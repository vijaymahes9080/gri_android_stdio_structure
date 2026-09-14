package com.example.ui

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.backend.GriKtorClient
import com.example.backend.GriKtorServer
import com.example.backend.HallTicketResponse
import com.example.backend.ServerHealthResponse
import com.example.data.local.CircularEntity
import com.example.data.local.CourseEntity
import com.example.data.local.GriDatabase
import com.example.data.local.GrievanceEntity
import com.example.data.local.TransportRouteEntity
import com.example.data.local.UserEntity
import com.example.data.local.UserRole
import com.example.data.repository.GriRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

enum class NavigationTab {
  HOME,
  ACADEMICS,
  SERVICES,
  GRIEVANCES,
  ADMIN
}

data class GriUiState(
  val currentRole: UserRole = UserRole.STUDENT,
  val currentTab: NavigationTab = NavigationTab.HOME,
  val currentUser: UserEntity? = null,
  val courses: List<CourseEntity> = emptyList(),
  val grievances: List<GrievanceEntity> = emptyList(),
  val transportRoutes: List<TransportRouteEntity> = emptyList(),
  val circulars: List<CircularEntity> = emptyList(),
  val pendingSyncCount: Int = 0,
  val ktorServerStatus: String = "Starting...",
  val ktorServerPort: Int = 8080,
  val ktorRequestsCount: Int = 0,
  val hallTicketData: HallTicketResponse? = null,
  val isSyncing: Boolean = false,
  val notificationMessage: String? = null,
  val serverHealth: ServerHealthResponse? = null
)

class GriViewModel(application: Application) : AndroidViewModel(application) {
  private val database = GriDatabase.getDatabase(application)
  private val ktorServer = GriKtorServer(database, port = 8080)
  private val ktorClient = GriKtorClient("http://127.0.0.1:8080/api")
  val repository = GriRepository(database, ktorServer, ktorClient)

  private val _uiState = MutableStateFlow(GriUiState())
  val uiState: StateFlow<GriUiState> = _uiState.asStateFlow()

  init {
    // 1. Start embedded Ktor server on background coroutine
    startKtorServer()

    // 2. Initialize database seeds
    viewModelScope.launch(Dispatchers.IO) {
      repository.initializeAndSeedIfEmpty()
    }

    // 3. Observe Room data streams
    observeDatabaseStreams()

    // 4. Load initial user for STUDENT
    loadUserForRole(UserRole.STUDENT)
  }

  private fun startKtorServer() {
    _uiState.update { it.copy(ktorServerStatus = "INITIALIZING") }
    ktorServer.start(
      onStarted = {
        _uiState.update {
          it.copy(
            ktorServerStatus = "ONLINE (:8080)",
            ktorRequestsCount = ktorServer.requestsHandled
          )
        }
        // Poll health
        viewModelScope.launch {
          val healthResult = ktorClient.checkHealth()
          if (healthResult.isSuccess) {
            _uiState.update { it.copy(serverHealth = healthResult.getOrNull()) }
          }
        }
      },
      onError = { error ->
        _uiState.update {
          it.copy(ktorServerStatus = "LOCAL MODE (${error.message?.take(20) ?: "Offline"})")
        }
      }
    )
  }

  fun toggleKtorServer() {
    if (ktorServer.isRunning) {
      ktorServer.stop()
      _uiState.update { it.copy(ktorServerStatus = "STOPPED") }
    } else {
      startKtorServer()
    }
  }

  private fun observeDatabaseStreams() {
    viewModelScope.launch {
      repository.allCourses.collectLatest { coursesList ->
        _uiState.update { it.copy(courses = coursesList) }
      }
    }

    viewModelScope.launch {
      repository.allGrievances.collectLatest { grievanceList ->
        _uiState.update { it.copy(grievances = grievanceList) }
      }
    }

    viewModelScope.launch {
      repository.allTransportRoutes.collectLatest { routes ->
        _uiState.update { it.copy(transportRoutes = routes) }
      }
    }

    viewModelScope.launch {
      repository.allCirculars.collectLatest { circulars ->
        _uiState.update { it.copy(circulars = circulars) }
      }
    }

    viewModelScope.launch {
      repository.pendingSyncCount.collectLatest { pending ->
        _uiState.update { it.copy(pendingSyncCount = pending.size) }
      }
    }
  }

  private fun loadUserForRole(role: UserRole) {
    viewModelScope.launch {
      repository.getUserByRole(role).collectLatest { user ->
        _uiState.update { it.copy(currentUser = user) }
      }
    }
  }

  fun switchRole(role: UserRole) {
    _uiState.update { it.copy(currentRole = role) }
    loadUserForRole(role)
    // Authenticate with Ktor server
    viewModelScope.launch {
      val loginRes = ktorClient.login(role.name)
      if (loginRes.isSuccess) {
        _uiState.update {
          it.copy(
            ktorRequestsCount = ktorServer.requestsHandled,
            notificationMessage = "Logged in as ${role.name}"
          )
        }
      }
    }
  }

  fun switchTab(tab: NavigationTab) {
    _uiState.update { it.copy(currentTab = tab) }
  }

  fun markAttendance(courseId: String) {
    viewModelScope.launch {
      repository.markAttendance(courseId)
      _uiState.update {
        it.copy(
          notificationMessage = "Attendance updated for $courseId",
          ktorRequestsCount = ktorServer.requestsHandled
        )
      }
    }
  }

  fun submitGrievance(category: String, subject: String, description: String) {
    viewModelScope.launch {
      val roll = _uiState.value.currentUser?.rollNo ?: "GRI2026"
      val ticket = repository.submitGrievance(category, subject, description, roll)
      _uiState.update {
        it.copy(
          notificationMessage = "Complaint registered: $ticket",
          ktorRequestsCount = ktorServer.requestsHandled
        )
      }
    }
  }

  fun resolveGrievance(id: Long, remarks: String) {
    viewModelScope.launch {
      repository.resolveGrievance(id, remarks)
      _uiState.update {
        it.copy(notificationMessage = "Grievance #$id status updated to RESOLVED")
      }
    }
  }

  fun fetchHallTicket() {
    viewModelScope.launch {
      val res = ktorClient.getHallTicket()
      if (res.isSuccess) {
        _uiState.update {
          it.copy(
            hallTicketData = res.getOrNull(),
            notificationMessage = "Hall ticket verified via e-SANAD",
            ktorRequestsCount = ktorServer.requestsHandled
          )
        }
      }
    }
  }

  fun clearHallTicket() {
    _uiState.update { it.copy(hallTicketData = null) }
  }

  fun markCircularRead(id: String) {
    viewModelScope.launch {
      repository.markCircularRead(id)
    }
  }

  fun triggerCloudSync() {
    viewModelScope.launch {
      _uiState.update { it.copy(isSyncing = true) }
      val result = repository.performCloudSync()
      _uiState.update {
        it.copy(
          isSyncing = false,
          ktorRequestsCount = ktorServer.requestsHandled,
          notificationMessage = if (result.isSuccess) {
            "Cloud sync successful (${result.getOrDefault(0)} records synchronized with Firestore)"
          } else {
            "Local queue saved. Cloud sync offline."
          }
        )
      }
    }
  }

  fun clearNotification() {
    _uiState.update { it.copy(notificationMessage = null) }
  }

  override fun onCleared() {
    super.onCleared()
    ktorServer.stop()
    ktorClient.close()
  }
}
