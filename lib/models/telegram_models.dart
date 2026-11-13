import 'dart:convert';

/// Status of the user's Telegram integration
enum TelegramConnectionStatus {
  notConnected,
  connecting,
  connected,
  disconnected,
  connectionFailed,
  reconnecting,
}

extension TelegramConnectionStatusExtension on TelegramConnectionStatus {
  String get label {
    switch (this) {
      case TelegramConnectionStatus.notConnected:
        return 'Not Connected';
      case TelegramConnectionStatus.connecting:
        return 'Connecting...';
      case TelegramConnectionStatus.connected:
        return 'Connected & Verified';
      case TelegramConnectionStatus.disconnected:
        return 'Disconnected';
      case TelegramConnectionStatus.connectionFailed:
        return 'Connection Failed';
      case TelegramConnectionStatus.reconnecting:
        return 'Reconnecting...';
    }
  }
}

/// Represents an active or historical Telegram Bot connection record
class TelegramConnection {
  final String id;
  final String userId;
  final int telegramUserId;
  final int telegramChatId;
  final String telegramUsername;
  final String telegramFirstName;
  final String authenticatedRole;
  final bool isAuthenticated;
  final TelegramConnectionStatus status;
  final DateTime linkedAt;
  final DateTime lastInteractionAt;
  final DateTime? lastLoginAt;
  final DateTime? disconnectedAt;

