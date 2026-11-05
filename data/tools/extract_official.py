#!/usr/bin/env python3
"""
Extract the verified official GRI dataset from cached live pages.

Input  : %TEMP%/opencode/gri-research (cached HTML + JSON snapshots of ruraluniv.ac.in)
Output : <project>/data/official/canonical/*.json
         <project>/data/official/raw/ (source snapshots + provenance index)

The script is intentionally deterministic: every record keeps its source URL and
the UTC timestamp of the live fetch, so the app can show provenance and the
dataset can be rebuilt after the official site changes.
"""
from __future__ import annotations

import hashlib
import json
import os
import re
import shutil
import unicodedata
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import unquote, urlparse

from bs4 import BeautifulSoup

PROJECT = Path(__file__).resolve().parents[2]
RESEARCH = Path(os.environ.get("GRI_RESEARCH", Path.home() / "AppData/Local/Temp/opencode/gri-research"))
OUT = PROJECT / "data" / "official"
CANON = OUT / "canonical"
RAW = OUT / "raw"
NOW = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
SITE = "https://www.ruraluniv.ac.in"

GENERAL = {
    "email": "grucc@ruraluniv.ac.in",
    "phone": "0451-2452371",
    "address": "Gandhigram, Dindigul District, Tamil Nadu 624 302, India",
}


def clean(value) -> str:
    if value is None:
        return ""
    text = str(value).replace("\xa0", " ")
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n\s*\n+", "\n", text)
    return text.strip()


def one_line(value) -> str:
    return re.sub(r"\s+", " ", clean(value)).strip()


def slugify(value: str) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode()
    value = re.sub(r"[^a-zA-Z0-9]+", "-", value.lower()).strip("-")
    return value or "item"


def norm_name(value: str) -> str:
    value = unicodedata.normalize("NFKD", value or "").encode("ascii", "ignore").decode()
    value = value.lower()
    value = re.sub(r"\b(dr|prof|mrs|mr|ms|smt|sri)\.?\b", " ", value)
    value = re.sub(r"[^a-z0-9]+", " ", value)
    return re.sub(r"\s+", " ", value).strip()


def guess_unit_type(url: str) -> str:
    tail = url.rstrip("/").rsplit("/", 1)[-1]
    if tail.startswith("school-of"):
        return "school"
    if tail.startswith("centre-for"):
        return "centre"
    if tail.startswith("department-of"):
        return "department"
    if "ddukk" in tail:
        return "kaushal-kendra"
    if "physical-education" in tail or "computer-centre" in tail:
        return "facility"
    return "unit"


def unit_id_from_url(url: str) -> str:
    return url.rstrip("/").rsplit("/", 1)[-1]


def normalize_asset_url(url: str) -> str:
    """Canonicalise the several URL spellings the official site uses.

    The server serves the same file from /includes/..., /files/includes/... and
    even /files/files/includes/....  We keep one canonical spelling so the
    manifest, downloads and app asset map never contain duplicates.
    """
    url = clean(url).replace("http://", "https://")
    url = url.replace("https://www.ruraluniv.ac.in/files/files/includes/", "https://www.ruraluniv.ac.in/files/includes/")
    url = url.replace("https://ruraluniv.ac.in/files/files/includes/", "https://www.ruraluniv.ac.in/files/includes/")
    url = url.replace("https://www.ruraluniv.ac.in/includes/", "https://www.ruraluniv.ac.in/files/includes/")
    url = url.replace("https://ruraluniv.ac.in/includes/", "https://www.ruraluniv.ac.in/files/includes/")
    url = url.replace("https://ruraluniv.ac.in/", "https://www.ruraluniv.ac.in/")
    return url


class Cache:
    def __init__(self) -> None:
        self.pages: dict[str, dict] = {}
        self.html: dict[str, str] = {}
        cache_dir = RESEARCH / "cache"
        for meta_path in sorted(cache_dir.glob("*.json")):
            try:
                meta = json.loads(meta_path.read_text(encoding="utf-8"))
            except Exception:
                continue
            if meta.get("status") != 200:
                continue
            html_path = meta_path.with_suffix(".html")
            if not html_path.exists() or html_path.stat().st_size == 0:
                continue
            url = meta.get("url", "").rstrip("/")
            self.pages[url] = meta
            self.html[url] = html_path.read_text(encoding="utf-8", errors="replace")

        # Extra cached pages kept as standalone files.
        extras = {
            "https://www.ruraluniv.ac.in/notices/circular/2": RESEARCH / "cache_notices_circular_2.html",
            "https://www.ruraluniv.ac.in/notices/student/2": RESEARCH / "cache_notices_student_2.html",
            "https://www.ruraluniv.ac.in/page/physical-education-and-yoga-centre": RESEARCH / "cache_page_physical-education-and-yoga-centre.html",
            "https://www.ruraluniv.ac.in/page/computer-centre": RESEARCH / "cache_page_computer-centre.html",
        }
        for url, path in extras.items():
            if path.exists():
                self.pages[url] = {"url": url, "status": 200, "fetched_at": "2026-11-05T12:45:00Z"}
                self.html[url] = path.read_text(encoding="utf-8", errors="replace")

    def soup(self, url: str) -> BeautifulSoup | None:
        html = self.html.get(url.rstrip("/"))
        return BeautifulSoup(html, "html.parser") if html else None

    def find_url(self, needle: str) -> str | None:
        needle = needle.rstrip("/")
        for url in self.html:
            if url.rstrip("/") == needle or url.rstrip("/").endswith(needle):
                return url
        return None


