package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.EventNote
import androidx.compose.material.icons.filled.DirectionsBus
import androidx.compose.material.icons.filled.FolderShared
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Public
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.data.local.UserRole
import com.example.ui.GriUiState
import com.example.ui.GriViewModel
import com.example.ui.NavigationTab
import com.example.ui.components.GriLoginDialog
import com.example.ui.components.GriSahayakChatDialog
import com.example.ui.components.GriTopBar
import com.example.ui.components.HallTicketDialog
import com.example.ui.screens.HomeScreen
import com.example.ui.screens.NewsEventsScreen
import com.example.ui.screens.ProfileAndAdminScreen
import com.example.ui.screens.PublicExploreScreen
import com.example.ui.screens.ServicesScreen
import com.example.ui.theme.GriNavyPrimary
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
          onApplyStaffLeave = { type, start, end, reason -> viewModel.applyStaffLeave(type, start, end, reason) }
        )
      }
    }
  }
}

sealed class NavItem(val tab: NavigationTab, val title: String, val icon: ImageVector, val tag: String) {
  object Home : NavItem(NavigationTab.HOME, "Home", Icons.Default.Home, "nav_home")
  object Explore : NavItem(NavigationTab.EXPLORE, "Explore", Icons.Default.Public, "nav_explore")
  object Services : NavItem(NavigationTab.SERVICES, "Services", Icons.Default.DirectionsBus, "nav_services")
  object News : NavItem(NavigationTab.NEWS, "News", Icons.AutoMirrored.Filled.EventNote, "nav_news")
  object Profile : NavItem(NavigationTab.PROFILE, "Profile", Icons.Default.FolderShared, "nav_profile")
}

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
  onApplyStaffLeave: (String, String, String, String) -> Unit
) {
  val snackbarHostState = remember { SnackbarHostState() }
  var showLoginDialog by remember { mutableStateOf(false) }
  var showSahayakDialog by remember { mutableStateOf(false) }

  LaunchedEffect(uiState.notificationMessage) {
    uiState.notificationMessage?.let { msg ->
      snackbarHostState.showSnackbar(msg)
      onClearNotification()
    }
  }

  val navItems = listOf(
    NavItem.Home,
    NavItem.Explore,
    NavItem.Services,
    NavItem.News,
    NavItem.Profile
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
        onOpenSahayak = { showSahayakDialog = true },
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
          val selected = uiState.currentTab == item.tab
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
              selectedIconColor = GriNavyPrimary,
              selectedTextColor = GriNavyPrimary,
              indicatorColor = GriNavyPrimary.copy(alpha = 0.12f),
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
          HomeScreen(
            uiState = uiState,
            onFetchHallTicket = onFetchHallTicket,
            onNavigateToGrievances = { onTabSelected(NavigationTab.SERVICES) },
            onNavigateToServices = { onTabSelected(NavigationTab.SERVICES) },
            onNavigateToAcademics = { onTabSelected(NavigationTab.SERVICES) },
            onMarkCircularRead = onMarkCircularRead
          )
        }
        NavigationTab.EXPLORE -> {
          PublicExploreScreen()
        }
        NavigationTab.SERVICES -> {
          ServicesScreen(
            courses = uiState.courses,
            onMarkAttendance = onMarkAttendance,
            onFetchHallTicket = onFetchHallTicket,
            transportRoutes = uiState.transportRoutes,
            grievances = uiState.grievances,
            userRole = uiState.currentRole,
            onSubmitGrievance = onSubmitGrievance,
            onResolveGrievance = onResolveGrievance
          )
        }
        NavigationTab.NEWS -> {
          NewsEventsScreen(
            circulars = uiState.circulars,
            onMarkCircularRead = onMarkCircularRead
          )
        }
        NavigationTab.PROFILE -> {
          ProfileAndAdminScreen(
            uiState = uiState,
            onToggleServer = onToggleServer,
            onTriggerSync = onTriggerSync,
            onPublishCircular = onPublishCircular,
            onSendNotification = onSendNotification,
            onApplyStaffLeave = onApplyStaffLeave,
            onFetchHallTicket = onFetchHallTicket
          )
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

    // GRI-Sahayak Institutional AI Assistant Modal
    if (showSahayakDialog) {
      GriSahayakChatDialog(
        messages = uiState.sahayakMessages,
        onSendMessage = onSendMessage,
        onDismiss = { showSahayakDialog = false }
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
