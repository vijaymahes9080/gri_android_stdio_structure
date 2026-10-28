import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gri_app/models/academic_models.dart';
import 'package:gri_app/models/user_model.dart';
import 'package:gri_app/providers/gri_provider.dart';
import 'package:gri_app/services/local_data_store_service.dart';
import 'package:gri_app/services/supabase_service.dart';
import 'package:gri_app/widgets/role_switcher_modal.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Faculty roll-call register', () {
    test('setRollStatus cycles Present -> Absent -> OD -> Present', () {
      final provider = GriProvider();
      const course = 'MCA-401';
      final roll = provider.rollCallRosterFor(course).first.roll;

      expect(provider.rollCallRosterFor(course).first.status, 'Present');
      provider.setRollStatus(course, roll);
      expect(provider.rollCallRosterFor(course).first.status, 'Absent');
      provider.setRollStatus(course, roll);
      expect(provider.rollCallRosterFor(course).first.status, 'OD');
      provider.setRollStatus(course, roll);
      expect(provider.rollCallRosterFor(course).first.status, 'Present');
    });

    test('submitRollCall records correct counts and persists the ledger', () async {
      final provider = GriProvider();
      const course = 'MCA-401';

      // Change one student to Absent so counts are non-trivial.
      final firstRoll = provider.rollCallRosterFor(course).first.roll;
      provider.setRollStatus(course, firstRoll); // Present -> Absent

      final record = provider.submitRollCall(course, 'MCA Sem IV — Batch A');
      expect(record, isNotNull);
      expect(record!.courseCode, course);
      expect(record.batch, 'MCA Sem IV — Batch A');
      expect(record.presentCount, 5); // 8 students: seed 1 Absent + 1 flipped Absent, 1 OD
      expect(record.absentCount, 2);
      expect(record.odCount, 1);
      expect(provider.rollCallRecords.first.id, record.id);

      // The submitted register must be durable across restarts.
      final persisted = await LocalDataStoreService.instance.loadRollCallRecords();
      expect(persisted, isNotNull);
      expect(persisted!.any((r) => r.id == record.id), isTrue);

      // Roster edits must also be durable.
      final persistedRosters =
          await LocalDataStoreService.instance.loadRollCallRosters();
      expect(
        persistedRosters[course]!.firstWhere((e) => e.roll == firstRoll).status,
        'Absent',
      );
    });

    test('submitRollCall refuses an unknown course honestly', () {
      final provider = GriProvider();
      final before = provider.rollCallRecords.length;

      final record = provider.submitRollCall('NO-SUCH-COURSE', 'Ghost batch');

      expect(record, isNull);
      expect(provider.rollCallRecords.length, before);
      expect(provider.notificationMessage, contains('No roll register found'));
    });
  });

  group('Hall ticket eligibility (CBCS 75% rule)', () {
    test('approved student with >= 75% in every course is eligible', () {
      final courses = [
        CourseModel(
          id: 'c1', code: 'MCA-401', title: 'T', credits: 4,
          instructor: 'I', schedule: 'S',
          attendancePercent: 75, totalClasses: 40, attendedClasses: 30,
        ),
        CourseModel(
          id: 'c2', code: 'MCA-402', title: 'T', credits: 4,
          instructor: 'I', schedule: 'S',
          attendancePercent: 92, totalClasses: 38, attendedClasses: 35,
        ),
      ];
      final (eligible, _) = GriProvider.evaluateHallTicketEligibility(
        courses: courses, role: 'STUDENT', accountStatus: 'APPROVED',
      );
      expect(eligible, isTrue);
    });

    test('shortfall in any course withholds the ticket with exact reasons', () {
      final courses = [
        CourseModel(
          id: 'c1', code: 'MCA-401', title: 'T', credits: 4,
          instructor: 'I', schedule: 'S',
          attendancePercent: 88, totalClasses: 42, attendedClasses: 37,
        ),
        CourseModel(
          id: 'c2', code: 'MCA-403', title: 'T', credits: 4,
          instructor: 'I', schedule: 'S',
          attendancePercent: 62, totalClasses: 40, attendedClasses: 25,
        ),
      ];
      final (eligible, reason) = GriProvider.evaluateHallTicketEligibility(
        courses: courses, role: 'STUDENT', accountStatus: 'APPROVED',
      );
      expect(eligible, isFalse);
      expect(reason, contains('MCA-403: 62%'));
    });

    test('non-student roles and unapproved accounts are refused', () {
      final courses = [
        CourseModel(
          id: 'c1', code: 'MCA-401', title: 'T', credits: 4,
          instructor: 'I', schedule: 'S',
          attendancePercent: 90, totalClasses: 40, attendedClasses: 36,
        ),
      ];
      final (roleBlocked, roleReason) = GriProvider.evaluateHallTicketEligibility(
        courses: courses, role: 'ADMIN', accountStatus: 'APPROVED',
      );
      expect(roleBlocked, isFalse);
      expect(roleReason, contains('student and scholar accounts only'));

      final (statusBlocked, statusReason) =
          GriProvider.evaluateHallTicketEligibility(
        courses: courses, role: 'STUDENT', accountStatus: 'PENDING_APPROVAL',
      );
      expect(statusBlocked, isFalse);
      expect(statusReason, contains('APPROVED status'));
    });
  });

  group('Cloud schema mappers', () {
    test('cloudRollCallRow maps the vault record shape to the table columns', () {
      final row = SupabaseService.cloudRollCallRow(
        RollCallRecord(
          id: 'rcl_123',
          courseCode: 'MCA-401',
          batch: 'Sem IV',
          recordedBy: 'Dr. R. Subramanian',
          presentCount: 6,
          absentCount: 1,
          odCount: 1,
          recordedAt: 1728800000000,
        ).toMap(),
      );
      expect(row['id'], 'rcl_123');
      expect(row['course_code'], 'MCA-401');
      expect(row['present_count'], 6);
      expect(row['absent_count'], 1);
      expect(row['od_count'], 1);
      expect(row['recorded_by'], 'Dr. R. Subramanian');
      expect(row['recorded_at'], isA<String>());
    });

    test('pending cloud ops queue stores and drains roll-call records', () async {
      final provider = GriProvider();
      provider.submitRollCall('MCA-401', 'Sem IV');

      // The queue write is fire-and-forget; poll briefly until it lands.
      var ops = <Map<String, dynamic>>[];
      for (var attempt = 0; attempt < 30 && ops.isEmpty; attempt++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        ops = await LocalDataStoreService.instance.loadPendingCloudOps();
      }
      // Multiple mutations may queue ops; the roll-call op must be present.
      final rollCallOps = ops
          .where((op) => op['table'] == 'attendance_registers')
          .toList();
      expect(rollCallOps, isNotEmpty);
      expect(
        (rollCallOps.last['payload'] as Map<String, dynamic>)['course_code'],
        'MCA-401',
      );
    });
  });

  group('RBAC authorization gate', () {
    test('guest account cannot activate the ADMIN role', () {
      final provider = GriProvider();
      final guest = provider.availableAccounts
          .firstWhere((a) => a.accountStatus == 'PENDING_APPROVAL');

      provider.switchUserAccount(guest);
      provider.switchAuthorizedRole(UserRole.ADMIN);

      expect(provider.currentRole, isNot(UserRole.ADMIN));
      expect(provider.notificationMessage, contains('Not authorized'));
    });

    testWidgets('role switcher disables chips for roles outside the dossier',
        (tester) async {
      final provider = GriProvider(); // default student: only STUDENT approved

      await tester.pumpWidget(
        ChangeNotifierProvider<GriProvider>.value(
          value: provider,
          child: const MaterialApp(home: Scaffold(body: RoleSwitcherModal())),
        ),
      );
      await tester.pumpAndSettle();

      // Unauthorized chip renders locked and disabled.
      expect(find.text('ADMIN 🔒'), findsOneWidget);
      final adminChip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'ADMIN 🔒'),
      );
      expect(adminChip.onSelected, isNull);

      // Tapping a disabled chip must not change the active role.
      await tester.tap(find.text('ADMIN 🔒'), warnIfMissed: false);
      await tester.pump();
      expect(provider.currentRole, UserRole.STUDENT);
    });
  });
}
