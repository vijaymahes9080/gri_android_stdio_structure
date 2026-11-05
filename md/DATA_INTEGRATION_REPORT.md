# The Gandhigram Rural Institute (Deemed to be University)
## Data Integration & Technical Audit Report

**Authoritative Portal:** [https://ruraluniv.ac.in/](https://ruraluniv.ac.in/)  
**Target Codebase:** Flutter Android (`gri_app`, `com.aistudio.grist.kxmpzq`)  
**Phase Completed:** Phase 2 Data Inventory, Provenance Mapping & Integration Planning  

---

## 1. Technical Audit of Discovered Data Formats

### 1.1. Structured Data Files (JSON & CSV)
- **Files Inspected:**
  - `data/02_page_inventory/all_pages.csv`: 309 rows with full page IDs, URLs, and mapping categories.
  - `data/03_page_content/structured_json/*.json`: 285 detailed structured JSON files.
  - `data/05_metadata/assets_manifest.csv`: 1,047 assets cataloged with SHA hashes, mime types, and parent URLs.
  - `data/06_relationships/PAGE_ASSET_RELATIONSHIPS.csv`: 8,464 relational pairs.
  - `assets/website_inventory.json`: 1.56 MB JSON bundling page metadata, interactive features, and document links.
  - `assets/data/gri_official_seed.json`: 70 KB seed containing 8 statutory schools, 30+ academic departments, degree programmes, facilities, and contact points.
- **Integration Approach:**
  - Fully deserialized using safe null-aware Dart models (`SchoolModel`, `DepartmentModel`, `ProgrammeItem`, `FacilityItem`, `OfficialResource`).
  - Pre-cached on app startup through `SeedDataService.instance.loadSeedData()`.
  - Backed by fallback models in case of corrupt or incomplete asset records.

### 1.2. Markdown & Clean Text Content
- **Files Inspected:**
  - `data/03_page_content/clean_text/*.md`: 285 normalized Markdown files.
  - Formatted with YAML frontmatter containing metadata and clean markdown tables of all associated official documents.
- **Integration Approach:**
  - `InstitutionalArticleScreen` provides high-contrast, responsive presentation of institutional narratives.
  - Eliminates raw HTML tags, inline CSS, or script injections.
  - Supports bilingual content (English and Tamil unicode fonts via `Noto Sans Tamil` fallback).

### 1.3. Physical PDF Documents
- **Files Inspected:**
  - 7 official documents bundled in `04_assets/documents/pdf/` and `assets/official/documents/`:
    1. `GRI_Prospectus_2026-27.pdf`
    2. `COE_Form_Transcript_Application.pdf`
    3. `COE_Form_Duplicate_Certificate.pdf`
    4. `COE_Tatkal_Scheme_Instructions.pdf`
    5. `MEA_eSANAD_Attestation_Procedure.pdf`
    6. `UGC_PhD_Compliance_Certificate.pdf`
    7. `ICAR_KVK_Farm_Science_Brochure.pdf`
- **Integration Approach:**
  - Registered in `OfficialResourceRegistry` with local asset paths and canonical remote URLs.
  - `DocumentVaultScreen` and `OfficialDocumentCenterScreen` offer one-tap launch via `url_launcher`.
  - Non-bundled documents (595 in total) automatically resolve to canonical server URLs on `ruraluniv.ac.in` with user feedback.

### 1.4. Image and Media Assets
- **Files Inspected:**
  - 17 physical images in `data/04_assets/images/`, `assets/images/`, and `assets/official/images/`.
  - Video tour streams cataloged via verified streaming servers.
- **Integration Approach:**
  - Cached locally with resolution-independent vector icons and WebP/JPEG compression.
  - Safe image widget `OfficialResourceRegistry.buildImage()` with fallback shimmer and error icons.
  - `MediaGalleryScreen` provides dedicated video tour launch with official university branding.

---

## 2. Identified Integration Gaps & Remediation Actions

| Component / Screen | Existing State | Identified Gap | Remediation Action |
| :--- | :--- | :--- | :--- |
| **Universal Catalog Search** | Searches 250 bundled pages in `website_inventory.json` | 59 deep-crawled portal routes from `all_pages.csv` (total 309) need to be unified into the searchable catalog | Enrich `assets/website_inventory.json` to index all 309 pages with documents and clean summaries |
| **Institutional Article Screen** | Shows a static summary if not passed dynamically | When navigating from search or drawer, articles should render rich content and document links | Enhance `InstitutionalArticleScreen` to load page metadata, document lists, and clean text dynamically |
| **Document Vault Screen** | Displays static 10-item list | 595 cataloged PDFs across 8 institutional categories available in `assets_manifest.csv` | Wire `DocumentVaultScreen` to read the complete documents collection from `website_inventory.json` |
| **Department Detail Screen** | Renders template data for departments | Specific research areas, HOD names, and degree programmes should reflect actual GRI departments | Wire `DepartmentDetailScreen` with department data from `SeedDataService` and structured records |
| **Android Build Verification** | `flutter analyze` passed with 0 issues | Debug APK must be built and verified with Gradle wrapper | Completed `flutter build apk --debug` with success (55.9s) |

---

## 3. Build & Quality Verification Summary

| Check | Tool / Command | Result | Pass / Fail |
| :--- | :--- | :--- | :-: |
| Dart Static Analysis | `flutter analyze` | No issues found! (ran in 97.8s) | **PASS** |
| Automated Unit & Widget Tests | `flutter test` | All 25 tests passed (ran in 6.0s) | **PASS** |
| Android Gradle Build | `flutter build apk --debug` | Generated `app-debug.apk` (55.9s) | **PASS** |
| Asset Declarations | `pubspec.yaml` | All 8 asset paths declared | **PASS** |
| Data Completeness | Python Checksum & Walk | All 910 files intact in `data/` | **PASS** |
