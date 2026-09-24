package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AdminPanelSettings
import androidx.compose.material.icons.filled.AppRegistration
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Domain
import androidx.compose.material.icons.filled.FactCheck
import androidx.compose.material.icons.filled.GridView
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.HourglassTop
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.Science
import androidx.compose.material.icons.filled.SwitchAccount
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.example.data.local.AccountStatus
import com.example.data.local.InstitutionalPermission
import com.example.data.local.RegistrationApplication
import com.example.data.local.UserEntity
import com.example.data.local.UserRole
import com.example.ui.GriUiState
import com.example.ui.GriViewModel
import com.example.ui.NavigationTab
import com.example.ui.components.GriLoginDialog
import com.example.ui.components.GriTopBar
import com.example.ui.components.HallTicketDialog
import com.example.ui.screens.AcademicsHubScreen
import com.example.ui.screens.AdminApprovalCenterScreen
import com.example.ui.screens.AdminDirectoryScreen
import com.example.ui.screens.AdminReviewDialog
import com.example.ui.screens.ApplicationStatusScreen
import com.example.ui.screens.AskGriAiScreen
import com.example.ui.screens.AuthorizedRoleSwitcherDialog
import com.example.ui.screens.CampusFacilitiesScreen
import com.example.ui.screens.FacultyStaffPortalScreen
import com.example.ui.screens.HomeDashboardScreen
import com.example.ui.screens.OfficialDocumentCenterScreen
import com.example.ui.screens.RegistrationWizardDialog
import com.example.ui.screens.StudentServicesHubScreen
import com.example.ui.theme.GriError
import com.example.ui.theme.GriForestPrimary
import com.example.ui.theme.GriOchreOnContainer
import com.example.ui.theme.GriOnSurfaceVariant
import com.example.ui.theme.GriSuccess
import com.example.ui.theme.MyApplicationTheme

class MainActivity : ComponentActivity() {
  private val viewModel: GriViewModel by viewModels()

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    enableEdgeToEdge()
    setContent {
      MyApplicationTheme {
        val uiState by viewModel.uiState.collectAsState()
        GriApp(
          uiState = uiState,
          onRoleSelected = { viewModel.switchAuthorizedRole(it) },
          onTabSelected = { viewModel.switchTab(it) },
          onMarkAttendance = { viewModel.markAttendance(it) },
          onFetchHallTicket = { viewModel.fetchHallTicket() },
          onClearHallTicket = { viewModel.clearHallTicket() },
          onSubmitGrievance = { cat, sub, desc -> viewModel.submitGrievance(cat, sub, desc) },
          onResolveGrievance = { id, remarks -> viewModel.resolveGrievance(id, remarks) },
          onToggleServer = { viewModel.toggleKtorServer() },
          onTriggerSync = { viewModel.triggerCloudSync() },
          onMarkCircularRead = { viewModel.markCircularRead(it) },
          onPublishCircular = { title, cat, sum, isUrg, issuedBy -> viewModel.publishCircular(title, cat, sum, isUrg, issuedBy) },
          onSendNotification = { title, msg, aud -> viewModel.sendNotification(title, msg, aud) },
          onClearNotification = { viewModel.clearNotification() },
          onLogin = { role, id -> viewModel.loginAsRole(role, id) },
          onLogout = { viewModel.logout() },
          onSendMessage = { query -> viewModel.sendSahayakMessage(query) },
          onApplyStaffLeave = { type, start, end, reason -> viewModel.applyStaffLeave(type, start, end, reason) },
          onToggleDocumentCenter = { viewModel.toggleDocumentCenter(it) },
          onToggleFacultyPortal = { viewModel.toggleFacultyPortal(it) },
          onToggleAskAi = { viewModel.toggleAskAi(it) },
          onVerifyDocument = { viewModel.verifyDocumentAuthenticity(it) },
          // Institutional Authentication & Approval Callbacks
          onSwitchAccount = { viewModel.switchUserAccount(it) },
          onOpenRegister = { viewModel.openRegistrationWizard() },
          onCloseRegister = { viewModel.closeRegistrationWizard() },
          onSubmitRegistration = { name, email, phone, id, role, dept, prog, yr, des, res ->
            viewModel.submitRegistrationApplication(name, email, phone, id, role, dept, prog, yr, des, res)
          },
          onSubmitClarification = { id, text -> viewModel.submitApplicantClarification(id, text) },
          onOpenAdminReview = { viewModel.openAdminReviewModal(it) },
          onCloseAdminReview = { viewModel.closeAdminReviewModal() },
          onAdminApprove = { viewModel.adminApproveApplication(it) },
          onAdminReject = { id, reason -> viewModel.adminRejectApplication(id, reason) },
          onAdminRequestInfo = { id, query -> viewModel.adminRequestMoreInformation(id, query) },
          onToggleRoleSwitcher = { viewModel.toggleRoleSwitcher(it) },
          onFilterChange = { viewModel.setApplicationFilter(it) },
          onSearchChange = { viewModel.setApplicationSearchQuery(it) }
        )
      }
    }
  }
}

