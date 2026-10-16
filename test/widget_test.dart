import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gri_app/main.dart';
import 'package:gri_app/providers/gri_provider.dart';
import 'package:gri_app/models/user_model.dart';
import 'package:gri_app/screens/about_gri_heritage_screen.dart';
import 'package:gri_app/screens/governance_leadership_screen.dart';
import 'package:gri_app/screens/schools_programmes_hub_screen.dart';
import 'package:gri_app/screens/admissions_prospectus_screen.dart';
import 'package:gri_app/screens/document_vault_screen.dart';
import 'package:gri_app/screens/global_website_search_screen.dart';
import 'package:gri_app/screens/media_gallery_screen.dart';
import 'package:gri_app/screens/official_portals_gateway_screen.dart';
import 'package:gri_app/screens/gri_splash_screen.dart';
import 'package:gri_app/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  Widget createTestApp(Widget child) {
    return ChangeNotifierProvider(
      create: (_) => GriProvider(),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: child,
      ),
    );
  }

  testWidgets('GRI App renders dashboard and title successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GriProvider(),
        child: const GriApplication(home: MainScaffold()),
      ),
    );

    await tester.pumpAndSettle();

    // Verify institutional title exists
    expect(find.text('THE GANDHIGRAM RURAL INSTITUTE'), findsOneWidget);
  });

  testWidgets('About GRI Heritage Screen renders genesis and Nai Talim content', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const AboutGriHeritageScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Vision & Mission'), findsOneWidget);
    await tester.tap(find.text('Genesis & Founders'));
    await tester.pumpAndSettle();

    expect(find.textContaining('GENESIS OF GRI'), findsOneWidget);
    expect(find.textContaining('Nai Talim'), findsWidgets);
  });

  testWidgets('Governance Leadership Screen displays key administrative officers', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const GovernanceLeadershipScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Chancellor'), findsWidgets);
    expect(find.textContaining('Vice-Chancellor'), findsWidgets);
  });

  testWidgets('Schools Programmes Hub Screen displays faculties and programmes', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const SchoolsProgrammesHubScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Schools & Academic Programmes'), findsOneWidget);
    expect(find.textContaining('School'), findsWidgets);
  });

  testWidgets('Admissions Prospectus Screen renders fee policies and official downloads', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const AdmissionsProspectusScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Official Prospectuses'), findsWidgets);
  });

  testWidgets('Document Vault Screen renders official document categories', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const DocumentVaultScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Official Document Vault'), findsOneWidget);
  });

  testWidgets('Media Gallery Screen renders official photo and video sections', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const MediaGalleryScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Media & Video Galleries'), findsOneWidget);
    expect(find.text('Official Videos'), findsOneWidget);
  });

  testWidgets('Global Website Search Screen allows entering queries', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const GlobalWebsiteSearchScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'physics');
    await tester.pump();

    expect(find.text('physics'), findsOneWidget);
  });

  testWidgets('Official Portals Gateway Screen renders security advisory and portals', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const OfficialPortalsGatewayScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Official Portals & Gateways'), findsOneWidget);
    expect(find.text('Official Authentication Disclaimer'), findsOneWidget);
    expect(find.textContaining('Samarth@GRI'), findsOneWidget);
    expect(find.textContaining('GRI Integrated Student Portal'), findsOneWidget);
  });

  test('GRI Provider initializes with default student role and courses', () {
    final provider = GriProvider();
    expect(provider.currentRole, UserRole.STUDENT);
    expect(provider.courses.isNotEmpty, true);
    expect(provider.circulars.isNotEmpty, true);
    expect(provider.availableAccounts.isNotEmpty, true);
  });

  test('GRI Provider handles attendance marking and percentage calculation', () {
    final provider = GriProvider();
    final firstCourse = provider.courses.first;
    final initialAttended = firstCourse.attendedClasses;

    provider.markAttendance(firstCourse.id);

    final updatedCourse = provider.courses.firstWhere((c) => c.id == firstCourse.id);
    expect(updatedCourse.attendedClasses, initialAttended + 1);
  });

  test('GRI Provider switches authorized role correctly', () {
    final provider = GriProvider();
    provider.switchAuthorizedRole(UserRole.FACULTY);

    expect(provider.currentRole, UserRole.FACULTY);
  });

  test('GRI Provider submits new grievance', () {
    final provider = GriProvider();
    final initialCount = provider.grievances.length;

    provider.submitGrievance("Transport", "Bus Delaybat", "Batlagundu bus delay 15 min");

    expect(provider.grievances.length, initialCount + 1);
    expect(provider.grievances.first.subject, "Bus Delaybat");
  });

  testWidgets('GRI Splash Screen renders official identity and accreditation', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GriProvider(),
        child: const MaterialApp(home: GriSplashScreen()),
      ),
    );

    // Initial frame of splash screen
    await tester.pump();
    expect(find.text('காந்திகிராம கிராமிய நிறுவனம்'), findsOneWidget);
    expect(find.text('THE GANDHIGRAM RURAL INSTITUTE'), findsOneWidget);
    expect(find.textContaining('NAAC'), findsOneWidget);

    // Settle timer transition to MainScaffold
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();
  });

  testWidgets('Settings Screen renders appearance, language, and cache sections', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(createTestApp(const SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Settings & Preferences'), findsOneWidget);
    expect(find.text('APPEARANCE & DISPLAY'), findsOneWidget);
    expect(find.text('LANGUAGE & ACCESSIBILITY'), findsOneWidget);
    expect(find.text('NOTIFICATION PREFERENCES'), findsOneWidget);
    expect(find.text('OFFLINE STORAGE & CACHE'), findsOneWidget);
    expect(find.text('INSTITUTIONAL METADATA'), findsOneWidget);

    // Verify Theme buttons exist
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);

    // Verify Language segment exists
    expect(find.text('தமிழ்'), findsOneWidget);

    // Verify Clear Cache button exists
    expect(find.text('Clear Cache'), findsOneWidget);
  });
}
