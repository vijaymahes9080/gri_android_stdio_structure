class CourseModel {
  final String id;
  final String code;
  final String title;
  final int credits;
  final String instructor;
  final String schedule;
  final int attendancePercent;
  final int totalClasses;
  final int attendedClasses;

  CourseModel({
    required this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.instructor,
    required this.schedule,
    required this.attendancePercent,
    required this.totalClasses,
    required this.attendedClasses,
  });

  CourseModel copyWith({
    String? id,
    String? code,
    String? title,
    int? credits,
    String? instructor,
    String? schedule,
    int? attendancePercent,
    int? totalClasses,
    int? attendedClasses,
  }) {
    return CourseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      credits: credits ?? this.credits,
      instructor: instructor ?? this.instructor,
      schedule: schedule ?? this.schedule,
      attendancePercent: attendancePercent ?? this.attendancePercent,
      totalClasses: totalClasses ?? this.totalClasses,
      attendedClasses: attendedClasses ?? this.attendedClasses,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'code': code,
        'title': title,
        'credits': credits,
        'instructor': instructor,
        'schedule': schedule,
        'attendance_percent': attendancePercent,
        'total_classes': totalClasses,
        'attended_classes': attendedClasses,
      };

  factory CourseModel.fromMap(Map<String, dynamic> map) => CourseModel(
        id: map['id']?.toString() ?? '',
        code: map['code']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        credits: (map['credits'] as num?)?.toInt() ?? 0,
        instructor: map['instructor']?.toString() ?? '',
        schedule: map['schedule']?.toString() ?? '',
        attendancePercent: (map['attendance_percent'] as num?)?.toInt() ?? 0,
        totalClasses: (map['total_classes'] as num?)?.toInt() ?? 0,
        attendedClasses: (map['attended_classes'] as num?)?.toInt() ?? 0,
      );
}

class CircularModel {
  final String id;
  final String title;
  final String category;
  final String publishedDate;
  final String summary;
  final String issuedBy;
  final bool isUrgent;
  final bool isRead;

  CircularModel({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedDate,
    required this.summary,
    required this.issuedBy,
    this.isUrgent = false,
    this.isRead = false,
  });

  CircularModel copyWith({
    String? id,
    String? title,
    String? category,
    String? publishedDate,
    String? summary,
    String? issuedBy,
    bool? isUrgent,
    bool? isRead,
  }) {
    return CircularModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      publishedDate: publishedDate ?? this.publishedDate,
      summary: summary ?? this.summary,
      issuedBy: issuedBy ?? this.issuedBy,
      isUrgent: isUrgent ?? this.isUrgent,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'published_date': publishedDate,
        'summary': summary,
        'issued_by': issuedBy,
        'is_urgent': isUrgent,
        'is_read': isRead,
      };

  factory CircularModel.fromMap(Map<String, dynamic> map) => CircularModel(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        category: map['category']?.toString() ?? '',
        publishedDate: map['published_date']?.toString() ?? '',
        summary: map['summary']?.toString() ?? '',
        issuedBy: map['issued_by']?.toString() ?? '',
        isUrgent: map['is_urgent'] as bool? ?? false,
        isRead: map['is_read'] as bool? ?? false,
      );
}

class GrievanceModel {
  final int id;
  final String ticketNumber;
  final String category;
  final String subject;
  final String description;
  final String status;
  final String studentRollNo;
  final int createdAt;
  final int? resolvedAt;
  final String remarks;

  GrievanceModel({
    required this.id,
    required this.ticketNumber,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    required this.studentRollNo,
    required this.createdAt,
    this.resolvedAt,
    this.remarks = "",
  });

  GrievanceModel copyWith({
    int? id,
    String? ticketNumber,
    String? category,
    String? subject,
    String? description,
    String? status,
    String? studentRollNo,
    int? createdAt,
    int? resolvedAt,
    String? remarks,
  }) {
    return GrievanceModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      studentRollNo: studentRollNo ?? this.studentRollNo,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'ticket_number': ticketNumber,
        'category': category,
        'subject': subject,
        'description': description,
        'status': status,
        'student_roll_no': studentRollNo,
        'created_at': createdAt,
        'resolved_at': resolvedAt,
        'remarks': remarks,
      };

