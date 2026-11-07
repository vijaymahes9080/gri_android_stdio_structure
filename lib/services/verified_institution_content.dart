/// Verified institutional content for The Gandhigram Rural Institute.
///
/// Every value and URL in this file was checked against the live official site
/// (https://www.ruraluniv.ac.in/) during the Phase 1 data audit. Nothing here is
/// inferred: if the university does not publish a value, it is left out rather
/// than guessed.
class VerifiedInstitution {
  VerifiedInstitution._();

  static const String englishName =
      'The Gandhigram Rural Institute (Deemed to be University)';
  static const String tamilName =
      'காந்திகிராம கிராமிய நிகர்நிலைப் பல்கலைக்கழகம்';
  static const String shortName = 'GRI';
  static const String accreditation = 'NAAC A++ Grade (4th Cycle)';
  static const String cgpa = '3.58';
  static const int campusAcres = 207;
  static const int established = 1956;
  static const int deemedUniversity = 1976;
  static const String ministry = 'Ministry of Education, Government of India';
  static const String address =
      'Gandhigram, Dindigul District, Tamil Nadu 624 302, India';
  static const String phone = '0451-2452371';
  static const String email = 'grucc@ruraluniv.ac.in';
  static const String website = 'https://www.ruraluniv.ac.in/';
  static const String mottoTamil = 'கிராமம் உயர நாடு உயரும்';

  /// Official campus map image published by GRI (verified 200 image/png).
  static const String campusMapImageUrl =
      'https://www.ruraluniv.ac.in/files/includes/aboutgri/map/grimap.png';

  /// Exact link used by the "View on Google Maps" action on the official site.
  static const String googleMapsUrl =
      'https://www.google.com/maps/place/The+Gandhigram+Rural+Institute/@10.279323,77.934599,17z';

  // Current official site routes (verified during the audit).
  static const String aboutUrl =
      'https://www.ruraluniv.ac.in/page/about-gri';
  static const String profileUrl =
      'https://www.ruraluniv.ac.in/page/about-gri#profile';
  static const String visionMissionUrl =
      'https://www.ruraluniv.ac.in/page/about-gri#vision-mission';
  static const String locationMapUrl =
      'https://www.ruraluniv.ac.in/page/about-gri#location-map';
  static const String administrationUrl =
      'https://www.ruraluniv.ac.in/page/administration';
  static const String governanceUrl =
      'https://www.ruraluniv.ac.in/page/governance';
  static const String academicsUrl =
      'https://www.ruraluniv.ac.in/page/academics';
  static const String schoolsUrl =
      'https://www.ruraluniv.ac.in/page/academics#schools';
  static const String programmesUrl =
      'https://www.ruraluniv.ac.in/page/academics#programmes';
  static const String admissionsUrl =
      'https://www.ruraluniv.ac.in/page/admissions';
  static const String prospectusUrl =
      'https://www.ruraluniv.ac.in/page/admissions#prospectus';
  static const String examinationUrl =
      'https://www.ruraluniv.ac.in/page/examination';
  static const String cellsUrl = 'https://www.ruraluniv.ac.in/page/cells';
  static const String committeesUrl =
      'https://www.ruraluniv.ac.in/page/committees';
  static const String disclosuresUrl =
      'https://www.ruraluniv.ac.in/page/disclosures';
  static const String naacUrl =
      'https://www.ruraluniv.ac.in/page/disclosures#naac';
  static const String mandatoryDisclosuresUrl =
      'https://www.ruraluniv.ac.in/page/disclosures#mandatory-disclosures';
  static const String rtiUrl = 'https://www.ruraluniv.ac.in/page/rti';
  static const String rulesManualsUrl =
      'https://www.ruraluniv.ac.in/page/rules-manuals';
  static const String facilitiesUrl =
      'https://www.ruraluniv.ac.in/page/facilities';
  static const String infrastructureUrl =
      'https://www.ruraluniv.ac.in/page/infrastructure';
  static const String libraryUrl =
      'https://www.ruraluniv.ac.in/page/library';
  static const String contactUrl =
      'https://www.ruraluniv.ac.in/contact-us';
  static const String faqUrl = 'https://www.ruraluniv.ac.in/faq';
  static const String feedbackUrl =
      'https://www.ruraluniv.ac.in/feedback';
  static const String photoGalleryUrl =
      'https://www.ruraluniv.ac.in/photo-gallery';
  static const String videoGalleryUrl =
      'https://www.ruraluniv.ac.in/video-gallery';
  static const String eventsUrl =
      'https://www.ruraluniv.ac.in/notices/event';
  static const String circularsUrl =
      'https://www.ruraluniv.ac.in/notices/circular';
  static const String studentNoticesUrl =
      'https://www.ruraluniv.ac.in/notices/student';
  static const String tendersUrl =
      'https://www.ruraluniv.ac.in/notices/tender';
  static const String careersUrl =
      'https://www.ruraluniv.ac.in/notices/career';
  static const String samarthUrl =
      'https://ruraluniv.samarth.ac.in/index.php/site/login';
  static const String webmailUrl = 'https://webmail.ruraluniv.ac.in/';
  static const String portalsUrl =
      'https://www.ruraluniv.ac.in/portals';
  static const String grievanceCircularUrl =
      'https://doc.ruraluniv.ac.in/circulars/view/152';

