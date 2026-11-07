import '../models/official_models.dart';
import 'official_catalog_service.dart';
import 'verified_institution_content.dart';

/// A grounded answer produced from the verified official catalogue.
class RagResult {
  final String text;
  final List<String> sources;
  final bool grounded;
  final double confidence;

  const RagResult({
    required this.text,
    required this.sources,
    this.grounded = true,
    this.confidence = 0.6,
  });
}

/// Deterministic retrieval-augmented answering over the canonical GRI dataset.
///
/// The service never calls an external model and never fabricates values. It
/// selects records from [OfficialCatalogService] (built from the official site)
/// and from the audited [VerifiedInstitution] routes, then cites the source URL
/// for every statement it returns.
class OfficialRagService {
  OfficialRagService._();
  static final OfficialRagService instance = OfficialRagService._();

  static String _source(String url) =>
      url.replaceFirst('https://www.ruraluniv.ac.in/', 'https://ruraluniv.ac.in/');

  static String _withSources(String body, List<String> sources) {
    final unique = <String>[];
    for (final s in sources) {
      if (s.trim().isEmpty) continue;
      if (!unique.contains(s)) unique.add(s);
    }
    if (unique.isEmpty) return body;
    return '$body\n\nSource: ${unique.join('  •  ')}';
  }

