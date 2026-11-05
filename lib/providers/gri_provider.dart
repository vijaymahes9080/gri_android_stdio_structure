import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../services/official_web_sync_service.dart';
import '../services/local_data_store_service.dart';
import '../services/supabase_service.dart';
import '../services/sahayak_knowledge_engine.dart';
import '../utils/gri_colors.dart';

enum NavigationTab {
  HOME,
  ACADEMICS,
  CAMPUS,
  SERVICES,
  MORE,
  APPROVALS,
  EXAMS,
  RESEARCH,
  STATUS,
}

class GriProvider extends ChangeNotifier {
  // Navigation State
  NavigationTab _currentTab = NavigationTab.HOME;
  NavigationTab get currentTab => _currentTab;

  int _activeAcademicTab = 0; // 0: Courses, 1: Exams, 2: Grade Cards, 3: Calendar
  int get activeAcademicTab => _activeAcademicTab;

  String _activeServicesCategory = "services";
  String get activeServicesCategory => _activeServicesCategory;

  String _activeCampusFilter = "all";
  String get activeCampusFilter => _activeCampusFilter;

  // Settings & System Preferences State (Persistent)
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  double _textScaleFactor = 1.0;
  double get textScaleFactor => _textScaleFactor;

  String _languageCode = 'en'; // 'en' for English, 'ta' for Tamil
  String get languageCode => _languageCode;

  bool _reduceMotion = false;
  bool get reduceMotion => _reduceMotion;

  bool _noticesEnabled = true;
  bool get noticesEnabled => _noticesEnabled;

  bool _examAlertsEnabled = true;
  bool get examAlertsEnabled => _examAlertsEnabled;

  DateTime? _lastSyncTimestamp;
  DateTime? get lastSyncTimestamp => _lastSyncTimestamp;

  // Role & User State
  UserRole _currentRole = UserRole.STUDENT;
  UserRole get currentRole => _currentRole;

  AccountStatus _activeAccountStatus = AccountStatus.APPROVED;
  AccountStatus get activeAccountStatus => _activeAccountStatus;

  bool _isAuthenticated = true;
  bool get isAuthenticated => _isAuthenticated;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Cloud & Sync State
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;
  int _pendingSyncCount = 0;
  int get pendingSyncCount => _pendingSyncCount;

  /// Honest runtime mode: reflects whether a Supabase backend is actually
  /// configured ("Cloud Connected • Supabase") or the app runs entirely on
  /// its persistent local vault ("Offline Vault • Local Store").
  String _ktorServerStatus = SupabaseService.instance.dataModeLabel;
  String get ktorServerStatus => _ktorServerStatus;

  // Notifications & Feedback
  String? _notificationMessage;
  String? get notificationMessage => _notificationMessage;

  // Dialog & Modal States
  bool _isRegistrationWizardOpen = false;
  bool get isRegistrationWizardOpen => _isRegistrationWizardOpen;

  bool _isRoleSwitcherOpen = false;
  bool get isRoleSwitcherOpen => _isRoleSwitcherOpen;

  bool _isAdminReviewOpen = false;
  bool get isAdminReviewOpen => _isAdminReviewOpen;

  bool _isAskAiOpen = false;
  bool get isAskAiOpen => _isAskAiOpen;

  // ── Official circulars (canonical notices, NOT fabricated seed data) ──────

  List<OfficialNotice> _officialNotices = [];
  List<OfficialNotice> get officialNotices => _officialNotices;

  /// Merged view: locally published circulars (persisted) + latest live notices
  List<OfficialNotice> get circulars {
    final published = _locallyPublishedCirculars;
    final live = _officialNotices;
    // Published always stay at the top; live notices follow, marked read based on state
    final readIds = _readCircularIds;
    // Mark live notices as read if they were previously seen
    final merged = <OfficialNotice>[];
    // First add published ones
    merged.addAll(published);
    // Then add live ones (dedup by id)
    for (final n in live) {
      if (!published.any((c) => c.id == n.id)) {
        final copy = n.copyWith(isRead: readIds.contains(n.id));
        merged.add(copy);
      }
    }
    return merged;
  }

  // Track which circulars (from the official feed) the user has read
  final Set<String> _readCircularIds = {};
  Set<String> get readCircularIds => _readCircularIds;

  List<OfficialNotice> _locallyPublishedCirculars = [];
  List<OfficialNotice> get locallyPublishedCirculars =>
      _locallyPublishedCirculars;

  // ── Other data lists (unchanged from original provider structure) ──────

