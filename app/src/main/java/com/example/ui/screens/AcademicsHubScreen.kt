package com.example.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.material.icons.filled.Book
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.CloudDownload
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.ExpandLess
import androidx.compose.material.icons.filled.ExpandMore
import androidx.compose.material.icons.filled.Grade
import androidx.compose.material.icons.filled.HistoryEdu
import androidx.compose.material.icons.filled.LocalLibrary
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.QrCode
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.TabRowDefaults
import androidx.compose.material3.TabRowDefaults.tabIndicatorOffset
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
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
 * Stitch Screen 2: Academics & Examination Hub
 * gandhigram_rural_institute/academics_examination_hub.html
 */
@Composable
fun AcademicsHubScreen(
  uiState: GriUiState,
  onFetchHallTicket: () -> Unit,
  onMarkAttendance: (String) -> Unit = {},
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  var selectedTab by remember { mutableIntStateOf(uiState.activeAcademicTab) }
  val tabs = listOf("Courses (4)", "Examinations", "Grade Cards", "Calendar")

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("academics_screen"),
    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
    verticalArrangement = Arrangement.spacedBy(14.dp)
  ) {

    // 1. TOP HEADER & CURRENT TERM
    item {
      Column {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Column {
            Text(
              text = "Academic Portal • COE Wing",
              fontSize = 11.sp,
              fontWeight = FontWeight.SemiBold,
              color = GriOutline
            )
            Text(
              text = "Academics & Examinations",
              fontSize = 20.sp,
              fontWeight = FontWeight.Bold,
              color = GriForestPrimary
            )
          }

          Surface(
            shape = RoundedCornerShape(999.dp),
            color = GriForestContainer
          ) {
            Row(
              modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
              verticalAlignment = Alignment.CenterVertically
            ) {
              Icon(Icons.Default.Verified, contentDescription = null, tint = Color.White, modifier = Modifier.size(12.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text("Verified", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = Color.White)
            }
          }
        }

        Spacer(modifier = Modifier.height(4.dp))
        Text(
          text = "Even Semester 2024-25 (Current) • B.Sc. (Hons) Agriculture",
          fontSize = 12.sp,
          color = GriOnSurfaceVariant
        )
      }
    }

    // 2. BENTO STATS CARDS (CGPA, ATTENDANCE, CREDITS)
    item {
      Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        // CGPA Card (Institutional Forest Green Primary)
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .testTag("card_cgpa_stat"),
          shape = RoundedCornerShape(14.dp),
          colors = CardDefaults.cardColors(containerColor = GriForestPrimary)
        ) {
          Row(
            modifier = Modifier
              .fillMaxWidth()
              .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Column {
              Text(
                text = "Cumulative GPA • Semester VI",
                fontSize = 12.sp,
                fontWeight = FontWeight.Medium,
                color = Color.White.copy(alpha = 0.8f)
              )
              Spacer(modifier = Modifier.height(2.dp))
              Row(verticalAlignment = Alignment.Bottom) {
                Text(
                  text = "8.74",
                  fontSize = 28.sp,
                  fontWeight = FontWeight.Bold,
                  color = Color.White
                )
                Text(
                  text = " / 10.0",
                  fontSize = 14.sp,
                  color = Color.White.copy(alpha = 0.7f),
                  modifier = Modifier.padding(bottom = 3.dp)
                )
              }
              Text(
                text = "First Class with Distinction • Rank #4 in Dept",
                fontSize = 11.sp,
                color = GriForestFixed,
                modifier = Modifier.padding(top = 2.dp)
              )
            }

            Box(
              modifier = Modifier
                .size(46.dp)
                .clip(CircleShape)
                .background(Color.White.copy(alpha = 0.15f)),
              contentAlignment = Alignment.Center
            ) {
              Icon(
                imageVector = Icons.Default.Grade,
                contentDescription = null,
                tint = Color.White,
                modifier = Modifier.size(24.dp)
              )
            }
          }
        }

        // Two Column Cards: Attendance + Credits
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
          // Attendance Card
          Card(
            modifier = Modifier
              .weight(1f)
              .testTag("card_attendance_stat"),
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
            elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
              ) {
                Text("Attendance", fontSize = 11.sp, color = GriOutline, fontWeight = FontWeight.Bold)
                Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(14.dp))
              }
              Spacer(modifier = Modifier.height(6.dp))
              Text("88.5%", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
              Text("Safe Zone (>75%)", fontSize = 10.sp, color = GriOnSurfaceVariant)
            }
          }

          // Workload Credits Card
          Card(
            modifier = Modifier
              .weight(1f)
              .testTag("card_credits_stat"),
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
            elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
              ) {
                Text("Workload", fontSize = 11.sp, color = GriOutline, fontWeight = FontWeight.Bold)
                Icon(Icons.Default.Book, contentDescription = null, tint = GriTealSecondary, modifier = Modifier.size(14.dp))
              }
              Spacer(modifier = Modifier.height(6.dp))
              Text("24 Credits", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = GriTealSecondary)
              Text("All Approved", fontSize = 10.sp, color = GriOnSurfaceVariant)
            }
          }
        }
      }
    }

    // 3. SEGMENTED TABS
    item {
      Surface(
        shape = RoundedCornerShape(10.dp),
        color = GriSurfaceContainerLowest,
        shadowElevation = 0.5.dp
      ) {
        TabRow(
          selectedTabIndex = selectedTab,
          containerColor = Color.Transparent,
          contentColor = GriForestPrimary,
          indicator = { tabPositions ->
            TabRowDefaults.PrimaryIndicator(
              modifier = Modifier.tabIndicatorOffset(tabPositions[selectedTab]),
              color = GriForestPrimary,
              height = 3.dp
            )
          },
          divider = {}
        ) {
          tabs.forEachIndexed { index, title ->
            Tab(
              selected = selectedTab == index,
              onClick = { selectedTab = index },
              text = {
                Text(
                  text = title,
                  fontSize = 11.sp,
                  fontWeight = if (selectedTab == index) FontWeight.Bold else FontWeight.Medium,
                  color = if (selectedTab == index) GriForestPrimary else GriOutline
                )
              }
            )
          }
        }
      }
    }

    // 4. TAB CONTENT
    when (selectedTab) {
      0 -> {
        // COURSES TAB
        item {
          Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            AcademicCourseCard(
              code = "AG-302",
              title = "Rural Extension & Sustainable Development",
              credits = 4,
              instructor = "Dr. R. Sundaram",
              internalScore = "27 / 30",
              attendance = "91%",
              progress = 0.78f,
              unitTopic = "Unit IV - Micro-credit & SHGs (Completed 78%)"
            )

            AcademicCourseCard(
              code = "AG-304",
              title = "Soil Fertility & Organic Agriculture Management",
              credits = 4,
              instructor = "Prof. M. Kalyani",
              internalScore = "26 / 30",
              attendance = "86%",
              progress = 0.85f,
              unitTopic = "Unit V - Bio-fertilizers & Vermicompost Practicals"
            )

            AcademicCourseCard(
              code = "CS-201",
              title = "Digital Agriculture & Sensor Tech",
              credits = 3,
              instructor = "Dr. K. Venkat",
              internalScore = "29 / 30",
              attendance = "93%",
              progress = 0.90f,
              unitTopic = "Unit III - IoT Soil Sensors & Drone Mapping"
            )

            AcademicCourseCard(
              code = "GS-102",
              title = "Gandhian Thought & Rural Community Organization",
              credits = 3,
              instructor = "Dr. S. Radhakrishnan",
              internalScore = "28 / 30",
              attendance = "89%",
              progress = 0.82f,
              unitTopic = "Village Immersion Camp: Chinnalapatti Shanti Sena"
            )
          }
        }
      }

      1 -> {
        // EXAMINATIONS TAB
        item {
          Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            // Official Hall Ticket Admit Card Card
            Card(
              modifier = Modifier
                .fillMaxWidth()
                .testTag("card_admit_card"),
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
                  Column {
                    Surface(
                      shape = RoundedCornerShape(4.dp),
                      color = GriOchreContainer
                    ) {
                      Text(
                        text = "OFFICIAL ADMIT CARD",
                        fontSize = 9.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White,
                        letterSpacing = 0.5.sp,
                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                      )
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                      text = "End Semester Examinations 2025",
                      fontSize = 15.sp,
                      fontWeight = FontWeight.Bold,
                      color = GriOnSurface
                    )
                    Text(
                      text = "Roll No: 22AG1087 • B.Sc. (Hons) Agriculture",
                      fontSize = 12.sp,
                      color = GriOnSurfaceVariant
                    )
                  }

                  Box(
                    modifier = Modifier
                      .size(40.dp)
                      .clip(RoundedCornerShape(8.dp))
                      .background(GriSurfaceContainerLow),
                    contentAlignment = Alignment.Center
                  ) {
                    Icon(
                      imageVector = Icons.Default.QrCode,
                      contentDescription = null,
                      tint = GriForestPrimary,
                      modifier = Modifier.size(24.dp)
                    )
                  }
                }

                Spacer(modifier = Modifier.height(12.dp))

                Surface(
                  shape = RoundedCornerShape(8.dp),
                  color = GriSurfaceContainerLow,
                  modifier = Modifier.fillMaxWidth()
                ) {
                  Column(modifier = Modifier.padding(10.dp)) {
                    Text("Examination Center", fontSize = 10.sp, color = GriOutline, fontWeight = FontWeight.Bold)
                    Text("Dr. J.C. Kumarappa Academic Block • Hall 4", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = GriOnSurface)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("Verification Status: Dues Cleared & Biometric Registered", fontSize = 11.sp, color = GriForestPrimary, fontWeight = FontWeight.Medium)
                  }
                }

                Spacer(modifier = Modifier.height(10.dp))

                // Barcode graphic representation
                Box(
                  modifier = Modifier
                    .fillMaxWidth()
                    .height(38.dp)
                    .background(Color.White)
                    .border(1.dp, GriOutlineVariant, RoundedCornerShape(6.dp))
                    .padding(horizontal = 8.dp),
                  contentAlignment = Alignment.Center
                ) {
                  Text(
                    text = "||| | |||| || | |||| ||| || |||| | |||||| |||",
                    fontFamily = FontFamily.Monospace,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.Black,
                    letterSpacing = 2.sp
                  )
                }

                Text(
                  text = "GRI-COE-2025-22AG1087-APR • Cryptographically Sealed",
                  fontSize = 9.sp,
                  color = GriOutline,
                  textAlign = TextAlign.Center,
                  modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 4.dp, bottom = 12.dp)
                )

                Button(
                  onClick = onFetchHallTicket,
                  shape = RoundedCornerShape(8.dp),
                  colors = ButtonDefaults.buttonColors(
                    containerColor = GriForestPrimary,
                    contentColor = Color.White
                  ),
                  modifier = Modifier
                    .fillMaxWidth()
                    .testTag("btn_view_print_hall_ticket")
                ) {
                  Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(16.dp))
                  Spacer(modifier = Modifier.width(6.dp))
                  Text("View & Print QR Hall Ticket", fontSize = 13.sp, fontWeight = FontWeight.Bold)
                }
              }
            }

            // CIA Marks Breakdown Table
            Card(
              modifier = Modifier.fillMaxWidth(),
              shape = RoundedCornerShape(14.dp),
              colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
              elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
            ) {
              Column(modifier = Modifier.padding(14.dp)) {
                Text(
                  text = "Continuous Internal Assessment (CIA) Aggregate",
                  fontSize = 14.sp,
                  fontWeight = FontWeight.Bold,
                  color = GriOnSurface
                )
                Spacer(modifier = Modifier.height(8.dp))

                CiaRow(course = "AG-302", name = "Rural Extension", cia1 = "14/15", cia2 = "13/15", aggregate = "27/30")
                CiaRow(course = "AG-304", name = "Soil Fertility", cia1 = "13/15", cia2 = "13/15", aggregate = "26/30")
                CiaRow(course = "CS-201", name = "Digital Agriculture", cia1 = "15/15", cia2 = "14/15", aggregate = "29/30")
                CiaRow(course = "GS-102", name = "Gandhian Thought", cia1 = "14/15", cia2 = "14/15", aggregate = "28/30")
              }
            }
          }
        }
      }

      2 -> {
        // GRADE CARDS TAB
        item {
          Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Surface(
              shape = RoundedCornerShape(8.dp),
              color = GriForestFixed,
              modifier = Modifier.fillMaxWidth()
            ) {
              Row(
                modifier = Modifier.padding(10.dp),
                verticalAlignment = Alignment.CenterVertically
              ) {
                Icon(Icons.Default.Verified, contentDescription = null, tint = GriForestOnFixed, modifier = Modifier.size(16.dp))
                Spacer(modifier = Modifier.width(6.dp))
                Text(
                  text = "DigiLocker & NAD Verified Academic Depository",
                  fontSize = 11.sp,
                  fontWeight = FontWeight.Bold,
                  color = GriForestOnFixed
                )
              }
            }

            GradeSheetCard(
              sem = "Semester V (Nov 2024)",
              gpa = "8.82",
              credits = "24",
              refNo = "GRI/COE/2024/UG-4921",
              onDownload = {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
                try { context.startActivity(intent) } catch (_: Exception) {}
              }
            )

            GradeSheetCard(
              sem = "Semester IV (May 2024)",
              gpa = "8.65",
              credits = "23",
              refNo = "GRI/COE/2024/UG-3810",
              onDownload = {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
                try { context.startActivity(intent) } catch (_: Exception) {}
              }
            )
          }
        }
      }

      3 -> {
        // CALENDAR TAB
        item {
          Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(14.dp),
            colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
            elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
          ) {
            Column(modifier = Modifier.padding(16.dp)) {
              Text(
                text = "Key Academic Milestones • Even Sem 2024-25",
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface
              )
              Spacer(modifier = Modifier.height(10.dp))

              CalendarEventItem(date = "15 Jan 2025", title = "Semester Commencement", status = "Completed")
              CalendarEventItem(date = "24-28 Feb 2025", title = "CIA-I Mid-Term Examinations", status = "Completed")
              CalendarEventItem(date = "24-28 Mar 2025", title = "CIA-II Internal Assessment", status = "Completed")
              CalendarEventItem(date = "12 Apr 2025", title = "Last Working Day", status = "Upcoming")
              CalendarEventItem(date = "18-25 Apr 2025", title = "End Semester Practicals", status = "Upcoming")
              CalendarEventItem(date = "28 Apr - 15 May 2025", title = "End Semester Theory Examinations", status = "Scheduled")
            }
          }
        }
      }
    }

    // 5. FACULTY ADVISOR CONTACT FOOTER
    item {
      Surface(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        color = GriSurfaceContainerLow
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
                .size(36.dp)
                .clip(CircleShape)
                .background(GriForestPrimary),
              contentAlignment = Alignment.Center
            ) {
              Icon(Icons.Default.School, contentDescription = null, tint = Color.White, modifier = Modifier.size(20.dp))
            }
            Spacer(modifier = Modifier.width(10.dp))
            Column {
              Text("Faculty Advisor: Dr. R. Sundaram", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
              Text("Dean, Dept of Agriculture • Room #104", fontSize = 10.sp, color = GriOnSurfaceVariant)
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
            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
          ) {
            Icon(Icons.Default.Call, contentDescription = null, modifier = Modifier.size(13.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text("Call", fontSize = 11.sp, fontWeight = FontWeight.Bold)
          }
        }
      }
    }
  }
}

