# GRI Data Sync Architecture

## Overview

The data pipeline for the GRI mobile portal follows a verified-official
first principle: all content is sourced from https://www.ruraluniv.ac.in/
and stored locally under `data/official/`. The app reads from a single
canonical dataset; no synthetic or fabricated data is generated at runtime.

## Directory Structure

```
data/official/
├── canonical/          # Committed to Git (canonical JSON + manifests)
│   ├── official_data.json    # Single app payload (~710 KB)
│   ├── documents.json        # 480 document records (~320 KB)
│   ├── faculty.json          # 118 faculty records (~130 KB)
│   ├── units.json            # 33 unit records (~140 KB)
│   ├── programmes.json       # 38 programme records (~40 KB)
│   ├── notices.json          # 40 notice records (~20 KB)
│   ├── media.json            # 28 photos + 4 videos (~10 KB)
│   ├── leadership.json       # 13 leader records (~10 KB)
│   ├── schools.json          # 8 school records (~10 KB)
│   ├── facilities.json       # Facility records
│   └── institution.json      # Institution facts
├── raw/                  # Committed (53 live-page HTML snapshots + index)
│   ├── 0fb493f12849.html
│   ├── 12a2441a6bd5.html
│   └── ... (51 more)
├── files/                # Git-excluded (420 MB PDF archive)
│   ├── syllabi/
│   ├── regulations/
│   ├── prospectus/
│   ├── forms/
│   └── ...
├── media/                # Committed (faculty photos, leadership photos,
│   # unit photos, gallery photos + thumbs, video thumbnails)
│   ├── faculty/            # 118 faculty portraits
│   ├── leadership/         # 13 leader portraits
│   ├── units/              # 33 unit profile photos
│   ├── gallery/            # 28 gallery JPGs + 28 thumb WebPs
   └── videos/              # 4 YouTube thumbnail JPEGs
├── manifests/            # Committed (sync results + metadata)
│   ├── document_manifest.json
│   ├── media_manifest.json
│   ├── failures.json
│   └── sync_summary.json
└── tools/                # Extractor / validator scripts
    ├── extract_official.py
    └── validate_and_download.py
```

## Data Flow

### 1. Extraction (Offline, one-time or on-demand)

- **Tool**: `data/tools/extract_official.py`
- **Process**:
  1. Crawl verified pages on https://www.ruraluniv.ac.in/
  2. Parse HTML for faculty, units, programmes, notices, gallery, videos
  3. Deduplicate faculty by `data-fid`/profile id
  4. Output: `data/official/canonical/official_data.json`
  5. Also output: 53 HTML snapshots in `data/official/raw/`
- **Frequency**: Initial extraction + re-run when site structure changes

### 2. Validation & Download (Offline, administrator-run)

- **Tool**: `data/tools/validate_and_download.py`
- **Process**:
  1. HEAD validation of all 480 document URLs
  2. Skip `/uploads/docs/` per robots.txt (link-only)
  3. Download valid PDFs to `data/official/files/` with id-prefix filenames
     (avoids collision: `29-bvoc-mm__29_BVoc_MMPT_2021.pdf`)
  4. Compute SHA-256 for each downloaded file
  5. Record `http_status`, `valid`, `local_path`, `bytes`, `sha256`
  6. Output manifests in `data/official/manifests/`
- **Status**: Pass 1 completed — 290/466 documents cached (412.7 MB);
  download paused at ~200/466 due to Windows file-lock; patched downloader
  resumes from background job `validate_and_download.py` writing
  `download2.log`.

### 3. Media Download (Offline, administrator-run)

- **Tool**: Same `validate_and_download.py` (shared `download_media` function)
- **Process**:
  1. Download faculty photos to `data/official/media/faculty/`
  2. Download leader photos to `data/official/media/leadership/`
  3. Download unit profile photos to `data/official/media/units/`
  4. Download gallery photos to `data/official/media/gallery/`
  5. Download thumbnail WebPs to `data/official/media/gallery/thumbs/`
  6. Download YouTube thumbnail JPEGs to `data/official/media/videos/`
  7. Attach local `photo_asset`/`profile_photo_asset`/`asset_path` to
     canonical records
- **Status**: In progress (background job from previous session).

### 4. App Runtime (Online or Offline)

- **Service**: `OfficialCatalogService.instance`
- **Load**: `ensureLoaded()` reads from `assetPath`
  (`data/official/canonical/official_data.json`)
- **Behavior**:
  - If network available → may call `syncOfficialWebsite()` to refresh
    from live site (optional, gated by `force` flag).
  - If offline → reads exclusively from cached canonical JSON.
  - No data is synthesised; empty/missing fields are hidden from UI.
