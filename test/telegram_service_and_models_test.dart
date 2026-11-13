import 'package:flutter_test/flutter_test.dart';
import 'package:gri_app/models/telegram_models.dart';
import 'package:gri_app/services/telegram_bot_service.dart';

void main() {
  group('Telegram Models Serialization & State Tests', () {
    test('TelegramConnection serializes to and from Map accurately', () {
      final now = DateTime.now();
      final conn = TelegramConnection(
        id: 'conn_101',
        userId: '2026GRI001',
        telegramUserId: 9037258166,
        telegramChatId: 123456789,
        telegramUsername: 'gandhigram_student',
        telegramFirstName: 'Vijay',
        authenticatedRole: 'STUDENT',
        isAuthenticated: true,
        status: TelegramConnectionStatus.connected,
        linkedAt: now,
        lastInteractionAt: now,
      );

      final map = conn.toMap();
      expect(map['user_id'], '2026GRI001');
      expect(map['telegram_user_id'], 9037258166);
      expect(map['authenticated_role'], 'STUDENT');
      expect(map['is_authenticated'], true);

      final restored = TelegramConnection.fromMap(map);
      expect(restored.id, conn.id);
      expect(restored.userId, conn.userId);
      expect(restored.telegramUserId, conn.telegramUserId);
      expect(restored.telegramChatId, conn.telegramChatId);
      expect(restored.authenticatedRole, conn.authenticatedRole);
      expect(restored.isAuthenticated, true);
      expect(restored.status, TelegramConnectionStatus.connected);
    });

    test('TelegramMessageRecord serializes and distinguishes inbound/outbound', () {
      final now = DateTime.now();
      final msgOut = TelegramMessageRecord(
        id: 'msg_01',
        userId: '2026GRI001',
        telegramMessageId: 8899,
        direction: 'OUTBOUND',
        messageType: 'NOTIFICATION',
        content: 'End-semester hall ticket is now available.',
        processingStatus: 'DELIVERED',
        timestamp: now,
      );

      expect(msgOut.isOutbound, true);
      final jsonStr = msgOut.toJson();
      final restored = TelegramMessageRecord.fromJson(jsonStr);
      expect(restored.id, 'msg_01');
      expect(restored.content, 'End-semester hall ticket is now available.');
      expect(restored.isOutbound, true);

      final msgIn = TelegramMessageRecord(
        id: 'msg_02',
        userId: '2026GRI001',
        direction: 'INBOUND',
        messageType: 'COMMAND',
        content: '/attendance',
        processingStatus: 'RECEIVED',
        timestamp: now,
      );
      expect(msgIn.isOutbound, false);
    });

    test('TelegramNotificationPreferences serialization and copyWith', () {
      const prefs = TelegramNotificationPreferences(
        telegramEnabled: true,
        circularsEnabled: true,
        examAlertsEnabled: false,
        grievanceAlertsEnabled: true,
        administrativeAlertsEnabled: false,
      );

      final map = prefs.toMap();
      expect(map['telegram_enabled'], true);
      expect(map['exam_alerts_enabled'], false);

      final restored = TelegramNotificationPreferences.fromMap(map);
      expect(restored.examAlertsEnabled, false);
      expect(restored.grievanceAlertsEnabled, true);

      final updated = restored.copyWith(examAlertsEnabled: true);
      expect(updated.examAlertsEnabled, true);
    });
  });

  group('TelegramBotService Fallback & Deep Link Tests', () {
    test('initiateDeepLinkConnect generates a valid Telegram bot URL', () async {
      final link = await TelegramBotService.instance.initiateDeepLinkConnect('2026GRI001');
      expect(link, isNotNull);
      expect(link!.startsWith('https://t.me/Gandhigram_rural_institutebot?start=link_'), true);
    });
  });
}