  /// Official site banner text used across the app.
  static const String accreditationLine =
      'NAAC A++ Grade (4th Cycle) • CGPA $cgpa';
}

/// A verified institutional service or information entry.
class InstitutionalService {
  final String id;
  final String title;
  final String description;
  final String category;
  final String url;

  const InstitutionalService({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.url,
  });
}

/// Verified campus facility published on the official infrastructure and
/// facilities pages. Descriptions intentionally stay generic where the official
/// page does not publish operational details (timings, staff names, capacities).
class VerifiedFacility {
  final String id;
  final String name;
  final String category;
  final String sourceUrl;

  const VerifiedFacility({
    required this.id,
    required this.name,
    required this.category,
    required this.sourceUrl,
  });
}

/// A date-stamped official event read from the live GRI events board.
class VerifiedEvent {
  final String id;
  final String title;
  final String dateDisplay;
  final String detail;
  final String url;

  const VerifiedEvent({
    required this.id,
    required this.title,
    required this.dateDisplay,
    required this.detail,
    required this.url,
  });
}

class VerifiedContent {
  VerifiedContent._();

  /// Current GRI event board (retrieved from
  /// https://www.ruraluniv.ac.in/notices/event).
  static const List<VerifiedEvent> events = [
    VerifiedEvent(
      id: 'evt_459',
      title:
          'NSS & Department of Education webinar on Promotion of Millets',
      dateDisplay: '12.11.2026',
      detail: '02.30 PM – 04.30 PM • National Service Scheme, GRI',
      url: 'https://doc.ruraluniv.ac.in/events/view/459',
    ),
    VerifiedEvent(
      id: 'evt_458',
      title: 'NSS & Department of Education webinar on SAVE WATER',
      dateDisplay: '11.11.2026',
      detail: '02.30 PM – 04.30 PM • National Service Scheme, GRI',
      url: 'https://doc.ruraluniv.ac.in/events/view/458',
    ),
    VerifiedEvent(
      id: 'evt_457',
      title: 'Essay Writing Competition',
      dateDisplay: '10.11.2026',
      detail: 'Seminar Hall, Department of Education • 02.30 PM – 04.30 PM',
      url: 'https://doc.ruraluniv.ac.in/events/view/457',
    ),
    VerifiedEvent(
      id: 'evt_454',
      title: 'Call for Papers: ICIMMAC 2027 international conference',
      dateDisplay: '27–29.01.2027',
      detail: 'Organised by the Department of Mathematics, GRI',
      url: 'https://sites.google.com/view/icimmac2027/',
    ),
    VerifiedEvent(
      id: 'evt_ecei',
      title: '10th Eurasian Conference on Educational Innovation 2027',
      dateDisplay: '29–31.01.2027',
      detail: 'INTI International University, Malaysia • with IRELS, NTNU',
      url: 'https://www.ecei.asia',
    ),
    VerifiedEvent(
      id: 'evt_184',
      title:
          'DST Women\'s Training Programme: Green Technology Startups for Women\'s Empowerment',
      dateDisplay: 'Official programme',
      detail: 'Published by The Gandhigram Rural Institute',
      url: 'https://doc.ruraluniv.ac.in/events/view/184',
    ),
    VerifiedEvent(
      id: 'evt_180',
      title: 'Malaviya Mission Teacher Training Programme',
      dateDisplay: 'Official programme',
      detail: 'Published by The Gandhigram Rural Institute',
      url: 'https://doc.ruraluniv.ac.in/events/view/180',
    ),
  ];

