# GRI Official Website — Complete Content Discovery, Data Acquisition & Technical Planning Repository

## 1. Executive Summary & Purpose
This directory (`data/`) contains the complete, authoritative, and verified discovery records, content extracts, media manifests, technical architecture proposals, and development roadmaps for **The Gandhigram Rural Institute (Deemed to be University)** official website ([https://ruraluniv.ac.in/home](https://ruraluniv.ac.in/home)).

In accordance with strict project guidelines, this phase is **DISCOVERY + COLLECTION + VERIFICATION + PLANNING ONLY**:
- **Application Code Integrity**: Zero modification, deletion, or refactoring of existing Flutter source files (`lib/`), Android configurations (`android/`), or testing suites (`test/`).
- **Complete Provenance**: Every record maps to its original institutional URL on `ruraluniv.ac.in` with timestamps, HTTP status codes, and SHA-256 checksums where applicable.
- **Evidence-Based Models**: All proposed database entities, sitemaps, and architecture diagrams reflect live institutional workflows verified via automated web crawlers and Chromium browser automation.

---

## 2. Directory Hierarchy Guide

| Directory | Purpose & Key Contents |
| :--- | :--- |
| [`00_repository_audit/`](file:///d:/current%20project/gri/data/00_repository_audit/REPOSITORY_AUDIT.md) | Baseline environment, Git commit audit (`ed9a49d`), tooling, and previous inventory cross-verification. |
| [`01_discovery/`](file:///d:/current%20project/gri/data/01_discovery/WEBSITE_DISCOVERY_REPORT.md) | Comprehensive web crawl analysis, navigation menus, query parameter patterns, and URL normalization. |
| [`02_page_inventory/`](file:///d:/current%20project/gri/data/02_page_inventory/) | Machine-readable catalogs: `all_pages.csv`, `all_pages.jsonl`, and `module_inventory.csv`. |
| [`03_page_content/`](file:///d:/current%20project/gri/data/03_page_content/) | Extracted clean page assets across `html/`, `clean_text/` (Markdown), and `structured_json/`. |
| [`04_assets/`](file:///d:/current%20project/gri/data/04_assets/) | Physical files organized into `images/`, `videos/`, `documents/pdf/`, `documents/office/`, `audio/`, and `other/`. |
| [`05_metadata/`](file:///d:/current%20project/gri/data/05_metadata/) | Global asset catalogs (`assets_manifest.csv`, `assets_manifest.jsonl`) and `collection_summary.json`. |
| [`06_relationships/`](file:///d:/current%20project/gri/data/06_relationships/PAGE_ASSET_RELATIONSHIPS.csv) | Full bipartite graph linking web pages to embedded documents and media (`8,102` mapped pairs). |
| [`07_architecture/`](file:///d:/current%20project/gri/data/07_architecture/) | Proposed technical architectures: `SYSTEM_ARCHITECTURE.md`, `DATA_FLOW.md`, `ERD_AND_DATA_MODEL.md`, `FLUTTER_STRUCTURE_PROPOSAL.md`, and `DATABASE_AND_MEDIA_STORAGE_COMPARISON.md`. |
| [`08_diagrams/`](file:///d:/current%20project/gri/data/08_diagrams/) | 10 editable Mermaid architectural diagrams (`.mmd`). |
| [`09_development_plan/`](file:///d:/current%20project/gri/data/09_development_plan/) | Prioritized 8-phase implementation roadmap (`DEVELOPMENT_ROADMAP.md`) and `WEBSITE_TO_APP_MAPPING.csv`. |
| [`10_quality_assurance/`](file:///d:/current%20project/gri/data/10_quality_assurance/) | Coverage matrices, `BROKEN_LINKS.csv`, `MISSING_OR_UNAVAILABLE_ASSETS.csv`, `DUPLICATE_ASSETS.csv`, and `CONTENT_GAP_ANALYSIS.md`. |
| [`11_logs/`](file:///d:/current%20project/gri/data/11_logs/collection.log) | Timestamped execution log of crawler and extraction steps. |
| [`12_exceptions/`](file:///d:/current%20project/gri/data/12_exceptions/ACCESS_LIMITATIONS.md) | Documented perimeter boundaries, intranet restrictions, and third-party portal redirections. |

---

## 3. High-Level Collection Metrics

- **Discovered Web Pages**: **250**
- **Publicly Accessible & Verified Pages**: **247** (98.8% accessibility rate)
- **Inaccessible / Deprecated Pages**: **3** (recorded with HTTP status in exception logs)
- **Cataloged Assets**: **1,047** (PDF prospectuses, circulars, syllabi, logos, leadership portraits)
- **Locally Downloaded & Verified Assets**: **24** high-priority institutional binaries
- **Remote Cataloged Assets**: **1,020** stream-verified URLs
- **Page-to-Asset Bipartite Relationships**: **8,102**
- **Discovered Institutional Modules**: **14**

---

## 4. How to Rerun or Resume Collection
To update or regenerate the dataset manifests after website updates:
```powershell
# Run the dataset pipeline script
python "C:\Users\vijay\.gemini\antigravity-ide\brain\89ab01ad-8b10-4e63-b7e0-4e945f526124\scratch\generate_gri_dataset.py"
```

## 5. Known Limitations
1. **Campus LAN Intranet Assets**: 3 documents point to internal university IPs (e.g., `http://10.10.12.48/opac-tmpl/...`) which are unreachable from the public Internet.
2. **Dynamic Server Query Navigation**: The website utilizes legacy PHP query parameters (`?content=...`). All 247+ sub-routes have been normalized and cataloged.
