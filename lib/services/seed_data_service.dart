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
        id: "sch_socsci",
        name: "School of Social Sciences",
        dean: "Dr. P. Anandharajakumar",
        deanEmail: "dean_socsci@ruraluniv.ac.in",
        deanPhone: "+91 451 2452371 Ext: 204",
        programmesCount: 14,
        highlights: "Nai Talim Village Internship, Kasturba Seva Ashram Field Action Projects",
      ),
    ];
  }
}