  factory GrievanceModel.fromMap(Map<String, dynamic> map) => GrievanceModel(
        id: (map['id'] as num?)?.toInt() ?? 0,
        ticketNumber: map['ticket_number']?.toString() ?? '',
        category: map['category']?.toString() ?? '',
        subject: map['subject']?.toString() ?? '',
        description: map['description']?.toString() ?? '',
        status: map['status']?.toString() ?? 'SUBMITTED',
        studentRollNo: map['student_roll_no']?.toString() ?? '',
        createdAt: (map['created_at'] as num?)?.toInt() ?? 0,
        resolvedAt: (map['resolved_at'] as num?)?.toInt(),
        remarks: map['remarks']?.toString() ?? '',
      );
}

class TransportRouteModel {
  final String id;
  final String routeNo;
  final String routeName;
  final String source;
  final String destination;
  final String busNumber;
  final String departureTime;
  final String returnTime;
  final String driverName;
  final String driverPhone;
  final String currentStatus;

  TransportRouteModel({
    required this.id,
    required this.routeNo,
    required this.routeName,
    required this.source,
    required this.destination,
    required this.busNumber,
    required this.departureTime,
    required this.returnTime,
    required this.driverName,
    required this.driverPhone,
    required this.currentStatus,
  });
}

class StaffLeaveRecord {
  final String id;
  final String leaveType;
  final int days;
  final String fromDate;
  final String toDate;
  final String status;
  final String reason;

  StaffLeaveRecord({
    required this.id,
    required this.leaveType,
    required this.days,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.reason,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'leave_type': leaveType,
        'days': days,
        'from_date': fromDate,
        'to_date': toDate,
        'status': status,
        'reason': reason,
      };

  factory StaffLeaveRecord.fromMap(Map<String, dynamic> map) => StaffLeaveRecord(
        id: map['id']?.toString() ?? '',
        leaveType: map['leave_type']?.toString() ?? '',
        days: (map['days'] as num?)?.toInt() ?? 1,
        fromDate: map['from_date']?.toString() ?? '',
        toDate: map['to_date']?.toString() ?? '',
        status: map['status']?.toString() ?? 'SUBMITTED',
        reason: map['reason']?.toString() ?? '',
      );
}

class PublishingAuditEntry {
  final String id;
  final String noticeId;
  final String title;
  final String author;
  final String authorRole;
  final String authorizedBy;
  final String timestamp;
  final String status;

  PublishingAuditEntry({
    required this.id,
    required this.noticeId,
    required this.title,
    required this.author,
    required this.authorRole,
    required this.authorizedBy,
    required this.timestamp,
    required this.status,
  });
}

class DocumentItem {
  final String id;
  final String title;
  final String authority;
  final String category;
  final String date;
  final String fileSize;
  final String summary;
  final List<String> sections;

  DocumentItem({
    required this.id,
    required this.title,
    required this.authority,
    required this.category,
    required this.date,
    required this.fileSize,
    required this.summary,
    this.sections = const [],
  });
}

class ExamSubject {
  final String code;
  final String title;
  final String date;
  final String session;
  final String venue;

  ExamSubject({
    required this.code,
    required this.title,
    required this.date,
    required this.session,
    required this.venue,
  });
}

class HallTicketResponse {
  final String rollNo;
  final String studentName;
  final String degree;
  final String semester;
  final String examCenter;
  final String instructions;
  final List<ExamSubject> subjects;

  HallTicketResponse({
    required this.rollNo,
    required this.studentName,
    required this.degree,
    required this.semester,
    required this.examCenter,
    required this.instructions,
    required this.subjects,
  });
}

class SahayakMessage {
  final String id;
  final String text;
  final bool isUser;
  final String timestamp;
  final String? source;

  SahayakMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.timestamp = "Just now",
    this.source,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'is_user': isUser,
        'timestamp': timestamp,
        'source': source,
      };

  factory SahayakMessage.fromMap(Map<String, dynamic> map) => SahayakMessage(
        id: map['id']?.toString() ?? '',
        text: map['text']?.toString() ?? '',
        isUser: map['is_user'] as bool? ?? false,
        timestamp: map['timestamp']?.toString() ?? 'Just now',
        source: map['source']?.toString(),
      );
}

class StudentRollEntry {
  final String roll;
  final String name;
  final String status; // Present | Absent | OD

  StudentRollEntry({
    required this.roll,
    required this.name,
    this.status = "Present",
  });

