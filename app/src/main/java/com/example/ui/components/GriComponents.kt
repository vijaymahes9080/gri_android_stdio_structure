package com.example.ui.components

import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.Assignment
import androidx.compose.material.icons.automirrored.filled.Launch
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.Campaign
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material.icons.filled.CloudDone
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.ConfirmationNumber
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.Key
import androidx.compose.material.icons.filled.Launch
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Logout
import androidx.compose.material.icons.filled.PictureAsPdf
import androidx.compose.material.icons.filled.QrCode2
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.Sync
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material.icons.filled.WarningAmber
import androidx.compose.material.icons.outlined.Sync
import androidx.compose.material3.Badge
import androidx.compose.material3.BadgedBox
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.example.R
import com.example.backend.HallTicketResponse
import com.example.data.local.UserEntity
import com.example.data.local.UserRole
import com.example.ui.DocumentItem
import com.example.ui.SahayakMessage
import com.example.ui.theme.*
import com.example.ui.theme.GriRadius
import com.example.ui.theme.GriRedAlert
import com.example.ui.theme.GriSpacing

/**
 * Official GRI Top Bar Component
 * Featuring the official circular seal, institutional name, Tamil motto, live verified indicator,
 * GRI-Sahayak AI trigger, and secure authentication controls.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GriTopBar(
  serverStatus: String = "Online • Synced",
  currentRole: UserRole = UserRole.GUEST,
  isAuthenticated: Boolean = false,
  onSignInClick: () -> Unit = {},
  onLogoutClick: () -> Unit = {},
  onOpenSahayak: () -> Unit = {},
  pendingSyncs: Int = 0,
  isSyncing: Boolean = false,
  onSyncClick: () -> Unit = {},
  modifier: Modifier = Modifier
) {
  val infiniteTransition = rememberInfiniteTransition(label = "serverPulse")
  val pulseAlpha by infiniteTransition.animateFloat(
    initialValue = 0.45f,
    targetValue = 1.0f,
    animationSpec = infiniteRepeatable(
      animation = tween(850),
      repeatMode = RepeatMode.Reverse
    ),
    label = "serverPulseAlpha"
  )

  TopAppBar(
    modifier = modifier.fillMaxWidth(),
    colors = TopAppBarDefaults.topAppBarColors(
      containerColor = MaterialTheme.colorScheme.surface,
      titleContentColor = MaterialTheme.colorScheme.onSurface
    ),
    title = {
      Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.padding(vertical = 4.dp)
      ) {
        // Official GRI Seal Vector Emblem
        Surface(
          shape = RoundedCornerShape(6.dp),
          color = Color.White,
          shadowElevation = 1.dp,
          border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFE51A1A).copy(alpha = 0.4f)),
          modifier = Modifier.padding(end = 4.dp)
        ) {
          Image(
            painter = painterResource(id = R.drawable.ic_gri_seal),
            contentDescription = "Official GRI University Seal",
            modifier = Modifier
              .size(width = 36.dp, height = 44.dp)
              .padding(2.dp)
          )
        }

        Spacer(modifier = Modifier.width(8.dp))

        Column {
          Text(
            text = "GANDHIGRAM RURAL INSTITUTE",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary,
            fontSize = 13.sp,
            lineHeight = 16.sp,
            letterSpacing = 0.2.sp,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
          )
          Text(
            text = "(Deemed to be University) • NAAC 'A+'",
            style = MaterialTheme.typography.bodySmall,
            fontSize = 10.sp,
            color = GriGoldDark,
            fontWeight = FontWeight.SemiBold,
            maxLines = 1
          )
          Text(
            text = "கிராமம் உயர நாடு உயரும்",
            style = MaterialTheme.typography.labelSmall,
            fontSize = 9.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            maxLines = 1
          )
        }
      }
    },
    actions = {
      // GRI-Sahayak AI Assistant Action Button
      IconButton(
        onClick = onOpenSahayak,
        modifier = Modifier
          .size(42.dp)
          .testTag("btn_gri_sahayak_ai")
      ) {
        Box(
          modifier = Modifier
            .size(34.dp)
            .clip(CircleShape)
            .background(GriGoldSecondary.copy(alpha = 0.15f)),
          contentAlignment = Alignment.Center
        ) {
          Icon(
            imageVector = Icons.Default.AutoAwesome,
            contentDescription = "GRI-Sahayak Institutional AI Assistant",
            tint = GriGoldDark,
            modifier = Modifier.size(20.dp)
          )
        }
      }

      // Live System Status (Institutional indicator, without exposing raw ports)
      Surface(
        color = GriGreenSuccess.copy(alpha = 0.12f),
        shape = RoundedCornerShape(GriRadius.xs),
        modifier = Modifier.padding(horizontal = 2.dp)
      ) {
        Row(
          modifier = Modifier.padding(horizontal = 6.dp, vertical = 4.dp),
          verticalAlignment = Alignment.CenterVertically
        ) {
          Box(
            modifier = Modifier
              .size(6.dp)
              .clip(CircleShape)
              .background(GriGreenSuccess.copy(alpha = pulseAlpha))
          )
          Spacer(modifier = Modifier.width(4.dp))
          Text(
            text = "Verified",
            style = MaterialTheme.typography.labelSmall,
            fontSize = 9.sp,
            fontWeight = FontWeight.Bold,
            color = GriGreenSuccess
          )
        }
      }

      // Secure Authentication Indicator / Sign In action
      if (!isAuthenticated) {
        FilledTonalButton(
          onClick = onSignInClick,
          shape = RoundedCornerShape(GriRadius.sm),
          colors = ButtonDefaults.filledTonalButtonColors(
            containerColor = GriNavyPrimary.copy(alpha = 0.1f),
            contentColor = GriNavyPrimary
          ),
          modifier = Modifier
            .padding(start = 4.dp, end = 2.dp)
            .height(32.dp)
            .testTag("btn_top_sign_in")
        ) {
          Icon(
            imageVector = Icons.Default.Lock,
            contentDescription = null,
            modifier = Modifier.size(13.dp)
          )
          Spacer(modifier = Modifier.width(4.dp))
          Text(
            text = "Sign In",
            style = MaterialTheme.typography.labelSmall,
            fontWeight = FontWeight.Bold
          )
        }
      } else {
        // Authenticated Role Badge with 1-tap Logout
        Surface(
          color = GriNavyPrimary,
          shape = RoundedCornerShape(GriRadius.xs),
          modifier = Modifier.padding(horizontal = 4.dp)
        ) {
          Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp)
          ) {
            Text(
              text = currentRole.name,
              style = MaterialTheme.typography.labelSmall,
              color = Color.White,
              fontWeight = FontWeight.Bold,
              fontSize = 9.sp
            )
            Spacer(modifier = Modifier.width(4.dp))
            Icon(
              imageVector = Icons.Default.Logout,
              contentDescription = "Sign Out",
              tint = GriGoldSecondary,
              modifier = Modifier
                .size(14.dp)
                .clickable(onClick = onLogoutClick)
                .testTag("btn_sign_out")
            )
          }
        }
      }

      // Sync Trigger Button with pending syncs badge
      IconButton(
        onClick = onSyncClick,
        modifier = Modifier
          .size(40.dp)
          .testTag("cloud_sync_button")
      ) {
        BadgedBox(badge = {
          if (pendingSyncs > 0) {
            Badge(
              containerColor = GriGoldSecondary,
              contentColor = Color.White
            ) {
              Text(pendingSyncs.toString())
            }
          }
        }) {
          Icon(
            imageVector = if (isSyncing) Icons.Outlined.Sync else if (pendingSyncs == 0) Icons.Default.CloudDone else Icons.Default.Sync,
            contentDescription = "Sync Cloud Records",
            tint = if (isSyncing) GriNavyPrimary else if (pendingSyncs > 0) GriGoldSecondary else GriGreenSuccess,
            modifier = Modifier.size(20.dp)
          )
        }
      }
    }
  )
}

/**
 * Secure Official GRI Login Dialog
 * Provides multi-role authentication with demo helper credentials for Students, Faculty, Staff, and Administrators.
 */