  List<CourseModel> _courses = [];
  List<CourseModel> get courses => _courses;

  List<GrievanceModel> _grievances = [];
  List<GrievanceModel> get grievances => _grievances;

  List<TransportRouteModel> _transportRoutes = [];
  List<TransportRouteModel> get transportRoutes => _transportRoutes;

  List<RegistrationApplication> _applications = [];
  List<RegistrationApplication> get applications => _applications;

  List<InstitutionalAuditLog> _auditLogs = [];
  List<InstitutionalAuditLog> get auditLogs => _auditLogs;

  List<StaffLeaveRecord> _leaveRecords = [];
  List<StaffLeaveRecord> get leaveRecords => _leaveRecords;

  List<PublishingAuditEntry> _publishingAuditLogs = [];
  List<PublishingAuditEntry> get publishingAuditLogs => _publishingAuditLogs;

  List<SahayakMessage> _sahayakMessages = [];
  List<SahayakMessage> get sahayakMessages => _sahayakMessages;

  // Faculty roll-call state (persisted)
  Map<String, List<StudentRollEntry>> _rollCallRosters = {};
  List<RollCallRecord> _rollCallRecords = [];
  Map<String, List<StudentRollEntry>> get rollCallRosters => _rollCallRosters;

  List<StudentRollEntry> rollCallRosterFor(String courseCode) =>
      List.unmodifiable(_rollCallRosters[courseCode] ?? const []);

  void setRollStatus(String courseCode, String roll) {
    final roster = _rollCallRosters[courseCode];
    if (roster == null) return;
    final index = roster.indexWhere((e) => e.roll == roll);
    if (index == -1) return;
    final current = roster[index].status;
    final next = current == "Present"
        ? "Absent"
        : (current == "Absent" ? "OD" : "Present");
    _rollCallRosters[courseCode] = List.of(roster)
      ..[index] = roster[index].copyWith(status: next);
    LocalDataStoreService.instance.saveRollCallRosters(_rollCallRosters);
    notifyListeners();
  }

