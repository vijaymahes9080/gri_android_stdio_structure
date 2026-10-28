import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gri_app/models/academic_models.dart';
import 'package:gri_app/models/user_model.dart';
import 'package:gri_app/providers/gri_provider.dart';
import 'package:gri_app/screens/official_document_center_screen.dart';
import 'package:gri_app/screens/settings_screen.dart';
import 'package:gri_app/services/document_certification_service.dart';
import 'package:gri_app/services/local_data_store_service.dart';
import 'package:gri_app/services/sahayak_knowledge_engine.dart';
import 'package:gri_app/services/supabase_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Workflow model serialization roundtrips', () {
    test('CourseModel serializes and restores attendance ledger', () {
      final course = CourseModel(
        id: 'crs_9',
        code: 'MCA-40X',
        title: 'Roundtrip Course',
        credits: 3,
        instructor: 'Dr. T. Tester',
        schedule: 'Mon 10:00 - Seminar Hall 9',
        attendancePercent: 81,
        totalClasses: 32,
        attendedClasses: 26,
      );
      final restored = CourseModel.fromMap(course.toMap());
      expect(restored.id, course.id);
      expect(restored.attendancePercent, 81);
      expect(restored.attendedClasses, 26);
      expect(restored.totalClasses, 32);
      expect(restored.instructor, course.instructor);
    });

    test('GrievanceModel preserves ticket lifecycle data', () {
      final g = GrievanceModel(
        id: 77,
        ticketNumber: 'GRV-2026-1137',
        category: 'Hostel Facility',
        subject: 'Server connection issue',
        description: 'Detail',
        status: 'RESOLVED',
        studentRollNo: '2024-MS-4011',
        createdAt: 1728800000000,
        resolvedAt: 1728900000000,
        remarks: 'Fixture replaced',
      );
      final restored = GrievanceModel.fromMap(g.toMap());
      expect(restored.ticketNumber, 'GRV-2026-1137');
      expect(restored.status, 'RESOLVED');
      expect(restored.resolvedAt, 1728900000000);
      expect(restored.remarks, 'Fixture replaced');
    });

    test('RegistrationApplication preserves full review dossier', () {
      final app = RegistrationApplication(
        id: 'APP-2026-7777',
        userId: 'usr_t',
        fullName: 'Test Applicant',
        email: 't@ruraluniv.ac.in',
        mobile: '+91 90000 00000',
        institutionalId: '2026-TS-0001',
        requestedRole: UserRole.SCHOLAR,
        department: 'School of Tests',
        researchTopic: 'Testing',
        status: AccountStatus.UNDER_REVIEW,
        submittedDate: '01 Feb 2026',
        adminQuery: 'Query?',
        history: [
          ApplicationHistoryEntry(
            timestamp: '01 Feb 2026',
            action: 'APPLICATION_SUBMITTED',
            actor: 'Test Applicant',
            details: 'Submitted',
          ),
        ],
      );
      final restored = RegistrationApplication.fromMap(app.toMap());
      expect(restored.requestedRole, UserRole.SCHOLAR);
      expect(restored.status, AccountStatus.UNDER_REVIEW);
      expect(restored.history.length, 1);
      expect(restored.history.first.action, 'APPLICATION_SUBMITTED');
      expect(restored.adminQuery, 'Query?');
      // Invalid enum values fall back safely instead of throwing.
      final degraded = RegistrationApplication.fromMap({
        ...app.toMap(),
        'requested_role': 'NOT_A_ROLE',
        'status': 'NOT_A_STATUS',
      });
      expect(degraded.requestedRole, UserRole.STUDENT);
      expect(degraded.status, AccountStatus.PENDING_APPROVAL);
    });

    test('InstitutionalAuditLog roundtrip keeps the immutable ledger intact', () {
      final log = InstitutionalAuditLog(
        id: 'log_x',
        timestamp: '10 Oct 2026',
        adminName: 'Registrar',
        adminRole: 'ADMIN',
        action: 'APPLICATION_APPROVED',
        targetUser: 'Someone',
        targetRole: 'STUDENT',
        previousState: 'PENDING_APPROVAL',
        newState: 'APPROVED',
        reasonOrNotes: 'Verified',
      );
      final restored = InstitutionalAuditLog.fromMap(log.toMap());
      expect(restored.action, 'APPLICATION_APPROVED');
      expect(restored.newState, 'APPROVED');
      expect(restored.reasonOrNotes, 'Verified');
    });

    test('SahayakMessage and StaffLeaveRecord roundtrip', () {
      final m = SahayakMessage(
        id: 'msg_1',
        text: 'Question',
        isUser: true,
        timestamp: '08:00',
        source: 'https://ruraluniv.ac.in/',
      );
      final restoredMsg = SahayakMessage.fromMap(m.toMap());
      expect(restoredMsg.isUser, true);
      expect(restoredMsg.source, 'https://ruraluniv.ac.in/');

      final l = StaffLeaveRecord(
        id: 'lv_9',
        leaveType: 'Casual Leave (CL)',
        days: 2,
        fromDate: '2026-11-12',
        toDate: '2026-11-13',
        status: 'SUBMITTED',
        reason: 'Family function',
      );
      final restoredLeave = StaffLeaveRecord.fromMap(l.toMap());
      expect(restoredLeave.days, 2);
      expect(restoredLeave.status, 'SUBMITTED');
    });
  });

  group('Document certification verification (honest behaviour)', () {
    test('A code on the register with a valid checksum verifies as AUTHENTIC', () {
      final result = DocumentCertificationService.instance
          .verify('GRI-CERT-2023-015468');
      expect(result.isAuthentic, isTrue);
      expect(result.record?.holderName, 'Preethi Ramasamy');
      expect(result.message, startsWith('AUTHENTIC'));
    });

    test('Lowercase and spaced input is normalized before verification', () {
      final result = DocumentCertificationService.instance
          .verify(' gri-cert-2023-015468 ');
      expect(result.isAuthentic, isTrue);
    });

    test('Malformed identifiers are refused as INVALID FORMAT', () {
      final short = DocumentCertificationService.instance.verify('ABC123');
      expect(short.status, DocumentVerificationStatus.invalidFormat);
      expect(short.isAuthentic, isFalse);
      expect(short.message, startsWith('INVALID FORMAT'));
    });

    test('Altered check digits fail the checksum and are never authenticated',
        () {
      final altered = DocumentCertificationService.instance
          .verify('GRI-CERT-2023-015469'); // valid pattern, wrong check digit
      expect(altered.status, DocumentVerificationStatus.checksumFailed);
      expect(altered.isAuthentic, isFalse);
      expect(altered.message, startsWith('CHECKSUM FAILURE'));
    });

    test('Well-formed unknown identifiers are reported NOT ON REGISTER', () {
      // Compose a structurally valid code that is definitely absent from the
      // register and compute its correct check digit.
      final body = 'GRI-TRAN-2025-99998';
      final code = '$body${DocumentCertificationService.checkDigitFor(body)}';
      final result = DocumentCertificationService.instance.verify(code);
      expect(result.status, DocumentVerificationStatus.notOnRegister);
      expect(result.isAuthentic, isFalse);
      expect(result.message, startsWith('NOT ON REGISTER'));
    });

    test('Cloud register records are merged and become verifiable', () {
      const cloudRow = {
        'code': 'GRI-DEG-2024-123456',
        'holder_name': 'Cloud Applicant',
        'programme': 'M.Sc. Rural Economics',
        'register_number': '2024-MS-1234',
        'issued_by': 'Office of the Registrar (Academic), GRI',
        'issued_on': '01 Jan 2024',
      };
      final body = 'GRI-DEG-2024-12345';
      final documentedCode = 'GRI-DEG-2024-12345'
          '${DocumentCertificationService.checkDigitFor(body)}';
      // Merge a record keyed by the checksum-corrected code.
      DocumentCertificationService.instance.mergeCloudRecords([
        {...cloudRow, 'code': documentedCode}
      ]);
      final result = DocumentCertificationService.instance.verify(documentedCode);
      expect(result.isAuthentic, isTrue);
      expect(result.record?.holderName, 'Cloud Applicant');
    });

    test('Provider surfaces the honest status text', () {
      final provider = GriProvider();
      provider.verifyDocumentAuthenticity('totally-fake-code');
      expect(provider.verifiedDocumentStatus, startsWith('INVALID FORMAT'));
    });
  });

  group('Hall ticket eligibility enforcement', () {
    test('Eligible student with >=75% attendance in every course is issued a ticket',
        () {
      final courses = [
        CourseModel(
          id: 'c1', code: 'A-1', title: 'A', credits: 2,
          instructor: 'x', schedule: 'x',
          attendancePercent: 90, totalClasses: 40, attendedClasses: 36,
        ),
        CourseModel(
          id: 'c2', code: 'A-2', title: 'B', credits: 2,
          instructor: 'x', schedule: 'x',
          attendancePercent: 76, totalClasses: 30, attendedClasses: 23,
        ),
      ];
      final (eligible, _) = GriProvider.evaluateHallTicketEligibility(
        courses: courses,
        role: 'STUDENT',
        accountStatus: 'APPROVED',
      );
      expect(eligible, isTrue);

      final provider = GriProvider();
      provider.fetchHallTicket();
      expect(provider.hallTicketData, isNotNull);
      expect(provider.hallTicketData!.rollNo, isNotEmpty);
    });

    test('Shortfall in any course withholds the ticket with a stated reason', () {
      final courses = [
        CourseModel(
          id: 'c1', code: 'A-1', title: 'A', credits: 2,
          instructor: 'x', schedule: 'x',
          attendancePercent: 90, totalClasses: 40, attendedClasses: 36,
        ),
        CourseModel(
          id: 'c2', code: 'A-2', title: 'B', credits: 2,
          instructor: 'x', schedule: 'x',
          attendancePercent: 60, totalClasses: 20, attendedClasses: 12,
        ),
      ];
      final (eligible, reason) = GriProvider.evaluateHallTicketEligibility(
        courses: courses,
        role: 'STUDENT',
        accountStatus: 'APPROVED',
      );
      expect(eligible, isFalse);
      expect(reason, contains('A-2'));
      expect(reason, contains('75%'));
    });

    test('Non-student roles are refused hall tickets honestly', () {
      final (eligible, reason) = GriProvider.evaluateHallTicketEligibility(
        courses: const [],
        role: 'ADMIN',
        accountStatus: 'APPROVED',
      );
      expect(eligible, isFalse);
      expect(reason, contains('ADMIN'));
    });

    test('Unapproved account status is refused', () {
      final (eligible, reason) = GriProvider.evaluateHallTicketEligibility(
        courses: const [],
        role: 'STUDENT',
        accountStatus: 'PENDING_APPROVAL',
      );
      expect(eligible, isFalse);
      expect(reason, contains('APPROVED status'));
    });
  });

  group('GRI-Sahayak grounded retrieval', () {
    test('Admission questions return a grounded sourced answer', () {
      final reply = SahayakKnowledgeEngine.instance.answer('how can I apply for admission');
      expect(reply.grounded, isTrue);
      expect(reply.sources, isNotEmpty);
      expect(reply.text, contains('CUET'));
      expect(reply.text, contains('Source:'));
    });

    test('Exam and hall ticket questions cite the CBCS rule and official pages', () {
      final reply = SahayakKnowledgeEngine.instance.answer('when will the exam results be released');
      expect(reply.grounded, isTrue);
      expect(reply.sources, isNotEmpty);
      expect(reply.text, contains('75%'));
    });

    test('Certificate verification questions point to e-SANAD', () {
      final reply = SahayakKnowledgeEngine.instance.answer('how do I verify my degree certificate');
      expect(reply.grounded, isTrue);
      expect(reply.sources.any((s) => s.contains('e-sanad') || s.contains('esanad')), isTrue);
    });

    test('Unknown queries fall back honestly without claiming a source', () {
      final reply = SahayakKnowledgeEngine.instance.answer('quantum flux capacitor bwipop');
      expect(reply.grounded, isFalse);
      expect(reply.sources, isEmpty);
      expect(reply.text, contains('do not have a verified institutional answer'));
    });

    test('Current circulars outrank static knowledge when relevant', () {
      final circular = CircularModel(
        id: 'cir_live',
        title: 'National seminar on organic farming registration',
        category: 'Academic Event',
        publishedDate: 'Just now',
        summary: 'Registration for the organic farming seminar in Dindigul opens Monday.',
        issuedBy: 'Dean, Academic Affairs',
      );
      final reply = SahayakKnowledgeEngine.instance.answer(
        'organic farming seminar',
        circulars: [circular],
      );
      expect(reply.grounded, isTrue);
      expect(reply.text, contains('organic farming registration'));
    });

    test('Assistant conversation persists and drives grounded answers end to end',
        () async {
      final provider = GriProvider();
      provider.sendSahayakMessage('library opening hours');
      await Future<void>.delayed(const Duration(milliseconds: 900));

      expect(provider.sahayakMessages.length, greaterThanOrEqualTo(3));
      final answer = provider.sahayakMessages.last;
      expect(answer.isUser, isFalse);
      expect(answer.text, contains('Central Library'));
      // The grounded answer must only cite a source that actually matched.
      expect(answer.source ?? '', startsWith('https://ruraluniv.ac.in/'));

      final saved = await LocalDataStoreService.instance.loadSahayakMessages();
      expect(saved, isNotNull);
      expect(saved!.last.text, contains('Central Library'));
    });
  });

  group('Persistent vault (restart-safe state)', () {
    test('Grievances submitted in one session are restored in the next',
        () async {
      // First session: seeded defaults are snapshotted and submissions persist.
      final first = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 120));
      first.submitGrievance('Transport', 'Restart Persistence Probe',
          'Submitted before simulated restart');
      expect(first.grievances.first.subject, 'Restart Persistence Probe');

      // Second session (fresh provider over the same persisted vault).
      final second = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(
        second.grievances.any((g) => g.subject == 'Restart Persistence Probe'),
        isTrue,
      );
    });

    test('Attendance marking persists across restarts', () async {
      final first = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 120));
      final course = first.courses.first;
      final attended = course.attendedClasses;
      first.markAttendance(course.id);
      await Future<void>.delayed(const Duration(milliseconds: 120));

      final second = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final restored = second.courses.firstWhere((c) => c.id == course.id);
      expect(restored.attendedClasses, attended + 1);
    });

    test('Circular read-state survives a source refresh and restart', () async {
      final provider = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(provider.circulars, isNotEmpty);
      provider.markCircularRead(provider.circulars.first.id);
      await Future<void>.delayed(const Duration(milliseconds: 120));

      final second = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (second.circulars.isNotEmpty) {
        final readSet = await LocalDataStoreService.instance.loadReadCircularIds();
        expect(readSet, isNotEmpty);
      }

      // A website re-sync must not wipe the read overlay.
      await provider.syncOfficialWebsite(force: false);
      expect(
        provider.circulars.any((c) => c.isRead),
        isTrue,
      );
    });
  });

  group('Supabase cloud-schema mappers (queue correctness)', () {
    test('Grievance payload is translated to the cloud table shape', () {
      final cloud = SupabaseService.cloudGrievanceRow(
        GrievanceModel(
          id: 9,
          ticketNumber: 'GRV-2026-1069',
          category: 'Library Services',
          subject: 'Proxy access',
          description: 'Details',
          status: 'IN_REVIEW',
          studentRollNo: '2024-MS-4011',
          createdAt: 1728800000000,
          remarks: '',
        ).toMap(),
      );
      expect(cloud['id'], '2024-MS-4011|GRV-2026-1069');
      expect(cloud['user_id'], '2024-MS-4011');
      expect(cloud['status'], 'IN_PROGRESS'); // cloud CHECK constraint vocabulary
      expect(cloud['date'], isA<String>());
      // ISO-8601 date expected by the TEXT date column, not epoch millis.
      expect(cloud['date'], contains('T'));
      expect(cloud.containsKey('ticket_number'), isFalse);
      expect(cloud.containsKey('created_at'), isFalse);
    });

    test('Audit ledger payload is translated to the cloud ledger shape', () {
      final cloud = SupabaseService.cloudAuditRow(
        InstitutionalAuditLog(
          id: 'log_9',
          timestamp: '10 Oct 2026',
          adminName: 'Dr. M. Sundaramari',
          adminRole: 'ADMIN',
          action: 'APPLICATION_APPROVED',
          targetUser: 'Kavitha Mohan',
          targetRole: 'STUDENT',
          previousState: 'PENDING_APPROVAL',
          newState: 'APPROVED',
          reasonOrNotes: 'Verified rolls',
        ).toMap(),
      );
      expect(cloud['actor_name'], 'Dr. M. Sundaramari (ADMIN)');
      expect(cloud['target_user_id'], 'Kavitha Mohan');
      expect(cloud['previous_status'], 'PENDING_APPROVAL');
      expect(cloud['new_status'], 'APPROVED');
      expect(cloud['remarks'], 'Verified rolls');
      // The cloud table has no local-shaped columns.
      expect(cloud.containsKey('admin_name'), isFalse);
      expect(cloud.containsKey('timestamp'), isFalse);
    });

    test('Leave payload is translated with owner attribution and status map',
        () {
      final cloud = SupabaseService.cloudLeaveRow({
        ...StaffLeaveRecord(
          id: 'lv_9',
          leaveType: 'Casual Leave (CL)',
          days: 2,
          fromDate: '2026-11-12',
          toDate: '2026-11-13',
          status: 'SUBMITTED',
          reason: 'Family function',
        ).toMap(),
        'owner_id': 'FAC-CS-108',
        'owner_name': 'Dr. R. Subramanian',
      });
      expect(cloud['user_id'], 'FAC-CS-108');
      expect(cloud['faculty_name'], 'Dr. R. Subramanian');
      expect(cloud['type'], 'Casual Leave (CL)');
      expect(cloud['dates'], '2026-11-12 — 2026-11-13');
      expect(cloud['status'], 'PENDING_HOD'); // cloud CHECK constraint vocabulary
      expect(cloud.containsKey('leave_type'), isFalse);
      expect(cloud.containsKey('from_date'), isFalse);
    });
  });

  group('Published circular persistence & hall-ticket block state', () {
    test('Admin-published circulars survive an app restart', () async {
      final first = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      // Admin dossier may publish circulars.
      first.switchUserAccount(first.availableAccounts[0]);
      final before = first.circulars.length;
      first.publishCircular(
        'Restart Persistence Circular',
        'Academic Event',
        'Published then reloaded.',
        false,
        'Test Directorate',
      );
      expect(first.circulars.length, before + 1);
      await Future<void>.delayed(const Duration(milliseconds: 120));

      final second = GriProvider();
      await Future<void>.delayed(const Duration(milliseconds: 220));
      expect(
        second.circulars.any((c) => c.title == 'Restart Persistence Circular'),
        isTrue,
      );
      // Also restored into the published set so a live web re-sync keeps it.
      await second.syncOfficialWebsite(force: false);
      expect(
        second.circulars.any((c) => c.title == 'Restart Persistence Circular'),
        isTrue,
      );
    });

    test('Hall-ticket refusal sets persistent inline state; role switch clears it',
        () {
      final provider = GriProvider();
      // Default demo student (approved, >=75% every course) is eligible.
      provider.fetchHallTicket();
      expect(provider.hallTicketData, isNotNull);
      expect(provider.hallTicketBlockReason, isNull);

      // Switching to a non-exam role must record a persistent refusal reason.
      provider.switchUserAccount(provider.availableAccounts[1]); // faculty
      provider.fetchHallTicket();
      expect(provider.hallTicketData, isNull);
      expect(provider.hallTicketBlockReason, isNotNull);

      // Switching accounts clears the stale refusal state.
      provider.switchUserAccount(provider.availableAccounts[2]); // student
      expect(provider.hallTicketBlockReason, isNull);
      provider.fetchHallTicket();
      expect(provider.hallTicketData, isNotNull);
      expect(provider.hallTicketBlockReason, isNull);
    });
  });

  group('Official document center verification UI', () {
    Future<GriProvider> pumpVerification(
      WidgetTester tester,
      String code,
    ) async {
      final provider = GriProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<GriProvider>.value(
          value: provider,
          child: const MaterialApp(home: Scaffold(body: OfficialDocumentCenterScreen())),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      final fieldFinder = find.byType(TextField).first;
      await tester.ensureVisible(fieldFinder);
      await tester.enterText(fieldFinder, code);

      final verifyButton = find.text('Verify');
      await tester.ensureVisible(verifyButton);
      await tester.tap(verifyButton);
      await tester.pumpAndSettle();
      return provider;
    }

    testWidgets('Registered code shows AUTHENTIC verdict', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pumpVerification(tester, 'GRI-CERT-2023-015468');
      expect(find.textContaining('AUTHENTIC'), findsOneWidget);
    });

    testWidgets('Fabricated code shows an explicit refusal, not success',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pumpVerification(tester, 'MAKE-IT-UP-99');
      expect(find.textContaining('INVALID FORMAT'), findsOneWidget);
      expect(find.textContaining('AUTHENTIC'), findsNothing);
    });
  });

  group('Settings — institutional data reset journey', () {
    testWidgets('Reset Vault Data requires confirmation and then restores baseline',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Widget-test timers are fake: avoid real-duration awaits before any
      // pump; give the constructor's async restore a frame instead.
      final provider = GriProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<GriProvider>.value(
          value: provider,
          child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
        ),
      );
      await tester.pump(const Duration(milliseconds: 250));

      // Guard: the action needs explicit confirmation before it runs.
      final resetButton = find.text('Reset Vault Data');
      await tester.scrollUntilVisible(resetButton, 400);
      await tester.tap(resetButton);
      await tester.pumpAndSettle();
      expect(find.text('Reset Institutional Data?'), findsOneWidget);

      // Recording a mutation first proves baseline restoration afterwards.
      provider.submitGrievance('Transport', 'Reset Probe', 'Market');
      expect(provider.grievances.any((g) => g.subject == 'Reset Probe'), isTrue);

      await tester.tap(find.text('Reset Data'));
      await tester.pumpAndSettle();

      // Dialog is dismissed and the vault is restored to the seed baseline.
      expect(find.text('Reset Institutional Data?'), findsNothing);
      expect(
        provider.notificationMessage,
        contains('reset to institutional baseline'),
      );
      expect(
        provider.grievances.any((g) => g.subject == 'Reset Probe'),
        isFalse,
      );
      expect(provider.grievances.isNotEmpty, isTrue); // seeded baseline restored
    });
  });
}
