package com.example.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.Image
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
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.Campaign
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.ConfirmationNumber
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.EventAvailable
import androidx.compose.material.icons.filled.FactCheck
import androidx.compose.material.icons.filled.Grade
import androidx.compose.material.icons.filled.Groups
import androidx.compose.material.icons.filled.HealthAndSafety
import androidx.compose.material.icons.filled.LocalLibrary
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.MarkEmailUnread
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.OpenInNew
import androidx.compose.material.icons.filled.Payments
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.SyncAlt
import androidx.compose.material.icons.filled.Tune
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
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
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.R
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
import com.example.ui.theme.GriOchreTertiary
import com.example.ui.theme.GriOnSurface
import com.example.ui.theme.GriOnSurfaceVariant
import com.example.ui.theme.GriOutline
import com.example.ui.theme.GriOutlineVariant
import com.example.ui.theme.GriRadius
import com.example.ui.theme.GriSpacing
import com.example.ui.theme.GriSurface
import com.example.ui.theme.GriSurfaceContainer
import com.example.ui.theme.GriSurfaceContainerHigh
import com.example.ui.theme.GriSurfaceContainerLow
import com.example.ui.theme.GriSurfaceContainerLowest
import com.example.ui.theme.GriTealContainer
import com.example.ui.theme.GriTealOnContainer
import com.example.ui.theme.GriTealSecondary

/**
 * Stitch Screen 1: Home Dashboard
 * gandhigram_rural_institute/gri_home_dashboard.html
 */
