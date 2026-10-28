import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin data-access layer over Supabase.
///
/// Initialization is safe to call without credentials: the app then runs in
/// offline-vault mode and every cloud operation degrades to a no-op instead
/// of pretending to succeed. Once dart-define credentials are supplied, the
/// same call sites transparently begin mirroring to the cloud tables defined
/// in supabase/migrations/.
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  SupabaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Honest mode label surfaced in the admin directory UI.
  String get dataModeLabel =>
      _isInitialized ? 'Cloud Connected • Supabase' : 'Offline Vault • Local Store';

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    return Supabase.instance.client;
  }

  /// Reads credentials from `--dart-define SUPABASE_URL / SUPABASE_ANON_KEY`.
  /// When absent the service stays disabled and the app runs fully offline.
  Future<void> initialize({
    String? supabaseUrl,
    String? supabaseAnonKey,
  }) async {
    final url = supabaseUrl ??
        const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    final anonKey = supabaseAnonKey ??
        const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

    if (url.isNotEmpty &&
        anonKey.isNotEmpty &&
        url.startsWith('http')) {
      try {
        if (_initializedClientExists()) {
          _isInitialized = true;
          return;
        }
        await Supabase.initialize(url: url, anonKey: anonKey);
        _isInitialized = true;
      } catch (_) {
        _isInitialized = false;
      }
    } else {
      // Credentials not provided — offline-vault mode (documented in README).
      _isInitialized = false;
    }
  }

  bool _initializedClientExists() {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  // ------------------------------------------------------------------
  // Generic table access
  // ------------------------------------------------------------------
  Future<List<Map<String, dynamic>>?> fetchTable(String tableName) async {
    final db = client;
    if (db == null) return null;
    try {
      final response = await db.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return null;
    }
  }

  Future<bool> insertRecord(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    final db = client;
    if (db == null) return false;
    try {
      await db.from(tableName).insert(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateRecord(
    String tableName,
    String idField,
    dynamic idValue,
    Map<String, dynamic> data,
  ) async {
    final db = client;
    if (db == null) return false;
    try {
      await db.from(tableName).update(data).eq(idField, idValue);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ------------------------------------------------------------------
  // Typed institutional operations (mirror of the local vault)
  // ------------------------------------------------------------------

  /// Published circulars from the cloud publishing hub.
  Future<List<Map<String, dynamic>>?> fetchPublishedCirculars() =>
      fetchTable('circulars_notices');

  /// Certificate verification register (e-SANAD mirror).
  Future<List<Map<String, dynamic>>?> fetchCertificates() =>
      fetchTable('document_certificates');

  /// Pushes a grievance record; returns false when offline or rejected.
  Future<bool> pushGrievance(Map<String, dynamic> row) =>
      insertRecord('grievances', row);

  /// Pushes a registration application to the registrar review queue.
  Future<bool> pushApplication(Map<String, dynamic> row) =>
      insertRecord('registration_applications', row);

  /// Pushes an immutable audit-ledger entry.
  Future<bool> pushAuditLog(Map<String, dynamic> row) =>
      insertRecord('audit_logs', row);

  /// Pushes a faculty leave request.
  Future<bool> pushLeaveRecord(Map<String, dynamic> row) =>
      insertRecord('faculty_leaves', row);
}
