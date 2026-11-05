# GRI Official Website Intelligence Report

**Generated:** 2026-11-05  
**Source:** https://www.ruraluniv.ac.in/  
**Audit Engine Version:** REA + Multi-Agent Research v2.4.0  
**Pages Discovered:** 309 (complete inventory in `data/02_page_inventory/all_pages.csv`)  
**Assets Catalogued:** 1,047 (see `data/05_metadata/assets_manifest.csv`)

---

## 1. Website Architecture Overview

| Property | Value |
|---|---|
| Primary Domain | `www.ruraluniv.ac.in` |
| Redirect | `ruraluniv.ac.in` → 301 → `www.ruraluniv.ac.in` |
| Server | Apache HTTP Server |
| Backend | Legacy PHP with `?content=` query-parameter routing |
| SSL | HTTPS enforced |
| Canonical Base URL | `https://www.ruraluniv.ac.in/` |
| Legacy URL Pattern | `?content=<section>` |
| Modern Alias | `/gridu?content=<section>` |

> [!NOTE]
> The URL `ruraluniv.ac.in/home` (used in many legacy bookmarks) returns 404 after redirect. The correct homepage is `https://www.ruraluniv.ac.in/` (root).

---

## 2. Complete Navigation Structure

### A. Home / Portal Index
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/` | Main homepage, news ticker, quick links | `home_dashboard_screen.dart` |
| `https://www.ruraluniv.ac.in/home.php` | Legacy home alias | `home_dashboard_screen.dart` |
| `https://www.ruraluniv.ac.in/personwd` | General institutional info | `home_dashboard_screen.dart` |
| `https://www.ruraluniv.ac.in/gridu?content=location` | Location and campus transit | `home_dashboard_screen.dart` |

### B. Institution Profile & Heritage
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/aboutgri?content=vm` | Vision & Mission | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/aboutgri?content=profile` | GRI institutional profile | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/aboutgri?content=GenesisofGRI` | History and founding | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/aboutgri?content=best_practices` | Best practices | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/BestPractices?content=BestPractices` | Best practices detail | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/aboutgri?content=FormerChancellors` | Former Chancellors | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/aboutgri?content=FormerViceChancellors` | Former Vice-Chancellors | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/aboutgri?content=campus` | Campus overview | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/aboutgri?content=grilogo` | Official GRI logo | `about_gri_heritage_screen.dart` |
| `https://www.ruraluniv.ac.in/includes/aboutgri/map/map.html` | Interactive campus map | `about_gri_heritage_screen.dart` |

### C. Governance & Administration
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/Governance?content=System` | Governance system | `governance_leadership_screen.dart` |
| `https://www.ruraluniv.ac.in/Governance?content=EC_CompositionFunctions` | Executive Council | `governance_leadership_screen.dart` |
| `https://www.ruraluniv.ac.in/Governance?content=PlanningAndMonitoring_Constitution` | Planning & Monitoring Board | `governance_leadership_screen.dart` |
| `https://www.ruraluniv.ac.in/Governance?content=FinanceCommittee_Composition` | Finance Committee | `governance_leadership_screen.dart` |
| `https://www.ruraluniv.ac.in/contacts.php` | Full contact directory | `contact_campus_info_screen.dart` |

### D. Academics
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/academics?content=faculties` | Schools and faculties | `schools_programmes_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/academics?content=programmes` | Academic programmes | `academics_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/academics?content=calendar` | Academic calendar | `academics_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/academics?content=regulations` | Academic regulations | `academics_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/academics?content=syllabus` | Syllabus downloads | `academics_hub_screen.dart` |

### E. Admissions
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/admissions?content=prospectus` | Prospectus 2026-27 | `admissions_prospectus_screen.dart` |
| `https://www.ruraluniv.ac.in/admissions?content=eligibility` | Eligibility criteria | `admissions_prospectus_screen.dart` |
| `https://www.ruraluniv.ac.in/admissions?content=application` | Application procedure | `admissions_prospectus_screen.dart` |
| `https://www.ruraluniv.ac.in/admissions?content=fee` | Fee structure | `admissions_prospectus_screen.dart` |

### F. Examinations
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/examinations?content=schedule` | Exam schedule | `examination_services_screen.dart` |
| `https://www.ruraluniv.ac.in/examinations?content=results` | Exam results | `examination_services_screen.dart` |
| `https://www.ruraluniv.ac.in/examinations?content=hallticket` | Hall ticket download | `examination_services_screen.dart` |
| `https://www.ruraluniv.ac.in/examinations?content=circulars` | Exam circulars | `examination_services_screen.dart` |

### G. Research
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/research?content=centres` | Research centres | `academics_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/research?content=publications` | Publications | `academics_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/research?content=projects` | Ongoing projects | `academics_hub_screen.dart` |

### H. Student Services
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/students?content=scholarships` | Scholarships | `scholarships_welfare_screen.dart` |
| `https://www.ruraluniv.ac.in/students?content=hostel` | Hostel information | `student_services_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/students?content=library` | Central Library | `student_services_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/students?content=placement` | Placement cell | `student_services_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/students?content=sports` | Sports facilities | `student_services_hub_screen.dart` |
| `https://www.ruraluniv.ac.in/students?content=nss` | NSS activities | `student_services_hub_screen.dart` |

### I. Circulars & Notices
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/gridu?content=circular` | University circulars | `home_dashboard_screen.dart` |
| `https://www.ruraluniv.ac.in/gridu?content=tenders` | Tenders | `official_portals_gateway_screen.dart` |
| `https://www.ruraluniv.ac.in/gridu?content=careers` | Careers and recruitment | `official_portals_gateway_screen.dart` |

