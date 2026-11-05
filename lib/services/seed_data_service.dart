import 'package:flutter/foundation.dart';
import '../models/academic_models.dart';
import '../models/official_models.dart';
import 'official_catalog_service.dart';

class SchoolItem {
  final String id;
  final String name;
  final String dean;
  final String deanEmail;
  final String deanPhone;
  final int programmesCount;
  final String highlights;
  final String deanDesignation;
  final String deanPhotoAsset;
  final List<String> unitIds;
  final String type;
  final String sourceUrl;

  SchoolItem({
    required this.id,
    required this.name,
    required this.dean,
    required this.deanEmail,
    required this.deanPhone,
    required this.programmesCount,
    required this.highlights,
    this.deanDesignation = 'Dean',
    this.deanPhotoAsset = '',
    this.unitIds = const [],
    this.type = 'school',
    this.sourceUrl = '',
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
      deanDesignation: json['dean_designation'] ?? 'Dean',
      deanPhotoAsset: json['dean_photo_asset'] ?? '',
      unitIds: (json['unit_ids'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      type: json['type'] ?? 'school',
      sourceUrl: json['source_url'] ?? '',
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
  final String type;
  final String profile;
  final String description;
  final String photoAsset;
  final String sourceUrl;
  final List<String> imageUrls;
  final List<Map<String, dynamic>> videos;
  final List<String> facultyIds;
  final String fetchedAt;

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
    this.type = 'department',
    this.profile = '',
    this.description = '',
    this.photoAsset = '',
    this.sourceUrl = '',
    this.imageUrls = const [],
    this.videos = const [],
    this.facultyIds = const [],
    this.fetchedAt = '',
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
      type: json['type'] ?? 'department',
      profile: json['profile'] ?? '',
      description: json['description'] ?? '',
      photoAsset: json['photo_asset'] ?? '',
      sourceUrl: json['source_url'] ?? '',
      imageUrls: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      videos: (json['videos'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? const [],
      facultyIds: (json['faculty_ids'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      fetchedAt: json['fetched_at'] ?? '',
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
  final String unitName;
  final String group;
  final List<String> tags;
  final List<Map<String, String>> syllabi;
  final String officialUrl;

  ProgrammeItem({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.degree,
    required this.duration,
    required this.intake,
    required this.eligibility,
    required this.feePerSemester,
    this.unitName = '',
    this.group = '',
    this.tags = const [],
    this.syllabi = const [],
    this.officialUrl = '',
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
      unitName: json['unit_name'] ?? '',
      group: json['group'] ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      syllabi: (json['syllabi'] as List?)
              ?.map((e) => {
                    'label': (e as Map)['label']?.toString() ?? '',
                    'url': e['url']?.toString() ?? '',
                  })
              .toList() ??
          const [],
      officialUrl: json['official_url'] ?? '',
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

/// Compatibility facade over [OfficialCatalogService].
///
/// The old class exposed hard-coded seed records. It now exposes only records
/// parsed from the live official website; fields that the university does not
/// publish (direct emails, extensions, fees, intake) remain empty rather than
/// being invented.
class SeedDataService {
  static SeedDataService? _instance;
  static SeedDataService get instance => _instance ??= SeedDataService._();
  SeedDataService._();

  static const String generalEmail = 'grucc@ruraluniv.ac.in';
  static const String generalPhone = '0451-2452371';

  bool _isLoaded = false;
  List<SchoolItem> schools = [];
  List<DepartmentItem> departments = [];
  List<ProgrammeItem> programmes = [];
  List<FacilityItem> facilities = [];
  List<Map<String, dynamic>> examinations = [];
  List<Map<String, dynamic>> documents = [];
  List<Map<String, dynamic>> contacts = [];

  List<Map<String, dynamic>> allPages = [];
  List<Map<String, dynamic>> allCatalogDocuments = [];

  static List<SchoolModel> _staticSchools = [];
  static List<LeadershipOfficerModel> _staticLeadership = [];
  static List<OfficialDownloadModel> _staticDownloads = [];
  static List<Map<String, dynamic>> _staticProspectuses = [];
  static List<Map<String, String>> _staticForms = [];
  static List<Map<String, dynamic>> _staticScholarships = [];
  static OfficialInstitution? _institution;
  static DateTime? _loadedAt;

  DateTime? get loadedAt => _loadedAt;

  Future<void> loadSeedData() async {
    if (_isLoaded) return;
    final catalog = OfficialCatalogService.instance;
    try {
      await catalog.ensureLoaded();
      _institution = catalog.institution;

      schools = catalog.schools
          .where((s) => s.type == 'school')
          .map((s) {
            final units = catalog.unitsForSchool(s.id);
            final progs = catalog.programmes.where((p) => units.any((u) => u.id == p.unitId)).length;
            return SchoolItem(
              id: s.id,
              name: s.name,
              dean: s.deanName,
              deanEmail: generalEmail,
              deanPhone: generalPhone,
              programmesCount: progs > 0 ? progs : s.programmeCount,
              highlights: units.isEmpty
                  ? 'Official school information is published by the university.'
                  : units.map((u) => u.name.replaceFirst('Department of ', '').replaceFirst('Centre for ', '')).join(' • '),
              deanDesignation: s.deanDesignation,
              deanPhotoAsset: OfficialCatalogService.assetKey(s.deanPhotoAsset),
              unitIds: s.unitIds,
              type: s.type,
              sourceUrl: s.sourceUrls.isNotEmpty ? s.sourceUrls.first : '',
            );
          })
          .toList();

      departments = catalog.units.map((u) {
        final hods = catalog.faculty.where((f) =>
            f.affiliations.any((a) => a.unitId == u.id && (a.role == 'hod' || a.role == 'dean')));
        final deptFaculty = catalog.facultyForUnit(u.id);
        return DepartmentItem(
          id: u.id,
          schoolId: u.schoolId,
          name: u.name,
          hod: hods.isNotEmpty ? hods.first.name : (u.type == 'school' ? (catalog.schoolById(u.id)?.deanName ?? '') : ''),
          hodEmail: generalEmail,
          hodPhone: generalPhone,
          establishedYear: '',
          programmesOffered: u.programmes.map((p) => p.name).toList(),
          researchAreas: u.profile.isNotEmpty ? u.profile : u.description,
          type: u.type,
          profile: u.profile,
          description: u.description,
          photoAsset: OfficialCatalogService.assetKey(u.profilePhotoAsset),
          sourceUrl: u.url,
          imageUrls: u.imageUrls,
          videos: u.videos,
          facultyIds: deptFaculty.map((f) => f.id).toList(),
          fetchedAt: u.fetchedAt,
        );
      }).toList();

      programmes = catalog.programmes.map((p) {
        final unit = catalog.unitById(p.unitId);
        return ProgrammeItem(
          id: p.id,
          departmentId: p.unitId,
          name: p.displayName,
          degree: p.degree,
          duration: p.duration,
          intake: 0,
          eligibility: p.eligibility,
          feePerSemester: '',
          unitName: unit?.name ?? p.group,
          group: p.group,
          tags: p.tags,
          syllabi: p.syllabi.map((s) => {'label': s.label, 'url': s.url}).toList(),
          officialUrl: p.officialUrl,
        );
      }).toList();

      facilities = catalog.facilities
          .map((f) => FacilityItem(
                id: f.id,
                name: f.name,
                category: f.category,
                description: f.description,
                location: 'Gandhigram campus',
                inCharge: '',
                timings: '',
              ))
          .toList();

      documents = catalog.documents
          .where((d) => d.valid)
          .map((d) => <String, dynamic>{
                'id': d.id,
                'title': d.title,
                'category': d.category,
                'url': d.url,
                'file_size': d.sizeLabel,
                'authority': d.authority,
                'unit_id': d.unitId,
                'unit_name': d.unitName,
                'programme': d.programme,
                'label': d.label,
                'local_path': d.localPath,
              })
          .toList();

      contacts = [
        {
          'name': 'University General Office',
          'email': generalEmail,
          'phone': generalPhone,
          'address': catalog.institution?.address ?? '',
        }
      ];

      allPages = catalog.pageEntries();
      allCatalogDocuments = documents;

      _buildStaticViews(catalog);
      _isLoaded = true;
      _loadedAt = DateTime.now();
    } catch (e) {
      // Keep the app usable without fabricating official records. The caller
      // can surface the source/sync error instead.
      debugPrint('Official catalog load failed: $e');
      schools = [];
      departments = [];
      programmes = [];
      facilities = [];
      documents = [];
      contacts = [];
      allPages = [];
      allCatalogDocuments = [];
      _isLoaded = true;
      _loadedAt = DateTime.now();
    }
  }

  void _buildStaticViews(OfficialCatalogService catalog) {
    _staticSchools = schools
        .map((s) => SchoolModel(
              id: s.id,
              name: s.name,
              dean: s.dean,
              deanEmail: s.deanEmail,
              deanPhone: s.deanPhone,
              programmesCount: s.programmesCount,
              highlights: s.highlights,
              departments: departments
                  .where((d) => d.schoolId == s.id)
                  .map((d) => DepartmentModel(
                        id: d.id,
                        name: d.name,
                        hod: d.hod,
                        hodEmail: d.hodEmail,
                        contact: d.hodPhone,
                        programmes: d.programmesOffered,
                        researchAreas: d.researchAreas,
                      ))
                  .toList(),
            ))
        .toList();

    _staticLeadership = catalog.leadership
        .map((l) => LeadershipOfficerModel(
              id: l.id,
              name: l.name,
              designation: l.designation,
              email: l.email,
              phone: l.phone,
              portfolio: l.designation,
              officeLocation: 'Gandhigram campus',
            ))
        .toList();

    final priority = ['prospectus', 'regulation', 'examination', 'form', 'student-corner', 'admissions', 'official-document'];
    final orderedDocs = List<OfficialDocument>.from(catalog.documents.where((d) => d.valid))
      ..sort((a, b) {
        final ai = priority.indexOf(a.category);
        final bi = priority.indexOf(b.category);
        return (ai < 0 ? 99 : ai).compareTo(bi < 0 ? 99 : bi);
      });
    _staticDownloads = orderedDocs
        .where((d) => !['syllabus', 'faculty-profile'].contains(d.category))
        .take(40)
        .map((d) => OfficialDownloadModel(
              id: d.id,
              title: d.title,
              category: d.category,
              fileUrl: d.url,
              authority: d.authority,
              instructions: d.sizeLabel,
            ))
        .toList();

    _staticProspectuses = catalog.documents
        .where((d) => d.category == 'prospectus')
        .map((d) => <String, dynamic>{
              'title': d.title,
              'year': _yearFrom(d.title),
              'pdfUrl': d.url,
              'size': d.sizeLabel,
              'summary': 'Official prospectus published by the Admissions Directorate.',
              'programmes': const <String>[],
            })
        .toList();

    _staticForms = catalog.documents
        .where((d) => ['examination', 'form', 'student-corner', 'regulation'].contains(d.category) && d.valid)
        .take(30)
        .map((d) => <String, String>{
              'title': d.title,
              'code': d.label,
              'url': d.url,
              'authority': d.authority,
              'desc': d.sizeLabel,
            })
        .toList();

    _staticScholarships = catalog.notices
        .where((n) {
          final t = n.title.toLowerCase();
          return t.contains('scholarship') || t.contains('welfare') || t.contains('fee');
        })
        .map((n) => <String, dynamic>{
              'title': n.title,
              'authority': 'GRI Official Notice',
              'beneficiary': 'Refer to the official notice',
              'details': n.summary,
              'noticeUrl': n.url,
              'date': n.displayDate,
            })
        .toList();
  }

  static String _yearFrom(String value) {
    final m = RegExp(r'(20\d{2})\s*[-–]\s*(\d{2,4})').firstMatch(value);
    return m == null ? '' : '${m.group(1)}-${m.group(2)}';
  }

  Future<void> loadWebsiteInventory() async {
    await loadSeedData();
    if (allPages.isEmpty) {
      allPages = OfficialCatalogService.instance.pageEntries();
    }
  }

  Map<String, dynamic>? getPageByIdOrUrl(String identifier) {
    if (identifier.isEmpty) return null;
    final clean = identifier.toLowerCase().trim();
    final catalog = OfficialCatalogService.instance;

    final unit = catalog.unitById(identifier) ?? catalog.unitByUrl(identifier);
    if (unit != null) {
      final docs = catalog.documentsForUnit(unit.id).where((d) => d.valid).map((d) => {
            'title': d.programme.isNotEmpty ? '${d.programme} — ${d.label}' : d.title,
            'url': d.url,
            'size': d.sizeLabel,
          }).toList();
      return {
        'id': unit.id,
        'title': unit.name,
        'name': unit.name,
        'url': unit.url,
        'category': 'Academics',
        'kind': 'unit',
        'description': unit.description,
        'clean_summary': unit.profile.isNotEmpty ? unit.profile : unit.description,
        'text': unit.profile,
        'images': unit.imageUrls,
        'videos': unit.videos,
        'resources': {'documents': docs},
      };
    }

    for (final n in catalog.notices) {
      if (n.url.toLowerCase() == clean || n.id.toLowerCase() == clean) {
        return {
          'id': n.id,
          'title': n.title,
          'name': n.title,
          'url': n.url,
          'category': 'Notices',
          'kind': 'notice',
          'description': n.summary,
          'clean_summary': n.summary,
          'text': n.summary,
        };
      }
    }

    for (final p in allPages) {
      final url = (p['url'] ?? '').toString().toLowerCase();
      final id = (p['id'] ?? '').toString().toLowerCase();
      final title = (p['title'] ?? '').toString().toLowerCase();
      if (url == clean || id == clean || title == clean) return p;
    }
    return null;
  }

  List<Map<String, dynamic>> getPagesByCategory(String category) {
    if (category.toLowerCase() == "all") return allPages;
    final catLower = category.toLowerCase();
    return allPages.where((p) => (p['category'] ?? '').toString().toLowerCase().contains(catLower)).toList();
  }

  List<Map<String, dynamic>> getAllDocuments() {
    if (allCatalogDocuments.isNotEmpty) return allCatalogDocuments;
    return documents;
  }

  DepartmentItem? getDepartmentById(String deptId) {
    final id = deptId.trim().toLowerCase();
    for (final d in departments) {
      if (d.id.toLowerCase() == id) return d;
    }
    for (final s in schools) {
      if (s.id.toLowerCase() == id) {
        final units = departments.where((d) => d.schoolId == s.id).toList();
        return DepartmentItem(
          id: s.id,
          schoolId: s.id,
          name: s.name,
          hod: s.dean,
          hodEmail: s.deanEmail,
          hodPhone: s.deanPhone,
          establishedYear: '',
          programmesOffered: units.expand((u) => u.programmesOffered).toList(),
          researchAreas: units.map((u) => u.name).join(' • '),
          type: 'school',
          profile: 'Official school information published by The Gandhigram Rural Institute.',
          description: s.highlights,
          photoAsset: s.deanPhotoAsset,
          sourceUrl: s.sourceUrl,
          facultyIds: units.expand((u) => u.facultyIds).toSet().toList(),
        );
      }
    }
    for (final d in departments) {
      if (d.id.toLowerCase().contains(id) || d.name.toLowerCase().contains(id)) return d;
    }
    return null;
  }

  static List<SchoolModel> getOfficialSchools() => List<SchoolModel>.from(_staticSchools);

  static List<LeadershipOfficerModel> getOfficialLeadership() =>
      List<LeadershipOfficerModel>.from(_staticLeadership);

  static List<OfficialDownloadModel> getOfficialDownloads() =>
      List<OfficialDownloadModel>.from(_staticDownloads);

  static List<StatutoryBodyModel> getStatutoryCouncils() => const [];

  static List<ScholarshipItemModel> getScholarshipSchemes() => _staticScholarships
      .map((s) => ScholarshipItemModel(
            id: (s['title'] ?? '').toString().hashCode.toString(),
            name: (s['title'] ?? '').toString(),
            beneficiary: (s['beneficiary'] ?? '').toString(),
            amount: 'As notified by the university',
            deadline: (s['date'] ?? '').toString(),
            officialNoticeUrl: (s['noticeUrl'] ?? '').toString(),
            eligibility: const [],
          ))
      .toList();

  // ---------------------------------------------------------------- legacy views
  List<Map<String, dynamic>> get officialLeadership => _staticLeadership
      .map((o) => <String, dynamic>{
            'name': o.name,
            'designation': o.designation,
            'email': o.email,
            'phone': o.phone,
            'portfolio': o.portfolio,
            'location': o.officeLocation,
          })
      .toList();

  List<Map<String, dynamic>> get officialProspectuses => _staticProspectuses;

  List<Map<String, String>> get officialForms => _staticForms;

  List<Map<String, dynamic>> get officialScholarships => _staticScholarships;

  Map<String, dynamic> get universityContact {
    final inst = _institution;
    return {
      "university_name": inst?.name ?? "The Gandhigram Rural Institute (Deemed to be University)",
      "accreditation": inst?.accreditation ?? "Accredited by NAAC with A ++ Grade (4th Cycle)",
      "address": inst?.address ?? "Gandhigram, Dindigul District, Tamil Nadu 624 302, India",
      "epabx": generalPhone,
      "email_general": generalEmail,
      "website": inst?.website ?? "https://www.ruraluniv.ac.in/",
      "schools_count": inst?.schoolsCount ?? 8,
      "departments_count": inst?.departmentsCount ?? 19,
      "centres_count": inst?.centresCount ?? 11,
      "programmes_count": inst?.programmesCount ?? 64,
      "students_count": inst?.studentsCount ?? 0,
      "teaching_staff": inst?.teachingStaff ?? 0,
      "non_teaching_staff": inst?.nonTeachingStaff ?? 0,
      "dataset_generated_at": OfficialCatalogService.instance.generatedAt,
    };
  }
}