sealed class NavItem(val tab: NavigationTab, val title: String, val icon: ImageVector, val tag: String) {
  object Home : NavItem(NavigationTab.HOME, "Home", Icons.Default.Home, "nav_home")
  object Academics : NavItem(NavigationTab.ACADEMICS, "Academics", Icons.Default.School, "nav_academics")
  object Approvals : NavItem(NavigationTab.APPROVALS, "Approvals", Icons.Default.FactCheck, "nav_approvals")
  object Exams : NavItem(NavigationTab.EXAMS, "Exams", Icons.Default.FactCheck, "nav_exams")
  object Research : NavItem(NavigationTab.RESEARCH, "Research", Icons.Default.Science, "nav_research")
  object Status : NavItem(NavigationTab.STATUS, "App Status", Icons.Default.HourglassTop, "nav_status")
  object Campus : NavItem(NavigationTab.CAMPUS, "Campus", Icons.Default.Domain, "nav_campus")
  object Services : NavItem(NavigationTab.SERVICES, "Services", Icons.Default.GridView, "nav_services")
  object More : NavItem(NavigationTab.MORE, "More", Icons.Default.Menu, "nav_more")
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GriApp(
  uiState: GriUiState,
  onRoleSelected: (UserRole) -> Unit,
  onTabSelected: (NavigationTab) -> Unit,
  onMarkAttendance: (String) -> Unit,
  onFetchHallTicket: () -> Unit,
  onClearHallTicket: () -> Unit,
  onSubmitGrievance: (String, String, String) -> Unit,
  onResolveGrievance: (Long, String) -> Unit,
  onToggleServer: () -> Unit,
  onTriggerSync: () -> Unit,
  onMarkCircularRead: (String) -> Unit,
  onPublishCircular: (String, String, String, Boolean, String) -> Unit,
  onSendNotification: (String, String, String) -> Unit,
  onClearNotification: () -> Unit,
  onLogin: (UserRole, String) -> Unit,
  onLogout: () -> Unit,
  onSendMessage: (String) -> Unit,
  onApplyStaffLeave: (String, String, String, String) -> Unit,
  onToggleDocumentCenter: (Boolean) -> Unit = {},
  onToggleFacultyPortal: (Boolean) -> Unit = {},
  onToggleAskAi: (Boolean) -> Unit = {},
  onVerifyDocument: (String) -> Unit = {},
  // Institutional callbacks
  onSwitchAccount: (UserEntity) -> Unit = {},
  onOpenRegister: () -> Unit = {},
  onCloseRegister: () -> Unit = {},
  onSubmitRegistration: (String, String, String, String, UserRole, String, String, String, String, String) -> Unit = { _, _, _, _, _, _, _, _, _, _ -> },
  onSubmitClarification: (String, String) -> Unit = { _, _ -> },
  onOpenAdminReview: (RegistrationApplication) -> Unit = {},
  onCloseAdminReview: () -> Unit = {},
  onAdminApprove: (String) -> Unit = {},
  onAdminReject: (String, String) -> Unit = { _, _ -> },
  onAdminRequestInfo: (String, String) -> Unit = { _, _ -> },
  onToggleRoleSwitcher: (Boolean) -> Unit = {},
  onFilterChange: (String) -> Unit = {},
  onSearchChange: (String) -> Unit = {}
) {
  val snackbarHostState = remember { SnackbarHostState() }
  var showLoginDialog by remember { mutableStateOf(false) }

  LaunchedEffect(uiState.notificationMessage) {
    uiState.notificationMessage?.let { msg ->
      snackbarHostState.showSnackbar(msg)
      onClearNotification()
    }
  }

  val currentUser = uiState.currentUser
  val isApproved = uiState.activeAccountStatus == AccountStatus.APPROVED

  // Dynamic Navigation Items based on actual role & permissions
  val navItems = when {
    !isApproved -> listOf(
      NavItem.Status,
      NavItem.Campus,
      NavItem.More
    )
    uiState.currentRole == UserRole.ADMIN || uiState.currentRole == UserRole.SUPER_ADMIN -> listOf(
      NavItem.Home,
      NavItem.Approvals,
      NavItem.Academics,
      NavItem.Services,
      NavItem.More
    )
    uiState.currentRole == UserRole.COE_STAFF -> listOf(
      NavItem.Home,
      NavItem.Exams,
      NavItem.Academics,
      NavItem.Services,
      NavItem.More
    )
    uiState.currentRole == UserRole.SCHOLAR -> listOf(
      NavItem.Home,
      NavItem.Research,
      NavItem.Academics,
      NavItem.Services,
      NavItem.More
    )
    uiState.currentRole == UserRole.FACULTY -> listOf(
      NavItem.Home,
      NavItem.Academics,
      NavItem.Services,
      NavItem.Campus,
      NavItem.More
    )
    else -> listOf(
      NavItem.Home,
      NavItem.Academics,
      NavItem.Campus,
      NavItem.Services,
      NavItem.More
    )
  }

  Scaffold(
    modifier = Modifier.fillMaxSize(),
    contentWindowInsets = WindowInsets(0, 0, 0, 0),
    topBar = {
      Column(modifier = Modifier.background(MaterialTheme.colorScheme.surface)) {
        GriTopBar(
          currentRole = uiState.currentRole,
          isAuthenticated = uiState.isAuthenticated,
          pendingSyncs = uiState.pendingSyncCount,
          isSyncing = uiState.isSyncing,
          onSignInClick = { onToggleRoleSwitcher(true) },
          onLogoutClick = onLogout,
          onOpenSahayak = { onToggleAskAi(true) },
          onOpenDocumentCenter = { onToggleDocumentCenter(true) },
          onOpenFacultyPortal = { onToggleFacultyPortal(true) },
          onSyncClick = onTriggerSync
        )

        // Institutional Workflow Bar: Account Selector & Registration Trigger
        Surface(
          color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f),
          modifier = Modifier.fillMaxWidth()
        ) {
          Row(
            modifier = Modifier
              .fillMaxWidth()
              .horizontalScroll(rememberScrollState())
              .padding(horizontal = 12.dp, vertical = 6.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
          ) {
            // Role & Multi-Role Chip
            Surface(
              shape = RoundedCornerShape(999.dp),
              color = GriForestPrimary,
              modifier = Modifier
                .clickable { onToggleRoleSwitcher(true) }
                .testTag("chip_current_role")
            ) {
              Row(
                modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp),
                verticalAlignment = Alignment.CenterVertically
              ) {
                Icon(
                  imageVector = Icons.Default.SwitchAccount,
                  contentDescription = null,
                  tint = Color.White,
                  modifier = Modifier.size(14.dp)
                )
                Spacer(modifier = Modifier.width(4.dp))
                Text(
                  text = "${uiState.currentRole.name} • ${uiState.activeAccountStatus.name}",
                  color = Color.White,
                  fontSize = 11.sp,
                  fontWeight = FontWeight.Bold
                )
              }
            }

            // Register Account Button
            Button(
              onClick = onOpenRegister,
              shape = RoundedCornerShape(999.dp),
              colors = ButtonDefaults.buttonColors(containerColor = GriOchreOnContainer),
              contentPadding = androidx.compose.foundation.layout.PaddingValues(horizontal = 10.dp, vertical = 2.dp),
              modifier = Modifier
                .height(28.dp)
                .testTag("btn_top_register")
            ) {
              Icon(Icons.Default.AppRegistration, contentDescription = null, modifier = Modifier.size(13.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text("+ Register", fontSize = 11.sp, fontWeight = FontWeight.Bold)
            }

            // Quick Institutional Account Switchers for demonstration of real workflows
            InstitutionalAccountChip("Admin (Registrar)", uiState.currentUser?.role == "ADMIN") {
              onSwitchAccount(
                UserEntity(
                  id = "usr_admin",
                  name = "Dr. M. Sangeetha",
                  email = "registrar@ruraluniv.ac.in",
                  role = UserRole.ADMIN.name,
                  rollNo = "ADMIN-GRI-01",
                  department = "Central Administration",
                  semester = "Registrar's Directorate",
                  cgpa = "Chief Institutional Officer",
                  accountStatus = AccountStatus.APPROVED.name,
                  approvedRolesCsv = "ADMIN"
                )
              )
            }

            InstitutionalAccountChip("Faculty (Multi-Role)", uiState.currentUser?.id == "usr_faculty") {
              onSwitchAccount(
                UserEntity(
                  id = "usr_faculty",
                  name = "Dr. R. Subramanian",
                  email = "r.subramanian@ruraluniv.ac.in",
                  role = UserRole.FACULTY.name,
                  rollNo = "FAC-CS-108",
                  department = "School of Sciences & Rural Technology",
                  semester = "Senior Associate Professor",
                  cgpa = "Ph.D. IIT Madras",
                  accountStatus = AccountStatus.APPROVED.name,
                  approvedRolesCsv = "FACULTY,SCHOLAR"
                )
              )
            }

            InstitutionalAccountChip("Student (Vijay)", uiState.currentUser?.id == "usr_student") {
              onSwitchAccount(
                UserEntity(
                  id = "usr_student",
                  name = "Vijay Pradhap",
                  email = "vijay.p24@ruraluniv.ac.in",
                  role = UserRole.STUDENT.name,
                  rollNo = "2024-MS-4011",
                  department = "Computer Science & Applications",
                  semester = "Semester IV",
                  cgpa = "8.92",
                  accountStatus = AccountStatus.APPROVED.name,
                  approvedRolesCsv = "STUDENT"
                )
              )
            }

            InstitutionalAccountChip("Applicant (Pending)", uiState.currentUser?.accountStatus == AccountStatus.PENDING_APPROVAL.name) {
              onSwitchAccount(
                UserEntity(
                  id = "usr_pending",
                  name = "Kavitha Mohan",
                  email = "kavitha.m26@ruraluniv.ac.in",
                  role = UserRole.GUEST.name,
                  rollNo = "2026-MA-8821",
                  department = "Department of Rural Development",
                  semester = "Applicant",
                  cgpa = "Pending",
                  accountStatus = AccountStatus.PENDING_APPROVAL.name,
                  approvedRolesCsv = "GUEST",
                  requestedRole = "STUDENT",
                  applicationId = "APP-2026-9042"
                )
              )
            }

            InstitutionalAccountChip("Applicant (In Review)", uiState.currentUser?.accountStatus == AccountStatus.UNDER_REVIEW.name) {
              onSwitchAccount(
                UserEntity(
                  id = "usr_review",
                  name = "Arun Kumar",
                  email = "arun.agri26@ruraluniv.ac.in",
                  role = UserRole.GUEST.name,
                  rollNo = "2026-PHD-AGR-05",
                  department = "School of Agriculture & Rural Innovation",
                  semester = "Applicant (Under Review)",
                  cgpa = "Under Review",
                  accountStatus = AccountStatus.UNDER_REVIEW.name,
                  approvedRolesCsv = "GUEST",
                  requestedRole = "SCHOLAR",
                  applicationId = "APP-2026-8819",
                  adminClarificationQuery = "Please upload or provide your PG Degree Provisional Certificate register number."
                )
              )
            }
          }
        }
      }
    },
    bottomBar = {
      NavigationBar(
        containerColor = MaterialTheme.colorScheme.surface,
        tonalElevation = 4.dp,
        modifier = Modifier.testTag("bottom_navigation_bar")
      ) {
        navItems.forEach { item ->
          val selected = when (item.tab) {
            NavigationTab.HOME -> uiState.currentTab == NavigationTab.HOME
            NavigationTab.ACADEMICS -> uiState.currentTab == NavigationTab.ACADEMICS
            NavigationTab.APPROVALS -> uiState.currentTab == NavigationTab.APPROVALS
            NavigationTab.EXAMS -> uiState.currentTab == NavigationTab.EXAMS
            NavigationTab.RESEARCH -> uiState.currentTab == NavigationTab.RESEARCH
            NavigationTab.STATUS -> uiState.currentTab == NavigationTab.STATUS
            NavigationTab.CAMPUS -> uiState.currentTab == NavigationTab.CAMPUS || uiState.currentTab == NavigationTab.EXPLORE
            NavigationTab.SERVICES -> uiState.currentTab == NavigationTab.SERVICES
            NavigationTab.MORE -> uiState.currentTab == NavigationTab.MORE || uiState.currentTab == NavigationTab.PROFILE || uiState.currentTab == NavigationTab.NEWS
            else -> false
          }

          NavigationBarItem(
            selected = selected,
            onClick = { onTabSelected(item.tab) },
            icon = { Icon(item.icon, contentDescription = item.title) },
            label = {
              Text(
                item.title,
                style = MaterialTheme.typography.labelMedium,
                fontWeight = if (selected) FontWeight.Bold else FontWeight.Medium
              )
            },
            colors = NavigationBarItemDefaults.colors(
              selectedIconColor = GriForestPrimary,
              selectedTextColor = GriForestPrimary,
              indicatorColor = GriForestPrimary.copy(alpha = 0.12f),
              unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
              unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant
            ),
            modifier = Modifier.testTag(item.tag)
          )
        }
      }
    },
    snackbarHost = { SnackbarHost(snackbarHostState) }
  ) { innerPadding ->
    Column(
      modifier = Modifier
        .fillMaxSize()
        .padding(innerPadding)
    ) {
      // If user status is not approved, show ApplicationStatusScreen
      if (!isApproved) {
        ApplicationStatusScreen(
          uiState = uiState,
          onSubmitClarification = onSubmitClarification,
          onOpenPortal = { onTabSelected(NavigationTab.HOME) }
        )
      } else {
        when (uiState.currentTab) {
          NavigationTab.HOME -> {
            HomeDashboardScreen(
              uiState = uiState,
              onNavigateToAcademics = { onTabSelected(NavigationTab.ACADEMICS) },
              onNavigateToServices = { onTabSelected(NavigationTab.SERVICES) },
              onNavigateToCampus = { onTabSelected(NavigationTab.CAMPUS) },
              onNavigateToAdmin = {
                if (uiState.currentRole == UserRole.ADMIN) {
                  onTabSelected(NavigationTab.APPROVALS)
                } else {
                  onTabSelected(NavigationTab.MORE)
                }
              },
              onNavigateToDocuments = { onToggleDocumentCenter(true) },
              onNavigateToFaculty = { onToggleFacultyPortal(true) },
              onFetchHallTicket = onFetchHallTicket,
              onOpenAiSearch = { onToggleAskAi(true) }
            )
          }
          NavigationTab.APPROVALS -> {
            AdminApprovalCenterScreen(
              uiState = uiState,
              onOpenReview = onOpenAdminReview,
              onFilterChange = onFilterChange,
              onSearchChange = onSearchChange
            )
          }
          NavigationTab.ACADEMICS, NavigationTab.EXAMS -> {
            AcademicsHubScreen(
              uiState = uiState,
              onFetchHallTicket = onFetchHallTicket,
              onMarkAttendance = onMarkAttendance
            )
          }
          NavigationTab.RESEARCH -> {
            OfficialDocumentCenterScreen(
              uiState = uiState,
              onVerifyAuthenticity = onVerifyDocument
            )
          }
          NavigationTab.STATUS -> {
            ApplicationStatusScreen(
              uiState = uiState,
              onSubmitClarification = onSubmitClarification,
              onOpenPortal = { onTabSelected(NavigationTab.HOME) }
            )
          }
          NavigationTab.CAMPUS, NavigationTab.EXPLORE -> {
            CampusFacilitiesScreen(uiState = uiState)
          }
          NavigationTab.SERVICES -> {
            StudentServicesHubScreen(
              uiState = uiState,
              onSubmitGrievance = { title, cat, desc, _ -> onSubmitGrievance(cat, title, desc) },
              onResolveGrievance = { id -> onResolveGrievance(id.toLongOrNull() ?: 1L, "Resolved by Admin") },
              onNavigateToDocuments = { onToggleDocumentCenter(true) }
            )
          }
          NavigationTab.MORE, NavigationTab.PROFILE -> {
            AdminDirectoryScreen(
              uiState = uiState,
              onRoleSelected = onRoleSelected,
              onTriggerSync = onTriggerSync,
              onToggleServer = onToggleServer,
              onPublishCircular = onPublishCircular
            )
          }
          NavigationTab.NEWS -> {
            OfficialDocumentCenterScreen(
              uiState = uiState,
              onVerifyAuthenticity = onVerifyDocument
            )
          }
        }
      }
    }

    // Modal: Registration Wizard
    if (uiState.isRegistrationWizardOpen) {
      RegistrationWizardDialog(
        onDismiss = onCloseRegister,
        onSubmit = { n, e, m, i, r, d, p, y, des, res ->
          onSubmitRegistration(n, e, m, i, r, d, p, y, des, res)
        }
      )
    }

    // Modal: Authorized Multi-Role Switcher
    if (uiState.isRoleSwitcherOpen) {
      AuthorizedRoleSwitcherDialog(
        currentUser = uiState.currentUser,
        currentRole = uiState.currentRole,
        onDismiss = { onToggleRoleSwitcher(false) },
        onRoleSelected = { role ->
          onRoleSelected(role)
          onToggleRoleSwitcher(false)
        }
      )
    }

    // Modal: Admin Review Dossier
    if (uiState.isAdminReviewOpen && uiState.selectedApplication != null) {
      AdminReviewDialog(
        app = uiState.selectedApplication,
        onDismiss = onCloseAdminReview,
        onApprove = { onAdminApprove(uiState.selectedApplication.id) },
        onReject = { reason -> onAdminReject(uiState.selectedApplication.id, reason) },
        onRequestInfo = { query -> onAdminRequestInfo(uiState.selectedApplication.id, query) }
      )
    }

    // Modal: Ask GRI AI Screen
    if (uiState.isAskAiOpen) {
      Dialog(
        onDismissRequest = { onToggleAskAi(false) },
        properties = DialogProperties(usePlatformDefaultWidth = false)
      ) {
        Surface(
          modifier = Modifier.fillMaxSize(),
          color = MaterialTheme.colorScheme.surface
        ) {
          Column(modifier = Modifier.fillMaxSize()) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Text("GRI-Sahayak AI Assistant", fontSize = 16.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
              IconButton(onClick = { onToggleAskAi(false) }) {
                Icon(Icons.Default.Close, contentDescription = "Close AI Assistant")
              }
            }
            AskGriAiScreen(
              uiState = uiState,
              onSendQuery = onSendMessage,
              onNavigateToDocuments = {
                onToggleAskAi(false)
                onToggleDocumentCenter(true)
              }
            )
          }
        }
      }
    }

    // Modal: Official Document Center
    if (uiState.isDocumentCenterOpen) {
      Dialog(
        onDismissRequest = { onToggleDocumentCenter(false) },
        properties = DialogProperties(usePlatformDefaultWidth = false)
      ) {
        Surface(
          modifier = Modifier.fillMaxSize(),
          color = MaterialTheme.colorScheme.surface
        ) {
          Column(modifier = Modifier.fillMaxSize()) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Text("Official Document Center", fontSize = 16.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
              IconButton(onClick = { onToggleDocumentCenter(false) }) {
                Icon(Icons.Default.Close, contentDescription = "Close Document Center")
              }
            }
            OfficialDocumentCenterScreen(
              uiState = uiState,
              onVerifyAuthenticity = onVerifyDocument
            )
          }
        }
      }
    }

    // Modal: Faculty & Staff Portal
    if (uiState.isFacultyPortalOpen) {
      Dialog(
        onDismissRequest = { onToggleFacultyPortal(false) },
        properties = DialogProperties(usePlatformDefaultWidth = false)
      ) {
        Surface(
          modifier = Modifier.fillMaxSize(),
          color = MaterialTheme.colorScheme.surface
        ) {
          Column(modifier = Modifier.fillMaxSize()) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Text("Faculty & Staff Academic Portal", fontSize = 16.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
              IconButton(onClick = { onToggleFacultyPortal(false) }) {
                Icon(Icons.Default.Close, contentDescription = "Close Faculty Portal")
              }
            }
            FacultyStaffPortalScreen(
              uiState = uiState,
              onMarkAttendance = onMarkAttendance,
              onApplyLeave = { onApplyStaffLeave("Casual Leave", "Today", "Tomorrow", "National Seminar") }
            )
          }
        }
      }
    }

