package com.example.backend

import com.example.data.local.GriDatabase
import com.example.data.local.GrievanceEntity
import com.example.data.local.SyncQueueEntity
import com.google.gson.Gson
import io.ktor.http.HttpHeaders
import io.ktor.http.HttpMethod
import io.ktor.http.HttpStatusCode
import io.ktor.serialization.gson.gson
import io.ktor.server.application.call
import io.ktor.server.application.install
import io.ktor.server.cio.CIO
import io.ktor.server.engine.ApplicationEngine
import io.ktor.server.engine.embeddedServer
import io.ktor.server.plugins.contentnegotiation.ContentNegotiation
import io.ktor.server.plugins.cors.routing.CORS
import io.ktor.server.request.receive
import io.ktor.server.response.respond
import io.ktor.server.routing.get
import io.ktor.server.routing.post
import io.ktor.server.routing.route
import io.ktor.server.routing.routing
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import java.util.concurrent.atomic.AtomicInteger

data class ServerHealthResponse(
  val status: String,
  val institution: String,
  val backend: String,
  val serverTime: String,
  val port: Int,
  val requestsHandled: Int,
  val activeModules: List<String>
)

data class LoginRequest(
  val identifier: String,
  val role: String
)

data class LoginResponse(
  val success: Boolean,
  val token: String,
  val role: String,
  val name: String,
  val rollNo: String,
  val department: String,
  val message: String
)

data class GrievanceRequest(
  val category: String,
  val subject: String,
  val description: String,
  val studentRollNo: String
)

data class HallTicketResponse(
  val hallTicketNo: String,
  val examSession: String,
  val studentName: String,
  val registerNumber: String,
  val degree: String,
  val examinationCenter: String,
  val sanadVerificationCode: String,
  val exams: List<ExamScheduleItem>
)

data class ExamScheduleItem(
  val courseCode: String,
  val courseTitle: String,
  val date: String,
  val session: String,
  val hallNumber: String
)