- **Search**: `OfficialCatalogService.search(query, category: 'All')`
  performs full-text search across all canonical record types.

### 4b. Web Sync Service (Optional, on-demand)

- **Service**: `OfficialWebSyncService`
- **Responsibilities**:
  - Trigger `syncFull()` — validates + downloads + media in one pass
  - Provide `refreshCatalog()` — reload canonical data from disk
  - Provide `validateDocument(url)` — HEAD check (informational only;
    app uses cached `http_status` from manifest)
- **Runtime**: Runs on the development machine; not embedded in the
  Flutter APK (the APK only reads the canonical JSON).

## Canonical Payload (official_data.json) Schema

Key top-level fields:

| Field | Type | Description |
|-------|------|-------------|
| `institution` | `OfficialInstitution` | Fixed facts (established, accreditation, contact) |
| `schools` | `List<OfficialSchool>` | 8 schools with dean info + unit IDs |
| `units` | `List<OfficialUnit>` | 33 departments/centres/schools |
| `faculty` | `List<OfficialFaculty>` | 118 deduplicated faculty |
| `leadership` | `List<OfficialLeader>` | 13 executive officers |
| `programmes` | `List<OfficialProgramme>` | 38 catalogue entries |
| `notices` | `List<OfficialNotice>` | 40 (24 circular + 21 student) |
| `media.photos` | `List<OfficialPhoto>` | 28 gallery photos |
| `media.videos` | `List<OfficialVideo>` | 4 YouTube videos |
| `documents` | `List<OfficialDocument>` | 480 record entries |
| `facilities` | `List<OfficialFacility>` | Facility listings |
| `counts` | `Map<String, dynamic>` | Aggregated counts |

## Sync Summary (sample)

```json
{
  "documents_total": 480,
  "documents_valid": 398,
  "documents_cached": 290,
  "documents_bytes": 412700000,
  "media_cached": 118,
  "media_bytes": 52428800,
  "galleries": 28,
  "videos": 4,
  "faculty": 118
}
```

## Git Strategy

| Path | Git Status | Reason |
|------|-----------|--------|
| `data/official/canonical/` | **Committed** | Small JSON files; single source of truth |
| `data/official/raw/` | **Committed** | 53 HTML snapshots (~4 MB); audit trail |
| `data/official/media/` | **Committed** | Asset photos/Thumbnails (~< 25 MB) |
| `data/official/files/` | **Excluded** | 420 MB PDF archive; too large for Git |
| `data/official/manifests/` | **Committed** | Sync metadata for reproducibility |
| `data/tools/` | **Committed** | Python scripts for extraction/validation |
| `.gitignore` | **Updated** | Excludes `data/official/files/`, `data/official/media/`,
  `.crawl_home.html` (media dirs committed because small) |

## Offline Fallback

- The app **always** starts by reading from the canonical JSON.
- If the JSON is missing or corrupt, the UI shows a warning and
  falls back to no data (no synthetic data invented).
- The `OfficialCatalogService.ensureLoaded()` method handles the
  loading error state gracefully.
- Document URLs that have `local_path` filled in will work offline;
  URLs without a local path refer to the original source and require
  network access.

## Refresh Mechanisms

| Trigger | Action |
|---------|--------|
| `refreshAllData()` (provider) | Loads canonical data + calls `OfficialWebSyncService.syncFull()` |
| Pull-to-refresh (UI) | Calls `syncOfficialWebsite(force: true)` for heavy sync |
| Manual "Refresh" button | Calls `OfficialWebSyncService.refreshCatalog()` |
| App startup | `OfficialCatalogService.instance.ensureLoaded()` |

## Error Handling

- **Missing canonical JSON**: UI shows warning; no synthetic data.
- **Failed document download**: Record shows `download_status: 'failed'`
  with error note; UI displays "Official PDF" with source URL only.
- **Failed media download**: Record keeps the original URL; UI shows
  placeholder initials if photo unavailable.
- **Network timeout during sync**: Current operation aborts; previous
  cached state remains valid.
- **robots.txt disallow (/uploads/docs/)**: Document records have
  `download_note: 'robots-disallowed; link only'` and `valid: false`;
  UI shows as link-only.

## Future Extensions

- Incremental sync (only changed documents since last run).
- WebP automatic thumbnail generation for new images.
- YouTube playlist integration (beyond the 4 verified videos).
- OCR on downloaded syllabi for searchable text index.
- AJAX-powered refresh without full app restart.