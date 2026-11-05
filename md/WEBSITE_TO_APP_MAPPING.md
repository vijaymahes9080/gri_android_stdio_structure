# The Gandhigram Rural Institute (Deemed to be University)
## Complete Website-to-App Content & Route Mapping

**Institution Portal:** [https://ruraluniv.ac.in/](https://ruraluniv.ac.in/)  
**Total Discovered Routes:** 309 web routes mapped to Flutter Mobile Application  
**Target Application Package:** `com.aistudio.grist.kxmpzq`  

---

## 1. Executive Content Routing Architecture

The 309 discovered pages of `ruraluniv.ac.in` map to native Flutter modules based on content type, interactivity, and academic hierarchy:

```mermaid
graph TD
    A[GRI Official Portal - 309 Routes] --> B[Core Nav Scaffold]
    B --> C[Home Dashboard Hub]
    B --> D[Academics & Examination Hub]
    B --> E[Campus & Facilities Hub]
    B --> F[Student Services & Welfare Hub]
    B --> G[University Drawer & Universal Catalog]

    G --> H[Heritage & Vision Dossier]
    G --> I[Governance & Statutory Councils]
    G --> J[Schools & Programmes Browser]
    G --> K[Admissions & Prospectuses]
    G --> L[Official Document Vault]
    G --> M[Media & Video Gallery]
    G --> N[Enterprise Portals Gateway]
    G --> O[Contact & Campus Transit]
    G --> P[Institutional Parametric Articles]
```

---

## 2. Institutional Modules & Screen Coverage

| Module Category | Website URL Coverage | Flutter Implementation Screen | Screen Type | Verification Status |
| :--- | :--- | :--- | :--- | :--- |
| **Home & Portal Index** | `ruraluniv.ac.in/` | `lib/screens/home_dashboard_screen.dart` | Dedicated Native | **VERIFIED** |
| **Institution Profile & Heritage** | `aboutgri?content=vm`, `GenesisofGRI`, `grilogo`, `profile`, `FormerChancellors`, `FormerViceChancellors` (62 routes) | `lib/screens/about_gri_heritage_screen.dart` | Dedicated 4-Tab Native | **VERIFIED** |
| **Governance & Leadership** | `Governance?content=System`, `EC_CompositionFunctions`, `AcademicCouncil_Composition`, `administration?content=vc`, `registrar`, `coe`, `hod`, `deans` (20 routes) | `lib/screens/governance_leadership_screen.dart` | Dedicated 3-Tab Native | **VERIFIED** |
| **Schools & Academic Programmes** | `academics?content=CBCSsystem`, `faculties`, `programmes`, 30+ department query URLs (`department=agri_pr...`) (52 routes) | `lib/screens/schools_programmes_hub_screen.dart` & `lib/screens/department_detail_screen.dart` | Dedicated Hub & Parametric Detail | **VERIFIED** |
| **Admissions & Prospectus** | `admissions?content=PhD_Regulations`, `MPhil_Regulations`, `Dsc_Regulations`, `admn1?content=Refund`, `Hostel_fee` (6 routes) | `lib/screens/admissions_prospectus_screen.dart` | Dedicated 4-Tab Native | **VERIFIED** |
| **Examinations & COE Services** | `examination?content=ExaminationSystem`, `examtt`, Tatkal guidelines, e-SANAD attestation (49 routes) | `lib/screens/examination_services_screen.dart` | Dedicated 4-Tab Native | **VERIFIED** |
| **Campus Facilities & Map** | `facilities?content=library`, `ibc`, `cedt`, `phyedu`, `museum`, `About_NMR_Facility`, `About_XRD_Facility`, `About_NANO_Facility`, `SEAWEED_1` (4 routes) | `lib/screens/campus_facilities_screen.dart` | Dedicated Native + Filter Chips | **VERIFIED** |
| **Student Services & Welfare** | Grievances, bus passes, digital hostel allotments, `gridu?content=AntiRaggingCommittee`, `swayam_guidelines` (3 routes) | `lib/screens/student_services_hub_screen.dart` & `lib/screens/scholarships_welfare_screen.dart` | Dedicated Native | **VERIFIED** |
| **Official Document Center** | 595 cataloged PDFs, UGC compliance certificates, NAAC SSR Cycle 4, NIRF 2026, mandatory disclosures (15 routes) | `lib/screens/document_vault_screen.dart` & `lib/screens/official_document_center_screen.dart` | Searchable Vault with Local & Remote Fallback | **VERIFIED** |
| **Official Portals & Gateways** | Samarth@GRI, Student ERP, MEA e-SANAD, Biometric Attendance, DigiLocker APAAR ID, Webmail, LMS (17 routes) | `lib/screens/official_portals_gateway_screen.dart` | Dedicated Enterprise Gateway Directory | **VERIFIED** |
| **Media & Galleries** | `facilities?content=videotour`, campus panoramic video, photo galleries (3 routes) | `lib/screens/media_gallery_screen.dart` | Dedicated Stream & Gallery Native | **VERIFIED** |
| **Contact & Transit Directions** | `contacts.php`, `gridu?content=location`, EPABX directory, Madurai/Dindigul transit guides (3 routes) | `lib/screens/contact_campus_info_screen.dart` | Dedicated 3-Tab Native | **VERIFIED** |
| **Universal Catalog Search** | Universal index covering all 309 URLs and dynamic keywords | `lib/screens/global_website_search_screen.dart` | Live Search & Filter Engine | **VERIFIED** |
| **Parametric Institutional Pages** | Specific statutory circulars, special centre articles, policies, committees (71 routes) | `lib/screens/institutional_article_screen.dart` | Parametric Article Template | **VERIFIED** |
| **Inaccessible / Deprecated Routes** | 10 legacy 2014-2016 dead URLs, 3 campus LAN intranet links (`10.10.12.48`) | Documented in `10_quality_assurance/` | Graceful Fallback Notice | **VERIFIED** |

---

## 3. High-Priority Mapped Routes Roster

| # | Web URL | Official Page Title | Primary App Screen Destination | Local Asset Available |
| :-: | :--- | :--- | :--- | :--- |
| 1 | `https://ruraluniv.ac.in/` | GRI Portal Index | `HomeDashboardScreen` | `assets/official/images/gri_portal_banner.png` |
| 2 | `https://ruraluniv.ac.in/aboutgri?content=vm` | Vision & Mission | `AboutGriHeritageScreen` (Tab 1) | `assets/official/images/gri_official_crest.jpg` |
| 3 | `https://ruraluniv.ac.in/aboutgri?content=GenesisofGRI` | Genesis & Founders | `AboutGriHeritageScreen` (Tab 2) | Historical archives text |
| 4 | `https://ruraluniv.ac.in/aboutgri?content=grilogo` | University Crest & Motto | `AboutGriHeritageScreen` (Tab 3) | `assets/official/images/gri_official_crest.jpg` |
| 5 | `https://ruraluniv.ac.in/administration?content=chancellor` | Chancellor Secretariat | `GovernanceLeadershipScreen` (Tab 1) | `assets/official/images/chancellor_annamalai.jpg` |
| 6 | `https://ruraluniv.ac.in/administration?content=vc` | Vice-Chancellor Secretariat | `GovernanceLeadershipScreen` (Tab 1) | `assets/official/images/vice_chancellor_panchanatham.jpg` |
| 7 | `https://ruraluniv.ac.in/administration?content=registrar` | Registrar Secretariat | `GovernanceLeadershipScreen` (Tab 1) | `assets/official/images/registrar_marimuthu.jpg` |
| 8 | `https://ruraluniv.ac.in/administration?content=deans` | Deans of Schools | `GovernanceLeadershipScreen` (Tab 2) | Official School Roster |
| 9 | `https://ruraluniv.ac.in/administration?content=hod` | Heads of Departments | `GovernanceLeadershipScreen` (Tab 2) | 30+ Academic HODs |
| 10 | `https://ruraluniv.ac.in/Governance?content=EC_CompositionFunctions` | Executive Council | `GovernanceLeadershipScreen` (Tab 3) | Statutory roster |
| 11 | `https://ruraluniv.ac.in/academics?content=CBCSsystem` | CBCS Regulations | `SchoolsProgrammesHubScreen` (Tab 4) | CBCS regulation syllabus guidelines |
| 12 | `https://ruraluniv.ac.in/academics?content=faculties` | 8 Statutory Schools | `SchoolsProgrammesHubScreen` (Tab 1) | Full Dean/Faculty profiles |
| 13 | `https://ruraluniv.ac.in/admissions/2026/pdf/Prospectus_202627.pdf` | Prospectus 2026-27 | `AdmissionsProspectusScreen` | `assets/official/documents/GRI_Prospectus_2026-27.pdf` |
| 14 | `https://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf` | Transcript Form COE-01 | `ExaminationServicesScreen` | `assets/official/documents/COE_Form_Transcript_Application.pdf` |
| 15 | `https://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf` | Duplicate Cert Form COE-02 | `ExaminationServicesScreen` | `assets/official/documents/COE_Form_Duplicate_Certificate.pdf` |
| 16 | `https://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf` | Tatkal Instructions | `ExaminationServicesScreen` | `assets/official/documents/COE_Tatkal_Scheme_Instructions.pdf` |
| 17 | `https://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf` | e-SANAD Attestation | `ExaminationServicesScreen` | `assets/official/documents/MEA_eSANAD_Attestation_Procedure.pdf` |
| 18 | `https://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf` | PhD Compliance Format | `AdmissionsProspectusScreen` | `assets/official/documents/UGC_PhD_Compliance_Certificate.pdf` |
| 19 | `https://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf` | ICAR KVK Farm Science | `SchoolsProgrammesHubScreen` (Tab 3) | `assets/official/documents/ICAR_KVK_Farm_Science_Brochure.pdf` |
| 20 | `https://ruraluniv.ac.in/facilities?content=library` | Dr. Radhakrishnan Library | `CampusFacilitiesScreen` | `assets/images/library_front.jpg` |
| 21 | `https://ruraluniv.ac.in/facilities?content=videotour` | Campus Video Walkthrough | `MediaGalleryScreen` | Verified Stream `VID_CAMPUS_TOUR` |
| 22 | `https://ruraluniv.ac.in/contacts.php` | Directory & Emergency | `ContactCampusInfoScreen` | Verified EPABX directory |
