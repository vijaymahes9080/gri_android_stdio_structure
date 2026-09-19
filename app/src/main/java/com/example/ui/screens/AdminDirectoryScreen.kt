package com.example.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AdminPanelSettings
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.CloudDone
import androidx.compose.material.icons.filled.CloudSync
import androidx.compose.material.icons.filled.ExpandLess
import androidx.compose.material.icons.filled.ExpandMore
import androidx.compose.material.icons.filled.Fingerprint
import androidx.compose.material.icons.filled.HealthAndSafety
import androidx.compose.material.icons.filled.HistoryEdu
import androidx.compose.material.icons.filled.Language
import androidx.compose.material.icons.filled.LocalHospital
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.PowerSettingsNew
import androidx.compose.material.icons.filled.Publish
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Sync
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material.icons.filled.VpnKey
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.local.UserRole
import com.example.ui.GriUiState
import com.example.ui.theme.GriForestContainer
import com.example.ui.theme.GriForestFixed
import com.example.ui.theme.GriForestOnContainer
import com.example.ui.theme.GriForestOnFixed
import com.example.ui.theme.GriForestPrimary
import com.example.ui.theme.GriOchreContainer
import com.example.ui.theme.GriOchreFixed
import com.example.ui.theme.GriOchreOnContainer
import com.example.ui.theme.GriOchreOnFixed
import com.example.ui.theme.GriOnSurface
import com.example.ui.theme.GriOnSurfaceVariant
import com.example.ui.theme.GriOutline
import com.example.ui.theme.GriOutlineVariant
import com.example.ui.theme.GriSurface
import com.example.ui.theme.GriSurfaceContainer
import com.example.ui.theme.GriSurfaceContainerHigh
import com.example.ui.theme.GriSurfaceContainerLow
import com.example.ui.theme.GriSurfaceContainerLowest
import com.example.ui.theme.GriTealContainer
import com.example.ui.theme.GriTealOnContainer
import com.example.ui.theme.GriTealSecondary

/**
 * Stitch Screen 8: Admin & Campus Directory / More Tab
 * gandhigram_rural_institute/gri_ecosystem_admin_directory.html
 */