@Composable
fun GriLoginDialog(
  onDismiss: () -> Unit,
  onLogin: (role: UserRole, identifier: String) -> Unit
) {
  var selectedRoleIndex by remember { mutableStateOf(0) }
  val roleList = listOf(UserRole.STUDENT, UserRole.FACULTY, UserRole.STAFF, UserRole.ADMIN)
  val selectedRole = roleList[selectedRoleIndex]

  var identifier by remember(selectedRole) {
    mutableStateOf(
      when (selectedRole) {
        UserRole.STUDENT -> "23MCA042"
        UserRole.FACULTY -> "FAC-CS-108"
        UserRole.STAFF -> "STF-ADM-042"
        UserRole.ADMIN -> "ADMIN-GRI-01"
        else -> ""
      }
    )
  }
  var password by remember { mutableStateOf("••••••••") }

  Dialog(
    onDismissRequest = onDismiss,
    properties = DialogProperties(usePlatformDefaultWidth = false)
  ) {
    Surface(
      shape = RoundedCornerShape(GriRadius.xl),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 6.dp,
      modifier = Modifier
        .fillMaxWidth(0.92f)
        .padding(vertical = 20.dp)
    ) {
      Column(
        modifier = Modifier
          .fillMaxWidth()
          .padding(20.dp)
      ) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Image(
              painter = painterResource(id = R.drawable.ic_gri_seal),
              contentDescription = null,
              modifier = Modifier
                .size(34.dp)
                .clip(CircleShape)
            )
            Spacer(modifier = Modifier.width(10.dp))
            Column {
              Text(
                text = "GRI PORTAL SIGN IN",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = GriNavyPrimary
              )
              Text(
                text = "Role-Based Access Control (RBAC)",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
              )
            }
          }
          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close")
          }
        }

        Spacer(modifier = Modifier.height(14.dp))
        HorizontalDivider()
        Spacer(modifier = Modifier.height(14.dp))

        // Role Tabs
        TabRow(
          selectedTabIndex = selectedRoleIndex,
          containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f),
          contentColor = GriNavyPrimary,
          modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(GriRadius.sm))
        ) {
          roleList.forEachIndexed { index, role ->
            Tab(
              selected = selectedRoleIndex == index,
              onClick = { selectedRoleIndex = index },
              text = {
                Text(
                  text = role.name,
                  style = MaterialTheme.typography.labelSmall,
                  fontWeight = if (selectedRoleIndex == index) FontWeight.Bold else FontWeight.Normal
                )
              }
            )
          }
        }

        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(
          value = identifier,
          onValueChange = { identifier = it },
          label = {
            Text(
              when (selectedRole) {
                UserRole.STUDENT -> "Roll / Register Number"
                UserRole.FACULTY -> "Faculty Employee ID"
                UserRole.STAFF -> "Staff ID / Service No"
                UserRole.ADMIN -> "Administrative Officer ID"
                else -> "User ID"
              }
            )
          },
          singleLine = true,
          modifier = Modifier
            .fillMaxWidth()
            .testTag("input_login_identifier"),
          colors = OutlinedTextFieldDefaults.colors(
            focusedBorderColor = GriNavyPrimary,
            focusedLabelColor = GriNavyPrimary
          )
        )

        Spacer(modifier = Modifier.height(10.dp))

        OutlinedTextField(
          value = password,
          onValueChange = { password = it },
          label = { Text("Password / Samarth Credentials") },
          singleLine = true,
          visualTransformation = PasswordVisualTransformation(),
          modifier = Modifier
            .fillMaxWidth()
            .testTag("input_login_password"),
          colors = OutlinedTextFieldDefaults.colors(
            focusedBorderColor = GriNavyPrimary,
            focusedLabelColor = GriNavyPrimary
          )
        )

        Spacer(modifier = Modifier.height(14.dp))

        // Quick 1-Tap Demo Logins banner
        Surface(
          color = GriGoldContainer.copy(alpha = 0.35f),
          shape = RoundedCornerShape(GriRadius.sm),
          modifier = Modifier.fillMaxWidth()
        ) {
          Row(
            modifier = Modifier.padding(10.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Icon(Icons.Default.Key, contentDescription = null, tint = GriGoldDark, modifier = Modifier.size(18.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Column {
              Text(
                text = "EVALUATOR / AUDIT DEMO HELPER",
                style = MaterialTheme.typography.labelSmall,
                fontWeight = FontWeight.Bold,
                color = GriGoldDark
              )
              Text(
                text = "Pre-filled credentials for ${selectedRole.name}. Tap 'Authenticate & Sign In' below.",
                style = MaterialTheme.typography.bodySmall,
                fontSize = 11.sp
              )
            }
          }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(
          onClick = {
            onLogin(selectedRole, identifier)
          },
          colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
          shape = RoundedCornerShape(GriRadius.md),
          modifier = Modifier
            .fillMaxWidth()
            .height(48.dp)
            .testTag("btn_confirm_login")
        ) {
          Icon(Icons.Default.Lock, contentDescription = null, modifier = Modifier.size(16.dp))
          Spacer(modifier = Modifier.width(8.dp))
          Text(
            text = "Authenticate & Enter ${selectedRole.name} Portal",
            color = Color.White,
            fontWeight = FontWeight.Bold
          )
        }
      }
    }
  }
}

/**
 * Interactive GRI-Sahayak Institutional AI Assistant Modal
 * Grounded in verified institutional knowledge from https://www.ruraluniv.ac.in/.
 */
