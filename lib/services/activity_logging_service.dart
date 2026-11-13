import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/activity_log_model.dart';
import 'local_data_store_service.dart';
import 'supabase_service.dart';

/// Centralized, Privacy-Respecting Application Activity Logging Service
/// Conforms to Phase 6 & Phase 8 of GRI Cloud Telemetry Specification.
class ActivityLoggingService {
  ActivityLoggingService._();
  static final ActivityLoggingService instance = ActivityLoggingService._();

  bool _isDraining = false;

  /// Logs a meaningful application action.
  /// Never records passwords, authentication secrets, tokens or private data.
  Future<void> logEvent({
    required String userId,
    required String action,
    required String module,
    String? entityType,
    String? entityId,
    Map<String, dynamic> metadata = const {},
    String source = 'FLUTTER_MOBILE',
  }) async {
    try {
      final sanitizedMetadata = _sanitizeMetadata(metadata);
      final log = AppActivityLog(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}',
        userId: userId,
        action: action,
        module: module,
        entityType: entityType,
        entityId: entityId,
        metadata: sanitizedMetadata,
        source: source,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      final store = LocalDataStoreService.instance;
      final pending = await store.loadPendingActivityLogs();
      pending.add(log);
      await store.savePendingActivityLogs(pending);

      // Attempt non-blocking drain if cloud service is reachable
      unawaited(drainPendingLogs());
    } catch (e) {
      debugPrint('ActivityLoggingService.logEvent error: $e');
    }
  }

  /// Drains queued offline activity logs to Supabase app_activity_logs table.
  Future<int> drainPendingLogs() async {
    if (_isDraining) return 0;
    if (!SupabaseService.instance.isInitialized) return 0;

    _isDraining = true;
    int syncedCount = 0;

    try {
      final store = LocalDataStoreService.instance;
      final pending = await store.loadPendingActivityLogs();
      if (pending.isEmpty) {
        _isDraining = false;
        return 0;
      }

      final client = SupabaseService.instance.client;
      if (client == null) {
        _isDraining = false;
        return 0;
      }

      final remaining = <AppActivityLog>[];

      for (final item in pending) {
        try {
          await client.from('app_activity_logs').insert({
            'user_id': item.userId,
            'action': item.action,
            'module': item.module,
            'entity_type': item.entityType,
            'entity_id': item.entityId,
            'metadata': item.metadata,
            'source': item.source,
            'created_at': item.createdAt.toIso8601String(),
          });
          syncedCount++;
        } catch (_) {
          remaining.add(item);
        }
      }

      await store.savePendingActivityLogs(remaining);
    } catch (e) {
      debugPrint('ActivityLoggingService.drainPendingLogs error: $e');
    } finally {
      _isDraining = false;
    }

    return syncedCount;
  }

  /// Removes sensitive keys such as password, token, pin, secret from telemetry payloads.
  Map<String, dynamic> _sanitizeMetadata(Map<String, dynamic> input) {
    final sanitized = <String, dynamic>{};
    for (final entry in input.entries) {
      final keyLower = entry.key.toLowerCase();
      if (keyLower.contains('password') ||
          keyLower.contains('secret') ||
          keyLower.contains('token') ||
          keyLower.contains('pin') ||
          keyLower.contains('auth_header')) {
        sanitized[entry.key] = '[REDACTED]';
      } else {
        sanitized[entry.key] = entry.value;
      }
    }
    return sanitized;
  }
}
