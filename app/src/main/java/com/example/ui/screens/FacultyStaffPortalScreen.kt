package com.example.ui.screens

import android.content.Intent
import android.net.Uri
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
import androidx.compose.material.icons.filled.Assignment
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.EditNote
import androidx.compose.material.icons.filled.EventNote
import androidx.compose.material.icons.filled.FactCheck
import androidx.compose.material.icons.filled.Grade
import androidx.compose.material.icons.filled.HowToReg
import androidx.compose.material.icons.filled.PendingActions
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.QrCode
import androidx.compose.material.icons.filled.Science
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
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
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
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
 * Stitch Screen 6: Faculty & Staff Portal
 * gandhigram_rural_institute/faculty_staff_portal.html
 */
@Composable
fun FacultyStaffPortalScreen(
  uiState: GriUiState,
  onMarkAttendance: (String) -> Unit = {},
  onApplyLeave: () -> Unit = {},
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  var attendanceMarked by remember { mutableStateOf(false) }
  var approval1Processed by remember { mutableStateOf(false) }

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("faculty_staff_portal_screen"),
    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
    verticalArrangement = Arrangement.spacedBy(14.dp)
  ) {

    // 1. FACULTY TOP STATUS BANNER
    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.weight(1f)) {
            Box(
              modifier = Modifier
                .size(44.dp)
                .clip(CircleShape)
                .background(GriForestPrimary),
              contentAlignment = Alignment.Center
            ) {
              Icon(Icons.Default.Person, contentDescription = null, tint = Color.White, modifier = Modifier.size(24.dp))
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column {
              Text("Dr. R. Sundaram", fontSize = 16.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
              Text("Dean, Dept of Agriculture & Extension", fontSize = 11.sp, color = GriOnSurfaceVariant)
              Text("ID: GRI-FAC-1988 • Regular Faculty", fontSize = 10.sp, color = GriOutline)
            }
          }

          Surface(
            shape = RoundedCornerShape(999.dp),
            color = GriSurfaceContainerLow
          ) {
            Text(
              text = "Even '24-25",
              fontSize = 11.sp,
              fontWeight = FontWeight.Bold,
              color = GriForestPrimary,
              modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp)
            )
          }
        }
      }
    }

    // 2. LIVE CLASSROOM STATUS BANNER
    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriForestPrimary)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Surface(
              shape = RoundedCornerShape(999.dp),
              color = GriForestFixed
            ) {
              Text(
                text = "UPCOMING LECTURE • STARTS IN 25m",
                fontSize = 9.sp,
                fontWeight = FontWeight.Bold,
                color = GriForestOnFixed,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
              )
            }
            Text("10:30 AM - 11:30 AM", fontSize = 11.sp, color = Color.White.copy(alpha = 0.8f))
          }

          Spacer(modifier = Modifier.height(8.dp))
          Text(
            text = "AG-302: Rural Extension & Comm. Dev",
            fontSize = 16.sp,
            fontWeight = FontWeight.Bold,
            color = Color.White
          )
          Text(
            text = "GM Hall Rm 12 • 64 Registered Scholars • Unit IV Micro-credit",
            fontSize = 11.sp,
            color = Color.White.copy(alpha = 0.8f),
            modifier = Modifier.padding(top = 2.dp, bottom = 12.dp)
          )

          Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(
              onClick = {
                onMarkAttendance("AG-302")
                attendanceMarked = true
              },
              shape = RoundedCornerShape(8.dp),
              colors = ButtonDefaults.buttonColors(containerColor = GriForestFixed, contentColor = GriForestOnFixed),
              contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
            ) {
              Icon(Icons.Default.QrCode, contentDescription = null, modifier = Modifier.size(14.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text(if (attendanceMarked) "Roll Recorded ✓" else "Open Attendance QR", fontSize = 11.sp, fontWeight = FontWeight.Bold)
            }

            Button(
              onClick = {},
              shape = RoundedCornerShape(8.dp),
              colors = ButtonDefaults.buttonColors(containerColor = Color.White.copy(alpha = 0.2f), contentColor = Color.White),
              contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
            ) {
              Text("Class Roster", fontSize = 11.sp, fontWeight = FontWeight.SemiBold)
            }
          }
        }
      }
    }

    // 3. FACULTY WORKFLOWS (6 GRID CARDS)
    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Text("Faculty Academic Operations", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
          Spacer(modifier = Modifier.height(10.dp))

          Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            FacultyWorkflowTile(title = "Attendance", sub = "Live QR / Roll", icon = Icons.Default.HowToReg, modifier = Modifier.weight(1f))
            FacultyWorkflowTile(title = "CIA Marks", sub = "3d left • Entry", icon = Icons.Default.EditNote, badge = "Due", modifier = Modifier.weight(1f))
            FacultyWorkflowTile(title = "Exam Roster", sub = "Hall Alloc.", icon = Icons.Default.FactCheck, modifier = Modifier.weight(1f))
          }

          Spacer(modifier = Modifier.height(8.dp))

          Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            FacultyWorkflowTile(title = "End-Sem", sub = "Grade Approval", icon = Icons.Default.Grade, modifier = Modifier.weight(1f))
            FacultyWorkflowTile(title = "Leave & OD", sub = "3 Approvals", icon = Icons.Default.EventNote, badge = "3", modifier = Modifier.weight(1f), onClick = onApplyLeave)
            FacultyWorkflowTile(title = "Research", sub = "DST / ICAR", icon = Icons.Default.Science, modifier = Modifier.weight(1f))
          }
        }
      }
    }

    // 4. ALLOCATED COURSES
    item {
      Text("Allocated Teaching Courses", fontSize = 15.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
    }

    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.5.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Surface(shape = RoundedCornerShape(4.dp), color = GriForestContainer) {
              Text("AG-302", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = Color.White, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
            }
            Text("64 Students • 4 Credits", fontSize = 11.sp, color = GriOutline)
          }

          Spacer(modifier = Modifier.height(4.dp))
          Text("Rural Extension & Sustainable Development", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
          Text("Avg Attendance: 92% • Syllabus Covered: 78%", fontSize = 11.sp, color = GriForestPrimary, modifier = Modifier.padding(top = 2.dp, bottom = 8.dp))

          Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(
              onClick = {
                onMarkAttendance("AG-302")
                attendanceMarked = true
              },
              shape = RoundedCornerShape(6.dp),
              colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White),
              contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp)
            ) {
              Text(if (attendanceMarked) "Recorded ✓" else "Mark Today's Attendance", fontSize = 11.sp, fontWeight = FontWeight.Bold)
            }
          }
        }
      }
    }

    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.5.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Surface(shape = RoundedCornerShape(4.dp), color = GriTealContainer) {
              Text("AG-304", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriTealOnContainer, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
            }
            Text("58 Scholars • 4 Credits", fontSize = 11.sp, color = GriOutline)
          }

          Spacer(modifier = Modifier.height(4.dp))
          Text("Soil Fertility & Organic Agriculture Management", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
          Text("CIA-I Average: 23.4 / 25 • Entry Deadline: 04 May", fontSize = 11.sp, color = GriOchreContainer, modifier = Modifier.padding(top = 2.dp, bottom = 8.dp))

          Button(
            onClick = {},
            shape = RoundedCornerShape(6.dp),
            colors = ButtonDefaults.buttonColors(containerColor = GriSurfaceContainerHigh, contentColor = GriForestPrimary),
            contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp)
          ) {
            Text("Submit CIA-II Internal Marks", fontSize = 11.sp, fontWeight = FontWeight.Bold)
          }
        }
      }
    }

    // 5. DEAN'S DESK APPROVALS (ACTION ITEMS)
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
            Text("Dean's Desk Approvals", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
            Text("2 Pending", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriOchreContainer)
          }

          Spacer(modifier = Modifier.height(10.dp))

          if (!approval1Processed) {
            Surface(
              shape = RoundedCornerShape(8.dp),
              color = GriSurfaceContainerLow,
              modifier = Modifier.fillMaxWidth()
            ) {
              Column(modifier = Modifier.padding(10.dp)) {
                Row(
                  modifier = Modifier.fillMaxWidth(),
                  horizontalArrangement = Arrangement.SpaceBetween
                ) {
                  Text("M. Karthik Raja (22AG104)", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
                  Text("Student OD", fontSize = 10.sp, color = GriForestPrimary, fontWeight = FontWeight.Bold)
                }
                Text("ICAR National Youth Innovation Summit • 3 Days OD", fontSize = 11.sp, color = GriOnSurfaceVariant, modifier = Modifier.padding(vertical = 4.dp))

                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                  Button(
                    onClick = { approval1Processed = true },
                    shape = RoundedCornerShape(6.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White),
                    contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp)
                  ) {
                    Icon(Icons.Default.Check, contentDescription = null, modifier = Modifier.size(12.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Approve", fontSize = 10.sp, fontWeight = FontWeight.Bold)
                  }

                  Button(
                    onClick = { approval1Processed = true },
                    shape = RoundedCornerShape(6.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = GriSurfaceContainerHigh, contentColor = GriOnSurface),
                    contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp)
                  ) {
                    Text("Review", fontSize = 10.sp)
                  }
                }
              }
            }
          } else {
            Text("✓ Karthik Raja's OD approved and forwarded to CoE.", fontSize = 11.sp, color = GriForestPrimary, fontWeight = FontWeight.Medium)
          }
        }
      }
    }
  }
}

