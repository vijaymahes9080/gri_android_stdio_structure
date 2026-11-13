import 'dart:convert';

/// Complete Application Activity Log Record
class AppActivityLog {
  final String id;
  final String userId;
  final String action;
  final String module;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic> metadata;
  final String source;
  final DateTime createdAt;
  final bool isSynced;

  const AppActivityLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.module,
    this.entityType,
    this.entityId,
    this.metadata = const {},
    this.source = 'FLUTTER_MOBILE',
    required this.createdAt,
    this.isSynced = false,
  });

  AppActivityLog copyWith({
    String? id,
    String? userId,
    String? action,
    String? module,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? metadata,
    String? source,
    DateTime? createdAt,
    bool? isSynced,
  }) {
    return AppActivityLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      module: module ?? this.module,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      metadata: metadata ?? this.metadata,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'action': action,
        'module': module,
        'entity_type': entityType,
        'entity_id': entityId,
        'metadata': metadata,
        'source': source,
        'created_at': createdAt.toIso8601String(),
        'is_synced': isSynced,
      };

  factory AppActivityLog.fromMap(Map<String, dynamic> map) {
    return AppActivityLog(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      action: map['action']?.toString() ?? '',
      module: map['module']?.toString() ?? '',
      entityType: map['entity_type']?.toString(),
      entityId: map['entity_id']?.toString(),
      metadata: (map['metadata'] as Map<String, dynamic>?) ?? {},
      source: map['source']?.toString() ?? 'FLUTTER_MOBILE',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
      isSynced: map['is_synced'] == true,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory AppActivityLog.fromJson(String source) =>
      AppActivityLog.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