  /// Official tender board items currently published by GRI.
  static const List<VerifiedEvent> tenders = [
    VerifiedEvent(
      id: 'tender_455',
      title: 'Corrigendum: Internal Auditor tender notice',
      dateDisplay: 'Corrigendum',
      detail: 'The Gandhigram Rural Institute (DTBU), Gandhigram',
      url: 'https://doc.ruraluniv.ac.in/tenders/view/455',
    ),
    VerifiedEvent(
      id: 'tender_428',
      title: 'Tender: Engagement of Internal Auditor for GRI',
      dateDisplay: 'Closing 26.11.2026, 15.00 hrs',
      detail: 'The Gandhigram Rural Institute (DTBU), Gandhigram',
      url: 'https://doc.ruraluniv.ac.in/tenders/view/428',
    ),
  ];

  static const List<VerifiedFacility> facilities = [
    VerifiedFacility(
      id: 'fac_library',
      name: 'Library (Dr. G.R. Library)',
      category: 'Academic',
      sourceUrl: 'https://www.ruraluniv.ac.in/page/library',
    ),
    VerifiedFacility(
      id: 'fac_computer',
      name: 'Computer Centre',
      category: 'Academic',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/computer-centre',
    ),
    VerifiedFacility(
      id: 'fac_pe',
      name: 'Physical Education and Yoga Centre',
      category: 'Sports',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/physical-education-and-yoga-centre',
    ),
    VerifiedFacility(
      id: 'fac_cic',
      name: 'Central Instrumentation Centre',
      category: 'Research',
      sourceUrl: 'https://www.ruraluniv.ac.in/page/facilities#central-instrumentation-centre',
    ),
    VerifiedFacility(
      id: 'fac_xrd',
      name: 'XRD Facility',
      category: 'Research',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/facilities#xrd-facility',
    ),
    VerifiedFacility(
      id: 'fac_instrument',
      name: 'Instrument Facility (Department of Chemistry)',
      category: 'Research',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/instrument-facility',
    ),
    VerifiedFacility(
      id: 'fac_museum',
      name: 'Museum',
      category: 'Heritage',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/facilities#museum',
    ),
    VerifiedFacility(
      id: 'fac_art',
      name: 'Art Gallery',
      category: 'Heritage',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/facilities#art-gallery',
    ),
    VerifiedFacility(
      id: 'fac_theatre',
      name: 'Theatre',
      category: 'Heritage',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/facilities#theatre',
    ),
    VerifiedFacility(
      id: 'fac_av',
      name: 'Audio Visual Centre',
      category: 'Academic',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/facilities#audio-visual-centre',
    ),
    VerifiedFacility(
      id: 'fac_business',
      name: 'Business Lab',
      category: 'Academic',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/facilities#business-lab',
    ),
    VerifiedFacility(
      id: 'fac_hostels',
      name: 'Hostels',
      category: 'Residential',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#hostels',
    ),
    VerifiedFacility(
      id: 'fac_wwh',
      name: 'Working Women\'s Hostel',
      category: 'Residential',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#working-women-s-hostel',
    ),
    VerifiedFacility(
      id: 'fac_guest',
      name: 'Guest House',
      category: 'Residential',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#guest-house',
    ),
    VerifiedFacility(
      id: 'fac_health',
      name: 'Health Centre',
      category: 'Health',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#health-centre',
    ),
    VerifiedFacility(
      id: 'fac_canteen',
      name: 'Canteen',
      category: 'Services',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#canteen',
    ),
    VerifiedFacility(
      id: 'fac_bank',
      name: 'Bank',
      category: 'Services',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#bank',
    ),
    VerifiedFacility(
      id: 'fac_daycare',
      name: 'Day Care Centre',
      category: 'Services',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#day-care-centre',
    ),
    VerifiedFacility(
      id: 'fac_examhall',
      name: 'Examination Hall',
      category: 'Academic',
      sourceUrl:
          'https://www.ruraluniv.ac.in/page/infrastructure#examination-hall',
    ),
  ];

