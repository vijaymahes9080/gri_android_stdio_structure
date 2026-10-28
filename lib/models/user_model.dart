enum UserRole {
  STUDENT,
  FACULTY,
  COE_STAFF,
  SCHOLAR,
  ADMIN,
  SUPER_ADMIN,
  STAFF,
  GUEST,
  ALUMNI,
  PUBLIC,
}

enum AccountStatus {
  PENDING_APPROVAL,
  UNDER_REVIEW,
  APPROVED,
  REJECTED,
  SUSPENDED,
  DISABLED,
}

enum InstitutionalPermission {
  VIEW_PROFILE,
  VIEW_DOCUMENTS,
  VIEW_NOTIFICATIONS,
  VIEW_ACADEMIC_DATA,
  VIEW_EXAM_DATA,
  SUBMIT_ATTENDANCE,
  MANAGE_STUDENTS,
  MANAGE_COURSES,
  MANAGE_EXAMS,
  PUBLISH_RESULTS,
  GENERATE_HALL_TICKETS,
  MANAGE_CONTENT,
  MANAGE_NOTIFICATIONS,
  APPROVE_USERS,
  MANAGE_ROLES,
  VIEW_AUDIT_LOGS,
  VIEW_ANALYTICS,
  MANAGE_SYSTEM_SETTINGS,
  SUBMIT_RESEARCH,
  VIEW_CAMPUS_PUBLIC,
}

class RolePermissions {
  static Set<InstitutionalPermission> getPermissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.PUBLIC:
        return {
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
          InstitutionalPermission.VIEW_DOCUMENTS,
        };
      case UserRole.GUEST:
        return {
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_PROFILE,
        };
      case UserRole.STUDENT:
        return {
          InstitutionalPermission.VIEW_PROFILE,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_NOTIFICATIONS,
          InstitutionalPermission.VIEW_ACADEMIC_DATA,
          InstitutionalPermission.VIEW_EXAM_DATA,
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
        };
      case UserRole.FACULTY:
        return {
          InstitutionalPermission.VIEW_PROFILE,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_NOTIFICATIONS,
          InstitutionalPermission.VIEW_ACADEMIC_DATA,
          InstitutionalPermission.MANAGE_STUDENTS,
          InstitutionalPermission.MANAGE_COURSES,
          InstitutionalPermission.SUBMIT_ATTENDANCE,
          InstitutionalPermission.MANAGE_CONTENT,
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
        };
      case UserRole.COE_STAFF:
        return {
          InstitutionalPermission.VIEW_PROFILE,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_NOTIFICATIONS,
          InstitutionalPermission.VIEW_EXAM_DATA,
          InstitutionalPermission.MANAGE_EXAMS,
          InstitutionalPermission.PUBLISH_RESULTS,
          InstitutionalPermission.GENERATE_HALL_TICKETS,
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
        };
      case UserRole.SCHOLAR:
        return {
          InstitutionalPermission.VIEW_PROFILE,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_NOTIFICATIONS,
          InstitutionalPermission.VIEW_ACADEMIC_DATA,
          InstitutionalPermission.SUBMIT_RESEARCH,
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
        };
      case UserRole.ADMIN:
        return {
          InstitutionalPermission.VIEW_PROFILE,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_NOTIFICATIONS,
          InstitutionalPermission.VIEW_ACADEMIC_DATA,
          InstitutionalPermission.VIEW_EXAM_DATA,
          InstitutionalPermission.MANAGE_STUDENTS,
          InstitutionalPermission.MANAGE_CONTENT,
          InstitutionalPermission.MANAGE_NOTIFICATIONS,
          InstitutionalPermission.APPROVE_USERS,
          InstitutionalPermission.MANAGE_ROLES,
          InstitutionalPermission.VIEW_AUDIT_LOGS,
          InstitutionalPermission.VIEW_ANALYTICS,
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
        };
      case UserRole.SUPER_ADMIN:
        return InstitutionalPermission.values.toSet();
      case UserRole.STAFF:
        return {
          InstitutionalPermission.VIEW_PROFILE,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_NOTIFICATIONS,
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
        };
      case UserRole.ALUMNI:
        return {
          InstitutionalPermission.VIEW_PROFILE,
          InstitutionalPermission.VIEW_DOCUMENTS,
          InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
        };
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String rollNo;
  final String department;
  final String semester;
  final String cgpa;
  final bool isHostelite;
  final bool busPassActive;
  final String validThru;
  final String accountStatus;
  final String approvedRolesCsv;
  final String requestedRole;
  final String applicationId;
  final String applicationDate;
  final String designation;
  final String mobileNumber;
  final String adminNotes;
  final String rejectionReason;
  final String adminClarificationQuery;
  final String applicantClarificationResponse;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.cgpa,
    this.isHostelite = true,
    this.busPassActive = true,
    this.validThru = "2026-12-31",
    this.accountStatus = "APPROVED",
    this.approvedRolesCsv = "STUDENT",
    this.requestedRole = "STUDENT",
    this.applicationId = "",
    this.applicationDate = "",
    this.designation = "",
    this.mobileNumber = "",
    this.adminNotes = "",
    this.rejectionReason = "",
    this.adminClarificationQuery = "",
    this.applicantClarificationResponse = "",
  });

  List<UserRole> getApprovedRolesList() {
    final list = approvedRolesCsv.split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) {
          try {
            return UserRole.values.byName(s);
          } catch (_) {
            return null;
          }
        })
        .whereType<UserRole>()
        .toList();

    if (list.isNotEmpty) return list;
    try {
      return [UserRole.values.byName(role)];
    } catch (_) {
      return [UserRole.GUEST];
    }
  }

  AccountStatus getAccountStatusEnum() {
    try {
      return AccountStatus.values.byName(accountStatus);
    } catch (_) {
      return AccountStatus.APPROVED;
    }
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? rollNo,
    String? department,
    String? semester,
    String? cgpa,
    bool? isHostelite,
    bool? busPassActive,
    String? validThru,
    String? accountStatus,
    String? approvedRolesCsv,
    String? requestedRole,
    String? applicationId,
    String? applicationDate,
    String? designation,
    String? mobileNumber,
    String? adminNotes,
    String? rejectionReason,
    String? adminClarificationQuery,
    String? applicantClarificationResponse,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      rollNo: rollNo ?? this.rollNo,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      cgpa: cgpa ?? this.cgpa,
      isHostelite: isHostelite ?? this.isHostelite,
      busPassActive: busPassActive ?? this.busPassActive,
      validThru: validThru ?? this.validThru,
      accountStatus: accountStatus ?? this.accountStatus,
      approvedRolesCsv: approvedRolesCsv ?? this.approvedRolesCsv,
      requestedRole: requestedRole ?? this.requestedRole,
      applicationId: applicationId ?? this.applicationId,
      applicationDate: applicationDate ?? this.applicationDate,
      designation: designation ?? this.designation,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      adminNotes: adminNotes ?? this.adminNotes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      adminClarificationQuery: adminClarificationQuery ?? this.adminClarificationQuery,
      applicantClarificationResponse: applicantClarificationResponse ?? this.applicantClarificationResponse,
    );
  }
}

