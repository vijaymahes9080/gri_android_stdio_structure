#!/usr/bin/env python3
"""Validate every official document URL, then download valid PDFs and all media.

Respects robots.txt: files under /uploads/docs/ are never requested; they are
kept as links only.  Downloads are resumable (existing file + recorded size is
skipped) and every record receives a SHA-256 in the manifest.
"""
from __future__ import annotations

import hashlib
import json
import mimetypes
import os
import re
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import unquote, urlparse

import requests

PROJECT = Path(__file__).resolve().parents[2]
OUT = PROJECT / "data" / "official"
CANON = OUT / "canonical"
MEDIA = OUT / "media"
FILES = OUT / "files"
MANIFESTS = OUT / "manifests"
NOW = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
UA = "GRI-Official-Portal/2.0 (+https://www.ruraluniv.ac.in/; contact: grucc@ruraluniv.ac.in)"
HEADERS = {"User-Agent": UA, "Accept": "application/pdf,image/*,*/*;q=0.8"}
LOCK = threading.Lock()
SESSION = requests.Session()
SESSION.headers.update(HEADERS)
TIMEOUT = 45
WORKERS = 6


def safe_name(value: str, limit: int = 80) -> str:
    value = unquote(value or "file")
    value = re.sub(r"[^A-Za-z0-9._-]+", "_", value)
    value = value.strip("._") or "file"
    if len(value) > limit:
        stem, dot, ext = value.rpartition(".")
        if not dot:
            stem, ext = value, ""
        value = stem[: limit - len(ext) - 1] + "." + ext
    return value


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def probe(url: str) -> dict:
    """HEAD with a ranged GET fallback; never touch robots-disallowed paths."""
    if "/uploads/docs/" in url:
        return {"status": None, "content_type": "", "bytes": 0, "note": "robots-disallowed; link only"}
    for attempt in range(3):
        try:
            r = SESSION.head(url, timeout=TIMEOUT, allow_redirects=True)
            if r.status_code in (403, 405, 501):
                r = SESSION.get(url, timeout=TIMEOUT, stream=True, headers={"Range": "bytes=0-0"})
                r.close()
            ctype = (r.headers.get("content-type") or "").split(";")[0].strip().lower()
            size = int(r.headers.get("content-length") or 0)
            return {"status": r.status_code, "content_type": ctype, "bytes": size, "final_url": r.url}
        except Exception as exc:  # retry transient failures
            if attempt == 2:
                return {"status": None, "content_type": "", "bytes": 0, "error": str(exc)[:200]}
            time.sleep(1.5 * (attempt + 1))
    return {"status": None, "content_type": "", "bytes": 0}


def download(url: str, dest: Path) -> dict:
    if "/uploads/docs/" in url:
        return {"ok": False, "note": "robots-disallowed; link only"}
    if dest.exists() and dest.stat().st_size > 1000:
        return {"ok": True, "bytes": dest.stat().st_size, "sha256": sha256(dest), "skipped": True}
    dest.parent.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_suffix(dest.suffix + ".part")
    for attempt in range(3):
        try:
            with SESSION.get(url, timeout=TIMEOUT, stream=True, allow_redirects=True) as r:
                if r.status_code != 200:
                    raise RuntimeError(f"HTTP {r.status_code}")
                ctype = (r.headers.get("content-type") or "").split(";")[0].strip().lower()
                if "pdf" not in ctype and "image" not in ctype and "octet-stream" not in ctype:
                    raise RuntimeError(f"unexpected content-type {ctype}")
                with tmp.open("wb") as fh:
                    for chunk in r.iter_content(1024 * 256):
                        if chunk:
                            fh.write(chunk)
            if tmp.stat().st_size < 1000:
                raise RuntimeError("file too small")
            if dest.exists():
                dest.unlink()
            tmp.replace(dest)
            return {"ok": True, "bytes": dest.stat().st_size, "sha256": sha256(dest), "content_type": ctype}
        except Exception as exc:
            tmp.unlink(missing_ok=True)
            if attempt == 2:
                return {"ok": False, "error": str(exc)[:200]}
            time.sleep(1.5 * (attempt + 1))
    return {"ok": False, "error": "unknown"}


DOC_DIRS = {
    "faculty-profile": "faculty-profiles",
    "syllabus": "syllabi",
    "prospectus": "prospectus",
    "regulation": "regulations",
    "admissions": "admissions",
    "examination": "examination",
    "student-corner": "student-corner",
    "form": "forms",
    "official-document": "official-documents",
}