  static const List<InstitutionalService> services = [
    InstitutionalService(
      id: 'svc_profile',
      title: 'Institutional profile',
      description:
          'Official overview, genesis, vision, mission and campus profile of GRI.',
      category: 'Governance',
      url: 'https://www.ruraluniv.ac.in/page/about-gri#profile',
    ),
    InstitutionalService(
      id: 'svc_vision',
      title: 'Vision & mission',
      description:
          'The university vision and mission as published on the official site.',
      category: 'Governance',
      url: 'https://www.ruraluniv.ac.in/page/about-gri#vision-mission',
    ),
    InstitutionalService(
      id: 'svc_governance',
      title: 'Governance system',
      description:
          'Executive Council, Academic Council, Finance Committee and Planning & Monitoring Board.',
      category: 'Governance',
      url: 'https://www.ruraluniv.ac.in/page/governance',
    ),
    InstitutionalService(
      id: 'svc_administration',
      title: 'Administration & officers',
      description:
          'Chancellor, Vice-Chancellor, Registrar, COE, Finance Officer, Deans and Heads of Departments.',
      category: 'Governance',
      url: 'https://www.ruraluniv.ac.in/page/administration',
    ),
    InstitutionalService(
      id: 'svc_schools',
      title: 'Schools & departments',
      description:
          'Official directory of GRI schools, departments and centres.',
      category: 'Academics',
      url: 'https://www.ruraluniv.ac.in/page/academics#schools',
    ),
    InstitutionalService(
      id: 'svc_programmes',
      title: 'Programmes offered',
      description:
          'Undergraduate, postgraduate, research and vocational programmes.',
      category: 'Academics',
      url: 'https://www.ruraluniv.ac.in/page/academics#programmes',
    ),
    InstitutionalService(
      id: 'svc_admissions',
      title: 'Admissions & prospectus',
      description:
          'Admission process, prospectus and programme regulations.',
      category: 'Academics',
      url: 'https://www.ruraluniv.ac.in/page/admissions',
    ),
    InstitutionalService(
      id: 'svc_exam',
      title: 'Examination services',
      description:
          'Examination system, timetables, applications, certificates and e-SANAD.',
      category: 'Academics',
      url: 'https://www.ruraluniv.ac.in/page/examination',
    ),
    InstitutionalService(
      id: 'svc_library',
      title: 'Library',
      description:
          'Dr. G.R. Library collections, e-resources and library services.',
      category: 'Academics',
      url: 'https://www.ruraluniv.ac.in/page/library',
    ),
    InstitutionalService(
      id: 'svc_rnd',
      title: 'Research & Development Cell',
      description:
          'Research support, development cell and institutional research initiatives.',
      category: 'Research',
      url:
          'https://www.ruraluniv.ac.in/page/academics#research-development-cell',
    ),
    InstitutionalService(
      id: 'svc_research_facility',
      title: 'Facilities to support research',
      description:
          'Central instrumentation and research facilities published by GRI.',
      category: 'Research',
      url:
          'https://www.ruraluniv.ac.in/page/facilities#facility-to-support-research',
    ),
    InstitutionalService(
      id: 'svc_ipr',
      title: 'IPR Cell',
      description:
          'Intellectual Property Rights cell information.',
      category: 'Research',
      url: 'https://www.ruraluniv.ac.in/page/academics#ipr-cell',
    ),
    InstitutionalService(
      id: 'svc_nss',
      title: 'National Service Scheme (NSS)',
      description:
          'NSS unit activities and programme information.',
      category: 'Student Support',
      url: 'https://www.ruraluniv.ac.in/page/cells#nss',
    ),
    InstitutionalService(
      id: 'svc_uba',
      title: 'Unnat Bharat Abhiyan (UBA)',
      description:
          'UBA GRI Seaweed Startup Facility and rural engagement initiative.',
      category: 'Student Support',
      url:
          'https://www.ruraluniv.ac.in/page/uba-gri-seaweed-startup-facility',
    ),
    InstitutionalService(
      id: 'svc_shanti',
      title: 'Shanti Sena',
      description:
          'Gandhian best-practice initiative. A dedicated Shanti Sena page is not currently published; details are covered under institutional best practices.',
      category: 'Student Support',
      url:
          'https://www.ruraluniv.ac.in/page/about-gri#best-practices-institutional-distinctiveness',
    ),
    InstitutionalService(
      id: 'svc_iqac',
      title: 'Internal Quality Assurance Cell (IQAC)',
      description:
          'Quality assurance, institutional planning and monitoring.',
      category: 'Accreditation',
      url: 'https://www.ruraluniv.ac.in/page/cells#iqac',
    ),
    InstitutionalService(
      id: 'svc_naac',
      title: 'NAAC, NIRF & rankings',
      description:
          'NAAC A++ Grade (4th Cycle, CGPA 3.58), NIRF and institutional ranking disclosures.',
      category: 'Accreditation',
      url: 'https://www.ruraluniv.ac.in/page/disclosures#naac',
    ),
    InstitutionalService(
      id: 'svc_disclosures',
      title: 'Mandatory disclosures',
      description:
          'Mandatory institutional disclosures, 12B status, AICTE and NCTE information.',
      category: 'Accreditation',
      url:
          'https://www.ruraluniv.ac.in/page/disclosures#mandatory-disclosures',
    ),
    InstitutionalService(
      id: 'svc_aishe',
      title: 'AISHE & institutional data',
      description:
          'Institutional data published under the mandatory disclosure section.',
      category: 'Accreditation',
      url:
          'https://www.ruraluniv.ac.in/page/disclosures#mandatory-disclosures',
    ),
    InstitutionalService(
      id: 'svc_rti',
      title: 'Right to Information (RTI)',
      description:
          'Public Information Officer, officers for RTI, MoA and bye-laws.',
      category: 'Compliance',
      url: 'https://www.ruraluniv.ac.in/page/rti',
    ),
    InstitutionalService(
      id: 'svc_rules',
      title: 'Rules & manuals',
      description:
          'Deemed to be University Regulations 2023, CCS rules and codes of conduct.',
      category: 'Compliance',
      url: 'https://www.ruraluniv.ac.in/page/rules-manuals',
    ),
    InstitutionalService(
      id: 'svc_committees',
      title: 'Committees',
      description:
          'Institutional committees published by the university.',
      category: 'Compliance',
      url: 'https://www.ruraluniv.ac.in/page/committees',
    ),
    InstitutionalService(
      id: 'svc_antiragging',
      title: 'Anti-Ragging',
      description:
          'Anti-ragging committee, UGC regulations and reporting information.',
      category: 'Student Support',
      url: 'https://www.ruraluniv.ac.in/page/cells#anti-ragging',
    ),
    InstitutionalService(
      id: 'svc_eoc',
      title: 'Equal Opportunity Cell',
      description:
          'Equal opportunity and inclusive campus support.',
      category: 'Student Support',
      url:
          'https://www.ruraluniv.ac.in/page/cells#equal-opportunity-cell',
    ),
    InstitutionalService(
      id: 'svc_reservation',
      title: 'Reservation Cell',
      description:
          'Reservation policy and student support information.',
      category: 'Student Support',
      url:
          'https://www.ruraluniv.ac.in/page/cells#reservation-cell',
    ),
    InstitutionalService(
      id: 'svc_placement',
      title: 'Training & Placement',
      description:
          'Centre for Training and Placement activities and updates.',
      category: 'Student Support',
      url:
          'https://www.ruraluniv.ac.in/page/cells#centre-for-training-and-placement',
    ),
    InstitutionalService(
      id: 'svc_grievance',
      title: 'Student grievance & ombudsperson',
      description:
          'Official circular on student grievance redressal and appointment of the Ombudsperson.',
      category: 'Student Support',
      url: 'https://doc.ruraluniv.ac.in/circulars/view/152',
    ),
    InstitutionalService(
      id: 'svc_events',
      title: 'Events',
      description:
          'Workshops, webinars, conferences and campus activities.',
      category: 'Media',
      url: 'https://www.ruraluniv.ac.in/notices/event',
    ),
    InstitutionalService(
      id: 'svc_circulars',
      title: 'Circulars',
      description:
          'Official university circulars and office orders.',
      category: 'Media',
      url: 'https://www.ruraluniv.ac.in/notices/circular',
    ),
    InstitutionalService(
      id: 'svc_public_notices',
      title: 'Public notices',
      description:
          'Public notices published by the university.',
      category: 'Media',
      url: 'https://www.ruraluniv.ac.in/page/information#public-notices',
    ),
    InstitutionalService(
      id: 'svc_tenders',
      title: 'Tenders',
      description:
          'Official tender notices and corrigenda.',
      category: 'Media',
      url: 'https://www.ruraluniv.ac.in/notices/tender',
    ),
    InstitutionalService(
      id: 'svc_careers',
      title: 'Careers',
      description:
          'Official recruitment and career announcements.',
      category: 'Media',
      url: 'https://www.ruraluniv.ac.in/notices/career',
    ),
    InstitutionalService(
      id: 'svc_faq',
      title: 'FAQ',
      description:
          'Frequently asked questions published on the official website.',
      category: 'Help',
      url: 'https://www.ruraluniv.ac.in/faq',
    ),
    InstitutionalService(
      id: 'svc_feedback',
      title: 'Feedback',
      description:
          'Official feedback form for website and institutional services.',
      category: 'Help',
      url: 'https://www.ruraluniv.ac.in/feedback',
    ),
    InstitutionalService(
      id: 'svc_contact',
      title: 'Contact GRI',
      description:
          'Official contact details and campus location.',
      category: 'Help',
      url: 'https://www.ruraluniv.ac.in/contact-us',
    ),
    InstitutionalService(
      id: 'svc_alumni',
      title: 'Alumni',
      description:
          'GRI alumni network information.',
      category: 'Help',
      url: 'https://www.ruraluniv.ac.in/includes/AlumniGRI',
    ),
    InstitutionalService(
      id: 'svc_photo',
      title: 'Photo gallery',
      description:
          'Official campus photographs published by GRI.',
      category: 'Media',
      url: 'https://www.ruraluniv.ac.in/photo-gallery',
    ),
    InstitutionalService(
      id: 'svc_video',
      title: 'Video gallery',
      description:
          'Official videos published by GRI.',
      category: 'Media',
      url: 'https://www.ruraluniv.ac.in/video-gallery',
    ),
  ];