@Composable
fun AcademicCourseCard(
  code: String,
  title: String,
  credits: Int,
  instructor: String,
  internalScore: String,
  attendance: String,
  progress: Float,
  unitTopic: String
) {
  var expanded by remember { mutableStateOf(false) }

  Card(
    modifier = Modifier
      .fillMaxWidth()
      .clickable { expanded = !expanded },
    shape = RoundedCornerShape(12.dp),
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
          Surface(
            shape = RoundedCornerShape(4.dp),
            color = GriForestContainer
          ) {
            Text(
              text = code,
              fontSize = 10.sp,
              fontWeight = FontWeight.Bold,
              color = Color.White,
              modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
            )
          }
          Spacer(modifier = Modifier.width(6.dp))
          Text(text = "$credits Credits", fontSize = 11.sp, color = GriOutline, fontWeight = FontWeight.Medium)
        }

        Row(verticalAlignment = Alignment.CenterVertically) {
          Text(text = "Att: $attendance", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
          Spacer(modifier = Modifier.width(4.dp))
          Icon(
            imageVector = if (expanded) Icons.Default.ExpandLess else Icons.Default.ExpandMore,
            contentDescription = null,
            tint = GriOnSurfaceVariant,
            modifier = Modifier.size(18.dp)
          )
        }
      }

      Spacer(modifier = Modifier.height(6.dp))
      Text(text = title, fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
      Text(text = "Instructor: $instructor", fontSize = 11.sp, color = GriOnSurfaceVariant, modifier = Modifier.padding(top = 2.dp))

      Spacer(modifier = Modifier.height(8.dp))

      // Progress bar
      LinearProgressIndicator(
        progress = { progress },
        modifier = Modifier
          .fillMaxWidth()
          .height(5.dp)
          .clip(RoundedCornerShape(999.dp)),
        color = GriForestPrimary,
        trackColor = GriSurfaceContainerLow
      )

      AnimatedVisibility(visible = expanded) {
        Column(modifier = Modifier.padding(top = 10.dp)) {
          Surface(
            shape = RoundedCornerShape(6.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier.fillMaxWidth()
          ) {
            Column(modifier = Modifier.padding(8.dp)) {
              Text(text = "Active Unit", fontSize = 10.sp, color = GriOutline, fontWeight = FontWeight.Bold)
              Text(text = unitTopic, fontSize = 11.sp, color = GriOnSurface)
              Spacer(modifier = Modifier.height(4.dp))
              Text(text = "Internal CIA Score: $internalScore", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriTealSecondary)
            }
          }
        }
      }
    }
  }
}

