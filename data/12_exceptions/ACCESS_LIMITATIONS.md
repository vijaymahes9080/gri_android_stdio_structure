# Phase K — Access Limitations, Perimeter Boundaries & Exception Catalog

## 1. Perimeter Boundaries & Policy
During the discovery and data acquisition of the official website of **The Gandhigram Rural Institute (Deemed to be University)** ([https://ruraluniv.ac.in/home](https://ruraluniv.ac.in/home)), strict compliance with cybersecurity ethics, privacy, and non-negotiable boundaries was maintained:
- **Zero Authentication Bypass**: No attempts were made to bypass CAPTCHAs, brute-force student/staff portals (`portal.ruraluniv.ac.in`, `attendance.ruraluniv.ac.in`), or harvest restricted student grade records.
- **Rate-Limiting Politeness**: Automated crawlers and browser subagents operated with minimum 500ms intervals between page requests to prevent server strain on institutional infrastructure.
- **Zero Secret Ingestion**: No cookies, session tokens, or API credentials were stored.

---

## 2. Identified Access Limitations & Resolutions

### 2.1 Private Campus Intranet IP Subnets
- **Observed URL**: `http://10.10.12.48/opac-tmpl/gril_current_update/grilibtoday.pdf`
- **Issue**: The resource points to an internal Class-A RFC 1918 private IPv4 subnet (`10.10.12.48`), which is physically routed only within the GRI campus LAN / Wi-Fi network.
- **Resolution**: Categorized as `RESTRICTED_LAN_ONLY` in [`data/10_quality_assurance/MISSING_OR_UNAVAILABLE_ASSETS.csv`](file:///d:/current%20project/gri/data/10_quality_assurance/MISSING_OR_UNAVAILABLE_ASSETS.csv). Not flagged as a data pipeline error.

### 2.2 External Government & Accreditation Portals
- **Observed Links**:
  - `https://ruraluniv.samarth.ac.in/` (Govt. of India Samarth Portal)
  - `https://www.studyinindia.gov.in/` (Ministry of Education Study in India)
  - `https://cuet.samarth.ac.in/` (NTA CUET Entrance Portal)
  - `https://webmail.ruraluniv.ac.in/` (GRI Staff Webmail)
- **Scope Boundary**: These represent external third-party or dedicated secure subdomains. They are cataloged as external references in [`data/02_page_inventory/all_pages.csv`](file:///d:/current%20project/gri/data/02_page_inventory/all_pages.csv) without recursively downloading external domains.

### 2.3 Legacy PHP Query Routing
- **Observed Route Structure**: The website utilizes a single-entry PHP routing pattern (`page.php?content=<identifier>`).
- **Resolution**: Normalized using URL sanitizers to ensure deterministic page IDs and file paths across `data/03_page_content/` without character collision.

### 2.4 Server-Side Inaccessible Links (HTTP 404 / 500)
- `https://ruraluniv.ac.in/cell?content=cika` (HTTP 404 - Broken internal navigation link)
- `https://ruraluniv.ac.in/includes/griims/app/login` (Connection refused - Deprecated 2018 portal)
- Both instances are documented in [`data/10_quality_assurance/BROKEN_LINKS.csv`](file:///d:/current%20project/gri/data/10_quality_assurance/BROKEN_LINKS.csv).
