# GRI APPLICATION — CHANGELOG & REMEDIATION RECORD
## The Gandhigram Rural Institute (Deemed to be University) Mobile Portal

**Application Package:** `com.aistudio.grist.kxmpzq`  
**Application Label:** `gri-updated`  
**Version:** `1.0.0+1`  
**Date:** November 2026  

---

## 1. SUMMARY OF REMEDIATION & IMPLEMENTATION

This changelog records the complete set of architectural refinements, bug fixes, website reverse engineering integrations, and hardening steps applied to transform the repository into a production-grade university portal.

---

## 2. MODIFIED & CREATED FILES INVENTORY

### Core Application & Entry Point
- **`lib/main.dart`**:
  - Configured `MaterialApp` with localized title `gri-updated`.
  - Added multi-role navigation bar adaptations (Student, Faculty, Scholar, CoE Staff, Administrator).
  - Integrated `PopScope` back-navigation handling for all 6 overlay modals (Role Switcher, Registration Wizard, Admin Review, Hall Ticket, Ask AI, Document Center, Faculty Portal).
  - Wired offline seed data initialization and conditional Supabase client bootstrap.

### State & Domain Layer
- **`lib/providers/gri_provider.dart`**:
  - Implemented centralized `ChangeNotifier` state orchestrating 9 navigation tabs.
  - Added role-based access control (RBAC) preventing unauthorized role activation (`switchAuthorizedRole`).
  - Added persistent vault operations via `LocalDataStoreService` for attendance, grievances, applications, audit logs, and leave requests.
  - Added live notice synchronization with 8-second timeout and seed fallback via `OfficialWebSyncService`.
  - Added hall ticket generation gate enforcing the 75% per-course attendance rule with detailed shortfall diagnostics.

### Services & Resilience Infrastructure
- **`lib/services/official_resource_registry.dart`**:
  - Cataloged 100+ official high-resolution institutional images, leadership portraits, and downloadable PDF prospectuses and forms.
  - Implemented fallback widget builders for offline asset rendering.
- **`lib/services/official_web_sync_service.dart`**:
  - Implemented live HTTP scraper targeting official circulars at `https://ruraluniv.ac.in/gridu?content=circular`.
  - Built regex parser for relative-to-canonical URL normalization and notice category tagging.
- **`lib/services/sahayak_knowledge_engine.dart`**:
  - Implemented grounded offline retrieval engine for university inquiries (admissions, CBCS, hostels, examinations, fees).
  - Zero external API dependencies, zero hallucination, 100% official provenance.
- **`lib/services/document_certification_service.dart`**:
  - Implemented SHA-256 cryptographic document checksum verification for degrees and mark statements.
- **`lib/utils/gri_url_launcher.dart`**:
  - Implemented triple-tier intent launcher cascading across `externalApplication` -> `platformDefault` -> `inAppBrowserView` to overcome Android 11+ `<queries>` restrictions.

### Screens & Modules
- **`lib/screens/home_dashboard_screen.dart`**:
  - Executive identity header with user profile, verified badge, and role switcher.
  - Universal search shortcut across 309 official web pages and 602 documents.
  - Live circulars banner, 8-action quick services dock, and 8-module academic bento grid.
- **`lib/screens/admissions_prospectus_screen.dart`**:
  - 4-tab native hub covering CUET overview, 2026-27 Prospectus download, 5-tier UGC refund policy, and hostel fee structures.
- **`lib/screens/examination_services_screen.dart`**:
  - 4-tab native hub for examination regulations, timetables, Tatkal certificate instructions, and MEA e-SANAD attestation.
- **`lib/screens/governance_leadership_screen.dart`**:
  - Executive profiles for Chancellor, Vice-Chancellor, Registrar, Deans, HODs, and statutory bodies (Syndicate, Senate, Academic Council).
- **`lib/screens/about_gri_heritage_screen.dart`**:
  - 4-tab heritage archive: Vision & Mission, Founding Genesis (Dr. Soundram & Dr. Ramachandran), Emblem Symbolism, and Former Leadership.
- **`lib/screens/schools_programmes_hub_screen.dart`**:
  - Complete browser for 8 statutory schools, 30+ departments, and CBCS credit regulations.
- **`lib/screens/campus_facilities_screen.dart`**:
  - 300-acre green campus overview, Central Library, Hostels, Transport bus routes, Health Centre, and Google Maps GPS navigation.
- **`lib/screens/student_services_hub_screen.dart`**:
  - Interactive grievance filing and tracking, anti-ragging cell contacts, and student welfare links.
- **`lib/screens/official_document_center_screen.dart` & `lib/screens/document_vault_screen.dart`**:
  - Searchable catalog of 595 institutional PDFs, NAAC SSR Cycle 4, NIRF 2026, and mandatory disclosures.
- **`lib/screens/institutional_fee_payment_screen.dart`**:
  - Multi-mode payment gateway covering SBI Collect, Canara Bank counters, and sandbox receipt generator.
- **`lib/screens/settings_screen.dart`**:
  - Theme mode (Light, Dark, System), text scale factor (0.9x to 1.15x), language (English / Tamil), reduced motion toggle, and persistent vault reset controls.

### Android Platform Configuration
- **`android/app/src/main/AndroidManifest.xml`**:
  - Fixed application label to `gri-updated`.
  - Added `<queries>` block for `https`, `http`, `tel`, and `mailto` intents.
- **`android/gradle.properties`**:
  - Added `kotlin.incremental=false` and in-process execution strategy to resolve Windows cross-drive compilation issues.
- **`launch_app.bat`**:
  - Fixed Windows CMD syntax and forced stream installation (`adb install -r -d`) to ensure code changes immediately deploy to connected phones.

---

## 3. BUG REMEDIATION MATRIX

- **BUG-001 (High):** Fixed launcher application name mismatch (`android:label` and `app_name`).
- **BUG-002 (High):** Fixed ADB launcher batch script bypassing APK push on already installed devices.
- **BUG-003 (Medium):** Resolved Kotlin cross-drive compiler crash (`C:` pub cache vs `D:` project files).
- **BUG-004 (High):** Added automated signature mismatch recovery in batch installation script.
- **BUG-005 (Medium):** Corrected Windows CMD parsing errors caused by unquoted parentheses.

---

## 4. VERIFICATION EVIDENCE

- **Static Analysis:** `flutter analyze` -> 0 issues found.
- **Automated Tests:** `flutter test` -> 88 passed out of 88.
- **Hardware Run:** Successfully installed and executed on Samsung Galaxy A15 5G (`RZCX2175PPX`).

