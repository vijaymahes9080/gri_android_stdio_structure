# Institutional Asset & Resource Mapping Report: `gri-updated`

**Application Target:** `gri-updated` (`com.aistudio.grist.kxmpzq`)  
**Resource Audit Date:** 2026-10-30  
**Integrity Rule:** Zero fabricated URLs, zero stock placeholders, zero broken assets.  

---

## 1. Asset Registry Breakdown

| Category | Count | Storage Path | Verification Status | Integrity Check |
|---|:---:|---|:---:|---|
| PNG Graphics & Emblems | 10 | `assets/images/`, `assets/official/icons/` | VERIFIED | Official institutional crests, portal banners, navigation icons |
| High-Res JPEG Visuals | 10 | `assets/images/`, `assets/official/images/` | VERIFIED | Leadership portraits, campus landmarks, student avatars |
| Official PDF Publications | 7 | `assets/official/documents/` | VERIFIED | Prospectus 2026-27, COE transcript applications, eSANAD guides |
| JSON Metadata & Catalogs | 3 | `assets/`, `assets/data/`, `assets/official/metadata/` | VERIFIED | 309-page crawler index, official institutional seed repository |

---

## 2. Resource-to-Screen Mapping Matrix

### 2.1 Photographic & Identity Assets
1. **`assets/official/images/gri_official_crest.jpg` (and `gridtbu_logo.png`):**
   - **Target:** `GriTopBar`, `GriSplashScreen`, `GriUniversityDrawer`.
   - **Purpose:** Primary university crest and emblem.
2. **`assets/official/images/chancellor_annamalai.jpg`:**
   - **Target:** `GovernanceLeadershipScreen`, `AdminDirectoryScreen`.
   - **Purpose:** Portrait of Hon'ble Chancellor Shri K.M. Annamalai.
3. **`assets/official/images/vice_chancellor_panchanatham.jpg`:**
   - **Target:** `HomeDashboardScreen`, `GovernanceLeadershipScreen`.
   - **Purpose:** Portrait of Vice-Chancellor Prof. S. Panchanatham.
4. **`assets/official/images/registrar_marimuthu.jpg`:**
   - **Target:** `GovernanceLeadershipScreen`, `AdminDirectoryScreen`.
   - **Purpose:** Portrait of Registrar Dr. C. Marimuthu.
5. **`assets/images/library_front.jpg`:**
   - **Target:** `CampusFacilitiesScreen` (Central Library tab).
   - **Purpose:** Dr. Radhakrishnan Central Library building photo.
6. **`assets/images/health_centre.jpg`:**
   - **Target:** `CampusFacilitiesScreen` (Health Centre tab).
   - **Purpose:** University 24/7 Health Centre and dispensary photo.
7. **`assets/official/images/gri_admin_block.png`:**
   - **Target:** `HomeDashboardScreen`, `AboutGriHeritageScreen`.
   - **Purpose:** Iconic administrative building and Gandhi statue.

### 2.2 Official PDF Documents & Forms
1. **`assets/official/documents/GRI_Prospectus_2026-27.pdf`:**
   - **Target:** `AdmissionsProspectusScreen`.
   - **Purpose:** Complete 84-page academic prospectus with eligibility matrices.
2. **`assets/official/documents/COE_Form_Transcript_Application.pdf`:**
   - **Target:** `ExaminationServicesScreen`.
   - **Purpose:** Official application for academic transcripts.
3. **`assets/official/documents/COE_Form_Duplicate_Certificate.pdf`:**
   - **Target:** `ExaminationServicesScreen`.
   - **Purpose:** Loss of degree certificate affidavit & application.
4. **`assets/official/documents/COE_Tatkal_Scheme_Instructions.pdf`:**
   - **Target:** `ExaminationServicesScreen`.
   - **Purpose:** Emergency Tatkal examination certificate delivery instructions.
5. **`assets/official/documents/MEA_eSANAD_Attestation_Procedure.pdf`:**
   - **Target:** `OfficialDocumentCenterScreen`.
   - **Purpose:** Ministry of External Affairs degree verification workflow.
6. **`assets/official/documents/UGC_PhD_Compliance_Certificate.pdf`:**
   - **Target:** `DocumentVaultScreen`.
   - **Purpose:** UGC 2009/2016 Ph.D. regulations compliance template.
7. **`assets/official/documents/ICAR_KVK_Farm_Science_Brochure.pdf`:**
   - **Target:** `SchoolsProgrammesHubScreen`.
   - **Purpose:** Farm Science Centre / Krishi Vigyan Kendra extension guide.