def document_destination(doc: dict) -> Path:
    folder = DOC_DIRS.get(doc["category"], "official-documents")
    base = safe_name(doc.get("filename") or "document.pdf")
    if doc["category"] == "faculty-profile":
        key = doc.get("faculty_id") or doc["id"].replace("doc_profile_", "")
        base = safe_name(str(key)) + "__" + base
    elif doc["category"] == "syllabus":
        base = doc["id"].replace("doc_", "")[:10] + "__" + base
    else:
        if len(base) < 8:
            base = doc["id"].replace("doc_", "")[:10] + "__" + base
    return FILES / folder / base


def run_validations(documents: list[dict]) -> list[dict]:
    todo = [d for d in documents if d.get("http_status") is None]
    print(f"[validate] {len(todo)} unchecked of {len(documents)}", flush=True)
    done = 0
    with ThreadPoolExecutor(max_workers=WORKERS) as pool:
        futures = {pool.submit(probe, d["url"]): d for d in todo}
        for fut in as_completed(futures):
            d = futures[fut]
            info = fut.result()
            d["http_status"] = info.get("status")
            d["content_type"] = info.get("content_type") or d.get("content_type") or ""
            if info.get("bytes"):
                d["bytes"] = info["bytes"]
            d["valid"] = bool(info.get("status") == 200 and "pdf" in (info.get("content_type") or ""))
            if info.get("note"):
                d["download_note"] = info["note"]
            if info.get("error"):
                d["validation_error"] = info["error"]
            done += 1
            if done % 50 == 0:
                print(f"[validate] {done}/{len(todo)}", flush=True)
    return documents


def download_documents(documents: list[dict]) -> list[dict]:
    todo = [d for d in documents if d.get("valid") and d.get("download_allowed", True)]
    print(f"[documents] {len(todo)} to download", flush=True)
    done = 0
    with ThreadPoolExecutor(max_workers=WORKERS) as pool:
        futures = {pool.submit(download, d["url"], document_destination(d)): d for d in todo}
        for fut in as_completed(futures):
            d = futures[fut]
            dest = document_destination(d)
            info = fut.result()
            if info.get("ok"):
                d["local_path"] = dest.relative_to(OUT).as_posix()
                d["bytes"] = info.get("bytes", d.get("bytes", 0))
                d["sha256"] = info.get("sha256", "")
                d["downloaded_at"] = NOW
                d["download_status"] = "cached" if info.get("skipped") else "downloaded"
            else:
                d["download_status"] = "failed"
                d["download_error"] = info.get("error") or info.get("note", "")
            done += 1
            if done % 40 == 0:
                print(f"[documents] {done}/{len(todo)}", flush=True)
    return documents


def media_tasks(data: dict) -> list[tuple[str, str, Path]]:
    tasks: list[tuple[str, str, Path]] = []
    for f in data["faculty"]:
        if f.get("photo_url"):
            key = f.get("fid") or f["id"].replace("fac_", "")
            tasks.append(("faculty", f"{safe_name(key)}.jpg", None, f))
    # rebuild with explicit URL field
    tasks = []
    for f in data["faculty"]:
        if f.get("photo_url"):
            key = f.get("fid") or f["id"].replace("fac_", "")
            tasks.append((f["photo_url"], f"faculty/{safe_name(key)}.jpg", f))
    for i, leader in enumerate(data["leadership"]):
        if leader.get("photo_url"):
            tasks.append((leader["photo_url"], f"leadership/{safe_name(leader['id'])}.jpg", leader))
    for unit in data["units"]:
        if unit.get("profile_photo_url"):
            tasks.append((unit["profile_photo_url"], f"units/{safe_name(unit['id'])}__profile.jpg", unit))
        for idx, img in enumerate(unit.get("images", [])):
            url = img.get("url", "")
            if not url or url == unit.get("profile_photo_url"):
                continue
            ext = (urlparse(url).path.rsplit(".", 1)[-1] or "jpg").lower()
            if ext not in ("jpg", "jpeg", "png", "webp"):
                ext = "jpg"
            tasks.append((url, f"units/{safe_name(unit['id'])}__{idx:02d}.{ext}", img))
    for photo in data["media"]["photos"]:
        tasks.append((photo["full_url"], f"gallery/{photo['number']:02d}.jpg", photo))
        if photo.get("thumb_url"):
            tasks.append((photo["thumb_url"], f"gallery/thumbs/{photo['number']:02d}.webp", photo))
    for video in data["media"]["videos"]:
        tasks.append((video["thumbnail_url"], f"videos/{safe_name(video['youtube_id'])}.jpg", video))
    return tasks