@Composable
fun CiaRow(course: String, name: String, cia1: String, cia2: String, aggregate: String) {
  Row(
    modifier = Modifier
      .fillMaxWidth()
      .padding(vertical = 4.dp),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
  ) {
    Column(modifier = Modifier.weight(1.5f)) {
      Text(course, fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
      Text(name, fontSize = 10.sp, color = GriOnSurfaceVariant, maxLines = 1)
    }
    Text(cia1, fontSize = 11.sp, color = GriOnSurface, modifier = Modifier.weight(0.8f), textAlign = TextAlign.Center)
    Text(cia2, fontSize = 11.sp, color = GriOnSurface, modifier = Modifier.weight(0.8f), textAlign = TextAlign.Center)
    Text(aggregate, fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary, modifier = Modifier.weight(0.9f), textAlign = TextAlign.End)
  }
}

@Composable
fun GradeSheetCard(sem: String, gpa: String, credits: String, refNo: String, onDownload: () -> Unit) {
  Surface(
    shape = RoundedCornerShape(10.dp),
    color = GriSurfaceContainerLowest,
    shadowElevation = 0.5.dp,
    modifier = Modifier.fillMaxWidth()
  ) {
    Row(
      modifier = Modifier
        .fillMaxWidth()
        .padding(12.dp),
      horizontalArrangement = Arrangement.SpaceBetween,
      verticalAlignment = Alignment.CenterVertically
    ) {
      Column(modifier = Modifier.weight(1f)) {
        Text(sem, fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
        Text("GPA: $gpa • $credits Credits Approved", fontSize = 11.sp, color = GriForestPrimary, fontWeight = FontWeight.SemiBold)
        Text(refNo, fontSize = 9.sp, color = GriOutline)
      }

      Button(
        onClick = onDownload,
        shape = RoundedCornerShape(6.dp),
        colors = ButtonDefaults.buttonColors(containerColor = GriSurfaceContainerHigh, contentColor = GriForestPrimary),
        contentPadding = PaddingValues(horizontal = 10.dp, vertical = 6.dp)
      ) {
        Icon(Icons.Default.CloudDownload, contentDescription = null, modifier = Modifier.size(14.dp))
        Spacer(modifier = Modifier.width(4.dp))
        Text("Download", fontSize = 11.sp, fontWeight = FontWeight.Bold)
      }
    }
  }
}

@Composable
fun CalendarEventItem(date: String, title: String, status: String) {
  Row(
    modifier = Modifier
      .fillMaxWidth()
      .padding(vertical = 6.dp),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
  ) {
    Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.weight(1f)) {
      Box(
        modifier = Modifier
          .size(6.dp)
          .clip(CircleShape)
          .background(if (status == "Completed") GriForestPrimary else GriOchreContainer)
      )
      Spacer(modifier = Modifier.width(8.dp))
      Column {
        Text(title, fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = GriOnSurface)
        Text(date, fontSize = 10.sp, color = GriOutline)
      }
    }

    Surface(
      shape = RoundedCornerShape(999.dp),
      color = if (status == "Completed") GriForestFixed else GriSurfaceContainerLow
    ) {
      Text(
        text = status,
        fontSize = 9.sp,
        fontWeight = FontWeight.Bold,
        color = if (status == "Completed") GriForestOnFixed else GriOnSurfaceVariant,
        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
      )
    }
  }
}
