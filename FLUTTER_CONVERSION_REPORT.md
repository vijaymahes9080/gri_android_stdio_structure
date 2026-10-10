# GRI Official Mobile Application — Complete Flutter Conversion Report

**Institution:** The Gandhigram Rural Institute (Deemed to be University)  
**Official Portal:** [ruraluniv.ac.in](https://ruraluniv.ac.in/)  
**Application ID:** `com.aistudio.grist.kxmpzq`  

---

## 1. Executive Summary & Conversion Overview
The GRI Official Mobile Portal has been converted into a native **Flutter Android application** using **Dart** with a clean, modular architecture.

All existing institutional modules, workflows, roles, and design requirements have been preserved:
- **8 Core Application Screens** (Home Dashboard, Academics & Examination Hub, Campus Facilities & Map, Student Services Hub, Ask GRI AI Assistant, Faculty & Staff Portal, Official Document Center, System Governance & Directory).
- **Institutional Authentication & Workflows** (Multi-Role Switcher, Registration Wizard, Admin Approval Dossier, Application Status Stepper & Clarification response).
- **Cloud Backend Integration** (Supabase Cloud + offline fallback).
- **Gandhian Aesthetic Design System** (GRI Forest Green `#1B5E20`, Khadi Golden Ochre `#B8860B`, Khadi Ivory `#F9F9F4`).
- **One-Click Phone Launcher** (`launch_app.bat`).

---

## 2. Flutter Project Structure

```
d:\current project\gri\
├── android\                           # Native Android Gradle configuration for Flutter
│   ├── app\
│   │   ├── build.gradle               # Flutter Android app build configuration
│   │   └── src\main\
│   │       ├── AndroidManifest.xml    # Permissions (INTERNET, ACCESS_NETWORK_STATE)
│   │       └── kotlin\com\aistudio\grist\kxmpzq\MainActivity.kt
│   ├── build.gradle                   # Top-level build script
│   ├── settings.gradle                # Flutter Gradle plugin loader
│   ├── local.properties               # Android SDK & Flutter configuration
│   └── gradlew.bat                    # Gradle wrapper
├── assets\
│   ├── data\
│   │   └── gri_official_seed.json     # Official university institutional dataset
│   ├── images\                        # University logo, banners, avatars, campus photos
│   └── icons\
├── lib\
│   ├── main.dart                      # Application root & dynamic navigation
│   ├── models\
│   │   ├── user_model.dart            # Roles, Permissions, User Dossier, Registration Applications
│   │   └── academic_models.dart       # Courses, Circulars, Grievances, Transport, Hall Tickets
│   ├── providers\
│   │   └── gri_provider.dart          # Central State Management (ChangeNotifier)
│   ├── services\
│   │   ├── seed_data_service.dart     # Loads & queries official GRI seed repository
│   │   └── supabase_service.dart      # Real-time Supabase cloud client & offline sync
│   ├── screens\
│   │   ├── home_dashboard_screen.dart           # Screen 1: Home Dashboard & Quick Actions
│   │   ├── academics_hub_screen.dart            # Screen 2: Courses, Attendance & Examinations
│   │   ├── campus_facilities_screen.dart        # Screen 3: Campus Facilities & Map
│   │   ├── student_services_hub_screen.dart     # Screen 4: Grievance Redressal & Bus Pass
│   │   ├── ask_gri_ai_screen.dart               # Screen 5: GRI-Sahayak AI Assistant
│   │   ├── faculty_staff_portal_screen.dart     # Screen 6: Faculty Attendance & Leave Portal
│   │   ├── official_document_center_screen.dart # Screen 7: e-SANAD Document Verification
│   │   ├── admin_directory_screen.dart          # Screen 8: Governance & Administration Directory
│   │   ├── admin_approval_center_screen.dart    # Admin Registration Approval Dossiers
│   │   └── application_status_screen.dart       # Applicant Status Stepper & Clarification
│   ├── widgets\
│   │   ├── gri_top_bar.dart                     # University Header & Role Switcher Strip
│   │   ├── role_switcher_modal.dart             # Role Switcher Modal Sheet
│   │   ├── registration_wizard_modal.dart       # Institutional Registration Modal
│   │   ├── admin_review_modal.dart              # Admin Dossier Review & Decision Modal
│   │   └── hall_ticket_modal.dart               # Examination Hall Ticket with QR Code
│   └── utils\
│       └── gri_colors.dart                      # Official GRI Palette & Theme Tokens
├── test\
│   └── widget_test.dart                         # Automated Unit & Widget Tests
├── .idea\
│   └── runConfigurations\
│       └── main_dart.xml                        # Android Studio Flutter Run Configuration
├── pubspec.yaml                                 # Flutter dependencies and assets
└── launch_app.bat                               # One-Click Phone Launcher Batch File
```

---

## 3. Preserved Institutional Roles & Workflows

| Role | Navigation Tabs | Permissions & Features |
|---|---|---|
| **STUDENT** | Home, Academics, Campus, Services, More | View courses, mark attendance, generate Hall Tickets, digital bus pass, file grievances, access GRI-Sahayak AI. |
| **FACULTY** | Home, Academics, Services, Campus, More | Manage class rolls, submit staff leaves, grade cards, research publications. |
| **ADMIN** | Home, Approvals, Academics, Services, More | Full approval dossier center (Approve, Reject, Request Info), audit logs, broadcast official circulars, sync cloud. |
| **COE_STAFF** | Home, Exams, Academics, Services, More | Publish exam timetables, manage hall tickets, authenticate digital certificates. |
| **SCHOLAR** | Home, Research, Academics, Services, More | Research thesis registration, library e-resources proxy, conference seminar portal. |
| **GUEST / APPLICANT** | Status, Campus, More | Application tracking stepper, answer registrar queries, campus guide. |

---

## 4. How to Run & Build

### Option A: Launch Directly onto Connected Phone
Simply double-click **`launch_app.bat`** or run in terminal:
```cmd
.\launch_app.bat
```
This script will:
1. Verify ADB connection and check for authorized phone.
2. Resolve Flutter dependencies (`flutter pub get`).
3. Deploy and launch the application directly onto your Android device.

### Option B: Run via Android Studio
1. Open Android Studio.
2. Select **Open** and choose `d:\current project\gri`.
3. In the run dropdown, select **`main.dart`** (automatically configured in `.idea/runConfigurations/main_dart.xml`).
4. Select your connected phone or emulator and click **Run (Shift+F10)**.

### Option C: Manual CLI Commands
```bash
# Get dependencies
flutter pub get

# Run tests
flutter test

# Run on connected phone
flutter run

# Build release/debug APK
flutter build apk --debug
```
The compiled APK will be generated at:
`build/app/outputs/flutter-apk/app-debug.apk`

---

## 5. Cloud Database & Backend Configuration

The application integrates with **Supabase Cloud Backend**:
- Configured in `.env` (refer to `.env.example`):
  ```env
  VITE_SUPABASE_URL=https://<your-project-ref>.supabase.co
  VITE_SUPABASE_ANON_KEY=<your-anon-key>
  ```
- Compatible with existing SQL migrations in `supabase/migrations/`:
  - `20261004000000_init_gri_cloud.sql`
  - `20261004010000_gri_official_content.sql`
- Offline-ready with local state and cache fallback.
