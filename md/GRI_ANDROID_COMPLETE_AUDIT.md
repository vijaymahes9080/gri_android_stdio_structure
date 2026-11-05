# GRI ANDROID APPLICATION — COMPLETE AUDIT & REVERSE ENGINEERING REPORT
## The Gandhigram Rural Institute (Deemed to be University) Official Mobile Portal

**Application Package:** `com.aistudio.grist.kxmpzq`  
**Application Label:** `gri-updated`  
**Official Institution Domain:** `https://ruraluniv.ac.in`  
**Repository Branch:** `main` (`https://github.com/vijaymahes9080/gri_android_stdio_structure.git`)  
**Target Architecture:** Flutter 3.x / Dart >=3.5, Android SDK compileSdk 36, targetSdkVersion 36, minSdk 24  
**Physical Validation Device:** Samsung Galaxy A15 5G (`RZCX2175PPX`), Android 14/15, API 34+  
**Audit Date:** November 2026  
**Engineering Standards:** Production-Grade Clean Architecture, WCAG 2.2 AA Accessibility, Offline-First Vaulting  

---

## 1. EXECUTIVE SUMMARY

An exhaustive investigation and technical audit were conducted combining deep reverse engineering of the official university website ([https://ruraluniv.ac.in/home](https://ruraluniv.ac.in/home)) and a 360-degree code and security audit of the Android repository (`gri_android_stdio_structure`).

### Key Findings
1. **Repository Technology & Structure:** The active implementation is a production-grade Flutter application (`lib/`) using Material 3, `provider` state management, offline-first JSON vaulting (`shared_preferences`), optional Supabase cloud mirroring with Row Level Security (RLS), and a pre-bundled offline seed catalog (`assets/data/gri_official_seed.json`).
2. **Official Web Discovery:** 309 distinct routes and sub-routes on `ruraluniv.ac.in` were cataloged. Of these, 299 are publicly accessible and verified live, 7 are authenticated/intranet portals (e.g., Student ERP, Samarth, biometric attendance, LAN OPAC), and 3 are legacy deprecated routes.
3. **Parity & Screen Mapping:** 100% of the 15 discovered institutional modules have dedicated, mobile-optimized screens and workflows (18 dedicated screens, 6 specialized modal dialogs, and a universal search index covering all 309 URLs and 602 documents).
4. **Physical Device Verification:** The application was compiled into a release APK (`build/app/outputs/flutter-apk/app-release.apk`, 69.3 MB) and successfully installed and verified on a physical Samsung Galaxy A15 5G (`RZCX2175PPX`).
5. **Quality Assurance Gate:**
   - `flutter analyze`: **0 issues found** (clean lint and static analysis).
   - `flutter test`: **88/88 automated unit and widget tests passed** across all 5 test suites.

---

## 2. OFFICIAL WEBSITE REVERSE ENGINEERING (CATEGORIES A–H)

The official web presence of The Gandhigram Rural Institute utilizes an Apache HTTP infrastructure hosting legacy PHP endpoints with dynamic query-based navigation (`?content=...`). 

```mermaid
graph TD
    Root[Official Website: ruraluniv.ac.in] --> Mod1[Home & Quick Circulars]
    Root --> Mod2[University Heritage & Genesis]
    Root --> Mod3[Governance & Authorities]
    Root --> Mod4[Schools & Departments 8 Faculties]
    Root --> Mod5[Admissions 2026-27 & CUET]
    Root --> Mod6[Controller of Examinations COE]
    Root --> Mod7[Campus & Student Welfare]
    Root --> Mod8[Statutory Disclosures & NAAC SSR]
```

### Deep Reverse Engineering Breakdown:

#### Category A: Home & Portal Index
- **Official URLs:** `https://ruraluniv.ac.in/`, `https://ruraluniv.ac.in/home`
- **Discovered Content:** University logo crest, rotating hero banners, live notices and announcements ticker, Chancellor/Vice-Chancellor welcome excerpts, quick links to Samarth and CoE.
- **Mobile Adaptation:** Implemented in `lib/screens/home_dashboard_screen.dart` featuring an executive identity header, active role badge with dossier verification, live notice card synced via `OfficialWebSyncService` with graceful fallback, 8-module bento grid, and quick services dock.

#### Category B: University Information & Governance
- **Official URLs:** `aboutgri?content=vm`, `aboutgri?content=profile`, `aboutgri?content=GenesisofGRI`, `aboutgri?content=grilogo`, `administration?content=chancellor`, `administration?content=vc`, `administration?content=registrar`, `Governance?content=EC_CompositionFunctions`.
- **Discovered Content:** 1956 founding history by Dr. T.S. Soundram and Dr. G. Ramachandran; 1976 Deemed to be University conferral; 3-pillar philosophy (Teaching, Research, Extension); statutory authorities (Senate, Syndicate, Academic Council, Finance Committee).
- **Mobile Adaptation:** Implemented across `lib/screens/about_gri_heritage_screen.dart` (4-tab native heritage dossier) and `lib/screens/governance_leadership_screen.dart` (leadership directory with Chancellor, VC, Registrar, Deans, and statutory committee compositions).

#### Category C: Academic Information
- **Official URLs:** `academics?content=faculties`, `academics?content=CBCSsystem`, 30+ departmental sub-routes (`faculties?department=maths`, `agri`, `social`, etc.).
- **Discovered Content:** 8 statutory schools (Agriculture, Rural Development, Sciences, Health, Social Sciences, English & Foreign Languages, Management Studies, Educational Technology), 30+ departments, CBCS curriculum guidelines, Ph.D. regulations.
- **Mobile Adaptation:** Implemented in `lib/screens/schools_programmes_hub_screen.dart` and `lib/screens/department_detail_screen.dart` with faculty profiles, HOD contact intents, and research thrust areas.

#### Category D: Admissions
- **Official URLs:** `admissions?content=PhD_Regulations`, `admissions/2026/pdf/Prospectus_202627.pdf`, `admn1?content=Refund`.
- **Discovered Content:** CUET UG/PG Samarth application instructions, downloadable Prospectus 2026-27, 5-tier UGC fee refund policy, hostel fees structure.
- **Mobile Adaptation:** Implemented in `lib/screens/admissions_prospectus_screen.dart` with downloadable official prospectus PDF, fee breakdown, and live Samarth portal launcher.

#### Category E: Examination Services
- **Official URLs:** `examination?content=ExaminationSystem`, `includes/examination/pdf/Tatkal_instruction.pdf`, `Application_Transcript.pdf`, `DuplicateCertificate.pdf`, `e-sanad301221.pdf`.
- **Discovered Content:** Controller of Examinations (COE) rules, Tatkal fast-track certificate scheme, MEA e-SANAD attestation procedures, end-semester exam timetables.
- **Mobile Adaptation:** Implemented in `lib/screens/examination_services_screen.dart` and `lib/widgets/hall_ticket_modal.dart` with enforced 75% per-course attendance eligibility gate.

#### Category F: Student Services & Welfare
- **Official URLs:** `facilities?content=library`, `facilities?content=hostel`, `gridu?content=AntiRaggingCommittee`, `swayam_guidelines`.
- **Discovered Content:** Dr. Radhakrishnan Central Library, hostel accommodation guidelines, Anti-Ragging committee roster, post-matric and institutional scholarships.
- **Mobile Adaptation:** Implemented in `lib/screens/student_services_hub_screen.dart`, `lib/screens/scholarships_welfare_screen.dart`, and `lib/screens/campus_facilities_screen.dart` with interactive grievance submission and tracking.

#### Category G: Institutional Information & Accreditation
- **Official URLs:** `naac?content=ssr`, `nirf`, `mandatory_disclosures`, `tender`, `careers`.
- **Discovered Content:** NAAC Cycle 4 'A' grade accreditation certificate, NIRF 2026 submissions, mandatory disclosures, public tenders, faculty recruitment circulars.
- **Mobile Adaptation:** Implemented in `lib/screens/official_document_center_screen.dart` and `lib/screens/document_vault_screen.dart` with cryptographic document hash verification.

#### Category H: Digital Content & Utilities
- **Official URLs:** `contacts.php`, `gridu?content=location`, `facilities?content=videotour`, campus panoramic video.
- **Discovered Content:** EPABX telephone directory, campus transit guides (Madurai / Dindigul highway), geo-coordinates (`10.2798° N, 77.9333° E`), video tours.
- **Mobile Adaptation:** Implemented in `lib/screens/contact_campus_info_screen.dart`, `lib/screens/media_gallery_screen.dart`, `lib/screens/global_website_search_screen.dart`, and `lib/screens/ask_gri_ai_screen.dart` (GRI-Sahayak grounded retrieval engine).

---

## 3. TECHNICAL ARCHITECTURE AUDIT

### 3.1 Software Architecture Pattern
The project implements Clean Architecture and Feature-Driven Development:
- **Presentation Layer:** Flutter Material 3 widgets (`lib/screens/`, `lib/widgets/`) conforming to design system tokens (`GriColors`, `GriTypography`, `GriMetrics`, `GriMotion`).
- **State Management:** `GriProvider` (`lib/providers/gri_provider.dart`), an enterprise `ChangeNotifier` orchestrating tab navigation, multi-role dossier authorization, modal sheets, and data synchronization.
- **Persistence & Cloud Layer:**
  - On-Device: `LocalDataStoreService` (`lib/services/local_data_store_service.dart`) utilizing `shared_preferences` for instantaneous JSON vaulting of all user modifications (attendance, grievances, registration dossiers, audit trails).
  - Cloud Mirror: `SupabaseService` (`lib/services/supabase_service.dart`) providing asynchronous mirroring to Supabase with queueing (`pending_cloud_ops`).
- **Resilience & Fallback:** `OfficialWebSyncService` attempts live HTTP scraping with an 8-second timeout, falling back automatically to the verified institutional baseline (`assets/data/gri_official_seed.json`).
- **Offline Intelligence:** `SahayakKnowledgeEngine` executes grounded, deterministic FAQ and keyword retrieval without external ungrounded LLM dependencies or API costs.

---

## 4. SECURITY & PRIVACY AUDIT

1. **Android Permission Scoping:**
   - Manifest declares strictly `android.permission.INTERNET` and `android.permission.ACCESS_NETWORK_STATE`.
   - Zero dangerous runtime permissions (Camera, Location, Contacts, Microphone) requested unnecessarily.
2. **Intent & Package Visibility:**
   - Strict `<queries>` block declared in `AndroidManifest.xml` targeting `https`, `http`, `tel`, and `mailto` protocols conforming to Android 11+ (API 30+) requirements.
   - `GriUrlLauncher` implements triple-tier execution (`externalApplication` -> `platformDefault` -> `inAppBrowserView`) to avoid silent intent failures.
3. **Cloud Row Level Security (RLS):**
   - Supabase schema migrations (`supabase/migrations/20261028010000_hardened_rls.sql`) enforce closed-by-default policies: anonymous writes are blocked for circulars, attendance, and grievances.
4. **Secret Management:**
   - No hardcoded API keys or master database credentials exist in source code. Supabase credentials are provided strictly at compile-time via `--dart-define=SUPABASE_URL` and `--dart-define=SUPABASE_ANON_KEY`.

---

## 5. RESOLVED ISSUES & ROOT-CAUSE ANALYSIS

| Bug ID | Severity | Issue Summary | Technical Root Cause | Applied Fix | Verification |
|---|---|---|---|---|---|
| **BUG-001** | High | Generic app label "GRI Portal" | Manifest `android:label` and `strings.xml` set to old title | Updated to `gri-updated` across Manifest, strings.xml, and MaterialApp | Verified on phone home launcher |
| **BUG-002** | High | ADB batch launcher skipped APK push | `launch_app.bat` exited if package already existed | Rewrote batch to force stream install `-r -d` unconditionally | Verified streamed install on device |
| **BUG-003** | Medium | Cross-drive Kotlin cache crash | C: pub cache vs D: project source path relativization failure | Disabled incremental cache and set in-process compiler strategy in `gradle.properties` | Full Gradle build succeeded in 250s |
| **BUG-004** | High | Signature mismatch install error | Older build on phone had mismatched debug key | Automated fallback detection uninstalls old APK and reinstalls cleanly | Verified clean install on Galaxy A15 |
| **BUG-005** | Medium | Batch file syntax crash | Unquoted parenthesis in Windows CMD conditional blocks | Reformatted batch syntax avoiding nested parentheses | Script runs seamlessly |

---

## 6. VERIFIED METRICS & SYSTEM LIMITATIONS

- **Static Analysis:** `flutter analyze` completed in 104.8s with **0 warnings / 0 errors**.
- **Test Suite:** `flutter test` executed 88 unit and widget tests in 7.0s with **88/88 passed**.
- **Release APK:** 69,340,674 bytes (66.1 MB) generated at `build/app/outputs/flutter-apk/app-release.apk`.
- **Known Limitations:**
  - Campus LAN Intranet links (`http://10.10.12.48/opac-tmpl/...`) require physical connection to campus Wi-Fi.
  - Multi-user cloud synchronization requires active Supabase project credentials; without them, the app runs in full offline vault mode.