    // Official Secure Login Dialog
    if (showLoginDialog) {
      GriLoginDialog(
        onDismiss = { showLoginDialog = false },
        onLogin = { role, id ->
          onLogin(role, id)
          showLoginDialog = false
        }
      )
    }

    // Modal dialog for Examination Hall Ticket
    uiState.hallTicketData?.let { ticket ->
      HallTicketDialog(
        ticket = ticket,
        onDismiss = onClearHallTicket
      )
    }
  }
}

@Composable
fun InstitutionalAccountChip(
  label: String,
  isSelected: Boolean,
  onClick: () -> Unit
) {
  Surface(
    shape = RoundedCornerShape(999.dp),
    color = if (isSelected) GriForestPrimary.copy(alpha = 0.15f) else MaterialTheme.colorScheme.surface,
    border = BorderStroke(
      if (isSelected) 1.5.dp else 1.dp,
      if (isSelected) GriForestPrimary else MaterialTheme.colorScheme.outlineVariant
    ),
    modifier = Modifier
      .clickable(onClick = onClick)
      .height(28.dp)
  ) {
    Row(
      modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp),
      verticalAlignment = Alignment.CenterVertically
    ) {
      Text(
        text = label,
        style = MaterialTheme.typography.labelSmall,
        fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
        color = if (isSelected) GriForestPrimary else MaterialTheme.colorScheme.onSurface,
        fontSize = 11.sp
      )
    }
  }
}
