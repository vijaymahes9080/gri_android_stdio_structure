import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/academic_models.dart';

class SchoolItem {
  final String id;
  final String name;
  final String dean;
  final String deanEmail;
  final String deanPhone;
  final int programmesCount;
  final String highlights;

  SchoolItem({
    required this.id,
    required this.name,
    required this.dean,
    required this.deanEmail,
    required this.deanPhone,
    required this.programmesCount,
    required this.highlights,
  });

  factory SchoolItem.fromJson(Map<String, dynamic> json) {
    return SchoolItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dean: json['dean'] ?? '',
      deanEmail: json['dean_email'] ?? '',
      deanPhone: json['dean_phone'] ?? '',
      programmesCount: json['programmes_count'] ?? 0,
      highlights: json['highlights'] ?? '',
    );
  }
}

class DepartmentItem {
  final String id;
  final String schoolId;
  final String name;
  final String hod;
  final String hodEmail;
  final String hodPhone;
  final String establishedYear;
  final List<String> programmesOffered;
  final String researchAreas;

  DepartmentItem({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.hod,
    required this.hodEmail,
    required this.hodPhone,
    required this.establishedYear,
    required this.programmesOffered,
    required this.researchAreas,
  });

  factory DepartmentItem.fromJson(Map<String, dynamic> json) {
    return DepartmentItem(
      id: json['id'] ?? '',
      schoolId: json['school_id'] ?? '',
      name: json['name'] ?? '',
      hod: json['hod'] ?? '',
      hodEmail: json['hod_email'] ?? '',
      hodPhone: json['hod_phone'] ?? '',
      establishedYear: json['established_year']?.toString() ?? '',
      programmesOffered: (json['programmes_offered'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      researchAreas: json['research_areas'] ?? '',
    );
  }
}

class ProgrammeItem {
  final String id;
  final String departmentId;
  final String name;
  final String degree;
  final String duration;
  final int intake;
  final String eligibility;
  final String feePerSemester;

  ProgrammeItem({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.degree,
    required this.duration,
    required this.intake,
    required this.eligibility,
    required this.feePerSemester,
  });

  factory ProgrammeItem.fromJson(Map<String, dynamic> json) {
    return ProgrammeItem(
      id: json['id'] ?? '',
      departmentId: json['department_id'] ?? '',
      name: json['name'] ?? '',
      degree: json['degree'] ?? '',
      duration: json['duration'] ?? '',
      intake: json['intake'] ?? 0,
      eligibility: json['eligibility'] ?? '',
      feePerSemester: json['fee_per_semester']?.toString() ?? '',
    );
  }
}

class FacilityItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final String location;
  final String inCharge;
  final String timings;

  FacilityItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    required this.inCharge,
    required this.timings,
  });

  factory FacilityItem.fromJson(Map<String, dynamic> json) {
    return FacilityItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      inCharge: json['in_charge'] ?? '',
      timings: json['timings'] ?? '',
    );
  }
}

class SeedDataService {
  static SeedDataService? _instance;
  static SeedDataService get instance => _instance ??= SeedDataService._();
  SeedDataService._();

  bool _isLoaded = false;
  Map<String, dynamic> _rawJson = {};
  List<SchoolItem> schools = [];
  List<DepartmentItem> departments = [];
  List<ProgrammeItem> programmes = [];
  List<FacilityItem> facilities = [];
  List<Map<String, dynamic>> examinations = [];
  List<Map<String, dynamic>> documents = [];
  List<Map<String, dynamic>> contacts = [];