@Composable
fun FacultyWorkflowTile(
  title: String,
  sub: String,
  icon: ImageVector,
  modifier: Modifier = Modifier,
  badge: String? = null,
  onClick: () -> Unit = {}
) {
  Surface(
    shape = RoundedCornerShape(10.dp),
    color = GriSurfaceContainerLow,
    modifier = modifier.clickable(onClick = onClick)
  ) {
    Column(
      modifier = Modifier.padding(8.dp),
      horizontalAlignment = Alignment.CenterHorizontally
    ) {
      Box(contentAlignment = Alignment.TopEnd) {
        Icon(imageVector = icon, contentDescription = title, tint = GriForestPrimary, modifier = Modifier.size(22.dp))
        if (badge != null) {
          Surface(
            shape = RoundedCornerShape(999.dp),
            color = Color(0xFFBA1A1A),
            modifier = Modifier.padding(start = 14.dp)
          ) {
            Text(badge, fontSize = 7.sp, fontWeight = FontWeight.Bold, color = Color.White, modifier = Modifier.padding(horizontal = 3.dp, vertical = 1.dp))
          }
        }
      }
      Spacer(modifier = Modifier.height(4.dp))
      Text(title, fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriOnSurface, maxLines = 1)
      Text(sub, fontSize = 8.sp, color = GriOutline, maxLines = 1)
    }
  }
}