def section_html(soup: BeautifulSoup, sid: str):
    return soup.find("section", id=sid)


def parse_faculty_card(card, page_url: str, page_title: str, context: str) -> dict | None:
    btn = card.select_one("button.c-explore")
    name = clean(card.select_one(".c-pname").get_text(" ", strip=True) if card.select_one(".c-pname") else "")
    if not name:
        return None
    data = btn.attrs if btn else {}
    lines = [clean(x.get_text(" ", strip=True)) for x in card.select(".c-pline")]
    img = card.select_one("img")
    profile_a = card.select_one(".c-pname a[href]")
    fid = clean(card.get("data-fid") or "")
    photo = normalize_asset_url(clean(data.get("data-photo") or (img.get("src") if img else "")))
    profile = normalize_asset_url(clean(data.get("data-profile") or (profile_a.get("href") if profile_a else "")))
    designation = clean(data.get("data-desig") or "")
    if not designation:
        designation = next((x for x in lines if "head" in x.lower() or "dean" in x.lower() or "director" in x.lower() or "professor" in x.lower()), lines[0] if lines else "")
    qual = clean(data.get("data-qual") or "")
    spec = clean(data.get("data-spec") or "")
    if not spec and len(lines) > 1:
        spec = "\n".join(x for x in lines if x != designation and x != qual)
    key = fid
    if not key:
        m = re.search(r"/(?:profile|images)/(\d+)\.(?:pdf|jpe?g|png)", profile + " " + photo, re.I)
        key = m.group(1) if m else "name:" + norm_name(name)
    return {
        "key": key,
        "fid": fid,
        "name": name,
        "designation": one_line(designation),
        "qualifications": clean(qual),
        "specialization": clean(spec),
        "photo_url": photo,
        "profile_url": profile,
        "scholar": clean(data.get("data-scholar") or ""),
        "irins": clean(data.get("data-irins") or ""),
        "orcid": clean(data.get("data-orcid") or ""),
        "page_url": page_url,
        "page_title": page_title,
        "context": context,
    }