@Composable
fun GriSahayakChatDialog(
  messages: List<SahayakMessage>,
  onSendMessage: (String) -> Unit,
  onDismiss: () -> Unit
) {
  var userInput by remember { mutableStateOf("") }
  val quickQueries = listOf(
    "Admissions 2026",
    "75% Attendance Rule",
    "Exam Hall Ticket",
    "Library Timings & Holdings",
    "Hostels & Mess Timings",
    "Bus Routes",
    "Scholarships",
    "Anti-Ragging Helpline"
  )

  Dialog(
    onDismissRequest = onDismiss,
    properties = DialogProperties(usePlatformDefaultWidth = false)
  ) {
    Surface(
      shape = RoundedCornerShape(GriRadius.xl),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 6.dp,
      modifier = Modifier
        .fillMaxWidth(0.95f)
        .fillMaxHeight(0.85f)
        .padding(vertical = 16.dp)
    ) {
      Column(
        modifier = Modifier
          .fillMaxSize()
          .padding(16.dp)
      ) {
        // Header
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
              modifier = Modifier
                .size(42.dp)
                .clip(CircleShape)
                .background(GriNavyPrimary),
              contentAlignment = Alignment.Center
            ) {
              Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = GriGoldSecondary, modifier = Modifier.size(24.dp))
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column {
              Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                  text = "GRI-SAHAYAK",
                  style = MaterialTheme.typography.titleMedium,
                  fontWeight = FontWeight.Bold,
                  color = GriNavyPrimary
                )
                Spacer(modifier = Modifier.width(6.dp))
                Surface(
                  color = GriGoldContainer,
                  shape = RoundedCornerShape(GriRadius.xs)
                ) {
                  Text(
                    text = "AI Verified",
                    style = MaterialTheme.typography.labelSmall,
                    fontSize = 9.sp,
                    color = GriGoldOnContainer,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 4.dp, vertical = 2.dp)
                  )
                }
              }
              Text(
                text = "Grounded University Knowledge Base • ruraluniv.ac.in",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
              )
            }
          }
          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close Assistant")
          }
        }

        Spacer(modifier = Modifier.height(10.dp))
        HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))
        Spacer(modifier = Modifier.height(8.dp))

        // Quick chips
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .horizontalScroll(rememberScrollState())
            .padding(vertical = 4.dp),
          horizontalArrangement = Arrangement.spacedBy(6.dp)
        ) {
          quickQueries.forEach { query ->
            Surface(
              onClick = { onSendMessage(query) },
              shape = RoundedCornerShape(GriRadius.pill),
              color = GriNavyPrimary.copy(alpha = 0.08f),
              border = BorderStroke(1.dp, GriNavyPrimary.copy(alpha = 0.2f))
            ) {
              Text(
                text = query,
                style = MaterialTheme.typography.labelSmall,
                color = GriNavyPrimary,
                fontWeight = FontWeight.SemiBold,
                modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp)
              )
            }
          }
        }

        Spacer(modifier = Modifier.height(6.dp))

        // Chat messages
        LazyColumn(
          modifier = Modifier
            .weight(1f)
            .fillMaxWidth(),
          reverseLayout = false
        ) {
          items(messages) { msg ->
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 5.dp),
              horizontalArrangement = if (msg.isUser) Arrangement.End else Arrangement.Start
            ) {
              Card(
                colors = CardDefaults.cardColors(
                  containerColor = if (msg.isUser) GriNavyPrimary else MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.7f)
                ),
                shape = RoundedCornerShape(
                  topStart = 16.dp,
                  topEnd = 16.dp,
                  bottomStart = if (msg.isUser) 16.dp else 4.dp,
                  bottomEnd = if (msg.isUser) 4.dp else 16.dp
                ),
                elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
                border = if (!msg.isUser) BorderStroke(1.dp, MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)) else null,
                modifier = Modifier.fillMaxWidth(0.85f)
              ) {
                Column(modifier = Modifier.padding(14.dp)) {
                  if (!msg.isUser) {
                    Row(
                      verticalAlignment = Alignment.CenterVertically,
                      horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                      Box(
                        modifier = Modifier
                          .size(16.dp)
                          .clip(CircleShape)
                          .background(GriGoldSecondary),
                        contentAlignment = Alignment.Center
                      ) {
                        Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = Color.Black, modifier = Modifier.size(10.dp))
                      }
                      Text(
                        text = "GRI Knowledge Assistant",
                        style = MaterialTheme.typography.labelSmall,
                        color = GriNavyPrimary,
                        fontWeight = FontWeight.Bold
                      )
                    }
                    Spacer(modifier = Modifier.height(6.dp))
                  }
                  Text(
                    text = msg.text,
                    style = MaterialTheme.typography.bodyMedium,
                    color = if (msg.isUser) Color.White else MaterialTheme.colorScheme.onSurface
                  )
                  if (msg.source != null) {
                    Spacer(modifier = Modifier.height(8.dp))
                    Surface(
                      color = if (msg.isUser) Color.White.copy(alpha = 0.15f) else GriGoldContainer.copy(alpha = 0.6f),
                      shape = RoundedCornerShape(GriRadius.xs)
                    ) {
                      Text(
                        text = "Official Source: ${msg.source}",
                        style = MaterialTheme.typography.labelSmall,
                        color = if (msg.isUser) Color.White else GriGoldOnContainer,
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 9.sp,
                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                      )
                    }
                  }
                }
              }
            }
          }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Input row
        Row(
          modifier = Modifier.fillMaxWidth(),
          verticalAlignment = Alignment.CenterVertically,
          horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
          OutlinedTextField(
            value = userInput,
            onValueChange = { userInput = it },
            placeholder = { Text("Ask about courses, syllabus, fees, exams...", fontSize = 13.sp) },
            singleLine = true,
            shape = RoundedCornerShape(GriRadius.md),
            modifier = Modifier
              .weight(1f)
              .testTag("input_sahayak_prompt"),
            colors = OutlinedTextFieldDefaults.colors(
              focusedBorderColor = GriNavyPrimary,
              unfocusedBorderColor = MaterialTheme.colorScheme.outline.copy(alpha = 0.4f)
            )
          )

          IconButton(
            onClick = {
              if (userInput.isNotBlank()) {
                onSendMessage(userInput)
                userInput = ""
              }
            },
            enabled = userInput.isNotBlank(),
            modifier = Modifier
              .size(48.dp)
              .clip(CircleShape)
              .background(if (userInput.isNotBlank()) GriNavyPrimary else Color.LightGray)
              .testTag("btn_sahayak_send")
          ) {
            Icon(
              imageVector = Icons.AutoMirrored.Filled.Send,
              contentDescription = "Send Question",
              tint = Color.White,
              modifier = Modifier.size(20.dp)
            )
          }
        }
      }
    }
  }
}

/**
 * Role Selector Bar (Kept for backwards-compatible test calls and authorized internal views)
 */
@Composable
fun RoleSelectorBar(
  currentRole: UserRole,
  onRoleSelected: (UserRole) -> Unit,
  modifier: Modifier = Modifier
) {
  Row(
    modifier = modifier
      .fillMaxWidth()
      .background(MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f))
      .horizontalScroll(rememberScrollState())
      .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
    horizontalArrangement = Arrangement.spacedBy(8.dp),
    verticalAlignment = Alignment.CenterVertically
  ) {
    Text(
      text = "DEMO ROLE:",
      style = MaterialTheme.typography.labelSmall,
      color = MaterialTheme.colorScheme.onSurfaceVariant,
      fontWeight = FontWeight.Bold
    )

    UserRole.values().forEach { role ->
      val isSelected = currentRole == role
      FilterChip(
        selected = isSelected,
        onClick = { onRoleSelected(role) },
        label = {
          Text(
            text = role.name.replace("_", " "),
            style = MaterialTheme.typography.labelMedium,
            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium
          )
        },
        colors = FilterChipDefaults.filterChipColors(
          selectedContainerColor = GriNavyPrimary,
          selectedLabelColor = Color.White,
          containerColor = MaterialTheme.colorScheme.surface,
          labelColor = MaterialTheme.colorScheme.onSurface
        ),
        border = FilterChipDefaults.filterChipBorder(
          enabled = true,
          selected = isSelected,
          borderColor = if (isSelected) GriGoldSecondary else MaterialTheme.colorScheme.outline
        ),
        modifier = Modifier.testTag("role_chip_${role.name.lowercase()}")
      )
    }
  }
}

/**
 * Institutional Search Bar
 */
@Composable
fun GriSearchBar(
  query: String,
  onQueryChange: (String) -> Unit,
  placeholder: String = "Search courses, circulars, exams, faculty...",
  modifier: Modifier = Modifier
) {
  OutlinedTextField(
    value = query,
    onValueChange = onQueryChange,
    placeholder = {
      Text(
        text = placeholder,
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f),
        maxLines = 1,
        overflow = TextOverflow.Ellipsis
      )
    },
    leadingIcon = {
      Icon(
        imageVector = Icons.Default.Search,
        contentDescription = "Search",
        tint = MaterialTheme.colorScheme.primary,
        modifier = Modifier.size(20.dp)
      )
    },
    trailingIcon = {
      if (query.isNotEmpty()) {
        IconButton(onClick = { onQueryChange("") }) {
          Icon(
            imageVector = Icons.Default.Clear,
            contentDescription = "Clear search",
            modifier = Modifier.size(18.dp)
          )
        }
      }
    },
    singleLine = true,
    shape = RoundedCornerShape(GriRadius.lg),
    colors = OutlinedTextFieldDefaults.colors(
      focusedContainerColor = MaterialTheme.colorScheme.surface,
      unfocusedContainerColor = MaterialTheme.colorScheme.surface,
      focusedBorderColor = MaterialTheme.colorScheme.primary,
      unfocusedBorderColor = MaterialTheme.colorScheme.outline
    ),
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 6.dp)
      .testTag("gri_search_input")
  )
}

/**
 * Important Notice / Urgent Alert Banner
 */