  /// Canonical category labels used by the institutional services screen.
  static List<String> get serviceCategories {
    final seen = <String>{};
    final list = <String>[];
    for (final s in services) {
      if (seen.add(s.category)) list.add(s.category);
    }
    return list;
  }
}

/// Cleans strings produced by the collected canonical dataset. Some Tamil
/// fields and document titles were lossy during collection and contain
/// replacement characters or runs of question marks. Cleaning is display-only:
/// the original canonical JSON is never modified.
class OfficialText {
  OfficialText._();

  static String clean(String? value) {
    if (value == null) return '';
    var s = value;
    final hadArtifacts =
        s.contains('\uFFFD') || RegExp(r'\?{2,}').hasMatch(s) || s.contains('�');
    s = s.replaceAll('\uFFFD', ' ');
    s = s.replaceAll('�', ' ');
    s = s.replaceAll(RegExp(r'\?{2,}'), ' ');
    s = s.replaceAll(RegExp(r'[ \t]+'), ' ');
    if (hadArtifacts) {
      s = s.replaceAll(RegExp(r'[\s+–—-]+$'), '');
    }
    return s.trim();
  }

  /// Cleans long extracted page bodies by removing the site chrome that the
  /// collector captured alongside the article.
  static String cleanBody(String? value, {int maxLength = 900}) {
    final cleaned = clean(value);
    if (cleaned.isEmpty) return '';
    var body = cleaned;
    for (final marker in const [
      'Skip to main content',
      'Screen Reader Access',
      'Ministry of Education',
      'Swipe up or tap here to close menu',
    ]) {
      final index = body.indexOf(marker);
      if (index == 0) {
        final next = body.indexOf('\n', index);
        if (next > 0) body = body.substring(next + 1);
      } else if (index > 40) {
        body = body.substring(0, index);
      }
    }
    body = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (body.length > maxLength) {
      body = '${body.substring(0, maxLength - 1).trimRight()}…';
    }
    return body;
  }

  /// A title that is safe to display, with an explicit fallback when the
  /// collected title was entirely corrupted.
  static String title(String? value, {String fallback = 'Official GRI record'}) {
    final cleaned = clean(value);
    return cleaned.isEmpty ? fallback : cleaned;
  }
}