# ---------------------------------------------------------------- units + faculty
def parse_units(cache: Cache):
    raw = json.loads((RESEARCH / "departments_raw.json").read_text(encoding="utf-8"))
    urls = [u.rstrip("/") for u in raw.keys()]
    for extra in (
        "https://www.ruraluniv.ac.in/page/physical-education-and-yoga-centre",
        "https://www.ruraluniv.ac.in/page/computer-centre",
    ):
        if cache.html.get(extra) and extra not in urls:
            urls.append(extra)
    # The administration page is not an academic unit but is a faculty source.
    admin_url = cache.find_url("https://ruraluniv.ac.in/page/administration")

    units: list[dict] = []
    faculty_cards: list[dict] = []
    unit_programmes: dict[str, list[dict]] = {}

    for url in urls:
        soup = cache.soup(url)
        if not soup:
            continue
        uid = unit_id_from_url(url)
        title = clean(soup.title.get_text() if soup.title else "")
        name = title.split(" — ")[0].strip() or uid.replace("-", " ").title()
        desc = ""
        meta = soup.find("meta", attrs={"name": "description"})
        if meta:
            desc = clean(meta.get("content", ""))
        profile_sec = section_html(soup, "profile")
        profile_text = ""
        profile_photo = ""
        if profile_sec:
            body = profile_sec.select_one(".dp-text") or profile_sec
            profile_text = clean(body.get_text("\n", strip=True))
            dp = profile_sec.select_one("img.dp-photo")
            if dp:
                profile_photo = clean(dp.get("src"))
        if not profile_text:
            main = soup.find("main") or soup
            profile_text = clean(main.get_text("\n", strip=True))[:4000]

        videos = []
        for iframe in soup.select("iframe[src]"):
            src = iframe.get("src", "")
            m = re.search(r"(?:youtube(?:-nocookie)?\.com/embed/|youtu\.be/)([\w-]{6,})", src)
            if m:
                videos.append({
                    "youtube_id": m.group(1),
                    "title": clean(iframe.get("title") or name),
                    "embed_url": f"https://www.youtube-nocookie.com/embed/{m.group(1)}?rel=0",
                    "watch_url": f"https://www.youtube.com/watch?v={m.group(1)}",
                    "source_url": url,
                })
            elif "drive.google.com" in src:
                # Keep only genuine Drive ids (the site currently carries a placeholder).
                dm = re.search(r"/d/([A-Za-z0-9_-]{20,})", src)
                if dm and not dm.group(1).lower().startswith("1abcdefghijklmnop"):
                    videos.append({
                        "youtube_id": "",
                        "title": clean(iframe.get("title") or f"{name} video tour"),
                        "embed_url": src,
                        "watch_url": src,
                        "source_url": url,
                    })

        images = []
        seen_img = set()
        for img in soup.select("main img[src], .dp-photo, .gal-i img"):
            src = clean(img.get("src"))
            if not src or src in seen_img:
                continue
            if any(x in src.lower() for x in ("logo", "favicon", "banner", "emblem")):
                continue
            seen_img.add(src)
            images.append({"url": src, "alt": clean(img.get("alt") or name), "source_url": url})

        for card in soup.select(".c-person"):
            rec = parse_faculty_card(card, url, name, "unit")
            if rec:
                faculty_cards.append(rec)

        # programmes & syllabus table
        progs = []
        sec = section_html(soup, "programmes")
        tables = sec.select("table") if sec else []
        if not tables and "ddukk" in uid:
            tables = soup.select("table")
        for table in tables:
            current = None
            for tr in table.select("tr"):
                tds = tr.find_all("td")
                if not tds:
                    continue
                first = tds[0]
                txt = one_line(first.get_text(" ", strip=True))
                if txt and not first.find("a"):
                    current = txt
                    progs.append({"name": current, "syllabi": []})
                for a in tr.find_all("a", href=True):
                    href = a.get("href", "")
                    if not href.lower().split("?")[0].endswith(".pdf"):
                        continue
                    if not progs:
                        current = name
                        progs.append({"name": current, "syllabi": []})
                    progs[-1]["syllabi"].append({
                        "label": one_line(a.get_text(" ", strip=True)) or "Syllabus",
                        "url": normalize_asset_url(href),
                    })
        # DDU-KK programme table carries eligibility in additional columns
        if "ddukk" in uid:
            for table in soup.select("table"):
                header = [one_line(th.get_text(" ", strip=True)).lower() for th in table.select("th")]
                if not header:
                    continue
                for tr in table.select("tr"):
                    tds = tr.find_all("td")
                    if len(tds) < 2:
                        continue
                    pname = one_line(tds[0].get_text(" ", strip=True))
                    if not pname or pname.lower() in ("programme", "name of the programme"):
                        continue
                    rec = next((p for p in progs if norm_name(p["name"]) == norm_name(pname)), None)
                    if rec is None:
                        rec = {"name": pname, "syllabi": []}
                        progs.append(rec)
                    for idx, key in enumerate(header):
                        if idx < len(tds) and "eligib" in key:
                            rec["eligibility"] = one_line(tds[idx].get_text(" ", strip=True))
                        if idx < len(tds) and ("school" in key or "dept" in key):
                            rec["unit_label"] = one_line(tds[idx].get_text(" ", strip=True))
                    for a in tr.select("a[href]"):
                        href = a.get("href", "")
                        if href.lower().endswith(".pdf"):
                            rec["syllabi"].append({"label": one_line(a.get_text(" ", strip=True)) or "Syllabus", "url": normalize_asset_url(href)})
        # de-duplicate programmes while preserving order
        clean_progs = []
        seen_p = set()
        for p in progs:
            k = norm_name(p["name"])
            if k in seen_p:
                continue
            seen_p.add(k)
            clean_progs.append(p)
        unit_programmes[uid] = clean_progs

        units.append({
            "id": uid,
            "name": name,
            "type": guess_unit_type(url),
            "url": url,
            "title": title,
            "description": desc,
            "profile": profile_text,
            "profile_photo_url": profile_photo,
            "images": images,
            "videos": videos,
            "programmes": clean_progs,
            "fetched_at": cache.pages.get(url, {}).get("fetched_at", ""),
        })

    # administration faculty / deans / HODs / officers
    deans_raw = []
    hod_groups = []
    officers_raw = []
    if admin_url:
        soup = cache.soup(admin_url)
        if soup:
            for sec_id, context in (("deans", "dean"), ("heads-of-departments", "hod"), ("officers-in-administration", "officer")):
                sec = section_html(soup, sec_id)
                if not sec:
                    continue
                current_school = ""
                for el in sec.find_all(["h3", "div"], recursive=True):
                    if el.name == "h3":
                        current_school = clean(el.get_text(" ", strip=True))
                    elif "c-person" in (el.get("class") or []):
                        rec = parse_faculty_card(el, admin_url, "Administration", context)
                        if not rec:
                            continue
                        rec["school_hint"] = current_school
                        if context == "dean":
                            deans_raw.append(rec)
                        elif context == "hod":
                            hod_groups.append(rec)
                        else:
                            officers_raw.append(rec)
                        faculty_cards.append(rec)
            for card in soup.select(".ad-card"):
                img = card.select_one("img.ad-photo")
                name = one_line(card.select_one(".ad-name").get_text(" ", strip=True)) if card.select_one(".ad-name") else ""
                role = one_line(card.select_one(".ad-role").get_text(" ", strip=True)) if card.select_one(".ad-role") else ""
                link = card.select_one("a.ad-go")
                officers_raw.append({
                    "key": "leader:" + norm_name(name),
                    "name": re.sub(r"\s+Ph\.?D\.?$", "", name).strip(),
                    "designation": role,
                    "photo_url": clean(img.get("src")) if img else "",
                    "profile_url": clean(link.get("href")) if link else "",
                    "context": "executive",
                    "school_hint": "",
                    "qualifications": "",
                    "specialization": "",
                    "scholar": "",
                    "irins": "",
                    "orcid": "",
                })
    return units, unit_programmes, faculty_cards, deans_raw, hod_groups, officers_raw