@Composable
fun HomeDashboardScreen(
  uiState: GriUiState,
  onFetchHallTicket: () -> Unit,
  onNavigateToGrievances: () -> Unit = {},
  onNavigateToServices: () -> Unit = {},
  onNavigateToAcademics: () -> Unit = {},
  onMarkCircularRead: (String) -> Unit = {},
  onOpenSahayak: () -> Unit = {},
  onRoleSelected: (UserRole) -> Unit = {},
  onNavigateToDocuments: () -> Unit = {},
  onNavigateToTimetable: () -> Unit = {},
  onNavigateToCampus: () -> Unit = {},
  onNavigateToAdmin: () -> Unit = {},
  onNavigateToFaculty: () -> Unit = {},
  onOpenAiSearch: () -> Unit = onOpenSahayak,
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  var searchQuery by remember { mutableStateOf("") }
  var showRoleDialog by remember { mutableStateOf(false) }

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("home_screen"),
    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
    verticalArrangement = Arrangement.spacedBy(14.dp)
  ) {

    // 1. GREETING & ROLE BAR
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_greeting"),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.Top
        ) {
          Column(modifier = Modifier.weight(1f)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Text(
                text = "Vanakkam, ${uiState.currentUser?.name ?: "Priya S."}",
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = GriForestPrimary,
                letterSpacing = (-0.2).sp
              )
              Spacer(modifier = Modifier.width(6.dp))
              Box(
                modifier = Modifier
                  .size(8.dp)
                  .clip(CircleShape)
                  .background(GriTealSecondary)
              )
            }
            Text(
              text = uiState.currentUser?.department ?: "B.Sc (Hons) Agriculture • Sem VI",
              fontSize = 12.sp,
              color = GriOnSurfaceVariant,
              maxLines = 1,
              overflow = TextOverflow.Ellipsis
            )
            Text(
              text = "ROLL: ${uiState.currentUser?.rollNo ?: "21AG104"}",
              fontSize = 10.sp,
              fontWeight = FontWeight.Bold,
              color = GriOutline,
              letterSpacing = 0.5.sp,
              modifier = Modifier.padding(top = 2.dp)
            )
          }

          // Quick Role Indicator Switcher Pill
          Surface(
            shape = RoundedCornerShape(999.dp),
            color = GriSurfaceContainer,
            modifier = Modifier.clickable { showRoleDialog = true }
          ) {
            Row(
              modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp),
              verticalAlignment = Alignment.CenterVertically
            ) {
              Icon(
                imageVector = Icons.Default.School,
                contentDescription = null,
                tint = GriForestPrimary,
                modifier = Modifier.size(13.dp)
              )
              Spacer(modifier = Modifier.width(4.dp))
              Text(
                text = uiState.currentRole.name,
                fontSize = 11.sp,
                fontWeight = FontWeight.Bold,
                color = GriForestPrimary
              )
              Spacer(modifier = Modifier.width(4.dp))
              Icon(
                imageVector = Icons.Default.SyncAlt,
                contentDescription = "Switch Role",
                tint = GriOnSurfaceVariant,
                modifier = Modifier.size(14.dp)
              )
            }
          }
        }
      }
    }

    // 2. CRITICAL ANNOUNCEMENT BANNER (HALL TICKET ALERT)
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("banner_hall_ticket_alert"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.5.dp)
      ) {
        Box(modifier = Modifier.fillMaxWidth()) {
          // Heritage Saffron Warm Ambient Indicator
          Box(
            modifier = Modifier
              .matchParentSize()
              .background(GriOchreFixed.copy(alpha = 0.25f))
          )

          Row(
            modifier = Modifier
              .fillMaxWidth()
              .padding(16.dp),
            verticalAlignment = Alignment.Top
          ) {
            Box(
              modifier = Modifier
                .size(42.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(GriOchreContainer),
              contentAlignment = Alignment.Center
            ) {
              Icon(
                imageVector = Icons.Default.Campaign,
                contentDescription = null,
                tint = Color.White,
                modifier = Modifier.size(24.dp)
              )
            }

            Spacer(modifier = Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
              Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.padding(bottom = 4.dp)
              ) {
                Surface(
                  shape = RoundedCornerShape(999.dp),
                  color = GriOchreContainer
                ) {
                  Text(
                    text = "URGENT NOTICE",
                    fontSize = 9.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White,
                    letterSpacing = 0.5.sp,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                  )
                }
                Text(
                  text = " • End Sem Exam 2025",
                  fontSize = 11.sp,
                  color = GriOutline,
                  fontWeight = FontWeight.Medium
                )
              }

              Text(
                text = "End Semester Examinations (April-May 2025) Hall Tickets now live.",
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface,
                lineHeight = 19.sp
              )
              Text(
                text = "Download and verify departmental endorsement before 15th April.",
                fontSize = 12.sp,
                color = GriOnSurfaceVariant,
                modifier = Modifier.padding(top = 2.dp, bottom = 10.dp)
              )

              Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Button(
                  onClick = onFetchHallTicket,
                  shape = RoundedCornerShape(8.dp),
                  colors = ButtonDefaults.buttonColors(
                    containerColor = GriForestPrimary,
                    contentColor = Color.White
                  ),
                  contentPadding = PaddingValues(horizontal = 14.dp, vertical = 8.dp),
                  modifier = Modifier.testTag("btn_download_hall_ticket")
                ) {
                  Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(16.dp))
                  Spacer(modifier = Modifier.width(4.dp))
                  Text("Download", fontSize = 12.sp, fontWeight = FontWeight.Bold)
                }

                Button(
                  onClick = onNavigateToDocuments,
                  shape = RoundedCornerShape(8.dp),
                  colors = ButtonDefaults.buttonColors(
                    containerColor = GriSurfaceContainerHigh,
                    contentColor = GriForestPrimary
                  ),
                  contentPadding = PaddingValues(horizontal = 12.dp, vertical = 8.dp),
                  modifier = Modifier.testTag("btn_hall_ticket_instructions")
                ) {
                  Text("Instructions", fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                }
              }
            }
          }
        }
      }
    }

    // 3. INTERACTIVE SEARCH / ASK AI BAR
    item {
      Surface(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("home_search_bar"),
        shape = RoundedCornerShape(12.dp),
        color = GriSurfaceContainerLowest,
        shadowElevation = 1.dp
      ) {
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 12.dp, vertical = 6.dp),
          verticalAlignment = Alignment.CenterVertically
        ) {
          IconButton(
            onClick = onOpenAiSearch,
            modifier = Modifier.size(32.dp)
          ) {
            Icon(
              imageVector = Icons.Default.Search,
              contentDescription = "Search",
              tint = GriForestPrimary,
              modifier = Modifier.size(20.dp)
            )
          }
          Spacer(modifier = Modifier.width(4.dp))
          Box(modifier = Modifier.weight(1f)) {
            if (searchQuery.isEmpty()) {
              Text(
                text = "Search courses, circulars, or Ask GRI AI...",
                fontSize = 13.sp,
                color = GriOutline
              )
            }
            androidx.compose.foundation.text.BasicTextField(
              value = searchQuery,
              onValueChange = { searchQuery = it },
              singleLine = true,
              keyboardOptions = KeyboardOptions(imeAction = ImeAction.Search),
              keyboardActions = KeyboardActions(onSearch = {
                if (searchQuery.isNotBlank()) onOpenAiSearch()
              }),
              textStyle = androidx.compose.ui.text.TextStyle(
                fontSize = 13.sp,
                color = GriOnSurface
              ),
              modifier = Modifier.fillMaxWidth()
            )
          }

          IconButton(
            onClick = onOpenSahayak,
            modifier = Modifier.size(32.dp)
          ) {
            Icon(
              imageVector = Icons.Default.Mic,
              contentDescription = "Voice Query",
              tint = GriOnSurfaceVariant,
              modifier = Modifier.size(18.dp)
            )
          }

          IconButton(
            onClick = onOpenSahayak,
            modifier = Modifier.size(32.dp)
          ) {
            Icon(
              imageVector = Icons.Default.Tune,
              contentDescription = "Filter",
              tint = GriOnSurfaceVariant,
              modifier = Modifier.size(18.dp)
            )
          }
        }
      }
    }

    // 4. TODAY'S LIVE SCHEDULE & ATTENDANCE GAUGE CARD
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_today_schedule"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Box(
                modifier = Modifier
                  .size(8.dp)
                  .clip(CircleShape)
                  .background(GriTealSecondary)
              )
              Spacer(modifier = Modifier.width(8.dp))
              Text(
                text = "Today's Schedule",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface
              )
            }
            Row(
              verticalAlignment = Alignment.CenterVertically,
              modifier = Modifier.clickable { onNavigateToAcademics() }
            ) {
              Text(
                text = "Full Week",
                fontSize = 12.sp,
                fontWeight = FontWeight.SemiBold,
                color = GriTealSecondary
              )
              Icon(
                imageVector = Icons.Default.ChevronRight,
                contentDescription = null,
                tint = GriTealSecondary,
                modifier = Modifier.size(16.dp)
              )
            }
          }

          Spacer(modifier = Modifier.height(12.dp))

          // Active Lecture Box
          Surface(
            shape = RoundedCornerShape(10.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier.fillMaxWidth()
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
              ) {
                Surface(
                  shape = RoundedCornerShape(999.dp),
                  color = GriTealContainer
                ) {
                  Text(
                    text = "Next Lecture • 10:30 AM",
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    color = GriTealOnContainer,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                  )
                }
                Text(
                  text = "AG-302",
                  fontSize = 11.sp,
                  fontWeight = FontWeight.Bold,
                  color = GriOutline
                )
              }

              Spacer(modifier = Modifier.height(6.dp))

              Text(
                text = "Rural Extension & Community Dev",
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface
              )

              Spacer(modifier = Modifier.height(6.dp))

              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
              ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                  Icon(
                    imageVector = Icons.Default.LocationOn,
                    contentDescription = null,
                    tint = GriTealSecondary,
                    modifier = Modifier.size(14.dp)
                  )
                  Spacer(modifier = Modifier.width(4.dp))
                  Text(
                    text = "GM Hall Rm 12",
                    fontSize = 11.sp,
                    color = GriOnSurfaceVariant
                  )
                }

                Row(verticalAlignment = Alignment.CenterVertically) {
                  Icon(
                    imageVector = Icons.Default.Person,
                    contentDescription = null,
                    tint = GriTealSecondary,
                    modifier = Modifier.size(14.dp)
                  )
                  Spacer(modifier = Modifier.width(4.dp))
                  Text(
                    text = "Dr. R. Sundaram",
                    fontSize = 11.sp,
                    color = GriOnSurfaceVariant
                  )
                }
              }
            }
          }

          Spacer(modifier = Modifier.height(10.dp))

          // Overall Attendance Widget
          Surface(
            shape = RoundedCornerShape(8.dp),
            color = GriSurfaceContainer,
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
                Box(
                  modifier = Modifier
                    .size(32.dp)
                    .clip(CircleShape)
                    .background(GriForestPrimary),
                  contentAlignment = Alignment.Center
                ) {
                  Icon(
                    imageVector = Icons.Default.FactCheck,
                    contentDescription = null,
                    tint = Color.White,
                    modifier = Modifier.size(18.dp)
                  )
                }
                Spacer(modifier = Modifier.width(10.dp))
                Column {
                  Text(
                    text = "OVERALL ATTENDANCE",
                    fontSize = 9.sp,
                    fontWeight = FontWeight.Bold,
                    color = GriOutline,
                    letterSpacing = 0.5.sp
                  )
                  Text(
                    text = "88.5% • Good Standing",
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Bold,
                    color = GriForestPrimary
                  )
                }
              }

              // Circular Mini Progress Gauge
              Box(
                modifier = Modifier.size(36.dp),
                contentAlignment = Alignment.Center
              ) {
                CircularProgressIndicator(
                  progress = { 0.885f },
                  modifier = Modifier.fillMaxSize(),
                  color = GriForestPrimary,
                  trackColor = GriSurfaceContainerHigh,
                  strokeWidth = 3.5.dp
                )
                Text(
                  text = "88%",
                  fontSize = 10.sp,
                  fontWeight = FontWeight.Bold,
                  color = GriForestPrimary
                )
              }
            }
          }
        }
      }
    }

    // 5. STUDENT DESK (4x2 CLEAN GRID)
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_student_desk"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Text(
              text = "Student Desk",
              fontSize = 16.sp,
              fontWeight = FontWeight.Bold,
              color = GriOnSurface
            )
            Text(
              text = "GRI Samarth Suite",
              fontSize = 11.sp,
              color = GriOutline
            )
          }

          Spacer(modifier = Modifier.height(14.dp))

          // Row 1 (4 items)
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            StudentDeskIconItem(
              title = "Hall Ticket",
              icon = Icons.Default.ConfirmationNumber,
              badgeText = "LIVE",
              badgeColor = GriOchreContainer,
              onClick = onFetchHallTicket,
              modifier = Modifier.weight(1f)
            )
            StudentDeskIconItem(
              title = "Results",
              icon = Icons.Default.Grade,
              onClick = onNavigateToAcademics,
              modifier = Modifier.weight(1f)
            )
            StudentDeskIconItem(
              title = "Attendance",
              icon = Icons.Default.EventAvailable,
              onClick = onNavigateToAcademics,
              modifier = Modifier.weight(1f)
            )
            StudentDeskIconItem(
              title = "Samarth Pay",
              icon = Icons.Default.Payments,
              onClick = onNavigateToServices,
              modifier = Modifier.weight(1f)
            )
          }

          Spacer(modifier = Modifier.height(14.dp))

          // Row 2 (4 items)
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            StudentDeskIconItem(
              title = "Timetable",
              icon = Icons.Default.CalendarMonth,
              onClick = onNavigateToAcademics,
              modifier = Modifier.weight(1f)
            )
            StudentDeskIconItem(
              title = "Circulars",
              icon = Icons.Default.MarkEmailUnread,
              badgeText = "3 New",
              badgeColor = Color(0xFFBA1A1A),
              onClick = onNavigateToDocuments,
              modifier = Modifier.weight(1f)
            )
            StudentDeskIconItem(
              title = "E-Library",
              icon = Icons.Default.LocalLibrary,
              onClick = onNavigateToServices,
              modifier = Modifier.weight(1f)
            )
            StudentDeskIconItem(
              title = "Ask GRI",
              icon = Icons.Default.AutoAwesome,
              badgeText = "GRI AI",
              badgeColor = GriOchreContainer,
              isSpecial = true,
              onClick = onOpenSahayak,
              modifier = Modifier.weight(1f)
            )
          }
        }
      }
    }

    // 6. INSTITUTIONAL CIRCULARS PREVIEW
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_institutional_circulars"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Icon(
                imageVector = Icons.Default.Verified,
                contentDescription = null,
                tint = GriForestPrimary,
                modifier = Modifier.size(18.dp)
              )
              Spacer(modifier = Modifier.width(6.dp))
              Text(
                text = "Institutional Circulars",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface
              )
            }
            Text(
              text = "View All",
              fontSize = 12.sp,
              fontWeight = FontWeight.SemiBold,
              color = GriTealSecondary,
              modifier = Modifier.clickable { onNavigateToDocuments() }
            )
          }

          Spacer(modifier = Modifier.height(10.dp))

          // Circular 1
          Surface(
            shape = RoundedCornerShape(10.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier
              .fillMaxWidth()
              .clickable { onNavigateToDocuments() }
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
              ) {
                Surface(
                  shape = RoundedCornerShape(4.dp),
                  color = GriForestContainer
                ) {
                  Row(
                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp),
                    verticalAlignment = Alignment.CenterVertically
                  ) {
                    Icon(
                      imageVector = Icons.Default.CheckCircle,
                      contentDescription = null,
                      tint = Color.White,
                      modifier = Modifier.size(11.dp)
                    )
                    Spacer(modifier = Modifier.width(3.dp))
                    Text(
                      text = "GRI/AC/2025/112",
                      fontSize = 10.sp,
                      fontWeight = FontWeight.Bold,
                      color = Color.White
                    )
                  }
                }
                Text(
                  text = "Today • PDF (240 KB)",
                  fontSize = 10.sp,
                  color = GriOutline
                )
              }

              Spacer(modifier = Modifier.height(6.dp))

              Text(
                text = "Revised Academic Calendar for Even Semester 2024-25 (UG/PG & Research Programmes).",
                fontSize = 13.sp,
                fontWeight = FontWeight.SemiBold,
                color = GriOnSurface,
                lineHeight = 18.sp
              )

              Spacer(modifier = Modifier.height(6.dp))

              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
              ) {
                Text(
                  text = "Registrar Secretariat",
                  fontSize = 11.sp,
                  color = GriTealSecondary,
                  fontWeight = FontWeight.Medium
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                  Text(
                    text = "Read PDF",
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Bold,
                    color = GriForestPrimary
                  )
                  Icon(
                    imageVector = Icons.AutoMirrored.Filled.ArrowForward,
                    contentDescription = null,
                    tint = GriForestPrimary,
                    modifier = Modifier.size(14.dp)
                  )
                }
              }
            }
          }

          Spacer(modifier = Modifier.height(8.dp))

          // Circular 2
          Surface(
            shape = RoundedCornerShape(10.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier
              .fillMaxWidth()
              .clickable { onNavigateToDocuments() }
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
              ) {
                Surface(
                  shape = RoundedCornerShape(4.dp),
                  color = GriOchreFixed
                ) {
                  Text(
                    text = "Convocation 2025",
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    color = GriOchreOnFixed,
                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                  )
                }
                Text(
                  text = "Yesterday",
                  fontSize = 10.sp,
                  color = GriOutline
                )
              }

              Spacer(modifier = Modifier.height(6.dp))

              Text(
                text = "Registration portal open for graduating batch of 2024. Gown distribution instructions issued.",
                fontSize = 13.sp,
                fontWeight = FontWeight.SemiBold,
                color = GriOnSurface,
                lineHeight = 18.sp
              )

              Spacer(modifier = Modifier.height(6.dp))

              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
              ) {
                Text(
                  text = "Controller of Examinations",
                  fontSize = 11.sp,
                  color = GriTealSecondary,
                  fontWeight = FontWeight.Medium
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                  Text(
                    text = "Apply Online",
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Bold,
                    color = GriForestPrimary
                  )
                  Icon(
                    imageVector = Icons.Default.OpenInNew,
                    contentDescription = null,
                    tint = GriForestPrimary,
                    modifier = Modifier.size(13.dp)
                  )
                }
              }
            }
          }
        }
      }
    }

    // 7. CAMPUS LIFE & HIGHLIGHTS (SUMMIT EVENT CARD)
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_campus_highlights"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Icon(
                imageVector = Icons.Default.Groups,
                contentDescription = null,
                tint = GriTealSecondary,
                modifier = Modifier.size(18.dp)
              )
              Spacer(modifier = Modifier.width(6.dp))
              Text(
                text = "Campus Life & Highlights",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface
              )
            }
            Text(
              text = "Upcoming",
              fontSize = 11.sp,
              color = GriOutline
            )
          }

          Spacer(modifier = Modifier.height(10.dp))

          Surface(
            shape = RoundedCornerShape(10.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier.fillMaxWidth()
          ) {
            Column {
              // Graphic banner representation
              Box(
                modifier = Modifier
                  .fillMaxWidth()
                  .height(110.dp)
                  .background(GriForestContainer)
                  .padding(12.dp),
                contentAlignment = Alignment.BottomStart
              ) {
                Surface(
                  shape = RoundedCornerShape(999.dp),
                  color = Color.White.copy(alpha = 0.9f)
                ) {
                  Text(
                    text = "Technology Summit",
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    color = GriForestPrimary,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                  )
                }
              }

              Column(modifier = Modifier.padding(12.dp)) {
                Text(
                  text = "Inter-Collegiate Rural Technology Summit 2025",
                  fontSize = 14.sp,
                  fontWeight = FontWeight.Bold,
                  color = GriOnSurface
                )
                Text(
                  text = "Showcasing grassroots innovation, agro-drone technologies, and sustainable organic farming models at the Multi-Purpose Auditorium.",
                  fontSize = 12.sp,
                  color = GriOnSurfaceVariant,
                  modifier = Modifier.padding(top = 4.dp, bottom = 10.dp)
                )

                Surface(
                  shape = RoundedCornerShape(8.dp),
                  color = GriSurfaceContainer,
                  modifier = Modifier.fillMaxWidth()
                ) {
                  Row(
                    modifier = Modifier
                      .fillMaxWidth()
                      .padding(horizontal = 10.dp, vertical = 8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                  ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                      Icon(
                        imageVector = Icons.Default.CalendarToday,
                        contentDescription = null,
                        tint = GriOnSurfaceVariant,
                        modifier = Modifier.size(14.dp)
                      )
                      Spacer(modifier = Modifier.width(4.dp))
                      Text(
                        text = "18-20 April 2025",
                        fontSize = 11.sp,
                        color = GriOnSurfaceVariant
                      )
                    }

                    Text(
                      text = "Register • Free Entry",
                      fontSize = 12.sp,
                      fontWeight = FontWeight.Bold,
                      color = GriForestPrimary,
                      modifier = Modifier.clickable {
                        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
                        try { context.startActivity(intent) } catch (_: Exception) {}
                      }
                    )
                  }
                }
              }
            }
          }
        }
      }
    }

    // 8. 24x7 GRI CAMPUS PROCTOR & HEALTH HELPLINE STRIP
    item {
      Surface(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("strip_campus_helpline"),
        shape = RoundedCornerShape(12.dp),
        color = GriSurfaceContainerHigh
      ) {
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(12.dp),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.weight(1f)
          ) {
            Box(
              modifier = Modifier
                .size(34.dp)
                .clip(CircleShape)
                .background(Color(0xFFFFDAD6)),
              contentAlignment = Alignment.Center
            ) {
              Icon(
                imageVector = Icons.Default.HealthAndSafety,
                contentDescription = null,
                tint = Color(0xFFBA1A1A),
                modifier = Modifier.size(18.dp)
              )
            }
            Spacer(modifier = Modifier.width(10.dp))
            Column {
              Text(
                text = "24x7 Campus Helpline",
                fontSize = 13.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface
              )
              Text(
                text = "Health Centre • Proctorial Board",
                fontSize = 11.sp,
                color = GriOnSurfaceVariant
              )
            }
          }

          Button(
            onClick = {
              val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:04512452371"))
              try { context.startActivity(intent) } catch (_: Exception) {}
            },
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.buttonColors(
              containerColor = GriForestPrimary,
              contentColor = Color.White
            ),
            contentPadding = PaddingValues(horizontal = 14.dp, vertical = 6.dp),
            modifier = Modifier.testTag("btn_dial_helpline")
          ) {
            Icon(Icons.Default.Call, contentDescription = null, modifier = Modifier.size(14.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text("Dial", fontSize = 12.sp, fontWeight = FontWeight.Bold)
          }
        }
      }
    }
  }

  // Role Switcher Dialog
  if (showRoleDialog) {
    androidx.compose.material3.AlertDialog(
      onDismissRequest = { showRoleDialog = false },
      title = {
        Text("Switch Role View", fontWeight = FontWeight.Bold, color = GriForestPrimary)
      },
      text = {
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
          UserRole.values().forEach { role ->
            val isCurrent = role == uiState.currentRole
            Surface(
              shape = RoundedCornerShape(8.dp),
              color = if (isCurrent) GriForestPrimary.copy(alpha = 0.12f) else GriSurfaceContainerLow,
              border = if (isCurrent) androidx.compose.foundation.BorderStroke(1.5.dp, GriForestPrimary) else null,
              modifier = Modifier
                .fillMaxWidth()
                .clickable {
                  onRoleSelected(role)
                  showRoleDialog = false
                }
            ) {
              Row(
                modifier = Modifier.padding(12.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
              ) {
                Text(
                  text = when (role) {
                    UserRole.STUDENT -> "Student View"
                    UserRole.FACULTY -> "Faculty / Staff Portal"
                    UserRole.ADMIN -> "Administrator"
                    UserRole.SCHOLAR -> "Research Scholar"
                    UserRole.ALUMNI -> "Alumni Network"
                    UserRole.GUEST -> "Guest / Visitor"
                    else -> role.name
                  },
                  fontWeight = if (isCurrent) FontWeight.Bold else FontWeight.Medium,
                  color = if (isCurrent) GriForestPrimary else GriOnSurface
                )
                if (isCurrent) {
                  Icon(
                    imageVector = Icons.Default.CheckCircle,
                    contentDescription = null,
                    tint = GriForestPrimary,
                    modifier = Modifier.size(18.dp)
                  )
                }
              }
            }
          }
        }
      },
      confirmButton = {
        androidx.compose.material3.TextButton(onClick = { showRoleDialog = false }) {
          Text("Close", color = GriForestPrimary, fontWeight = FontWeight.Bold)
        }
      }
    )
  }
}

