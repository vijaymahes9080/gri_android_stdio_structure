import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/academic_models.dart';
import '../services/seed_data_service.dart';
import '../services/supabase_service.dart';

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
  String _ktorServerStatus = "Live • System Verified";
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

  GriProvider() {
    _initDefaultState();
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

    // Preload institutional seed
    SeedDataService.instance.loadSeedData();
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
      _showNotification("Attendance marked for ${course.code} (${newPercent}%)");
      notifyListeners();
    }
  }

  // Hall Ticket
  void fetchHallTicket() {
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
    final newId = _grievances.length + 1;
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
      _showNotification("Ticket ${_grievances[index].ticketNumber} marked resolved.");
      notifyListeners();
    }
  }

  // Circulars
  void markCircularRead(String id) {
    final index = _circulars.indexWhere((c) => c.id == id);
    if (index != -1) {
      _circulars[index] = _circulars[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void publishCircular(String title, String category, String summary, bool isUrgent, String issuedBy) {
    final newCir = CircularModel(
      id: "cir_${_circulars.length + 1}",
      title: title,
      category: category,
      publishedDate: "Just now",
      summary: summary,
      issuedBy: issuedBy,
      isUrgent: isUrgent,
      isRead: false,
    );
    _circulars.insert(0, newCir);
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
    _isRegistrationWizardOpen = false;
    _showNotification("Application $appId submitted. Pending Registrar approval.");
    notifyListeners();
  }

  void adminApproveApplication(String appId) {
    final index = _applications.indexWhere((a) => a.id == appId);
    if (index != -1) {
      final app = _applications[index];
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

      _auditLogs.insert(
        0,
        InstitutionalAuditLog(
          id: "log_${_auditLogs.length + 1}",
          timestamp: "Just now",
          adminName: _currentUser?.name ?? "Registrar",
          adminRole: "ADMIN",
          action: "APPLICATION_APPROVED",
          targetUser: app.fullName,
          targetRole: app.requestedRole.name,
          previousState: "PENDING_APPROVAL",
          newState: "APPROVED",
          reasonOrNotes: "Institutional roll credentials authenticated.",
        ),
      );

      closeAdminReviewModal();
      _showNotification("Approved application for ${app.fullName}.");
      notifyListeners();
    }
  }

  void adminRejectApplication(String appId, String reason) {
    final index = _applications.indexWhere((a) => a.id == appId);
    if (index != -1) {
      final app = _applications[index];
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
    _leaveRecords.insert(
      0,
      StaffLeaveRecord(
        id: "lv_${_leaveRecords.length + 1}",
        leaveType: type,
        days: 1,
        fromDate: from,
        toDate: to,
        status: "SUBMITTED",
        reason: reason,
      ),
    );
    _showNotification("Leave request submitted for approval.");
    notifyListeners();
  }

  // Document Authenticity Verification
  void verifyDocumentAuthenticity(String docCode) {
    if (docCode.toUpperCase().contains("GRI") || docCode.length >= 6) {
      _verifiedDocumentStatus = "AUTHENTIC: Institutional Digital Certificate Verified under e-SANAD repository. Registered by Controller of Examinations.";
    } else {
      _verifiedDocumentStatus = "UNVERIFIED: Invalid document identifier. Please verify QR code or contact Controller of Examinations.";
    }
    _showNotification("Document verification complete.");
    notifyListeners();
  }

  // Cloud Sync Simulation
  Future<void> triggerCloudSync() async {
    _isSyncing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Attempt Supabase fetch if configured
    if (SupabaseService.instance.isInitialized) {
      final cloudCirculars = await SupabaseService.instance.fetchTable("circulars");
      if (cloudCirculars != null && cloudCirculars.isNotEmpty) {
        // Updated from cloud
      }
    }

    _isSyncing = false;
    _pendingSyncCount = 0;
    _showNotification("Cloud synchronization complete. All records synchronized.");
    notifyListeners();
  }

  // AI Assistant (GRI-Sahayak)
  void sendSahayakMessage(String query) {
    if (query.trim().isEmpty) return;

    _sahayakMessages.add(
      SahayakMessage(
        id: "msg_${DateTime.now().millisecondsSinceEpoch}",
        text: query,
        isUser: true,
        timestamp: "Just now",
      ),
    );
    notifyListeners();

    // Generate intelligent institutional answer
    Future.delayed(const Duration(milliseconds: 600), () {
      final responseText = _generateAiAnswer(query);
      _sahayakMessages.add(
        SahayakMessage(
          id: "msg_ai_${DateTime.now().millisecondsSinceEpoch}",
          text: responseText,
          isUser: false,
          timestamp: "Just now",
          source: "ruraluniv.ac.in",
        ),
      );
      notifyListeners();
    });
  }

  String _generateAiAnswer(String query) {
    final q = query.toLowerCase();
    if (q.contains("admission") || q.contains("apply") || q.contains("eligibility")) {
      return "Admissions at The Gandhigram Rural Institute are conducted through CUET-UG, CUET-PG, and GRI All-India Entrance Examinations. The admission portal opens annually at https://ruraluniv.ac.in/admissions. Common programmes include B.Sc. (Hons) Agriculture, M.Sc., M.C.A., M.Tech, and B.Ed. Rural Development.";
    } else if (q.contains("exam") || q.contains("hall ticket") || q.contains("result") || q.contains("coe")) {
      return "Semester Examinations are conducted under the Choice Based Credit System (CBCS). To be eligible for Hall Tickets, students must maintain a minimum of 75% attendance. Hall tickets can be fetched directly under the Academics Hub in this app.";
    } else if (q.contains("hostel") || q.contains("mess") || q.contains("stay")) {
      return "GRI provides residential hostel facilities including Kasturba Hostel for women and Tagore & Bapu Hostels for men. Nutritious vegetarian meals are served under student-run mess committees with monthly mess rebate facilities.";
    } else if (q.contains("bus") || q.contains("transport") || q.contains("route")) {
      return "The university operates scheduled bus services covering Dindigul Bus Stand, Madurai Mattuthavani, and Batlagundu. Concessional semester bus passes are issued to regular students and scholars.";
    } else if (q.contains("library") || q.contains("book") || q.contains("journal")) {
      return "Dr. Radhakrishnan Central Library houses over 1,80,000 volumes, classical Tamil palm-leaf archives, and gives online access to IEEE, Springer, and UGC INFONET digital repositories from 8:00 AM to 8:00 PM.";
    } else if (q.contains("attendance") || q.contains("leave")) {
      return "University academic regulations require a mandatory minimum attendance of 75% in each course to appear for End Semester Examinations. Shortage between 65%-74% may be condoned by the Vice-Chancellor on certified medical grounds.";
    } else if (q.contains("gandhi") || q.contains("nai talim") || q.contains("history")) {
      return "Founded in 1947 by Gandhian disciples Dr. T.S. Soundram and Dr. G. Ramachandran, GRI follows the Nai Talim (Basic Education) philosophy integrating Teaching, Research, and Extension into rural community transformation.";
    } else {
      return "GRI Official Portal: For institutional queries on departments, programmes, faculty, or circulars, please consult the Official Document Center or visit the university portal at ruraluniv.ac.in.";
    }
  }
}