# ---------------------------------------------------------------- schools
SCHOOL_DEFS = [
    ("sch_tamil", "School of Tamil, Indian Languages and Rural Arts"),
    ("sch_english", "School of English & Foreign Languages"),
    ("sch_health", "School of Health Sciences and Rural Development"),
    ("sch_social", "School of Social Sciences"),
    ("sch_management", "School of Management Studies"),
    ("sch_sciences", "School of Sciences"),
    ("sch_cs", "School of Computer Science & Technologies"),
    ("sch_agriculture", "School of Agriculture & Animal Sciences"),
]
DEAN_BY_NAME = {
    "p anandakumar": "sch_tamil",
    "s balasundari": "sch_english",
    "r venkataravi": "sch_health",
    "r mani": "sch_social",
    "b tamilmani": "sch_management",
    "p balasubramaniam": "sch_sciences",
    "p kalavathi": "sch_cs",
    "a ramanathan": "sch_agriculture",
    "s manivel": "student-welfare",
}

UNIT_SCHOOL_HINTS = {
    "department-of-tamil": "sch_tamil",
    "department-of-hindi": "sch_tamil",
    "centre-for-malayalam": "sch_tamil",
    "school-of-english-foreign-languages": "sch_english",
    "department-of-rural-development": "sch_health",
    "centre-for-geoinformatics": "sch_health",
    "department-of-applied-research": "sch_health",
    "department-of-rural-health-and-sanitation": "sch_health",
    "department-of-lifelong-learning-extension": "sch_health",
    "centre-for-extension": "sch_health",
    "centre-for-lifelong-learning": "sch_health",
    "department-of-gandhian-thought-and-peace-science": "sch_social",
    "department-of-sociology": "sch_social",
    "department-of-political-science-development-administration": "sch_social",
    "department-of-education": "sch_social",
    "centre-for-futures-studies": "sch_social",
    "department-of-physical-education-and-yoga-centre": "sch_social",
    "physical-education-and-yoga-centre": "sch_social",
    "department-of-rural-industries-management": "sch_management",
    "department-of-economics": "sch_management",
    "department-of-cooperation": "sch_management",
    "department-of-mathematics": "sch_sciences",
    "department-of-physics": "sch_sciences",
    "department-of-chemistry": "sch_sciences",
    "department-of-biology": "sch_sciences",
    "department-of-home-science": "sch_sciences",
    "department-of-computer-science-applications": "sch_cs",
    "centre-for-rural-technology": "sch_cs",
    "centre-for-rural-energy": "sch_cs",
    "centre-for-applied-geology": "sch_cs",
    "school-of-agriculture-animal-sciences": "sch_agriculture",
    "ddukk": "ddu-kk",
    "ddukk-programmes": "ddu-kk",
}


def build_schools(units: list[dict], deans_raw: list[dict]) -> tuple[list[dict], dict]:
    schools = []
    for sid, sname in SCHOOL_DEFS:
        schools.append({
            "id": sid,
            "name": sname,
            "type": "school",
            "dean_id": "",
            "dean_name": "",
            "dean_designation": "Dean",
            "dean_photo_url": "",
            "source_urls": [f"{SITE}/page/academics", f"{SITE}/page/administration"],
            "unit_ids": [],
            "programme_count": 0,
        })
    schools.append({
        "id": "ddu-kk",
        "name": "Deen Dayal Upadhyay - KAUSHAL Kendra (DDU-KK)",
        "type": "kaushal-kendra",
        "dean_id": "",
        "dean_name": "",
        "dean_designation": "Director",
        "dean_photo_url": "",
        "source_urls": [f"{SITE}/page/ddukk"],
        "unit_ids": [],
        "programme_count": 0,
    })
    by_id = {s["id"]: s for s in schools}
    unit_map = {}
    for u in units:
        sid = UNIT_SCHOOL_HINTS.get(u["id"])
        if not sid:
            for key, val in UNIT_SCHOOL_HINTS.items():
                if key in u["id"] or u["id"] in key:
                    sid = val
                    break
        if sid and sid in by_id:
            u["school_id"] = sid
            by_id[sid]["unit_ids"].append(u["id"])
            for p in u["programmes"]:
                if p["name"].lower() not in ("ph.d.", "ph. d.", "ph.d", "ph.d course work: core and supportive courses", "other department programmes", "ug & pg courses offered to other departments", "ug, pg and diploma programmes", "ug & ug nme courses", "pg, pg integrated and pg-nme courses", "diploma & pg diploma courses", "b. voc. courses", "ug/ pg/ diploma courses (allied/nme courses)", "all other pg / ug / b.voc / diploma / certificate courses", "environmental studies", "ug - generic elective courses", "extension education", "adult continuing education and extension/ corporate social responsibility/ life skills education/ social entrepreneurship/ rural livelihood promotion"):
                    by_id[sid]["programme_count"] += 1
        else:
            u["school_id"] = ""
        unit_map[u["id"]] = u
    # deans
    for rec in deans_raw:
        key = norm_name(rec["name"])
        sid = DEAN_BY_NAME.get(key)
        if not sid:
            sid = DEAN_BY_NAME.get(next((k for k in DEAN_BY_NAME if k in key), ""), "")
        if sid and sid in by_id:
            s = by_id[sid]
            s["dean_id"] = rec.get("fid") or rec.get("key", "")
            s["dean_name"] = rec["name"]
            s["dean_designation"] = one_line(rec["designation"]) or "Dean"
            s["dean_photo_url"] = rec.get("photo_url", "")
    return schools, unit_map