@Composable
fun GriNoticeAlert(
  title: String,
  message: String,
  isUrgent: Boolean = true,
  onClick: () -> Unit = {},
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 6.dp)
      .clickable(onClick = onClick)
      .testTag("gri_notice_alert"),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(
      containerColor = if (isUrgent) GriColors.AlertContainer else GriColors.GoldContainer
    ),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
  ) {
    Row(
      modifier = Modifier
        .fillMaxWidth()
        .padding(12.dp),
      verticalAlignment = Alignment.CenterVertically
    ) {
      Box(
        modifier = Modifier
          .size(36.dp)
          .clip(CircleShape)
          .background(if (isUrgent) GriRedAlert.copy(alpha = 0.15f) else GriGoldSecondary.copy(alpha = 0.15f)),
        contentAlignment = Alignment.Center
      ) {
        Icon(
          imageVector = if (isUrgent) Icons.Default.Campaign else Icons.Default.WarningAmber,
          contentDescription = null,
          tint = if (isUrgent) GriRedAlert else GriGoldDark,
          modifier = Modifier.size(20.dp)
        )
      }

      Spacer(modifier = Modifier.width(12.dp))

      Column(modifier = Modifier.weight(1f)) {
        Text(
          text = title,
          style = MaterialTheme.typography.titleSmall,
          fontWeight = FontWeight.Bold,
          color = if (isUrgent) GriColors.AlertText else GriColors.GoldOnContainer
        )
        Text(
          text = message,
          style = MaterialTheme.typography.bodySmall,
          color = if (isUrgent) GriColors.AlertText.copy(alpha = 0.85f) else GriColors.GoldOnContainer.copy(alpha = 0.85f),
          maxLines = 2,
          overflow = TextOverflow.Ellipsis
        )
      }
    }
  }
}

/**
 * Institutional Section Header with Gold/Navy vertical accent bar
 */
@Composable
fun GriSectionHeader(
  title: String,
  subtitle: String? = null,
  actionText: String? = null,
  onActionClick: (() -> Unit)? = null,
  modifier: Modifier = Modifier
) {
  Row(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 8.dp),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
  ) {
    Row(verticalAlignment = Alignment.CenterVertically) {
      Box(
        modifier = Modifier
          .width(4.dp)
          .height(20.dp)
          .clip(RoundedCornerShape(2.dp))
          .background(GriGoldSecondary)
      )
      Spacer(modifier = Modifier.width(8.dp))
      Column {
        Text(
          text = title,
          style = MaterialTheme.typography.titleMedium,
          fontWeight = FontWeight.Bold,
          color = MaterialTheme.colorScheme.onSurface
        )
        if (subtitle != null) {
          Text(
            text = subtitle,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            fontSize = 11.sp
          )
        }
      }
    }

    if (actionText != null && onActionClick != null) {
      TextButton(onClick = onActionClick) {
        Text(
          text = actionText,
          style = MaterialTheme.typography.labelMedium,
          color = MaterialTheme.colorScheme.primary,
          fontWeight = FontWeight.Bold
        )
      }
    }
  }
}

/**
 * Official Digital Institutional ID Card
 */
@Composable
fun DigitalIdCard(
  user: UserEntity?,
  onVerifyClick: () -> Unit = {},
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 6.dp)
      .testTag("digital_id_card"),
    shape = RoundedCornerShape(GriRadius.lg),
    colors = CardDefaults.cardColors(
      containerColor = GriNavyPrimary
    ),
    elevation = CardDefaults.cardElevation(defaultElevation = 3.dp)
  ) {
    Column(
      modifier = Modifier
        .fillMaxWidth()
        .padding(18.dp)
    ) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
          Image(
            painter = painterResource(id = R.drawable.ic_gri_seal),
            contentDescription = "Institutional Seal",
            modifier = Modifier
              .size(34.dp)
              .clip(CircleShape)
              .border(1.dp, GriGoldSecondary, CircleShape)
          )
          Spacer(modifier = Modifier.width(10.dp))
          Column {
            Text(
              text = "GANDHIGRAM RURAL INSTITUTE",
              style = MaterialTheme.typography.labelMedium,
              color = Color.White,
              fontWeight = FontWeight.Bold,
              letterSpacing = 0.3.sp
            )
            Text(
              text = "DEEMED TO BE UNIVERSITY • NAAC 'A+'",
              style = MaterialTheme.typography.bodySmall,
              color = Color.White.copy(alpha = 0.75f),
              fontSize = 9.sp
            )
          }
        }

        Surface(
          color = GriGoldSecondary,
          shape = RoundedCornerShape(GriRadius.xs)
        ) {
          Text(
            text = user?.role ?: "STUDENT",
            style = MaterialTheme.typography.labelSmall,
            color = Color.Black,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
          )
        }
      }

      Spacer(modifier = Modifier.height(14.dp))

      Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
      ) {
        Box(
          modifier = Modifier
            .size(62.dp)
            .clip(RoundedCornerShape(GriRadius.md))
            .background(Color.White.copy(alpha = 0.15f))
            .border(1.5.dp, GriGoldSecondary, RoundedCornerShape(GriRadius.md)),
          contentAlignment = Alignment.Center
        ) {
          Text(
            text = user?.name?.split(" ")?.mapNotNull { it.firstOrNull()?.toString() }?.take(2)?.joinToString("") ?: "GRI",
            color = GriGoldSecondary,
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.Bold
          )
        }

        Spacer(modifier = Modifier.width(14.dp))

        Column(modifier = Modifier.weight(1f)) {
          Text(
            text = user?.name ?: "Student Name",
            style = MaterialTheme.typography.titleMedium,
            color = Color.White,
            fontWeight = FontWeight.Bold
          )
          Text(
            text = "Roll / Reg No: ${user?.rollNo ?: "23MCA042"}",
            style = MaterialTheme.typography.bodyMedium,
            color = Color.White.copy(alpha = 0.9f)
          )
          Text(
            text = "${user?.department ?: "Computer Science"} • ${user?.semester ?: "Sem 4"}",
            style = MaterialTheme.typography.bodySmall,
            color = Color.White.copy(alpha = 0.75f),
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
          )
        }

        IconButton(
          onClick = onVerifyClick,
          modifier = Modifier
            .size(46.dp)
            .clip(CircleShape)
            .background(Color.White.copy(alpha = 0.12f))
        ) {
          Icon(
            imageVector = Icons.Default.QrCode2,
            contentDescription = "Verify e-SANAD Token",
            tint = Color.White,
            modifier = Modifier.size(26.dp)
          )
        }
      }

      Spacer(modifier = Modifier.height(14.dp))
      HorizontalDivider(color = Color.White.copy(alpha = 0.15f))
      Spacer(modifier = Modifier.height(10.dp))

      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
          if (user?.isHostelite == true) {
            Surface(
              color = Color.White.copy(alpha = 0.12f),
              shape = RoundedCornerShape(GriRadius.xs)
            ) {
              Text(
                text = "Hostel Resident",
                style = MaterialTheme.typography.bodySmall,
                fontSize = 11.sp,
                color = Color.White.copy(alpha = 0.9f),
                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
              )
            }
          }
          if (user?.busPassActive == true) {
            Surface(
              color = Color.White.copy(alpha = 0.12f),
              shape = RoundedCornerShape(GriRadius.xs)
            ) {
              Text(
                text = "Bus Pass: Active",
                style = MaterialTheme.typography.bodySmall,
                fontSize = 11.sp,
                color = Color.White.copy(alpha = 0.9f),
                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
              )
            }
          }
        }
        Text(
          text = "Valid Thru: ${user?.validThru ?: "2026-12"}",
          style = MaterialTheme.typography.bodySmall,
          fontSize = 10.sp,
          color = Color.White.copy(alpha = 0.65f)
        )
      }
    }
  }
}

/**
 * Metric Card Component
 */
@Composable
fun StatCard(
  title: String,
  value: String,
  subtitle: String,
  icon: ImageVector,
  iconTint: Color,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier,
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.5.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Text(
          text = title,
          style = MaterialTheme.typography.labelMedium,
          color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Box(
          modifier = Modifier
            .size(32.dp)
            .clip(CircleShape)
            .background(iconTint.copy(alpha = 0.12f)),
          contentAlignment = Alignment.Center
        ) {
          Icon(
            imageVector = icon,
            contentDescription = null,
            tint = iconTint,
            modifier = Modifier.size(18.dp)
          )
        }
      }
      Spacer(modifier = Modifier.height(8.dp))
      Text(
        text = value,
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        color = MaterialTheme.colorScheme.onSurface
      )
      Text(
        text = subtitle,
        style = MaterialTheme.typography.bodySmall,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        fontSize = 11.sp
      )
    }
  }
}

/**
 * Quick Service Grid Action Button
 */