def download_media(data: dict) -> tuple[dict, list[dict]]:
    tasks = media_tasks(data)
    manifest: dict[str, dict] = {}
    failures = []
    print(f"[media] {len(tasks)} files", flush=True)
    with ThreadPoolExecutor(max_workers=WORKERS) as pool:
        futures = {pool.submit(download, url, MEDIA / rel): (url, rel, record) for url, rel, record in tasks}
        done = 0
        for fut in as_completed(futures):
            url, rel, record = futures[fut]
            info = fut.result()
            if info.get("ok"):
                entry = {
                    "url": url,
                    "local_path": (MEDIA / rel).relative_to(OUT).as_posix(),
                    "bytes": info.get("bytes"),
                    "sha256": info.get("sha256"),
                    "downloaded_at": NOW,
                }
                manifest[url] = entry
                if isinstance(record, dict):
                    # attach the local asset path to the canonical record
                    if record.get("photo_url") == url:
                        record["photo_asset"] = entry["local_path"]
                    elif record.get("profile_photo_url") == url:
                        record["profile_photo_asset"] = entry["local_path"]
                    elif record.get("full_url") == url:
                        record["asset_path"] = entry["local_path"]
                    elif record.get("thumb_url") == url:
                        record["thumb_asset_path"] = entry["local_path"]
                    elif record.get("thumbnail_url") == url:
                        record["thumbnail_asset_path"] = entry["local_path"]
                    elif record.get("url") == url:
                        record["asset_path"] = entry["local_path"]
            else:
                failures.append({"url": url, "error": info.get("error") or info.get("note")})
            done += 1
            if done % 40 == 0:
                print(f"[media] {done}/{len(tasks)}", flush=True)
    return manifest, failures


def write_json(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def main() -> None:
    for d in (FILES, MEDIA, MANIFESTS):
        d.mkdir(parents=True, exist_ok=True)
    data = json.loads((CANON / "official_data.json").read_text(encoding="utf-8"))
    documents = data["documents"]
    documents = run_validations(documents)
    data["documents"] = documents
    data["counts"]["documents_valid"] = sum(1 for d in documents if d.get("valid"))
    documents = download_documents(documents)
    data["documents"] = documents

    media_manifest, media_failures = download_media(data)

    # refresh counts and write canonical payloads
    data["counts"]["documents_cached"] = sum(1 for d in documents if d.get("local_path"))
    data["counts"]["media_cached"] = len(media_manifest)
    write_json(CANON / "official_data.json", data)
    write_json(CANON / "documents.json", documents)
    write_json(CANON / "faculty.json", data["faculty"])
    write_json(CANON / "leadership.json", data["leadership"])
    write_json(CANON / "units.json", data["units"])
    write_json(CANON / "media.json", data["media"])

    doc_manifest = []
    for d in documents:
        doc_manifest.append({
            "id": d.get("id"),
            "title": d.get("title"),
            "category": d.get("category"),
            "url": d.get("url"),
            "local_path": d.get("local_path", ""),
            "bytes": d.get("bytes", 0),
            "sha256": d.get("sha256", ""),
            "http_status": d.get("http_status"),
            "valid": d.get("valid", False),
            "download_status": d.get("download_status", "not-downloaded"),
            "download_allowed": d.get("download_allowed", True),
            "source_url": d.get("source_url"),
        })
    write_json(MANIFESTS / "document_manifest.json", doc_manifest)
    write_json(MANIFESTS / "media_manifest.json", list(media_manifest.values()))
    write_json(MANIFESTS / "failures.json", {"documents": [d for d in documents if d.get("download_status") == "failed"], "media": media_failures})

    summary = {
        "generated_at": NOW,
        "documents_total": len(documents),
        "documents_valid": sum(1 for d in documents if d.get("valid")),
        "documents_cached": sum(1 for d in documents if d.get("local_path")),
        "documents_bytes": sum(d.get("bytes", 0) for d in documents if d.get("local_path")),
        "media_cached": len(media_manifest),
        "media_bytes": sum(m.get("bytes", 0) for m in media_manifest.values()),
        "galleries": len(data["media"]["photos"]),
        "videos": len(data["media"]["videos"]),
        "faculty": len(data["faculty"]),
    }
    write_json(MANIFESTS / "sync_summary.json", summary)
    print(json.dumps(summary, indent=2), flush=True)


if __name__ == "__main__":
    main()