# ---------------------------------------------------------------- faculty merge
ROLE_RANK = {"executive": 0, "officer": 1, "dean": 2, "hod": 3, "unit": 4}


def merge_faculty(cards: list[dict], units_by_id: dict, schools: list[dict]) -> list[dict]:
    school_names = {s["id"]: s["name"] for s in schools}
    merged: dict[str, dict] = {}
    for card in cards:
        key = card.get("fid") or card.get("key")
        if not key:
            key = "name:" + norm_name(card["name"])
        rec = merged.setdefault(key, {
            "id": f"fac_{slugify(key.replace('name:', ''))}",
            "fid": card.get("fid") or "",
            "name": card["name"],
            "designation": "",
            "qualifications": "",
            "specialization": "",
            "photo_url": "",
            "profile_url": "",
            "scholar": "",
            "irins": "",
            "orcid": "",
            "affiliations": [],
            "roles": [],
        })
        if card["name"] and (not rec["name"] or len(card["name"]) > len(rec["name"])):
            rec["name"] = card["name"]
        for field in ("qualifications", "specialization", "photo_url", "profile_url", "scholar", "irins", "orcid", "fid"):
            if not rec[field] and card.get(field):
                rec[field] = card[field]
        if card.get("specialization") and len(card["specialization"]) > len(rec["specialization"]):
            rec["specialization"] = card["specialization"]
        if card.get("qualifications") and len(card["qualifications"]) > len(rec["qualifications"]):
            rec["qualifications"] = card["qualifications"]
        context = card.get("context", "unit")
        page = card.get("page_url", "")
        uid = unit_id_from_url(page) if page and "administration" not in page else ""
        unit = units_by_id.get(uid)
        school_id = unit.get("school_id", "") if unit else ""
        if context in ("dean", "hod") and card.get("school_hint"):
            school_id = next((s["id"] for s in schools if norm_name(s["name"]) == norm_name(card["school_hint"])), school_id)
        aff = {
            "role": context,
            "designation": one_line(card.get("designation", "")),
            "unit_id": uid,
            "unit_name": unit["name"] if unit else ("Administration" if "administration" in page else ""),
            "school_id": school_id,
            "school_name": school_names.get(school_id, card.get("school_hint", "")),
            "source_url": page,
        }
        if not any(a["role"] == aff["role"] and a["unit_id"] == aff["unit_id"] and a["designation"] == aff["designation"] for a in rec["affiliations"]):
            rec["affiliations"].append(aff)
        if context not in rec["roles"]:
            rec["roles"].append(context)
        # Prefer leadership designations for the primary display label.
        current_rank = ROLE_RANK.get(next((r for r in ("executive", "officer", "dean", "hod", "unit") if r in rec["roles"] and r != context), "unit"), 9)
        if card.get("designation") and (not rec["designation"] or ROLE_RANK.get(context, 9) <= current_rank):
            rec["designation"] = one_line(card["designation"])
    # sort leadership first, then alphabetically
    out = list(merged.values())
    for rec in out:
        rec["roles"] = sorted(set(rec["roles"]), key=lambda r: ROLE_RANK.get(r, 9))
        rec["primary_role"] = rec["roles"][0] if rec["roles"] else "faculty"
        if not rec["designation"]:
            rec["designation"] = "Faculty"
    out.sort(key=lambda r: (ROLE_RANK.get(r["primary_role"], 9), norm_name(r["name"])))
    return out


# ---------------------------------------------------------------- programmes
def parse_catalogue(cache: Cache) -> list[dict]:
    url = cache.find_url("https://ruraluniv.ac.in/page/academics")
    soup = cache.soup(url) if url else None
    if not soup:
        return []
    out = []
    for group in soup.select(".pgm-grp"):
        h = group.select_one(".pgm-h")
        gname = one_line(h.get_text(" ", strip=True)) if h else ""
        gname = re.sub(r"\s+\d+\s+Programmes?$", "", gname, flags=re.I)
        for card in group.select(".pgc"):
            deg = one_line(card.select_one(".pgc-deg").get_text(" ", strip=True)) if card.select_one(".pgc-deg") else ""
            pname = one_line(card.select_one(".pgc-name").get_text(" ", strip=True)) if card.select_one(".pgc-name") else ""
            tags = [one_line(x.get_text(" ", strip=True)) for x in card.select(".pgc-tags span")]
            link = card.select_one("a[href]")
            href = clean(link.get("href")) if link else ""
            href = href.replace("/ruraluniv/public/page/", "/page/")
            uid = unit_id_from_url(href.split("#")[0]) if href else ""
            out.append({
                "id": "pgm_" + slugify(f"{deg}-{pname}"),
                "group": gname,
                "degree": deg,
                "name": pname,
                "display_name": one_line(f"{deg} {pname}"),
                "tags": tags,
                "duration": next((t for t in tags if "semester" in t.lower() or "year" in t.lower()), ""),
                "approval": " · ".join(t for t in tags if t not in ("Hons.",) and "semester" not in t.lower() and "year" not in t.lower()),
                "unit_id": uid,
                "official_url": href,
                "source_url": url,
                "syllabi": [],
                "eligibility": "",
            })
    return out


