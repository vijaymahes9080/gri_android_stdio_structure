# GRI APPLICATION — IMPLEMENTATION & ARCHITECTURAL ROADMAP
## Strategic Engineering Execution, Dependency Governance & Production Deployment

**Target Project:** `gri-updated` (`com.aistudio.grist.kxmpzq`)  
**Architecture:** Flutter 3.x / Dart 3.5+ (Material 3)  
**Security Standard:** Row Level Security (RLS) + Offline Vaulting  
**Target Platform:** Android 8.0+ (API 24 to API 36)  

---

## 1. TECHNICAL DECISION LOG (ADR)

### ADR-001: Mobile Framework Selection — Flutter vs. Native Kotlin/Java
- **Decision:** Retain and optimize the existing Flutter implementation in `lib/`.
- **Rationale:** The repository contains a mature, comprehensive Flutter codebase covering 18 dedicated screens, 6 specialized modals, custom design tokens, and an 88-test test suite. Rewriting into native Kotlin/Jetpack Compose would incur massive regressions without architectural benefit.

### ADR-002: Dual Persistence & Offline-First Vaulting
- **Decision:** Implement `LocalDataStoreService` (`shared_preferences`) as the primary write store, with asynchronous cloud mirroring via `SupabaseService`.
- **Rationale:** Campus network connectivity in rural environments is frequently intermittent. The application must guarantee that attendance submissions, leave applications, grievances, and registration workflows never fail due to dropped packets.

### ADR-003: Grounded Offline Retrieval Engine (GRI-Sahayak)
- **Decision:** Utilize deterministic AST and keyword retrieval in `SahayakKnowledgeEngine` rather than calling external generative LLM APIs.
- **Rationale:** Educational institutional assistants must not hallucinate examination rules, fee deadlines, or statutory compliance. The grounded engine guarantees 100% factual fidelity to official university prospectuses with zero operational API billing.

### ADR-004: Triple-Tier External Intent Cascading
- **Decision:** Route all external URLs and documents through `GriUrlLauncher`.
- **Rationale:** Android 11+ (API 30+) strictly restricts package visibility via `<queries>`. Cascading through `externalApplication` -> `platformDefault` -> `inAppBrowserView` ensures that PDFs, web portals, and phone dialers always succeed on any Android OEM.

---

## 2. PHASED IMPLEMENTATION PLAN

```mermaid
flowchart TD
    P1[Phase 1: Repository Intelligence & Audit] --> P2[Phase 2: Official Web Reverse Engineering]
    P2 --> P3[Phase 3: Parity & Feature Gap Matrix]
    P3 --> P4[Phase 4: Architecture & Design System Hardening]
    P4 --> P5[Phase 5: UI/UX Refinement & Device Testing]
    P5 --> P6[Phase 6: Multi-Role Workflows & Authorization]
    P6 --> P7[Phase 7: Cloud Mirroring & RLS Security]
    P7 --> P8[Phase 8: Comprehensive QA & Verification]
```

### Phase Breakdown & Deliverables

#### Phase 1: Repository Intelligence & Baselines (Completed)
- Source inventory across `lib/`, `android/`, `assets/`, `supabase/`.
- Build configuration analysis: Kotlin 2.2.20 pinning, Java 17 toolchain, Android SDK 36.
- Verification of test suites and dependency tree.

#### Phase 2: Official Website Reverse Engineering (Completed)
- Discovery and extraction of 309 web routes on `ruraluniv.ac.in`.
- Categorization across 15 institutional modules (A–H).
- Extraction of high-priority institutional PDFs, circulars, and leadership profiles into `assets/official/`.

#### Phase 3: Parity & Gap Remediation (Completed)
- Cross-referencing 309 routes to 18 native Flutter screens.
- Resolving app labeling (`gri-updated`), batch installer automation, and cross-drive compilation.

#### Phase 4: Design System & Accessibility Hardening (Completed)
- WCAG 2.2 AA compliant palette (`GriColors`) featuring Gandhian Khadi Ivory, Forest Green, Deep Ochre, Terracotta, and Deep Teal.
- 10px typography legibility floor enforced across all text tokens (`GriTypography`).
- Reduced-motion integration honoring `MediaQuery.disableAnimations` and user settings (`GriMotion`).

#### Phase 5: Functional Workflows & Role Gating (Completed)
- Role-based activation restricted to authorized account dossiers (`approvedRolesCsv`).
- Enforced 75% attendance rule for examination hall ticket generation.
- Faculty roll-call register with Present/Absent/OD recording and cloud queueing.

#### Phase 6: Cloud Mirroring & Security Hardening (Completed)
- Supabase migrations with Row Level Security (RLS).
- Fail-closed security for unauthenticated sessions on grievance and attendance tables.
- Cryptographic hash verification for institutional certificates.

#### Phase 7: Hardware Verification & E2E Testing (Completed)
- Hardware deployment and execution on physical Samsung Galaxy A15 5G (`RZCX2175PPX`).
- 88 automated unit and widget tests executing in 7.0s.

---

## 3. DEPENDENCY & RISK GOVERNANCE

| Dependency | Version | Purpose | Risk Assessment & Mitigation |
|---|---|---|---|
| `provider` | `^6.1.2` | Central state management | High stability; standard Flutter architecture. |
| `supabase_flutter`| `^2.8.0` | Cloud database & auth | Optional runtime; application operates seamlessly in offline vault mode. |
| `shared_preferences`| `^2.3.2` | Persistent on-device JSON vault | Rock-solid Android SharedPreferences abstraction. |
| `url_launcher` | `^6.3.0` | External portal, dialer & mail intent | Hardened via `GriUrlLauncher` triple-tier fallback. |
| `qr_flutter` | `^4.1.0` | Verification QR code generation | Deterministic client-side rendering. |
| `http` | `^1.2.2` | Live notice scraping & sync | Protected by 8-second timeout and seed fallback. |

---

## 4. ACCEPTANCE CRITERIA & SIGN-OFF GATES

- [x] **Gate 1: Static Analysis Cleanliness:** `flutter analyze` passes with 0 errors and 0 warnings.
- [x] **Gate 2: Automated Test Coverage:** All 88 automated unit/widget tests pass.
- [x] **Gate 3: Hardware Verification:** App installs and runs cleanly on a physical Android device without crashes.
- [x] **Gate 4: Navigation Integrity:** Zero broken routes, dead links, or unhandled exceptions across all 18 screens and 6 modal workflows.
- [x] **Gate 5: Content Provenance:** All academic, admission, examination, and governance data matches official university records.

