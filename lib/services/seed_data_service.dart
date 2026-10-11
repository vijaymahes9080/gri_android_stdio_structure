import 'dart:convert';
import 'package:flutter/services.dart';

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

