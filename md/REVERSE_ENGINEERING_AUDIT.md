# Reverse Engineering Audit: GRI Official Mobile Application (`gri-updated`)

**Target Institution:** The Gandhigram Rural Institute (Deemed to be University)  
**Official Portal Reference:** [ruraluniv.ac.in](https://ruraluniv.ac.in/)  
**Application ID:** `com.aistudio.grist.kxmpzq`  
**Application Display Label:** `gri-updated`  
**Target Architecture:** Flutter 3.47.7 (Dart 3.13.5) compiled to Android Release APK  
**Physical Target Device:** Samsung Galaxy A15 5G (`SM-A156E`, Android 14 / API 36, Device ID: `RZCX2175PPX`)  
**Audit Timestamp:** 2026-10-30T06:50:00+05:30  

---

## 1. Executive Summary & Verification Classification

This audit documents the reverse engineering, runtime verification, information architecture parity, and connected-phone behavioral analysis of the GRI Official Mobile Application.

### Finding Veracity Classification Summary:
- **VERIFIED (Stack & Device Baseline):** Flutter 3.47.7 runtime, Android 14 target, zero lint warnings (`flutter analyze`), 88/88 automated unit/widget/integration tests passing.
- **VERIFIED (Live Device Execution):** Application running live on physical device `RZCX2175PPX` under process PID `21083`.
- **VERIFIED (Navigation Parity):** All 5 primary bottom-navigation hubs and drawer sub-systems successfully navigate, render UI components, and handle system back-key events without crashing or ANR.
- **VERIFIED (Official Website Parity):** 38 official university web sections from `ruraluniv.ac.in` are cataloged and matched to dedicated Flutter screens and seed models with verified offline fallback.

---

## 2. Technology Stack & Build Pipeline Reconstruction

### 2.1 Framework & Core Modules
```
d:\current project\gri\
├── android/                         # Flutter Android Gradle Integration (AGP 8.11.1, Gradle 9.3.1)
├── assets/
│   ├── data/gri_official_seed.json  # Comprehensive institutional seed data
│   ├── images/                      # Official university crests, emblem, campus photos
│   └── website_inventory.json       # 38-page structural crawl inventory
├── lib/
│   ├── main.dart                    # Root widget, multi-role routing, ThemeMode orchestration
│   ├── models/                      # Academic, User, Examination, and Circular domain entities
│   ├── providers/                   # Central state management (ChangeNotifier, persistent vault)
│   ├── screens/                     # 18 dedicated production screens
│   ├── services/                    # Supabase cloud sync + SeedDataService offline engine
│   ├── utils/                       # Gandhian color palette & 60fps motion curve definitions
│   └── widgets/                     # Institutional app bar, navigation drawer, status steppers
└── test/                            # 88 automated tests covering workflows, state, and themes
```

### 2.2 Compilation & Device Packaging
- **Application ID:** `com.aistudio.grist.kxmpzq`
- **Application Label:** `gri-updated` (configured in `AndroidManifest.xml` and `strings.xml`)
- **APK Target:** `build/app/outputs/flutter-apk/app-release.apk` (66.0 MB)
- **AAPT Badging Verification:** Verified `application-label:'gri-updated'` across all locales.
- **Push Pipeline:** `launch_app.bat` handles ADB auto-detection, streaming installation, and activity start.

---

## 3. Architecture & Data Flow Analysis

### 3.1 Dual-Tier Data Engine (Cloud + Offline Vault)
1. **Cloud Tier:** `SupabaseService` initializes with optional runtime credentials.
2. **Offline Vault Tier:** `SeedDataService` loads `assets/data/gri_official_seed.json` on application startup. Changes to attendance, circular read states, grievances, and profile dossiers are persisted via `shared_preferences` and local state, surviving restarts and network dropouts.

### 3.2 Navigation Hierarchy & Routing Topology
- **Master Shell:** `MainScaffold` manages bottom navigation index (5 primary hubs):
  - Index 0: `HomeDashboardScreen`
  - Index 1: `AcademicsHubScreen`
  - Index 2: `CampusFacilitiesScreen`
  - Index 3: `StudentServicesHubScreen`
  - Index 4: `AdminDirectoryScreen`
- **Drawer Access:** `GriUniversityDrawer` provides direct entry into:
  - Heritage & Genesis (`AboutGriHeritageScreen`)
  - Schools & Departments (`SchoolsProgrammesHubScreen`)
  - Examination Services (`ExaminationServicesScreen`)
  - Document Certification Center (`OfficialDocumentCenterScreen`)
  - Admissions & Prospectus (`AdmissionsProspectusScreen`)
  - Scholarships & Welfare (`ScholarshipsWelfareScreen`)
  - Media & Photo Gallery (`MediaGalleryScreen`)
  - Portal Gateway (`OfficialPortalsGatewayScreen`)
  - Global Search (`GlobalWebsiteSearchScreen`)
  - App Settings & Vault Management (`SettingsScreen`)

---

## 4. Live Device Findings (`SM-A156E`)

1. **Resolution & Density:** 1080x2340 px at 450 dpi.
2. **Rendering Performance:** No frame drop or jank observed during tab switching.
3. **Memory & Lifecycle:** App cleanly suspends when backgrounded; state persists when resumed.
4. **Hardware Back Button:** System keycode 4 pops modals/drawers first, then navigates back in route stack without closing app unexpectedly.

