# Phase K — Website vs. Mobile Application Content Gap Analysis

## 1. Overview & Analysis Scope
This audit contrasts the **live web presence** of The Gandhigram Rural Institute ([https://ruraluniv.ac.in/home](https://ruraluniv.ac.in/home)) with the **existing Flutter mobile application** capabilities, highlighting information gaps, structural advantages, and future integration priorities.

---

## 2. Comparative Feature & Content Gap Matrix

| Institutional Domain | Official Website Content | Current Flutter Mobile Feature | Content Gap Status | Proposed Remediation in Phase 5 |
| :--- | :--- | :--- | :---: | :--- |
| **Institutional Governance** | Static HTML tables of EC, Planning Board, and Academic Council | `AdminDirectoryScreen` executive dossier cards | **Minimal Gap** | Connect directory cards to live institutional email/phone intent triggers. |
| **Academic Syllabi & CBCS** | 120+ individual department PDF links | `AcademicsHubScreen` with semester subject cards | **Medium Gap** | Integrate local PDF reader to open cataloged syllabi directly from in-app cache. |
| **Examination Hall Tickets** | Requires login to external student portal | In-app `HallTicketModal` with e-SANAD badge & QR | **Mobile Advantage** | App provides superior native rendering; connect QR code to live verification API. |
| **Admissions & Prospectus** | PDF downloads (`Prospectus_202627.pdf`, CUET guides) | `ApplicationStatusScreen` (admission tracking) | **Medium Gap** | Add in-app Prospectus booklet viewer and CUET eligibility calculator. |
| **Campus Infrastructure** | Static descriptions of library, health centre, hostels | `CampusFacilitiesScreen` with GPS coordinates & map toggle | **Mobile Advantage** | App provides one-touch Google Maps navigation and instant security dialer. |
| **Grievance Redressal** | Static PDF circular with UGC contact info | Interactive `StudentServicesHubScreen` filing form | **Mobile Advantage** | App provides interactive submission workflow and status badges (`RESOLVED`, `IN_REVIEW`). |
| **Notices & Circulars** | Web text marquee ticker with PDF links | Live Notice Card on `HomeDashboardScreen` | **Low Gap** | Implement background push notifications for newly published CoE circulars. |
| **Intranet OPAC Library** | Private LAN IP (`10.10.12.48`) OPAC updates | Library facility info tile | **Blocked by Network** | Provide intranet fallback banner notifying students to connect to campus Wi-Fi. |

---

## 3. High-Priority Remediation Priorities for Phase 5
1. **In-App PDF Viewer Integration**: Bundle lightweight PDF viewer for the 595 cataloged official documents in [`data/05_metadata/assets_manifest.csv`](file:///d:/current%20project/gri/data/05_metadata/assets_manifest.csv).
2. **Offline Syllabus Pack**: Package core semester syllabi for top enrolled programmes (MCA, M.Sc., B.Voc., B.Ed.) within the mobile app's local SQLite seed database.
3. **Automated Notice Ingestion**: Establish a lightweight cloud cron worker that checks `ruraluniv.ac.in/home` for new notices and updates the mobile application notice board.