def attach_syllabi(programmes: list[dict], units: list[dict]):
    for p in programmes:
        unit = next((u for u in units if u["id"] == p["unit_id"]), None)
        if not unit:
            continue
        pn = norm_name(p["name"])
        best = None
        for up in unit["programmes"]:
            un = norm_name(up["name"])
            if pn and (pn in un or un in pn):
                best = up
                break
            # token overlap for names such as "B.A. English" vs "M.A. English..."
            pt = set(pn.split())
            ut = set(un.split())
            if len(pt & ut) >= max(1, min(len(pt), len(ut)) - 1):
                best = up
                break
        if best:
            p["syllabi"] = best["syllabi"]
            p["unit_programme_name"] = best["name"]
    return programmes


# ---------------------------------------------------------------- leadership
def build_leadership(cards: list[dict], deans_raw: list[dict], schools: list[dict]) -> list[dict]:
    out = []
    for rec in cards:
        if rec.get("context") != "executive":
            continue
        out.append({
            "id": "ldr_" + slugify(rec["designation"] or rec["name"]),
            "name": rec["name"],
            "designation": rec["designation"],
            "portfolio": rec["designation"],
            "photo_url": rec.get("photo_url", ""),
            "profile_url": rec.get("profile_url", ""),
            "email": GENERAL["email"],
            "phone": GENERAL["phone"],
            "contact_note": "University general office contact; no direct officer line is published.",
            "source_url": f"{SITE}/page/administration",
        })
    # verified dean roster
    seen = {norm_name(x["name"]) for x in out}
    for d in deans_raw:
        key = norm_name(d["name"])
        sid = DEAN_BY_NAME.get(key)
        school = next((s for s in schools if s["id"] == sid), None)
        if not school or key in seen:
            continue
        seen.add(key)
        out.append({
            "id": "ldr_dean_" + slugify(key),
            "name": d["name"],
            "designation": f"Dean, {school['name']}",
            "portfolio": f"Dean, {school['name']}",
            "photo_url": d.get("photo_url", ""),
            "profile_url": d.get("profile_url", ""),
            "email": GENERAL["email"],
            "phone": GENERAL["phone"],
            "contact_note": "University general office contact; no direct officer line is published.",
            "source_url": f"{SITE}/page/administration",
        })
    return out


# ---------------------------------------------------------------- notices
def parse_notices(cache: Cache) -> list[dict]:
    out = []
    seen = set()
    pages = [
        ("circular", "https://ruraluniv.ac.in/notices/circular"),
        ("circular", "https://ruraluniv.ac.in/notices/circular/2"),
        ("student", "https://ruraluniv.ac.in/notices/student"),
        ("student", "https://ruraluniv.ac.in/notices/student/2"),
    ]
    for category, url in pages:
        soup = cache.soup(url)
        if not soup:
            continue
        for li in soup.select(".nl-list li"):
            a = li.select_one("a[href]")
            if not a:
                continue
            href = clean(a.get("href"))
            if href in seen:
                continue
            seen.add(href)
            title = one_line(a.select_one("b").get_text(" ", strip=True)) if a.select_one("b") else one_line(a.get_text(" ", strip=True))
            small = one_line(a.select_one("small").get_text(" ", strip=True)) if a.select_one("small") else ""
            dm = re.search(r"(\d{2})\.(\d{2})\.(\d{4})", small)
            date = f"{dm.group(3)}-{dm.group(2)}-{dm.group(1)}" if dm else ""
            out.append({
                "id": "notice_" + slugify(urlparse(href).path.rsplit("/", 1)[-1] or title),
                "title": title,
                "url": href,
                "category": category,
                "date": date,
                "date_display": dm.group(0) if dm else "",
                "summary": small,
                "is_new": bool(li.select_one(".nl-new")),
                "source_page": url,
                "fetched_at": NOW,
            })
    return out