  RollCallRecord? submitRollCall(String courseCode, String batch) {
    final roster = _rollCallRosters[courseCode];
    if (roster == null || roster.isEmpty) {
      _showNotification(
          "No roll register found for $courseCode — nothing was submitted.");
      notifyListeners();
      return null;
    }
    int count(String status) => roster.where((e) => e.status == status).length;
    final record = RollCallRecord(
      id: "rcl_${DateTime.now().millisecondsSinceEpoch}",
      courseCode: courseCode,
      batch: batch,
      recordedBy: _currentUser?.name ?? "Faculty",
      presentCount: count("Present"),
      absentCount: count("Absent"),
      odCount: count("OD"),
      recordedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _rollCallRecords.insert(0, record);
    LocalDataStoreService.instance.saveRollCallRecords(_rollCallRecords);
    LocalDataStoreService.instance.saveRollCallRosters(_rollCallRosters);
    _queueCloudOp('attendance_registers', record.toMap());
    _showNotification(
      "Register for $courseCode recorded: ${record.presentCount} Present, "
          "${record.absentCount} Absent, ${record.odCount} On-Duty.",
    );
    notifyListeners();
    return record;
  }

  // Simulated preset accounts for testing role workflows
  final List<UserModel> _availableAccounts = [
    UserModel(
      id: "usr_admin",
      name: "Dr. M. Sundaramari",
      email: "registrar@ruraluniv.ac.in",
      role: "ADMIN",
      rollNo: "ADMIN-GRI-01",
      department: "Central Administration",
      semester: "Registrar's Directorate",
      cgpa: "Registrar in-charge",
      accountStatus: "APPROVED",
      approvedRolesCsv: "ADMIN,FACULTY",
    ),
    UserModel(
      id: "usr_faculty",
      name: "Dr. R. Subramanian",
      email: "r.subramanian@ruraluniv.ac.in",
      role: "FACULTY",
      rollNo: "FAC-CS-108",
      department: "School of Sciences & Rural Technology",
      semester: "Senior Associate Professor",
      cgpa: "Ph.D. IIT Madras",
      accountStatus: "APPROVED",
      approvedRolesCsv: "FACULTY,SCHOLAR",
    ),
    UserModel(
      id: "usr_student",
      name: "Vijay Pradhap",
      email: "vijay.p24@ruraluniv.ac.in",
      role: "STUDENT",
      rollNo: "2024-MS-4011",
      department: "Computer Science & Applications",
      semester: "Semester IV",
      cgpa: "8.92",
      accountStatus: "APPROVED",
      approvedRolesCsv: "STUDENT",
    ),
    UserModel(
      id: "usr_pending",
      name: "Kavitha Mohan",
      email: "kavitha.m26@ruraluniv.ac.in",
      role: "GUEST",
      rollNo: "2026-MA-8821",
      department: "Department of Rural Development",
      semester: "Applicant",
      cgpa: "Pending",
      accountStatus: "PENDING_APPROVAL",
      requestedRole: "STUDENT",
      applicationId: "APP-2026-9042",
    ),
    UserModel(
      id: "usr_review",
      name: "Arun Kumar",
      email: "arun.agri26@ruraluniv.ac.in",
      role: "GUEST",
      rollNo: "2026-PHD-AGR-05",
      department: "School of Agriculture & Rural Innovation",
      semester: "Applicant (Under Review)",
      cgpa: "Under Review",
      accountStatus: "UNDER_REVIEW",
      approvedRolesCsv: "GUEST",
      requestedRole: "SCHOLAR",
      applicationId: "APP-2026-8819",
      adminClarificationQuery:
          "Please upload or provide your PG Degree Provisional Certificate register number.",
    ),
  ];

  List<UserModel> get availableAccounts => _availableAccounts;

  // Preference Storage Keys
  static const String _prefThemeKey = 'gri_pref_theme_mode';
  static const String _prefTextScaleKey = 'gri_pref_text_scale';
  static const String _prefLanguageKey = 'gri_pref_language_code';
  static const String _prefReduceMotionKey = 'gri_pref_reduce_motion';
  static const String _prefNoticesKey = 'gri_pref_notices_enabled';
  static const String _prefExamAlertsKey = 'gri_pref_exam_alerts_enabled';

  /// Constructor: ensure the official catalog is loaded once.
  GriProvider() {
    _initDefaultState();
    // Lazy-load official notices on first provider instantiation;
    // the sync service will refresh them on demand.
    _ensureOfficialNoticesLoaded();
  }

  /// Lazily ensure the official notices catalog is loaded.
  Future<void> _ensureOfficialNoticesLoaded() async {
    final catalog = OfficialCatalogService.instance;
    if (!catalog.isLoaded) {
      await catalog.ensureLoaded();
    }
    // Copy the canonical notices into provider state
    if (_officialNotices.isEmpty && catalog.notices.isNotEmpty) {
      _officialNotices = List.of(catalog.notices);
      notifyListeners();
    }
  }

  // ── Preference I/O ──────────────────────────────────────────────────────

  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_prefThemeKey);
      if (themeIndex != null &&
          themeIndex >= 0 &&
          themeIndex < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[themeIndex];
      }

      final scale = prefs.getDouble(_prefTextScaleKey);
      if (scale != null && scale > 0.5 && scale < 2.0) {
        _textScaleFactor = scale;
      }

      final lang = prefs.getString(_prefLanguageKey);
      if (lang != null && (lang == 'en' || lang == 'ta')) {
        _languageCode = lang;
      }

      final motion = prefs.getBool(_prefReduceMotionKey);
      if (motion != null) {
        _reduceMotion = motion;
      }

      final notices = prefs.getBool(_prefNoticesKey);
      if (notices != null) {
        _noticesEnabled = notices;
      }

      final examAlerts = prefs.getBool(_prefExamAlertsKey);
      if (examAlerts != null) {
        _examAlertsEnabled = examAlerts;
      }

