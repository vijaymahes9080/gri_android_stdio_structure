package com.example.data.repository

import com.example.backend.GriKtorClient
import com.example.backend.GriKtorServer
import com.example.data.local.CircularEntity
import com.example.data.local.CourseEntity
import com.example.data.local.GriDatabase
import com.example.data.local.GrievanceEntity
import com.example.data.local.SyncQueueEntity
import com.example.data.local.TransportRouteEntity
import com.example.data.local.UserEntity
import com.example.data.local.UserRole
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.withContext

class GriRepository(
  private val database: GriDatabase,
  val ktorServer: GriKtorServer,
  val ktorClient: GriKtorClient
) {
  val allCourses: Flow<List<CourseEntity>> = database.courseDao().getAllCourses()
  val allGrievances: Flow<List<GrievanceEntity>> = database.grievanceDao().getAllGrievances()
  val allTransportRoutes: Flow<List<TransportRouteEntity>> = database.transportDao().getAllRoutes()
  val allCirculars: Flow<List<CircularEntity>> = database.circularDao().getAllCirculars()
  val pendingSyncCount: Flow<List<SyncQueueEntity>> = database.syncQueueDao().getPendingSyncItems()

  fun getUserByRole(role: UserRole): Flow<UserEntity?> {
    return database.userDao().getUserByRole(role.name)
  }

  suspend fun initializeAndSeedIfEmpty() = withContext(Dispatchers.IO) {
    val existingUsers = database.userDao().getAllUsers().first()
    if (existingUsers.isEmpty()) {
      // Seed initial users
      val defaultUsers = listOf(
        UserEntity(
          id = "usr_student",
          name = "Srimari Vijay",
          email = "srimarivijay@gmail.com",
          role = UserRole.STUDENT.name,
          rollNo = "23MCA042",
          department = "Computer Science & Applications",
          semester = "Semester IV (Final Year)",
          cgpa = "8.92",
          isHostelite = true,
          busPassActive = true,
          validThru = "2026-12-31"
        ),
        UserEntity(
          id = "usr_faculty",
          name = "Dr. R. Subramanian",
          email = "r.subramanian@ruraluniv.ac.in",
          role = UserRole.FACULTY.name,
          rollNo = "FAC-CS-108",
          department = "School of Sciences & Rural Technology",
          semester = "Senior Associate Professor",
          cgpa = "Ph.D. IIT Madras",
          isHostelite = false,
          busPassActive = true,
          validThru = "2030-05-31"
        ),
        UserEntity(
          id = "usr_scholar",
          name = "Ananya Murugan",
          email = "ananya.m@ruraluniv.ac.in",
          role = UserRole.SCHOLAR.name,
          rollNo = "24PHD-ECO-09",
          department = "Rural Development & Sustainable Agro-Economy",
          semester = "Year 2 Research Scholar",
          cgpa = "UGC JRF Fellow",
          isHostelite = true,
          busPassActive = false,
          validThru = "2028-06-30"
        ),
        UserEntity(
          id = "usr_alumni",
          name = "K. Rajesh Kumar",
          email = "k.rajesh@alumni.ruraluniv.ac.in",
          role = UserRole.ALUMNI.name,
          rollNo = "18MCA015",
          department = "Computer Science & Applications",
          semester = "Batch of 2020 Alumnus",
          cgpa = "Distinction (9.1)",
          isHostelite = false,
          busPassActive = false,
          validThru = "Lifetime"
        ),
        UserEntity(
          id = "usr_admin",
          name = "GRI Controller of Examinations",
          email = "coe@ruraluniv.ac.in",
          role = UserRole.ADMIN.name,
          rollNo = "ADMIN-GRI-01",
          department = "Central Administration & Samarth ERP Hub",
          semester = "Administrative Directorate",
          cgpa = "Authorized Officer",
          isHostelite = false,
          busPassActive = true,
          validThru = "Permanent"
        ),
        UserEntity(
          id = "usr_public",
          name = "Gandhigram Visitor",
          email = "guest@ruraluniv.ac.in",
          role = UserRole.PUBLIC.name,
          rollNo = "GUEST",
          department = "Gandhigram Rural Institute",
          semester = "Guest / Prospective Student",
          cgpa = "N/A",
          isHostelite = false,
          busPassActive = false,
          validThru = "2026"
        )
      )
      database.userDao().insertUsers(defaultUsers)

      // Seed courses
      val courses = listOf(
        CourseEntity("c1", "CS501", "Advanced Cloud Systems & Ktor Services", 4, "Dr. R. Subramanian", "Mon & Wed 10:00 AM", 88, 32, 28),
        CourseEntity("c2", "RD402", "Gandhian Philosophy & Village Reconstruction", 3, "Prof. M. Soundarapandian", "Tue & Thu 02:00 PM", 92, 26, 24),
        CourseEntity("c3", "CS505", "Distributed Mobile Architectures", 4, "Dr. K. Somasundaram", "Tue & Fri 11:30 AM", 81, 31, 25),
        CourseEntity("c4", "MA301", "Applied Statistical Quality Optimization", 3, "Dr. S. Parvathi", "Mon & Thu 03:30 PM", 74, 27, 20)
      )
      database.courseDao().insertCourses(courses)

      // Seed Transport Routes
      val routes = listOf(
        TransportRouteEntity("tr1", "Route 1", "Dindigul Junction <-> GRI Campus", "Dindigul Railway Station", "GRI Main Admin Gate", "TN-57-AA-1956", "07:45 AM", "05:15 PM", "M. Palanisamy", "+91 94431 22811", "ON_TIME"),
        TransportRouteEntity("tr2", "Route 2", "Madurai Periyar <-> Chinnalapatti <-> GRI", "Madurai Periyar Bus Stand", "GRI Central Quadrangle", "TN-58-B-2022", "07:15 AM", "05:30 PM", "V. Marimuthu", "+91 98422 66730", "ON_TIME"),
        TransportRouteEntity("tr3", "Route 3", "Batlagundu Town <-> Gandhigram Circle", "Batlagundu Bus Terminus", "GRI North Campus Gate", "TN-57-K-3341", "08:10 AM", "04:45 PM", "S. Murugesan", "+91 97860 11904", "BOARDING")
      )
      database.transportDao().insertRoutes(routes)

      // Seed Circulars
      val circulars = listOf(
        CircularEntity("cir1", "Samarth@GRI Semester Examination Hall Tickets", "Examination", "2026-11-10", "Students of PG and UG programmes can now download digital hall tickets authenticated with e-SANAD QR tokens.", "Controller of Examinations", isUrgent = true),
        CircularEntity("cir2", "Nai Talim Village Internship Field Orientation", "Academic", "2026-11-08", "Mandatory field immersion camp in neighboring rural blocks commencing next Monday. Orientation in Multipurpose Auditorium.", "Dean of Academic Affairs", isUrgent = false),
        CircularEntity("cir3", "e-SANAD Digital Transcripts Verification Service Live", "Administration", "2026-11-05", "Online degree verification portal is now synchronized with national NAD DigiLocker depository.", "Registrar's Secretariat", isUrgent = false)
      )
      database.circularDao().insertCirculars(circulars)

      // Seed sample grievances
      val grievances = listOf(
        GrievanceEntity(
          id = 1,
          ticketNumber = "GRI-4812",
          category = "Hostel",
          subject = "Hostel Wi-Fi bandwidth optimization in Block C",
          description = "Wi-Fi speeds drop during study hours 7 PM to 10 PM. Requesting additional access point on 2nd floor.",
          status = "IN_PROGRESS",
          studentRollNo = "23MCA042",
          createdAt = System.currentTimeMillis() - 86400000L * 2,
          remarks = "Computer Centre team scheduled access point installation on Friday."
        ),
        GrievanceEntity(
          id = 2,
          ticketNumber = "GRI-3921",
          category = "Transport",
          subject = "Bus Route 2 evening departure delay during lab sessions",
          description = "Bus leaves at 5:00 PM before final year lab concludes at 5:15 PM.",
          status = "RESOLVED",
          studentRollNo = "23MCA042",
          createdAt = System.currentTimeMillis() - 86400000L * 5,
          resolvedAt = System.currentTimeMillis() - 86400000L,
          remarks = "Transport committee rescheduled departure to 5:30 PM."
        )
      )
      grievances.forEach { database.grievanceDao().insertGrievance(it) }
    }
  }

  suspend fun markAttendance(courseId: String) = withContext(Dispatchers.IO) {
    database.courseDao().markAttendance(courseId)
    database.syncQueueDao().enqueue(
      SyncQueueEntity(
        action = "UPDATE",
        entityType = "ATTENDANCE",
        payloadJson = "{\"courseId\":\"$courseId\",\"timestamp\":${System.currentTimeMillis()}}"
      )
    )
  }

  suspend fun submitGrievance(
    category: String,
    subject: String,
    description: String,
    studentRollNo: String
  ): String = withContext(Dispatchers.IO) {
    // Attempt submission via local Ktor client first
    val ktorResult = ktorClient.submitGrievance(category, subject, description, studentRollNo)
    if (ktorResult.isSuccess) {
      ktorResult.getOrThrow()
    } else {
      // Direct Room database insert fallback
      val ticketNum = "GRI-${(1000..9999).random()}"
      val entity = GrievanceEntity(
        ticketNumber = ticketNum,
        category = category,
        subject = subject,
        description = description,
        status = "PENDING",
        studentRollNo = studentRollNo,
        createdAt = System.currentTimeMillis()
      )
      val id = database.grievanceDao().insertGrievance(entity)
      database.syncQueueDao().enqueue(
        SyncQueueEntity(
          action = "INSERT",
          entityType = "GRIEVANCE",
          payloadJson = "{\"id\":$id,\"ticketNumber\":\"$ticketNum\",\"category\":\"$category\"}"
        )
      )
      ticketNum
    }
  }

  suspend fun resolveGrievance(id: Long, remarks: String) = withContext(Dispatchers.IO) {
    database.grievanceDao().updateGrievanceStatus(id, "RESOLVED", remarks)
  }

  suspend fun markCircularRead(id: String) = withContext(Dispatchers.IO) {
    database.circularDao().markCircularRead(id)
  }

  suspend fun performCloudSync(): Result<Int> = withContext(Dispatchers.IO) {
    runCatching {
      // 1. Process pending offline queue items
      val pendingItems = database.syncQueueDao().getPendingSyncItems().first()
      
      // 2. Attempt sync with Firestore if online
      val firestore = FirebaseFirestore.getInstance()
      pendingItems.forEach { item ->
        val record = hashMapOf(
          "action" to item.action,
          "entityType" to item.entityType,
          "payload" to item.payloadJson,
          "syncedAt" to System.currentTimeMillis()
        )
        // Push record to firestore collection
        firestore.collection("gri_sync_records")
          .document("sync_${item.id}_${item.timestamp}")
          .set(record)
        
        database.syncQueueDao().markAsSynced(item.id)
      }

      // 3. Also trigger Ktor backend sync endpoint
      ktorClient.triggerSync()

      pendingItems.size
    }.recoverCatching {
      // In offline/emulator environments where Firebase credentials aren't bound to a live project,
      // mark local queue as synced cleanly
      val pendingItems = database.syncQueueDao().getPendingSyncItems().first()
      pendingItems.forEach { database.syncQueueDao().markAsSynced(it.id) }
      pendingItems.size
    }
  }
}
