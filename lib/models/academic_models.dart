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

