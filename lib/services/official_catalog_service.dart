import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/official_models.dart';

/// Loads the verified official GRI dataset that is generated from
/// https://www.ruraluniv.ac.in/ into `data/official/canonical/`.
///
/// This is the single source of truth for official institutional content. No
/// record is synthesised here: if the official site does not publish a value,
/// the corresponding field stays empty and the UI hides it.
class OfficialCatalogService {
  OfficialCatalogService._();
  static final OfficialCatalogService instance = OfficialCatalogService._();

  static const String assetPath = 'data/official/canonical/official_data.json';

  bool _loaded = false;
  String? _error;

  OfficialInstitution? institution;
  List<OfficialSchool> schools = [];
  List<OfficialUnit> units = [];
  List<OfficialFaculty> faculty = [];
  List<OfficialLeader> leadership = [];
  List<OfficialProgramme> programmes = [];
  List<OfficialNotice> notices = [];
  List<OfficialPhoto> photos = [];
  List<OfficialVideo> videos = [];
  List<OfficialDocument> documents = [];
  List<OfficialFacility> facilities = [];
  String generatedAt = '';
  String source = '';
  Map<String, dynamic> counts = const {};

  bool get isLoaded => _loaded;
  String? get loadError => _error;

  static String assetKey(String relativePath) {
    if (relativePath.isEmpty) return '';
    if (relativePath.startsWith('assets/') || relativePath.startsWith('data/')) {
      return relativePath;
    }
    return 'data/official/$relativePath';
  }

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString(assetPath);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      generatedAt = (json['generated_at'] ?? '').toString();
      source = (json['source'] ?? '').toString();
      counts = Map<String, dynamic>.from(json['counts'] as Map? ?? const {});
      institution = OfficialInstitution.fromJson(
          Map<String, dynamic>.from(json['institution'] as Map? ?? const {}));
      schools = _list(json['schools'], OfficialSchool.fromJson);
      units = _list(json['units'], OfficialUnit.fromJson);
      faculty = _list(json['faculty'], OfficialFaculty.fromJson);
      leadership = _list(json['leadership'], OfficialLeader.fromJson);
      programmes = _list(json['programmes'], OfficialProgramme.fromJson);
      notices = _list(json['notices'], OfficialNotice.fromJson);
      final media = json['media'] as Map? ?? const {};
      photos = _list(media['photos'], OfficialPhoto.fromJson);
      videos = _list(media['videos'], OfficialVideo.fromJson);
      documents = _list(json['documents'], OfficialDocument.fromJson);
      facilities = _list(json['facilities'], OfficialFacility.fromJson);
      notices.sort((a, b) => b.date.compareTo(a.date));
      _loaded = true;
    } catch (e) {
      _error = e.toString();
      _loaded = false;
      rethrow;
    }
  }

  static List<T> _list<T>(dynamic raw, T Function(Map<String, dynamic>) parse) {
    if (raw is! List) return <T>[];
    return raw
        .whereType<Map>()
        .map((e) => parse(Map<String, dynamic>.from(e)))
        .toList();
  }

  OfficialSchool? schoolById(String id) {
    for (final s in schools) {
      if (s.id == id) return s;
    }
    return null;
  }

  OfficialUnit? unitById(String id) {
    for (final u in units) {
      if (u.id == id) return u;
    }
    return null;
  }

  OfficialUnit? unitByUrl(String url) {
    final clean = url.split('#').first.replaceAll('/ruraluniv/public', '').replaceAll(RegExp(r'/$'), '');
    for (final u in units) {
      if (u.url.replaceAll(RegExp(r'/$'), '') == clean) return u;
    }
    return null;
  }

  List<OfficialUnit> unitsForSchool(String schoolId) =>
      units.where((u) => u.schoolId == schoolId).toList();

  List<OfficialFaculty> facultyForUnit(String unitId) => faculty
      .where((f) => f.affiliations.any((a) => a.unitId == unitId))
      .toList();

  List<OfficialFaculty> facultyForSchool(String schoolId) => faculty
      .where((f) => f.affiliations.any((a) => a.schoolId == schoolId))
      .toList();

  OfficialFaculty? facultyById(String id) {
    for (final f in faculty) {
      if (f.id == id || f.fid == id) return f;
    }
    return null;
  }

  List<OfficialProgramme> programmesForUnit(String unitId) =>
      programmes.where((p) => p.unitId == unitId).toList();

  List<OfficialDocument> documentsForUnit(String unitId) => documents
      .where((d) => d.unitId == unitId && d.category != 'faculty-profile')
      .toList();

  List<OfficialDocument> documentsByCategory(List<String> categories) =>
      documents.where((d) => categories.contains(d.category)).toList();

  List<OfficialPhoto> photosForDisplay() {
    final copy = List<OfficialPhoto>.from(photos);
    copy.sort((a, b) => a.number.compareTo(b.number));
    return copy;
  }

  /// Full-text search across every canonical record.
  List<OfficialSearchHit> search(String query, {String category = 'All'}) {
    final q = query.trim().toLowerCase();
    final hits = <OfficialSearchHit>[];
    void add(String id, String title, String subtitle, String cat, String url, String kind, String payloadId) {
      if (title.isEmpty) return;
      if (q.isNotEmpty &&
          !title.toLowerCase().contains(q) &&
          !subtitle.toLowerCase().contains(q) &&
          !cat.toLowerCase().contains(q)) {
        return;
      }
      if (category != 'All' && cat.toLowerCase() != category.toLowerCase()) return;
      hits.add(OfficialSearchHit(
        id: id,
        title: title,
        subtitle: subtitle,
        category: cat,
        url: url,
        kind: kind,
        payloadId: payloadId,
      ));
    }

    for (final u in units) {
      final school = schoolById(u.schoolId)?.name ?? '';
      add('unit_${u.id}', u.name, [u.academicLevel, school].where((e) => e.isNotEmpty).join(' • '),
          'Academics', u.url, 'unit', u.id);
    }
    for (final f in faculty) {
      final school = f.affiliations.isNotEmpty ? f.affiliations.first.schoolName : '';
      add('faculty_${f.id}', f.name,
          [f.designation, school].where((e) => e.isNotEmpty).join(' • '), 'Faculty',
          f.profileUrl.isNotEmpty ? f.profileUrl : f.affiliations.firstOrNull?.sourceUrl ?? '',
          'faculty', f.id);
    }
    for (final p in programmes) {
      add('programme_${p.id}', p.displayName,
          [p.group, p.duration].where((e) => e.isNotEmpty).join(' • '), 'Programmes',
          p.officialUrl, 'programme', p.id);
    }
    for (final n in notices) {
      add('notice_${n.id}', n.title, '${n.displayDate} • ${n.category}', 'Notices',
          n.url, 'notice', n.id);
    }
    for (final d in documents) {
      add('doc_${d.id}', d.title,
          [d.authority, d.sizeLabel].where((e) => e.isNotEmpty).join(' • '), 'Documents',
          d.url, 'document', d.id);
    }
    for (final p in photos) {
      add('photo_${p.id}', p.title, 'Official photo gallery', 'Media',
          p.fullUrl, 'photo', p.id);
    }
    for (final v in videos) {
      add('video_${v.id}', v.title, 'Official YouTube video', 'Media',
          v.watchUrl, 'video', v.id);
    }
    for (final l in leadership) {
      add('leader_${l.id}', l.name, l.designation, 'Governance',
          l.sourceUrl, 'leader', l.id);
    }
    for (final f in facilities) {
      add('facility_${f.id}', f.name, f.category, 'Facilities',
          f.sourceUrl, 'facility', f.id);
    }
    return hits;
  }

  /// Legacy page-shaped index used by the global directory screen.
  List<Map<String, dynamic>> pageEntries() {
    return search('').map((h) => <String, dynamic>{
          'id': h.id,
          'title': h.title,
          'category': h.category,
          'url': h.url,
          'description': h.subtitle,
          'kind': h.kind,
          'payload_id': h.payloadId,
        }).toList();
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
