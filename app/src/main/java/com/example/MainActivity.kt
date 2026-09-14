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
import androidx.compose.material.icons.filled.DirectionsBus
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.ReportProblem
import androidx.compose.material.icons.filled.School
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
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.data.local.UserRole
import com.example.ui.GriUiState
import com.example.ui.GriViewModel
import com.example.ui.NavigationTab
import com.example.ui.components.GriTopBar
import com.example.ui.components.HallTicketDialog
import com.example.ui.components.RoleSelectorBar
import com.example.ui.screens.AcademicsScreen
import com.example.ui.screens.AdminScreen
import com.example.ui.screens.GrievancesScreen
import com.example.ui.screens.HomeScreen
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
          onClearNotification = { viewModel.clearNotification() }
        )
      }
    }
  }
}

sealed class NavItem(val tab: NavigationTab, val title: String, val icon: ImageVector, val tag: String) {
  object Home : NavItem(NavigationTab.HOME, "Home", Icons.Default.Home, "nav_home")
  object Academics : NavItem(NavigationTab.ACADEMICS, "Academics", Icons.Default.School, "nav_academics")
  object Services : NavItem(NavigationTab.SERVICES, "Services", Icons.Default.DirectionsBus, "nav_services")
  object Grievances : NavItem(NavigationTab.GRIEVANCES, "GRI-Care", Icons.Default.ReportProblem, "nav_grievances")
  object Admin : NavItem(NavigationTab.ADMIN, "Console", Icons.Default.Dns, "nav_admin")
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
  onClearNotification: () -> Unit
) {
  val snackbarHostState = remember { SnackbarHostState() }

  LaunchedEffect(uiState.notificationMessage) {
    uiState.notificationMessage?.let { msg ->
      snackbarHostState.showSnackbar(msg)
      onClearNotification()
    }
  }

  val navItems = listOf(
    NavItem.Home,
    NavItem.Academics,
    NavItem.Services,
    NavItem.Grievances,
    NavItem.Admin
  )

  Scaffold(
    modifier = Modifier.fillMaxSize(),
    contentWindowInsets = WindowInsets(0, 0, 0, 0),
    topBar = {
      Column {
        GriTopBar(
          serverStatus = uiState.ktorServerStatus,
          pendingSyncs = uiState.pendingSyncCount,
          isSyncing = uiState.isSyncing,
          onSyncClick = onTriggerSync
        )
        RoleSelectorBar(
          currentRole = uiState.currentRole,
          onRoleSelected = onRoleSelected
        )
      }
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
      if (uiState.currentRole == UserRole.PUBLIC) {
        PublicExploreScreen()
      } else {
        when (uiState.currentTab) {
          NavigationTab.HOME -> {
            HomeScreen(
              uiState = uiState,
              onFetchHallTicket = onFetchHallTicket,
              onNavigateToGrievances = { onTabSelected(NavigationTab.GRIEVANCES) },
              onNavigateToServices = { onTabSelected(NavigationTab.SERVICES) },
              onNavigateToAcademics = { onTabSelected(NavigationTab.ACADEMICS) },
              onMarkCircularRead = onMarkCircularRead
            )
          }
          NavigationTab.ACADEMICS -> {
            AcademicsScreen(
              courses = uiState.courses,
              onMarkAttendance = onMarkAttendance,
              onFetchHallTicket = onFetchHallTicket
            )
          }
          NavigationTab.SERVICES -> {
            ServicesScreen(
              transportRoutes = uiState.transportRoutes
            )
          }
          NavigationTab.GRIEVANCES -> {
            GrievancesScreen(
              grievances = uiState.grievances,
              userRole = uiState.currentRole,
              onSubmitGrievance = onSubmitGrievance,
              onResolveGrievance = onResolveGrievance
            )
          }
          NavigationTab.ADMIN -> {
            AdminScreen(
              uiState = uiState,
              onToggleServer = onToggleServer,
              onTriggerSync = onTriggerSync
            )
          }
        }
      }
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
fun Greeting(name: String, modifier: Modifier = Modifier) {
  Text(text = "Hello $name!", modifier = modifier)
}
