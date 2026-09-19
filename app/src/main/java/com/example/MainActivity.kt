package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.DirectionsBus
import androidx.compose.material.icons.filled.Explore
import androidx.compose.material.icons.filled.FolderShared
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.School
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.example.data.local.UserRole
import com.example.ui.GriUiState
import com.example.ui.GriViewModel
import com.example.ui.NavigationTab
import com.example.ui.components.GriLoginDialog
import com.example.ui.components.GriTopBar
import com.example.ui.components.HallTicketDialog
import com.example.ui.screens.AcademicsHubScreen
import com.example.ui.screens.AdminDirectoryScreen
import com.example.ui.screens.AskGriAiScreen
import com.example.ui.screens.CampusFacilitiesScreen
import com.example.ui.screens.FacultyStaffPortalScreen
import com.example.ui.screens.HomeDashboardScreen
import com.example.ui.screens.OfficialDocumentCenterScreen
import com.example.ui.screens.StudentServicesHubScreen
import com.example.ui.theme.GriForestPrimary
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
          onRoleSelected = { viewModel.switchRole(it) },
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
          onVerifyDocument = { viewModel.verifyDocumentAuthenticity(it) }
        )
      }
    }
  }
}

sealed class NavItem(val tab: NavigationTab, val title: String, val icon: ImageVector, val tag: String) {
  object Home : NavItem(NavigationTab.HOME, "Home", Icons.Default.Home, "nav_home")
  object Academics : NavItem(NavigationTab.ACADEMICS, "Academics", Icons.Default.School, "nav_academics")
  object Campus : NavItem(NavigationTab.CAMPUS, "Campus", Icons.Default.Explore, "nav_campus")
  object Services : NavItem(NavigationTab.SERVICES, "Services", Icons.Default.DirectionsBus, "nav_services")
  object More : NavItem(NavigationTab.MORE, "More", Icons.Default.FolderShared, "nav_more")
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
  onVerifyDocument: (String) -> Unit = {}
) {
  val snackbarHostState = remember { SnackbarHostState() }
  var showLoginDialog by remember { mutableStateOf(false) }

  LaunchedEffect(uiState.notificationMessage) {
    uiState.notificationMessage?.let { msg ->
      snackbarHostState.showSnackbar(msg)
      onClearNotification()
    }
  }

  val navItems = listOf(
    NavItem.Home,
    NavItem.Academics,
    NavItem.Campus,
    NavItem.Services,
    NavItem.More
  )

  Scaffold(
    modifier = Modifier.fillMaxSize(),
    contentWindowInsets = WindowInsets(0, 0, 0, 0),
    topBar = {
      GriTopBar(
        currentRole = uiState.currentRole,
        isAuthenticated = uiState.isAuthenticated,
        pendingSyncs = uiState.pendingSyncCount,
        isSyncing = uiState.isSyncing,
        onSignInClick = { showLoginDialog = true },
        onLogoutClick = onLogout,
        onOpenSahayak = { onToggleAskAi(true) },
        onOpenDocumentCenter = { onToggleDocumentCenter(true) },
        onOpenFacultyPortal = { onToggleFacultyPortal(true) },
        onSyncClick = onTriggerSync
      )
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
      when (uiState.currentTab) {
        NavigationTab.HOME -> {
          HomeDashboardScreen(
            uiState = uiState,
            onNavigateToAcademics = { onTabSelected(NavigationTab.ACADEMICS) },
            onNavigateToServices = { onTabSelected(NavigationTab.SERVICES) },
            onNavigateToCampus = { onTabSelected(NavigationTab.CAMPUS) },
            onNavigateToAdmin = { onTabSelected(NavigationTab.MORE) },
            onNavigateToDocuments = { onToggleDocumentCenter(true) },
            onNavigateToFaculty = { onToggleFacultyPortal(true) },
            onFetchHallTicket = onFetchHallTicket,
            onOpenAiSearch = { onToggleAskAi(true) }
          )
        }
        NavigationTab.ACADEMICS -> {
          AcademicsHubScreen(
            uiState = uiState,
            onFetchHallTicket = onFetchHallTicket,
            onMarkAttendance = onMarkAttendance
          )
        }
        NavigationTab.CAMPUS, NavigationTab.EXPLORE -> {
          CampusFacilitiesScreen(
            uiState = uiState
          )
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