  const TelegramConnection({
    required this.id,
    required this.userId,
    required this.telegramUserId,
    required this.telegramChatId,
    this.telegramUsername = '',
    this.telegramFirstName = '',
    this.authenticatedRole = 'GUEST',
    this.isAuthenticated = false,
    this.status = TelegramConnectionStatus.connected,
    required this.linkedAt,
    required this.lastInteractionAt,
    this.lastLoginAt,
    this.disconnectedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'telegram_user_id': telegramUserId,
        'telegram_chat_id': telegramChatId,
        'telegram_username': telegramUsername,
        'telegram_first_name': telegramFirstName,
        'authenticated_role': authenticatedRole,
        'is_authenticated': isAuthenticated,
        'connection_status': status == TelegramConnectionStatus.connected
            ? 'CONNECTED'
            : (status == TelegramConnectionStatus.disconnected ? 'DISCONNECTED' : 'SUSPENDED'),
        'linked_at': linkedAt.toIso8601String(),
        'last_interaction_at': lastInteractionAt.toIso8601String(),
        'last_login_at': lastLoginAt?.toIso8601String(),
        'disconnected_at': disconnectedAt?.toIso8601String(),
      };

  factory TelegramConnection.fromMap(Map<String, dynamic> map) {
    final statusStr = map['connection_status']?.toString().toUpperCase() ?? 'CONNECTED';
    TelegramConnectionStatus st = TelegramConnectionStatus.connected;
    if (statusStr == 'DISCONNECTED') {
      st = TelegramConnectionStatus.disconnected;
    } else if (statusStr == 'SUSPENDED' || statusStr == 'FAILED') {
      st = TelegramConnectionStatus.connectionFailed;
    }

    return TelegramConnection(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      telegramUserId: int.tryParse(map['telegram_user_id']?.toString() ?? '0') ?? 0,
      telegramChatId: int.tryParse(map['telegram_chat_id']?.toString() ?? '0') ?? 0,
      telegramUsername: map['telegram_username']?.toString() ?? '',
      telegramFirstName: map['telegram_first_name']?.toString() ?? '',
      authenticatedRole: map['authenticated_role']?.toString() ?? 'GUEST',
      isAuthenticated: map['is_authenticated'] == true,
      status: st,
      linkedAt: DateTime.tryParse(map['linked_at']?.toString() ?? '') ?? DateTime.now(),
      lastInteractionAt:
          DateTime.tryParse(map['last_interaction_at']?.toString() ?? '') ?? DateTime.now(),
      lastLoginAt: map['last_login_at'] != null
          ? DateTime.tryParse(map['last_login_at'].toString())
          : null,
      disconnectedAt: map['disconnected_at'] != null
          ? DateTime.tryParse(map['disconnected_at'].toString())
          : null,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory TelegramConnection.fromJson(String source) =>
      TelegramConnection.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

/// Inbound or Outbound Telegram message record
class TelegramMessageRecord {
  final String id;
  final String userId;
  final int? telegramMessageId;
  final String direction; // 'INBOUND' or 'OUTBOUND'
  final String messageType; // 'TEXT', 'COMMAND', 'NOTIFICATION'
  final String content;
  final String processingStatus; // 'DELIVERED', 'FAILED', 'RECEIVED'
  final String? errorMessage;
  final DateTime timestamp;

  const TelegramMessageRecord({
    required this.id,
    required this.userId,
    this.telegramMessageId,
    required this.direction,
    this.messageType = 'TEXT',
    required this.content,
    this.processingStatus = 'DELIVERED',
    this.errorMessage,
    required this.timestamp,
  });

  bool get isOutbound => direction.toUpperCase() == 'OUTBOUND';

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'telegram_message_id': telegramMessageId,
        'direction': direction,
        'message_type': messageType,
        'message_content': content,
        'processing_status': processingStatus,
        'error_message': errorMessage,
        'created_at': timestamp.toIso8601String(),
      };

  factory TelegramMessageRecord.fromMap(Map<String, dynamic> map) {
    return TelegramMessageRecord(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      telegramMessageId: int.tryParse(map['telegram_message_id']?.toString() ?? ''),
      direction: map['direction']?.toString() ?? 'OUTBOUND',
      messageType: map['message_type']?.toString() ?? 'TEXT',
      content: map['message_content']?.toString() ?? '',
      processingStatus: map['processing_status']?.toString() ?? 'DELIVERED',
      errorMessage: map['error_message']?.toString(),
      timestamp: DateTime.tryParse(map['created_at']?.toString() ??
              map['sent_at']?.toString() ??
              map['received_at']?.toString() ??
              '') ??
          DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory TelegramMessageRecord.fromJson(String source) =>
      TelegramMessageRecord.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

/// User's Telegram Notification Delivery Preferences
class TelegramNotificationPreferences {
  final bool telegramEnabled;
  final bool circularsEnabled;
  final bool examAlertsEnabled;
  final bool grievanceAlertsEnabled;
  final bool administrativeAlertsEnabled;

  const TelegramNotificationPreferences({
    this.telegramEnabled = true,
    this.circularsEnabled = true,
    this.examAlertsEnabled = true,
    this.grievanceAlertsEnabled = true,
    this.administrativeAlertsEnabled = true,
  });

  TelegramNotificationPreferences copyWith({
    bool? telegramEnabled,
    bool? circularsEnabled,
    bool? examAlertsEnabled,
    bool? grievanceAlertsEnabled,
    bool? administrativeAlertsEnabled,
  }) {
    return TelegramNotificationPreferences(
      telegramEnabled: telegramEnabled ?? this.telegramEnabled,
      circularsEnabled: circularsEnabled ?? this.circularsEnabled,
      examAlertsEnabled: examAlertsEnabled ?? this.examAlertsEnabled,
      grievanceAlertsEnabled: grievanceAlertsEnabled ?? this.grievanceAlertsEnabled,
      administrativeAlertsEnabled:
          administrativeAlertsEnabled ?? this.administrativeAlertsEnabled,
    );
  }

  Map<String, dynamic> toMap() => {
        'telegram_enabled': telegramEnabled,
        'circulars_enabled': circularsEnabled,
        'exam_alerts_enabled': examAlertsEnabled,
        'grievance_alerts_enabled': grievanceAlertsEnabled,
        'administrative_alerts_enabled': administrativeAlertsEnabled,
      };

  factory TelegramNotificationPreferences.fromMap(Map<String, dynamic> map) {
    return TelegramNotificationPreferences(
      telegramEnabled: map['telegram_enabled'] as bool? ?? true,
      circularsEnabled: map['circulars_enabled'] as bool? ?? true,
      examAlertsEnabled: map['exam_alerts_enabled'] as bool? ?? true,
      grievanceAlertsEnabled: map['grievance_alerts_enabled'] as bool? ?? true,
      administrativeAlertsEnabled: map['administrative_alerts_enabled'] as bool? ?? true,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory TelegramNotificationPreferences.fromJson(String source) =>
      TelegramNotificationPreferences.fromMap(
          jsonDecode(source) as Map<String, dynamic>);
}