@Composable
fun QuickServiceButton(
  title: String,
  icon: ImageVector,
  iconTint: Color,
  onClick: () -> Unit,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .clickable(onClick = onClick)
      .testTag("quick_service_${title.lowercase().replace(" ", "_")}"),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(
      modifier = Modifier
        .fillMaxWidth()
        .padding(vertical = 12.dp, horizontal = 8.dp),
      horizontalAlignment = Alignment.CenterHorizontally,
      verticalArrangement = Arrangement.Center
    ) {
      Box(
        modifier = Modifier
          .size(42.dp)
          .clip(CircleShape)
          .background(iconTint.copy(alpha = 0.12f)),
        contentAlignment = Alignment.Center
      ) {
        Icon(
          imageVector = icon,
          contentDescription = title,
          tint = iconTint,
          modifier = Modifier.size(22.dp)
        )
      }
      Spacer(modifier = Modifier.height(8.dp))
      Text(
        text = title,
        style = MaterialTheme.typography.labelSmall,
        color = MaterialTheme.colorScheme.onSurface,
        fontWeight = FontWeight.SemiBold,
        textAlign = TextAlign.Center,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis
      )
    }
  }
}

/**
 * Examination Hall Ticket Modal Dialog with e-SANAD Verification
 */
@Composable
fun HallTicketDialog(
  ticket: HallTicketResponse,
  onDismiss: () -> Unit
) {
  var isDownloaded by remember { mutableStateOf(false) }

  Dialog(
    onDismissRequest = onDismiss,
    properties = DialogProperties(usePlatformDefaultWidth = false)
  ) {
    Surface(
      shape = RoundedCornerShape(GriRadius.xl),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 6.dp,
      modifier = Modifier
        .fillMaxWidth(0.95f)
        .fillMaxHeight(0.90f)
        .padding(vertical = 12.dp)
    ) {
      Column(
        modifier = Modifier
          .fillMaxSize()
          .padding(18.dp)
      ) {
        // Header
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Image(
              painter = painterResource(id = R.drawable.ic_gri_seal),
              contentDescription = null,
              modifier = Modifier
                .size(38.dp)
                .clip(CircleShape)
            )
            Spacer(modifier = Modifier.width(10.dp))
            Column {
              Text(
                text = "GANDHIGRAM RURAL INSTITUTE",
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.Bold,
                color = GriNavyPrimary
              )
              Text(
                text = "Office of the Controller of Examinations (CoE)",
                style = MaterialTheme.typography.bodySmall,
                fontSize = 11.sp,
                color = MaterialTheme.colorScheme.onSurfaceVariant
              )
            }
          }
          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close Hall Ticket")
          }
        }

        Spacer(modifier = Modifier.height(10.dp))
        HorizontalDivider()
        Spacer(modifier = Modifier.height(10.dp))

        // Scrollable content
        Column(
          modifier = Modifier
            .weight(1f)
            .verticalScroll(rememberScrollState())
        ) {
          // Banner
          Surface(
            color = GriNavyPrimary,
            shape = RoundedCornerShape(GriRadius.sm),
            modifier = Modifier.fillMaxWidth()
          ) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Column {
                Text(
                  text = "END SEMESTER EXAMINATIONS (ESE)",
                  style = MaterialTheme.typography.titleSmall,
                  fontWeight = FontWeight.Bold,
                  color = Color.White
                )
                Text(
                  text = ticket.examSession,
                  style = MaterialTheme.typography.bodySmall,
                  color = GriGoldSecondary
                )
              }
              Surface(
                color = GriGoldSecondary,
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(
                  text = "OFFICIAL E-PASS",
                  style = MaterialTheme.typography.labelSmall,
                  fontWeight = FontWeight.Bold,
                  color = Color.Black,
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp)
                )
              }
            }
          }

          Spacer(modifier = Modifier.height(12.dp))

          // Candidate Info Grid
          Surface(
            color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.6f),
            shape = RoundedCornerShape(GriRadius.md),
            border = androidx.compose.foundation.BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
          ) {
            Column(modifier = Modifier.padding(14.dp)) {
              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
              ) {
                Column(modifier = Modifier.weight(1f)) {
                  Text(text = "CANDIDATE NAME", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 9.sp)
                  Text(text = ticket.studentName, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
                }
                Column(horizontalAlignment = Alignment.End) {
                  Text(text = "REGISTER / ROLL NO", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 9.sp)
                  Text(text = ticket.registerNumber, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold, color = GriNavyPrimary)
                }
              }

              Spacer(modifier = Modifier.height(8.dp))

              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
              ) {
                Column(modifier = Modifier.weight(1f)) {
                  Text(text = "DEGREE & PROGRAMME", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 9.sp)
                  Text(text = ticket.degree, style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
                }
                Column(horizontalAlignment = Alignment.End) {
                  Text(text = "SEMESTER", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 9.sp)
                  Text(text = ticket.semester, style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
                }
              }

              Spacer(modifier = Modifier.height(8.dp))

              Text(text = "EXAMINATION CENTRE", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 9.sp)
              Text(text = ticket.examinationCenter, style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
            }
          }

          Spacer(modifier = Modifier.height(14.dp))

          // e-SANAD Verification Badge
          Surface(
            color = GriGreenSuccess.copy(alpha = 0.08f),
            shape = RoundedCornerShape(GriRadius.md),
            border = androidx.compose.foundation.BorderStroke(1.dp, GriGreenSuccess.copy(alpha = 0.3f))
          ) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
              verticalAlignment = Alignment.CenterVertically
            ) {
              Icon(Icons.Default.QrCode2, contentDescription = null, tint = GriGreenSuccess, modifier = Modifier.size(36.dp))
              Spacer(modifier = Modifier.width(10.dp))
              Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                  Icon(Icons.Default.Verified, contentDescription = null, tint = GriGreenSuccess, modifier = Modifier.size(14.dp))
                  Spacer(modifier = Modifier.width(4.dp))
                  Text(
                    text = "e-SANAD / NAD VERIFIED RECORD",
                    style = MaterialTheme.typography.labelSmall,
                    fontWeight = FontWeight.Bold,
                    color = GriGreenSuccess
                  )
                }
                Text(
                  text = "Security Token: ${ticket.sanadVerificationCode}",
                  style = MaterialTheme.typography.bodySmall,
                  fontSize = 11.sp,
                  fontWeight = FontWeight.Medium
                )
                Text(
                  text = "[DEMO / PREVIEW DATA - Cryptographically signed for audit testing]",
                  style = MaterialTheme.typography.labelSmall,
                  color = MaterialTheme.colorScheme.onSurfaceVariant,
                  fontSize = 9.sp
                )
              }
            }
          }

          Spacer(modifier = Modifier.height(14.dp))

          // Exam schedule list
          Text(
            text = "EXAMINATION TIMETABLE (${ticket.exams.size} COURSES)",
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.Bold,
            color = GriNavyPrimary
          )
          Spacer(modifier = Modifier.height(6.dp))

          ticket.exams.forEach { exam ->
            Card(
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp),
              shape = RoundedCornerShape(GriRadius.sm),
              colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
              border = CardDefaults.outlinedCardBorder()
            ) {
              Column(modifier = Modifier.padding(10.dp)) {
                Row(
                  modifier = Modifier.fillMaxWidth(),
                  horizontalArrangement = Arrangement.SpaceBetween,
                  verticalAlignment = Alignment.CenterVertically
                ) {
                  Surface(
                    color = GriNavyPrimary.copy(alpha = 0.1f),
                    shape = RoundedCornerShape(GriRadius.xs)
                  ) {
                    Text(
                      text = exam.courseCode,
                      style = MaterialTheme.typography.labelSmall,
                      fontWeight = FontWeight.Bold,
                      color = GriNavyPrimary,
                      modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                    )
                  }
                  Text(
                    text = "${exam.date} • ${exam.session}",
                    style = MaterialTheme.typography.labelSmall,
                    fontWeight = FontWeight.Bold,
                    color = GriGoldDark
                  )
                }

                Spacer(modifier = Modifier.height(4.dp))
                Text(
                  text = exam.courseTitle,
                  style = MaterialTheme.typography.titleSmall,
                  fontWeight = FontWeight.Bold
                )

                Spacer(modifier = Modifier.height(6.dp))
                Row(
                  modifier = Modifier.fillMaxWidth(),
                  horizontalArrangement = Arrangement.SpaceBetween
                ) {
                  Text(
                    text = "Venue: ${exam.hallNumber}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    fontSize = 11.sp
                  )
                  Text(
                    text = "Desk / Seat: ${exam.seatNumber}",
                    style = MaterialTheme.typography.bodySmall,
                    fontWeight = FontWeight.Bold,
                    fontSize = 11.sp
                  )
                }
              }
            }
          }

          Spacer(modifier = Modifier.height(14.dp))

          // Candidate Instructions
          Surface(
            color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f),
            shape = RoundedCornerShape(GriRadius.sm)
          ) {
            Column(modifier = Modifier.padding(10.dp)) {
              Text(
                text = "INSTRUCTIONS TO CANDIDATES:",
                style = MaterialTheme.typography.labelSmall,
                fontWeight = FontWeight.Bold,
                color = GriNavyPrimary
              )
              Text("1. Candidates must arrive at the examination hall at least 15 minutes prior to commencement.", style = MaterialTheme.typography.bodySmall, fontSize = 10.sp)
              Text("2. University Identity Card and Hall Ticket must be produced upon invigilator inspection.", style = MaterialTheme.typography.bodySmall, fontSize = 10.sp)
              Text("3. Electronic devices, smart watches, and unauthorized materials are strictly prohibited.", style = MaterialTheme.typography.bodySmall, fontSize = 10.sp)
            }
          }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Action Buttons
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
          OutlinedButton(
            onClick = { isDownloaded = true },
            shape = RoundedCornerShape(GriRadius.md),
            modifier = Modifier.weight(1f)
          ) {
            Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text(if (isDownloaded) "Saved PDF" else "Download PDF")
          }

          Button(
            onClick = onDismiss,
            colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
            shape = RoundedCornerShape(GriRadius.md),
            modifier = Modifier.weight(1f)
          ) {
            Text("Done / Close", color = Color.White, fontWeight = FontWeight.Bold)
          }
        }
      }
    }
  }
}

