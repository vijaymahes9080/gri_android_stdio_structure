import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gri_app/models/activity_log_model.dart';
import 'package:gri_app/services/activity_logging_service.dart';
import 'package:gri_app/services/local_data_store_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppActivityLog & ActivityLoggingService Tests', () {
    test('AppActivityLog model serializes cleanly to Map and JSON', () {
      final now = DateTime.now();
      final log = AppActivityLog(
        id: 'act_001',
        userId: '2026GRI001',
        action: 'HALL_TICKET_VIEW',
        module: 'ACADEMICS',
        entityType: 'hall_tickets',
        entityId: 'HT-2026-MCA',
        metadata: {'semester': 'IV', 'degree': 'MCA'},
        createdAt: now,
        isSynced: false,
      );

      final map = log.toMap();
      expect(map['action'], 'HALL_TICKET_VIEW');
      expect(map['module'], 'ACADEMICS');
      expect(map['metadata']['semester'], 'IV');

      final restored = AppActivityLog.fromMap(map);
      expect(restored.id, 'act_001');
      expect(restored.action, 'HALL_TICKET_VIEW');
      expect(restored.entityId, 'HT-2026-MCA');
    });

    test('ActivityLoggingService logs event, redacts passwords, and queues offline', () async {
      await ActivityLoggingService.instance.logEvent(
        userId: '2026GRI001',
        action: 'LOGIN_ATTEMPT',
        module: 'AUTH',
        metadata: {
          'username': 'student1',
          'password': 'superSecretPassword123',
          'device': 'Pixel 8',
        },
      );

      final pending = await LocalDataStoreService.instance.loadPendingActivityLogs();
      expect(pending.isNotEmpty, true);

      final logged = pending.last;
      expect(logged.action, 'LOGIN_ATTEMPT');
      expect(logged.metadata['username'], 'student1');
      // Verify security redaction invariant: password must NEVER be logged
      expect(logged.metadata['password'], '[REDACTED]');
      expect(logged.metadata['device'], 'Pixel 8');
    });
  });
}

