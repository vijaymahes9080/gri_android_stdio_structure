package com.example.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

enum class UserRole {
  STUDENT,
  FACULTY,
  SCHOLAR,
  ALUMNI,
  ADMIN,
  PUBLIC
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
  val validThru: String = "2026-12-31"
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

@Entity(tableName = "grievances")
data class GrievanceEntity(
  @PrimaryKey(autoGenerate = true) val id: Long = 0,
  val ticketNumber: String,
  val category: String, // Hostel, Academic, Transport, Sanitation, Infrastructure
  val subject: String,
  val description: String,
  val status: String, // PENDING, IN_PROGRESS, RESOLVED
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
  val currentStatus: String // ON_TIME, DELAYED, BOARDING
)

@Entity(tableName = "circulars")
data class CircularEntity(
  @PrimaryKey val id: String,
  val title: String,
  val category: String, // Examination, Academic, Campus, Administration
  val publishedDate: String,
  val summary: String,
  val issuedBy: String,
  val isUrgent: Boolean = false,
  val isRead: Boolean = false
)

@Entity(tableName = "sync_queue")
data class SyncQueueEntity(
  @PrimaryKey(autoGenerate = true) val id: Long = 0,
  val action: String, // INSERT, UPDATE, DELETE
  val entityType: String, // GRIEVANCE, ATTENDANCE, CIRCULAR
  val payloadJson: String,
  val timestamp: Long = System.currentTimeMillis(),
  val isSynced: Boolean = false
)
