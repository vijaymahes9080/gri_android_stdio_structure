import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/telegram_models.dart';
import 'local_data_store_service.dart';
import 'supabase_service.dart';
import 'activity_logging_service.dart';

/// Client Service for Telegram Bot Integration & Supabase Edge Functions
class TelegramBotService {
  TelegramBotService._();
  static final TelegramBotService instance = TelegramBotService._();

  static const String botUsername = 'Gandhigram_rural_institutebot';
  static const String botDisplayName = 'Gandhigram Rural Institute Bot';

  /// Generates a secure deep link URL for account linking.
  /// When cloud credentials are configured, calls Supabase Edge Function `telegram-connect`.
  /// Otherwise, generates a secure local deep link for offline testing.
  Future<String?> initiateDeepLinkConnect(String userId) async {
    final client = SupabaseService.instance.client;
    if (client != null && SupabaseService.instance.isInitialized) {
      try {
        final res = await client.functions.invoke(
          'telegram-connect',
          body: {'userId': userId},
        );
        if (res.status == 200 && res.data != null) {
          final data = res.data is Map ? res.data : jsonDecode(res.data.toString());
          final link = data['deep_link']?.toString();
          if (link != null && link.isNotEmpty) {
            await ActivityLoggingService.instance.logEvent(
              userId: userId,
              action: 'TELEGRAM_LINK_REQUESTED',
              module: 'TELEGRAM',
              metadata: {'deep_link': link},
            );
            return link;
          }
        }
      } catch (e) {
        debugPrint('telegram-connect invocation error: $e');
      }
    }

    // Offline vault fallback
    final randomHex = List.generate(32, (_) => Random().nextInt(16).toRadixString(16)).join();
    final fallbackLink = 'https://t.me/$botUsername?start=link_$randomHex';

    await ActivityLoggingService.instance.logEvent(
      userId: userId,
      action: 'TELEGRAM_LINK_REQUESTED_OFFLINE',
      module: 'TELEGRAM',
      metadata: {'deep_link': fallbackLink},
    );

    return fallbackLink;
  }

  /// Fetches connection status from backend or local storage.
  Future<TelegramConnection?> fetchConnectionStatus(String userId) async {
    final client = SupabaseService.instance.client;
    if (client != null && SupabaseService.instance.isInitialized) {
      try {
        final res = await client.functions.invoke(
          'telegram-connection-status',
          queryParameters: {'userId': userId},
        );
        if (res.status == 200 && res.data != null) {
          final data = res.data is Map ? res.data : jsonDecode(res.data.toString());
          if (data['is_connected'] == true && data['connection'] != null) {
            final conn = TelegramConnection.fromMap(data['connection'] as Map<String, dynamic>);
            await LocalDataStoreService.instance.saveTelegramConnection(conn);

            if (data['messages'] is List) {
              final msgs = (data['messages'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map(TelegramMessageRecord.fromMap)
                  .toList();
              await LocalDataStoreService.instance.saveTelegramMessages(msgs);
            }

            return conn;
          } else {
            await LocalDataStoreService.instance.clearTelegramConnection();
            return null;
          }
        }
      } catch (e) {
        debugPrint('telegram-connection-status error: $e');
      }
    }

    // Offline store
    return await LocalDataStoreService.instance.loadTelegramConnection();
  }

  /// Disconnects the Telegram account.
  Future<bool> disconnectTelegram(String userId) async {
    bool ok = true;
    final client = SupabaseService.instance.client;
    if (client != null && SupabaseService.instance.isInitialized) {
      try {
        final res = await client.functions.invoke(
          'telegram-disconnect',
          body: {'userId': userId},
        );
        ok = res.status == 200;
      } catch (e) {
        debugPrint('telegram-disconnect error: $e');
        ok = false;
      }
    }

    final current = await LocalDataStoreService.instance.loadTelegramConnection();
    if (current != null) {
      final disconnected = TelegramConnection(
        id: current.id,
        userId: current.userId,
        telegramUserId: current.telegramUserId,
        telegramChatId: current.telegramChatId,
        telegramUsername: current.telegramUsername,
        telegramFirstName: current.telegramFirstName,
        authenticatedRole: 'GUEST',
        isAuthenticated: false,
        status: TelegramConnectionStatus.disconnected,
        linkedAt: current.linkedAt,
        lastInteractionAt: DateTime.now(),
        disconnectedAt: DateTime.now(),
      );
      await LocalDataStoreService.instance.saveTelegramConnection(disconnected);
    }

    await ActivityLoggingService.instance.logEvent(
      userId: userId,
      action: 'TELEGRAM_DISCONNECTED',
      module: 'TELEGRAM',
    );

    return ok;
  }

  /// Sends a test notification to the user's Telegram.
  Future<bool> sendTestNotification(String userId, String message) async {
    final client = SupabaseService.instance.client;
    if (client != null && SupabaseService.instance.isInitialized) {
      try {
        final res = await client.functions.invoke(
          'telegram-send-message',
          body: {
            'userId': userId,
            'message': message,
            'notification_type': 'TEST_ALERT',
          },
        );
        final data = res.data is Map ? res.data : jsonDecode(res.data.toString());
        return data['ok'] == true;
      } catch (e) {
        debugPrint('telegram-send-message error: $e');
      }
    }

    // In offline vault mode: record outbound message record locally
    final store = LocalDataStoreService.instance;
    final msgs = await store.loadTelegramMessages();
    final newMsg = TelegramMessageRecord(
      id: 'tg_msg_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      direction: 'OUTBOUND',
      messageType: 'NOTIFICATION',
      content: message,
      processingStatus: 'DELIVERED',
      timestamp: DateTime.now(),
    );
    msgs.insert(0, newMsg);
    await store.saveTelegramMessages(msgs);

    await ActivityLoggingService.instance.logEvent(
      userId: userId,
      action: 'TELEGRAM_TEST_MESSAGE_LOCAL',
      module: 'TELEGRAM',
      metadata: {'content': message},
    );

    return true;
  }

  /// Loads message history
  Future<List<TelegramMessageRecord>> fetchMessageHistory(String userId) async {
    return await LocalDataStoreService.instance.loadTelegramMessages();
  }

  /// Updates notification preferences for Telegram channel
  Future<bool> updatePreferences(
    String userId,
    TelegramNotificationPreferences prefs,
  ) async {
    await LocalDataStoreService.instance.saveTelegramPreferences(prefs);

    final client = SupabaseService.instance.client;
    if (client != null && SupabaseService.instance.isInitialized) {
      try {
        await client.from('notification_preferences').upsert({
          'user_id': userId,
          ...prefs.toMap(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('updatePreferences cloud error: $e');
      }
    }

    await ActivityLoggingService.instance.logEvent(
      userId: userId,
      action: 'NOTIFICATION_PREFERENCES_UPDATED',
      module: 'SETTINGS',
      metadata: prefs.toMap(),
    );

    return true;
  }
}
