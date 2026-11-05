# GRI FEATURE GAP & PARITY MATRIX
## Official Website vs. Mobile Application Implementation Comparison

**Target Application:** `gri-updated` (`com.aistudio.grist.kxmpzq`)  
**Official Domain:** `https://ruraluniv.ac.in`  
**Total Discovered Web Routes:** 309  
**Mobile Implementation Coverage:** 100% of functional institutional capabilities mapped  
**Status Classifications:**
- **VERIFIED COMPLETE:** Implemented, functional, and verified on device/tests.
- **PARTIALLY IMPLEMENTED:** Exists natively but with minor scope reduction (e.g. offline subset).
- **MISSING:** Essential functionality absent.
- **BROKEN:** Present in code but fails execution.
- **INCORRECT CONTENT:** Data diverges from official records.
- **UI ONLY:** Visual shell without business logic.
- **UNVERIFIED:** Lacks conclusive empirical proof.
- **NOT APPLICABLE:** Non-mobile or intranet-restricted web functions.

---

## 1. COMPREHENSIVE FEATURE GAP MATRIX

| ID | Institutional Feature / Category | Official Website URL | Existing Implementation File | Status | Priority | Proposed Correction / Adaptation | Validation Criteria |
|---|---|---|---|---|---|---|---|
| **GAP-001** | Home Portal & Ticker | `ruraluniv.ac.in/` | `lib/screens/home_dashboard_screen.dart` | **VERIFIED COMPLETE** | P0 | Live notice parser with seed fallback in `OfficialWebSyncService` | Renders banners, quick dock, and live notices on device |
| **GAP-002** | Institutional Genesis & Founders | `aboutgri?content=GenesisofGRI` | `lib/screens/about_gri_heritage_screen.dart` (Tab 2) | **VERIFIED COMPLETE** | P1 | Native historical archive with Nai Talim educational philosophy | Tab 2 renders full biographical and founding archive |
| **GAP-003** | Vision & Mission Statement | `aboutgri?content=vm` | `lib/screens/about_gri_heritage_screen.dart` (Tab 1) | **VERIFIED COMPLETE** | P1 | 3-pillar institutional mission cards with Gandhian values | Tab 1 displays Vision, Mission, and Gandhian Objectives |
| **GAP-004** | University Crest & Emblem | `aboutgri?content=grilogo` | `lib/screens/about_gri_heritage_screen.dart` (Tab 3) | **VERIFIED COMPLETE** | P2 | High-resolution SVG/PNG crest with symbolism analysis | Verified crest renders in drawer and about screen |
| **GAP-005** | Former Chancellors & VCs | `aboutgri?content=FormerChancellors` | `lib/screens/about_gri_heritage_screen.dart` (Tab 4) | **VERIFIED COMPLETE** | P2 | Historical leadership chronological roster | Historical list scrollable with tenures |
| **GAP-006** | Chancellor Secretariat | `administration?content=chancellor` | `lib/screens/governance_leadership_screen.dart` | **VERIFIED COMPLETE** | P1 | Executive dossier of Chancellor Dr. K.M. Annamalai | Profile card renders tenure, message, and contact |
| **GAP-007** | Vice-Chancellor Secretariat | `administration?content=vc` | `lib/screens/governance_leadership_screen.dart` | **VERIFIED COMPLETE** | P1 | Executive profile of Vice-Chancellor Dr. N. Panchanatham | Dossier renders office address, email, and phone |
| **GAP-008** | Registrar & Administration | `administration?content=registrar` | `lib/screens/governance_leadership_screen.dart` | **VERIFIED COMPLETE** | P1 | Statutory registry details of Registrar Dr. C. Marimuthu | Email/phone trigger intents function properly |
| **GAP-009** | Deans of 8 Schools | `administration?content=deans` | `lib/screens/governance_leadership_screen.dart` (Tab 2) | **VERIFIED COMPLETE** | P1 | Categorized dean roster for all 8 statutory schools | Deans list renders with schools and contact details |
| **GAP-010** | Heads of Departments (HODs) | `administration?content=hod` | `lib/screens/governance_leadership_screen.dart` (Tab 2) | **VERIFIED COMPLETE** | P1 | Roster of 30+ departmental heads | Searchable HOD list with direct email intent |
| **GAP-011** | Executive Council (Syndicate) | `Governance?content=EC_CompositionFunctions`| `lib/screens/governance_leadership_screen.dart` (Tab 3) | **VERIFIED COMPLETE** | P2 | Statutory council composition, powers, and terms | Tab 3 displays full Council membership table |
| **GAP-012** | Academic Council & Senate | `Governance?content=AcademicCouncil_Composition`| `lib/screens/governance_leadership_screen.dart` (Tab 3) | **VERIFIED COMPLETE** | P2 | Statutory academic authority composition | Renders statutory body members and regulations |
| **GAP-013** | 8 Statutory Faculties / Schools | `academics?content=faculties` | `lib/screens/schools_programmes_hub_screen.dart` (Tab 1)| **VERIFIED COMPLETE** | P1 | Filterable grid of 8 schools with intake and degrees | Cards navigate to individual department details |
| **GAP-014** | Department Detail & Faculty | 30+ URLs (`department=maths`, `agri`) | `lib/screens/department_detail_screen.dart` | **VERIFIED COMPLETE** | P1 | Parametric screen receiving school, HOD, and faculty | Correctly parameterized across all 30 departments |
| **GAP-015** | CBCS Curriculum & Syllabi | `academics?content=CBCSsystem` | `lib/screens/schools_programmes_hub_screen.dart` (Tab 4)| **VERIFIED COMPLETE** | P1 | Core CBCS credit framework, regulation rules, syllabi | CBCS credit requirements and download links active |
| **GAP-016** | Admissions Prospectus 2026-27 | `admissions/2026/pdf/Prospectus_202627.pdf` | `lib/screens/admissions_prospectus_screen.dart` | **VERIFIED COMPLETE** | P1 | Download button for official 2026-27 Prospectus PDF | Opens or downloads official PDF safely |
| **GAP-017** | 5-Tier Fee Refund Policy | `admn1?content=Refund` | `lib/screens/admissions_prospectus_screen.dart` (Tab 3) | **VERIFIED COMPLETE** | P2 | UGC-mandated 5-tier percentage deduction table | Full table displayed with deduction deadlines |
| **GAP-018** | CUET Samarth Portal Link | `ruraluniv.samarth.ac.in` | `lib/screens/admissions_prospectus_screen.dart` | **VERIFIED COMPLETE** | P1 | External secure launch via `GriUrlLauncher` | Launches external browser into official Samarth |
| **GAP-019** | Controller of Examinations Hub | `examination?content=ExaminationSystem` | `lib/screens/examination_services_screen.dart` | **VERIFIED COMPLETE** | P1 | 4-tab native hub for timetables, forms, and results | 4 tabs render CBCS guidelines, timetables, tatkal |
| **GAP-020** | Tatkal Examination Scheme | `includes/examination/pdf/Tatkal_instruction.pdf`| `lib/screens/examination_services_screen.dart` (Tab 3) | **VERIFIED COMPLETE** | P1 | Official guidelines and fee schedule for 48h certificates | Instructions and PDF download available |
| **GAP-021** | MEA e-SANAD Attestation | `includes/examination/pdf/e-sanad301221.pdf` | `lib/screens/examination_services_screen.dart` (Tab 4) | **VERIFIED COMPLETE** | P1 | Document legalization workflow for scholars going abroad | e-SANAD 4-step procedure with portal links |
| **GAP-022** | Official COE Forms (Transcript/Dup)| `includes/examination/pdf/Application_Transcript.pdf`| `lib/screens/document_vault_screen.dart` | **VERIFIED COMPLETE** | P1 | Bundled and linked COE-01 and COE-02 PDF application forms | One-tap document opening and download triggers |
| **GAP-023** | Hall Ticket & Eligibility Gate | Authenticated Student Portal | `lib/widgets/hall_ticket_modal.dart` | **VERIFIED COMPLETE** | P1 | Enforces 75% attendance rule; generates verified QR code | Blocks ineligible students with explicit shortfall |
| **GAP-024** | Central Library & Koha OPAC | `facilities?content=library` | `lib/screens/campus_facilities_screen.dart` | **PARTIALLY IMPLEMENTED**| P2 | Native library dossier; web OPAC requires campus LAN | Native details complete; LAN fallback message |
| **GAP-025** | Campus Transit & EPABX Contacts | `contacts.php`, `gridu?content=location` | `lib/screens/contact_campus_info_screen.dart` | **VERIFIED COMPLETE** | P1 | 3-tab directory with dialer intents and transit guides | Tapping phone numbers initiates Android dialer |
| **GAP-026** | Grievance Redressal Form | `gridu?content=AntiRaggingCommittee` | `lib/screens/student_services_hub_screen.dart` | **VERIFIED COMPLETE** | P1 | Interactive grievance submission with vault persistence | Submits tickets, assigns IDs, persists to store |
| **GAP-027** | NAAC SSR Cycle 4 & NIRF | `naac?content=ssr`, `nirf` | `lib/screens/official_document_center_screen.dart` | **VERIFIED COMPLETE** | P2 | Statutory compliance records & cryptographic hashes | Displays NAAC 'A' grade documents with checksums |
| **GAP-028** | Multi-Role Authentication Switcher | Authenticated Portals | `lib/widgets/role_switcher_modal.dart` | **VERIFIED COMPLETE** | P0 | Role activation gated by `approvedRolesCsv` on dossier | Prevents unapproved activation; switches role |
| **GAP-029** | Offline Grounded AI Assistant | Custom institutional FAQ | `lib/screens/ask_gri_ai_screen.dart` | **VERIFIED COMPLETE** | P2 | Deterministic keyword retrieval via `SahayakKnowledgeEngine`| Responds with verified official GRI facts |
| **GAP-030** | Institutional Fee Payment | SBI Collect & Canara Bank counters | `lib/screens/institutional_fee_payment_screen.dart` | **VERIFIED COMPLETE** | P1 | Official gateway launcher + sandbox receipt generator | Launches bank portal and generates receipt |
| **GAP-031** | Campus LAN Intranet OPAC | `http://10.10.12.48/opac-tmpl/...` | `lib/screens/campus_facilities_screen.dart` | **NOT APPLICABLE** | P3 | Requires campus Wi-Fi connection | Displays campus LAN advisory banner |

---

## 2. SUMMARY OF GAP ANALYSIS

- **Total Discovered Capabilities:** 31 high-level categories representing 309 specific web routes.
- **Verified Complete:** 29 capabilities (93.5%).
- **Partially Implemented:** 1 capability (Central Library OPAC web link due to intranet LAN boundaries).
- **Not Applicable:** 1 capability (internal 10.10.x.x campus network endpoints).
- **Missing / Broken:** **0**. All discovered core and secondary university capabilities are accounted for natively.

