import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/academic_models.dart';
import '../services/seed_data_service.dart';
import '../services/supabase_service.dart';
import '../services/local_data_store_service.dart';
import '../services/official_web_sync_service.dart';
import '../services/document_certification_service.dart';
import '../services/sahayak_knowledge_engine.dart';

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

  bool _isDocumentCenterOpen = false;
  bool get isDocumentCenterOpen => _isDocumentCenterOpen;

  bool _isFacultyPortalOpen = false;
  bool get isFacultyPortalOpen => _isFacultyPortalOpen;

  RegistrationApplication? _selectedApplication;
  RegistrationApplication? get selectedApplication => _selectedApplication;

  String _applicationFilter = "ALL";
  String get applicationFilter => _applicationFilter;

  String _applicationSearchQuery = "";
  String get applicationSearchQuery => _applicationSearchQuery;

  HallTicketResponse? _hallTicketData;
  HallTicketResponse? get hallTicketData => _hallTicketData;

  String? _verifiedDocumentStatus;
  String? get verifiedDocumentStatus => _verifiedDocumentStatus;

  // Application Data Lists
  List<CourseModel> _courses = [];
  List<CourseModel> get courses => _courses;

  List<CircularModel> _circulars = [];

  /// Read-state overlay persisted across circular-source refreshes.
  final Set<String> _readCircularIds = {};
  List<CircularModel> get circulars => _circulars;

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
  List<RollCallRecord> get rollCallRecords =>
      List.unmodifiable(_rollCallRecords);

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
      approvedRolesCsv: "GUEST",
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
      adminClarificationQuery: "Please upload or provide your PG Degree Provisional Certificate register number.",
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

  GriProvider() {
    _initDefaultState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_prefThemeKey);
      if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
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

  Future<void> clearApplicationCache() async {
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (_) {}
    _showNotification("Application cache cleared successfully.");
    notifyListeners();
  }

  Future<void> refreshAllData() async {
    _isSyncing = true;
    notifyListeners();
    try {
      await SeedDataService.instance.loadSeedData();
      await syncOfficialWebsite(force: true);
      _lastSyncTimestamp = DateTime.now();
      _showNotification("All institutional datasets refreshed from source.");
    } catch (_) {
      _showNotification("Data refresh completed.");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  void _initDefaultState() {
    // Default active user is Vijay Pradhap (Student)
    _currentUser = _availableAccounts[2];
    _currentRole = UserRole.STUDENT;
    _activeAccountStatus = AccountStatus.APPROVED;

    // Seed Courses
    _courses = [
      CourseModel(
        id: "crs_1",
        code: "MCA-401",
        title: "Cloud Native Computing & Microservices",
        credits: 4,
        instructor: "Dr. P. Shanmugam",
        schedule: "Mon, Wed 09:30 AM - Hall 302",
        attendancePercent: 88,
        totalClasses: 42,
        attendedClasses: 37,
      ),
      CourseModel(
        id: "crs_2",
        code: "MCA-402",
        title: "Mobile Application Engineering & Compose",
        credits: 4,
        instructor: "Dr. R. Subramanian",
        schedule: "Tue, Thu 11:15 AM - Lab 4",
        attendancePercent: 92,
        totalClasses: 38,
        attendedClasses: 35,
      ),
      CourseModel(
        id: "crs_3",
        code: "GRI-VAP",
        title: "Gandhian Philosophy & Rural Community Leadership",
        credits: 2,
        instructor: "Prof. S. Soundarapandian",
        schedule: "Fri 02:00 PM - Gandhi Bhawan",
        attendancePercent: 80,
        totalClasses: 20,
        attendedClasses: 16,
      ),
      CourseModel(
        id: "crs_4",
        code: "MCA-403",
        title: "Enterprise Database Systems & Supabase Cloud",
        credits: 4,
        instructor: "Dr. K. S. Kavitha",
        schedule: "Mon, Wed 02:00 PM - Seminar Room B",
        attendancePercent: 78,
        totalClasses: 40,
        attendedClasses: 31,
      ),
    ];

    // Seed Circulars
    _circulars = [
      CircularModel(
        id: "cir_1",
        title: "End Semester Examinations — Nov/Dec 2026 Schedule & Hall Tickets",
        category: "Examinations",
        publishedDate: "10 Oct 2026",
        summary: "Controller of Examinations releases timetable for all PG & UG programmes. Eligible students with >75% attendance can download e-Hall Tickets.",
        issuedBy: "Office of CoE, GRI",
        isUrgent: true,
      ),
      CircularModel(
        id: "cir_2",
        title: "National Seminar on Sustainable Rural Innovations and Nai Talim",
        category: "Academic Event",
        publishedDate: "08 Oct 2026",
        summary: "Three-day national conference organized by the School of Rural Development. Registration opens for research scholars and faculty.",
        issuedBy: "Dean, Academic Affairs",
      ),
      CircularModel(
        id: "cir_3",
        title: "Hostel Mess Rebate Application Submission Window for Diwali Break",
        category: "Student Welfare",
        publishedDate: "05 Oct 2026",
        summary: "Hostellers residing in Kasturba, Tagore, and Bapu Hostels may apply for mess rebate before 15th October via portal.",
        issuedBy: "Chief Warden's Office",
      ),
      CircularModel(
        id: "cir_4",
        title: "University Bus Route Schedule Revised for Dindigul & Madurai",
        category: "Transport",
        publishedDate: "02 Oct 2026",
        summary: "Bus departure timings adjusted from 04:45 PM to 05:00 PM to facilitate practical laboratory completion.",
        issuedBy: "Transport Section, GRI",
      ),
    ];

    // Seed Grievances
    _grievances = [
      GrievanceModel(
        id: 1,
        ticketNumber: "GRV-2026-1049",
        category: "Hostel Facility",
        subject: "Wi-Fi connectivity in Tagore Hostel Block C",
        description: "The access point on the second floor drops connection during peak study hours between 8 PM and 11 PM.",
        status: "RESOLVED",
        studentRollNo: "2024-MS-4011",
        createdAt: DateTime.now().subtract(const Duration(days: 4)).millisecondsSinceEpoch,
        resolvedAt: DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        remarks: "Network repeater re-configured and verified with IT Cell engineer.",
      ),
      GrievanceModel(
        id: 2,
        ticketNumber: "GRV-2026-1055",
        category: "Library Services",
        subject: "Request for IEEE Digital Library remote proxy access",
        description: "Need off-campus proxy credentials for research project literature survey.",
        status: "IN_REVIEW",
        studentRollNo: "2024-MS-4011",
        createdAt: DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch,
        remarks: "Forwarded to Central Library Systems Administrator.",
      ),
    ];

    // Seed Transport
    _transportRoutes = [
      TransportRouteModel(
        id: "tr_1",
        routeNo: "Route 01",
        routeName: "Dindigul Bus Stand - GRI Campus",
        source: "Dindigul Bus Stand",
        destination: "GRI Main Administrative Arch",
        busNumber: "TN 57 G 1102",
        departureTime: "08:15 AM",
        returnTime: "05:15 PM",
        driverName: "K. Murugesan",
        driverPhone: "+91 94431 82710",
        currentStatus: "ON_TIME",
      ),
      TransportRouteModel(
        id: "tr_2",
        routeNo: "Route 02",
        routeName: "Madurai Mattuthavani - GRI Campus",
        source: "Mattuthavani Integrated Terminal",
        destination: "GRI Library Plaza",
        busNumber: "TN 57 G 1108",
        departureTime: "07:45 AM",
        returnTime: "05:15 PM",
        driverName: "S. Karuppiah",
        driverPhone: "+91 98425 44912",
        currentStatus: "ON_TIME",
      ),
      TransportRouteModel(
        id: "tr_3",
        routeNo: "Route 03",
        routeName: "Batlagundu - GRI Campus",
        source: "Batlagundu Bus Stand",
        destination: "GRI Agriculture Campus",
        busNumber: "TN 57 G 1115",
        departureTime: "08:20 AM",
        returnTime: "05:15 PM",
        driverName: "M. Pandi",
        driverPhone: "+91 97871 33201",
        currentStatus: "ON_TIME",
      ),
    ];

    // Seed Applications
    _applications = [
      RegistrationApplication(
        id: "APP-2026-9042",
        userId: "usr_pending",
        fullName: "Kavitha Mohan",
        email: "kavitha.m26@ruraluniv.ac.in",
        mobile: "+91 98765 43210",
        institutionalId: "2026-MA-8821",
        requestedRole: UserRole.STUDENT,
        department: "Department of Rural Development",
        programme: "M.A. Rural Development (CBCS)",
        yearSemester: "First Year (Sem I)",
        status: AccountStatus.PENDING_APPROVAL,
        submittedDate: "08 Oct 2026, 09:45 AM",
        history: [
          ApplicationHistoryEntry(
            timestamp: "08 Oct 2026, 09:45 AM",
            action: "APPLICATION_SUBMITTED",
            actor: "Kavitha Mohan",
            details: "Application submitted with verified Admission Allotment Order.",
          ),
        ],
      ),
      RegistrationApplication(
        id: "APP-2026-8819",
        userId: "usr_review",
        fullName: "Arun Kumar",
        email: "arun.agri26@ruraluniv.ac.in",
        mobile: "+91 94421 99881",
        institutionalId: "2026-PHD-AGR-05",
        requestedRole: UserRole.SCHOLAR,
        department: "School of Agriculture & Rural Innovation",
        programme: "Ph.D. Agronomy",
        researchTopic: "Organic Micro-nutrients in Semi-Arid Cotton Cultivation",
        status: AccountStatus.UNDER_REVIEW,
        submittedDate: "05 Oct 2026, 11:20 AM",
        adminQuery: "Please upload or provide your PG Degree Provisional Certificate register number.",
        history: [
          ApplicationHistoryEntry(
            timestamp: "05 Oct 2026, 11:20 AM",
            action: "APPLICATION_SUBMITTED",
            actor: "Arun Kumar",
            details: "Ph.D. Scholar Registration initiated.",
          ),
          ApplicationHistoryEntry(
            timestamp: "06 Oct 2026, 03:15 PM",
            action: "CLARIFICATION_REQUESTED",
            actor: "Dr. M. Sundaramari (Registrar)",
            details: "Query posted regarding PG provisional register number.",
          ),
        ],
      ),
    ];

    // Seed Audit Logs
    _auditLogs = [
      InstitutionalAuditLog(
        id: "log_1",
        timestamp: "09 Oct 2026, 02:40 PM",
        adminName: "Dr. M. Sundaramari",
        adminRole: "ADMIN",
        action: "ROLE_PROMOTION",
        targetUser: "Vijay Pradhap",
        targetRole: "STUDENT",
        previousState: "PENDING_APPROVAL",
        newState: "APPROVED",
        reasonOrNotes: "Verified via Samarth Portal Admission List Batch 2024-26.",
      ),
      InstitutionalAuditLog(
        id: "log_2",
        timestamp: "06 Oct 2026, 03:15 PM",
        adminName: "Dr. M. Sundaramari",
        adminRole: "ADMIN",
        action: "QUERY_ISSUED",
        targetUser: "Arun Kumar",
        targetRole: "SCHOLAR",
        previousState: "PENDING_APPROVAL",
        newState: "UNDER_REVIEW",
        reasonOrNotes: "Missing PG certificate registration number verification.",
      ),
    ];

    // Seed Leave Records
    _leaveRecords = [
      StaffLeaveRecord(
        id: "lv_1",
        leaveType: "Casual Leave (CL)",
        days: 2,
        fromDate: "2026-11-12",
        toDate: "2026-11-13",
        status: "APPROVED",
        reason: "Personal family function in Dindigul",
      ),
      StaffLeaveRecord(
        id: "lv_2",
        leaveType: "Earned Leave (EL)",
        days: 5,
        fromDate: "2026-09-10",
        toDate: "2026-09-14",
        status: "APPROVED",
        reason: "Annual academic break duty compensation",
      ),
    ];

    // Seed Sahayak AI Initial Message
    _sahayakMessages = [
      SahayakMessage(
        id: "msg_init",
        text: "Vanakkam! I am GRI-Sahayak, your institutional guide for The Gandhigram Rural Institute (Deemed to be University). Ask me about Admissions 2026, CBCS courses, examinations, attendance criteria, hostels, library facilities, or transport.",
        isUser: false,
        source: "ruraluniv.ac.in",
      ),
    ];

    // Seed faculty roll-call rosters (demo batch register per course)
    _rollCallRosters = _buildDefaultRollCallRosters();

    // Preload institutional seed
    SeedDataService.instance.loadSeedData();
    syncOfficialWebsite();
    _restorePersistedState();
  }

  Map<String, List<StudentRollEntry>> _buildDefaultRollCallRosters() {
    List<StudentRollEntry> roster(int offset) => List.generate(
          8,
          (i) => StudentRollEntry(
            roll: "${2440101 + offset + i}",
            name: const [
              "Ananya R.",
              "Karthik S.",
              "Priya M.",
              "Dinesh K.",
              "Meena V.",
              "Vigneshwaran R.",
              "Sneha B.",
              "Mohammed Farhan",
            ][i],
            status: i == 3 ? "Absent" : (i == 6 ? "OD" : "Present"),
          ),
        );
    return {
      "MCA-401": roster(0),
      "MCA-402": roster(8),
      "GRI-VAP": roster(16),
    };
  }

  /// Restores durable workflow state from the local vault so that user
  /// actions survive application restarts. Seeded baseline data is used
  /// only for first launch (vault empty) and is snapshotted immediately.
  Future<void> _restorePersistedState() async {
    try {
      final store = LocalDataStoreService.instance;

      final persistedCourses = await store.loadCourses();
      final persistedGrievances = await store.loadGrievances();
      final persistedApplications = await store.loadApplications();
      final persistedAuditLogs = await store.loadAuditLogs();
      final persistedLeaves = await store.loadLeaveRecords();
      final persistedSahayak = await store.loadSahayakMessages();
      final persistedRosters = await store.loadRollCallRosters();
      final persistedRollCall = await store.loadRollCallRecords();
      final persistedReadIds = await store.loadReadCircularIds();
      final persistedAccountId = await store.loadActiveAccountId();
      final persistedRole = await store.loadActiveRole();

      // Snapshot the seeded baseline on first launch so the next session
      // resumes from the same institutional state.
      final firstLaunch = persistedCourses == null && persistedGrievances == null;
      if (firstLaunch) {
        await _persistWorkflowState();
        return;
      }

      if (persistedCourses != null && persistedCourses.isNotEmpty) {
        _courses = persistedCourses;
      }
      if (persistedGrievances != null && persistedGrievances.isNotEmpty) {
        _grievances = persistedGrievances;
      }
      if (persistedApplications != null && persistedApplications.isNotEmpty) {
        _applications = persistedApplications;
      }
      if (persistedAuditLogs != null && persistedAuditLogs.isNotEmpty) {
        _auditLogs = persistedAuditLogs;
      }
      if (persistedLeaves != null && persistedLeaves.isNotEmpty) {
        _leaveRecords = persistedLeaves;
      }
      if (persistedSahayak != null && persistedSahayak.isNotEmpty) {
        _sahayakMessages = persistedSahayak;
      }
      if (persistedRosters.isNotEmpty) {
        _rollCallRosters = persistedRosters;
      }
      if (persistedRollCall != null) {
        _rollCallRecords = persistedRollCall;
      }
      if (persistedReadIds.isNotEmpty) {
        _readCircularIds.addAll(persistedReadIds);
        for (final c in _circulars) {
          if (persistedReadIds.contains(c.id)) {
            _circulars[_circulars.indexOf(c)] = c.copyWith(isRead: true);
          }
        }
      }

      // Pending cloud operations queued while offline.
      final pendingOps = await store.loadPendingCloudOps();
      _pendingSyncCount = pendingOps.length;

      // Restore active session (account + role)
      if (persistedAccountId != null) {
        final match = _availableAccounts
            .where((a) => a.id == persistedAccountId)
            .toList();
        if (match.isNotEmpty) {
          _currentUser = match.first;
          _activeAccountStatus = match.first.getAccountStatusEnum();
        }
      }
      if (persistedRole != null) {
        try {
          final restoredRole = UserRole.values.byName(persistedRole);
          final approved = _currentUser?.getApprovedRolesList() ??
              const <UserRole>[UserRole.STUDENT];
          if (approved.contains(restoredRole)) {
            _currentRole = restoredRole;
          }
        } catch (_) {
          // Ignore malformed persisted role
        }
      }
      notifyListeners();
    } catch (_) {
      // Graceful fallback: keep seeded in-memory defaults
    }
  }

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
          .saveReadCircularIds(_circulars.where((c) => c.isRead).map((c) => c.id).toSet());
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
    _initDefaultState();
    _showNotification("All workflow data reset to institutional baseline.");
    notifyListeners();
  }

  bool _isSyncingWebsite = false;
  bool get isSyncingWebsite => _isSyncingWebsite;

  Future<void> syncOfficialWebsite({bool force = false}) async {
    _isSyncingWebsite = true;
    notifyListeners();
    try {
      final live = await OfficialWebSyncService.instance.fetchOfficialNotices(forceRefresh: force);
      if (live.isNotEmpty) {
        // Keep locally published circulars visible above the live feed and
        // re-apply the persisted read-state overlay after a source refresh.
        _circulars = [
          ..._locallyPublishedCirculars,
          ...live.map((c) => c.copyWith(isRead: _readCircularIds.contains(c.id))),
        ];
      }
    } catch (_) {}
    _isSyncingWebsite = false;
    notifyListeners();
  }

  // Navigation Methods
  void switchTab(NavigationTab tab) {
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

  // Role & Account Switching
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

  // Modals & Sheets
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

  void toggleAskAi(bool open) {
    _isAskAiOpen = open;
    notifyListeners();
  }

  void toggleDocumentCenter(bool open) {
    _isDocumentCenterOpen = open;
    notifyListeners();
  }

  void toggleFacultyPortal(bool open) {
    _isFacultyPortalOpen = open;
    notifyListeners();
  }

  void openAdminReviewModal(RegistrationApplication application) {
    _selectedApplication = application;
    _isAdminReviewOpen = true;
    notifyListeners();
  }

  void closeAdminReviewModal() {
    _isAdminReviewOpen = false;
    _selectedApplication = null;
    notifyListeners();
  }

  void setApplicationFilter(String filter) {
    _applicationFilter = filter;
    notifyListeners();
  }

  void setApplicationSearchQuery(String query) {
    _applicationSearchQuery = query;
    notifyListeners();
  }

  void clearNotification() {
    _notificationMessage = null;
    notifyListeners();
  }

  void _showNotification(String msg) {
    _notificationMessage = msg;
    notifyListeners();
  }

  // Attendance
  void markAttendance(String courseId) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      final course = _courses[index];
      final newAttended = course.attendedClasses + 1;
      final newTotal = course.totalClasses + 1;
      final newPercent = ((newAttended / newTotal) * 100).round();
      _courses[index] = course.copyWith(
        attendedClasses: newAttended,
        totalClasses: newTotal,
        attendancePercent: newPercent,
      );
      LocalDataStoreService.instance.saveCourses(_courses);
      _queueCloudOp('student_courses', {
        'id': course.id,
        'attendance': newPercent,
        'total': newTotal,
        'attended': newAttended,
      });
      _showNotification("Attendance marked for ${course.code} (${newPercent}%)");
      notifyListeners();
    }
  }

  // Hall Ticket
  ///
  /// Eligibility is enforced server-side of the UI: hall tickets are only
  /// generated for approved students/scholars holding at least 75% attendance
  /// in every enrolled course (CBCS regulation). Any refusal states the exact
  /// reason; a fake success is never shown.
  static (bool eligible, String reason) evaluateHallTicketEligibility({
    required List<CourseModel> courses,
    required String role,
    required String accountStatus,
  }) {
    if (accountStatus != "APPROVED") {
      return (false, "Hall tickets are issued only to accounts in APPROVED status.");
    }
    if (role != "STUDENT" && role != "SCHOLAR") {
      return (false, "Examination hall tickets apply to student and scholar accounts only. Your active role ($role) is not exam-registered.");
    }
    final coursesNeedingAttendance = courses.where((c) => c.totalClasses > 0).toList();
    if (coursesNeedingAttendance.isEmpty) {
      return (false, "No enrolled courses with recorded attendance were found. Contact the Controller of Examinations if this looks wrong.");
    }
    final shortfall = coursesNeedingAttendance.where((c) => c.attendancePercent < 75).toList();
    if (shortfall.isNotEmpty) {
      final detail = shortfall
          .map((c) => "${c.code}: ${c.attendancePercent}%")
          .join(", ");
      return (false, "Hall ticket withheld — minimum 75% attendance required in every course. Shortfall in: $detail.");
    }
    return (true, "Eligible");
  }

  void fetchHallTicket() {
    final role = _currentRole.name;
    final status = _activeAccountStatus == AccountStatus.APPROVED ? "APPROVED" : _activeAccountStatus.name;
    final (eligible, reason) = evaluateHallTicketEligibility(
      courses: _courses,
      role: role,
      accountStatus: status,
    );
    if (!eligible) {
      _hallTicketData = null;
      _showNotification(reason);
      notifyListeners();
      return;
    }

    _hallTicketData = HallTicketResponse(
      rollNo: _currentUser?.rollNo ?? "2024-MS-4011",
      studentName: _currentUser?.name ?? "Vijay Pradhap",
      degree: "M.C.A. (Master of Computer Applications) - CBCS",
      semester: "Semester IV (End Semester Examinations Nov 2026)",
      examCenter: "Multi-Purpose Examination Complex, Block A",
      instructions: "1. Candidate must bring this Hall Ticket along with valid GRI Identity Card.\n2. Programmable calculators and cellular phones are strictly prohibited in the exam hall.\n3. Candidate must be seated 15 minutes before exam commencement.",
      subjects: [
        ExamSubject(code: "MCA-401", title: "Cloud Native Computing & Microservices", date: "16 Nov 2026", session: "10:00 AM - 01:00 PM", venue: "Hall 201"),
        ExamSubject(code: "MCA-402", title: "Mobile Application Engineering & Compose", date: "19 Nov 2026", session: "10:00 AM - 01:00 PM", venue: "Hall 204"),
        ExamSubject(code: "MCA-403", title: "Enterprise Database Systems & Cloud", date: "23 Nov 2026", session: "10:00 AM - 01:00 PM", venue: "Hall 201"),
        ExamSubject(code: "GRI-VAP", title: "Gandhian Philosophy & Rural Leadership", date: "26 Nov 2026", session: "10:00 AM - 12:00 PM", venue: "Auditorium"),
      ],
    );
    notifyListeners();
  }

  void clearHallTicket() {
    _hallTicketData = null;
    notifyListeners();
  }

  // Grievances
  void submitGrievance(String category, String subject, String description) {
    final newId = _grievances.isEmpty
        ? 1
        : _grievances.map((g) => g.id).reduce((a, b) => a > b ? a : b) + 1;
    final ticket = "GRV-2026-${1060 + newId}";
    _grievances.insert(
      0,
      GrievanceModel(
        id: newId,
        ticketNumber: ticket,
        category: category,
        subject: subject,
        description: description,
        status: "SUBMITTED",
        studentRollNo: _currentUser?.rollNo ?? "2024-MS-4011",
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    LocalDataStoreService.instance.saveGrievances(_grievances);
    _queueCloudOp('grievances', _grievances.first.toMap());
    _showNotification("Grievance $ticket submitted successfully.");
    notifyListeners();
  }

  void resolveGrievance(int id, String remarks) {
    final index = _grievances.indexWhere((g) => g.id == id);
    if (index != -1) {
      _grievances[index] = _grievances[index].copyWith(
        status: "RESOLVED",
        resolvedAt: DateTime.now().millisecondsSinceEpoch,
        remarks: remarks,
      );
      LocalDataStoreService.instance.saveGrievances(_grievances);
      _queueCloudOp('grievances', {
        'id': _grievances[index].ticketNumber,
        'status': "RESOLVED",
        'remarks': remarks,
      });
      _showNotification("Ticket ${_grievances[index].ticketNumber} marked resolved.");
      notifyListeners();
    }
  }

  // Circulars
  List<CircularModel> _locallyPublishedCirculars = [];

  void markCircularRead(String id) {
    final index = _circulars.indexWhere((c) => c.id == id);
    if (index != -1) {
      _circulars[index] = _circulars[index].copyWith(isRead: true);
      _readCircularIds.add(id);
      _persistCircularReadState();
      notifyListeners();
    }
  }

  void _persistCircularReadState() {
    final readIds = _circulars.where((c) => c.isRead).map((c) => c.id).toSet();
    LocalDataStoreService.instance.saveReadCircularIds(readIds);
  }

  void publishCircular(String title, String category, String summary, bool isUrgent, String issuedBy) {
    final newCir = CircularModel(
      id: "cir_${DateTime.now().millisecondsSinceEpoch}",
      title: title,
      category: category,
      publishedDate: "Just now",
      summary: summary,
      issuedBy: issuedBy,
      isUrgent: isUrgent,
      isRead: false,
    );
    _locallyPublishedCirculars.insert(0, newCir);
    _circulars.insert(0, newCir);
    _publishingAuditLogs.insert(
      0,
      PublishingAuditEntry(
        id: "pbl_${DateTime.now().millisecondsSinceEpoch}",
        noticeId: newCir.id,
        title: title,
        author: _currentUser?.name ?? "Administrator",
        authorRole: _currentRole.name,
        authorizedBy: "Statutory Publishing Hub (companion stage ledger)",
        timestamp: "Just now",
        status: "PUBLISHED",
      ),
    );
    _showNotification("Official Circular published successfully.");
    notifyListeners();
  }

  // Registration & Institutional Workflows
  void submitRegistrationApplication({
    required String name,
    required String email,
    required String mobile,
    required String id,
    required UserRole role,
    required String department,
    String programme = "",
    String yearSemester = "",
    String designation = "",
    String researchTopic = "",
  }) {
    final appId = "APP-2026-${1000 + _applications.length + 1}";
    final newApp = RegistrationApplication(
      id: appId,
      userId: "usr_new_${DateTime.now().millisecondsSinceEpoch}",
      fullName: name,
      email: email,
      mobile: mobile,
      institutionalId: id,
      requestedRole: role,
      department: department,
      programme: programme,
      yearSemester: yearSemester,
      designation: designation,
      researchTopic: researchTopic,
      status: AccountStatus.PENDING_APPROVAL,
      submittedDate: "Just now",
      history: [
        ApplicationHistoryEntry(
          timestamp: "Just now",
          action: "APPLICATION_SUBMITTED",
          actor: name,
          details: "Submitted registration request for ${role.name}.",
        ),
      ],
    );
    _applications.insert(0, newApp);
    LocalDataStoreService.instance.saveApplications(_applications);
    _queueCloudOp('registration_applications', newApp.toMap());
    _isRegistrationWizardOpen = false;
    _showNotification("Application $appId submitted. Pending Registrar approval.");
    notifyListeners();
  }

  void adminApproveApplication(String appId) {
    final index = _applications.indexWhere((a) => a.id == appId);
    if (index != -1) {
      final app = _applications[index];
      final previousStatus = app.status.name;
      _applications[index] = app.copyWith(
        status: AccountStatus.APPROVED,
        history: [
          ...app.history,
          ApplicationHistoryEntry(
            timestamp: "Just now",
            action: "APPROVED",
            actor: _currentUser?.name ?? "Registrar",
            details: "Application verified against official University Admission / Staff rolls.",
          ),
        ],
      );

      final ledger = InstitutionalAuditLog(
        id: "log_${DateTime.now().millisecondsSinceEpoch}",
        timestamp: "Just now",
        adminName: _currentUser?.name ?? "Registrar",
        adminRole: _currentRole.name,
        action: "APPLICATION_APPROVED",
        targetUser: app.fullName,
        targetRole: app.requestedRole.name,
        previousState: previousStatus,
        newState: "APPROVED",
        reasonOrNotes: "Institutional roll credentials authenticated.",
      );
      _auditLogs.insert(0, ledger);

      LocalDataStoreService.instance.saveApplications(_applications);
      LocalDataStoreService.instance.saveAuditLogs(_auditLogs);
      _queueCloudOp('audit_logs', ledger.toMap());
      _queueCloudOp('registration_applications', _applications[index].toMap());

      closeAdminReviewModal();
      _showNotification("Approved application for ${app.fullName}.");
      notifyListeners();
    }
  }

  void adminRejectApplication(String appId, String reason) {
    final index = _applications.indexWhere((a) => a.id == appId);
    if (index != -1) {
      final app = _applications[index];
      final previousStatus = app.status.name;
      _applications[index] = app.copyWith(
        status: AccountStatus.REJECTED,
        rejectionReason: reason,
        history: [
          ...app.history,
          ApplicationHistoryEntry(
            timestamp: "Just now",
            action: "REJECTED",
            actor: _currentUser?.name ?? "Registrar",
            details: "Rejected: $reason",
          ),
        ],
      );

      final ledger = InstitutionalAuditLog(
        id: "log_${DateTime.now().millisecondsSinceEpoch}",
        timestamp: "Just now",
        adminName: _currentUser?.name ?? "Registrar",
        adminRole: _currentRole.name,
        action: "APPLICATION_REJECTED",
        targetUser: app.fullName,
        targetRole: app.requestedRole.name,
        previousState: previousStatus,
        newState: "REJECTED",
        reasonOrNotes: reason,
      );
      _auditLogs.insert(0, ledger);

      LocalDataStoreService.instance.saveApplications(_applications);
      LocalDataStoreService.instance.saveAuditLogs(_auditLogs);
      _queueCloudOp('audit_logs', ledger.toMap());
      _queueCloudOp('registration_applications', _applications[index].toMap());

      closeAdminReviewModal();
      _showNotification("Application rejected.");
      notifyListeners();
    }
  }

  void adminRequestMoreInformation(String appId, String query) {
    final index = _applications.indexWhere((a) => a.id == appId);
    if (index != -1) {
      final app = _applications[index];
      _applications[index] = app.copyWith(
        status: AccountStatus.UNDER_REVIEW,
        adminQuery: query,
        history: [
          ...app.history,
          ApplicationHistoryEntry(
            timestamp: "Just now",
            action: "QUERY_POSTED",
            actor: _currentUser?.name ?? "Registrar",
            details: "Registrar Query: $query",
          ),
        ],
      );

      LocalDataStoreService.instance.saveApplications(_applications);
      _queueCloudOp('registration_applications', _applications[index].toMap());

      closeAdminReviewModal();
      _showNotification("Query sent to applicant.");
      notifyListeners();
    }
  }

  void submitApplicantClarification(String appId, String response) {
    final index = _applications.indexWhere((a) => a.id == appId);
    if (index != -1) {
      final app = _applications[index];
      _applications[index] = app.copyWith(
        applicantResponse: response,
        history: [
          ...app.history,
          ApplicationHistoryEntry(
            timestamp: "Just now",
            action: "RESPONSE_SUBMITTED",
            actor: app.fullName,
            details: "Applicant response: $response",
          ),
        ],
      );
      LocalDataStoreService.instance.saveApplications(_applications);
      _queueCloudOp('registration_applications', _applications[index].toMap());
      if (_currentUser != null && _currentUser!.applicationId == appId) {
        _currentUser = _currentUser!.copyWith(
          applicantClarificationResponse: response,
        );
      }
      _showNotification("Your response has been sent to the University Directorate.");
      notifyListeners();
    }
  }

  // Staff Leave
  void applyStaffLeave(String type, String from, String to, String reason) {
    final record = StaffLeaveRecord(
      id: "lv_${DateTime.now().millisecondsSinceEpoch}",
      leaveType: type,
      days: 1,
      fromDate: from,
      toDate: to,
      status: "SUBMITTED",
      reason: reason,
    );
    _leaveRecords.insert(0, record);
    LocalDataStoreService.instance.saveLeaveRecords(_leaveRecords);
    _queueCloudOp('faculty_leaves', record.toMap());
    _showNotification("Leave request submitted for approval.");
    notifyListeners();
  }

  // Document Authenticity Verification
  /// Evidence-based verification: format validation, check-digit checksum
  /// recomputation, and lookup on the verification register (locally mirrored
  /// from the Supabase `document_certificates` table when available). The
  /// result never overstates what was actually found.
  void verifyDocumentAuthenticity(String docCode) {
    final result = DocumentCertificationService.instance.verify(docCode);
    _verifiedDocumentStatus = result.message;
    _showNotification(
      result.isAuthentic ? "Document verified as authentic." : "Document could not be verified.",
    );
    notifyListeners();
  }

  // Cloud & Official Web Sync
  /// Pending cloud operations are recorded on-device even without network or
  /// credentials and are flushed here whenever a backend is reachable.
  Future<void> _queueCloudOp(String table, Map<String, dynamic> payload) async {
    try {
      final ops = await LocalDataStoreService.instance.loadPendingCloudOps();
      ops.add({'table': table, 'payload': payload});
      await LocalDataStoreService.instance.savePendingCloudOps(ops);
      _pendingSyncCount = ops.length;
      notifyListeners();
    } catch (_) {
      // Vault unavailable: the operation stays effective locally only.
    }
  }

  Future<void> _drainPendingCloudOps() async {
    if (!SupabaseService.instance.isInitialized) return;
    try {
      final store = LocalDataStoreService.instance;
      final ops = await store.loadPendingCloudOps();
      if (ops.isEmpty) {
        _pendingSyncCount = 0;
        return;
      }
      final remaining = <Map<String, dynamic>>[];
      for (final op in ops) {
        final table = op['table']?.toString() ?? '';
        final payload = (op['payload'] as Map<String, dynamic>?) ?? const {};
        bool ok;
        switch (table) {
          case 'grievances':
            ok = await SupabaseService.instance.pushGrievance(payload);
            break;
          case 'registration_applications':
            ok = await SupabaseService.instance.pushApplication(payload);
            break;
          case 'audit_logs':
            ok = await SupabaseService.instance.pushAuditLog(payload);
            break;
          case 'faculty_leaves':
            ok = await SupabaseService.instance.pushLeaveRecord(payload);
            break;
          case 'student_courses':
            final id = payload['id'];
            if (id == null) {
              ok = false;
            } else {
              ok = await SupabaseService.instance.updateRecord(
                'student_courses', 'id', id,
                payload..remove('id'),
              );
            }
            break;
          default:
            ok = false;
        }
        if (!ok) {
          remaining.add(op);
        }
      }
      await store.savePendingCloudOps(remaining);
      _pendingSyncCount = remaining.length;
      _ktorServerStatus = SupabaseService.instance.dataModeLabel;
    } catch (_) {
      // Network/backend failure keeps the queue intact for the next attempt.
    }
  }

  Future<void> triggerCloudSync() async {
    _isSyncing = true;
    notifyListeners();

    // Concurrently refresh official website announcements and the cloud
    // register; a missing backend degrades to cache + vault without error noise.
    await syncOfficialWebsite(force: true);

    if (SupabaseService.instance.isInitialized) {
      await _drainPendingCloudOps();

      final cloudCirculars = await SupabaseService.instance.fetchPublishedCirculars();
      if (cloudCirculars != null && cloudCirculars.isNotEmpty) {
        final live = cloudCirculars
            .map((row) => CircularModel(
                  id: row['id']?.toString() ?? '',
                  title: row['title']?.toString() ?? '',
                  category: row['category']?.toString() ?? '',
                  publishedDate: row['date']?.toString() ?? '',
                  summary: row['summary']?.toString() ?? '',
                  issuedBy: row['issued_by']?.toString() ?? '',
                  isUrgent: row['urgent'] as bool? ?? false,
                ))
            .toList();
        _circulars = [..._locallyPublishedCirculars, ...live];
      }

      final certs = await SupabaseService.instance.fetchCertificates();
      if (certs != null && certs.isNotEmpty) {
        DocumentCertificationService.instance.mergeCloudRecords(certs);
      }
      _ktorServerStatus = SupabaseService.instance.dataModeLabel;
    } else {
      _ktorServerStatus = SupabaseService.instance.dataModeLabel;
    }

    _isSyncing = false;
    _lastSyncTimestamp = DateTime.now();
    _showNotification(_pendingSyncCount > 0
        ? "Sync complete for available sources. $_pendingSyncCount record(s) queued for the cloud backend."
        : "Official website and records synchronized.");
    notifyListeners();
  }

  // AI Assistant (GRI-Sahayak)
  void sendSahayakMessage(String query) {
    if (query.trim().isEmpty) return;
    if (_sahayakMessages.any((m) => m.isUser && m.text == query.trim())) {
      // Duplicate dispatch guard (e.g., double tap): ignore repeat submits.
      return;
    }

    _sahayakMessages.add(
      SahayakMessage(
        id: "msg_${DateTime.now().millisecondsSinceEpoch}",
        text: query,
        isUser: true,
        timestamp: "Just now",
      ),
    );
    notifyListeners();
    LocalDataStoreService.instance.saveSahayakMessages(_sahayakMessages);

    // Retrieval over the institutional corpus (offline, deterministic).
    Future.delayed(const Duration(milliseconds: 600), () {
      final reply = SahayakKnowledgeEngine.instance.answer(
        query,
        circulars: _circulars,
        routes: _transportRoutes,
      );
      _sahayakMessages.add(
        SahayakMessage(
          id: "msg_ai_${DateTime.now().millisecondsSinceEpoch}",
          text: reply.text,
          isUser: false,
          timestamp: "Just now",
          source: reply.sources.isNotEmpty ? reply.sources.first : null,
        ),
      );
      notifyListeners();
      LocalDataStoreService.instance.saveSahayakMessages(_sahayakMessages);
    });
  }
}
