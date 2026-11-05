# GRI Website Change Report

## Report Date: 2026-11-05

## Overview

This report documents the changes made to the Gandhigram Rural Institute
official website content as part of the GRI mobile portal rebuild. All
data has been verified against https://www.ruraluniv.ac.in/ and stored
locally in the `data/official/` directory.

## Data Extraction Summary

| Activity | Details |
|----------|---------|
| Canonical Extractor | `data/tools/extract_official.py` (deterministic) |
| Live HTML Snapshots | 53 pages captured in `data/official/raw/` |
| Unique Faculty | 118 (deduplicated by `data-fid`) |
| Units (Departments/Centres) | 33 |
| Programmes (Catalogue) | 38 |
| Official Notices | 40 (24 circular + 21 student) |
| Gallery Photos | 28 |
| YouTube Videos | 4 |
| Document Records | 480 |

## Key Content Changes (vs. Previous Seed Data)

### Removed / Replaced

| Legacy Item | Replacement |
|-------------|-------------|
| Fabricated schools (10+) | 8 verified schools from official Academics page |
| Invented fees/intake values | Removed; UI does not display unauthenticated data |
| Fake officer direct emails/phones | Replaced with `grucc@ruraluniv.ac.in` and `0451-2452371` |
| Fabricated prospectus content | Real prospectus link: https://www.ruraluniv.ac.in/page/academics |
| Fake scholarship amounts | Removed; no stable source published by GRI |
| Invented centre contacts | Replaced with official unit profiles only |
| Legacy `assets/website_inventory.json` | Replaced by canonical JSON in `data/official/canonical/` |
| Legacy `assets/data/gri_official_seed.json` | Retired; data merged into canonical payload |
| Fabricated HOD emails (e.g. `hod.XXX@ruraluniv.ac.in`) | Replaced with general office contact only |
| Fake extension numbers (e.g. "Ext. 2140") | Removed; not published by GRI |

### Preserved (Working Architecture)

| Feature | Status |
|---------|--------|
| Navigation tabs / provider state | Preserved |
| Roll-call roster system | Preserved (local data store) |
| Sahayak AI chat flow | Preserved (knowledge engine) |
| Supabase / cloud sync flags | Preserved |
| User role switching (STUDENT/ADMIN) | Preserved |
| Attendance register workflow | Preserved |
| Grievance ticket workflow | Preserved |
| Transport route listings | Preserved |

### Added (Verified Data)

| Feature | Source |
|---------|--------|
| 118 faculty profiles with photos | Official academics/faculties pages |
| 33 unit/department/centre profiles | Official academics page mapping |
| 38 programme catalogue entries | Official academics page |
| 40 official notices (circular + student) | /notices/circular and /notices/student |
| 28 gallery photographs | Official gallery page |
| 4 official YouTube videos | Official video gallery page |
| 9 deans with photos and designations | Official administration page |
| 13 leaders (executive officers) | Official administration page |
| Document URLs with HTTP status & SHA-256 | validate_and_download.py output |
| Syllabus links per unit | Official unit/admission pages |

### URL Policy (robots.txt Compliance)

- `/uploads/docs/` — **Disallowed**: kept as link-only, never downloaded
- `/page/*` — Allowed: all academics, administration, notices pages crawled
- Faculty profile images: Allowed (direct file paths in `/files/`)
- Gallery images: Allowed
- YouTube videos: Allowed (embedded links)

### Six 404 School Landing URLs

Six of the original school landing URLs return 404. School containers
assembled from verified mappings between the Academics page and Administration
page:

| School ID | School Name | Mapped From |
|-----------|-------------|-------------|
| `sch_tamil` | School of Tamil, Indian Languages and Rural Arts | Academics + Administration |
| `sch_english` | School of English & Foreign Languages | Academics + Administration |
| `sch_sciences` | School of Sciences & Rural Technology | Academics + Administration |
| `sch_management` | School of Management | Academics + Administration |
| `sch_cst` | School of Computer Science & Technologies | Academics + Administration |
| `sch_agri` | School of Agriculture & Rural Innovation | Academics + Administration |
| `sch_hsrd` | School of Health Sciences & Rural Development | Academics + Administration |
| `sch_stw` | School of Social Work | Academics + Administration |

(DDU-KK treated as separate vocational container)

## Archive & Git Decisions

- `data/official/files/` (420 MB PDF archive) — Git-excluded; kept locally
- `data/official/media/` — Committed (assets collectively < 25 MB)
- `data/official/raw/` — Committed (53 HTML snapshots, ~4 MB)
- `data/official/canonical/` — Committed (canonical JSON + manifests, ~1.5 MB)
- `.gitignore` updated to exclude `.crawl_home.html` and the large archive

## Change Methodology

1. **Extractor**: `data/tools/extract_official.py` deterministically pulls
   data from live pages, producing canonical JSON.
2. **Validator**: `data/tools/validate_and_download.py` validates document
   URLs (HEAD) and downloads valid PDFs/media respecting robots.txt.
3. **Canonical Payload**: Single source of truth in
   `data/official/canonical/official_data.json`.
4. **App Integration**: Services (`OfficialCatalogService`, `OfficialWebSyncService`)
   read from the canonical payload; no synthetic data invented.

## Conclusion

The rebuild replaces all fabricated or stale data with verified content
from https://www.ruraluniv.ac.in/. The app now operates exclusively against
the canonical dataset, ensuring accuracy, offline capability, and
compliance with the university's robots.txt and access policies.