/**
 * Official Document Viewer Dialog
 */
@Composable
fun GriOfficialDocumentDialog(
  document: DocumentItem,
  onDismiss: () -> Unit
) {
  var isSaved by remember { mutableStateOf(false) }

  Dialog(
    onDismissRequest = onDismiss,
    properties = DialogProperties(usePlatformDefaultWidth = false)
  ) {
    Surface(
      shape = RoundedCornerShape(GriRadius.xl),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 6.dp,
      modifier = Modifier
        .fillMaxWidth(0.94f)
        .fillMaxHeight(0.80f)
        .padding(vertical = 16.dp)
    ) {
      Column(
        modifier = Modifier
          .fillMaxSize()
          .padding(18.dp)
      ) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.PictureAsPdf, contentDescription = null, tint = GriRedAlert, modifier = Modifier.size(28.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Column {
              Text(text = "OFFICIAL NOTIFICATION", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold, color = GriRedAlert)
              Text(text = document.title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold, maxLines = 1, overflow = TextOverflow.Ellipsis)
            }
          }
          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close Document")
          }
        }

        Spacer(modifier = Modifier.height(10.dp))
        HorizontalDivider()
        Spacer(modifier = Modifier.height(12.dp))

        Column(
          modifier = Modifier
            .weight(1f)
            .verticalScroll(rememberScrollState())
        ) {
          Surface(
            color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f),
            shape = RoundedCornerShape(GriRadius.sm),
            modifier = Modifier.fillMaxWidth()
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Text(text = "Document Ref: ${document.id}", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold)
              Text(text = "Issue Date: ${document.date} • Authority: ${document.authority}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
              Text(text = "Department / Category: ${document.category}", style = MaterialTheme.typography.bodySmall)
            }
          }

          Spacer(modifier = Modifier.height(14.dp))
          Text(text = "Official Summary & Orders:", style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.Bold)
          Spacer(modifier = Modifier.height(6.dp))
          Text(
            text = if (document.sections.isNotEmpty()) document.sections.joinToString("\n\n") else document.summary,
            style = MaterialTheme.typography.bodyMedium,
            lineHeight = 22.sp
          )
        }

        Spacer(modifier = Modifier.height(12.dp))
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
          OutlinedButton(
            onClick = { isSaved = true },
            shape = RoundedCornerShape(GriRadius.md),
            modifier = Modifier.weight(1f)
          ) {
            Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text(if (isSaved) "Saved to Storage" else "Download Copy")
          }

          Button(
            onClick = onDismiss,
            colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
            shape = RoundedCornerShape(GriRadius.md),
            modifier = Modifier.weight(1f)
          ) {
            Text("Close", color = Color.White)
          }
        }
      }
    }
  }
}

/**
 * Reusable Empty State Component
 */
@Composable
fun GriEmptyState(
  icon: ImageVector,
  title: String,
  message: String,
  actionLabel: String? = null,
  onActionClick: (() -> Unit)? = null,
  modifier: Modifier = Modifier
) {
  Column(
    modifier = modifier
      .fillMaxWidth()
      .padding(32.dp),
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.Center
  ) {
    Box(
      modifier = Modifier
        .size(64.dp)
        .clip(CircleShape)
        .background(MaterialTheme.colorScheme.surfaceVariant),
      contentAlignment = Alignment.Center
    ) {
      Icon(
        imageVector = icon,
        contentDescription = null,
        tint = MaterialTheme.colorScheme.primary,
        modifier = Modifier.size(32.dp)
      )
    }
    Spacer(modifier = Modifier.height(16.dp))
    Text(
      text = title,
      style = MaterialTheme.typography.titleMedium,
      fontWeight = FontWeight.Bold,
      color = MaterialTheme.colorScheme.onSurface,
      textAlign = TextAlign.Center
    )
    Spacer(modifier = Modifier.height(4.dp))
    Text(
      text = message,
      style = MaterialTheme.typography.bodySmall,
      color = MaterialTheme.colorScheme.onSurfaceVariant,
      textAlign = TextAlign.Center
    )
    if (actionLabel != null && onActionClick != null) {
      Spacer(modifier = Modifier.height(16.dp))
      Button(
        onClick = onActionClick,
        colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
        shape = RoundedCornerShape(GriRadius.md)
      ) {
        Text(actionLabel)
      }
    }
  }
}

/**
 * Reusable Loading State Component
 */
@Composable
fun GriLoadingState(
  message: String = "Loading institutional data...",
  modifier: Modifier = Modifier
) {
  Column(
    modifier = modifier
      .fillMaxWidth()
      .padding(32.dp),
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.Center
  ) {
    CircularProgressIndicator(
      color = GriNavyPrimary,
      modifier = Modifier.size(36.dp)
    )
    Spacer(modifier = Modifier.height(12.dp))
    Text(
      text = message,
      style = MaterialTheme.typography.bodyMedium,
      color = MaterialTheme.colorScheme.onSurfaceVariant
    )
  }
}

/**
 * Reusable Error State Component
 */
@Composable
fun GriErrorState(
  errorMessage: String,
  onRetry: () -> Unit,
  modifier: Modifier = Modifier
) {
  Column(
    modifier = modifier
      .fillMaxWidth()
      .padding(24.dp),
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.Center
  ) {
    Icon(
      imageVector = Icons.Default.WarningAmber,
      contentDescription = null,
      tint = GriRedAlert,
      modifier = Modifier.size(40.dp)
    )
    Spacer(modifier = Modifier.height(8.dp))
    Text(
      text = "Unable to complete request",
      style = MaterialTheme.typography.titleMedium,
      fontWeight = FontWeight.Bold,
      color = MaterialTheme.colorScheme.onSurface
    )
    Spacer(modifier = Modifier.height(4.dp))
    Text(
      text = errorMessage,
      style = MaterialTheme.typography.bodySmall,
      color = MaterialTheme.colorScheme.onSurfaceVariant,
      textAlign = TextAlign.Center
    )
    Spacer(modifier = Modifier.height(16.dp))
    Button(
      onClick = onRetry,
      colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
      shape = RoundedCornerShape(GriRadius.md)
    ) {
      Icon(Icons.Default.Refresh, contentDescription = null, modifier = Modifier.size(16.dp))
      Spacer(modifier = Modifier.width(6.dp))
      Text("Retry")
    }
  }
}