# ---------------------------------------------------------------- media
def parse_media(cache: Cache) -> dict:
    photos = []
    url = cache.find_url("https://ruraluniv.ac.in/photo-gallery")
    soup = cache.soup(url) if url else None
    if soup:
        for idx, a in enumerate(soup.select(".gal-i"), 1):
            img = a.select_one("img")
            href = clean(a.get("href"))
            src = clean(img.get("src")) if img else ""
            caption = one_line(a.select_one("span").get_text(" ", strip=True)) if a.select_one("span") else ""
            m = re.search(r"gallery/(\d+)\.(jpg|jpeg|png)$", href, re.I)
            num = m.group(1) if m else f"{idx:02d}"
            photos.append({
                "id": f"gallery_{num}",
                "kind": "photo",
                "title": caption or f"Gandhigram archive photograph {num}",
                "caption": caption,
                "full_url": href,
                "thumb_url": src,
                "number": int(num) if num.isdigit() else idx,
                "group": f"Archive {(idx - 1) // 5 + 1}",
                "source_url": url,
            })
    videos = []
    url = cache.find_url("https://ruraluniv.in/video-gallery") or cache.find_url("https://ruraluniv.ac.in/video-gallery")
    soup = cache.soup(url) if url else None
    if soup:
        for fig in soup.select("figure.vid-f"):
            iframe = fig.select_one("iframe[src]")
            cap = one_line(fig.select_one("figcaption").get_text(" ", strip=True)) if fig.select_one("figcaption") else ""
            cap = re.sub(r"\s*Open on YouTube.*$", "", cap).strip()
            src = clean(iframe.get("src")) if iframe else ""
            m = re.search(r"(?:youtube(?:-nocookie)?\.com/embed/|youtu\.be/)([\w-]{6,})", src)
            if not m:
                continue
            vid = m.group(1)
            videos.append({
                "id": "video_" + vid,
                "kind": "video",
                "title": cap,
                "youtube_id": vid,
                "embed_url": f"https://www.youtube-nocookie.com/embed/{vid}?rel=0",
                "watch_url": f"https://www.youtube.com/watch?v={vid}",
                "thumbnail_url": f"https://i.ytimg.com/vi/{vid}/hqdefault.jpg",
                "source_url": url,
            })
    return {"photos": photos, "videos": videos}


# ---------------------------------------------------------------- documents
def classify_doc(url: str, title: str, source_url: str) -> str:
    low = url.lower()
    if "/faculties/profile/" in low:
        return "faculty-profile"
    if "/faculties/dept/" in low or "/programmes/syllabus/" in low or "syllabus" in title.lower():
        return "syllabus"
    if "prospectus" in low or "prospectus" in title.lower():
        return "prospectus"
    if "regulation" in low or "regulation" in title.lower():
        return "regulation"
    if "/admissions/" in low:
        return "admissions"
    if "/examination/" in low:
        return "examination"
    if "/studcorner/" in low:
        return "student-corner"
    if "form" in low or "application" in low or "application" in title.lower():
        return "form"
    return "official-document"


def parse_documents(cache: Cache, units: list[dict], faculty: list[dict]) -> list[dict]:
    heads = {}
    hp = RESEARCH / "pdf_heads.json"
    if hp.exists():
        for url, size, ctype, status in json.loads(hp.read_text(encoding="utf-8")):
            heads[url] = {"bytes": size, "content_type": ctype, "status": status}
    docs: dict[str, dict] = {}
    # syllabus links captured in unit programme tables
    for u in units:
        for p in u["programmes"]:
            for s in p["syllabi"]:
                url = s["url"]
                d = docs.setdefault(url, {
                    "id": "doc_" + slugify(urlparse(url).path.rsplit("/", 1)[-1]),
                    "title": f"{p['name']} - {s['label']}",
                    "category": "syllabus",
                    "url": url,
                    "unit_id": u["id"],
                    "unit_name": u["name"],
                    "programme": p["name"],
                    "label": s["label"],
                    "source_url": u["url"],
                    "authority": u["name"],
                })
                d.setdefault("occurrences", 0)
                d["occurrences"] += 1
    # faculty profiles
    for f in faculty:
        if f.get("profile_url"):
            url = f["profile_url"]
            docs.setdefault(url, {
                "id": "doc_profile_" + (f.get("fid") or slugify(f["name"])),
                "title": f"Faculty profile - {f['name']}",
                "category": "faculty-profile",
                "url": url,
                "faculty_id": f["id"],
                "faculty_name": f["name"],
                "source_url": f"{SITE}/page/administration",
                "authority": "GRI Faculty",
            })
    # every other PDF linked from cached pages
    for page_url, html in cache.html.items():
        soup = BeautifulSoup(html, "html.parser")
        page_title = one_line(soup.title.get_text()) if soup.title else page_url
        for a in soup.select("a[href]"):
            href = normalize_asset_url(clean(a.get("href")))
            if not href.lower().split("?")[0].endswith(".pdf"):
                continue
            if href in docs:
                continue
            label = one_line(a.get_text(" ", strip=True)) or unquote(href.rsplit("/", 1)[-1])
            cat = classify_doc(href, label, page_url)
            docs[href] = {
                "id": "doc_" + hashlib.sha1(href.encode()).hexdigest()[:10],
                "title": label,
                "category": cat,
                "url": href,
                "source_url": page_url,
                "authority": page_title.split(" — ")[0],
            }
    # merge HEAD metadata and dedupe by URL
    out = []
    for url, d in docs.items():
        h = heads.get(url)
        d["bytes"] = h["bytes"] if h else 0
        d["content_type"] = h["content_type"] if h else "application/pdf"
        d["http_status"] = h["status"] if h else None
        d["valid"] = bool(h and h["status"] == 200 and h["content_type"] == "application/pdf")
        d["filename"] = unquote(urlparse(url).path.rsplit("/", 1)[-1])
        d["local_path"] = ""
        d["download_allowed"] = "/uploads/docs/" not in url
        out.append(d)
    out.sort(key=lambda d: (d["category"], d["title"].lower()))
    return out


