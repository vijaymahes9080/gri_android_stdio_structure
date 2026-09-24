package com.example.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

enum class UserRole {
    STUDENT,
    FACULTY,
    COE_STAFF,
    SCHOLAR,
    ADMIN,
    SUPER_ADMIN,
    STAFF,
    GUEST,
    ALUMNI,
    PUBLIC
}

enum class AccountStatus {
    PENDING_APPROVAL,
    UNDER_REVIEW,
    APPROVED,
    REJECTED,
    SUSPENDED,
    DISABLED
}

enum class InstitutionalPermission {
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
    VIEW_CAMPUS_PUBLIC
}

object RolePermissions {
    fun getPermissionsForRole(role: UserRole): Set<InstitutionalPermission> = when (role) {
        UserRole.PUBLIC -> setOf(
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
            InstitutionalPermission.VIEW_DOCUMENTS
        )
        UserRole.GUEST -> setOf(
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC,
            InstitutionalPermission.VIEW_DOCUMENTS,
            InstitutionalPermission.VIEW_PROFILE
        )
        UserRole.STUDENT -> setOf(
            InstitutionalPermission.VIEW_PROFILE,
            InstitutionalPermission.VIEW_DOCUMENTS,
            InstitutionalPermission.VIEW_NOTIFICATIONS,
            InstitutionalPermission.VIEW_ACADEMIC_DATA,
            InstitutionalPermission.VIEW_EXAM_DATA,
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC
        )
        UserRole.FACULTY -> setOf(
            InstitutionalPermission.VIEW_PROFILE,
            InstitutionalPermission.VIEW_DOCUMENTS,
            InstitutionalPermission.VIEW_NOTIFICATIONS,
            InstitutionalPermission.VIEW_ACADEMIC_DATA,
            InstitutionalPermission.MANAGE_STUDENTS,
            InstitutionalPermission.MANAGE_COURSES,
            InstitutionalPermission.SUBMIT_ATTENDANCE,
            InstitutionalPermission.MANAGE_CONTENT,
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC
        )
        UserRole.COE_STAFF -> setOf(
            InstitutionalPermission.VIEW_PROFILE,
            InstitutionalPermission.VIEW_DOCUMENTS,
            InstitutionalPermission.VIEW_NOTIFICATIONS,
            InstitutionalPermission.VIEW_EXAM_DATA,
            InstitutionalPermission.MANAGE_EXAMS,
            InstitutionalPermission.PUBLISH_RESULTS,
            InstitutionalPermission.GENERATE_HALL_TICKETS,
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC
        )
        UserRole.SCHOLAR -> setOf(
            InstitutionalPermission.VIEW_PROFILE,
            InstitutionalPermission.VIEW_DOCUMENTS,
            InstitutionalPermission.VIEW_NOTIFICATIONS,
            InstitutionalPermission.VIEW_ACADEMIC_DATA,
            InstitutionalPermission.SUBMIT_RESEARCH,
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC
        )
        UserRole.ADMIN -> setOf(
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
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC
        )
        UserRole.SUPER_ADMIN -> InstitutionalPermission.values().toSet()
        UserRole.STAFF -> setOf(
            InstitutionalPermission.VIEW_PROFILE,
            InstitutionalPermission.VIEW_DOCUMENTS,
            InstitutionalPermission.VIEW_NOTIFICATIONS,
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC
        )
        UserRole.ALUMNI -> setOf(
            InstitutionalPermission.VIEW_PROFILE,
            InstitutionalPermission.VIEW_DOCUMENTS,
            InstitutionalPermission.VIEW_CAMPUS_PUBLIC
        )
    }
}

