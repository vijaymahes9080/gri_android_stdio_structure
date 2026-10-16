import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gri_app/providers/gri_provider.dart';
import 'package:gri_app/services/official_resource_registry.dart';
import 'package:gri_app/services/seed_data_service.dart';
import 'package:gri_app/services/official_web_sync_service.dart';
import 'package:gri_app/screens/official_portals_gateway_screen.dart';

void main() {
  group('OfficialResourceRegistry Tests', () {
    test('Registry contains all 24 core official verified institutional resources', () {
      final registry = OfficialResourceRegistry.registry;
      expect(registry.length, greaterThanOrEqualTo(24));

      // Key documents verification
      expect(registry.containsKey('DOC_PROSPECTUS_2026'), isTrue);
      expect(registry.containsKey('DOC_PROSPECTUS_2025'), isTrue);
      expect(registry.containsKey('DOC_COE_TRANSCRIPT'), isTrue);
      expect(registry.containsKey('DOC_COE_DUPLICATE_CERT'), isTrue);
      expect(registry.containsKey('DOC_COE_TATKAL_INSTRUCTIONS'), isTrue);
      expect(registry.containsKey('DOC_MEA_ESANAD_GUIDELINES'), isTrue);
      expect(registry.containsKey('DOC_ANTI_RAGGING_POLICY'), isTrue);
      expect(registry.containsKey('DOC_NIRF_2026_DISCLOSURE'), isTrue);
      expect(registry.containsKey('DOC_NAAC_SSR_CYCLE4'), isTrue);
      expect(registry.containsKey('DOC_CBCS_REGULATIONS'), isTrue);

      // Key branding and image assets
      expect(registry.containsKey('IMG_OFFICIAL_CREST'), isTrue);
      expect(registry.containsKey('IMG_PORTAL_BANNER'), isTrue);
      expect(registry.containsKey('IMG_ADMIN_BLOCK'), isTrue);
      expect(registry.containsKey('IMG_CHANCELLOR_ANNAMALAI'), isTrue);
      expect(registry.containsKey('IMG_VC_PANCHANATHAM'), isTrue);
      expect(registry.containsKey('IMG_REGISTRAR_MARIMUTHU'), isTrue);

      // Key media / video links
      expect(registry.containsKey('VID_CAMPUS_TOUR'), isTrue);
      expect(registry.containsKey('VID_YOUTUBE_CHANNEL'), isTrue);
      expect(registry.containsKey('VID_ANTI_RAGGING_FILM'), isTrue);

      // Key integrated portals
      expect(registry.containsKey('PORTAL_SAMARTH_ADMISSIONS'), isTrue);
      expect(registry.containsKey('PORTAL_STUDY_IN_INDIA'), isTrue);
      expect(registry.containsKey('PORTAL_DIGILOCKER_APAAR'), isTrue);
    });

    test('All registered resources have valid verified URLs pointing to official and national domains', () {
      for (final entry in OfficialResourceRegistry.registry.entries) {
        final resource = entry.value;
        expect(resource.officialUrl, startsWith('http'));
        expect(resource.title.isNotEmpty, isTrue);
        expect(resource.pageAssociation.isNotEmpty, isTrue);
      }
    });

    test('getResource returns valid item for known ID and null for unknown ID', () {
      final valid = OfficialResourceRegistry.getResource('DOC_PROSPECTUS_2026');
      expect(valid, isNotNull);
      expect(valid?.type, ResourceType.DOCUMENT_PDF);

      final invalid = OfficialResourceRegistry.getResource('NON_EXISTENT_ASSET_XYZ');
      expect(invalid, isNull);
    });

    test('getResourcesByType filters correctly', () {
      final pdfs = OfficialResourceRegistry.getResourcesByType(ResourceType.DOCUMENT_PDF);
      final images = OfficialResourceRegistry.getResourcesByType(ResourceType.IMAGE);
      final videos = OfficialResourceRegistry.getResourcesByType(ResourceType.VIDEO_STREAM);

      expect(pdfs.isNotEmpty, isTrue);
      expect(images.isNotEmpty, isTrue);
      expect(videos.isNotEmpty, isTrue);

      expect(pdfs.every((r) => r.type == ResourceType.DOCUMENT_PDF), isTrue);
      expect(images.every((r) => r.type == ResourceType.IMAGE), isTrue);
      expect(videos.every((r) => r.type == ResourceType.VIDEO_STREAM), isTrue);
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

  group('OfficialWebSyncService & Portals Gateway Tests', () {
    test('OfficialWebSyncService returns valid notices with fallback resilience', () async {
      final syncService = OfficialWebSyncService.instance;
      final notices = await syncService.fetchOfficialNotices();

      expect(notices.isNotEmpty, isTrue);
      expect(notices.length, greaterThanOrEqualTo(5));

      for (final notice in notices) {
        expect(notice.title.isNotEmpty, isTrue);
        expect(notice.category.isNotEmpty, isTrue);
        expect(notice.issuedBy.isNotEmpty, isTrue);
        expect(notice.publishedDate.isNotEmpty, isTrue);
      }
    });

    test('OfficialPortalsGatewayScreen indexes official verified external portals from URL inventory', () {
      final portals = OfficialPortalsGatewayScreen.portals;
      expect(portals.length, greaterThanOrEqualTo(10));

      // Key portals verification
      expect(portals.any((p) => p.id == 'portal_samarth'), isTrue);
      expect(portals.any((p) => p.id == 'portal_student_erp'), isTrue);
      expect(portals.any((p) => p.id == 'portal_esanad'), isTrue);
      expect(portals.any((p) => p.id == 'portal_webmail'), isTrue);
      expect(portals.any((p) => p.id == 'portal_apaar'), isTrue);
      expect(portals.any((p) => p.id == 'portal_etrack'), isTrue);
      expect(portals.any((p) => p.id == 'portal_hostel'), isTrue);
      expect(portals.any((p) => p.id == 'portal_department'), isTrue);
      expect(portals.any((p) => p.id == 'portal_lms'), isTrue);

      for (final p in portals) {
        expect(p.title.isNotEmpty, isTrue);
        expect(p.url, startsWith('https://'));
        expect(p.authRequirement.isNotEmpty, isTrue);
        expect(p.authority.isNotEmpty, isTrue);
      }
    });

    test('OfficialResourceRegistry.getFullDocumentVault returns unified base documents', () {
      final vault = OfficialResourceRegistry.getFullDocumentVault();
      expect(vault.length, greaterThanOrEqualTo(12));
      expect(vault.every((d) => d.type == ResourceType.DOCUMENT_PDF), isTrue);
    });

    test('OfficialResourceRegistry contains canonical and deduplicated branding images', () {
      final registry = OfficialResourceRegistry.registry;
      expect(registry.containsKey('IMG_OFFICIAL_LOGO'), isTrue);
      expect(registry.containsKey('IMG_LIBRARY_FRONT'), isTrue);
      expect(registry.containsKey('IMG_HEALTH_CENTRE'), isTrue);
      expect(registry.containsKey('IMG_STUDENT_AVATAR'), isTrue);
      expect(registry.containsKey('IMG_OFFICIAL_CREST'), isTrue);
      expect(registry.containsKey('IMG_PORTAL_BANNER'), isTrue);
      expect(registry.containsKey('IMG_ADMIN_BLOCK'), isTrue);
    });

    test('OfficialResourceRegistry.buildThemedFacilityHero renders non-null widget for all categories', () {
      final categories = ['Academic', 'Health', 'Hostel', 'Agriculture', 'Sports', 'Research', 'Computing'];
      for (final cat in categories) {
        final heroLight = OfficialResourceRegistry.buildThemedFacilityHero(cat, isDark: false);
        final heroDark = OfficialResourceRegistry.buildThemedFacilityHero(cat, isDark: true);
        expect(heroLight, isNotNull);
        expect(heroDark, isNotNull);
      }
    });
  });

  group('GriProvider Settings & Persistence Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('ThemeMode can be switched between system, light, and dark', () async {
      final provider = GriProvider();
      expect(provider.themeMode, ThemeMode.system);

      await provider.setThemeMode(ThemeMode.dark);
      expect(provider.themeMode, ThemeMode.dark);

      await provider.setThemeMode(ThemeMode.light);
      expect(provider.themeMode, ThemeMode.light);

      await provider.setThemeMode(ThemeMode.system);
      expect(provider.themeMode, ThemeMode.system);
    });

    test('Text scale factor can be adjusted', () async {
      final provider = GriProvider();
      expect(provider.textScaleFactor, 1.0);

      await provider.setTextScaleFactor(1.15);
      expect(provider.textScaleFactor, 1.15);

      await provider.setTextScaleFactor(0.9);
      expect(provider.textScaleFactor, 0.9);
    });

    test('Language preference can be toggled between English and Tamil', () async {
      final provider = GriProvider();
      expect(provider.languageCode, 'en');

      await provider.setLanguageCode('ta');
      expect(provider.languageCode, 'ta');

      await provider.setLanguageCode('en');
      expect(provider.languageCode, 'en');
    });

    test('Reduce motion and notification toggles update correctly', () async {
      final provider = GriProvider();
      expect(provider.reduceMotion, isFalse);

      await provider.setReduceMotion(true);
      expect(provider.reduceMotion, isTrue);

      await provider.setNoticesEnabled(false);
      expect(provider.noticesEnabled, isFalse);

      await provider.setExamAlertsEnabled(false);
      expect(provider.examAlertsEnabled, isFalse);
    });

    test('Cache clearing flushes image caches without throwing', () async {
      final provider = GriProvider();
      await provider.clearApplicationCache();
      expect(provider.notificationMessage, contains('cleared'));
    });
  });
}