class ApplicationHistoryEntry {
  final String timestamp;
  final String action;
  final String actor;
  final String details;

  ApplicationHistoryEntry({
    required this.timestamp,
    required this.action,
    required this.actor,
    required this.details,
  });

  Map<String, dynamic> toMap() => {
        'timestamp': timestamp,
        'action': action,
        'actor': actor,
        'details': details,
      };

  factory ApplicationHistoryEntry.fromMap(Map<String, dynamic> map) =>
      ApplicationHistoryEntry(
        timestamp: map['timestamp']?.toString() ?? '',
        action: map['action']?.toString() ?? '',
        actor: map['actor']?.toString() ?? '',
        details: map['details']?.toString() ?? '',
      );
}

class RegistrationApplication {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String mobile;
  final String institutionalId;
  final UserRole requestedRole;
  final String department;
  final String programme;
  final String yearSemester;
  final String designation;
  final String researchTopic;
  final AccountStatus status;
  final String submittedDate;
  final String adminQuery;
  final String applicantResponse;
  final String rejectionReason;
  final List<ApplicationHistoryEntry> history;

  RegistrationApplication({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.institutionalId,
    required this.requestedRole,
    required this.department,
    this.programme = "",
    this.yearSemester = "",
    this.designation = "",
    this.researchTopic = "",
    this.status = AccountStatus.PENDING_APPROVAL,
    this.submittedDate = "24 Sep 2026, 10:30 AM",
    this.adminQuery = "",
    this.applicantResponse = "",
    this.rejectionReason = "",
    this.history = const [],
  });

