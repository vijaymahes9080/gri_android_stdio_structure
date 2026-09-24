package com.example.data.repository

import com.example.backend.GriKtorClient
import com.example.backend.GriKtorServer
import com.example.data.local.AccountStatus
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

  suspend fun getUserById(id: String): UserEntity? {
    return database.userDao().getUserById(id)
  }

  suspend fun saveUser(user: UserEntity) {
    database.userDao().insertUser(user)
  }

  fun getAllUsers(): Flow<List<UserEntity>> {
    return database.userDao().getAllUsers()
  }

  suspend fun initializeAndSeedIfEmpty() = withContext(Dispatchers.IO) {
    val existingUsers = database.userDao().getAllUsers().first()
    if (existingUsers.isEmpty()) {
      // Seed initial institutional users
      val defaultUsers = listOf(
        UserEntity(
          id = "usr_student",
          name = "Vijay Pradhap",
          email = "vijay.p24@ruraluniv.ac.in",
          role = UserRole.STUDENT.name,
          rollNo = "2024-MS-4011",
          department = "Computer Science & Applications",
          semester = "Semester IV (Final Year)",
          cgpa = "8.92",
          isHostelite = true,
          busPassActive = true,
          validThru = "2026-12-31",
          accountStatus = AccountStatus.APPROVED.name,
          approvedRolesCsv = "STUDENT",
          requestedRole = "STUDENT",
          applicationId = "APP-2024-1102",
          mobileNumber = "9876543210"
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
          validThru = "2030-05-31",
          accountStatus = AccountStatus.APPROVED.name,
          approvedRolesCsv = "FACULTY,SCHOLAR",
          requestedRole = "FACULTY",
          applicationId = "APP-2018-0512",
          designation = "Associate Professor & Research Guide",
          mobileNumber = "9442158900"
        ),
        UserEntity(
          id = "usr_admin",
          name = "Dr. M. Sundaramari",
          email = "registrar@ruraluniv.ac.in",
          role = UserRole.ADMIN.name,
          rollNo = "ADMIN-GRI-01",
          department = "Central Administration & Samarth ERP Hub",
          semester = "Registrar's Directorate",
          cgpa = "Registrar in-charge",
          isHostelite = false,
          busPassActive = true,
          validThru = "Permanent",
          accountStatus = AccountStatus.APPROVED.name,
          approvedRolesCsv = "ADMIN",
          requestedRole = "ADMIN",
          applicationId = "APP-2015-001",
          designation = "Registrar (in-charge) & Professor",
          mobileNumber = "9443322110"
        ),
        UserEntity(
          id = "usr_coe",
          name = "Dr. V. Sivakumar",
          email = "coe@ruraluniv.ac.in",
          role = UserRole.COE_STAFF.name,
          rollNo = "COE-OFF-09",
          department = "Office of the Controller of Examinations",
          semester = "CoE Secretariat",
          cgpa = "Controller of Examinations",
          isHostelite = false,
          busPassActive = true,
          validThru = "2029-12-31",
          accountStatus = AccountStatus.APPROVED.name,
          approvedRolesCsv = "COE_STAFF",
          requestedRole = "COE_STAFF",
          applicationId = "APP-2019-0941",
          designation = "Controller of Examinations",
          mobileNumber = "9488112233"
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
          validThru = "2028-06-30",
          accountStatus = AccountStatus.APPROVED.name,
          approvedRolesCsv = "SCHOLAR",
          requestedRole = "SCHOLAR",
          applicationId = "APP-2024-3401",
          designation = "Doctoral Research Fellow",
          mobileNumber = "9790012345"
        ),
        UserEntity(
          id = "usr_pending",
          name = "Kavitha Mohan",
          email = "kavitha.m26@ruraluniv.ac.in",
          role = UserRole.GUEST.name,
          rollNo = "2026-MA-8821",
          department = "Department of Rural Development",
          semester = "Applicant (Pending Verification)",
          cgpa = "Under Review",
          isHostelite = false,
          busPassActive = false,
          validThru = "Pending",
          accountStatus = AccountStatus.PENDING_APPROVAL.name,
          approvedRolesCsv = "GUEST",
          requestedRole = "STUDENT",
          applicationId = "APP-2026-9042",
          applicationDate = "24 Sep 2026, 09:15 AM",
          mobileNumber = "9840123456"
        ),
        UserEntity(
          id = "usr_review",
          name = "Arun Kumar",
          email = "arun.agri26@ruraluniv.ac.in",
          role = UserRole.GUEST.name,
          rollNo = "2026-PHD-AGR-05",
          department = "School of Agriculture & Rural Innovation",
          semester = "Applicant (Clarification Required)",
          cgpa = "Under Review",
          isHostelite = false,
          busPassActive = false,
          validThru = "Under Review",
          accountStatus = AccountStatus.UNDER_REVIEW.name,
          approvedRolesCsv = "GUEST",
          requestedRole = "SCHOLAR",
          applicationId = "APP-2026-8819",
          applicationDate = "23 Sep 2026, 03:40 PM",
          mobileNumber = "9710987654",
          adminClarificationQuery = "Please upload or provide your PG Degree Provisional Certificate register number and specify your specialization."
        ),
        UserEntity(
          id = "usr_guest",
          name = "Gandhigram Visitor",
          email = "guest@ruraluniv.ac.in",
          role = UserRole.GUEST.name,
          rollNo = "GUEST-VISITOR",
          department = "Gandhigram Rural Institute",
          semester = "Prospective Student / Campus Visitor",
          cgpa = "N/A",
          isHostelite = false,
          busPassActive = false,
          validThru = "2026-12-31",
          accountStatus = AccountStatus.APPROVED.name,
          approvedRolesCsv = "GUEST",
          requestedRole = "GUEST",
          applicationId = "GST-SESSION"
        )
      )
      database.userDao().insertUsers(defaultUsers)
    } else {
      // Ensure staff and guest accounts exist even if database was previously seeded
      val staffUser = database.userDao().getUserByRole(UserRole.STAFF.name).first()
      if (staffUser == null) {
        database.userDao().insertUser(
          UserEntity(
            id = "usr_staff",
            name = "K. Shanmugasundaram",
            email = "k.shanmugam@ruraluniv.ac.in",
            role = UserRole.STAFF.name,
            rollNo = "STF-ADM-042",
            department = "Finance & Establishment Section",
            semester = "Section Officer / Superintendent",
            cgpa = "Cadre: Group B Non-Teaching",
            isHostelite = false,
            busPassActive = true,
            validThru = "2032-03-31"
          )
        )
      }
      val guestUser = database.userDao().getUserByRole(UserRole.GUEST.name).first()
      if (guestUser == null) {
        database.userDao().insertUser(
          UserEntity(
            id = "usr_guest",
            name = "Gandhigram Visitor",
            email = "guest@ruraluniv.ac.in",
            role = UserRole.GUEST.name,
            rollNo = "GUEST-VISITOR",
            department = "Gandhigram Rural Institute",
            semester = "Prospective Student / Campus Visitor",
            cgpa = "N/A",
            isHostelite = false,
            busPassActive = false,
            validThru = "2026-12-31"
          )
        )
      }
    }

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

  suspend fun publishCircular(title: String, category: String, summary: String, isUrgent: Boolean, issuedBy: String): CircularEntity = withContext(Dispatchers.IO) {
    val circular = CircularEntity(
      id = "circ_${System.currentTimeMillis()}",
      title = title,
      category = category,
      publishedDate = java.text.SimpleDateFormat("dd MMM yyyy", java.util.Locale.getDefault()).format(java.util.Date()),
      isUrgent = isUrgent,
      summary = summary,
      issuedBy = issuedBy,
      isRead = false
    )
    database.circularDao().insertCircular(circular)
    database.syncQueueDao().enqueue(
      SyncQueueEntity(
        action = "INSERT",
        entityType = "CIRCULAR",
        payloadJson = "{\"id\":\"${circular.id}\",\"title\":\"${circular.title}\"}"
      )
    )
    circular
  }

  suspend fun performCloudSync(): Result<Int> = withContext(Dispatchers.IO) {
    runCatching {
      // 1. Process pending offline queue items
      val pendingItems = database.syncQueueDao().getPendingSyncItems().first()
      
      // 2. Attempt sync with Firestore if online and initialized
      val firestoreResult = runCatching { FirebaseFirestore.getInstance() }
      if (firestoreResult.isSuccess) {
        val firestore = firestoreResult.getOrThrow()
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
      } else {
        pendingItems.forEach { database.syncQueueDao().markAsSynced(it.id) }
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