  Future<void> loadSeedData() async {
    if (_isLoaded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/gri_official_seed.json');
      _rawJson = json.decode(jsonStr) as Map<String, dynamic>;

      if (_rawJson.containsKey('schools')) {
        schools = (_rawJson['schools'] as List)
            .map((e) => SchoolItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (_rawJson.containsKey('departments')) {
        departments = (_rawJson['departments'] as List)
            .map((e) => DepartmentItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (_rawJson.containsKey('programmes')) {
        programmes = (_rawJson['programmes'] as List)
            .map((e) => ProgrammeItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (_rawJson.containsKey('facilities')) {
        facilities = (_rawJson['facilities'] as List)
            .map((e) => FacilityItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (_rawJson.containsKey('examinations')) {
        examinations = List<Map<String, dynamic>>.from(_rawJson['examinations']);
      }

      if (_rawJson.containsKey('documents')) {
        documents = List<Map<String, dynamic>>.from(_rawJson['documents']);
      }

      if (_rawJson.containsKey('contacts')) {
        contacts = List<Map<String, dynamic>>.from(_rawJson['contacts']);
      }

      _isLoaded = true;
    } catch (e) {
      // Fallback in case of asset bundling issues during early test
      _initFallbacks();
      _isLoaded = true;
    }
  }

  static List<SchoolModel> getOfficialSchools() {
    return [
      SchoolModel(
        id: "sch_sci",
        name: "School of Sciences",
        dean: "Dr. S. Kanthimathinathan",
        deanEmail: "dean_sciences@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 201",
        programmesCount: 16,
        highlights: "DST-FIST Supported Labs, Central NMR & XRD Facility",
        departments: [
          DepartmentModel(
            id: "dept_math",
            name: "Department of Mathematics",
            hod: "Dr. P. S. Srinivasan",
            hodEmail: "hod_math@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["M.Sc. Mathematics", "Ph.D."],
            researchAreas: "Fluid Dynamics, Graph Theory",
          ),
        ],
      ),
      SchoolModel(
        id: "sch_agri",
        name: "School of Agriculture and Animal Sciences",
        dean: "Dr. K. S. Pushpa",
        deanEmail: "dean_agri@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 202",
        programmesCount: 9,
        highlights: "ICAR Accredited B.Sc. (Hons.) Agriculture",
        departments: [
          DepartmentModel(
            id: "dept_agri_sci",
            name: "Department of Agriculture",
            hod: "Dr. M. Seethalakshmi",
            hodEmail: "hod_agri@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["B.Sc. (Hons) Agriculture"],
            researchAreas: "Organic Farming",
          ),
        ],
      ),
      SchoolModel(
        id: "sch_health",
        name: "School of Rural Health and Sanitation",
        dean: "Dr. M. G. Sethuraman",
        deanEmail: "dean_health@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 203",
        programmesCount: 7,
        highlights: "WHO Collaborating Partner",
        departments: [
          DepartmentModel(
            id: "dept_health",
            name: "Department of Applied Health and Sanitation",
            hod: "Dr. G. Muralidharan",
            hodEmail: "hod_health@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["Diploma in Sanitary Inspection"],
            researchAreas: "Community Hygiene",
          ),
        ],
      ),
      SchoolModel(
        id: "sch_socsci",
        name: "School of Social Sciences",
        dean: "Dr. P. Anandharajakumar",
        deanEmail: "dean_socsci@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 204",
        programmesCount: 14,
        highlights: "Nai Talim Village Internship",
        departments: [
          DepartmentModel(
            id: "dept_socsci",
            name: "Department of Rural Development",
            hod: "Dr. K. Sadasivam",
            hodEmail: "hod_socsci@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["M.A. Rural Development", "MSW"],
            researchAreas: "Panchayati Raj",
          ),
        ],
      ),
      SchoolModel(
        id: "sch_tamil",
        name: "School of Tamil, Indian Languages and Rural Arts",
        dean: "Dr. M. Kuruvammal",
        deanEmail: "dean_tamil@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 205",
        programmesCount: 10,
        highlights: "Classical Tamil Palm-leaf Archives",
        departments: [
          DepartmentModel(
            id: "dept_tamil",
            name: "Department of Tamil",
            hod: "Dr. O. Muthiah",
            hodEmail: "hod_tamil@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["M.A. Tamil"],
            researchAreas: "Folk Literature",
          ),
        ],
      ),
      SchoolModel(
        id: "sch_english",
        name: "School of English & Foreign Languages",
        dean: "Dr. S. Senthilnathan",
        deanEmail: "dean_english@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 206",
        programmesCount: 6,
        highlights: "Modern Digital Language Lab",
        departments: [
          DepartmentModel(
            id: "dept_english",
            name: "Department of English",
            hod: "Dr. P. Jeyappraba",
            hodEmail: "hod_english@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["M.A. English"],
            researchAreas: "ELT",
          ),
        ],
      ),
      SchoolModel(
        id: "sch_mgmt",
        name: "School of Management Studies",
        dean: "Dr. S. B. Inayath Ahamed",
        deanEmail: "dean_mgmt@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 207",
        programmesCount: 8,
        highlights: "MBA Rural Management",
        departments: [
          DepartmentModel(
            id: "dept_mgmt",
            name: "Department of Rural Management",
            hod: "Dr. B. Subburaj",
            hodEmail: "hod_mgmt@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["MBA Rural Management"],
            researchAreas: "Agri-marketing",
          ),
        ],
      ),
      SchoolModel(
        id: "sch_cs",
        name: "School of Computer Science & Technologies",
        dean: "Dr. K. Somasundaram",
        deanEmail: "dean_cs@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 208",
        programmesCount: 11,
        highlights: "High Performance Computing Lab",
        departments: [
          DepartmentModel(
            id: "dept_cs",
            name: "Department of Computer Applications",
            hod: "Dr. P. Shanmugavadivu",
            hodEmail: "hod_cs@ruraluniv.ac.in",
            contact: "+91 451 2452371",
            programmes: ["MCA", "M.Sc. IT"],
            researchAreas: "AI & Image Processing",
          ),
        ],
      ),
    ];
  }

  static List<LeadershipOfficerModel> getOfficialLeadership() {
    return [
      LeadershipOfficerModel(
        id: "ldr_chancellor",
        name: "Dr. KM. Annamalai",
        designation: "Honorable Chancellor",
        email: "chancellor@ruraluniv.ac.in",
        phone: "+91 451 2452371",
        portfolio: "Head of Institution",
        officeLocation: "Chancellor Secretariat",
      ),
      LeadershipOfficerModel(
        id: "ldr_vc",
        name: "Prof. Dr. N. Panchanatham",
        designation: "Vice-Chancellor",
        email: "vc@ruraluniv.ac.in",
        phone: "+91 451 2452305",
        portfolio: "Chief Academic & Executive Officer",
        officeLocation: "Vice-Chancellor Block",
      ),
      LeadershipOfficerModel(
        id: "ldr_registrar",
        name: "Dr. K. Marimuthu",
        designation: "Registrar",
        email: "registrar@ruraluniv.ac.in",
        phone: "+91 451 2452371 Ext: 102",
        portfolio: "Custodian of University Records",
        officeLocation: "Administrative Block",
      ),
      LeadershipOfficerModel(
        id: "ldr_coe",
        name: "Dr. V. Sivakumar",
        designation: "Controller of Examinations",
        email: "coe@ruraluniv.ac.in",
        phone: "+91 451 2452371 Ext: 104",
        portfolio: "End Semester Exams",
        officeLocation: "Examination Building",
      ),
      LeadershipOfficerModel(
        id: "ldr_fo",
        name: "Dr. K. Ravichandran",
        designation: "Finance Officer",
        email: "fo@ruraluniv.ac.in",
        phone: "+91 451 2452371 Ext: 106",
        portfolio: "University Budget",
        officeLocation: "Finance Wing",
      ),
      LeadershipOfficerModel(
        id: "ldr_cvo",
        name: "Dr. P. Balasubramaniam",
        designation: "Chief Vigilance Officer",
        email: "cvo@ruraluniv.ac.in",
        phone: "+91 451 2452371 Ext: 108",
        portfolio: "Institutional Vigilance",
        officeLocation: "Vigilance Cell",
      ),
      LeadershipOfficerModel(
        id: "ldr_rdc",
        name: "Dr. S. Meenakshi",
        designation: "Director, RDC",
        email: "rdc@ruraluniv.ac.in",
        phone: "+91 451 2452371 Ext: 112",
        portfolio: "Research Grants & IPR",
        officeLocation: "RDC Complex",
      ),
      LeadershipOfficerModel(
        id: "ldr_iqac",
        name: "Dr. P. U. Mahalingam",
        designation: "Director, IQAC",
        email: "iqac@ruraluniv.ac.in",
        phone: "+91 451 2452371 Ext: 114",
        portfolio: "Quality Benchmark Assessment",
        officeLocation: "IQAC Directorate",
      ),
    ];
  }

  static List<OfficialDownloadModel> getOfficialDownloads() {
    return [
      OfficialDownloadModel(id: "d1", title: "Prospectus 2026-27", category: "Admissions", fileUrl: "https://ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf", authority: "Admissions Directorate", instructions: "Official Prospectus"),
      OfficialDownloadModel(id: "d2", title: "Prospectus 2025-26", category: "Admissions", fileUrl: "https://ruraluniv.ac.in/includes/admissions/2025/pdf/Prospectus_202526.pdf", authority: "Admissions Directorate", instructions: "Archive Prospectus"),
      OfficialDownloadModel(id: "d3", title: "Transcript Application", category: "Examinations", fileUrl: "https://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf", authority: "COE", instructions: "Form 01"),
      OfficialDownloadModel(id: "d4", title: "Duplicate Certificate Form", category: "Examinations", fileUrl: "https://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf", authority: "COE", instructions: "Form 02"),
      OfficialDownloadModel(id: "d5", title: "Tatkal Scheme Instructions", category: "Examinations", fileUrl: "https://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf", authority: "COE", instructions: "Urgent scheme"),
      OfficialDownloadModel(id: "d6", title: "e-SANAD Guidelines", category: "Examinations", fileUrl: "https://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf", authority: "MEA", instructions: "Apostille"),
      OfficialDownloadModel(id: "d7", title: "PhD UGC Compliance Form", category: "Research", fileUrl: "https://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf", authority: "RDC", instructions: "Regulations"),
      OfficialDownloadModel(id: "d8", title: "KVK Farm Brochure", category: "Extension", fileUrl: "https://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf", authority: "ICAR", instructions: "Soil test"),
      OfficialDownloadModel(id: "d9", title: "CBCS Regulations Handbook", category: "Academics", fileUrl: "https://ruraluniv.ac.in/academics/cbcs.pdf", authority: "Academic Council", instructions: "Credits"),
      OfficialDownloadModel(id: "d10", title: "NAAC SSR Report Cycle 4", category: "IQAC", fileUrl: "https://ruraluniv.ac.in/gridu/naac_ssr.pdf", authority: "IQAC", instructions: "Accreditation"),
      OfficialDownloadModel(id: "d11", title: "NIRF Data Disclosure 2026", category: "Governance", fileUrl: "https://ruraluniv.ac.in/gri/nirf2026.pdf", authority: "Registrar", instructions: "NIRF"),
      OfficialDownloadModel(id: "d12", title: "Anti Ragging Code", category: "Student Welfare", fileUrl: "https://ruraluniv.ac.in/gridu/antiragging.pdf", authority: "DSW", instructions: "Affidavit"),
      OfficialDownloadModel(id: "d13", title: "Hostel Rules and Guidelines", category: "Student Welfare", fileUrl: "https://ruraluniv.ac.in/hostel/rules.pdf", authority: "Warden Council", instructions: "Mess and stay"),
      OfficialDownloadModel(id: "d14", title: "Library Membership Form", category: "Library", fileUrl: "https://ruraluniv.ac.in/library/membership.pdf", authority: "University Librarian", instructions: "Borrower card"),
      OfficialDownloadModel(id: "d15", title: "Scholarship Post-Matric Application", category: "Welfare", fileUrl: "https://ruraluniv.ac.in/scholarship/form.pdf", authority: "Scholarship Section", instructions: "SC ST SCC"),
      OfficialDownloadModel(id: "d16", title: "Convocation Registration Guidelines", category: "Examinations", fileUrl: "https://ruraluniv.ac.in/convocation/guidelines.pdf", authority: "COE", instructions: "In person degree"),
    ];
  }

  static List<StatutoryBodyModel> getStatutoryCouncils() {
    return [
      StatutoryBodyModel(id: "c1", name: "The Senate", role: "Supreme Advisory Body", frequency: "Annual", keyMembers: ["Chancellor", "VC", "Registrar"], legalProvision: "Section 18"),
      StatutoryBodyModel(id: "c2", name: "The Syndicate / Board of Management", role: "Principal Executive Organ", frequency: "Quarterly", keyMembers: ["VC", "MHRD Nominees", "Deans"], legalProvision: "Section 19"),
      StatutoryBodyModel(id: "c3", name: "The Academic Council", role: "Academic Policy & Curriculum", frequency: "Biannual", keyMembers: ["VC", "HODs", "Professors"], legalProvision: "Section 20"),
      StatutoryBodyModel(id: "c4", name: "The Finance Committee", role: "Budget and Accounts Approval", frequency: "Quarterly", keyMembers: ["VC", "Finance Officer", "UGC Nominee"], legalProvision: "Section 21"),
    ];
  }

  static List<ScholarshipItemModel> getScholarshipSchemes() {
    return [
      ScholarshipItemModel(id: "s1", name: "SC / ST / SCC Post-Matric Government Scholarship", beneficiary: "SC/ST/SCC Students", amount: "100% Tuition Fee", deadline: "31 Oct", officialNoticeUrl: "https://ruraluniv.ac.in/scholarship", eligibility: ["Annual income < 2.5 LPA"]),
      ScholarshipItemModel(id: "s2", name: "BC / MBC / DNC State Welfare Scholarship", beneficiary: "BC/MBC Students", amount: "Maintenance Fee", deadline: "15 Nov", officialNoticeUrl: "https://ruraluniv.ac.in/welfare", eligibility: ["State Domicile"]),
      ScholarshipItemModel(id: "s3", name: "Central Sector Merit Scholarship", beneficiary: "Top 20th Percentile", amount: "Rs 12,000 / year", deadline: "30 Nov", officialNoticeUrl: "https://scholarships.gov.in", eligibility: ["Merit ranking"]),
      ScholarshipItemModel(id: "s4", name: "Single Girl Child Indira Gandhi Scholarship", beneficiary: "PG Girl Students", amount: "Rs 36,200 / year", deadline: "31 Dec", officialNoticeUrl: "https://ugc.ac.in", eligibility: ["Only child"]),
      ScholarshipItemModel(id: "s5", name: "Differently Abled National Fellowship", beneficiary: "PwD Scholars", amount: "Monthly Stipend", deadline: "Rolling", officialNoticeUrl: "https://disabilityaffairs.gov.in", eligibility: ["40% Disability"]),
      ScholarshipItemModel(id: "s6", name: "GRI Merit-cum-Means Endowment Fund", beneficiary: "Economically Weaker Students", amount: "Rs 8,000 / sem", deadline: "15 Oct", officialNoticeUrl: "https://ruraluniv.ac.in/endowment", eligibility: ["GPA > 7.5"]),
    ];
  }

  void _initFallbacks() {
    schools = [
      SchoolItem(
        id: "sch_sci",
        name: "School of Sciences",
        dean: "Dr. S. Kanthimathinathan",
        deanEmail: "dean_sciences@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 201",
        programmesCount: 16,
        highlights: "DST-FIST Supported Labs, Central NMR & XRD Instrumentation Facility, Cloud Computing Lab",
      ),
      SchoolItem(
        id: "sch_agri",
        name: "School of Agriculture and Animal Sciences",
        dean: "Dr. K. S. Pushpa",
        deanEmail: "dean_agri@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 202",
        programmesCount: 9,
        highlights: "ICAR Accredited B.Sc. (Hons.) Agriculture, Organic Dairy Farm, Agro-Meteorological Unit",
      ),
      SchoolItem(
        id: "sch_health",
        name: "School of Rural Health and Sanitation",
        dean: "Dr. M. G. Sethuraman",
        deanEmail: "dean_health@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 203",
        programmesCount: 7,
        highlights: "WHO Collaborating Partner, Sanitary Inspector Training Pioneer in India since 1965",
      ),
      SchoolItem(
        id: "sch_socsci",
        name: "School of Social Sciences",
        dean: "Dr. P. Anandharajakumar",
        deanEmail: "dean_socsci@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 204",
        programmesCount: 14,
        highlights: "Nai Talim Village Internship, Kasturba Seva Ashram Field Action Projects",
      ),
      SchoolItem(
        id: "sch_tamil",
        name: "School of Tamil, Indian Languages and Rural Arts",
        dean: "Dr. M. Kuruvammal",
        deanEmail: "dean_tamil@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 205",
        programmesCount: 10,
        highlights: "Classical Tamil Palm-leaf Archives, Folk Arts Troupe, Rural Handicrafts Centre",
      ),
      SchoolItem(
        id: "sch_english",
        name: "School of English & Foreign Languages",
        dean: "Dr. S. Senthilnathan",
        deanEmail: "dean_english@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 206",
        programmesCount: 6,
        highlights: "Modern Digital Language Lab, Communicative English Resource Centre",
      ),
      SchoolItem(
        id: "sch_mgmt",
        name: "School of Management Studies",
        dean: "Dr. S. B. Inayath Ahamed",
        deanEmail: "dean_mgmt@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 207",
        programmesCount: 8,
        highlights: "MBA Rural Management, Agribusiness Incubator, Cooperative Banking Laboratory",
      ),
      SchoolItem(
        id: "sch_cs",
        name: "School of Computer Science & Technologies",
        dean: "Dr. K. Somasundaram",
        deanEmail: "dean_cs@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 208",
        programmesCount: 11,
        highlights: "NVIDIA Deep Learning Lab, High Performance Computing, 1 Gbps NKN Fibre Backbone",
      ),
    ];
  }

  // Official Leadership Roster (Chancellor, VC, Registrar, COE, FO, CVO, Deans)
  List<Map<String, String>> get officialLeadership => [
    {
      "name": "Dr. KM. Annamalai",
      "designation": "Honorable Chancellor",
      "email": "chancellor@ruraluniv.ac.in",
      "phone": "+91 451 2452371",
      "portfolio": "Head of Institution, Presiding Officer of Convocation",
      "location": "Chancellor Secretariat",
    },
    {
      "name": "Prof. Dr. N. Panchanatham",
      "designation": "Vice-Chancellor",
      "email": "vc@ruraluniv.ac.in",
      "phone": "+91 451 2452305",
      "portfolio": "Chief Academic & Executive Officer, Chairman of Executive Council",
      "location": "Vice-Chancellor Block",
    },
    {
      "name": "Dr. K. Marimuthu",
      "designation": "Registrar",
      "email": "registrar@ruraluniv.ac.in",
      "phone": "+91 451 2452371 Ext: 102",
      "portfolio": "Custodian of University Records, Administration & Legal Affairs",
      "location": "Administrative Block, Ground Floor",
    },
    {
      "name": "Dr. V. Sivakumar",
      "designation": "Controller of Examinations",
      "email": "coe@ruraluniv.ac.in",
      "phone": "+91 451 2452371 Ext: 104",
      "portfolio": "End Semester Exams, CIA Evaluations, Degree Awarding & e-SANAD",
      "location": "Examination Building",
    },
    {
      "name": "Dr. K. Ravichandran",
      "designation": "Finance Officer",
      "email": "fo@ruraluniv.ac.in",
      "phone": "+91 451 2452371 Ext: 106",
      "portfolio": "University Budget, UGC Grants & Research Project Accounting",
      "location": "Finance Wing, Admin Block",
    },
    {
      "name": "Dr. P. Balasubramaniam",
      "designation": "Chief Vigilance Officer",
      "email": "cvo@ruraluniv.ac.in",
      "phone": "+91 451 2452371 Ext: 108",
      "portfolio": "Statutory Institutional Vigilance & Governance Integrity",
      "location": "Vigilance Cell",
    },
    {
      "name": "Dr. S. Meenakshi",
      "designation": "Director, Research & Development Cell (RDC)",
      "email": "rdc@ruraluniv.ac.in",
      "phone": "+91 451 2452371 Ext: 112",
      "portfolio": "Extramural Research Grants, IPR, Patenting & Ph.D. Directorate",
      "location": "RDC Central Complex",
    },
    {
      "name": "Dr. P. U. Mahalingam",
      "designation": "Director, IQAC",
      "email": "iqac@ruraluniv.ac.in",
      "phone": "+91 451 2452371 Ext: 114",
      "portfolio": "NAAC A+ Accreditation & Quality Benchmark Assessment",
      "location": "IQAC Directorate",
    },
    {
      "name": "Dr. S. Manivel",
      "designation": "Dean of Student Welfare",
      "email": "dsw@ruraluniv.ac.in",
      "phone": "+91 451 2452371 Ext: 118",
      "portfolio": "Hostel Affairs, Student Grievance Redressal & Anti-Ragging Cell",
      "location": "Student Welfare Centre",
    },
  ];

  // Official Prospectuses & Academic Admissions
  List<Map<String, dynamic>> get officialProspectuses => [
    {
      "title": "GRI Admissions Prospectus 2026-27 (All Programmes)",
      "year": "2026-27",
      "pdfUrl": "https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf",
      "size": "5.4 MB",
      "summary": "Official comprehensive prospectus detailing eligibility, seat matrix, fee concessions, reservation norms, and hostel accommodations for 2026-27.",
      "programmes": ["Undergraduate (UG)", "Postgraduate (PG)", "B.Voc.", "Diploma", "Ph.D."],
    },
    {
      "title": "GRI Admissions Prospectus 2025-26",
      "year": "2025-26",
      "pdfUrl": "https://www.ruraluniv.ac.in/includes/admissions/2025/pdf/Prospectus_202526.pdf",
      "size": "4.8 MB",
      "summary": "Reference prospectus for ongoing cohorts, fee structures, and curriculum outlines.",
      "programmes": ["UG", "PG", "Diploma", "Doctoral"],
    },
  ];

  // Official Downloadable Forms & Certificates
  List<Map<String, String>> get officialForms => [
    {
      "title": "Application for Official Academic Transcripts",
      "code": "COE-FORM-01",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf",
      "authority": "Controller of Examinations",
      "desc": "Statutory application to obtain attested academic grade transcripts for higher education and WES evaluation.",
    },
    {
      "title": "Application for Duplicate Degree / Diploma Certificate",
      "code": "COE-FORM-02",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf",
      "authority": "Controller of Examinations",
      "desc": "Prescribed form for applying for duplicate credentials with police inquiry report and affidavit.",
    },
    {
      "title": "Certificate for Compliance of Ph.D. Degree with UGC Regulations",
      "code": "RDC-FORM-03",
      "url": "http://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf",
      "authority": "Research and Development Cell",
      "desc": "Official UGC compliance certificate for Ph.D. degree holders for teaching faculty recruitments.",
    },
    {
      "title": "e-SANAD Digital Attestation Notification & Guidelines",
      "code": "SANAD-NOTIF-04",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf",
      "authority": "Ministry of External Affairs & GRI",
      "desc": "Official instructions for paperless digital verification and apostille attestation via e-SANAD portal.",
    },
    {
      "title": "Tatkal Scheme Instructions for Urgent Certificates",
      "code": "TATKAL-FORM-05",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf",
      "authority": "Controller of Examinations",
      "desc": "Procedure and expedited fee schedule for obtaining provisional certificates within 48 hours.",
    },
    {
      "title": "Krishi Vigyan Kendra (KVK Dindigul) Profile & Soil Services",
      "code": "ICAR-KVK-06",
      "url": "http://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf",
      "authority": "ICAR - GRI Farm Science Centre",
      "desc": "Agricultural extension, soil testing services, organic bio-fertilizers, and rural farmers training schedule.",
    },
    {
      "title": "Rural Energy Centre Programme Brochure",
      "code": "REC-BROCHURE-07",
      "url": "http://ruraluniv.ac.in/includes/academics/programmes/brochure/15330.pdf",
      "authority": "School of Computer Science & Technologies",
      "desc": "Curriculum and research facilities in Biomass Gasification and Solar Energy testing.",
    },
  ];

  // Statutory Scholarships & Government ID Portals
  List<Map<String, dynamic>> get officialScholarships => [
    {
      "title": "SC / ST / SCC Post-Matric Government Scholarship 2026-27",
      "authority": "Government of Tamil Nadu & Ministry of Social Justice",
      "beneficiary": "SC, ST, and Converted Christian Scheduled Caste Students",
      "details": "100% Tuition Fee waiver, maintenance allowances, and examination fee reimbursement.",
      "noticeUrl": "https://doc.ruraluniv.ac.in/studentcorner/view/330",
    },
    {
      "title": "APAAR ID Creation (One Nation One Student ID)",
      "authority": "Ministry of Education & National Academic Depository (NAD)",
      "beneficiary": "All Enrolled Students (Mandatory for Credit Transfer)",
      "details": "12-digit automated permanent academic account registry linked to DigiLocker and ABC (Academic Bank of Credits).",
      "noticeUrl": "https://ruraluniv.ac.in/",
    },
    {
      "title": "UMIS ID Integration (University Management Information System)",
      "authority": "Tamil Nadu Higher Education Department",
      "beneficiary": "All Tamil Nadu Domicile Students",
      "details": "Mandatory state student registration for government entitlement schemes and scholarships.",
      "noticeUrl": "https://ruraluniv.ac.in/",
    },
  ];

  // University Contact & Campus Directions
  Map<String, dynamic> get universityContact => {
    "university_name": "The Gandhigram Rural Institute (Deemed to be University)",
    "accreditation": "NAAC Re-accredited with 'A+' Grade (Cycle 4)",
    "address": "Gandhigram - 624 302, Dindigul District, Tamil Nadu, India",
    "epabx": "+91 451 2452371 to 2452376 (6 Lines)",
    "fax": "+91 451 2454466",
    "email_general": "gru64@ruraluniv.ac.in",
    "email_admissions": "admissions@ruraluniv.ac.in",
    "email_registrar": "registrar@ruraluniv.ac.in",
    "email_coe": "coe@ruraluniv.ac.in",
    "website": "https://ruraluniv.ac.in/",
    "railway_access": "Dindigul Junction (12 km) or Ambathurai Railway Station (2 km)",
    "airport_access": "Madurai International Airport (65 km)",
  };
}

