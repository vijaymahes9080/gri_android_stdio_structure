/// Typed models for the verified official GRI dataset.
///
/// Every record is derived from a page on https://www.ruraluniv.ac.in/ and
/// keeps a source URL. Optional fields stay null/empty when the official site
/// does not publish that information, so the UI never has to invent it.
library;

String _s(dynamic v) => v == null ? '' : v.toString();

int _i(dynamic v) => v is num ? v.toInt() : int.tryParse(_s(v)) ?? 0;

List<String> _strings(dynamic v) =>
    v is List ? v.map((e) => _s(e)).where((e) => e.isNotEmpty).toList() : <String>[];

class OfficialAffiliation {
  final String role;
  final String designation;
  final String unitId;
  final String unitName;
  final String schoolId;
  final String schoolName;
  final String sourceUrl;

  const OfficialAffiliation({
    required this.role,
    required this.designation,
    required this.unitId,
    required this.unitName,
    required this.schoolId,
    required this.schoolName,
    required this.sourceUrl,
  });

  factory OfficialAffiliation.fromJson(Map<String, dynamic> j) => OfficialAffiliation(
        role: _s(j['role']),
        designation: _s(j['designation']),
        unitId: _s(j['unit_id']),
        unitName: _s(j['unit_name']),
        schoolId: _s(j['school_id']),
        schoolName: _s(j['school_name']),
        sourceUrl: _s(j['source_url']),
      );
}

class OfficialInstitution {
  final String name;
  final String shortName;
  final String tamilName;
  final int established;
  final int deemedUniversity;
  final String accreditation;
  final String ministry;
  final String address;
  final String email;
  final String phone;
  final String website;
  final int schoolsCount;
  final int departmentsCount;
  final int centresCount;
  final int programmesCount;
  final int studentsCount;
  final int teachingStaff;
  final int nonTeachingStaff;
  final String generatedAt;

  const OfficialInstitution({
    required this.name,
    required this.shortName,
    required this.tamilName,
    required this.established,
    required this.deemedUniversity,
    required this.accreditation,
    required this.ministry,
    required this.address,
    required this.email,
    required this.phone,
    required this.website,
    required this.schoolsCount,
    required this.departmentsCount,
    required this.centresCount,
    required this.programmesCount,
    required this.studentsCount,
    required this.teachingStaff,
    required this.nonTeachingStaff,
    required this.generatedAt,
  });

  factory OfficialInstitution.fromJson(Map<String, dynamic> j) => OfficialInstitution(
        name: _s(j['name']),
        shortName: _s(j['short_name']),
        tamilName: _s(j['tamil_name']),
        established: _i(j['established']),
        deemedUniversity: _i(j['deemed_university']),
        accreditation: _s(j['accreditation']),
        ministry: _s(j['ministry']),
        address: _s(j['address']),
        email: _s(j['email']),
        phone: _s(j['phone']),
        website: _s(j['website']),
        schoolsCount: _i(j['schools_count']),
        departmentsCount: _i(j['departments_count']),
        centresCount: _i(j['centres_count']),
        programmesCount: _i(j['programmes_count']),
        studentsCount: _i(j['students_count']),
        teachingStaff: _i(j['teaching_staff']),
        nonTeachingStaff: _i(j['non_teaching_staff']),
        generatedAt: _s(j['generated_at']),
      );
}

class OfficialSchool {
  final String id;
  final String name;
  final String type;
  final String deanId;
  final String deanName;
  final String deanDesignation;
  final String deanPhotoUrl;
  final String deanPhotoAsset;
  final List<String> unitIds;
  final int programmeCount;
  final List<String> sourceUrls;

  const OfficialSchool({
    required this.id,
    required this.name,
    required this.type,
    required this.deanId,
    required this.deanName,
    required this.deanDesignation,
    required this.deanPhotoUrl,
    required this.deanPhotoAsset,
    required this.unitIds,
    required this.programmeCount,
    required this.sourceUrls,
  });

  factory OfficialSchool.fromJson(Map<String, dynamic> j) => OfficialSchool(
        id: _s(j['id']),
        name: _s(j['name']),
        type: _s(j['type']),
        deanId: _s(j['dean_id']),
        deanName: _s(j['dean_name']),
        deanDesignation: _s(j['dean_designation']),
        deanPhotoUrl: _s(j['dean_photo_url']),
        deanPhotoAsset: _s(j['dean_photo_asset']),
        unitIds: _strings(j['unit_ids']),
        programmeCount: _i(j['programme_count']),
        sourceUrls: _strings(j['source_urls']),
      );
}

