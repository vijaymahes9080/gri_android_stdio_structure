import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gri_app/providers/gri_provider.dart';
import 'package:gri_app/screens/events_notices_screen.dart';
import 'package:gri_app/screens/faculty_directory_screen.dart';
import 'package:gri_app/screens/institutional_services_screen.dart';
import 'package:gri_app/screens/student_services_hub_screen.dart';
import 'package:gri_app/services/official_catalog_service.dart';
import 'package:gri_app/services/verified_institution_content.dart';

Widget _app(Widget child, {GriProvider? provider}) {
  return ChangeNotifierProvider<GriProvider>(
    create: (_) => provider ?? GriProvider(),
    child: MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Verified institutional content', () {
    test('uses audited institutional facts', () {
      expect(VerifiedInstitution.accreditation, contains('A++'));
      expect(VerifiedInstitution.cgpa, '3.58');
      expect(VerifiedInstitution.campusAcres, 207);
      expect(VerifiedInstitution.phone, '0451-2452371');
      expect(VerifiedInstitution.email, 'grucc@ruraluniv.ac.in');
      expect(VerifiedInstitution.website, startsWith('https://'));
    });

    test('services and facilities are non-empty and sourced', () {
      expect(VerifiedContent.services, isNotEmpty);
      expect(VerifiedContent.facilities, isNotEmpty);
      expect(VerifiedContent.events, isNotEmpty);
      for (final service in VerifiedContent.services) {
        expect(service.url, startsWith('https://'), reason: service.id);
      }
      for (final facility in VerifiedContent.facilities) {
        expect(facility.sourceUrl, startsWith('https://'), reason: facility.id);
      }
      expect(VerifiedContent.serviceCategories, contains('Academics'));
    });

    test('OfficialText removes collection artifacts without touching clean text', () {
      expect(OfficialText.clean('Department of Tamil'), 'Department of Tamil');
      expect(OfficialText.clean('Computer ?? Centre \uFFFD'), 'Computer Centre');
      expect(OfficialText.title('??', fallback: 'Fallback'), 'Fallback');
    });
  });

  group('Canonical catalogue', () {
    test('loads the verified dataset and answers grounded queries', () async {
      await OfficialCatalogService.instance.ensureLoaded();
      final catalog = OfficialCatalogService.instance;
      expect(catalog.isLoaded, isTrue);
      expect(catalog.schools, isNotEmpty);
      expect(catalog.units, isNotEmpty);
      expect(catalog.faculty, isNotEmpty);
      expect(catalog.programmes, isNotEmpty);
      expect(catalog.documents, isNotEmpty);
    });
  });

  group('Phase 2 student workspace gate', () {
    testWidgets('student services stay locked until demo workspace is accepted',
        (tester) async {
      final provider = GriProvider();
      await tester.pumpWidget(_app(const StudentServicesHubScreen(),
          provider: provider));
      await tester.pumpAndSettle();

      expect(find.text('Student Workspace'), findsOneWidget);
      expect(provider.isStudentWorkspaceUnlocked, isFalse);
      expect(find.text('Continue to demo workspace'), findsOneWidget);

      await tester.tap(find.text('Continue to demo workspace'));
      await tester.pumpAndSettle();

      expect(provider.isStudentWorkspaceUnlocked, isTrue);
      expect(find.textContaining('Demo workspace'), findsOneWidget);
    });
  });

  group('New verified screens render', () {
    testWidgets('faculty directory shows verified header', (tester) async {
      await OfficialCatalogService.instance.ensureLoaded();
      await tester.pumpWidget(_app(const FacultyDirectoryScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Faculty Directory'), findsOneWidget);
      expect(find.textContaining('VERIFIED FACULTY RECORDS'), findsOneWidget);
    });

    testWidgets('events screen exposes all four boards', (tester) async {
      await OfficialCatalogService.instance.ensureLoaded();
      await tester.pumpWidget(_app(const EventsNoticesScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Events & Notices'), findsOneWidget);
      expect(find.text('Notices'), findsOneWidget);
      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Tenders'), findsOneWidget);
      expect(find.text('Careers'), findsOneWidget);
    });

    testWidgets('institutional services screen filters verified entries',
        (tester) async {
      await tester.pumpWidget(_app(const InstitutionalServicesScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Institutional Services'), findsOneWidget);
      expect(find.textContaining('VERIFIED OFFICIAL COVERAGE'), findsOneWidget);
    });
  });
}