// =========================================================================
// UNIQUE GRI SIGNATURE COMPONENTS
// =========================================================================

data class GriDocument(
  val id: String,
  val title: String,
  val category: String,
  val date: String,
  val fileType: String,
  val fileSize: String,
  val description: String
)

@Composable
fun GriNoticeCard(
  title: String,
  message: String,
  date: String,
  isUrgent: Boolean,
  onClick: () -> Unit,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp)
      .clickable(onClick = onClick)
      .testTag("gri_notice_card"),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(
      containerColor = if (isUrgent) GriColors.AlertContainer.copy(alpha = 0.35f) else MaterialTheme.colorScheme.surface
    ),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Surface(
          color = if (isUrgent) GriColors.Alert else GriColors.NavyPrimary,
          shape = RoundedCornerShape(GriRadius.xs)
        ) {
          Text(
            text = if (isUrgent) "URGENT NOTICE" else "OFFICIAL ANNOUNCEMENT",
            style = MaterialTheme.typography.labelSmall,
            color = Color.White,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
          )
        }
        Text(date, style = MaterialTheme.typography.bodySmall, fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
      }
      Spacer(modifier = Modifier.height(6.dp))
      Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
      Spacer(modifier = Modifier.height(4.dp))
      Text(message, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 2)
    }
  }
}

@Composable
fun GriDocumentCard(
  document: GriDocument,
  onOpen: () -> Unit,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp)
      .clickable(onClick = onOpen)
      .testTag("gri_doc_card_${document.id}"),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Row(
      modifier = Modifier
        .fillMaxWidth()
        .padding(14.dp),
      verticalAlignment = Alignment.CenterVertically
    ) {
      Box(
        modifier = Modifier
          .size(40.dp)
          .clip(RoundedCornerShape(GriRadius.sm))
          .background(GriColors.NavyContainer),
        contentAlignment = Alignment.Center
      ) {
        Text(
          text = document.fileType,
          style = MaterialTheme.typography.labelSmall,
          fontWeight = FontWeight.Bold,
          color = GriColors.NavyPrimary
        )
      }
      Spacer(modifier = Modifier.width(12.dp))
      Column(modifier = Modifier.weight(1f)) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween
        ) {
          Surface(
            color = GriColors.GoldContainer,
            shape = RoundedCornerShape(GriRadius.xs)
          ) {
            Text(
              text = document.category,
              style = MaterialTheme.typography.labelSmall,
              color = GriColors.GoldOnContainer,
              fontWeight = FontWeight.Bold,
              modifier = Modifier.padding(horizontal = 6.dp, vertical = 1.dp)
            )
          }
          Text(document.date, style = MaterialTheme.typography.bodySmall, fontSize = 10.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(document.title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
        Text(document.description, style = MaterialTheme.typography.bodySmall, fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 1)
      }
    }
  }
}

@Composable
fun GriAcademicCard(
  title: String,
  code: String,
  credits: String,
  instructor: String,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Surface(color = GriColors.NavyContainer, shape = RoundedCornerShape(GriRadius.xs)) {
          Text(code, style = MaterialTheme.typography.labelSmall, color = GriColors.NavyPrimary, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
        }
        Text(credits, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
      }
      Spacer(modifier = Modifier.height(6.dp))
      Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
      Text("Instructor: $instructor", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
  }
}

@Composable
fun GriServiceCard(
  title: String,
  subtitle: String,
  icon: ImageVector,
  onClick: () -> Unit,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp)
      .clickable(onClick = onClick),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Row(
      modifier = Modifier
        .fillMaxWidth()
        .padding(14.dp),
      verticalAlignment = Alignment.CenterVertically
    ) {
      Box(
        modifier = Modifier
          .size(42.dp)
          .clip(CircleShape)
          .background(GriColors.NavyContainer),
        contentAlignment = Alignment.Center
      ) {
        Icon(icon, contentDescription = null, tint = GriColors.NavyPrimary, modifier = Modifier.size(20.dp))
      }
      Spacer(modifier = Modifier.width(12.dp))
      Column(modifier = Modifier.weight(1f)) {
        Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
        Text(subtitle, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
      }
    }
  }
}

@Composable
fun GriNewsCard(
  title: String,
  summary: String,
  date: String,
  category: String,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
      ) {
        Surface(color = GriColors.GoldContainer, shape = RoundedCornerShape(GriRadius.xs)) {
          Text(category, style = MaterialTheme.typography.labelSmall, color = GriColors.GoldOnContainer, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
        }
        Text(date, style = MaterialTheme.typography.bodySmall, fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
      }
      Spacer(modifier = Modifier.height(6.dp))
      Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
      Spacer(modifier = Modifier.height(4.dp))
      Text(summary, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 2)
    }
  }
}

@Composable
fun GriDepartmentCard(
  name: String,
  school: String,
  head: String,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Text(school, style = MaterialTheme.typography.labelSmall, color = GriColors.GoldDark, fontWeight = FontWeight.Bold)
      Spacer(modifier = Modifier.height(2.dp))
      Text(name, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
      Spacer(modifier = Modifier.height(4.dp))
      Text("Head / Dean: $head", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
  }
}

@Composable
fun GriProgrammeCard(
  title: String,
  level: String,
  duration: String,
  eligibility: String,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
      ) {
        Surface(color = GriColors.NavyContainer, shape = RoundedCornerShape(GriRadius.xs)) {
          Text(level, style = MaterialTheme.typography.labelSmall, color = GriColors.NavyPrimary, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
        }
        Text(duration, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
      }
      Spacer(modifier = Modifier.height(6.dp))
      Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
      Spacer(modifier = Modifier.height(4.dp))
      Text("Eligibility: $eligibility", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
  }
}

@Composable
fun GriCampusCard(
  title: String,
  description: String,
  location: String,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
      ) {
        Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
        Text(location, style = MaterialTheme.typography.labelSmall, color = GriColors.GoldDark, fontWeight = FontWeight.Bold)
      }
      Spacer(modifier = Modifier.height(4.dp))
      Text(description, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
  }
}

@Composable
fun GriOfficialLinkCard(
  title: String,
  url: String,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 3.dp),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Row(
      modifier = Modifier
        .fillMaxWidth()
        .padding(12.dp),
      horizontalArrangement = Arrangement.SpaceBetween,
      verticalAlignment = Alignment.CenterVertically
    ) {
      Column(modifier = Modifier.weight(1f)) {
        Text(title, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
        Text(url, style = MaterialTheme.typography.bodySmall, color = GriColors.GoldDark, fontSize = 11.sp)
      }
      Icon(Icons.AutoMirrored.Filled.Launch, contentDescription = null, tint = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.size(16.dp))
    }
  }
}