class OfficialSyllabus {
  final String label;
  final String url;

  const OfficialSyllabus({required this.label, required this.url});

  factory OfficialSyllabus.fromJson(Map<String, dynamic> j) =>
      OfficialSyllabus(label: _s(j['label']), url: _s(j['url']));

  String get yearLabel {
    final m = RegExp(r'(\d{4})\s*[-–]\s*(\d{2,4})').firstMatch(label);
    return m == null ? label : '${m.group(1)}-${m.group(2)}';
  }
}

class OfficialUnitProgramme {
  final String name;
  final List<OfficialSyllabus> syllabi;
  final String eligibility;
  final String unitLabel;

  const OfficialUnitProgramme({
    required this.name,
    required this.syllabi,
    this.eligibility = '',
    this.unitLabel = '',
  });

  factory OfficialUnitProgramme.fromJson(Map<String, dynamic> j) => OfficialUnitProgramme(
        name: _s(j['name']),
        syllabi: (j['syllabi'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => OfficialSyllabus.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        eligibility: _s(j['eligibility']),
        unitLabel: _s(j['unit_label']),
      );

  String? get latestSyllabusUrl => syllabi.isEmpty ? null : syllabi.first.url;
}

class OfficialUnit {
  final String id;
  final String name;
  final String type;
  final String url;
  final String title;
  final String description;
  final String profile;
  final String profilePhotoUrl;
  final String profilePhotoAsset;
  final String schoolId;
  final List<String> imageUrls;
  final List<Map<String, dynamic>> videos;
  final List<OfficialUnitProgramme> programmes;
  final String fetchedAt;

  const OfficialUnit({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.title,
    required this.description,
    required this.profile,
    required this.profilePhotoUrl,
    required this.profilePhotoAsset,
    required this.schoolId,
    required this.imageUrls,
    required this.videos,
    required this.programmes,
    required this.fetchedAt,
  });

  factory OfficialUnit.fromJson(Map<String, dynamic> j) => OfficialUnit(
        id: _s(j['id']),
        name: _s(j['name']),
        type: _s(j['type']),
        url: _s(j['url']),
        title: _s(j['title']),
        description: _s(j['description']),
        profile: _s(j['profile']),
        profilePhotoUrl: _s(j['profile_photo_url']),
        profilePhotoAsset: _s(j['profile_photo_asset']),
        schoolId: _s(j['school_id']),
        imageUrls: (j['images'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => _s(e['url']))
            .where((e) => e.isNotEmpty)
            .toList(),
        videos: (j['videos'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList(),
        programmes: (j['programmes'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => OfficialUnitProgramme.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        fetchedAt: _s(j['fetched_at']),
      );

  bool get isDepartment => type == 'department';
  bool get isCentre => type == 'centre';
  bool get isSchool => type == 'school';

  String get academicLevel {
    if (type == 'kaushal-kendra') return 'Vocational';
    if (type == 'centre') return 'Research Centre';
    if (type == 'school') return 'School';
    return 'Department';
  }
}

class OfficialFaculty {
  final String id;
  final String fid;
  final String name;
  final String designation;
  final String qualifications;
  final String specialization;
  final String photoUrl;
  final String photoAsset;
  final String profileUrl;
  final String profileAsset;
  final String scholar;
  final String irins;
  final String orcid;
  final List<OfficialAffiliation> affiliations;
  final List<String> roles;
  final String primaryRole;

  const OfficialFaculty({
    required this.id,
    required this.fid,
    required this.name,
    required this.designation,
    required this.qualifications,
    required this.specialization,
    required this.photoUrl,
    required this.photoAsset,
    required this.profileUrl,
    required this.profileAsset,
    required this.scholar,
    required this.irins,
    required this.orcid,
    required this.affiliations,
    required this.roles,
    required this.primaryRole,
  });

  factory OfficialFaculty.fromJson(Map<String, dynamic> j) => OfficialFaculty(
        id: _s(j['id']),
        fid: _s(j['fid']),
        name: _s(j['name']),
        designation: _s(j['designation']),
        qualifications: _s(j['qualifications']),
        specialization: _s(j['specialization']),
        photoUrl: _s(j['photo_url']),
        photoAsset: _s(j['photo_asset']),
        profileUrl: _s(j['profile_url']),
        profileAsset: _s(j['profile_asset']),
        scholar: _s(j['scholar']),
        irins: _s(j['irins']),
        orcid: _s(j['orcid']),
        affiliations: (j['affiliations'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => OfficialAffiliation.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        roles: _strings(j['roles']),
        primaryRole: _s(j['primary_role']),
      );

  String get initials {
    final parts = name.replaceAll(RegExp(r'[^A-Za-z ]'), ' ').trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'GRI';
    if (parts.length == 1) return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    return (parts[parts.length - 1][0] + parts[0][0]).toUpperCase();
  }
}

class OfficialProgramme {
  final String id;
  final String group;
  final String degree;
  final String name;
  final String displayName;
  final List<String> tags;
  final String duration;
  final String approval;
  final String unitId;
  final String officialUrl;
  final List<OfficialSyllabus> syllabi;
  final String eligibility;
  final String unitProgrammeName;

  const OfficialProgramme({
    required this.id,
    required this.group,
    required this.degree,
    required this.name,
    required this.displayName,
    required this.tags,
    required this.duration,
    required this.approval,
    required this.unitId,
    required this.officialUrl,
    required this.syllabi,
    required this.eligibility,
    required this.unitProgrammeName,
  });

  factory OfficialProgramme.fromJson(Map<String, dynamic> j) => OfficialProgramme(
        id: _s(j['id']),
        group: _s(j['group']),
        degree: _s(j['degree']),
        name: _s(j['name']),
        displayName: _s(j['display_name']),
        tags: _strings(j['tags']),
        duration: _s(j['duration']),
        approval: _s(j['approval']),
        unitId: _s(j['unit_id']),
        officialUrl: _s(j['official_url']),
        syllabi: (j['syllabi'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => OfficialSyllabus.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        eligibility: _s(j['eligibility']),
        unitProgrammeName: _s(j['unit_programme_name']),
      );

  String get level {
    final d = degree.toUpperCase();
    if (d.contains('PH.D') || d.contains('DOCTOR')) return 'Doctoral';
    if (d.contains('M.PHIL')) return 'M.Phil.';
    if (d.startsWith('M.')) return 'PG';
    if (d.contains('B.VOC') || d.contains('D.VOC')) return 'Vocational';
    if (d.contains('DIPLOMA') || d.contains('CERTIFICATE')) return 'Diploma';
    return 'UG';
  }
}

class OfficialLeader {
  final String id;
  final String name;
  final String designation;
  final String portfolio;
  final String photoUrl;
  final String photoAsset;
  final String profileUrl;
  final String email;
  final String phone;
  final String contactNote;
  final String sourceUrl;

  const OfficialLeader({
    required this.id,
    required this.name,
    required this.designation,
    required this.portfolio,
    required this.photoUrl,
    required this.photoAsset,
    required this.profileUrl,
    required this.email,
    required this.phone,
    required this.contactNote,
    required this.sourceUrl,
  });

  factory OfficialLeader.fromJson(Map<String, dynamic> j) => OfficialLeader(
        id: _s(j['id']),
        name: _s(j['name']),
        designation: _s(j['designation']),
        portfolio: _s(j['portfolio']),
        photoUrl: _s(j['photo_url']),
        photoAsset: _s(j['photo_asset']),
        profileUrl: _s(j['profile_url']),
        email: _s(j['email']),
        phone: _s(j['phone']),
        contactNote: _s(j['contact_note']),
        sourceUrl: _s(j['source_url']),
      );
}

class OfficialNotice {
  final String id;
  final String title;
  final String url;
  final String category;
  final String date;
  final String dateDisplay;
  final String summary;
  final bool isNew;
  final String sourcePage;
  final String fetchedAt;

  const OfficialNotice({
    required this.id,
    required this.title,
    required this.url,
    required this.category,
    required this.date,
    required this.dateDisplay,
    required this.summary,
    required this.isNew,
    required this.sourcePage,
    required this.fetchedAt,
  });

  factory OfficialNotice.fromJson(Map<String, dynamic> j) => OfficialNotice(
        id: _s(j['id']),
        title: _s(j['title']),
        url: _s(j['url']),
        category: _s(j['category']),
        date: _s(j['date']),
        dateDisplay: _s(j['date_display']),
        summary: _s(j['summary']),
        isNew: j['is_new'] == true,
        sourcePage: _s(j['source_page']),
        fetchedAt: _s(j['fetched_at']),
      );

  String get displayDate {
    if (dateDisplay.isNotEmpty) return dateDisplay;
    if (date.length == 10) {
      final p = date.split('-');
      return '${p[2]}.${p[1]}.${p[0]}';
    }
    return 'Official notice';
  }
}

class OfficialPhoto {
  final String id;
  final String title;
  final String caption;
  final String fullUrl;
  final String thumbUrl;
  final String assetPath;
  final String thumbAssetPath;
  final int number;
  final String group;
  final String sourceUrl;

  const OfficialPhoto({
    required this.id,
    required this.title,
    required this.caption,
    required this.fullUrl,
    required this.thumbUrl,
    required this.assetPath,
    required this.thumbAssetPath,
    required this.number,
    required this.group,
    required this.sourceUrl,
  });

  factory OfficialPhoto.fromJson(Map<String, dynamic> j) => OfficialPhoto(
        id: _s(j['id']),
        title: _s(j['title']),
        caption: _s(j['caption']),
        fullUrl: _s(j['full_url']),
        thumbUrl: _s(j['thumb_url']),
        assetPath: _s(j['asset_path']),
        thumbAssetPath: _s(j['thumb_asset_path']),
        number: _i(j['number']),
        group: _s(j['group']),
        sourceUrl: _s(j['source_url']),
      );
}

class OfficialVideo {
  final String id;
  final String title;
  final String youtubeId;
  final String embedUrl;
  final String watchUrl;
  final String thumbnailUrl;
  final String thumbnailAssetPath;
  final String sourceUrl;

  const OfficialVideo({
    required this.id,
    required this.title,
    required this.youtubeId,
    required this.embedUrl,
    required this.watchUrl,
    required this.thumbnailUrl,
    required this.thumbnailAssetPath,
    required this.sourceUrl,
  });

  factory OfficialVideo.fromJson(Map<String, dynamic> j) => OfficialVideo(
        id: _s(j['id']),
        title: _s(j['title']),
        youtubeId: _s(j['youtube_id']),
        embedUrl: _s(j['embed_url']),
        watchUrl: _s(j['watch_url']),
        thumbnailUrl: _s(j['thumbnail_url']),
        thumbnailAssetPath: _s(j['thumbnail_asset_path']),
        sourceUrl: _s(j['source_url']),
      );
}

class OfficialDocument {
  final String id;
  final String title;
  final String category;
  final String url;
  final String localPath;
  final int bytes;
  final String sha256;
  final bool valid;
  final bool downloadAllowed;
  final String sourceUrl;
  final String authority;
  final String unitId;
  final String unitName;
  final String programme;
  final String label;
  final String facultyName;
  final int httpStatus;

  const OfficialDocument({
    required this.id,
    required this.title,
    required this.category,
    required this.url,
    required this.localPath,
    required this.bytes,
    required this.sha256,
    required this.valid,
    required this.downloadAllowed,
    required this.sourceUrl,
    required this.authority,
    required this.unitId,
    required this.unitName,
    required this.programme,
    required this.label,
    required this.facultyName,
    required this.httpStatus,
  });

  factory OfficialDocument.fromJson(Map<String, dynamic> j) => OfficialDocument(
        id: _s(j['id']),
        title: _s(j['title']),
        category: _s(j['category']),
        url: _s(j['url']),
        localPath: _s(j['local_path']),
        bytes: _i(j['bytes']),
        sha256: _s(j['sha256']),
        valid: j['valid'] == true,
        downloadAllowed: j['download_allowed'] != false,
        sourceUrl: _s(j['source_url']),
        authority: _s(j['authority']),
        unitId: _s(j['unit_id']),
        unitName: _s(j['unit_name']),
        programme: _s(j['programme']),
        label: _s(j['label']),
        facultyName: _s(j['faculty_name']),
        httpStatus: _i(j['http_status']),
      );

  String get sizeLabel {
    if (bytes <= 0) return 'Official PDF';
    if (bytes >= 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / 1024).round()} KB';
  }
}

class OfficialFacility {
  final String id;
  final String name;
  final String category;
  final String description;
  final String sourceUrl;
  final String photoUrl;

  const OfficialFacility({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.sourceUrl,
    required this.photoUrl,
  });

  factory OfficialFacility.fromJson(Map<String, dynamic> j) => OfficialFacility(
        id: _s(j['id']),
        name: _s(j['name']),
        category: _s(j['category']),
        description: _s(j['description']),
        sourceUrl: _s(j['source_url']),
        photoUrl: _s(j['photo_url']),
      );
}

class OfficialSearchHit {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String url;
  final String kind;
  final String payloadId;

  const OfficialSearchHit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.url,
    required this.kind,
    required this.payloadId,
  });
}
