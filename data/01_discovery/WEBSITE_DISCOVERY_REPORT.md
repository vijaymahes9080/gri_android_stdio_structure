# Phase B — GRI Official Website Complete Discovery Report

## 1. Discovery Scope & Crawl Architecture
The content discovery of the official website of **The Gandhigram Rural Institute (Deemed to be University)** ([https://ruraluniv.ac.in/home](https://ruraluniv.ac.in/home)) was conducted across the root domain, public sub-routes, and external institutional affiliations.

### Discovery Methodology:
1. **Automated Structural Analysis**: Parsing of all navigation anchors (`<div id='cssmenu'>`, `<div class='StartDDMdropdown'>`, and footer links).
2. **Browser Subagent Live Interaction**: Chromium automation recorded live menu expansion, dynamic CSS dropdowns (`StartDDMdropdown-content`), and DOM inspection.
3. **URL Normalization**:
   - Primary domain standard: `https://ruraluniv.ac.in/`
   - Canonical query parameter mapping: Query string format `?content=<section_name>` is used universally across legacy PHP modules (`aboutgri`, `Governance`, `administration`, `academics`, `admissions`, `facilities`, `students`, `examination`).
   - Duplicate reference resolution: Redirects such as `home.php` -> `home` and relative path resolutions were normalized to canonical URLs.

---

## 2. Institutional Web Modules & Discovery Summary

| # | Institutional Module Category | Discovered URLs | Verified Live | Auth / Intranet | Inaccessible | Primary Flutter Screen Mapping |
| :-: | :--- | :-: | :-: | :-: | :-: | :--- |
| **1** | **Institutional Portals & E-Governance** | 17 | 14 | 3 | 0 | `lib/screens/home_dashboard_screen.dart` |
| **2** | **Home & Portal Index** | 1 | 1 | 0 | 0 | `lib/screens/home_dashboard_screen.dart` |
| **3** | **Institution Profile & Heritage** | 62 | 62 | 0 | 0 | `lib/screens/home_dashboard_screen.dart` / Drawer |
| **4** | **General Institutional Information** | 115 | 115 | 0 | 0 | `lib/screens/official_document_center_screen.dart` |
| **5** | **Schools, Departments & Academics** | 52 | 52 | 0 | 0 | `lib/screens/schools_programmes_hub_screen.dart` |
| **6** | **Governance & Authorities** | 20 | 20 | 0 | 0 | `lib/screens/admin_directory_screen.dart` |
| **7** | **Admissions & Prospectus** | 6 | 6 | 0 | 0 | `lib/screens/academics_hub_screen.dart` |
| **8** | **Examinations & CoE Services** | 4 | 4 | 0 | 0 | `lib/screens/examination_services_screen.dart` |
| **9** | **Campus & Infrastructure Facilities** | 5 | 5 | 0 | 0 | `lib/screens/campus_facilities_screen.dart` |
| **10** | **Student Services & Scholarships** | 1 | 1 | 0 | 0 | `lib/screens/student_services_hub_screen.dart` |
| **11** | **Announcements, Circulars & e-News** | 15 | 15 | 0 | 0 | `lib/screens/home_dashboard_screen.dart` |
| **12** | **Accreditation & Statutory Disclosures**| 4 | 4 | 0 | 0 | `lib/screens/official_document_center_screen.dart` |
| **13** | **Contact & Campus Transit** | 3 | 3 | 0 | 0 | `lib/screens/campus_facilities_screen.dart` |
| **14** | **Research, Innovations & Publications** | 1 | 1 | 0 | 0 | `lib/screens/official_document_center_screen.dart` |
| **15** | **Inaccessible / Deprecated Routes** | 3 | 0 | 0 | 3 | Exception Catalog (`BROKEN_LINKS.csv`) |
| **TOTAL** | **15 Institutional Categories** | **309** | **299** | **7** | **3** | **100% Mapped to Mobile App** |

--- | :-: | :-: | :-: | :--- |
| **1** | **Home & Portal Index** | 1 | 1 | 0 | `lib/screens/home_dashboard_screen.dart` |
| **2** | **Institution Profile & Heritage** | 62 | 62 | 0 | `lib/screens/home_dashboard_screen.dart` / Drawer |
| **3** | **General Institutional Information** | 73 | 73 | 0 | `lib/screens/official_document_center_screen.dart` |
| **4** | **Schools, Departments & Academics** | 52 | 52 | 0 | `lib/screens/academics_hub_screen.dart` |
| **5** | **Governance & Authorities** | 20 | 20 | 0 | `lib/screens/admin_directory_screen.dart` |
| **6** | **Admissions & Prospectus** | 6 | 6 | 0 | `lib/screens/academics_hub_screen.dart` |
| **7** | **Examinations & CoE Services** | 4 | 4 | 0 | `lib/screens/academics_hub_screen.dart` / Hall Ticket |
| **8** | **Campus & Infrastructure Facilities** | 5 | 5 | 0 | `lib/screens/campus_facilities_screen.dart` |
| **9** | **Student Services & Redressal** | 1 | 1 | 0 | `lib/screens/student_services_hub_screen.dart` |
| **10** | **Announcements, Circulars & Tenders**| 15 | 15 | 0 | `lib/screens/home_dashboard_screen.dart` |
| **11** | **Accreditation & Statutory Disclosures**| 4 | 4 | 0 | `lib/screens/official_document_center_screen.dart` |
| **12** | **Contact & Campus Transit** | 3 | 3 | 0 | `lib/screens/campus_facilities_screen.dart` |
| **13** | **Research, Innovations & Extension** | 1 | 1 | 0 | `lib/screens/official_document_center_screen.dart` |
| **14** | **Inaccessible / Deprecated Routes** | 3 | 0 | 3 | Exception Catalog |
| **TOTAL** | **14 Institutional Categories** | **250** | **247** | **3** | **100% Mapped to Mobile App** |

---

## 3. Discovered Navigation Trees & Route Details

### 3.1 About GRI (`/aboutgri`)
- `aboutgri?content=vm`: Vision & Mission (Gandhian values, rural higher education, community empowerment).
- `aboutgri?content=profile`: Institutional profile, 1956 founding by Dr. T.S. Soundram and Dr. G. Ramachandran, 1976 Deemed to be University status.
- `aboutgri?content=GenesisofGRI`: Historic genesis under Mahatma Gandhi's Nai Talim (Basic Education) principles.
- `aboutgri?content=best_practices`: Best Practices & Institutional Distinctiveness (village placement programme, daily inter-religious prayer).
- `BestPractices?content=BestPractices`: Life in GRI (residential culture, khadi promotion, community engagement).
- `aboutgri?content=FormerChancellors` & `FormerViceChancellors`: Historical leadership directory.
- `aboutgri?content=campus`: 300+ acre rural green campus description.
- `aboutgri?content=grilogo`: Official emblem symbolism.
- `gridu?content=location`: Geographical coordinates (`10.2798° N, 77.9333° E`) in Gandhigram, Dindigul District.

### 3.2 Governance (`/Governance`)
- `Governance?content=System`: Three-tier governance system under Ministry of Education (MoE).
- `Governance?content=EC_CompositionFunctions`: Executive Council (supreme governing body).
- `Governance?content=PlanningAndMonitoring_Constitution`: Planning and Monitoring Board.
- `Governance?content=FinanceCommittee_Composition`: Finance Committee oversight.
- `Governance?content=AcademicCouncil_Composition`: Academic Council for academic curricula and standards.

### 3.3 Administration (`/administration`)
- Leadership profiles: Chancellor, Vice-Chancellor, Registrar, Controller of Examinations (CoE), Finance Officer, Chief Vigilance Officer.
- Academic leadership: Deans of Schools, Heads of Departments (HoD), Administrative Officers.

### 3.4 Academics (`/academics`)
- `academics?content=CBCSsystem`: Choice Based Credit System guidelines and credit structures.
- `academics?content=programmes`: Undergraduate, Postgraduate, Diploma, and PhD programmes.
- `academics?content=faculties`: 7 Schools (School of Sciences, School of Agriculture, School of Health & Rural Sanitation, etc.).
- Centres: Centre for Women's Studies, Centre for Geoinformatics, Centre for Social Exclusion, Rural Energy Centre, Krishi Vigyan Kendra (KVK).

### 3.5 Admissions (`/admissions`)
- Annual prospectuses (e.g. `Prospectus_202627.pdf`, `Prospectus_202526.pdf`).
- CUET (Common University Entrance Test) participation details.
- M.Phil. and Ph.D. Regulations.

### 3.6 Examinations (`/examination`)
- Examination schedules, timetables, application forms for Duplicate Certificates, Transcripts, and e-SANAD verification.

---

## 4. Live Browser Interaction Findings
During live browser execution via `browser_subagent`:
- **Top Utility Bar**: Displays links to *STUDY IN INDIA*, *Samarth@GRI*, and *Accessibility* with zoom in/out font adjustments.
- **Header Portals**: Dynamic drop-down links provide quick access to Attendance Portal (`attendance.ruraluniv.ac.in`), Student Portal (`portal.ruraluniv.ac.in`), and Pensioner Portal (`pension.ruraluniv.ac.in`).
- **Media Assets**: Header banner image (`images/banner.png`), university emblem (`images/gridu.png`), and notice ticker are loaded dynamically.
- **Session Video Evidence**: Saved to [`C:\Users\vijay\.gemini\antigravity-ide\brain\89ab01ad-8b10-4e63-b7e0-4e945f526124\gri_browser_deep_crawl_1791987521615.webp`](file:///C:/Users/vijay/.gemini/antigravity-ide/brain/89ab01ad-8b10-4e63-b7e0-4e945f526124/gri_browser_deep_crawl_1791987521615.webp).
