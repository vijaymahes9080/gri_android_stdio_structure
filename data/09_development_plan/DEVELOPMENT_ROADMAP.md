# Phase J — Prioritized Engineering Development Roadmap

> [!IMPORTANT]
> **Planning Boundary Disclaimer**:  
> In compliance with strict project instructions, **Phases 1 through 3** (Discovery, Validation, and Architecture Design) are completed in this data collection phase. **Phases 4 through 8** (Backend Provisioning, Feature Refactoring, Live Sync, and Production Release) will remain in planning status until explicit approval is granted by the user.

---

## 1. Roadmap Phase Progression Overview

| Phase | Milestone Name | Status | Primary Focus |
| :---: | :--- | :---: | :--- |
| **Phase 1** | **Website Discovery & Content Collection** | **COMPLETED** | 250 URLs cataloged, 1,047 assets inventoried, `data/` populated. |
| **Phase 2** | **Content Validation & Gap Analysis** | **COMPLETED** | Verification matrices, broken link identification, coverage metrics. |
| **Phase 3** | **Data Model & Architecture Proposal** | **COMPLETED** | 10 Mermaid diagrams, normalized ERD, Flutter structure proposal. |
| **Phase 4** | **Backend & Media Storage Preparation** | **PROPOSED** | Supabase project creation, PostgreSQL RLS, Storage CDN buckets. |
| **Phase 5** | **Flutter Feature-First Refactoring** | **PROPOSED** | Transition from monolithic providers to feature-driven repositories. |
| **Phase 6** | **Live Dynamic Website Ingestion** | **PROPOSED** | Scheduled ingestion pipeline for new circulars and timetables. |
| **Phase 7** | **Physical Hardware Regression Testing** | **PROPOSED** | Multi-screen 0px overflow testing on connected Samsung phone. |
| **Phase 8** | **Production Release Readiness** | **PROPOSED** | Keystore signing, proguard shrinking, Google Play release bundle. |

---

## 2. Detailed Implementation Task Breakdown (Phases 4 – 8)

### Phase 4: Backend & Storage Preparation
- **Task ID**: `TSK-BE-01`
  - **Feature Area**: Database & Schema Migration
  - **Prerequisites**: Approval of `data/07_architecture/ERD_AND_DATA_MODEL.md`
  - **Affected Files**: `supabase/migrations/`
  - **Complexity**: Medium
  - **Priority**: High (P1)
  - **Risk**: Cloud quota limits; network latency to institutional servers.
  - **Acceptance Criteria**: All 7 core tables created with foreign keys, indexes, and RLS policies.
  - **Verification Method**: Automated SQL migration test script.

- **Task ID**: `TSK-BE-02`
  - **Feature Area**: Storage Buckets & CDN Distribution
  - **Prerequisites**: `TSK-BE-01`
  - **Affected Files**: Storage bucket policies
  - **Complexity**: Low
  - **Priority**: High (P1)
  - **Acceptance Criteria**: Buckets created for `official-documents` and `campus-media` with public read access.

### Phase 5: Flutter Feature-First Module Implementation
- **Task ID**: `TSK-FL-01`
  - **Feature Area**: Repository Pattern & Offline Cache
  - **Prerequisites**: `TSK-BE-01`
  - **Affected Files**: `lib/core/storage/`, `lib/features/*/data/`
  - **Complexity**: High
  - **Priority**: High (P1)
  - **Acceptance Criteria**: SQLite/Drift database caching circulars and syllabi with zero UI stutter.
  - **Verification Method**: Unit tests mocking offline state.

- **Task ID**: `TSK-FL-02`
  - **Feature Area**: Universal Website Catalog Search
  - **Prerequisites**: `data/02_page_inventory/all_pages.jsonl`
  - **Affected Files**: `lib/screens/global_website_search_screen.dart`
  - **Complexity**: Medium
  - **Priority**: Medium (P2)
  - **Acceptance Criteria**: Instant client-side fuzzy search across all 247 verified pages with direct links.

### Phase 6: Live Dynamic Website Content Integration
- **Task ID**: `TSK-INT-01`
  - **Feature Area**: Notice Board & Circular Sync Engine
  - **Prerequisites**: `TSK-BE-01`, `TSK-FL-01`
  - **Affected Files**: `lib/services/notice_sync_service.dart`
  - **Complexity**: Medium
  - **Priority**: Medium (P2)
  - **Acceptance Criteria**: Daily background sync fetches newly issued PDF circulars from `ruraluniv.ac.in`.

### Phase 7: Hardware Regression Testing
- **Task ID**: `TSK-QA-01`
  - **Feature Area**: End-to-End Physical Device Validation
  - **Prerequisites**: `TSK-FL-01`
  - **Affected Files**: Automated ADB test runner
  - **Complexity**: Medium
  - **Priority**: High (P1)
  - **Target Device**: Samsung Galaxy A15 5G (`RZCX2175PPX`)
  - **Acceptance Criteria**: 0px overflow across all screens, 60fps scrolling, zero memory leaks.

### Phase 8: Production Release
- **Task ID**: `TSK-REL-01`
  - **Feature Area**: Release Build & App Bundle Generation
  - **Prerequisites**: Complete signoff on Phase 7
  - **Affected Files**: `android/app/build.gradle`, `key.properties`
  - **Complexity**: Medium
  - **Priority**: High (P1)
  - **Acceptance Criteria**: AAB bundle signed with release keystore, passed Play Protect pre-launch report.