  StudentRollEntry copyWith({String? status}) {
    return StudentRollEntry(
      roll: roll,
      name: name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() => {
        'roll': roll,
        'name': name,
        'status': status,
      };

  factory StudentRollEntry.fromMap(Map<String, dynamic> map) =>
      StudentRollEntry(
        roll: map['roll']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        status: map['status']?.toString() ?? 'Present',
      );
}

class RollCallRecord {
  final String id;
  final String courseCode;
  final String batch;
  final String recordedBy;
  final int presentCount;
  final int absentCount;
  final int odCount;
  final int recordedAt; // epoch milliseconds

  RollCallRecord({
    required this.id,
    required this.courseCode,
    required this.batch,
    required this.recordedBy,
    required this.presentCount,
    required this.absentCount,
    required this.odCount,
    required this.recordedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'course_code': courseCode,
        'batch': batch,
        'recorded_by': recordedBy,
        'present_count': presentCount,
        'absent_count': absentCount,
        'od_count': odCount,
        'recorded_at': recordedAt,
      };

  factory RollCallRecord.fromMap(Map<String, dynamic> map) => RollCallRecord(
        id: map['id']?.toString() ?? '',
        courseCode: map['course_code']?.toString() ?? '',
        batch: map['batch']?.toString() ?? '',
        recordedBy: map['recorded_by']?.toString() ?? '',
        presentCount: (map['present_count'] as num?)?.toInt() ?? 0,
        absentCount: (map['absent_count'] as num?)?.toInt() ?? 0,
        odCount: (map['od_count'] as num?)?.toInt() ?? 0,
        recordedAt: (map['recorded_at'] as num?)?.toInt() ?? 0,
      );
}

class SchoolModel {
  final String id;
  final String name;
  final String dean;
  final String deanEmail;
  final String deanPhone;
  final int programmesCount;
  final String highlights;
  final List<DepartmentModel> departments;

  SchoolModel({
    required this.id,
    required this.name,
    required this.dean,
    required this.deanEmail,
    required this.deanPhone,
    required this.programmesCount,
    required this.highlights,
    this.departments = const [],
  });
}

class DepartmentModel {
  final String id;
  final String name;
  final String hod;
  final String hodEmail;
  final String contact;
  final List<String> programmes;
  final String researchAreas;

  String get headOfDepartment => hod;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.hod,
    required this.hodEmail,
    required this.contact,
    required this.programmes,
    required this.researchAreas,
  });
}

class LeadershipOfficerModel {
  final String id;
  final String name;
  final String designation;
  final String email;
  final String phone;
  final String portfolio;
  final String officeLocation;

  LeadershipOfficerModel({
    required this.id,
    required this.name,
    required this.designation,
    required this.email,
    required this.phone,
    required this.portfolio,
    required this.officeLocation,
  });
}

class ProspectusModel {
  final String id;
  final String title;
  final String academicYear;
  final String pdfUrl;
  final String size;
  final String summary;
  final List<String> keyOfferings;

  ProspectusModel({
    required this.id,
    required this.title,
    required this.academicYear,
    required this.pdfUrl,
    required this.size,
    required this.summary,
    required this.keyOfferings,
  });
}

class OfficialDownloadModel {
  final String id;
  final String title;
  final String category;
  final String fileUrl;
  final String authority;
  final String instructions;

  String get downloadUrl => fileUrl;

  OfficialDownloadModel({
    required this.id,
    required this.title,
    required this.category,
    required this.fileUrl,
    required this.authority,
    required this.instructions,
  });
}

class ScholarshipItemModel {
  final String id;
  final String name;
  final String beneficiary;
  final String amount;
  final String deadline;
  final String officialNoticeUrl;
  final List<String> eligibility;

  String get title => name;
  String get portalUrl => officialNoticeUrl;

  ScholarshipItemModel({
    required this.id,
    required this.name,
    required this.beneficiary,
    required this.amount,
    required this.deadline,
    required this.officialNoticeUrl,
    required this.eligibility,
  });
}

class StatutoryBodyModel {
  final String id;
  final String name;
  final String role;
  final String frequency;
  final List<String> keyMembers;
  final String legalProvision;

  StatutoryBodyModel({
    required this.id,
    required this.name,
    required this.role,
    required this.frequency,
    required this.keyMembers,
    required this.legalProvision,
  });
}

