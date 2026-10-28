import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/academic_models.dart';
import '../models/user_model.dart';

/// Persistent local vault for institutional workflow data.
///
/// Every recorded workflow action (grievances, applications, audit trail,
/// leave requests, attendance, assistant conversation) survives application
/// restarts. When Supabase cloud credentials are configured the same records
/// are mirrored to the cloud tables; this store remains the offline source of
/// truth so the application is fully functional without credentials.
class LocalDataStoreService {
  static LocalDataStoreService? _instance;
  static LocalDataStoreService get instance => _instance ??= LocalDataStoreService._();
  LocalDataStoreService._();

  static const String _kCourses = 'gri_vault_courses';
  static const String _kGrievances = 'gri_vault_grievances';
  static const String _kApplications = 'gri_vault_applications';
  static const String _kAuditLogs = 'gri_vault_audit_logs';
  static const String _kLeaveRecords = 'gri_vault_leave_records';
  static const String _kSahayakMessages = 'gri_vault_sahayak_messages';
  static const String _kReadCircularIds = 'gri_vault_read_circular_ids';
  static const String _kActiveAccountId = 'gri_vault_active_account_id';
  static const String _kActiveRole = 'gri_vault_active_role';
  static const String _kRollCallRosters = 'gri_vault_roll_call_rosters';
  static const String _kRollCallRecords = 'gri_vault_roll_call_records';
  static const String _kPendingCloudOps = 'gri_vault_pending_cloud_ops';