class GriKtorServer(
  private val database: GriDatabase,
  val port: Int = 8080
) {
  private var engine: ApplicationEngine? = null
  private val requestCounter = AtomicInteger(0)
  val requestsHandled: Int get() = requestCounter.get()
  var isRunning: Boolean = false
    private set

  private val scope = CoroutineScope(Dispatchers.IO)
  private val gson = Gson()

  fun start(onStarted: () -> Unit = {}, onError: (Throwable) -> Unit = {}) {
    if (isRunning) return

    scope.launch {
      try {
        engine = embeddedServer(CIO, port = port, host = "0.0.0.0") {
          install(ContentNegotiation) {
            gson {
              setPrettyPrinting()
            }
          }
          install(CORS) {
            anyHost()
            allowHeader(HttpHeaders.ContentType)
            allowHeader(HttpHeaders.Authorization)
            allowMethod(HttpMethod.Options)
            allowMethod(HttpMethod.Put)
            allowMethod(HttpMethod.Patch)
            allowMethod(HttpMethod.Delete)
          }

          routing {
            route("/api") {
              // Health Check
              get("/health") {
                requestCounter.incrementAndGet()
                call.respond(
                  HttpStatusCode.OK,
                  ServerHealthResponse(
                    status = "ONLINE",
                    institution = "The Gandhigram Rural Institute (Deemed to be University)",
                    backend = "Embedded Ktor 2.3 CIO Engine",
                    serverTime = java.util.Date().toString(),
                    port = port,
                    requestsHandled = requestCounter.get(),
                    activeModules = listOf(
                      "Student Portal",
                      "Academics & Attendance",
                      "Examination & e-SANAD",
                      "Hostel & Transport",
                      "GRI-Care Grievance Redressal",
                      "Cloud Firestore Sync Queue"
                    )
                  )
                )
              }

              // Authentication
              post("/auth/login") {
                requestCounter.incrementAndGet()
                val request = runCatching { call.receive<LoginRequest>() }.getOrNull()
                val role = request?.role ?: "STUDENT"
                val token = "gri_jwt_token_${System.currentTimeMillis()}_${role.lowercase()}"

                val user = database.userDao().getUserByRole(role).first()
                if (user != null) {
                  call.respond(
                    HttpStatusCode.OK,
                    LoginResponse(
                      success = true,
                      token = token,
                      role = user.role,
                      name = user.name,
                      rollNo = user.rollNo,
                      department = user.department,
                      message = "Authenticated successfully as ${user.role}"
                    )
                  )
                } else {
                  call.respond(
                    HttpStatusCode.OK,
                    LoginResponse(
                      success = true,
                      token = token,
                      role = role,
                      name = "Campus User",
                      rollNo = "GRI2026",
                      department = "Rural Development & Tech",
                      message = "Authenticated as $role"
                    )
                  )
                }
              }

              // Hall Ticket / Examination
              get("/examinations/hallticket") {
                requestCounter.incrementAndGet()
                call.respond(
                  HttpStatusCode.OK,
                  HallTicketResponse(
                    hallTicketNo = "HT-2026-NOV-7842",
                    examSession = "November / December 2026",
                    studentName = "Srimari Vijay",
                    registerNumber = "23MCA042",
                    degree = "Master of Computer Applications (MCA)",
                    examinationCenter = "Multipurpose Examination Hall - Block B, GRI Main Campus",
                    sanadVerificationCode = "SANAD-TN-GRI-2026-98124",
                    exams = listOf(
                      ExamScheduleItem("CS501", "Advanced Cloud Computing", "2026-11-24", "FN 10:00 AM - 01:00 PM", "Hall 4 - Desk 12"),
                      ExamScheduleItem("RD402", "Gandhian Reconstruction & Ethics", "2026-11-26", "FN 10:00 AM - 01:00 PM", "Hall 4 - Desk 12"),
                      ExamScheduleItem("CS505", "Distributed Microservices & APIs", "2026-11-29", "AN 02:00 PM - 05:00 PM", "Hall 2 - Desk 05"),
                      ExamScheduleItem("MA301", "Applied Statistical Analytics", "2026-12-02", "FN 10:00 AM - 01:00 PM", "Hall 4 - Desk 12")
                    )
                  )
                )
              }

              // Transport
              get("/transport/routes") {
                requestCounter.incrementAndGet()
                val routes = database.transportDao().getAllRoutes().first()
                call.respond(HttpStatusCode.OK, routes)
              }

              // Grievances
              get("/grievances") {
                requestCounter.incrementAndGet()
                val grievances = database.grievanceDao().getAllGrievances().first()
                call.respond(HttpStatusCode.OK, grievances)
              }

              post("/grievances") {
                requestCounter.incrementAndGet()
                val req = call.receive<GrievanceRequest>()
                val ticketNum = "GRI-${(1000..9999).random()}"
                val entity = GrievanceEntity(
                  ticketNumber = ticketNum,
                  category = req.category,
                  subject = req.subject,
                  description = req.description,
                  status = "PENDING",
                  studentRollNo = req.studentRollNo,
                  createdAt = System.currentTimeMillis()
                )
                val newId = database.grievanceDao().insertGrievance(entity)

                // Enqueue to cloud sync
                database.syncQueueDao().enqueue(
                  SyncQueueEntity(
                    action = "INSERT",
                    entityType = "GRIEVANCE",
                    payloadJson = gson.toJson(entity.copy(id = newId))
                  )
                )

                call.respond(
                  HttpStatusCode.Created,
                  mapOf(
                    "status" to "SUCCESS",
                    "ticketNumber" to ticketNum,
                    "message" to "Complaint registered into GRI Care desk"
                  )
                )
              }

              // Circulars
              get("/circulars") {
                requestCounter.incrementAndGet()
                val circulars = database.circularDao().getAllCirculars().first()
                call.respond(HttpStatusCode.OK, circulars)
              }

              // Trigger Sync
              post("/sync") {
                requestCounter.incrementAndGet()
                val pending = database.syncQueueDao().getPendingSyncItems().first()
                pending.forEach { item ->
                  database.syncQueueDao().markAsSynced(item.id)
                }
                call.respond(
                  HttpStatusCode.OK,
                  mapOf(
                    "status" to "SYNCED",
                    "syncedCount" to pending.size,
                    "timestamp" to System.currentTimeMillis()
                  )
                )
              }
            }
          }
        }
        engine?.start(wait = false)
        isRunning = true
        onStarted()
      } catch (t: Throwable) {
        isRunning = false
        onError(t)
      }
    }
  }

  fun stop() {
    try {
      engine?.stop(1000, 2000)
      engine = null
      isRunning = false
    } catch (_: Exception) {}
  }
}