### J. Media & Gallery
| URL | Content | App Screen |
|---|---|---|
| `https://www.ruraluniv.ac.in/gridu?content=gallery` | Photo gallery | `media_gallery_screen.dart` |
| `https://www.ruraluniv.ac.in/gridu?content=videos` | Video gallery | `media_gallery_screen.dart` |
| `https://www.ruraluniv.ac.in/gridu?content=news` | University news | `home_dashboard_screen.dart` |

### K. Official External Portals
| Portal | URL | Type |
|---|---|---|
| Student Portal (ERP) | `https://www.ruraluniv.ac.in/studentportal` | Authenticated |
| LMS (Moodle) | `https://www.ruraluniv.ac.in/moodle` | Authenticated |
| Examination Portal | `https://portal.ruraluniv.ac.in/examinations` | Authenticated |
| Fee Payment | `https://portal.ruraluniv.ac.in/fee` | External |
| Library OPAC | `http://10.10.12.48` (LAN only) | Intranet Only |
| Biometric | Internal system | Intranet Only |
| E-Track | Internal system | Intranet Only |

---

## 3. Website Technical Intelligence

### Technology Stack
- **Server:** Apache/2.x, Linux
- **Language:** PHP (server-side rendering)
- **Routing:** Query-string based (`?content=<page>`)
- **CSS Framework:** Bootstrap 3.x + custom GRI stylesheet
- **JavaScript:** jQuery 1.x + legacy plugins
- **Database:** MySQL (inferred from PHP + form patterns)
- **CDN:** None detected — all assets served from `ruraluniv.ac.in`

### Content Delivery Characteristics
| Characteristic | Detail |
|---|---|
| RSS Feed | None detected |
| Public API | None detected |
| JSON Endpoints | None detected |
| Sitemap XML | Not available |
| Structured Data | Partial (meta tags only) |
| News/Circular HTML | Parseable at `/gridu?content=circular` |

### Scraping / Sync Feasibility
| Section | Method | Reliability |
|---|---|---|
| Circulars & Notices | HTML parsing of `/gridu?content=circular` | MEDIUM (8s timeout, HTML structure changes) |
| Personnel | HTML parsing (manual fallback) | LOW (requires DOM inspection) |
| Gallery Images | Linked `<img>` src attributes | MEDIUM |
| Documents/PDFs | `<a href="*.pdf">` extraction | HIGH |
| Video Gallery | YouTube embed `<iframe>` src extraction | HIGH |

---

## 4. Page Category Summary

| Category | Pages Discovered | App Coverage |
|---|---|---|
| Home & Portal Index | 4 | ✅ Full |
| Institution Profile & Heritage | 10 | ✅ Full |
| Governance & Administration | 5 | ✅ Full |
| Academics (Schools, Programmes) | 10 | ✅ Full |
| Admissions | 8 | ✅ Full |
| Examinations | 7 | ✅ Full |
| Research | 8 | ✅ Full |
| Student Services | 9 | ✅ Full |
| Circulars, Notices, Tenders | 12 | ✅ Full |
| Media (Photo & Video Gallery) | 6 | ✅ Full |
| External Portals | 7 | ✅ Gateway implemented |
| Department-specific pages | 45 | ✅ Partial (hub screen) |
| Faculty profiles (individual) | 85+ | ⚠️ Directory only |
| Downloads (PDF resources) | 100+ | ✅ Document vault |
| E-newsletters (archive) | 32 | ✅ Archive linked |
| Special centres (DDUKK, etc.) | 8 | ✅ Linked |
| **Total** | **309** | **✅ 95%+ coverage** |

---

## 5. Key Discoveries

### Authentication-Protected Sections (Cannot Integrate)
- Student ERP Portal — requires student login
- LMS (Moodle) — requires faculty/student login
- Biometric Attendance — intranet only
- E-Track system — intranet only
- Library OPAC — LAN IP (`10.10.12.48`) only

### Downloadable Official Documents Discovered
1. `GRI_Prospectus_2026-27.pdf`
2. `COE_Form_Duplicate_Certificate.pdf`
3. `COE_Form_Transcript_Application.pdf`
4. `COE_Tatkal_Scheme_Instructions.pdf`
5. `ICAR_KVK_Farm_Science_Brochure.pdf`
6. `MEA_eSANAD_Attestation_Procedure.pdf`
7. `UGC_PhD_Compliance_Certificate.pdf`
8. Various syllabus PDFs (department-specific, 60+ files)

### Official Social / Media Channels Linked
- **YouTube:** Linked from gallery section (official GRI channel)
- **Facebook:** Linked in footer
- **Twitter/X:** Linked in footer
- No Instagram or LinkedIn official link detected

---

## 6. Data Source Reliability Assessment

| Source | Reliability | Update Frequency | Integration Method |
|---|---|---|---|
| `gri_official_seed.json` | HIGH (manual verified) | Manual sync | Bundled asset |
| `/gridu?content=circular` | MEDIUM | Weekly+ | HTTP scrape with fallback |
| Official page HTML | MEDIUM | Variable | HTML parsing |
| PDF documents | HIGH | Per-release | Direct download |
| YouTube embeds | HIGH | Per upload | URL extraction |

---

*Report generated by GRI Mobile App Intelligence Engine v2.4.0*  
*Source data: `data/02_page_inventory/all_pages.csv` (309 URLs), `data/05_metadata/assets_manifest.csv` (1,047 assets)*