@Composable
fun AdminDirectoryScreen(
  uiState: GriUiState,
  onRoleSelected: (UserRole) -> Unit,
  onTriggerSync: () -> Unit,
  onToggleServer: () -> Unit = {},
  onPublishCircular: (title: String, category: String, summary: String, isUrgent: Boolean, issuedBy: String) -> Unit = { _, _, _, _, _ -> },
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  var isGovTerminalExpanded by remember { mutableStateOf(uiState.isGovernanceTerminalExpanded) }
  var publishTitle by remember { mutableStateOf("") }
  var publishSummary by remember { mutableStateOf("") }
  var showPublishForm by remember { mutableStateOf(false) }

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("admin_directory_screen"),
    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
    verticalArrangement = Arrangement.spacedBy(14.dp)
  ) {

    // 1. USER IDENTITY & ROLE PRIVILEGE CARD
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_user_identity"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.Top
          ) {
            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.weight(1f)) {
              Box(
                modifier = Modifier
                  .size(46.dp)
                  .clip(CircleShape)
                  .background(GriForestPrimary),
                contentAlignment = Alignment.Center
              ) {
                Icon(Icons.Default.Person, contentDescription = null, tint = Color.White, modifier = Modifier.size(24.dp))
              }
              Spacer(modifier = Modifier.width(12.dp))
              Column {
                Text(uiState.currentUser?.name ?: "Priya S.", fontSize = 16.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
                Text(uiState.currentUser?.department ?: "B.Sc. (Hons) Agriculture • 21AG104", fontSize = 11.sp, color = GriOnSurfaceVariant)
                Text("Samarth ERP UID: GRI-2021-AG891", fontSize = 10.sp, color = GriOutline)
              }
            }

            Surface(
              shape = RoundedCornerShape(999.dp),
              color = GriForestFixed
            ) {
              Text(
                text = uiState.currentRole.name,
                fontSize = 10.sp,
                fontWeight = FontWeight.Bold,
                color = GriForestOnFixed,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
              )
            }
          }

          Spacer(modifier = Modifier.height(12.dp))

          // Biometrics & Govt e-KYC status bar
          Surface(
            shape = RoundedCornerShape(8.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier.fillMaxWidth()
          ) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(10.dp),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Default.Fingerprint, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(16.dp))
                Spacer(modifier = Modifier.width(6.dp))
                Text("Biometrics: Enabled & Linked", fontSize = 11.sp, color = GriOnSurface, fontWeight = FontWeight.Medium)
              }
              Text("Govt. e-KYC Verified", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
            }
          }

          Spacer(modifier = Modifier.height(10.dp))

          // Multi-Role Switcher Strip
          Text("Simulation & Role Switcher", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriOutline)
          Spacer(modifier = Modifier.height(6.dp))
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
          ) {
            RoleSwitchChip(title = "Student", role = UserRole.STUDENT, current = uiState.currentRole, onSelect = onRoleSelected, modifier = Modifier.weight(1f))
            RoleSwitchChip(title = "Faculty", role = UserRole.FACULTY, current = uiState.currentRole, onSelect = onRoleSelected, modifier = Modifier.weight(1f))
            RoleSwitchChip(title = "Admin", role = UserRole.ADMIN, current = uiState.currentRole, onSelect = onRoleSelected, modifier = Modifier.weight(1f))
            RoleSwitchChip(title = "Guest", role = UserRole.GUEST, current = uiState.currentRole, onSelect = onRoleSelected, modifier = Modifier.weight(1f))
          }
        }
      }
    }

    // 2. ADMINISTRATIVE & GOVERNANCE TERMINAL (EXPANDABLE)
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_governance_terminal"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(
            modifier = Modifier
              .fillMaxWidth()
              .clickable { isGovTerminalExpanded = !isGovTerminalExpanded },
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Box(
                modifier = Modifier
                  .size(32.dp)
                  .clip(CircleShape)
                  .background(GriForestContainer),
                contentAlignment = Alignment.Center
              ) {
                Icon(Icons.Default.AdminPanelSettings, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
              }
              Spacer(modifier = Modifier.width(10.dp))
              Column {
                Text("Administrative Governance Terminal", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
                Text("Authorised Officers & System Administration", fontSize = 10.sp, color = GriOutline)
              }
            }

            Icon(
              imageVector = if (isGovTerminalExpanded) Icons.Default.ExpandLess else Icons.Default.ExpandMore,
              contentDescription = null,
              tint = GriForestPrimary
            )
          }

          AnimatedVisibility(visible = isGovTerminalExpanded) {
            Column(modifier = Modifier.padding(top = 12.dp)) {
              // Live System Cohort Stats
              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
              ) {
                AdminStatBox(number = "1,420", label = "Active Students", modifier = Modifier.weight(1f))
                AdminStatBox(number = "184", label = "Faculty Nodes", modifier = Modifier.weight(1f))
                AdminStatBox(number = "42", label = "Pending Sync", modifier = Modifier.weight(1f))
              }

              Spacer(modifier = Modifier.height(10.dp))

              // Embedded Server & Cloud Sync Controls (Functional preservation)
              Surface(
                shape = RoundedCornerShape(8.dp),
                color = GriSurfaceContainerLow,
                modifier = Modifier.fillMaxWidth()
              ) {
                Column(modifier = Modifier.padding(10.dp)) {
                  Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                  ) {
                    Column {
                      Text("Local Ktor ERP Server", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
                      Text("Port 8080 • ${uiState.ktorServerStatus}", fontSize = 10.sp, color = GriForestPrimary)
                    }
                    Button(
                      onClick = onToggleServer,
                      shape = RoundedCornerShape(6.dp),
                      colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White),
                      contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp)
                    ) {
                      Text("Re-Verify", fontSize = 11.sp)
                    }
                  }

                  Spacer(modifier = Modifier.height(6.dp))

                  Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                  ) {
                    Column {
                      Text("Cloud Data Synchronizer", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
                      Text(if (uiState.isSyncing) "Sync in progress..." else "Sync status: Up to date", fontSize = 10.sp, color = GriOutline)
                    }
                    Button(
                      onClick = onTriggerSync,
                      shape = RoundedCornerShape(6.dp),
                      colors = ButtonDefaults.buttonColors(containerColor = GriSurfaceContainerHigh, contentColor = GriForestPrimary),
                      contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp)
                    ) {
                      Icon(Icons.Default.Sync, contentDescription = null, modifier = Modifier.size(13.dp))
                      Spacer(modifier = Modifier.width(4.dp))
                      Text("Sync Now", fontSize = 11.sp, fontWeight = FontWeight.Bold)
                    }
                  }
                }
              }

              Spacer(modifier = Modifier.height(10.dp))

              // Notice Publisher Toggle
              Button(
                onClick = { showPublishForm = !showPublishForm },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White),
                modifier = Modifier.fillMaxWidth()
              ) {
                Icon(Icons.Default.Publish, contentDescription = null, modifier = Modifier.size(15.dp))
                Spacer(modifier = Modifier.width(6.dp))
                Text(if (showPublishForm) "Close Publisher Form" else "Publish Official Notice / Circular", fontSize = 12.sp, fontWeight = FontWeight.Bold)
              }

              if (showPublishForm) {
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                  value = publishTitle,
                  onValueChange = { publishTitle = it },
                  label = { Text("Circular Title", fontSize = 11.sp) },
                  modifier = Modifier.fillMaxWidth()
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                  value = publishSummary,
                  onValueChange = { publishSummary = it },
                  label = { Text("Executive Summary", fontSize = 11.sp) },
                  minLines = 2,
                  modifier = Modifier.fillMaxWidth()
                )
                Spacer(modifier = Modifier.height(8.dp))
                Button(
                  onClick = {
                    if (publishTitle.isNotBlank()) {
                      onPublishCircular(publishTitle, "Official Circular", publishSummary, true, "Registrar")
                      publishTitle = ""
                      publishSummary = ""
                      showPublishForm = false
                    }
                  },
                  shape = RoundedCornerShape(6.dp),
                  colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White)
                ) {
                  Text("Publish with SHA-256 Ledger Entry", fontSize = 11.sp, fontWeight = FontWeight.Bold)
                }
              }
            }
          }
        }
      }
    }

    // 3. INSTITUTIONAL DISPATCH (NOTIFICATIONS CENTER)
    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Icon(Icons.Default.Notifications, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(18.dp))
              Spacer(modifier = Modifier.width(6.dp))
              Text("Institutional Dispatch", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
            }
            Text("3 Alerts", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriOchreContainer)
          }

          Spacer(modifier = Modifier.height(10.dp))

          DispatchNotificationItem(
            priority = "CRITICAL",
            title = "End-Semester Hall Ticket Biometric Clearance",
            desc = "Ensure department dues and biometric logs are synced before 15 April."
          )

          DispatchNotificationItem(
            priority = "ACADEMIC",
            title = "CIA-II Internal Assessment Schedule",
            desc = "Agro-Informatics retest scheduled on Monday at 02:00 PM."
          )

          DispatchNotificationItem(
            priority = "SUMMIT",
            title = "Rural Technology Innovation Summit",
            desc = "Delegates registration active. Student exhibition passes ready."
          )
        }
      }
    }

    // 4. INSTITUTIONAL HERITAGE & MISSION
    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.HistoryEdu, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(18.dp))
            Spacer(modifier = Modifier.width(6.dp))
            Text("Gandhian Rural Heritage (Estd. 1956)", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
          }
          Spacer(modifier = Modifier.height(6.dp))
          Text(
            text = "Founded under Nai Talim principles by disciples of Mahatma Gandhi: Dr. T.S. Soundram and Dr. G. Ramachandran. Conferred Deemed to be University status by MoE, Govt of India.",
            fontSize = 11.sp,
            color = GriOnSurfaceVariant,
            lineHeight = 16.sp
          )
          Spacer(modifier = Modifier.height(8.dp))
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            Text("NAAC Grade: A+ (CGPA 3.61)", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
            Text("Motto: கிராமம் உயர நாடு உயரும்", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriTealSecondary)
          }
        }
      }
    }

    // 5. 24x7 EMERGENCY SOS CONTACTS
    item {
      Surface(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        color = GriSurfaceContainerHigh
      ) {
        Column(modifier = Modifier.padding(12.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.HealthAndSafety, contentDescription = null, tint = Color(0xFFBA1A1A), modifier = Modifier.size(18.dp))
            Spacer(modifier = Modifier.width(6.dp))
            Text("24x7 Emergency Campus SOS", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
          }
          Spacer(modifier = Modifier.height(8.dp))
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
          ) {
            SosDialButton(label = "Health Centre", ext = "Ext. 222", phone = "04512452371", modifier = Modifier.weight(1f))
            SosDialButton(label = "Gate 1 Police", ext = "Gate 1", phone = "100", modifier = Modifier.weight(1f))
            SosDialButton(label = "Ambulance", ext = "24x7 Direct", phone = "108", modifier = Modifier.weight(1f))
          }
        }
      }
    }

    // 6. BUILD & LEGAL FOOTER
    item {
      Column(
        modifier = Modifier
          .fillMaxWidth()
          .padding(vertical = 8.dp),
        horizontalAlignment = Alignment.CenterHorizontally
      ) {
        Text("GRI Campus OS • Build v3.4.2", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriOutline)
        Text("Samarth e-Gov Integrated • Ministry of Education", fontSize = 9.sp, color = GriOutline)
      }
    }
  }
}

