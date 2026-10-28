import '../models/academic_models.dart';

class SahayakReply {
  final String text;
  final List<String> sources;
  final bool grounded;

  const SahayakReply({
    required this.text,
    this.sources = const [],
    this.grounded = false,
  });
}

class _KnowledgeEntry {
  final List<String> keywords;
  final String answer;
  final List<String> sources;

  const _KnowledgeEntry(this.keywords, this.answer, this.sources);
}

/// Local retrieval engine for the GRI-Sahayak assistant.
///
/// Answers are produced by scoring the query against a institutional knowledge
/// corpus. An answer is only attributed to a source when that entry actually
/// matched; the non-grounded fallback never claims an official origin. The
/// engine runs fully offline and requires no external service.
class SahayakKnowledgeEngine {
  static SahayakKnowledgeEngine? _instance;
  static SahayakKnowledgeEngine get instance =>
      _instance ??= SahayakKnowledgeEngine._();
  SahayakKnowledgeEngine._();

  static const Set<String> _stopWords = {
    'the', 'a', 'an', 'is', 'are', 'was', 'were', 'of', 'in', 'on', 'at', 'to',
    'for', 'and', 'or', 'how', 'what', 'when', 'where', 'who', 'do', 'does',
    'did', 'can', 'could', 'i', 'my', 'me', 'we', 'you', 'your', 'it', 'this',
    'that', 'with', 'about', 'be', 'been', 'there', 'please', 'tell', 'want',
    'need', 'know', 'any', 'have', 'has', 'from', 'give', 'some',
  };

  static const String _siteUrl = 'https://ruraluniv.ac.in/';
  static const String _circularsUrl = 'https://ruraluniv.ac.in/gridu?content=circular';
  static const String _libraryUrl = 'https://ruraluniv.ac.in/facilities?content=library';
  static const String _cbcsUrl = 'https://ruraluniv.ac.in/academics?content=CBCSsystem';
  static const String _admissionsUrl = 'https://ruraluniv.samarth.ac.in/index.php/site/login';
  static const String _prospectusUrl =
      'https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf';
  static const String _esanadUrl = 'http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf';
  static const String _nirfUrl = 'https://ruraluniv.ac.in/gri?CC=NIRF1';
  static const String _antiRaggingUrl =
      'https://ruraluniv.ac.in/gridu?content=AntiRaggingCommittee';

  static final List<_KnowledgeEntry> _corpus = [
    const _KnowledgeEntry(
      [
        'admission', 'admissions', 'apply', 'application', 'cuet', 'entrance',
        'eligibility', 'enroll', 'enrollment', 'join', 'seat', 'prospectus',
      ],
      'Admissions at The Gandhigram Rural Institute are conducted through '
          'CUET-UG, CUET-PG and the GRI All-India entrance route. Applicants '
          'register on the Samarth admission portal; the official 2026-27 '
          'prospectus lists programme-wise eligibility, seat matrix and fees.',
      [_admissionsUrl, _prospectusUrl],
    ),
    const _KnowledgeEntry(
      [
        'exam', 'exams', 'examination', 'hall', 'ticket', 'hallticket',
        'result', 'results', 'timetable', 'schedule', 'coe',
      ],
      'End-semester examinations are conducted under the Choice Based Credit '
          'System (CBCS). Hall tickets are issued only to students holding at '
          'least 75% attendance in every enrolled course, and can be generated '
          'from the Academics hub in this app. Transcript and duplicate-'
          'certificate request forms are published by the Controller of '
          'Examinations.',
      [_circularsUrl, _cbcsUrl],
    ),
    const _KnowledgeEntry(
      [
        'attendance', 'condonation', 'shortage', 'leave',
      ],
      'Academic regulations require a minimum of 75% attendance in each '
          'course to become eligible for end-semester examinations. '
          'Condonation of shortage between 65% and 74% may be considered by '
          'the Vice-Chancellor on certified medical grounds.',
      [_cbcsUrl],
    ),
    const _KnowledgeEntry(
      [
        'hostel', 'hostels', 'mess', 'residence', 'accommodation', 'rebate',
        'warden', 'stay',
      ],
      'GRI provides residential facilities including Kasturba Hostel for '
          'women and Tagore and Bapu hostels for men. Meals are managed by '
          'student mess committees, and mess rebate applications are collected '
          'by the Chief Warden before each vacation window.',
      [_siteUrl],
    ),
    const _KnowledgeEntry(
      ['bus', 'transport', 'route', 'routes', 'pass', 'commute', 'driver'],
      'The university operates scheduled bus services from Dindigul Bus '
          'Stand, Madurai Mattuthavani and Batlagundu. Concessional semester '
          'passes are issued to regular students; live route, driver and '
          'timing details are available in the Campus hub.',
      [_siteUrl],
    ),
    const _KnowledgeEntry(
      [
        'library', 'book', 'books', 'journal', 'journals', 'digital',
        'repository', 'ieee',
      ],
      'Dr. Radhakrishnan Central Library holds over 1,80,000 volumes with '
          'online access to IEEE, Springer and UGC INFONET repositories and a '
          'collection of classical Tamil palm-leaf archives.',
      [_libraryUrl],
    ),
    const _KnowledgeEntry(
      [
        'certificate', 'certificates', 'verification', 'verify', 'authentic',
        'transcript', 'degree', 'marksheet', 'esanad', 'e-sanad', 'migration',
      ],
      'Degree certificates, statements of marks and transcripts can be '
          'verified under the Official Document Center using their GRI- '
          'identifier, and are transferred digitally through the National '
          'e-SANAD/DigiLocker facility.',
      [_esanadUrl],
    ),
    const _KnowledgeEntry(
      ['nirf', 'ranking', 'rank', 'naac', 'accreditation', 'grade'],
      'The Gandhigram Rural Institute publishes its institutional data under '
          'the National Institutional Ranking Framework and is accredited by '
          'NAAC. Current disclosures are available on the official site.',
      [_nirfUrl],
    ),
    const _KnowledgeEntry(
      [
        'ragging', 'antiragging', 'anti', 'harassment', 'complaint',
        'discipline',
      ],
      'GRI operates an Anti-Ragging Committee under UGC regulations. '
          'Complaints can be reported confidentially through the national '
          'anti-ragging portal and the committee page on the university site.',
      [_antiRaggingUrl],
    ),
    const _KnowledgeEntry(
      [
        'scholarship', 'scholarships', 'stipend', 'fellowship', 'welfare',
      ],
      'Students can access post-matric and other welfare scholarship schemes; '
          'the Scholarships & Welfare hub lists each scheme with eligibility '
          'and the official application notice.',
      [_siteUrl],
    ),
    const _KnowledgeEntry(
      [
        'gandhi', 'nai', 'talim', 'history', 'founded', 'founding', '1947',
        'heritage', 'philosophy', 'soundram', 'ramachandran',
      ],
      'Founded in 1947 by the Gandhian workers Dr. T. S. Soundram and '
          'Dr. G. Ramachandran, the institute follows the Nai Talim philosophy '
          'that integrates teaching, research and extension for rural '
          'transformation.',
      [_siteUrl],
    ),
    const _KnowledgeEntry(
      ['contact', 'address', 'phone', 'email', 'office', 'reach', 'location'],
      'The Gandhigram Rural Institute (Deemed to be University) is located at '
          'Gandhigram, Dindigul District, Tamil Nadu 624302. Department-wise '
          'contacts and the administrative directory are available in the '
          '"More" section of this app.',
      [_siteUrl],
    ),
  ];

