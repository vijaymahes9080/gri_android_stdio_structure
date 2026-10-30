# Page-by-Page Reverse Engineering Analysis: Component-Level Dissection

**Target Application:** `gri-updated`  
**Reference Domain:** `https://ruraluniv.ac.in`  
**Dissection Scope:** All 15 Discovered Page Clusters (309 Total Routes)  
**Analysis Level:** Header, Navigation, Hero, Body Layout, Data Grid/Tables, Forms, Media, Touch Ergonomics  

---

## 1. Structural Cluster Component Dissection

### Cluster 1: Home & Portal Entryway (1 Page)
- **Official Web Elements:**
  - Institutional Top Strip: Anti-Ragging helpline, e-SANAD link, RTI, NAAC grade banner.
  - Crest & Header: Gandhigram emblem, bilingual English/Tamil university title.
  - Mega Menu: 6 primary menu drop-downs (About, Academics, Admissions, Examinations, Research, Facilities).
  - Hero Slider: High-resolution campus photographs, convocations, village outreach.
  - Notice Ticker: Real-time scrolling flash text for circulars.
  - Vice-Chancellor Desk: Photo, title, welcome message.
  - Quick Cards: 8 icon-backed shortcuts (Admissions, Results, Prospectus, Fee Payment, Samarth, Library, Transport, KVK).
  - Footer: Contact switchboard, address, copyright, visitor counter.
- **Mobile Adaptation in `lib/screens/home_dashboard_screen.dart`:**
  - `GriTopBar`: Sticky 58dp bar with official crest, dark mode toggle, and role indicator.
  - `RoleSwitcherModal`: Seamless institutional persona switcher (Student, Faculty, Staff, Admin, Guest).
  - Card Grids: 2-column touch-friendly cards with 48x48dp touch targets and ripple ink response.
  - Interactive Carousel: Smooth 60fps horizontal paging slider with caption overlays.
  - Live Circulars List: Infinite scrollable list with instant detail sheet popup.

### Cluster 2: About GRI & Gandhian Heritage (62 Pages)
- **Official Web Elements:**
  - Long-form prose detailing the 1956 genesis, Nai Talim curriculum, rural upliftment.
  - Historical black-and-white photographs of Mahatma Gandhi and founders.
  - Constitutional mission statement and Gandhian peace philosophy.
- **Mobile Adaptation in `lib/screens/about_gri_heritage_screen.dart`:**
  - Collapsible timeline cards illustrating milestones from 1956 to Deemed University status (1976) and modern NAAC accreditation.
  - Styled quote callouts in Gandhian Ochre (`#B8860B`) and Forest Green (`#1B5E20`).
  - High-res asset integration with local fallbacks (`assets/images/grilogotya.jpg`).

### Cluster 3: Governance & Administration (20 Pages)
- **Official Web Elements:**
  - Leadership profiles (Chancellor, VC, Registrar, Finance Officer, Deans).
  - Statutory committee lists (Syndicate, Senate, Board of Studies).
  - PDF gazettes and notification orders.
- **Mobile Adaptation in `lib/screens/governance_leadership_screen.dart` & `admin_directory_screen.dart`:**
  - Executive leadership cards with verified portrait images (`chancellor_annamalai.jpg`, `vice_chancellor_panchanatham.jpg`, `registrar_marimuthu.jpg`).
  - One-tap dialer and email launcher buttons (`url_launcher`).
  - Filterable directory by School, Department, and Designation.

### Cluster 4: Schools, Departments & Academic Hub (52 Pages)
- **Official Web Elements:**
  - 8 school portals containing 24 academic departments.
  - Course curriculum tables, credit structures, faculty CV links.
- **Mobile Adaptation in `lib/screens/schools_programmes_hub_screen.dart` & `department_detail_screen.dart`:**
  - Segmented school selector tabs.
  - Expandable degree accordions (B.Sc., M.Sc., B.Voc., Ph.D.) displaying semester fees, eligibility, and intake capacity.
  - Syllabus previewer with PDF download actions.

### Cluster 5: Examinations & COE Services (49 Pages)
- **Official Web Elements:**
  - Exam timetable tables, fee portals, circular lists.
  - Application forms for duplicate marksheets, transcripts, migration.
- **Mobile Adaptation in `lib/screens/examination_services_screen.dart`:**
  - Integrated digital hall ticket generator with dynamic QR code verification (`qr_flutter`).
  - Tatkal scheme instructions card.
  - Download triggers for official forms bundled locally in `assets/official/documents/`.

### Cluster 6: Campus Facilities & Infrastructure (4 Pages)
- **Official Web Elements:**
  - Central Library book catalogue, Health Centre facilities, Hostels, Transport timetable.
- **Mobile Adaptation in `lib/screens/campus_facilities_screen.dart`:**
  - Interactive campus map with zoom, pan, and GPS coordinate tagging.
  - Live transport timetable with outbound bus routes to Dindigul, Madurai, and Batlagundu.
  - Emergency 24/7 ambulance and health center dispatch call actions.

### Cluster 7: Admissions & Prospectus (6 Pages)
- **Official Web Elements:**
  - Admission notification banners, download links for annual prospectus.
- **Mobile Adaptation in `lib/screens/admissions_prospectus_screen.dart`:**
  - Full-text interactive admission prospectus viewer for academic year 2026-27.
  - Course fee comparison matrix and step-by-step online application guide.

### Cluster 8: Official Document Center & Verification (15 Pages)
- **Official Web Elements:**
  - Public document verification lookup, circular download table.
- **Mobile Adaptation in `lib/screens/official_document_center_screen.dart` & `document_vault_screen.dart`:**
  - Document authenticity verification engine (validates cryptographic hashes of issued degrees and marksheets).
  - Categorized archive filter (Academic, Exam, Administration, Financial).

### Cluster 9: National Portals Gateway (17 Pages)
- **Official Web Elements:**
  - Outbound redirects to Samarth, UGC, DigiLocker, SWAYAM.
- **Mobile Adaptation in `lib/screens/official_portals_gateway_screen.dart`:**
  - Secure in-app or browser redirection with official portal branding tiles.

### Cluster 10: Smart Campus AI & Search (2 Pages)
- **Official Web Elements:**
  - Keyword search box.
- **Mobile Adaptation in `lib/screens/ask_gri_ai_screen.dart` & `global_website_search_screen.dart`:**
  - Natural-language query interface grounded in institutional dataset.
  - Instant live search with category badge chips and highlight matching.