@Entity(tableName = "users")
data class UserEntity(
    @PrimaryKey val id: String,
    val name: String,
    val email: String,
    val role: String,
    val rollNo: String,
    val department: String,
    val semester: String,
    val cgpa: String,
    val isHostelite: Boolean = true,
    val busPassActive: Boolean = true,
    val validThru: String = "2026-12-31",
    val accountStatus: String = "APPROVED",
    val approvedRolesCsv: String = "STUDENT",
    val requestedRole: String = "STUDENT",
    val applicationId: String = "",
    val applicationDate: String = "",
    val designation: String = "",
    val mobileNumber: String = "",
    val adminNotes: String = "",
    val rejectionReason: String = "",
    val adminClarificationQuery: String = "",
    val applicantClarificationResponse: String = ""
) {
    fun getApprovedRolesList(): List<UserRole> {
        val list = approvedRolesCsv.split(",")
            .map { it.trim() }
            .filter { it.isNotEmpty() }
            .mapNotNull {
                try {
                    UserRole.valueOf(it)
                } catch (e: Exception) {
                    null
                }
            }
        return if (list.isNotEmpty()) list else listOf(try { UserRole.valueOf(role) } catch (e: Exception) { UserRole.GUEST })
    }

    fun getAccountStatusEnum(): AccountStatus {
        return try {
            AccountStatus.valueOf(accountStatus)
        } catch (e: Exception) {
            AccountStatus.APPROVED
        }
    }
}

data class RegistrationApplication(
    val id: String,
    val userId: String,
    val fullName: String,
    val email: String,
    val mobile: String,
    val institutionalId: String,
    val requestedRole: UserRole,
    val department: String,
    val programme: String = "",
    val yearSemester: String = "",
    val designation: String = "",
    val researchTopic: String = "",
    val status: AccountStatus = AccountStatus.PENDING_APPROVAL,
    val submittedDate: String = "24 Sep 2026, 10:30 AM",
    val adminQuery: String = "",
    val applicantResponse: String = "",
    val rejectionReason: String = "",
    val history: List<ApplicationHistoryEntry> = emptyList()
)

data class ApplicationHistoryEntry(
    val timestamp: String,
    val action: String,
    val actor: String,
    val details: String
)

data class InstitutionalAuditLog(
    val id: String,
    val timestamp: String,
    val adminName: String,
    val adminRole: String,
    val action: String,
    val targetUser: String,
    val targetRole: String,
    val previousState: String,
    val newState: String,
    val reasonOrNotes: String
)

@Entity(tableName = "courses")
data class CourseEntity(
    @PrimaryKey val id: String,
    val code: String,
    val title: String,
    val credits: Int,
    val instructor: String,
    val schedule: String,
    val attendancePercent: Int,
    val totalClasses: Int,
    val attendedClasses: Int
)

@Entity(tableName = "circulars")
data class CircularEntity(
    @PrimaryKey val id: String,
    val title: String,
    val category: String,
    val publishedDate: String,
    val summary: String,
    val issuedBy: String,
    val isUrgent: Boolean = false,
    val isRead: Boolean = false
)

@Entity(tableName = "grievances")
data class GrievanceEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val ticketNumber: String,
    val category: String,
    val subject: String,
    val description: String,
    val status: String,
    val studentRollNo: String,
    val createdAt: Long = System.currentTimeMillis(),
    val resolvedAt: Long? = null,
    val remarks: String = ""
)

@Entity(tableName = "transport_routes")
data class TransportRouteEntity(
    @PrimaryKey val id: String,
    val routeNo: String,
    val routeName: String,
    val source: String,
    val destination: String,
    val busNumber: String,
    val departureTime: String,
    val returnTime: String,
    val driverName: String,
    val driverPhone: String,
    val currentStatus: String
)

@Entity(tableName = "sync_queue")
data class SyncQueueEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val action: String,
    val entityType: String,
    val payloadJson: String,
    val timestamp: Long = System.currentTimeMillis(),
    val isSynced: Boolean = false
)

data class StaffLeaveRecord(
    val id: String,
    val leaveType: String,
    val days: Int,
    val fromDate: String,
    val toDate: String,
    val status: String,
    val reason: String
)

data class PublishingAuditEntry(
    val id: String,
    val noticeId: String,
    val title: String,
    val author: String,
    val authorRole: String,
    val authorizedBy: String,
    val timestamp: String,
    val status: String
)