  static const int sahayakHistoryLimit = 60;

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ------------------------------------------------------------------
  // Courses (attendance ledger)
  // ------------------------------------------------------------------
  Future<List<CourseModel>?> loadCourses() async {
    try {
      final raw = (await _prefs).getString(_kCourses);
      if (raw == null) return null;
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(CourseModel.fromMap)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCourses(List<CourseModel> courses) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(
        _kCourses,
        jsonEncode(courses.map((c) => c.toMap()).toList()),
      );
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Grievances
  // ------------------------------------------------------------------
  Future<List<GrievanceModel>?> loadGrievances() async {
    try {
      final raw = (await _prefs).getString(_kGrievances);
      if (raw == null) return null;
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(GrievanceModel.fromMap)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveGrievances(List<GrievanceModel> grievances) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(
        _kGrievances,
        jsonEncode(grievances.map((g) => g.toMap()).toList()),
      );
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Registration applications
  // ------------------------------------------------------------------
  Future<List<RegistrationApplication>?> loadApplications() async {
    try {
      final raw = (await _prefs).getString(_kApplications);
      if (raw == null) return null;
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(RegistrationApplication.fromMap)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveApplications(List<RegistrationApplication> apps) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(
        _kApplications,
        jsonEncode(apps.map((a) => a.toMap()).toList()),
      );
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Institutional audit ledger
  // ------------------------------------------------------------------
  Future<List<InstitutionalAuditLog>?> loadAuditLogs() async {
    try {
      final raw = (await _prefs).getString(_kAuditLogs);
      if (raw == null) return null;
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(InstitutionalAuditLog.fromMap)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveAuditLogs(List<InstitutionalAuditLog> logs) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(
        _kAuditLogs,
        jsonEncode(logs.map((l) => l.toMap()).toList()),
      );
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Staff leave records
  // ------------------------------------------------------------------
  Future<List<StaffLeaveRecord>?> loadLeaveRecords() async {
    try {
      final raw = (await _prefs).getString(_kLeaveRecords);
      if (raw == null) return null;
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(StaffLeaveRecord.fromMap)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLeaveRecords(List<StaffLeaveRecord> records) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(
        _kLeaveRecords,
        jsonEncode(records.map((r) => r.toMap()).toList()),
      );
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // GRI-Sahayak assistant conversation
  // ------------------------------------------------------------------
  Future<List<SahayakMessage>?> loadSahayakMessages() async {
    try {
      final raw = (await _prefs).getString(_kSahayakMessages);
      if (raw == null) return null;
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(SahayakMessage.fromMap)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSahayakMessages(List<SahayakMessage> messages) async {
    try {
      final trimmed = messages.length > sahayakHistoryLimit
          ? messages.sublist(messages.length - sahayakHistoryLimit)
          : messages;
      final prefs = await _prefs;
      await prefs.setString(
        _kSahayakMessages,
        jsonEncode(trimmed.map((m) => m.toMap()).toList()),
      );
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Circular read-state (overlaid on whichever circular source is active)
  // ------------------------------------------------------------------
  Future<Set<String>> loadReadCircularIds() async {
    try {
      final raw = (await _prefs).getString(_kReadCircularIds);
      if (raw == null) return <String>{};
      return ((jsonDecode(raw) as List<dynamic>).map((e) => e.toString())).toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> saveReadCircularIds(Set<String> ids) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_kReadCircularIds, jsonEncode(ids.toList()));
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Active demo/role account selection
  // ------------------------------------------------------------------
  Future<String?> loadActiveAccountId() async {
    try {
      return (await _prefs).getString(_kActiveAccountId);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveActiveAccountId(String id) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_kActiveAccountId, id);
    } catch (_) {}
  }

  Future<String?> loadActiveRole() async {
    try {
      return (await _prefs).getString(_kActiveRole);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveActiveRole(String role) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_kActiveRole, role);
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Faculty roll-call rosters (per course code) & submitted registers
  // ------------------------------------------------------------------
  Future<Map<String, List<StudentRollEntry>>> loadRollCallRosters() async {
    try {
      final raw = (await _prefs).getString(_kRollCallRosters);
      if (raw == null) return {};
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (courseCode, roster) => MapEntry(
          courseCode,
          (roster as List<dynamic>)
              .whereType<Map<String, dynamic>>()
              .map(StudentRollEntry.fromMap)
              .toList(),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> saveRollCallRosters(
      Map<String, List<StudentRollEntry>> rosters) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(
        _kRollCallRosters,
        jsonEncode(
          rosters.map((code, roster) => MapEntry(
                code,
                roster.map((e) => e.toMap()).toList(),
              )),
        ),
      );
    } catch (_) {}
  }

  Future<List<RollCallRecord>?> loadRollCallRecords() async {
    try {
      final raw = (await _prefs).getString(_kRollCallRecords);
      if (raw == null) return null;
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(RollCallRecord.fromMap)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveRollCallRecords(List<RollCallRecord> records) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(
        _kRollCallRecords,
        jsonEncode(records.map((r) => r.toMap()).toList()),
      );
    } catch (_) {}
  }

  // ------------------------------------------------------------------
  // Pending cloud operations queue (drained when Supabase is reachable)
  // ------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> loadPendingCloudOps() async {
    try {
      final raw = (await _prefs).getString(_kPendingCloudOps);
      if (raw == null) return [];
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> savePendingCloudOps(List<Map<String, dynamic>> ops) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_kPendingCloudOps, jsonEncode(ops));
    } catch (_) {}
  }

  /// Destructive: wipes all persisted vault data (used by explicit user reset).
  Future<void> clearAll() async {
    try {
      final prefs = await _prefs;
      await prefs.remove(_kCourses);
      await prefs.remove(_kGrievances);
      await prefs.remove(_kApplications);
      await prefs.remove(_kAuditLogs);
      await prefs.remove(_kLeaveRecords);
      await prefs.remove(_kSahayakMessages);
      await prefs.remove(_kReadCircularIds);
      await prefs.remove(_kActiveAccountId);
      await prefs.remove(_kActiveRole);
      await prefs.remove(_kRollCallRosters);
      await prefs.remove(_kRollCallRecords);
      await prefs.remove(_kPendingCloudOps);
    } catch (_) {}
  }
}