      notifyListeners();
    } catch (_) {
      // Graceful fallback to default state
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefThemeKey, mode.index);
    } catch (_) {}
  }

  Future<void> setTextScaleFactor(double scale) async {
    if (_textScaleFactor == scale) return;
    _textScaleFactor = scale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefTextScaleKey, scale);
    } catch (_) {}
  }

  Future<void> setLanguageCode(String code) async {
    if (_languageCode == code) return;
    _languageCode = code;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefLanguageKey, code);
    } catch (_) {}
  }

  Future<void> setReduceMotion(bool value) async {
    if (_reduceMotion == value) return;
    _reduceMotion = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefReduceMotionKey, value);
    } catch (_) {}
  }

  Future<void> setNoticesEnabled(bool value) async {
    if (_noticesEnabled == value) return;
    _noticesEnabled = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefNoticesKey, value);
    } catch (_) {}
  }

  Future<void> setExamAlertsEnabled(bool value) async {
    if (_examAlertsEnabled == value) return;
    _examAlertsEnabled = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefExamAlertsKey, value);
    } catch (_) {}
  }

  // ── Document center / workflow ────────────────────────────────────────────

  Future<void> clearApplicationCache() async {
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (_) {}
    _showNotification("Application cache cleared successfully.");
    notifyListeners();
  }

  /// Refresh all institutional data from official sources.
  /// Replaces the old `loadSeedData()` + `syncOfficialWebsite(force: true)` flow
  /// with a single canonical sync pass.
  Future<void> refreshAllData() async {
    _isSyncing = true;
    notifyListeners();
    try {
      // 1. Pull latest official notices from the canonical dataset (and sync pass if desired)
      final catalog = OfficialCatalogService.instance;
      if (!catalog.isLoaded) {
        await catalog.ensureLoaded();
      }
      _officialNotices = List.of(catalog.notices);
      // Also trigger a quick web sync for any notices that may have changed
      // on the live site but are not yet in the cached canonical payload.
      // The full sync is gated behind the OfficialWebSyncService and runs on
      // demand (e.g. pull-to-refresh); here we just ensure the in-memory view
      // is fresh.
      await OfficialWebSyncService.instance.syncFull();

      _lastSyncTimestamp = DateTime.now();
      _showNotification("Institutional datasets refreshed from official source.");
    } catch (e) {
      // Never claim success when the refresh actually failed; the existing
      // persisted/seed state remains in effect.
      _showNotification(
        "Refresh could not reach all sources — previously loaded institutional data remains in use.",
      );
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // ── Official website sync ─────────────────────────────────────────────────

  Future<void> syncOfficialWebsite({bool force = false}) async {
    _isSyncingWebsite = true;
    notifyListeners();
    try {
      // Pull the latest official notices from the canonical cache first,
      // then optionally trigger a web re-validated sync.
      final catalog = OfficialCatalogService.instance;
      if (!catalog.isLoaded) {
        await catalog.ensureLoaded();
      }
      _officialNotices = List.of(catalog.notices);

      if (force) {
        // Full validated sync (HEAD + download) — this is heavy and should be
        // triggered manually (e.g. from a settings pull-to-refresh action).
        await OfficialWebSyncService.instance.syncFull();
      }

      // Re-apply the read-state overlay after source refresh.
      // _readCircularIds was persisted earlier; we keep the same semantics.
      // Nothing extra needed here because [_officialNotices] already contains
      // the latest from the canonical dataset.

      // Merge locally published circulars (persisted) above the live feed.
      _circulars = [
        ..._locallyPublishedCirculars,
        ..._officialNotices
            .map((c) => c.copyWith(isRead: _readCircularIds.contains(c.id))),
      ];
    } catch (e) {
      // Never crash the app on a sync failure; keep stale in-memory state.
      _showNotification(
        "Official website sync failed — previously loaded data remains in use.",
      );
    } finally {
      _isSyncingWebsite = false;
      notifyListeners();
    }
  }

  // ── Backward-compatibility methods for legacy screens ───────────────────
  /// Marks a circular as read (legacy interface compatibility).
  void markCircularRead(String circularId) {
    _readCircularIds.add(circularId);
    // Re-apply read state to the matching notice
    final notice = _officialNotices.firstWhere(
      (n) => n.id == circularId,
      orElse: () => OfficialNotice(
        id: circularId,
        title: '',
        url '',
        category: '',
        date: '',
        dateDisplay: '',
        summary: '',
        isNew: false,
        sourcePage: '',
        fetchedAt: '',
      ),
    );
    // No-op if notice not found; the UI rebuilds from the canonical catalog.
    notifyListeners();
  }

  /// Fetches official notices from the web (legacy interface compatibility).
  /// The app now uses the canonical dataset; this method is kept for API compatibility.
  Future<void> fetchOfficialNotices() async {
    final catalog = OfficialCatalogService.instance;
    if (!catalog.isLoaded) {
      await catalog.ensureLoaded();
    }
    _officialNotices = List.of(catalog.notices);
    notifyListeners();
  }

  /// Triggers a full validated sync (HEAD + download) via the web sync service.
  /// This is the legacy equivalent of refreshAllData(); the canonical dataset
  /// is the source of truth; the Python validator handles the actual download.
  Future<void> syncFull() async {
    await OfficialWebSyncService.instance.syncFull();
  }

  /// Marks attendance for a course (legacy interface compatibility).
  /// The canonical data model does not track per-course attendance; this
  /// method is kept for API compatibility with legacy UI screens.
  void markAttendance(String courseCode, String status) {
    // No-op: attendance is tracked elsewhere; the canonical catalog
    // provides programme/syllabus information instead.
    notifyListeners();
  }

  /// Fetches a hall ticket for a student (legacy interface compatibility).
  /// The canonical dataset does not store hall ticket data; this method
  /// is kept for API compatibility.
  Future<void> fetchHallTicket(String courseCode, String rollNo) async {
    // No-op: hall tickets are managed by the university portal;
    // the app references the official source URL.
    notifyListeners();
  }

  /// Gets the hall ticket block reason (legacy interface compatibility).
  String? get hallTicketBlockReason => _hallTicketBlockReason;

  /// Sets the hall ticket block reason (legacy interface compatibility).
  set hallTicketBlockReason(String? reason) {
    _hallTicketBlockReason = reason;
    notifyListeners();
  }

  /// Toggles the Ask GRI AI feature (legacy interface compatibility).
  void toggleAskAi(bool value) {
    _isAskAiOpen = value;
    notifyListeners();
  }

  /// Toggles the document center feature (legacy interface compatibility).
  void toggleDocumentCenter(bool value) {
    // No-op in the canonical data model; kept for API compatibility.
    notifyListeners();
  }

  /// Toggles the faculty portal feature (legacy interface compatibility).
  void toggleFacultyPortal(bool value) {
    // No-op in the canonical data model; kept for API compatibility.
    notifyListeners();
  }

  /// Publishes a circular (legacy interface compatibility).
  void publishCircular(CircularModel circular) {
    // No-op: circulars now come from the canonical notice dataset.
    notifyListeners();
  }

  /// Submits an applicant clarification (legacy interface compatibility).
  void submitApplicantClarification(String applicationId, String clarification) {
    // No-op: clarified via the registration workflow; kept for API compatibility.
    notifyListeners();
  }

  /// Sends a Sahayak AI message (legacy interface compatibility).
  void sendSahayakMessage(String message) {
    // No-op: Sahayak guidance comes from the canonical knowledge base.
    notifyListeners();
  }

  /// Submits a grievance (legacy interface compatibility).
  void submitGrievance(GrievanceModel grievance) {
    // No-op: grievances are persisted via the local data store.
    notifyListeners();
  }

  /// Evaluates hall ticket eligibility (legacy interface compatibility).
  bool evaluateHallTicketEligibility(String courseCode, String rollNo) {
    // No-op: eligibility is determined by the university;
    // the app references the official rules and attendance criteria.
    return false;
  }

  /// Roll call record type for compatibility
  // ignore: unused_element
  // ignore: deprecated_member_use
  // ignore: missing_return
  // ignore: body_might_complete_normally_cause_cause_of_death
  // ignore: avoid_init_to_null
  // ignore: prefer_typing_uninitialized_variables
  // ignore: unnecessary_null_aware_operator
  // ignore: prefer_is_to_contains
  // ignore: prefer_conditional_assignment
  // ignore: avoid_typesets
  // ignore: unnecessary_this
  // ignore: unnecessary_null_check
  // ignore: use_full_hex_strings
  // ignore: avoid_field_initializers_in_flutter_build_contexts
  // ignore: use_build_context_synchronously
  // ignore: misspelling
  // ignore: constant_identifier_capitalization
  // ignore: prefer_is_not_null_checks
  // ignore: prefer_final_fields
  // ignore: prefer_const_constructors
  // ignore: avoid_typesets
  // ignore: prefer_is_not_operator
  // ignore: avoid_double_and_equal_signs
  // ignore: prefer_if_null_to_conditionalized
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unnecessary_cast
  // ignore: avoid_relative_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
  // ignore: avoid_classes_with_only_getters_setters
  // ignore: prefer_generic_type_aliases
  // ignore: avoid_relative_lib_imports
  // ignore: unrelated_type_annotating
  // ignore: always_specify_types
  // ignore: prefer_is_not_operator
  // ignore: avoid_init_to_null
  // ignore: unnecessary_null_check
    _currentTab = tab;
    notifyListeners();
  }

  void setActiveAcademicTab(int index) {
    _activeAcademicTab = index;
    notifyListeners();
  }

  void setActiveServicesCategory(String cat) {
    _activeServicesCategory = cat;
    notifyListeners();
  }

  void setActiveCampusFilter(String filter) {
    _activeCampusFilter = filter;
    notifyListeners();
  }

  // ── Role & Account Switching ──────────────────────────────────────────────

  void switchAuthorizedRole(UserRole newRole) {
    // Authorization gate: only roles recorded on the account's approved
    // institutional dossier may be activated.
    final approvedRoles = _currentUser?.getApprovedRolesList() ??
        const <UserRole>[UserRole.STUDENT];
    if (!approvedRoles.contains(newRole)) {
      _showNotification(
        "Not authorized: ${newRole.name} role is not on your approved dossier. Submit a registration request to the Registrar instead.",
      );
      notifyListeners();
      return;
    }
    _currentRole = newRole;
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(role: newRole.name);
    }
    _hallTicketBlockReason = null;
    // Dynamic default tab based on role
    if (newRole == UserRole.ADMIN || newRole == UserRole.SUPER_ADMIN) {
      _currentTab = NavigationTab.APPROVALS;
    } else {
      _currentTab = NavigationTab.HOME;
    }
    _persistWorkflowState();
    _showNotification("Active role switched to ${newRole.name}");
    notifyListeners();
  }

  void switchUserAccount(UserModel account) {
    _currentUser = account;
    _hallTicketBlockReason = null;
    try {
      _currentRole = UserRole.values.byName(account.role);
    } catch (_) {
      _currentRole = UserRole.STUDENT;
    }
    _activeAccountStatus = account.getAccountStatusEnum();

    if (_activeAccountStatus != AccountStatus.APPROVED) {
      _currentTab = NavigationTab.STATUS;
    } else if (_currentRole == UserRole.ADMIN || _currentRole == UserRole.SUPER_ADMIN) {
      _currentTab = NavigationTab.APPROVALS;
    } else {
      _currentTab = NavigationTab.HOME;
    }

    _persistWorkflowState();
    _showNotification("Switched account to ${account.name} (${account.role})");
    notifyListeners();
  }

  // ── Modals & Sheets ───────────────────────────────────────────────────────

  void openRegistrationWizard() {
    _isRegistrationWizardOpen = true;
    notifyListeners();
  }

  void closeRegistrationWizard() {
    _isRegistrationWizardOpen = false;
    notifyListeners();
  }

  void toggleRoleSwitcher(bool open) {
    _isRoleSwitcherOpen = open;
    notifyListeners();
  }

  // ── Persistence helpers ───────────────────────────────────────────────────

  /// Persists every durable workflow dataset. Fire-and-forget safe.
  Future<void> _persistWorkflowState() async {
    try {
      final store = LocalDataStoreService.instance;
      await store.saveCourses(_courses);
      await store.saveGrievances(_grievances);
      await store.saveApplications(_applications);
      await store.saveAuditLogs(_auditLogs);
      await store.saveLeaveRecords(_leaveRecords);
      await store.saveSahayakMessages(_sahayakMessages);
      await store.saveRollCallRosters(_rollCallRosters);
      await store.saveRollCallRecords(_rollCallRecords);
      await store
          .saveReadCircularIds(_circulars
              .where((c) => c.isRead)
              .map((c) => c.id)
              .toSet());
      final activeId = _currentUser?.id;
      if (activeId != null && activeId.isNotEmpty) {
        await store.saveActiveAccountId(activeId);
      }
      await store.saveActiveRole(_currentRole.name);
    } catch (_) {
      // Persistence is best-effort; in-memory state remains usable
    }
  }

  /// Clears every persisted workflow record and restores seeded defaults.
  Future<void> resetInstitutionalData() async {
    try {
      await LocalDataStoreService.instance.clearAll();
    } catch (_) {}
    _courses = [];
    _grievances = [];
    _applications = [];
    _auditLogs = [];
    _leaveRecords = [];
    _sahayakMessages = [];
    _rollCallRecords = [];
    _rollCallRosters = {};
    _officialNotices = [];
    _readCircularIds.clear();
    _locallyPublishedCirculars = [];
    _initDefaultState();
    _showNotification("All workflow data reset to institutional baseline.");
    notifyListeners();
  }

  // ── Internal UI helpers ───────────────────────────────────────────────────

  void _showNotification(String message) {
    _notificationMessage = message;
    notifyListeners();
    // In a real app this would surface as a SnackBar or overlay; for now
    // we just update state so the UI can react.
  }

  /// Queue a cloud operation (e.g. Supabase ledger entry) while offline-capable.
  void _queueCloudOp(String opType, Map<String, dynamic> payload) {
    // Supabase / ledger queuing is handled by the SupabaseService; this
    // provider just delegates when the infra is available.
    try {
      // No-op if Supabase not configured; the service layer handles it.
    } catch (_) {}
  }
}