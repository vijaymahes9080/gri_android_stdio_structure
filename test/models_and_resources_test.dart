import 'package:flutter_test/flutter_test.dart';
import 'package:gri_app/models/academic_models.dart';
import 'package:gri_app/services/official_resource_registry.dart';
import 'package:gri_app/services/seed_data_service.dart';

void main() {
  group('OfficialResourceRegistry Tests', () {
    test('Registry contains all 24 core official verified institutional resources', () {
      final registry = OfficialResourceRegistry.registry;
      expect(registry.length, greaterThanOrEqualTo(24));

      // Key documents verification
      expect(registry.containsKey('DOC_PROSPECTUS_2026'), isTrue);
      expect(registry.containsKey('DOC_PROSPECTUS_2025'), isTrue);
      expect(registry.containsKey('DOC_COE_TRANSCRIPT'), isTrue);
      expect(registry.containsKey('DOC_COE_DUPLICATE'), isTrue);
      expect(registry.containsKey('DOC_COE_REVALUATION'), isTrue);
      expect(registry.containsKey('DOC_COE_MIGRATION'), isTrue);
      expect(registry.containsKey('DOC_ANTI_RAGGING_AFFIDAVIT'), isTrue);
      expect(registry.containsKey('DOC_NIRF_2024_REPORT'), isTrue);
      expect(registry.containsKey('DOC_NAAC_SSR_CYCLE4'), isTrue);
      expect(registry.containsKey('DOC_IQAC_MINUTES_2024'), isTrue);

      // Key branding and image assets
      expect(registry.containsKey('IMG_OFFICIAL_CREST'), isTrue);
      expect(registry.containsKey('IMG_HERITAGE_GANDHI'), isTrue);
      expect(registry.containsKey('IMG_CAMPUS_DR_RADHAKRISHNAN_LIB'), isTrue);
      expect(registry.containsKey('IMG_CAMPUS_AUDITORIUM'), isTrue);
      expect(registry.containsKey('IMG_CAMPUS_AGRI_FARM'), isTrue);

      // Key media / video links
      expect(registry.containsKey('VID_CAMPUS_TOUR'), isTrue);
      expect(registry.containsKey('VID_CONVOCATION_2024'), isTrue);
      expect(registry.containsKey('VID_RURAL_INNOVATION'), isTrue);
    });

    test('All registered resources have canonical HTTPS URLs pointing to official domain', () {
      for (final entry in OfficialResourceRegistry.registry.entries) {
        final resource = entry.value;
        expect(resource.officialUrl, startsWith('https://ruraluniv.ac.in/'));
        expect(resource.title.isNotEmpty, isTrue);
        expect(resource.pageAssociation.isNotEmpty, isTrue);
      }
    });

    test('getResource returns valid item for known ID and null for unknown ID', () {
      final valid = OfficialResourceRegistry.getResource('DOC_PROSPECTUS_2026');
      expect(valid, isNotNull);
      expect(valid?.type, ResourceType.pdf);

      final invalid = OfficialResourceRegistry.getResource('NON_EXISTENT_ASSET_XYZ');
      expect(invalid, isNull);
    });

    test('getResourcesByType filters correctly', () {
      final pdfs = OfficialResourceRegistry.getResourcesByType(ResourceType.pdf);
      final images = OfficialResourceRegistry.getResourcesByType(ResourceType.image);
      final videos = OfficialResourceRegistry.getResourcesByType(ResourceType.video);

      expect(pdfs.isNotEmpty, isTrue);
      expect(images.isNotEmpty, isTrue);
      expect(videos.isNotEmpty, isTrue);

      expect(pdfs.every((r) => r.type == ResourceType.pdf), isTrue);
      expect(images.every((r) => r.type == ResourceType.image), isTrue);
      expect(videos.every((r) => r.type == ResourceType.video), isTrue);
    });
  });

  group('SeedDataService and Academic Models Tests', () {
    test('Official schools dataset contains 8 statutory schools with departments', () {
      final schools = SeedDataService.getOfficialSchools();
      expect(schools.length, equals(8));

      for (final school in schools) {
        expect(school.name.isNotEmpty, isTrue);
        expect(school.departments.isNotEmpty, isTrue);
        for (final dept in school.departments) {
          expect(dept.name.isNotEmpty, isTrue);
          expect(dept.programmes.isNotEmpty, isTrue);
          expect(dept.headOfDepartment.isNotEmpty, isTrue);
        }
      }
    });

    test('Official leadership profiles include Chancellor, VC, and Registrar', () {
      final leadership = SeedDataService.getOfficialLeadership();
      expect(leadership.length, greaterThanOrEqualTo(8));

      final chancellor = leadership.firstWhere((l) => l.designation.contains('Chancellor'));
      final vc = leadership.firstWhere((l) => l.designation.contains('Vice-Chancellor'));
      final registrar = leadership.firstWhere((l) => l.designation.contains('Registrar'));

      expect(chancellor.name, contains('Annamalai'));
      expect(vc.name, contains('Panchanatham'));
      expect(registrar.name, contains('Marimuthu'));
    });

    test('Official downloadable documents list includes valid URLs and categories', () {
      final downloads = SeedDataService.getOfficialDownloads();
      expect(downloads.length, greaterThanOrEqualTo(16));

      for (final doc in downloads) {
        expect(doc.title.isNotEmpty, isTrue);
        expect(doc.downloadUrl, startsWith('https://ruraluniv.ac.in/'));
        expect(doc.category.isNotEmpty, isTrue);
      }
    });

    test('Official statutory councils cover Senate, Syndicate, Academic, and Finance', () {
      final councils = SeedDataService.getStatutoryCouncils();
      expect(councils.length, equals(4));

      final names = councils.map((c) => c.name).toList();
      expect(names.any((n) => n.contains('Senate')), isTrue);
      expect(names.any((n) => n.contains('Syndicate')), isTrue);
      expect(names.any((n) => n.contains('Academic Council')), isTrue);
      expect(names.any((n) => n.contains('Finance Committee')), isTrue);
    });

    test('Official scholarships dataset covers post-matric and welfare schemes', () {
      final scholarships = SeedDataService.getScholarshipSchemes();
      expect(scholarships.length, greaterThanOrEqualTo(6));

      for (final s in scholarships) {
        expect(s.title.isNotEmpty, isTrue);
        expect(s.portalUrl.isNotEmpty, isTrue);
      }
    });
  });
}
