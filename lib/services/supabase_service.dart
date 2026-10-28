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
  // Local → cloud schema mapping
  //
  // The offline vault stores records in the app's model shape. Cloud tables
  // define their own columns and CHECK constraints, so payloads must be
  // translated before insertion or every queued op would be rejected.
  // These mappers are pure and directly unit-testable.
  // ------------------------------------------------------------------

  /// Grievances table: id TEXT PK, user_id NOT NULL, date TEXT NOT NULL,
  /// status CHECK IN ('SUBMITTED','IN_PROGRESS','RESOLVED').
  static Map<String, dynamic> cloudGrievanceRow(Map<String, dynamic> local) {
    final roll = local['student_roll_no']?.toString() ?? 'anonymous';
    final ticket = local['ticket_number']?.toString() ??
        (local['id']?.toString() ?? 'GRV-UNKNOWN');
    final createdAt = (local['created_at'] as num?)?.toInt();
    final created = createdAt != null
        ? DateTime.fromMillisecondsSinceEpoch(createdAt).toIso8601String()
        : DateTime.now().toIso8601String();
    final localStatus = local['status']?.toString() ?? 'SUBMITTED';
    // Local status vocabulary: SUBMITTED / IN_REVIEW / RESOLVED.
    final cloudStatus = localStatus == 'IN_REVIEW' ? 'IN_PROGRESS' : localStatus;
    return {
      'id': '$roll|$ticket', // deterministic PK; per-user namespace prevents collisions
      'user_id': roll,
      'category': local['category']?.toString() ?? 'General',
      'subject': local['subject']?.toString() ?? 'Untitled grievance',
      'description': local['description']?.toString() ?? '',
      'date': created,
      'status': cloudStatus,
      'remarks': local['remarks']?.toString() ?? '',
    };
  }

  /// Audit logs table: actor_user_id/actor_name/target_user_id/action NOT NULL,
  /// previous_status/new_status, remarks (no external id column).
  static Map<String, dynamic> cloudAuditRow(Map<String, dynamic> local) {
    final adminName = local['admin_name']?.toString() ?? 'System';
    final adminRole = local['admin_role']?.toString() ?? 'ADMIN';
    final targetUser = local['target_user']?.toString() ?? '';
    final targetRole = local['target_role']?.toString() ?? '';
    return {
      'actor_user_id': 'admin|$targetUser|$targetRole',
      'actor_name': '$adminName ($adminRole)',
      'target_user_id': targetUser,
      'action': local['action']?.toString() ?? 'UNKNOWN',
      'previous_status': local['previous_state']?.toString(),
      'new_status': local['new_state']?.toString(),
      'remarks': local['reason_or_notes']?.toString(),
    };
  }

  /// Faculty leaves table: user_id/faculty_name/type/dates/days/reason,
  /// status CHECK IN ('PENDING_HOD','APPROVED','REJECTED').
  static Map<String, dynamic> cloudLeaveRow(Map<String, dynamic> local) {
    final owner = local['owner_id']?.toString().isNotEmpty == true
        ? local['owner_id'].toString()
        : 'unknown-staff';
    final ownerName = local['owner_name']?.toString().isNotEmpty == true
        ? local['owner_name'].toString()
        : 'GRI Staff Member';
    final fromDate = local['from_date']?.toString() ?? '';
    final toDate = local['toDate']?.toString() ??
        local['to_date']?.toString() ??
        fromDate;
    final localStatus = local['status']?.toString() ?? 'SUBMITTED';
    final cloudStatus = localStatus == 'SUBMITTED' ? 'PENDING_HOD' : localStatus;
    final days = (local['days'] as num?)?.toInt() ?? 1;
    final dateRange = fromDate == toDate ? fromDate : '$fromDate — $toDate';
    return {
      'id': '$owner|$fromDate|$toDate|${local['leave_type'] ?? ''}',
      'user_id': owner,
      'faculty_name': ownerName,
      'type': local['leave_type']?.toString() ?? 'Leave',
      'dates': dateRange,
      'days': days,
      'reason': local['reason']?.toString() ?? '',
      'status': cloudStatus,
    };
  }

  /// Attendance registers table (append-only roll-call ledger): id TEXT PK,
  /// course_code/batch/recorded_by NOT NULL, integer counts >= 0.
  static Map<String, dynamic> cloudRollCallRow(Map<String, dynamic> local) {
    final recordedAt = (local['recorded_at'] as num?)?.toInt();
    return {
      'id': local['id']?.toString() ?? 'rcl_${DateTime.now().millisecondsSinceEpoch}',
      'course_code': local['course_code']?.toString() ?? 'UNKNOWN',
      'batch': local['batch']?.toString() ?? 'Unspecified batch',
      'recorded_by': local['recorded_by']?.toString() ?? 'GRI Faculty',
      'present_count': (local['present_count'] as num?)?.toInt() ?? 0,
      'absent_count': (local['absent_count'] as num?)?.toInt() ?? 0,
      'od_count': (local['od_count'] as num?)?.toInt() ?? 0,
      'recorded_at': recordedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(recordedAt).toIso8601String()
          : DateTime.now().toIso8601String(),
    };
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

  /// Pushes a submitted attendance register (append-only roll-call ledger).
  Future<bool> pushRollCallRecord(Map<String, dynamic> row) =>
      insertRecord('attendance_registers', row);
}