@Composable
fun RoleSwitchChip(
  title: String,
  role: UserRole,
  current: UserRole,
  onSelect: (UserRole) -> Unit,
  modifier: Modifier = Modifier
) {
  val isSelected = current == role
  Surface(
    shape = RoundedCornerShape(8.dp),
    color = if (isSelected) GriForestPrimary else GriSurfaceContainerLow,
    modifier = modifier.clickable { onSelect(role) }
  ) {
    Text(
      text = title,
      fontSize = 11.sp,
      fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
      color = if (isSelected) Color.White else GriOnSurface,
      modifier = Modifier
        .padding(vertical = 8.dp)
        .fillMaxWidth(),
      textAlign = androidx.compose.ui.text.style.TextAlign.Center
    )
  }
}

@Composable
fun AdminStatBox(number: String, label: String, modifier: Modifier = Modifier) {
  Surface(
    shape = RoundedCornerShape(8.dp),
    color = GriSurfaceContainerLow,
    modifier = modifier
  ) {
    Column(
      modifier = Modifier.padding(8.dp),
      horizontalAlignment = Alignment.CenterHorizontally
    ) {
      Text(number, fontSize = 16.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
      Text(label, fontSize = 9.sp, color = GriOutline)
    }
  }
}

@Composable
fun DispatchNotificationItem(priority: String, title: String, desc: String) {
  Surface(
    shape = RoundedCornerShape(8.dp),
    color = GriSurfaceContainerLow,
    modifier = Modifier
      .fillMaxWidth()
      .padding(vertical = 3.dp)
  ) {
    Column(modifier = Modifier.padding(8.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
      ) {
        Surface(
          shape = RoundedCornerShape(4.dp),
          color = if (priority == "CRITICAL") Color(0xFFBA1A1A) else GriForestContainer
        ) {
          Text(priority, fontSize = 8.sp, fontWeight = FontWeight.Bold, color = Color.White, modifier = Modifier.padding(horizontal = 4.dp, vertical = 1.dp))
        }
        Text("Today", fontSize = 9.sp, color = GriOutline)
      }
      Spacer(modifier = Modifier.height(2.dp))
      Text(title, fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
      Text(desc, fontSize = 10.sp, color = GriOnSurfaceVariant)
    }
  }
}

@Composable
fun SosDialButton(label: String, ext: String, phone: String, modifier: Modifier = Modifier) {
  val context = LocalContext.current
  Surface(
    shape = RoundedCornerShape(8.dp),
    color = GriSurfaceContainerLowest,
    modifier = modifier.clickable {
      val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:$phone"))
      try { context.startActivity(intent) } catch (_: Exception) {}
    }
  ) {
    Column(
      modifier = Modifier.padding(8.dp),
      horizontalAlignment = Alignment.CenterHorizontally
    ) {
      Icon(Icons.Default.Call, contentDescription = null, tint = Color(0xFFBA1A1A), modifier = Modifier.size(14.dp))
      Spacer(modifier = Modifier.height(2.dp))
      Text(label, fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
      Text(ext, fontSize = 8.sp, color = GriOutline)
    }
  }
}