  RegistrationApplication copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? mobile,
    String? institutionalId,
    UserRole? requestedRole,
    String? department,
    String? programme,
    String? yearSemester,
    String? designation,
    String? researchTopic,
    AccountStatus? status,
    String? submittedDate,
    String? adminQuery,
    String? applicantResponse,
    String? rejectionReason,
    List<ApplicationHistoryEntry>? history,
  }) {
    return RegistrationApplication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      institutionalId: institutionalId ?? this.institutionalId,
      requestedRole: requestedRole ?? this.requestedRole,
      department: department ?? this.department,
      programme: programme ?? this.programme,
      yearSemester: yearSemester ?? this.yearSemester,
      designation: designation ?? this.designation,
      researchTopic: researchTopic ?? this.researchTopic,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      adminQuery: adminQuery ?? this.adminQuery,
      applicantResponse: applicantResponse ?? this.applicantResponse,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'mobile': mobile,
        'institutional_id': institutionalId,
        'requested_role': requestedRole.name,
        'department': department,
        'programme': programme,
        'year_semester': yearSemester,
        'designation': designation,
        'research_topic': researchTopic,
        'status': status.name,
        'submitted_date': submittedDate,
        'admin_query': adminQuery,
        'applicant_response': applicantResponse,
        'rejection_reason': rejectionReason,
        'history': history.map((h) => h.toMap()).toList(),
      };

  factory RegistrationApplication.fromMap(Map<String, dynamic> map) {
    UserRole requestedRole;
    try {
      requestedRole = UserRole.values.byName(map['requested_role']?.toString() ?? 'STUDENT');
    } catch (_) {
      requestedRole = UserRole.STUDENT;
    }
    AccountStatus status;
    try {
      status = AccountStatus.values.byName(map['status']?.toString() ?? 'PENDING_APPROVAL');
    } catch (_) {
      status = AccountStatus.PENDING_APPROVAL;
    }
    return RegistrationApplication(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      mobile: map['mobile']?.toString() ?? '',
      institutionalId: map['institutional_id']?.toString() ?? '',
      requestedRole: requestedRole,
      department: map['department']?.toString() ?? '',
      programme: map['programme']?.toString() ?? '',
      yearSemester: map['year_semester']?.toString() ?? '',
      designation: map['designation']?.toString() ?? '',
      researchTopic: map['research_topic']?.toString() ?? '',
      status: status,
      submittedDate: map['submitted_date']?.toString() ?? '',
      adminQuery: map['admin_query']?.toString() ?? '',
      applicantResponse: map['applicant_response']?.toString() ?? '',
      rejectionReason: map['rejection_reason']?.toString() ?? '',
      history: ((map['history'] as List<dynamic>?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ApplicationHistoryEntry.fromMap)
          .toList(),
    );
  }
}

class InstitutionalAuditLog {
  final String id;
  final String timestamp;
  final String adminName;
  final String adminRole;
  final String action;
  final String targetUser;
  final String targetRole;
  final String previousState;
  final String newState;
  final String reasonOrNotes;

  InstitutionalAuditLog({
    required this.id,
    required this.timestamp,
    required this.adminName,
    required this.adminRole,
    required this.action,
    required this.targetUser,
    required this.targetRole,
    required this.previousState,
    required this.newState,
    required this.reasonOrNotes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'timestamp': timestamp,
        'admin_name': adminName,
        'admin_role': adminRole,
        'action': action,
        'target_user': targetUser,
        'target_role': targetRole,
        'previous_state': previousState,
        'new_state': newState,
        'reason_or_notes': reasonOrNotes,
      };

  factory InstitutionalAuditLog.fromMap(Map<String, dynamic> map) =>
      InstitutionalAuditLog(
        id: map['id']?.toString() ?? '',
        timestamp: map['timestamp']?.toString() ?? '',
        adminName: map['admin_name']?.toString() ?? '',
        adminRole: map['admin_role']?.toString() ?? '',
        action: map['action']?.toString() ?? '',
        targetUser: map['target_user']?.toString() ?? '',
        targetRole: map['target_role']?.toString() ?? '',
        previousState: map['previous_state']?.toString() ?? '',
        newState: map['new_state']?.toString() ?? '',
        reasonOrNotes: map['reason_or_notes']?.toString() ?? '',
      );
}
