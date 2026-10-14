# Phase A — Repository and Environment Inspection Report

## 1. Repository Status & Environment Metadata
- **Repository Root**: `D:\current project\gri`
- **Active Git Branch**: `main`
- **Latest Commit**: [`ed9a49d`](https://github.com/vijaymahes9080/gri_android_stdio_structure/commit/ed9a49d) (`fix(ui): resolve overflow issues and stabilize modal rendering across core modules`)
- **Remote Synchronization**: Synchronized with `origin/main` and `vijay/main` at `https://github.com/vijaymahes9080/gri_android_stdio_structure.git`
- **Working Tree**: Completely clean (0 uncommitted files, 0 untracked files)
- **Runtime Tooling**:
  - Python: `3.11.9`
  - Flutter SDK: `3.38.5` (Dart `3.8.1`)
  - Android SDK Platform-Tools (ADB): Installed at `C:\Users\vijay\AppData\Local\Android\Sdk\platform-tools\adb.exe`
  - Connected Target Hardware: **Samsung Galaxy A15 5G** (`RZCX2175PPX`) on Android 16 (API 36)
  - Browser Automation: Chromium engine with active page recording

---

## 2. Existing Application Architecture & Entry Points

### 2.1 Core Source Hierarchy (`lib/`)
The existing application follows a clean Flutter structure:
- **Application Entry Point**: [`lib/main.dart`](file:///d:/current%20project/gri/lib/main.dart)
  - Initializes `GriProvider` via `MultiProvider`.
  - Sets up `MainScaffold` with adaptive navigation bar (`Home`, `Academics`, `Campus`, `Services`, `More`).
  - Manages modal overlays (`RoleSwitcherModal`, `HallTicketModal`, `RegistrationWizardModal`, `AdminReviewModal`, `AskGriAiScreen`).
- **Core State Management**: [`lib/providers/gri_provider.dart`](file:///d:/current%20project/gri/lib/providers/gri_provider.dart)
  - Manages active user role (`STUDENT`, `FACULTY`, `ADMIN`, `COE_STAFF`, `SCHOLAR`, `GUEST`).
  - Controls offline state, synchronization triggers, and institutional seed data loading.
- **Screen Implementations** (`lib/screens/`):
  - `home_dashboard_screen.dart`: Central portal index, live notices, quick service dock, and institutional statistics.
  - `academics_hub_screen.dart`: Programmes, CBCS regulations, semester syllabus lists, and examination schedules.
  - `campus_facilities_screen.dart`: 300-acre campus interactive map, GPS coordinates, facility dossiers, and contact hotlines.
  - `student_services_hub_screen.dart`: Grievance redressal, bus passes, and hostel management.
  - `admin_directory_screen.dart`: Executive leadership contacts, governance terminal, and Supabase cloud sync status.
  - `application_status_screen.dart`: Student admission verification workflow and clarification resolution.
  - `official_document_center_screen.dart`: Universal document search and in-app viewing.
- **Data Models** (`lib/models/`):
  - `academic_models.dart`, `facility_models.dart`, `portal_item.dart`, `grievance_item.dart`.

### 2.2 Existing Assets & Inventories
The repository previously contained:
1. `assets/website_inventory.json` (37,406 lines, 1.56 MB): Machine-readable catalog from an initial crawl of 250 URLs.
2. `audit_reports/`:
   - `DOCUMENT_INVENTORY.csv`: 595 cataloged PDFs with source URLs and MIME types.
   - `IMAGE_INVENTORY.csv`: 2,535 cataloged image assets.
   - `WEBSITE_TO_FLUTTER_MAPPING.csv`: Screen destination mappings for 247 official URLs.
   - `WEBSITE_DISCOVERY_MASTER.md`: Master documentation of web routes.
3. `assets/official/`: 7 verified institutional PDFs and 10 leadership/crest images already bundled with the app.

---

## 3. Tooling & Automation Assessment

| Capability | Available Tool | Verified Behavior |
| :--- | :--- | :--- |
| **HTTP Request Extraction** | `read_url_content` | Successfully fetched live homepage (`https://ruraluniv.ac.in/home`) in 46 seconds. |
| **Browser Automation** | `browser_subagent` | Executed live Chromium session, expanded nested menu trees, observed DOM mutations, recorded WebP. |
| **ADB Hardware Control** | `adb` via PowerShell | Successfully pushed and verified APK on Samsung Galaxy A15 5G (`RZCX2175PPX`). |
| **Data Scripting** | Python 3.11.9 | Fast parsing of JSON, CSV, file hashing, and manifest generation. |

---

## 4. Preservation & Non-Interference Verification
- **Application Files**: Unchanged. `git status` verifies that no files in `lib/`, `android/`, `test/`, or `pubspec.yaml` have been altered.
- **Output Isolation**: All discovery, extraction, metadata, and planning files are housed in `data/`, which is ignored or tracked cleanly as instructed.