@Composable
fun StudentDeskIconItem(
  title: String,
  icon: ImageVector,
  onClick: () -> Unit,
  modifier: Modifier = Modifier,
  badgeText: String? = null,
  badgeColor: Color = GriOchreContainer,
  isSpecial: Boolean = false
) {
  Column(
    modifier = modifier
      .clickable(onClick = onClick)
      .padding(horizontal = 2.dp),
    horizontalAlignment = Alignment.CenterHorizontally
  ) {
    Box(
      modifier = Modifier
        .size(48.dp)
        .clip(RoundedCornerShape(12.dp))
        .background(if (isSpecial) GriTealContainer else GriSurfaceContainerLow),
      contentAlignment = Alignment.Center
    ) {
      Icon(
        imageVector = icon,
        contentDescription = title,
        tint = if (isSpecial) GriTealOnContainer else GriForestPrimary,
        modifier = Modifier.size(22.dp)
      )

      if (badgeText != null) {
        Surface(
          shape = RoundedCornerShape(999.dp),
          color = badgeColor,
          modifier = Modifier
            .align(Alignment.TopEnd)
            .padding(top = 2.dp, end = 2.dp)
        ) {
          Text(
            text = badgeText,
            fontSize = 7.sp,
            fontWeight = FontWeight.Bold,
            color = Color.White,
            modifier = Modifier.padding(horizontal = 4.dp, vertical = 1.dp)
          )
        }
      }
    }

    Spacer(modifier = Modifier.height(4.dp))

    Text(
      text = title,
      fontSize = 11.sp,
      fontWeight = FontWeight.SemiBold,
      color = if (isSpecial) GriTealSecondary else GriOnSurface,
      maxLines = 1,
      overflow = TextOverflow.Ellipsis
    )
  }
}