  /// Returns null when the query has no confident match, so the caller can fall
  /// back to another explanation path instead of guessing.
  RagResult? answer(String query) {
    final catalog = OfficialCatalogService.instance;
    if (!catalog.isLoaded) return null;

    final q = OfficialText.clean(query).toLowerCase();
    if (q.trim().isEmpty) return null;
    final tokens = q
        .split(RegExp(r'[^a-z0-9\u0B80-\u0BFF]+'))
        .where((t) => t.length >= 2)
        .toList();

    bool hasAny(List<String> needles) =>
        needles.any((n) => q.contains(n));

    final matched = <_CatalogMatch>[];
    void scoreUnits() {
      for (final u in catalog.units) {
        final hay = '${u.name} ${u.type} ${u.description}'.toLowerCase();
        final hits = tokens.where((t) => t.length >= 3 && hay.contains(t)).length;
        if (hits > 0) {
          matched.add(_CatalogMatch(
            score: hits * 3,
            text: _unitAnswer(u, catalog),
            sources: [_source(u.url)],
          ));
        }
      }
    }

    void scoreFaculty() {
      for (final f in catalog.faculty) {
        final hay =
            '${f.name} ${f.designation} ${f.specialization} ${f.qualifications}'
                .toLowerCase();
        final hits = tokens.where((t) => t.length >= 3 && hay.contains(t)).length;
        if (hits > 0) {
          matched.add(_CatalogMatch(
            score: hits * 4,
            text: _facultyAnswer(f),
            sources: [
              _source(f.profileUrl.isNotEmpty
                  ? f.profileUrl
                  : (f.affiliations.isNotEmpty
                      ? f.affiliations.first.sourceUrl
                      : VerifiedInstitution.administrationUrl)),
            ],
          ));
        }
      }
    }

    void scoreProgrammes() {
      for (final p in catalog.programmes) {
        final hay =
            '${p.displayName} ${p.name} ${p.group} ${p.tags.join(' ')}'
                .toLowerCase();
        final hits = tokens.where((t) => t.length >= 3 && hay.contains(t)).length;
        if (hits > 0) {
          matched.add(_CatalogMatch(
            score: hits * 3,
            text: _programmeAnswer(p, catalog),
            sources: [
              _source(p.officialUrl.isNotEmpty
                  ? p.officialUrl
                  : VerifiedInstitution.programmesUrl),
            ],
          ));
        }
      }
    }

    // Intent routes come first: they describe published information and always
    // carry an official source.
    if (hasAny(['admission', 'apply', 'eligibility', 'prospectus', 'சேர்க்கை', 'விண்ணப்ப', 'சேர'])) {
      return RagResult(
        text: _withSources(
          'Admissions are handled by GRI through the official process published '
          'on the admissions page: CUET-UG / CUET-PG and GRI entrance routes, '
          'programme eligibility, the prospectus and regulations. Applications '
          'are submitted on the official Samarth admission portal. This app does '
          'not submit or track applications on your behalf.',
          [
            _source(VerifiedInstitution.admissionsUrl),
            _source(VerifiedInstitution.samarthUrl),
          ],
        ),
        sources: [
          _source(VerifiedInstitution.admissionsUrl),
          _source(VerifiedInstitution.samarthUrl),
        ],
        confidence: 0.9,
      );
    }

    if (hasAny(['naac', 'nirf', 'rank', 'accreditation', 'cgpa', 'grade', 'தரச்சான்று'])) {
      return RagResult(
        text: _withSources(
          'GRI is accredited by NAAC with an A++ Grade in its 4th cycle '
          '(2025), with a CGPA of ${VerifiedInstitution.cgpa}. NAAC, NIRF and '
          'ranking disclosures are published on the official disclosures page.',
          [_source(VerifiedInstitution.naacUrl)],
        ),
        sources: [_source(VerifiedInstitution.naacUrl)],
        confidence: 0.95,
      );
    }

    if (hasAny(['library', 'book', 'journal', 'நூலகம்', 'புத்தகம்'])) {
      return RagResult(
        text: _withSources(
          'The Dr. G.R. Library (Central Library) is the university library. '
          'Its published collections, e-resources and service details are on the '
          'official library page. Current opening hours and borrowing rules are '
          'not part of the verified in-app dataset — confirm them on the '
          'official page before travelling.',
          [_source(VerifiedInstitution.libraryUrl)],
        ),
        sources: [_source(VerifiedInstitution.libraryUrl)],
        confidence: 0.85,
      );
    }

    if (hasAny(['hostel', 'mess', 'accommodation', 'விடுதி', 'உணவு'])) {
      return RagResult(
        text: _withSources(
          'GRI publishes its hostel and residential facilities on the official '
          'infrastructure page. Hostel allotment, mess rules and fees are '
          'administered by the university; this app does not display official '
          'allotment records.',
          [
            _source('${VerifiedInstitution.infrastructureUrl}#hostels'),
            _source('https://ruraluniv.ac.in/grihostel/login'),
          ],
        ),
        sources: [
          _source('${VerifiedInstitution.infrastructureUrl}#hostels'),
          _source('https://ruraluniv.ac.in/grihostel/login'),
        ],
        confidence: 0.8,
      );
    }

    if (hasAny(['exam', 'result', 'hall ticket', 'timetable', 'தேர்வு', 'முடிவு'])) {
      return RagResult(
        text: _withSources(
          'End-semester examinations follow the Choice Based Credit System '
          '(CBCS). GRI publishes the examination system, timetables, '
          'applications and certificates on the examination page. A minimum of '
          '75% attendance is required for examination eligibility under the '
          'published CBCS regulations. Certificate verification is available '
          'through the national e-SANAD facility.',
          [
            _source(VerifiedInstitution.examinationUrl),
            _source('https://ruraluniv.ac.in/page/examination#e-sanad'),
          ],
        ),
        sources: [
          _source(VerifiedInstitution.examinationUrl),
          _source('https://ruraluniv.ac.in/page/examination#e-sanad'),
        ],
        confidence: 0.85,
      );
    }

    if (hasAny(['contact', 'phone', 'email', 'address', 'location', 'தொடர்பு', 'முகவரி'])) {
      return RagResult(
        text: _withSources(
          'The Gandhigram Rural Institute is located at '
          '${VerifiedInstitution.address}. Official contact: '
          '${VerifiedInstitution.phone} • ${VerifiedInstitution.email}.',
          [_source(VerifiedInstitution.contactUrl)],
        ),
        sources: [_source(VerifiedInstitution.contactUrl)],
        confidence: 0.9,
      );
    }

    if (hasAny(['event', 'seminar', 'conference', 'workshop', 'நிகழ்வு'])) {
      final top = VerifiedContent.events.take(3);
      final body = top
          .map((e) => '• ${e.title} — ${e.dateDisplay} (${e.detail})')
          .join('\n');
      return RagResult(
        text: _withSources(
          'Current events on the official GRI events board:\n\n$body',
          [_source(VerifiedInstitution.eventsUrl)],
        ),
        sources: [_source(VerifiedInstitution.eventsUrl)],
        confidence: 0.85,
      );
    }

    if (hasAny(['tender', 'career', 'recruitment', 'job', 'வேலை'])) {
      return RagResult(
        text: _withSources(
          'Official tender and career notices are published on the GRI notice '
          'boards. The careers board currently shows no open notices; the tender '
          'board lists the internal-auditor tender and its corrigendum.',
          [
            _source(VerifiedInstitution.tendersUrl),
            _source(VerifiedInstitution.careersUrl),
          ],
        ),
        sources: [
          _source(VerifiedInstitution.tendersUrl),
          _source(VerifiedInstitution.careersUrl),
        ],
        confidence: 0.8,
      );
    }

    if (hasAny(['fee', 'payment', 'pay', 'கட்டணம்'])) {
      return RagResult(
        text: _withSources(
          'Fee amounts and payment instructions are published by GRI. This app '
          'does not process fee payments or verify transactions; use only the '
          'official university payment route linked from the admissions page.',
          [
            _source(VerifiedInstitution.admissionsUrl),
            _source(VerifiedInstitution.samarthUrl),
          ],
        ),
        sources: [
          _source(VerifiedInstitution.admissionsUrl),
          _source(VerifiedInstitution.samarthUrl),
        ],
        confidence: 0.75,
      );
    }

    if (hasAny(['research', 'ph.d', 'phd', 'publication', 'ஆராய்ச்சி'])) {
      return RagResult(
        text: _withSources(
          'GRI research activity is coordinated through the Research & '
          'Development Cell and supported by the Central Instrumentation and '
          'other research facilities. Research programmes, facilities and '
          'publications are listed on the official pages.',
          [
            _source(
                'https://ruraluniv.ac.in/page/academics#research-development-cell'),
            _source(
                'https://ruraluniv.ac.in/page/facilities#facility-to-support-research'),
          ],
        ),
        sources: [
          _source(
              'https://ruraluniv.ac.in/page/academics#research-development-cell'),
          _source(
              'https://ruraluniv.ac.in/page/facilities#facility-to-support-research'),
        ],
        confidence: 0.8,
      );
    }

    scoreUnits();
    scoreFaculty();
    scoreProgrammes();
    if (matched.isNotEmpty) {
      matched.sort((a, b) => b.score.compareTo(a.score));
      final best = matched.first;
      if (best.score >= 3) {
        return RagResult(
          text: _withSources(best.text, best.sources),
          sources: best.sources,
          confidence: best.score >= 6 ? 0.85 : 0.65,
        );
      }
    }

    return null;
  }