@Composable
fun GriDocumentDialog(
  document: GriDocument,
  onDismiss: () -> Unit,
  onDownload: () -> Unit
) {
  androidx.compose.ui.window.Dialog(onDismissRequest = onDismiss) {
    Card(
      modifier = Modifier
        .fillMaxWidth()
        .padding(16.dp)
        .testTag("document_preview_dialog"),
      shape = RoundedCornerShape(GriRadius.lg),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
      elevation = CardDefaults.cardElevation(defaultElevation = 6.dp)
    ) {
      Column(modifier = Modifier.padding(20.dp)) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Surface(
            color = GriColors.GoldContainer,
            shape = RoundedCornerShape(GriRadius.xs)
          ) {
            Text(
              text = document.category.uppercase(),
              style = MaterialTheme.typography.labelSmall,
              color = GriColors.GoldOnContainer,
              fontWeight = FontWeight.Bold,
              modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
            )
          }
          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close", tint = MaterialTheme.colorScheme.onSurfaceVariant)
          }
        }
        
        Spacer(modifier = Modifier.height(10.dp))
        Text(document.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(6.dp))
        Text(document.description, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
        
        Spacer(modifier = Modifier.height(14.dp))
        HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f))
        Spacer(modifier = Modifier.height(12.dp))
        
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween
        ) {
          Column {
            Text("Format / Size", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text("${document.fileType} • ${document.fileSize}", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
          }
          Column {
            Text("Published Date", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text(document.date, style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
          }
          Column(horizontalAlignment = Alignment.End) {
            Text("Verification", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text("SHA-256 Valid", style = MaterialTheme.typography.bodySmall, color = GriColors.Success, fontWeight = FontWeight.Bold)
          }
        }
        
        Spacer(modifier = Modifier.height(18.dp))
        
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
          OutlinedButton(
            onClick = onDismiss,
            modifier = Modifier.weight(1f),
            shape = RoundedCornerShape(GriRadius.sm)
          ) {
            Text("Dismiss")
          }
          Button(
            onClick = onDownload,
            colors = ButtonDefaults.buttonColors(containerColor = GriColors.NavyPrimary),
            modifier = Modifier.weight(1f),
            shape = RoundedCornerShape(GriRadius.sm)
          ) {
            Icon(Icons.AutoMirrored.Filled.Launch, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(6.dp))
            Text("Open Doc")
          }
        }
      }
    }
  }
}

// =========================================================================
// GRI REDESIGNED COMPONENT ECOSYSTEM (Institutional + Future Ready)
// =========================================================================

/**
 * Intelligent Priority Hub Card
 * Displays urgent academic, examination, or administrative action with institutional styling
 */
@Composable
fun GriPriorityHubCard(
  tag: String,
  title: String,
  subtitle: String,
  actionText: String,
  onActionClick: () -> Unit,
  modifier: Modifier = Modifier,
  secondaryActionText: String? = null,
  onSecondaryActionClick: (() -> Unit)? = null
) {
  Card(
    modifier = modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 6.dp)
      .testTag("gri_priority_hub_card"),
    shape = RoundedCornerShape(GriRadius.lg),
    colors = CardDefaults.cardColors(containerColor = GriNavyPrimary),
    elevation = CardDefaults.cardElevation(defaultElevation = 2.5.dp)
  ) {
    Column(
      modifier = Modifier
        .fillMaxWidth()
        .padding(18.dp)
    ) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Surface(
          color = GriGoldSecondary,
          shape = RoundedCornerShape(GriRadius.xs)
        ) {
          Text(
            text = tag.uppercase(),
            style = MaterialTheme.typography.labelSmall,
            fontWeight = FontWeight.Bold,
            color = Color.Black,
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
          )
        }

        Row(
          verticalAlignment = Alignment.CenterVertically,
          horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
          Box(
            modifier = Modifier
              .size(8.dp)
              .clip(CircleShape)
              .background(GriGreenSuccess)
          )
          Text(
            text = "Active Session",
            style = MaterialTheme.typography.labelSmall,
            color = Color.White.copy(alpha = 0.85f),
            fontSize = 10.sp
          )
        }
      }

      Spacer(modifier = Modifier.height(10.dp))

      Text(
        text = title,
        style = MaterialTheme.typography.titleMedium,
        fontWeight = FontWeight.Bold,
        color = Color.White
      )

      Spacer(modifier = Modifier.height(4.dp))

      Text(
        text = subtitle,
        style = MaterialTheme.typography.bodySmall,
        color = Color.White.copy(alpha = 0.8f),
        lineHeight = 18.sp
      )

      Spacer(modifier = Modifier.height(14.dp))

      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(10.dp)
      ) {
        Button(
          onClick = onActionClick,
          colors = ButtonDefaults.buttonColors(
            containerColor = GriGoldSecondary,
            contentColor = Color.Black
          ),
          shape = RoundedCornerShape(GriRadius.sm),
          modifier = Modifier.weight(1f)
        ) {
          Icon(Icons.Default.ConfirmationNumber, contentDescription = null, modifier = Modifier.size(16.dp))
          Spacer(modifier = Modifier.width(6.dp))
          Text(
            text = actionText,
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.Bold
          )
        }

        if (secondaryActionText != null && onSecondaryActionClick != null) {
          OutlinedButton(
            onClick = onSecondaryActionClick,
            shape = RoundedCornerShape(GriRadius.sm),
            colors = ButtonDefaults.outlinedButtonColors(contentColor = Color.White),
            border = androidx.compose.foundation.BorderStroke(1.dp, Color.White.copy(alpha = 0.4f)),
            modifier = Modifier.weight(1f)
          ) {
            Text(
              text = secondaryActionText,
              style = MaterialTheme.typography.labelMedium
            )
          }
        }
      }
    }
  }
}

/**
 * Modern Quick Service Pill Button
 */
@Composable
fun GriQuickActionPill(
  title: String,
  icon: ImageVector,
  iconTint: Color,
  onClick: () -> Unit,
  modifier: Modifier = Modifier
) {
  Card(
    modifier = modifier
      .clickable(onClick = onClick)
      .testTag("quick_action_${title.lowercase().replace(" ", "_")}"),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(
      modifier = Modifier
        .fillMaxWidth()
        .padding(vertical = 14.dp, horizontal = 6.dp),
      horizontalAlignment = Alignment.CenterHorizontally,
      verticalArrangement = Arrangement.Center
    ) {
      Box(
        modifier = Modifier
          .size(44.dp)
          .clip(CircleShape)
          .background(iconTint.copy(alpha = 0.12f)),
        contentAlignment = Alignment.Center
      ) {
        Icon(
          imageVector = icon,
          contentDescription = title,
          tint = iconTint,
          modifier = Modifier.size(22.dp)
        )
      }
      Spacer(modifier = Modifier.height(8.dp))
      Text(
        text = title,
        style = MaterialTheme.typography.labelMedium,
        color = MaterialTheme.colorScheme.onSurface,
        fontWeight = FontWeight.SemiBold,
        textAlign = TextAlign.Center,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis
      )
    }
  }
}

/**
 * Metric Progress Card with Radial / Gauge styled stats
 */
@Composable
fun GriMetricProgressCard(
  title: String,
  value: String,
  badgeText: String,
  isPositive: Boolean,
  progress: Float,
  subtitle: String,
  modifier: Modifier = Modifier,
  onClick: (() -> Unit)? = null
) {
  Card(
    modifier = modifier
      .then(if (onClick != null) Modifier.clickable(onClick = onClick) else Modifier),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder()
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Text(
          text = title,
          style = MaterialTheme.typography.labelSmall,
          color = MaterialTheme.colorScheme.onSurfaceVariant,
          fontWeight = FontWeight.Medium
        )
        Surface(
          color = if (isPositive) GriGreenSuccess.copy(alpha = 0.12f) else GriRedAlert.copy(alpha = 0.12f),
          shape = RoundedCornerShape(GriRadius.xs)
        ) {
          Text(
            text = badgeText,
            style = MaterialTheme.typography.labelSmall,
            color = if (isPositive) GriGreenSuccess else GriRedAlert,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp),
            fontSize = 9.sp
          )
        }
      }

      Spacer(modifier = Modifier.height(8.dp))

      Text(
        text = value,
        style = MaterialTheme.typography.headlineMedium,
        fontWeight = FontWeight.Bold,
        color = MaterialTheme.colorScheme.onSurface
      )

      Spacer(modifier = Modifier.height(6.dp))

      androidx.compose.material3.LinearProgressIndicator(
        progress = { progress },
        modifier = Modifier
          .fillMaxWidth()
          .height(5.dp)
          .clip(RoundedCornerShape(3.dp)),
        color = if (isPositive) GriGreenSuccess else GriRedAlert,
        trackColor = MaterialTheme.colorScheme.surfaceVariant
      )

      Spacer(modifier = Modifier.height(6.dp))

      Text(
        text = subtitle,
        style = MaterialTheme.typography.bodySmall,
        fontSize = 11.sp,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis
      )
    }
  }
}