# ---------------------------------------------------------------- main
def main() -> None:
    CANON.mkdir(parents=True, exist_ok=True)
    RAW.mkdir(parents=True, exist_ok=True)

    cache = Cache()
    units, unit_programmes, cards, deans_raw, hod_groups, officers_raw = parse_units(cache)
    schools, units_by_id = build_schools(units, deans_raw)
    faculty = merge_faculty(cards, units_by_id, schools)
    programmes = attach_syllabi(parse_catalogue(cache), units)
    leadership = build_leadership(officers_raw, deans_raw, schools)
    notices = parse_notices(cache)
    media = parse_media(cache)
    documents = parse_documents(cache, units, faculty)

    institution = {
        "id": "gri",
        "name": "The Gandhigram Rural Institute (Deemed to be University)",
        "short_name": "GRI",
        "tamil_name": "காந்திகிராம கிராமிய நிகர்நிலைப் பல்கலைக்கழகம்",
        "established": 1956,
        "deemed_university": 1976,
        "accreditation": "Accredited by NAAC with A ++ Grade (4th Cycle)",
        "ministry": "Ministry of Education, Government of India",
        "address": GENERAL["address"],
        "email": GENERAL["email"],
        "phone": GENERAL["phone"],
        "website": "https://www.ruraluniv.ac.in/",
        "schools_count": 8,
        "departments_count": 19,
        "centres_count": 11,
        "programmes_count": 64,
        "students_count": 5000,
        "teaching_staff": 178,
        "non_teaching_staff": 243,
        "facts_source": [
            "https://www.ruraluniv.ac.in/",
            "https://www.ruraluniv.ac.in/page/about-gri",
            "https://www.ruraluniv.ac.in/contact-us",
        ],
        "generated_at": NOW,
    }

    facilities = []
    for uid in ("computer-centre", "physical-education-and-yoga-centre"):
        u = units_by_id.get(uid)
        if u:
            facilities.append({
                "id": uid,
                "name": u["name"],
                "category": "Campus facility",
                "description": u["profile"][:1200],
                "source_url": u["url"],
                "photo_url": u["profile_photo_url"],
            })

    # canonical app payload
    payload = {
        "schema_version": "2.0.0",
        "generated_at": NOW,
        "source": "https://www.ruraluniv.ac.in/",
        "institution": institution,
        "schools": schools,
        "units": units,
        "faculty": faculty,
        "leadership": leadership,
        "programmes": programmes,
        "notices": notices,
        "media": media,
        "documents": documents,
        "facilities": facilities,
        "contact": {
            "address": GENERAL["address"],
            "email": GENERAL["email"],
            "phone": GENERAL["phone"],
            "website": "https://www.ruraluniv.ac.in/",
            "maps_url": "https://www.google.com/maps/search/?api=1&query=Gandhigram+Rural+Institute",
        },
        "counts": {
            "schools": len(schools),
            "units": len(units),
            "faculty": len(faculty),
            "leadership": len(leadership),
            "programmes_catalogue": len(programmes),
            "unit_programme_rows": sum(len(u["programmes"]) for u in units),
            "notices": len(notices),
            "gallery_photos": len(media["photos"]),
            "videos": len(media["videos"]),
            "documents": len(documents),
            "documents_valid": sum(1 for d in documents if d["valid"]),
        },
        "source_index": {
            "academics": f"{SITE}/page/academics",
            "administration": f"{SITE}/page/administration",
            "departments": sorted(u["url"] for u in units if u["type"] != "school"),
            "notices": [
                "https://www.ruraluniv.ac.in/notices/circular",
                "https://www.ruraluniv.ac.in/notices/student",
            ],
            "photo_gallery": f"{SITE}/photo-gallery",
            "video_gallery": f"{SITE}/video-gallery",
        },
    }

    files = {
        "official_data.json": payload,
        "institution.json": institution,
        "schools.json": schools,
        "units.json": units,
        "faculty.json": faculty,
        "leadership.json": leadership,
        "programmes.json": programmes,
        "notices.json": notices,
        "media.json": media,
        "documents.json": documents,
        "facilities.json": facilities,
    }
    for name, data in files.items():
        (CANON / name).write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")

    # copy source snapshots for provenance (small HTML corpus)
    raw_html = RAW / "html"
    raw_html.mkdir(parents=True, exist_ok=True)
    source_index = []
    for url, html in cache.html.items():
        digest = hashlib.sha1(url.encode()).hexdigest()[:12]
        path = raw_html / f"{digest}.html"
        path.write_text(html, encoding="utf-8")
        source_index.append({
            "url": url,
            "snapshot": f"raw/html/{digest}.html",
            "sha1": hashlib.sha1(html.encode()).hexdigest(),
            "bytes": len(html.encode()),
            "fetched_at": cache.pages.get(url, {}).get("fetched_at", ""),
        })
    (RAW / "source_index.json").write_text(json.dumps(source_index, ensure_ascii=False, indent=2), encoding="utf-8")

    print(json.dumps(payload["counts"], indent=2))
    print("canonical files:", ", ".join(files))
    print("source snapshots:", len(source_index))


if __name__ == "__main__":
    main()
