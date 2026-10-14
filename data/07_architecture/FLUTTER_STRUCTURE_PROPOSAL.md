# Phase H — Proposed Flutter Project Structure & Architecture

> [!NOTE]
> **Implementation Planning**: This document defines the recommended architectural structure for future development phases. The current codebase remains untouched.

---

## 1. Architectural Philosophy: Feature-First with Layer Separation

For long-term maintainability, the application should adhere to a **Feature-Driven Architecture** combined with Flutter's official **MVVM (Model-View-ViewModel) / Repository Pattern**:

```text
lib/
├── app/                          # Core application bootstrap, routing & theme
│   ├── app.dart                  # Root MaterialApp configuration
│   ├── routes.dart               # Declarative navigation route definitions
│   └── theme/                    # Material 3 tokens, dark/light color schemes
│       ├── gri_colors.dart       # Institutional color palette
│       ├── gri_typography.dart   # Responsive Google Fonts typography tokens
│       └── gri_motion.dart       # Animation durations and easing curves
│
├── core/                         # Shared utilities, contracts & network clients
│   ├── constants/                # API endpoints, assets paths, institutional URLs
│   ├── network/                  # HTTP client, interceptors, retry policies
│   ├── storage/                  # SQLite/Drift database, encrypted secure storage
│   ├── error/                    # Failure objects, exception handlers
│   └── utils/                    # Checksum validators, formatters, link launchers
│
├── features/                     # Self-contained business modules
│   ├── home/                     # Portal index, notices, quick dock
│   │   ├── data/                 # Remote API, local cache, repositories
│   │   ├── domain/               # Models, business entities, validation
│   │   └── presentation/         # HomeDashboardScreen, NoticeCard, QuickDock
│   │
│   ├── academics/                # Schools, departments, syllabi, CBCS
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/         # AcademicsHubScreen, SyllabusViewerScreen
│   │
│   ├── examinations/             # Hall tickets, CoE notifications, e-SANAD
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/         # HallTicketModal, ExamTimetableScreen
│   │
│   ├── campus/                   # 300-acre map, GPS markers, facilities directory
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/         # CampusFacilitiesScreen, InteractiveMapCard
│   │
│   ├── services/                 # Grievances, bus passes, hostel management
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/         # StudentServicesHubScreen, GrievanceFormDialog
│   │
│   ├── governance/               # Leadership, administration, statutory disclosures
│   └── portals/                  # Central Web Portal Hub & E-Governance Gateways
│       ├── data/                 # Session tokens, cookie manager, SSO bridge
│       ├── domain/               # PortalGatewayModel, DocketMovementEntity
│       └── presentation/         # PortalHubScreen, InAppPortalWebView, ETrackStatusView
│       ├── data/
│       ├── domain/
│       └── presentation/         # AdminDirectoryScreen, OfficerContactTile
│
└── shared/                       # Cross-feature reusable UI components
    ├── widgets/                  # GriTopBar, GriUniversityDrawer, GriPressable
    └── dialogs/                  # RoleSwitcherModal, AskGriAiDialog
```

---

## 2. Component Responsibility Matrix

| Layer Component | Responsibility | Allowed Dependencies | Prohibited Dependencies |
| :--- | :--- | :--- | :--- |
| **View (Screen / Widget)** | Render UI, bind user gestures, display animations | ViewModel / Provider, Shared UI Widgets | Raw HTTP clients, SQLite queries, direct SQL |
| **ViewModel / Provider** | Manage UI state, handle business logic, call repositories | Repositories, Domain Models | Direct BuildContext widgets, low-level platform calls |
| **Repository** | Mediate between local SQLite cache and remote REST/Cloud API | Remote API Service, Local Cache Store | UI Widgets, State Notifiers |
| **Service (Network/DB)** | Raw HTTP communication, SQLite serialization | HTTP client, SQLite driver | Flutter UI, Business domain logic |