  List<Map<String, String>> _tokenize(String query) {
    final raw = query
        .toLowerCase()
        .split(RegExp(r'[^a-z0-9]+'))
        .where((t) => t.isNotEmpty)
        .toList();
    final content = <Map<String, String>>[];
    for (final token in raw) {
      final meaningful = token.length >= 3 && !_stopWords.contains(token);
      if (meaningful) {
        var stem = token;
        if (stem.length > 4 && stem.endsWith('s') && !stem.endsWith('ss')) {
          stem = stem.substring(0, stem.length - 1);
        }
        content.add({'token': token, 'stem': stem});
      } else if (token.length == 2) {
        content.add({'token': token, 'stem': token});
      }
    }
    return content;
  }

  SahayakReply answer(
    String query, {
    List<CircularModel> circulars = const [],
    List<TransportRouteModel> routes = const [],
  }) {
    final q = query.trim();
    if (q.isEmpty) {
      return const SahayakReply(text: ''); // caller treats as no-op
    }

    // Live circulars are matched first so current notices win over static text.
    for (final circular in circulars) {
      final hay = '${circular.title} ${circular.category} ${circular.summary}'
          .toLowerCase();
      final tokens = _tokenize(q).map((t) => t['token']!).toList();
      var hits = 0;
      for (final token in tokens) {
        if (hay.contains(token)) hits++;
      }
      if (tokens.isNotEmpty &&
          hits >= (tokens.length == 1 && tokens.first.length >= 4 ? 1 : 2)) {
        return SahayakReply(
          text:
              'Current official circular — "${circular.title}" '
              '(category: ${circular.category}):\n\n${circular.summary}\n\n'
              'Issued by ${circular.issuedBy}. All live notices are listed on '
              'the circulars page of the university website.',
          sources: [_circularsUrl],
          grounded: true,
        );
      }
    }

    final queryTokens = _tokenize(q);
    if (queryTokens.isEmpty) {
      return _fallbackReply();
    }

    _KnowledgeEntry? best;
    var bestScore = 0;
    for (final entry in _corpus) {
      var score = 0;
      for (final qt in queryTokens) {
        for (final keyword in entry.keywords) {
          if (qt['stem'] == keyword || qt['token'] == keyword) {
            score += 2;
          } else if (keyword.startsWith(qt['stem']!) && qt['stem']!.length >= 4) {
            score += 1;
          }
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = entry;
      }
    }

    if (best != null && bestScore >= 2) {
      final sourceLine = best.sources.isNotEmpty
          ? '\n\nSource: ${best.sources.join('  •  ')}'
          : '';
      return SahayakReply(
        text: '${best.answer}$sourceLine',
        sources: best.sources,
        grounded: true,
      );
    }

    return _fallbackReply();
  }

  SahayakReply _fallbackReply() {
    return const SahayakReply(
      text:
          'I do not have a verified institutional answer for that yet. I can '
          'ground my replies in admissions, examinations and hall tickets, '
          'attendance rules, certificate verification, hostels, transport, '
          'library, scholarships, NIRF/NAAC data and anti-ragging policy. For '
          'anything outside that scope please use the Official Portals '
          'gateway or the university site.',
    );
  }
}