  String _unitAnswer(OfficialUnit unit, OfficialCatalogService catalog) {
    final school = catalog.schoolById(unit.schoolId)?.name ?? '';
    final profile = OfficialText.cleanBody(unit.profile, maxLength: 420);
    final description = OfficialText.cleanBody(unit.description, maxLength: 280);
    final body = profile.isNotEmpty ? profile : description;
    final programmes = catalog.programmesForUnit(unit.id);
    final buffer = StringBuffer();
    buffer.writeln('${OfficialText.title(unit.name)} (${unit.academicLevel})');
    if (school.isNotEmpty) buffer.writeln(school);
    if (body.isNotEmpty) buffer.writeln('\n$body');
    if (programmes.isNotEmpty) {
      buffer.writeln('\nProgrammes published for this unit:');
      for (final p in programmes.take(6)) {
        buffer.writeln('• ${OfficialText.title(p.displayName)}');
      }
    }
    buffer.write('\nOfficial page: ${_source(unit.url)}');
    return buffer.toString().trim();
  }

  String _facultyAnswer(OfficialFaculty faculty) {
    final aff = faculty.affiliations.isNotEmpty ? faculty.affiliations.first : null;
    final buffer = StringBuffer();
    buffer.writeln(OfficialText.title(faculty.name));
    if (faculty.designation.isNotEmpty) buffer.writeln(faculty.designation);
    if (aff != null) {
      buffer.writeln(
          [aff.unitName, aff.schoolName].where((e) => e.isNotEmpty).join(' • '));
    }
    if (faculty.qualifications.isNotEmpty) {
      buffer.writeln('Qualifications: ${OfficialText.clean(faculty.qualifications)}');
    }
    if (faculty.specialization.isNotEmpty) {
      buffer.writeln(
          'Specialisation: ${OfficialText.clean(faculty.specialization)}');
    }
    buffer.write(
        '\nOfficial profile: ${_source(faculty.profileUrl.isNotEmpty ? faculty.profileUrl : (aff?.sourceUrl ?? VerifiedInstitution.administrationUrl))}');
    return buffer.toString().trim();
  }

  String _programmeAnswer(OfficialProgramme programme, OfficialCatalogService catalog) {
    final unit = catalog.unitById(programme.unitId);
    final buffer = StringBuffer();
    buffer.writeln(OfficialText.title(programme.displayName));
    if (programme.group.isNotEmpty) buffer.writeln(programme.group);
    if (unit != null) buffer.writeln(unit.name);
    if (programme.duration.isNotEmpty) {
      buffer.writeln('Duration: ${programme.duration}');
    }
    if (programme.eligibility.isNotEmpty) {
      buffer.writeln('Eligibility: ${OfficialText.clean(programme.eligibility)}');
    }
    buffer.write(
        '\nOfficial page: ${_source(programme.officialUrl.isNotEmpty ? programme.officialUrl : VerifiedInstitution.programmesUrl)}');
    return buffer.toString().trim();
  }
}

class _CatalogMatch {
  final int score;
  final String text;
  final List<String> sources;

  const _CatalogMatch({
    required this.score,
    required this.text,
    required this.sources,
  });
}
