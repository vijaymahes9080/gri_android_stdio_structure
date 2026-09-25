package com.example.ui.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
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
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Assignment
import androidx.compose.material.icons.automirrored.filled.LibraryBooks
import androidx.compose.material.icons.automirrored.filled.OpenInNew
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Apartment
import androidx.compose.material.icons.filled.Assignment
import androidx.compose.material.icons.filled.BookmarkBorder
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.ConfirmationNumber
import androidx.compose.material.icons.filled.DirectionsBus
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.EventNote
import androidx.compose.material.icons.filled.FolderShared
import androidx.compose.material.icons.filled.HelpOutline
import androidx.compose.material.icons.filled.Hotel
import androidx.compose.material.icons.filled.HourglassTop
import androidx.compose.material.icons.filled.Launch
import androidx.compose.material.icons.filled.LibraryBooks
import androidx.compose.material.icons.filled.LocalHospital
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.NotificationsActive
import androidx.compose.material.icons.filled.OpenInNew
import androidx.compose.material.icons.filled.PowerSettingsNew
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.ReportProblem
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.Science
import androidx.compose.material.icons.filled.SportsScore
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material.icons.filled.Sync
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material.icons.filled.Badge
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.WorkHistory
import androidx.compose.material.icons.filled.HistoryEdu
import androidx.compose.material.icons.filled.Engineering
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Send
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.Payment
import androidx.compose.material.icons.filled.FactCheck
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Build
import com.example.data.local.StaffLeaveRecord
import com.example.data.local.PublishingAuditEntry
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.R
import com.example.data.local.CircularEntity
import com.example.data.local.CourseEntity
import com.example.data.local.GrievanceEntity
import com.example.data.local.TransportRouteEntity
import com.example.data.local.UserRole
import com.example.ui.GriUiState
import com.example.ui.components.DigitalIdCard
import com.example.ui.components.GriNoticeAlert
import com.example.ui.components.GriSearchBar
import com.example.ui.components.GriSectionHeader
import com.example.ui.components.QuickServiceButton
import com.example.ui.components.StatCard
import com.example.ui.theme.GriColors
import com.example.ui.theme.GriGoldDark
import com.example.ui.theme.GriGoldSecondary
import com.example.ui.theme.GriGoldContainer
import com.example.ui.theme.GriGoldOnContainer
import com.example.ui.theme.GriAccentCyan
import com.example.ui.theme.GriGreenSuccess
import com.example.ui.theme.GriNavyPrimary
import com.example.ui.theme.GriRadius
import com.example.ui.theme.GriRedAlert
import com.example.ui.theme.GriSpacing

// =========================================================================
// HOME SCREEN — OFFICIAL GRI HIERARCHY
// =========================================================================

/**
 * HOME SCREEN
 *
 * Content Hierarchy:
 * HEADER (TopBar) -> GRI BRANDING -> SEARCH -> IMPORTANT NOTICE / ALERT
 * -> QUICK SERVICES -> ACADEMICS -> ADMISSIONS -> EXAMINATION
 * -> LATEST NEWS -> EVENTS -> CAMPUS/FACILITIES -> STUDENT SERVICES
 * -> IMPORTANT LINKS -> CONTACT -> FOOTER
 */
@Composable
fun HomeScreen(
  uiState: GriUiState,
  onFetchHallTicket: () -> Unit,
  onNavigateToGrievances: () -> Unit,
  onNavigateToServices: () -> Unit,
  onNavigateToAcademics: () -> Unit,
  onMarkCircularRead: (String) -> Unit,
  modifier: Modifier = Modifier
) {
  var searchQuery by remember { mutableStateOf("") }
  var selectedDocForPreview by remember { mutableStateOf<com.example.ui.components.GriDocument?>(null) }
  val context = androidx.compose.ui.platform.LocalContext.current

  val prospectusDoc = remember {
    com.example.ui.components.GriDocument(
      id = "doc_prospectus_2026",
      title = "GRI Admission Prospectus 2026–2027",
      category = "Admissions",
      date = "15 Aug 2026",
      fileType = "PDF",
      fileSize = "4.2 MB",
      description = "Official guidelines for CUET-UG, CUET-PG, Non-CUET, ITEP 4-Year B.Ed, Diploma in Agriculture and Ph.D. research programmes with detailed fee structures and reservation quotas."
    )
  }

  selectedDocForPreview?.let { doc ->
    com.example.ui.components.GriDocumentDialog(
      document = doc,
      onDismiss = { selectedDocForPreview = null },
      onDownload = {
        val intent = android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse("https://www.ruraluniv.ac.in/admissions/"))
        try {
          context.startActivity(intent)
        } catch (_: Exception) {}
        selectedDocForPreview = null
      }
    )
  }

  val filteredCirculars = remember(searchQuery, uiState.circulars) {
    if (searchQuery.isBlank()) uiState.circulars
    else uiState.circulars.filter {
      it.title.contains(searchQuery, ignoreCase = true) ||
      it.category.contains(searchQuery, ignoreCase = true) ||
      it.summary.contains(searchQuery, ignoreCase = true)
    }
  }

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("home_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {

    // 1. INTELLIGENT GRI BRANDING & HERITAGE BANNER
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
        shape = RoundedCornerShape(GriRadius.lg),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.5.dp),
        border = CardDefaults.outlinedCardBorder()
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Surface(
              shape = RoundedCornerShape(8.dp),
              color = Color.White,
              shadowElevation = 2.dp,
              border = androidx.compose.foundation.BorderStroke(1.5.dp, Color(0xFFE51A1A).copy(alpha = 0.5f))
            ) {
              Image(
                painter = painterResource(id = R.drawable.ic_gri_seal),
                contentDescription = "Official GRI Seal",
                modifier = Modifier
                  .size(width = 54.dp, height = 64.dp)
                  .padding(3.dp)
              )
            }

            Spacer(modifier = Modifier.width(14.dp))

            Column(modifier = Modifier.weight(1f)) {
              Text(
                text = "The Gandhigram Rural Institute",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
              )
              Text(
                text = "(Deemed to be University) • Govt. of India",
                style = MaterialTheme.typography.bodySmall,
                color = GriGoldDark,
                fontWeight = FontWeight.SemiBold
              )
              Spacer(modifier = Modifier.height(2.dp))
              Text(
                text = "Gandhigram, Dindigul - 624 302, Tamil Nadu, India",
                style = MaterialTheme.typography.bodySmall,
                fontSize = 11.sp,
                color = MaterialTheme.colorScheme.onSurfaceVariant
              )
            }
          }

          Spacer(modifier = Modifier.height(10.dp))
          HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))
          Spacer(modifier = Modifier.height(8.dp))

          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
              Surface(
                color = GriGreenSuccess.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(
                  text = "NAAC A+ (3.34)",
                  style = MaterialTheme.typography.labelSmall,
                  color = GriGreenSuccess,
                  fontWeight = FontWeight.Bold,
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                )
              }
              Surface(
                color = GriNavyPrimary.copy(alpha = 0.08f),
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(
                  text = "Nai Talim (Est. 1956)",
                  style = MaterialTheme.typography.labelSmall,
                  color = GriNavyPrimary,
                  fontWeight = FontWeight.Medium,
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                )
              }
            }

            Text(
              text = "கிராமம் உயர நாடு உயரும்",
              style = MaterialTheme.typography.labelSmall,
              color = GriGoldDark,
              fontWeight = FontWeight.Bold,
              fontSize = 10.sp
            )
          }
        }
      }
    }

    // 2. INTELLIGENT SEARCH & DISCOVERY
    item {
      GriSearchBar(
        query = searchQuery,
        onQueryChange = { searchQuery = it },
        placeholder = "Search circulars, exams, faculty, services..."
      )
    }

    // 3. PRIORITY HUB — DYNAMIC INSTITUTIONAL ACTIONS
    item {
      com.example.ui.components.GriPriorityHubCard(
        tag = "EXAMINATION PRIORITY",
        title = "ESE Semester Examination & Hall Ticket",
        subtitle = "Continuous Internal Assessment (CIA) marks verified. Download official digitally signed e-SANAD hall ticket for examination hall entry.",
        actionText = "Get Hall Ticket",
        onActionClick = onFetchHallTicket,
        secondaryActionText = "Admissions 2026",
        onSecondaryActionClick = { selectedDocForPreview = prospectusDoc }
      )
    }

    // 4. QUICK SERVICES GRID (HIGH VISUAL HIERARCHY)
    item {
      GriSectionHeader(
        title = "Essential Services",
        subtitle = "Fast access to central university modules"
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp)
      ) {
        com.example.ui.components.GriQuickActionPill(
          title = "Hall Ticket",
          icon = Icons.Default.ConfirmationNumber,
          iconTint = GriGoldSecondary,
          onClick = onFetchHallTicket,
          modifier = Modifier.weight(1f)
        )
        com.example.ui.components.GriQuickActionPill(
          title = "Attendance",
          icon = Icons.Default.CheckCircle,
          iconTint = GriGreenSuccess,
          onClick = onNavigateToAcademics,
          modifier = Modifier.weight(1f)
        )
        com.example.ui.components.GriQuickActionPill(
          title = "Bus Fleet",
          icon = Icons.Default.DirectionsBus,
          iconTint = MaterialTheme.colorScheme.primary,
          onClick = onNavigateToServices,
          modifier = Modifier.weight(1f)
        )
        com.example.ui.components.GriQuickActionPill(
          title = "GRI-Care",
          icon = Icons.Default.ReportProblem,
          iconTint = GriRedAlert,
          onClick = onNavigateToGrievances,
          modifier = Modifier.weight(1f)
        )
      }
    }

    // 5. ACADEMIC SNAPSHOT & CBCS PERFORMANCE
    item {
      GriSectionHeader(
        title = "Academic Performance",
        subtitle = "CBCS Curriculum & Continuous Internal Assessment",
        actionText = "View All",
        onActionClick = onNavigateToAcademics
      )
    }

    item {
      val avgAttendance = uiState.courses.map { it.attendancePercent }.average().takeIf { !it.isNaN() }?.toInt() ?: 84
      val isEligible = avgAttendance >= 75
      val progress = (avgAttendance / 100f).coerceIn(0f, 1f)

      Row(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp)
      ) {
        com.example.ui.components.GriMetricProgressCard(
          title = "Attendance Rate",
          value = "$avgAttendance%",
          badgeText = if (isEligible) "Eligible (>75%)" else "Shortage (<75%)",
          isPositive = isEligible,
          progress = progress,
          subtitle = if (isEligible) "Permitted for ESE End Semester" else "Condonation Required",
          modifier = Modifier.weight(1f),
          onClick = onNavigateToAcademics
        )
        com.example.ui.components.GriMetricProgressCard(
          title = "Active Courses",
          value = "${uiState.courses.size}",
          badgeText = "CBCS Sem 4",
          isPositive = true,
          progress = 1.0f,
          subtitle = "Total 22 Credits Enrolled",
          modifier = Modifier.weight(1f),
          onClick = onNavigateToAcademics
        )
      }
    }

    // 6. ADMISSIONS
    item {
      GriSectionHeader(
        title = "Admissions 2026–2027",
        subtitle = "CUET, Non-CUET & Professional Programmes"
      )
    }

    item {
      Card(
        modifier = Modifier
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
            Row(verticalAlignment = Alignment.CenterVertically) {
              Icon(Icons.Default.School, contentDescription = null, tint = GriGoldSecondary, modifier = Modifier.size(20.dp))
              Spacer(modifier = Modifier.width(8.dp))
              Text("GRI Central Admissions Cell", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
            }
            Surface(color = GriGoldContainer, shape = RoundedCornerShape(GriRadius.xs)) {
              Text("OPEN", style = MaterialTheme.typography.labelSmall, color = GriGoldOnContainer, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
            }
          }
          Spacer(modifier = Modifier.height(6.dp))
          Text(
            text = "Applications invited for UG (CUET-UG), PG (CUET-PG), ITEP 4-Year B.Ed, Diploma in Agriculture, and Ph.D. research programmes.",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
          )
          Spacer(modifier = Modifier.height(10.dp))
          Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedButton(
              onClick = { selectedDocForPreview = prospectusDoc },
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.weight(1f)
            ) {
              Icon(Icons.AutoMirrored.Filled.LibraryBooks, contentDescription = null, modifier = Modifier.size(16.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text("Prospectus", style = MaterialTheme.typography.labelMedium)
            }
            Button(
              onClick = {
                val intent = android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse("https://www.ruraluniv.ac.in/admissions/"))
                try {
                  context.startActivity(intent)
                } catch (_: Exception) {}
              },
              colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.weight(1f)
            ) {
              Icon(Icons.Default.Launch, contentDescription = null, modifier = Modifier.size(16.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text("Apply Online", style = MaterialTheme.typography.labelMedium)
            }
          }
        }
      }
    }

    // 7. EXAMINATION
    item {
      GriSectionHeader(
        title = "Controller of Examinations (CoE)",
        subtitle = "Timetable, Hall Tickets & e-SANAD Verification",
        actionText = "Hall Ticket",
        onActionClick = onFetchHallTicket
      )
    }

    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        shape = RoundedCornerShape(GriRadius.md),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
        border = CardDefaults.outlinedCardBorder()
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.Verified, contentDescription = null, tint = GriGreenSuccess, modifier = Modifier.size(20.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Text("End Semester Examinations (ESE) Nov-Dec 2026", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
          }
          Spacer(modifier = Modifier.height(4.dp))
          Text(
            text = "• Timetable released for all Schools and Departments.\n• Hall tickets digitally signed and integrated with Ministry of External Affairs e-SANAD repository.",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
          )
          Spacer(modifier = Modifier.height(8.dp))
          Button(
            onClick = onFetchHallTicket,
            colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
            shape = RoundedCornerShape(GriRadius.sm),
            modifier = Modifier.fillMaxWidth()
          ) {
            Icon(Icons.Default.ConfirmationNumber, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(6.dp))
            Text("Download / View Verified Hall Ticket")
          }
        }
      }
    }

    // 8. LATEST NEWS / OFFICIAL CIRCULARS
    item {
      GriSectionHeader(
        title = "Latest News & Circulars",
        subtitle = "Official University Gazette & Administrative Orders"
      )
    }

    if (filteredCirculars.isEmpty()) {
      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Text(
            text = "No circulars matching \"$searchQuery\"",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(16.dp)
          )
        }
      }
    } else {
      items(filteredCirculars.take(4)) { circular ->
        CircularCardItem(
          circular = circular,
          onMarkRead = { onMarkCircularRead(circular.id) }
        )
      }
    }

    // 9. UPCOMING EVENTS
    item {
      GriSectionHeader(
        title = "Campus Events & Extension",
        subtitle = "Gandhian Programs & Academic Convocations"
      )
    }

    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        shape = RoundedCornerShape(GriRadius.md),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
        border = CardDefaults.outlinedCardBorder()
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          EventRowItem(
            date = "OCT 02",
            title = "Gandhi Jayanti & Shanti Sena Peace Assembly",
            location = "Multi-Purpose Open Air Theatre • 08:30 AM"
          )
          HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
          EventRowItem(
            date = "NOV 12",
            title = "39th Annual Convocation Ceremony",
            location = "Dr. Radhakrishnan Auditorium • 10:00 AM"
          )
          HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
          EventRowItem(
            date = "DEC 05",
            title = "Village Placement Programme (VPP) Rural Immersion",
            location = "Dindigul District Rural Blocks"
          )
        }
      }
    }

    // 10. CAMPUS / FACILITIES SHOWCASE
    item {
      GriSectionHeader(
        title = "Campus Facilities & Research",
        subtitle = "Infrastructure Supporting Academic Excellence",
        actionText = "Explore",
        onActionClick = onNavigateToServices
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .horizontalScroll(rememberScrollState())
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
      ) {
        FacilityMiniCard(
          title = "Central Library",
          subtitle = "1.75L+ Volumes, OPAC, e-ShodhSindhu",
          icon = Icons.AutoMirrored.Filled.LibraryBooks,
          iconTint = GriNavyPrimary
        )
        FacilityMiniCard(
          title = "Computer Centre",
          subtitle = "1 Gbps Optical Fiber, Cloud Lab",
          icon = Icons.Default.Dns,
          iconTint = GriGoldSecondary
        )
        FacilityMiniCard(
          title = "Central Instrumentation",
          subtitle = "CIF, XRD, Nanoscience Lab",
          icon = Icons.Default.Science,
          iconTint = GriAccentCyan
        )
        FacilityMiniCard(
          title = "Health Centre",
          subtitle = "24/7 Outpatient & Ambulance",
          icon = Icons.Default.LocalHospital,
          iconTint = GriGreenSuccess
        )
      }
    }

    // 11. STUDENT SERVICES (Digital ID Card)
    item {
      GriSectionHeader(
        title = "Student Identity & Pass",
        subtitle = "Institutional Credential & Residence Status"
      )
    }

    item {
      DigitalIdCard(
        user = uiState.currentUser,
        onVerifyClick = onFetchHallTicket
      )
    }

    // 12. IMPORTANT LINKS
    item {
      GriSectionHeader(
        title = "Important Portals & Links",
        subtitle = "Government of India & Academic Integrations"
      )
    }

    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        shape = RoundedCornerShape(GriRadius.md),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
        border = CardDefaults.outlinedCardBorder()
      ) {
        Column(modifier = Modifier.padding(12.dp)) {
          LinkRowItem("Samarth Student ERP Portal", "samarth.edu.in")
          HorizontalDivider(modifier = Modifier.padding(vertical = 6.dp))
          LinkRowItem("Ministry of External Affairs e-SANAD", "esanad.nic.in")
          HorizontalDivider(modifier = Modifier.padding(vertical = 6.dp))
          LinkRowItem("National Academic Depository (NAD / DigiLocker)", "nad.digilocker.gov.in")
          HorizontalDivider(modifier = Modifier.padding(vertical = 6.dp))
          LinkRowItem("Unnat Bharat Abhiyan (UBA GRI Cell)", "unnatbharatabhiyan.gov.in")
        }
      }
    }

    // 13. CONTACT DIRECTORY
    item {
      GriSectionHeader(
        title = "Campus Contact Directory",
        subtitle = "Administrative Secretariat & Helpdesks"
      )
    }

    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        shape = RoundedCornerShape(GriRadius.md),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
        border = CardDefaults.outlinedCardBorder()
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.LocationOn, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(18.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Text("The Gandhigram Rural Institute (Deemed to be University)\nGandhigram - 624 302, Dindigul District, Tamil Nadu, India", style = MaterialTheme.typography.bodySmall)
          }
          Spacer(modifier = Modifier.height(10.dp))
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.Call, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(18.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Text("EPABX: +91 451 2452371 to 2452375 | CoE: Ext 204", style = MaterialTheme.typography.bodySmall)
          }
          Spacer(modifier = Modifier.height(10.dp))
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.Email, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(18.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Text("registrar@ruraluniv.ac.in | coe@ruraluniv.ac.in", style = MaterialTheme.typography.bodySmall)
          }
        }
      }
    }

    // 14. INSTITUTIONAL FOOTER
    item {
      Spacer(modifier = Modifier.height(16.dp))
      Column(
        modifier = Modifier
          .fillMaxWidth()
          .background(MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f))
          .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
      ) {
        Image(
          painter = painterResource(id = R.drawable.ic_gri_seal),
          contentDescription = "GRI Footer Logo",
          modifier = Modifier.size(44.dp)
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
          text = "THE GANDHIGRAM RURAL INSTITUTE",
          style = MaterialTheme.typography.labelMedium,
          fontWeight = FontWeight.Bold,
          color = MaterialTheme.colorScheme.primary,
          letterSpacing = 0.5.sp
        )
        Text(
          text = "(Deemed to be University under MoE, Govt. of India)",
          style = MaterialTheme.typography.bodySmall,
          fontSize = 11.sp,
          color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(modifier = Modifier.height(4.dp))
        Text(
          text = "கிராமம் உயர நாடு உயரும் • Truth & Non-Violence",
          style = MaterialTheme.typography.labelSmall,
          color = GriGoldDark
        )
        Spacer(modifier = Modifier.height(12.dp))
        Text(
          text = "© 2026 The Gandhigram Rural Institute. All Rights Reserved.\nDesigned for Mobile Campus Governance & Services.",
          style = MaterialTheme.typography.labelSmall,
          color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f),
          textAlign = TextAlign.Center
        )
      }
    }
  }
}

// Sub-components for Home Screen
@Composable
private fun EventRowItem(date: String, title: String, location: String) {
  Row(verticalAlignment = Alignment.CenterVertically) {
    Surface(
      color = GriNavyPrimary.copy(alpha = 0.1f),
      shape = RoundedCornerShape(GriRadius.xs)
    ) {
      Text(
        text = date,
        style = MaterialTheme.typography.labelSmall,
        fontWeight = FontWeight.Bold,
        color = GriNavyPrimary,
        modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp)
      )
    }
    Spacer(modifier = Modifier.width(12.dp))
    Column(modifier = Modifier.weight(1f)) {
      Text(title, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
      Text(location, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 11.sp)
    }
  }
}

@Composable
private fun FacilityMiniCard(title: String, subtitle: String, icon: androidx.compose.ui.graphics.vector.ImageVector, iconTint: Color) {
  Card(
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
    border = CardDefaults.outlinedCardBorder(),
    modifier = Modifier.width(170.dp)
  ) {
    Column(modifier = Modifier.padding(12.dp)) {
      Box(
        modifier = Modifier
          .size(34.dp)
          .clip(CircleShape)
          .background(iconTint.copy(alpha = 0.12f)),
        contentAlignment = Alignment.Center
      ) {
        Icon(icon, contentDescription = null, tint = iconTint, modifier = Modifier.size(18.dp))
      }
      Spacer(modifier = Modifier.height(8.dp))
      Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold, maxLines = 1)
      Text(subtitle, style = MaterialTheme.typography.bodySmall, fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 2)
    }
  }
}

@Composable
private fun LinkRowItem(title: String, url: String) {
  val context = androidx.compose.ui.platform.LocalContext.current
  val fullUrl = if (url.startsWith("http://") || url.startsWith("https://")) url else "https://$url"

  Row(
    modifier = Modifier
      .fillMaxWidth()
      .clickable {
        val intent = android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(fullUrl))
        try {
          context.startActivity(intent)
        } catch (_: Exception) {}
      }
      .padding(vertical = 4.dp),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
  ) {
    Column(modifier = Modifier.weight(1f)) {
      Text(title, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
      Text(url, style = MaterialTheme.typography.bodySmall, color = GriGoldDark, fontSize = 11.sp)
    }
    Icon(Icons.AutoMirrored.Filled.OpenInNew, contentDescription = null, tint = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.size(16.dp))
  }
}

@Composable
fun CircularCardItem(
  circular: CircularEntity,
  onMarkRead: () -> Unit
) {
  Card(
    modifier = Modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp)
      .clickable(onClick = onMarkRead)
      .testTag("circular_item_${circular.id}"),
    shape = RoundedCornerShape(GriRadius.md),
    colors = CardDefaults.cardColors(
      containerColor = if (circular.isUrgent) GriColors.AlertContainer.copy(alpha = 0.4f) else MaterialTheme.colorScheme.surface
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
        Row(
          verticalAlignment = Alignment.CenterVertically,
          horizontalArrangement = Arrangement.spacedBy(6.dp)
        ) {
          Surface(
            color = if (circular.isUrgent) GriRedAlert else GriNavyPrimary,
            shape = RoundedCornerShape(GriRadius.xs)
          ) {
            Text(
              text = circular.category.uppercase(),
              style = MaterialTheme.typography.labelSmall,
              color = Color.White,
              fontWeight = FontWeight.Bold,
              modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
            )
          }

          if (circular.isUrgent) {
            Surface(
              color = GriRedAlert.copy(alpha = 0.15f),
              shape = RoundedCornerShape(GriRadius.xs)
            ) {
              Text(
                text = "URGENT",
                style = MaterialTheme.typography.labelSmall,
                color = GriRedAlert,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
              )
            }
          }
        }

        Text(
          text = circular.publishedDate,
          style = MaterialTheme.typography.bodySmall,
          color = MaterialTheme.colorScheme.onSurfaceVariant,
          fontSize = 11.sp
        )
      }

      Spacer(modifier = Modifier.height(6.dp))

      Text(
        text = circular.title,
        style = MaterialTheme.typography.titleSmall,
        fontWeight = FontWeight.Bold,
        color = MaterialTheme.colorScheme.onSurface
      )

      Spacer(modifier = Modifier.height(4.dp))

      Text(
        text = circular.summary,
        style = MaterialTheme.typography.bodySmall,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        maxLines = 3,
        overflow = TextOverflow.Ellipsis
      )

      Spacer(modifier = Modifier.height(8.dp))

      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Text(
          text = "Issued by: ${circular.issuedBy}",
          style = MaterialTheme.typography.bodySmall,
          fontSize = 10.sp,
          color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.8f)
        )

        if (!circular.isRead) {
          Text(
            text = "Tap to Acknowledge",
            style = MaterialTheme.typography.labelSmall,
            color = GriGoldDark,
            fontWeight = FontWeight.Bold
          )
        } else {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GriGreenSuccess, modifier = Modifier.size(12.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text("Acknowledged", style = MaterialTheme.typography.labelSmall, color = GriGreenSuccess)
          }
        }
      }
    }
  }
}

// =========================================================================
// ACADEMICS SCREEN
// =========================================================================

@Composable
fun AcademicsScreen(
  courses: List<CourseEntity>,
  userRole: UserRole = UserRole.STUDENT,
  onMarkAttendance: (String) -> Unit,
  onFetchHallTicket: () -> Unit,
  modifier: Modifier = Modifier
) {
  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("academics_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "Choice Based Credit System (CBCS)",
        subtitle = "Curriculum, Attendance Tracking & Eligibility"
      )
    }

    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
        shape = RoundedCornerShape(GriRadius.md),
        colors = CardDefaults.cardColors(containerColor = GriNavyPrimary),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
      ) {
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Column(modifier = Modifier.weight(1f)) {
            Text("Semester 4 Examinations", style = MaterialTheme.typography.titleMedium, color = Color.White, fontWeight = FontWeight.Bold)
            Text("Continuous Internal Assessment (CIA) Complete", style = MaterialTheme.typography.bodySmall, color = Color.White.copy(alpha = 0.8f))
            Text("Minimum Attendance Threshold: 75%", style = MaterialTheme.typography.labelSmall, color = GriGoldSecondary, fontWeight = FontWeight.Bold)
          }
          Button(
            onClick = onFetchHallTicket,
            colors = ButtonDefaults.buttonColors(containerColor = GriGoldSecondary),
            shape = RoundedCornerShape(GriRadius.sm)
          ) {
            Text("Hall Ticket", color = Color.Black, fontWeight = FontWeight.Bold)
          }
        }
      }
    }

    item {
      GriSectionHeader(
        title = "Enrolled Courses (${courses.size})",
        subtitle = if (userRole == UserRole.FACULTY) "Authorized faculty lecture attendance register" else "Official institutional record (Read-Only live sync)"
      )
    }

    items(courses) { course ->
      CourseAttendanceCard(
        course = course,
        userRole = userRole,
        onMarkAttendance = { onMarkAttendance(course.id) }
      )
    }
  }
}

@Composable
fun CourseAttendanceCard(
  course: CourseEntity,
  userRole: UserRole = UserRole.STUDENT,
  onMarkAttendance: () -> Unit
) {
  val isEligible = course.attendancePercent >= 75
  val progress = (course.attendancePercent / 100f).coerceIn(0f, 1f)

  Card(
    modifier = Modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 5.dp)
      .testTag("course_card_${course.id}"),
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
        Column(modifier = Modifier.weight(1f)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Surface(
              color = GriNavyPrimary.copy(alpha = 0.1f),
              shape = RoundedCornerShape(GriRadius.xs)
            ) {
              Text(
                text = course.code,
                style = MaterialTheme.typography.labelSmall,
                fontWeight = FontWeight.Bold,
                color = GriNavyPrimary,
                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
              )
            }
            Spacer(modifier = Modifier.width(8.dp))
            Text(
              text = "${course.credits} Credits",
              style = MaterialTheme.typography.bodySmall,
              fontSize = 11.sp,
              color = MaterialTheme.colorScheme.onSurfaceVariant
            )
          }
          Spacer(modifier = Modifier.height(4.dp))
          Text(
            text = course.title,
            style = MaterialTheme.typography.titleSmall,
            fontWeight = FontWeight.Bold
          )
          Text(
            text = "Instructor: ${course.instructor} • ${course.schedule}",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
          )
        }

        Column(horizontalAlignment = Alignment.End) {
          Text(
            text = "${course.attendancePercent}%",
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.Bold,
            color = if (isEligible) GriGreenSuccess else GriRedAlert
          )
          Surface(
            color = if (isEligible) GriGreenSuccess.copy(alpha = 0.12f) else GriRedAlert.copy(alpha = 0.12f),
            shape = RoundedCornerShape(GriRadius.xs)
          ) {
            Text(
              text = if (isEligible) "Eligible (>75%)" else "Shortage (<75%)",
              style = MaterialTheme.typography.labelSmall,
              color = if (isEligible) GriGreenSuccess else GriRedAlert,
              fontWeight = FontWeight.Bold,
              modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
            )
          }
        }
      }

      Spacer(modifier = Modifier.height(10.dp))

      LinearProgressIndicator(
        progress = { progress },
        modifier = Modifier
          .fillMaxWidth()
          .height(6.dp)
          .clip(RoundedCornerShape(3.dp)),
        color = if (isEligible) GriGreenSuccess else GriRedAlert,
        trackColor = MaterialTheme.colorScheme.surfaceVariant
      )

      Spacer(modifier = Modifier.height(10.dp))

      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Text(
          text = "Classes: ${course.attendedClasses}/${course.totalClasses} Attended",
          style = MaterialTheme.typography.bodySmall,
          color = MaterialTheme.colorScheme.onSurfaceVariant
        )

        if (userRole == UserRole.FACULTY) {
          Button(
            onClick = onMarkAttendance,
            colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
            shape = RoundedCornerShape(GriRadius.sm),
            modifier = Modifier.testTag("btn_attend_${course.id}")
          ) {
            Icon(Icons.Default.Add, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text("Record Period Attendance")
          }
        } else {
          Surface(
            color = GriNavyPrimary.copy(alpha = 0.08f),
            shape = RoundedCornerShape(GriRadius.xs)
          ) {
            Row(
              verticalAlignment = Alignment.CenterVertically,
              modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
            ) {
              Icon(Icons.Default.Lock, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(12.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text(
                text = "Official Record • Read-Only",
                style = MaterialTheme.typography.labelSmall,
                color = GriNavyPrimary,
                fontWeight = FontWeight.SemiBold
              )
            }
          }
        }
      }
    }
  }
}

// =========================================================================
// SERVICES SCREEN — UNIFIED CAMPUS SERVICES
// =========================================================================

@Composable
fun ServicesScreen(
  courses: List<CourseEntity> = emptyList(),
  onMarkAttendance: (String) -> Unit = {},
  onFetchHallTicket: () -> Unit = {},
  transportRoutes: List<TransportRouteEntity> = emptyList(),
  grievances: List<GrievanceEntity> = emptyList(),
  userRole: UserRole = UserRole.STUDENT,
  onSubmitGrievance: (String, String, String) -> Unit = { _, _, _ -> },
  onResolveGrievance: (Long, String) -> Unit = { _, _ -> },
  modifier: Modifier = Modifier
) {
  var selectedTab by remember { mutableStateOf(0) }
  val tabs = listOf("Academics", "Transport", "Hostels", "Library", "GRI-Care")

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("services_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "GRI Campus Services",
        subtitle = "Academics, Fleet, Hostels, Central Library & GRI-Care"
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .horizontalScroll(rememberScrollState())
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
      ) {
        tabs.forEachIndexed { index, tabTitle ->
          val isSelected = selectedTab == index
          FilterChip(
            selected = isSelected,
            onClick = { selectedTab = index },
            label = { Text(tabTitle, style = MaterialTheme.typography.labelMedium) },
            colors = FilterChipDefaults.filterChipColors(
              selectedContainerColor = GriNavyPrimary,
              selectedLabelColor = Color.White
            )
          )
        }
      }
    }

    when (selectedTab) {
      0 -> {
        item {
          Card(
            modifier = Modifier
              .fillMaxWidth()
              .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
            shape = RoundedCornerShape(GriRadius.md),
            colors = CardDefaults.cardColors(containerColor = GriNavyPrimary),
            elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
          ) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Column(modifier = Modifier.weight(1f)) {
                Text("Continuous Internal Assessment (CIA)", style = MaterialTheme.typography.titleSmall, color = Color.White, fontWeight = FontWeight.Bold)
                Text("Minimum Attendance: 75% required for ESE", style = MaterialTheme.typography.bodySmall, color = GriGoldSecondary)
              }
              Button(
                onClick = onFetchHallTicket,
                colors = ButtonDefaults.buttonColors(containerColor = GriGoldSecondary),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Text("Hall Ticket", color = Color.Black, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.labelMedium)
              }
            }
          }
        }

        item {
          GriSectionHeader(
            title = "Enrolled CBCS Courses (${courses.size})",
            subtitle = if (userRole == UserRole.FACULTY) "Faculty authorized lecture attendance register" else "Official student attendance register (Read-Only live sync)"
          )
        }

        items(courses) { course ->
          CourseAttendanceCard(
            course = course,
            userRole = userRole,
            onMarkAttendance = { onMarkAttendance(course.id) }
          )
        }
      }
      1 -> {
        item {
          GriSectionHeader(
            title = "University Transport Schedule",
            subtitle = "Serving Dindigul, Madurai, Bathalagundu & Chinnalapatti routes"
          )
        }
        items(transportRoutes) { route ->
          TransportRouteCard(route = route)
        }
      }
      2 -> {
        item {
          HostelInfoSection()
        }
      }
      3 -> {
        item {
          LibraryInfoSection()
        }
      }
      4 -> {
        item {
          GrievancesSection(
            grievances = grievances,
            userRole = userRole,
            onSubmitGrievance = onSubmitGrievance,
            onResolveGrievance = onResolveGrievance
          )
        }
      }
    }
  }
}

@Composable
fun TransportRouteCard(route: TransportRouteEntity) {
  val statusColor = when (route.currentStatus) {
    "ON_TIME" -> GriGreenSuccess
    "BOARDING" -> GriGoldSecondary
    else -> GriRedAlert
  }

  Card(
    modifier = Modifier
      .fillMaxWidth()
      .padding(horizontal = GriSpacing.lg, vertical = 4.dp)
      .testTag("transport_card_${route.id}"),
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
        Row(verticalAlignment = Alignment.CenterVertically) {
          Box(
            modifier = Modifier
              .size(36.dp)
              .clip(CircleShape)
              .background(GriNavyPrimary.copy(alpha = 0.1f)),
            contentAlignment = Alignment.Center
          ) {
            Icon(Icons.Default.DirectionsBus, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(20.dp))
          }
          Spacer(modifier = Modifier.width(10.dp))
          Column {
            Text(text = "Route ${route.routeNo}: ${route.routeName}", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
            Text(text = "Bus: ${route.busNumber}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
          }
        }

        Surface(
          color = statusColor.copy(alpha = 0.12f),
          shape = RoundedCornerShape(GriRadius.xs)
        ) {
          Text(
            text = route.currentStatus.replace("_", " "),
            style = MaterialTheme.typography.labelSmall,
            color = statusColor,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp)
          )
        }
      }

      Spacer(modifier = Modifier.height(10.dp))
      HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.4f))
      Spacer(modifier = Modifier.height(8.dp))

      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
      ) {
        Column {
          Text("Departure Time", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
          Text(route.departureTime, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
        }
        Column {
          Text("Return Trip", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
          Text(route.returnTime, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
        }
        Column(horizontalAlignment = Alignment.End) {
          Text("Driver Contact", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
          Text("${route.driverName} (${route.driverPhone})", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Medium)
        }
      }
    }
  }
}

@Composable
fun HostelInfoSection() {
  Column(modifier = Modifier.padding(horizontal = GriSpacing.lg, vertical = 6.dp)) {
    Card(
      shape = RoundedCornerShape(GriRadius.lg),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
      elevation = CardDefaults.cardElevation(defaultElevation = 1.5.dp),
      border = CardDefaults.outlinedCardBorder()
    ) {
      Column(modifier = Modifier.padding(18.dp)) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
              modifier = Modifier
                .size(36.dp)
                .clip(CircleShape)
                .background(GriGoldSecondary.copy(alpha = 0.15f)),
              contentAlignment = Alignment.Center
            ) {
              Icon(Icons.Default.Hotel, contentDescription = null, tint = GriGoldDark, modifier = Modifier.size(20.dp))
            }
            Spacer(modifier = Modifier.width(10.dp))
            Column {
              Text("Residential Hostels & Mess", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
              Text("Eco-friendly solar heated campus complexes", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
          }

          Surface(color = GriGreenSuccess.copy(alpha = 0.12f), shape = RoundedCornerShape(GriRadius.xs)) {
            Text("24/7 Security", style = MaterialTheme.typography.labelSmall, color = GriGreenSuccess, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp))
          }
        }

        Spacer(modifier = Modifier.height(12.dp))
        HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))
        Spacer(modifier = Modifier.height(10.dp))

        listOf(
          Triple("Thamarai Illam", "Men's Residential Complex • 450 capacity", "Thiru. S. Murugesan (Warden)"),
          Triple("Malligai Illam", "Women's Residential Complex • 500 capacity", "Dr. V. Radha (Warden)"),
          Triple("Kasturba Scholars Hostel", "Ph.D. & Post-Doctoral Single Suites • 120 rooms", "Quiet Study Wing"),
          Triple("Working Women's Hostel", "Safe residential suites for women faculty & staff", "Guest Rooms Available")
        ).forEach { (name, desc, contact) ->
          Row(
            modifier = Modifier
              .fillMaxWidth()
              .padding(vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Box(
              modifier = Modifier
                .size(6.dp)
                .clip(CircleShape)
                .background(GriNavyPrimary)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Column(modifier = Modifier.weight(1f)) {
              Text(name, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
              Text("$desc • $contact", style = MaterialTheme.typography.bodySmall, fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
          }
        }

        Spacer(modifier = Modifier.height(12.dp))
        Surface(
          color = GriNavyPrimary.copy(alpha = 0.06f),
          shape = RoundedCornerShape(GriRadius.sm),
          modifier = Modifier.fillMaxWidth()
        ) {
          Row(
            modifier = Modifier.padding(10.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            Text("Chief Warden Office: Ext 310", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold, color = GriNavyPrimary)
            Text("Mess Hours: 07:30 - 21:00", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
          }
        }
      }
    }
  }
}

@Composable
fun LibraryInfoSection() {
  Column(modifier = Modifier.padding(horizontal = GriSpacing.lg, vertical = 6.dp)) {
    Card(
      shape = RoundedCornerShape(GriRadius.lg),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
      elevation = CardDefaults.cardElevation(defaultElevation = 1.5.dp),
      border = CardDefaults.outlinedCardBorder()
    ) {
      Column(modifier = Modifier.padding(18.dp)) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
              modifier = Modifier
                .size(36.dp)
                .clip(CircleShape)
                .background(GriNavyPrimary.copy(alpha = 0.1f)),
              contentAlignment = Alignment.Center
            ) {
              Icon(Icons.AutoMirrored.Filled.LibraryBooks, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(20.dp))
            }
            Spacer(modifier = Modifier.width(10.dp))
            Column {
              Text("Dr. Radhakrishnan Central Library", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
              Text("Automated RFID Kiosk & e-ShodhSindhu Consortia", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
          }

          Surface(color = GriGoldContainer, shape = RoundedCornerShape(GriRadius.xs)) {
            Text("OPEN", style = MaterialTheme.typography.labelSmall, color = GriGoldOnContainer, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp))
          }
        }

        Spacer(modifier = Modifier.height(12.dp))
        HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))
        Spacer(modifier = Modifier.height(10.dp))

        Text("• Holdings: 1,75,000+ Print Volumes, 3,500 Rare Gandhian Historical Manuscripts", style = MaterialTheme.typography.bodySmall)
        Text("• Electronic Access: DELNET, ScienceDirect, Springer, JSTOR, IEEE Xplore digital library", style = MaterialTheme.typography.bodySmall)
        Text("• Working Hours: 08:00 AM – 08:00 PM (Monday – Saturday, Exam hours extended to 22:00)", style = MaterialTheme.typography.bodySmall)

        Spacer(modifier = Modifier.height(12.dp))
        Surface(
          color = GriGoldContainer,
          shape = RoundedCornerShape(GriRadius.sm),
          modifier = Modifier.fillMaxWidth()
        ) {
          Row(
            modifier = Modifier.padding(10.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            Text("Web OPAC Catalog: opac.ruraluniv.ac.in", style = MaterialTheme.typography.labelSmall, color = GriGoldOnContainer, fontWeight = FontWeight.Bold)
            Icon(Icons.Default.Launch, contentDescription = null, tint = GriGoldDark, modifier = Modifier.size(16.dp))
          }
        }
      }
    }
  }
}

@Composable
fun GrievancesSection(
  grievances: List<GrievanceEntity>,
  userRole: UserRole,
  onSubmitGrievance: (String, String, String) -> Unit,
  onResolveGrievance: (Long, String) -> Unit
) {
  var showForm by remember { mutableStateOf(false) }
  var category by remember { mutableStateOf("Hostel") }
  var subject by remember { mutableStateOf("") }
  var description by remember { mutableStateOf("") }
  val categories = listOf("Hostel", "Transport", "Academic", "Sanitation", "Infrastructure")

  Column(modifier = Modifier.fillMaxWidth()) {
    Card(
      modifier = Modifier
        .fillMaxWidth()
        .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
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
          Column(modifier = Modifier.weight(1f)) {
            Text("GRI-Care Grievance Cell", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
            Text("UGC Regulations compliant anti-harassment committee", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
          }
          Button(
            onClick = { showForm = !showForm },
            colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
            shape = RoundedCornerShape(GriRadius.sm),
            modifier = Modifier.testTag("btn_toggle_grievance_form")
          ) {
            Text(if (showForm) "Close" else "Register Ticket")
          }
        }

        AnimatedVisibility(visible = showForm) {
          Column(modifier = Modifier.padding(top = 12.dp)) {
            Text("Select Category:", style = MaterialTheme.typography.labelSmall)
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .horizontalScroll(rememberScrollState())
                .padding(vertical = 4.dp),
              horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
              categories.forEach { cat ->
                FilterChip(
                  selected = category == cat,
                  onClick = { category = cat },
                  label = { Text(cat, style = MaterialTheme.typography.labelSmall) }
                )
              }
            }

            OutlinedTextField(
              value = subject,
              onValueChange = { subject = it },
              label = { Text("Subject") },
              singleLine = true,
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp)
                .testTag("input_grievance_subject")
            )

            OutlinedTextField(
              value = description,
              onValueChange = { description = it },
              label = { Text("Detailed Description") },
              modifier = Modifier
                .fillMaxWidth()
                .height(100.dp)
                .padding(vertical = 4.dp)
                .testTag("input_grievance_description")
            )

            Button(
              onClick = {
                if (subject.isNotBlank() && description.isNotBlank()) {
                  onSubmitGrievance(category, subject, description)
                  subject = ""
                  description = ""
                  showForm = false
                }
              },
              enabled = subject.isNotBlank() && description.isNotBlank(),
              colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier
                .fillMaxWidth()
                .padding(top = 8.dp)
                .testTag("btn_submit_grievance")
            ) {
              Text("Submit Ticket")
            }
          }
        }
      }
    }

    GriSectionHeader(
      title = "Registered Tickets (${grievances.size})",
      subtitle = "Track resolution status in real time"
    )

    grievances.forEach { ticket ->
      val statusColor = when (ticket.status) {
        "RESOLVED" -> GriGreenSuccess
        "IN_PROGRESS" -> GriGoldSecondary
        else -> GriRedAlert
      }
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp)
          .testTag("ticket_card_${ticket.id}"),
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
            Row(verticalAlignment = Alignment.CenterVertically) {
              Surface(
                color = GriNavyPrimary.copy(alpha = 0.1f),
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(ticket.ticketNumber, style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold, color = GriNavyPrimary, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
              }
              Spacer(modifier = Modifier.width(6.dp))
              Text(ticket.category, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
            Surface(
              color = statusColor.copy(alpha = 0.12f),
              shape = RoundedCornerShape(GriRadius.xs)
            ) {
              Text(ticket.status, style = MaterialTheme.typography.labelSmall, color = statusColor, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
            }
          }

          Spacer(modifier = Modifier.height(6.dp))
          Text(ticket.subject, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
          Text(ticket.description, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)

          if (ticket.remarks.isNotBlank()) {
            Spacer(modifier = Modifier.height(8.dp))
            Surface(color = MaterialTheme.colorScheme.surfaceVariant, shape = RoundedCornerShape(GriRadius.xs)) {
              Text("Officer Remarks: ${ticket.remarks}", style = MaterialTheme.typography.bodySmall, fontSize = 11.sp, modifier = Modifier.padding(6.dp))
            }
          }

          if (userRole == UserRole.ADMIN && ticket.status != "RESOLVED") {
            Spacer(modifier = Modifier.height(8.dp))
            Button(
              onClick = { onResolveGrievance(ticket.id, "Action taken by administrative officer") },
              colors = ButtonDefaults.buttonColors(containerColor = GriGreenSuccess),
              shape = RoundedCornerShape(GriRadius.sm)
            ) {
              Text("Mark as Resolved")
            }
          }
        }
      }
    }
  }
}

// =========================================================================
// NEWS & EVENTS SCREEN (NEWS TAB)
// =========================================================================

@Composable
fun NewsEventsScreen(
  circulars: List<CircularEntity>,
  onMarkCircularRead: (String) -> Unit,
  modifier: Modifier = Modifier
) {
  var selectedCategory by remember { mutableStateOf("All") }
  var searchQuery by remember { mutableStateOf("") }
  val categories = listOf("All", "Examination", "Admissions", "Academic", "Administrative", "Events")

  val filteredCirculars = remember(selectedCategory, searchQuery, circulars) {
    circulars.filter { circular ->
      val matchesCat = if (selectedCategory == "All") true else circular.category.equals(selectedCategory, ignoreCase = true)
      val matchesSearch = if (searchQuery.isBlank()) true else {
        circular.title.contains(searchQuery, ignoreCase = true) ||
        circular.summary.contains(searchQuery, ignoreCase = true) ||
        circular.issuedBy.contains(searchQuery, ignoreCase = true)
      }
      matchesCat && matchesSearch
    }
  }

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("news_events_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "Official Gazette & Circulars",
        subtitle = "Notices, Examinations, Campus Events & University Orders"
      )
    }

    item {
      GriSearchBar(
        query = searchQuery,
        onQueryChange = { searchQuery = it },
        placeholder = "Search announcements, orders, notifications..."
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .horizontalScroll(rememberScrollState())
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
      ) {
        categories.forEach { cat ->
          val isSelected = selectedCategory == cat
          FilterChip(
            selected = isSelected,
            onClick = { selectedCategory = cat },
            label = { Text(cat, style = MaterialTheme.typography.labelMedium) },
            colors = FilterChipDefaults.filterChipColors(
              selectedContainerColor = GriNavyPrimary,
              selectedLabelColor = Color.White
            )
          )
        }
      }
    }

    item {
      GriSectionHeader(
        title = "Announcements (${filteredCirculars.size})",
        subtitle = "Tap any circular to mark as officially acknowledged"
      )
    }

    items(filteredCirculars) { circular ->
      CircularCardItem(
        circular = circular,
        onMarkRead = { onMarkCircularRead(circular.id) }
      )
    }

    item {
      GriSectionHeader(
        title = "Upcoming University Events",
        subtitle = "Gandhian Assemblies, Academic Conferences & Placement"
      )
    }

    item {
      Card(
        modifier = Modifier
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
            Surface(color = GriGoldContainer, shape = RoundedCornerShape(GriRadius.xs)) {
              Text("CONVOCATION", style = MaterialTheme.typography.labelSmall, color = GriGoldOnContainer, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
            }
            Text("18 Nov 2026", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold, color = GriNavyPrimary)
          }
          Spacer(modifier = Modifier.height(6.dp))
          Text("41st Annual Convocation of GRI", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
          Text("Dr. T.S. Soundram Auditorium • Hon'ble Chancellor presiding. Degree conferment for UG, PG, and Ph.D. scholars.", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
      }
    }

    item {
      Card(
        modifier = Modifier
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
            Surface(color = GriNavyPrimary.copy(alpha = 0.1f), shape = RoundedCornerShape(GriRadius.xs)) {
              Text("RURAL EXTENSION", style = MaterialTheme.typography.labelSmall, color = GriNavyPrimary, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
            }
            Text("02 Oct 2026", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold, color = GriNavyPrimary)
          }
          Spacer(modifier = Modifier.height(6.dp))
          Text("Gandhi Jayanti & Sarvodaya Peace Gathering", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
          Text("Multipurpose Hall • Interfaith prayer, khadi spinning demonstration, and village cleanliness drive across adopted rural hamlets.", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
      }
    }
  }
}

// =========================================================================
// PUBLIC EXPLORE SCREEN (EXPLORE TAB)
// =========================================================================

@Composable
fun PublicExploreScreen(
  modifier: Modifier = Modifier
) {
  var selectedCategory by remember { mutableStateOf("All") }
  var selectedDocForPreview by remember { mutableStateOf<com.example.ui.components.GriDocument?>(null) }

  val categories = listOf(
    "All",
    "About GRI",
    "Governance",
    "Schools & Depts",
    "Programmes",
    "Admissions",
    "Examinations",
    "Facilities",
    "Research",
    "Alumni",
    "Downloads",
    "Contact"
  )

  val officialDocuments = remember {
    listOf(
      com.example.ui.components.GriDocument(
        id = "doc_prospectus_2026",
        title = "GRI Admission Prospectus 2026–2027",
        category = "Admissions",
        date = "15 Aug 2026",
        fileType = "PDF",
        fileSize = "4.2 MB",
        description = "Complete eligibility criteria, CUET guidelines, intake capacity and fee structure for UG, PG, Diploma and Ph.D. programmes."
      ),
      com.example.ui.components.GriDocument(
        id = "doc_cbcs_regulations",
        title = "CBCS Academic Regulations & Grading System",
        category = "Academics",
        date = "10 Jul 2026",
        fileType = "PDF",
        fileSize = "1.8 MB",
        description = "Official guidelines for Choice Based Credit System, CIA continuous evaluation, minimum 75% attendance rule and semester credits."
      ),
      com.example.ui.components.GriDocument(
        id = "doc_exam_timetable_nov2026",
        title = "End Semester Examinations Nov-Dec 2026 Timetable",
        category = "Examinations",
        date = "14 Sep 2026",
        fileType = "PDF",
        fileSize = "920 KB",
        description = "Detailed slot-wise schedule for theory and practical examinations across all Schools and Departments."
      ),
      com.example.ui.components.GriDocument(
        id = "doc_phd_guidelines",
        title = "Ph.D. Research Regulations & Fellowship Manual",
        category = "Research",
        date = "01 Jun 2026",
        fileType = "PDF",
        fileSize = "1.1 MB",
        description = "UGC Minimum Standards compliance for M.Phil/Ph.D. degree awards, course work credits, and ethical clearance."
      ),
      com.example.ui.components.GriDocument(
        id = "doc_anti_ragging_policy",
        title = "UGC Anti-Ragging & Internal Complaints Committee Handbook",
        category = "Governance",
        date = "01 Jan 2026",
        fileType = "PDF",
        fileSize = "650 KB",
        description = "Zero-tolerance campus safety directives, committee member contacts, and confidential reporting protocols."
      ),
      com.example.ui.components.GriDocument(
        id = "doc_annual_report_nirf",
        title = "GRI Annual Report 2025–26 & NIRF Ranking Data",
        category = "Reports",
        date = "20 May 2026",
        fileType = "PDF",
        fileSize = "5.4 MB",
        description = "University achievements in teaching, research publications, rural extension patents, and NAAC A+ 3.34 audit data."
      )
    )
  }

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("public_explore_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "Institutional Repository & Directory",
        subtitle = "Gandhigram Rural Institute • Deemed to be University"
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .horizontalScroll(rememberScrollState())
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
      ) {
        categories.forEach { cat ->
          val isSelected = selectedCategory == cat
          FilterChip(
            selected = isSelected,
            onClick = { selectedCategory = cat },
            label = { Text(cat, style = MaterialTheme.typography.labelMedium) },
            colors = FilterChipDefaults.filterChipColors(
              selectedContainerColor = GriNavyPrimary,
              selectedLabelColor = Color.White
            )
          )
        }
      }
    }

    // 1. ABOUT GRI
    if (selectedCategory == "All" || selectedCategory == "About GRI") {
      item {
        GriSectionHeader(
          title = "About Gandhigram Rural Institute",
          subtitle = "Nai Talim Philosophy, Heritage & Vision"
        )
      }
      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Image(painter = painterResource(id = R.drawable.ic_gri_seal), contentDescription = null, modifier = Modifier.size(44.dp))
              Spacer(modifier = Modifier.width(12.dp))
              Column {
                Text("Heritage of 70 Years (Est. 1956)", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Text("NAAC A+ (3.34 CGPA) • Ministry of Education, GoI", style = MaterialTheme.typography.bodySmall, color = GriGoldDark)
              }
            }
            Spacer(modifier = Modifier.height(10.dp))
            Text(
              text = "Founded in 1956 by Dr. T.S. Soundram and Dr. G. Ramachandran under the direct guidance of Mahatma Gandhi, GRI has pioneered rural higher education in India. It was granted Deemed to be University status under Section 3 of the UGC Act in 1976.",
              style = MaterialTheme.typography.bodySmall
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
              text = "• Core Mission: To promote a classless and casteless society through three-dimensional education: Teaching, Research, and Extension.\n• Hallmark: Village Placement Programme (VPP) where students live in rural hamlets to study and solve grassroots challenges.",
              style = MaterialTheme.typography.bodySmall,
              color = MaterialTheme.colorScheme.onSurfaceVariant
            )
          }
        }
      }
    }

    // 2. GOVERNANCE & STATUTORY LEADERSHIP
    if (selectedCategory == "All" || selectedCategory == "Governance") {
      item {
        GriSectionHeader(
          title = "Statutory Governance & Authorities",
          subtitle = "Executive Council, Statutory Officers & Academic Senate"
        )
      }
      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
          shape = RoundedCornerShape(GriRadius.lg),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.5.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(18.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Box(
                modifier = Modifier
                  .size(36.dp)
                  .clip(CircleShape)
                  .background(GriNavyPrimary.copy(alpha = 0.1f)),
                contentAlignment = Alignment.Center
              ) {
                Icon(Icons.Default.Apartment, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(20.dp))
              }
              Spacer(modifier = Modifier.width(10.dp))
              Column {
                Text("Statutory Officers of the Institute", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Text("Appointed under UGC Deemed to be University Regulations", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
              }
            }

            Spacer(modifier = Modifier.height(12.dp))
            HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))
            Spacer(modifier = Modifier.height(8.dp))

            listOf(
              Triple("Chancellor", "Dr. K.M. Annamalai", "Presiding Head of the University"),
              Triple("Vice-Chancellor", "Prof. Dr. N. Panchanatham", "Chief Academic & Executive Officer"),
              Triple("Registrar (i/c)", "Dr. M. Sundaramari", "Custodian of University Records & Administration"),
              Triple("Controller of Examinations", "Dr. V. Sivakumar", "Evaluation, Convocation & Degree Sanctions"),
              Triple("Finance Officer (i/c)", "Dr. P. Shanmugavadivu", "University Treasury & Grants Management"),
              Triple("Dean, Academic Affairs", "Prof. M.G. Sethuraman", "Curriculum, CBCS & Quality Assurance")
            ).forEach { (role, name, designation) ->
              Row(
                modifier = Modifier
                  .fillMaxWidth()
                  .padding(vertical = 5.dp),
                verticalAlignment = Alignment.CenterVertically
              ) {
                Surface(
                  color = GriNavyPrimary.copy(alpha = 0.08f),
                  shape = RoundedCornerShape(GriRadius.xs),
                  modifier = Modifier.width(110.dp)
                ) {
                  Text(
                    text = role,
                    style = MaterialTheme.typography.labelSmall,
                    color = GriNavyPrimary,
                    fontWeight = FontWeight.Bold,
                    fontSize = 10.sp,
                    maxLines = 1,
                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 4.dp)
                  )
                }
                Spacer(modifier = Modifier.width(10.dp))
                Column(modifier = Modifier.weight(1f)) {
                  Text(name, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
                  Text(designation, style = MaterialTheme.typography.bodySmall, fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
              }
            }
          }
        }
      }
    }

    // 3. SCHOOLS & DEPARTMENTS
    if (selectedCategory == "All" || selectedCategory == "Schools & Depts") {
      item {
        GriSectionHeader(
          title = "Schools & Academic Departments",
          subtitle = "8 Schools, 20+ Specialised Departments"
        )
      }
      item {
        com.example.ui.components.GriDepartmentCard(
          name = "Department of Computer Science & Applications",
          school = "School of Sciences",
          head = "Dr. K. Senthilkumar (Prof. & Head)"
        )
      }
      item {
        com.example.ui.components.GriDepartmentCard(
          name = "Department of Agriculture & Animal Sciences",
          school = "School of Agriculture and Rural Development",
          head = "Dr. S. Rajendran (Dean & Professor)"
        )
      }
      item {
        com.example.ui.components.GriDepartmentCard(
          name = "Department of Rural Development",
          school = "School of Social Sciences",
          head = "Dr. P. Anandharajakumar (Professor & Head)"
        )
      }
      item {
        com.example.ui.components.GriDepartmentCard(
          name = "Department of Management Studies",
          school = "School of Management Studies",
          head = "Dr. V. Ragupathi (Professor & Head)"
        )
      }
      item {
        com.example.ui.components.GriDepartmentCard(
          name = "Department of Chemistry",
          school = "School of Sciences",
          head = "Dr. S. Abraham John (Dean of Research)"
        )
      }
      item {
        com.example.ui.components.GriDepartmentCard(
          name = "Department of Education (ITEP)",
          school = "School of Education",
          head = "Dr. P.S. Sreedevi (Professor & Head)"
        )
      }
    }

    // 4. PROGRAMMES
    if (selectedCategory == "All" || selectedCategory == "Programmes") {
      item {
        GriSectionHeader(
          title = "Academic Programmes Offered",
          subtitle = "Undergraduate, Postgraduate, Professional & Doctoral Degrees"
        )
      }
      item {
        com.example.ui.components.GriProgrammeCard(
          title = "Master of Computer Applications (MCA)",
          level = "Postgraduate (AICTE Approved)",
          duration = "2 Years (4 Semesters)",
          eligibility = "BCA / B.Sc. Computer Science / IT or Mathematics at +2 level"
        )
      }
      item {
        com.example.ui.components.GriProgrammeCard(
          title = "B.Sc. (Hons) Agriculture",
          level = "Undergraduate (ICAR Accredited)",
          duration = "4 Years (8 Semesters)",
          eligibility = "+2 Higher Secondary with Physics, Chemistry, Biology / Agriculture"
        )
      }
      item {
        com.example.ui.components.GriProgrammeCard(
          title = "Integrated Teacher Education Programme (ITEP B.Ed)",
          level = "Dual Degree (NCTE Approved)",
          duration = "4 Years (8 Semesters)",
          eligibility = "National Common Entrance Test (NCET) / +2 with 50% Marks"
        )
      }
      item {
        com.example.ui.components.GriProgrammeCard(
          title = "MBA (Rural Management)",
          level = "Postgraduate Professional",
          duration = "2 Years (4 Semesters)",
          eligibility = "Any Bachelor's Degree with CUET-PG / CAT / MAT Score"
        )
      }
      item {
        com.example.ui.components.GriProgrammeCard(
          title = "Doctor of Philosophy (Ph.D.)",
          level = "Research Doctorate",
          duration = "3 to 5 Years",
          eligibility = "Master's Degree with minimum 55% marks and UGC-NET / JRF qualification"
        )
      }
    }

    // 5. OFFICIAL DOCUMENTS & DOWNLOADS
    if (selectedCategory == "All" || selectedCategory == "Downloads") {
      item {
        GriSectionHeader(
          title = "Official Document Library (${officialDocuments.size})",
          subtitle = "Tap to open, verify cryptographic hash, and inspect"
        )
      }
      items(officialDocuments) { doc ->
        com.example.ui.components.GriDocumentCard(
          document = doc,
          onOpen = { selectedDocForPreview = doc }
        )
      }
    }

    // 6. CONTACT & IMPORTANT LINKS
    if (selectedCategory == "All" || selectedCategory == "Contact") {
      item {
        GriSectionHeader(
          title = "Official Contacts & Portals",
          subtitle = "University Directory, Portals & Campus Location"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Main University Portal",
          url = "https://ruraluniv.ac.in/"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Samarth@GRI ERP Portal",
          url = "https://ruraluniv.samarth.ac.in/index.php/site/login"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Student Examination Portal",
          url = "https://portal.ruraluniv.ac.in/"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Online Attendance Portal",
          url = "https://attendance.ruraluniv.ac.in/"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Tatkal Scheme (48-Hr Degree)",
          url = "https://www.portal.ruraluniv.ac.in/tatkal"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "e-SANAD Attestation Portal",
          url = "https://www.portal.ruraluniv.ac.in/esanad"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Convocation XXXIX Portal",
          url = "https://convocation.ruraluniv.ac.in/"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Pensioner Digital Portal",
          url = "https://pension.ruraluniv.ac.in/"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "Alumni Association (GRI-AA)",
          url = "https://ruraluniv.ac.in/includes/AlumniGRI"
        )
      }
      item {
        com.example.ui.components.GriOfficialLinkCard(
          title = "DigiLocker / NAD Academic Repository",
          url = "https://nad.digitallocker.gov.in/"
        )
      }
      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Text("Campus Location & Directory", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(6.dp))
            Text("The Gandhigram Rural Institute (Deemed to be University)", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
            Text("Gandhigram Post, Dindigul District - 624 302, Tamil Nadu, India", style = MaterialTheme.typography.bodySmall)
            Spacer(modifier = Modifier.height(6.dp))
            Text("• EPABX Phones: +91 451 2452371, 2452372, 2452373", style = MaterialTheme.typography.bodySmall)
            Text("• Registrar Email: registrar@ruraluniv.ac.in", style = MaterialTheme.typography.bodySmall)
            Text("• CoE Email: coe@ruraluniv.ac.in", style = MaterialTheme.typography.bodySmall)
            Text("• Admissions Cell: admissions@ruraluniv.ac.in", style = MaterialTheme.typography.bodySmall)
          }
        }
      }
    }
  }

  // Document Preview Dialog
  selectedDocForPreview?.let { doc ->
    com.example.ui.components.GriDocumentDialog(
      document = doc,
      onDismiss = { selectedDocForPreview = null },
      onDownload = {
        selectedDocForPreview = null
      }
    )
  }
}

// =========================================================================
// PROFILE & ADMIN CONSOLE SCREEN (PROFILE TAB)
// =========================================================================

@Composable
fun ProfileAndAdminScreen(
  uiState: GriUiState,
  onToggleServer: () -> Unit,
  onTriggerSync: () -> Unit,
  onPublishCircular: (title: String, category: String, summary: String, isUrgent: Boolean, issuedBy: String) -> Unit,
  onSendNotification: (title: String, message: String, audience: String) -> Unit,
  onApplyStaffLeave: (leaveType: String, startDate: String, endDate: String, reason: String) -> Unit = { _, _, _, _ -> },
  onFetchHallTicket: () -> Unit = {},
  modifier: Modifier = Modifier
) {
  // Admin publishing flow state
  var newNoticeTitle by remember { mutableStateOf("") }
  var newNoticeCategory by remember { mutableStateOf("Academic") }
  var newNoticeSummary by remember { mutableStateOf("") }
  var newNoticeIsUrgent by remember { mutableStateOf(false) }
  var currentPublishStep by remember { mutableStateOf(1) } // 1: Draft, 2: Review, 3: Authorization, 4: Seal, 5: Publish
  var isAuthorizedByRegistrar by remember { mutableStateOf(false) }

  // Admin notification state
  var notifTitle by remember { mutableStateOf("") }
  var notifMessage by remember { mutableStateOf("") }
  var notifAudience by remember { mutableStateOf("ALL CAMPUS") }
  var showNotifPreview by remember { mutableStateOf(false) }

  // Staff leave application state
  var leaveType by remember { mutableStateOf("Casual Leave") }
  var leaveStartDate by remember { mutableStateOf("2026-10-05") }
  var leaveEndDate by remember { mutableStateOf("2026-10-07") }
  var leaveReason by remember { mutableStateOf("") }
  var leaveSubmittedMessage by remember { mutableStateOf<String?>(null) }
  var requisitionSubmittedMessage by remember { mutableStateOf<String?>(null) }
  var facultyActionMessage by remember { mutableStateOf<String?>(null) }
  var studentActionMessage by remember { mutableStateOf<String?>(null) }

  val noticeCategories = listOf("Academic", "Examination", "Admissions", "Administrative", "Hostel")
  val audiences = listOf("ALL CAMPUS", "STUDENTS", "FACULTY", "STAFF", "HOSTELITES")
  val staffLeaveTypes = listOf("Casual Leave", "Earned Leave", "Medical Leave", "Duty Leave")

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("profile_admin_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    // 1. DIGITAL ID CARD
    uiState.currentUser?.let { user ->
      item {
        GriSectionHeader(
          title = "University Digital Identity",
          subtitle = "Cryptographically signed institutional credentials"
        )
      }
      item {
        DigitalIdCard(user = user)
      }
    }

    // =====================================================================
    // 2. STAFF ROLE PORTAL
    // =====================================================================
    if (uiState.currentRole == UserRole.STAFF) {
      item {
        GriSectionHeader(
          title = "GRI Staff Operations Portal",
          subtitle = "Service records, leave sanctions, campus maintenance & circulars"
        )
      }

      // Staff Service Profile
      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
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
                    .size(42.dp)
                    .clip(CircleShape)
                    .background(GriNavyPrimary.copy(alpha = 0.1f)),
                  contentAlignment = Alignment.Center
                ) {
                  Icon(Icons.Default.Badge, contentDescription = null, tint = GriNavyPrimary, modifier = Modifier.size(22.dp))
                }
                Spacer(modifier = Modifier.width(12.dp))
                Column {
                  Text("Thiru. M. Sundaram", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                  Text("Senior Executive Assistant", style = MaterialTheme.typography.bodySmall, color = GriGoldDark, fontWeight = FontWeight.SemiBold)
                }
              }
              Surface(
                color = GriGreenSuccess.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(
                  text = "PERMANENT CADRE",
                  style = MaterialTheme.typography.labelSmall,
                  color = GriGreenSuccess,
                  fontWeight = FontWeight.Bold,
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp)
                )
              }
            }

            Spacer(modifier = Modifier.height(12.dp))
            HorizontalDivider()
            Spacer(modifier = Modifier.height(10.dp))

            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
              Column {
                Text("Service ID", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                Text("STF-ADM-042", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
              }
              Column {
                Text("Department / Section", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                Text("General Admin & Estate", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
              }
              Column(horizontalAlignment = Alignment.End) {
                Text("Pay Scale / Level", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                Text("Level 7 (7th CPC)", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
              }
            }
          }
        }
      }

      // Leave Balances Grid
      item {
        GriSectionHeader(
          title = "Leave Balances (Calendar Year 2026)",
          subtitle = "Sanctioned balance as per Central Civil Services (CCS) Leave Rules"
        )
      }

      item {
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
          horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
          Surface(
            color = MaterialTheme.colorScheme.surface,
            shape = RoundedCornerShape(GriRadius.sm),
            border = androidx.compose.foundation.BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant),
            modifier = Modifier.weight(1f)
          ) {
            Column(modifier = Modifier.padding(10.dp), horizontalAlignment = Alignment.CenterHorizontally) {
              Text("Casual Leave", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp)
              Text("8 / 12", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = GriNavyPrimary)
              Text("Days Left", style = MaterialTheme.typography.labelSmall, fontSize = 9.sp)
            }
          }

          Surface(
            color = MaterialTheme.colorScheme.surface,
            shape = RoundedCornerShape(GriRadius.sm),
            border = androidx.compose.foundation.BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant),
            modifier = Modifier.weight(1f)
          ) {
            Column(modifier = Modifier.padding(10.dp), horizontalAlignment = Alignment.CenterHorizontally) {
              Text("Earned Leave", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp)
              Text("24 / 30", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = GriGreenSuccess)
              Text("Accumulated", style = MaterialTheme.typography.labelSmall, fontSize = 9.sp)
            }
          }

          Surface(
            color = MaterialTheme.colorScheme.surface,
            shape = RoundedCornerShape(GriRadius.sm),
            border = androidx.compose.foundation.BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant),
            modifier = Modifier.weight(1f)
          ) {
            Column(modifier = Modifier.padding(10.dp), horizontalAlignment = Alignment.CenterHorizontally) {
              Text("Medical Leave", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp)
              Text("12 / 15", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = GriGoldDark)
              Text("Commuted", style = MaterialTheme.typography.labelSmall, fontSize = 9.sp)
            }
          }

          Surface(
            color = MaterialTheme.colorScheme.surface,
            shape = RoundedCornerShape(GriRadius.sm),
            border = androidx.compose.foundation.BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant),
            modifier = Modifier.weight(1f)
          ) {
            Column(modifier = Modifier.padding(10.dp), horizontalAlignment = Alignment.CenterHorizontally) {
              Text("Duty / SCL", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp)
              Text("3 / 8", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = GriAccentCyan)
              Text("Restricted", style = MaterialTheme.typography.labelSmall, fontSize = 9.sp)
            }
          }
        }
      }

      // Apply for Official Leave Form
      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Text("Apply for Official Staff Leave", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Text("Electronic application directly submitted to Establishment Section & Registrar", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)

            Spacer(modifier = Modifier.height(10.dp))
            Text("Select Leave Nature:", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.SemiBold)
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .horizontalScroll(rememberScrollState())
                .padding(vertical = 4.dp),
              horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
              staffLeaveTypes.forEach { type ->
                FilterChip(
                  selected = leaveType == type,
                  onClick = { leaveType = type },
                  label = { Text(type, style = MaterialTheme.typography.labelSmall) }
                )
              }
            }

            Spacer(modifier = Modifier.height(8.dp))
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              OutlinedTextField(
                value = leaveStartDate,
                onValueChange = { leaveStartDate = it },
                label = { Text("From Date") },
                singleLine = true,
                modifier = Modifier.weight(1f).testTag("input_staff_leave_start")
              )
              OutlinedTextField(
                value = leaveEndDate,
                onValueChange = { leaveEndDate = it },
                label = { Text("To Date") },
                singleLine = true,
                modifier = Modifier.weight(1f).testTag("input_staff_leave_end")
              )
            }

            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(
              value = leaveReason,
              onValueChange = { leaveReason = it },
              label = { Text("Reason / Station Leaving Permission Justification") },
              placeholder = { Text("e.g. Attending family function / medical checkup") },
              modifier = Modifier
                .fillMaxWidth()
                .testTag("input_staff_leave_reason")
            )

            leaveSubmittedMessage?.let { msg ->
              Spacer(modifier = Modifier.height(8.dp))
              Surface(
                color = GriGreenSuccess.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.xs),
                modifier = Modifier.fillMaxWidth()
              ) {
                Text(
                  text = msg,
                  style = MaterialTheme.typography.bodySmall,
                  color = GriGreenSuccess,
                  fontWeight = FontWeight.Bold,
                  modifier = Modifier.padding(8.dp)
                )
              }
            }

            Spacer(modifier = Modifier.height(12.dp))
            Button(
              onClick = {
                if (leaveReason.isNotBlank()) {
                  onApplyStaffLeave(leaveType, leaveStartDate, leaveEndDate, leaveReason)
                  leaveSubmittedMessage = "Leave application for $leaveType ($leaveStartDate to $leaveEndDate) submitted to Registrar Office for sanction."
                  leaveReason = ""
                }
              },
              enabled = leaveReason.isNotBlank(),
              colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.fillMaxWidth().testTag("btn_submit_staff_leave")
            ) {
              Icon(Icons.Default.Send, contentDescription = null, modifier = Modifier.size(16.dp))
              Spacer(modifier = Modifier.width(6.dp))
              Text("Submit Leave Application for Sanction")
            }
          }
        }
      }

      // Staff Leave Records List
      item {
        GriSectionHeader(
          title = "Leave History & Sanctions (${uiState.staffLeaveRecords.size})",
          subtitle = "Official status log from the Establishment Register"
        )
      }

      items(uiState.staffLeaveRecords) { record ->
        val isApproved = record.status == "APPROVED"
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
          shape = RoundedCornerShape(GriRadius.sm),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(12.dp)) {
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Text(text = record.leaveType, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
              Surface(
                color = if (isApproved) GriGreenSuccess.copy(alpha = 0.12f) else GriGoldSecondary.copy(alpha = 0.15f),
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(
                  text = record.status,
                  style = MaterialTheme.typography.labelSmall,
                  color = if (isApproved) GriGreenSuccess else GriGoldDark,
                  fontWeight = FontWeight.Bold,
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                )
              }
            }
            Spacer(modifier = Modifier.height(4.dp))
            Text(
              text = "${record.fromDate} to ${record.toDate} (${record.days} Days)",
              style = MaterialTheme.typography.bodySmall,
              fontWeight = FontWeight.SemiBold
            )
            Text(
              text = "Reason: ${record.reason}",
              style = MaterialTheme.typography.bodySmall,
              color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
              text = "Status: ${record.status} • Sanction Authority: Registrar Office",
              style = MaterialTheme.typography.labelSmall,
              color = MaterialTheme.colorScheme.onSurfaceVariant,
              fontSize = 10.sp
            )
          }
        }
      }

      // Campus Estate Requisitions
      item {
        GriSectionHeader(
          title = "Campus Estate & Facility Work Requisitions",
          subtitle = "Submit maintenance work orders to the University Engineer"
        )
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(14.dp)) {
            Text("Work Order Services:", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold)
            Text("Click to raise a priority maintenance indent with the University Engineering Section", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 11.sp)
            Spacer(modifier = Modifier.height(8.dp))
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              OutlinedButton(
                onClick = { requisitionSubmittedMessage = "ICT & Wi-Fi Work Order #WO-ICT-2026-089 submitted to University Computer Centre." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Text("ICT & Wi-Fi", fontSize = 11.sp)
              }
              OutlinedButton(
                onClick = { requisitionSubmittedMessage = "Electrical Indent #WO-ELE-2026-042 submitted to Estate Electrical Wing." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Text("Electrical & Solar", fontSize = 11.sp)
              }
            }
            Spacer(modifier = Modifier.height(6.dp))
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              OutlinedButton(
                onClick = { requisitionSubmittedMessage = "Civil/Plumbing Work Order #WO-CIV-2026-115 submitted to Campus Maintenance Section." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Text("Civil / Plumbing", fontSize = 11.sp)
              }
              OutlinedButton(
                onClick = { requisitionSubmittedMessage = "Official Vehicle Indent #IND-VEH-2026-018 routed to Transport Officer & Registrar." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Text("Vehicle Indent", fontSize = 11.sp)
              }
            }

            requisitionSubmittedMessage?.let { msg ->
              Spacer(modifier = Modifier.height(10.dp))
              Surface(
                color = GriGreenSuccess.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.xs),
                modifier = Modifier.fillMaxWidth()
              ) {
                Row(
                  modifier = Modifier.padding(10.dp),
                  verticalAlignment = Alignment.CenterVertically
                ) {
                  Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GriGreenSuccess, modifier = Modifier.size(16.dp))
                  Spacer(modifier = Modifier.width(6.dp))
                  Text(msg, style = MaterialTheme.typography.bodySmall, color = GriGreenSuccess, fontWeight = FontWeight.SemiBold)
                }
              }
            }
          }
        }
      }
    }

    // =====================================================================
    // 3. FACULTY ROLE PORTAL
    // =====================================================================
    if (uiState.currentRole == UserRole.FACULTY) {
      item {
        GriSectionHeader(
          title = "Faculty Academic Console",
          subtitle = "Course allocations, CIA marks register, research and invigilation"
        )
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Text("Dr. K. Ramanathan, Ph.D.", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Text("Professor & Head, Dept. of Computer Science & Applications", style = MaterialTheme.typography.bodySmall, color = GriGoldDark, fontWeight = FontWeight.SemiBold)
            Spacer(modifier = Modifier.height(8.dp))
            Text("• Faculty ID: FAC-CS-108 • School of Mathematics & Computer Sciences", style = MaterialTheme.typography.bodySmall)
            Text("• Assigned Courses: ${uiState.courses.size} Active CBCS Courses (Semester IV)", style = MaterialTheme.typography.bodySmall)
            Text("• Research Projects: DST-PURSE Phase II Principal Investigator (₹42 Lakhs)", style = MaterialTheme.typography.bodySmall)
            Spacer(modifier = Modifier.height(12.dp))
            Text("Faculty Electronic Submissions:", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(6.dp))
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              OutlinedButton(
                onClick = { facultyActionMessage = "Continuous Internal Assessment (CIA-2) marks uploaded and synchronized to CoE Portal." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Icon(Icons.Default.Add, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Sync CIA Marks", fontSize = 10.sp)
              }
              OutlinedButton(
                onClick = { facultyActionMessage = "Even Semester 2026 Course File & Lesson Plan submitted to Dean's Office for academic audit." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Icon(Icons.Default.LibraryBooks, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Course File", fontSize = 10.sp)
              }
            }
            Spacer(modifier = Modifier.height(6.dp))
            OutlinedButton(
              onClick = { facultyActionMessage = "Invigilation Schedule acknowledged: CoE ESE Hall 4 (2026-11-24 FN & AN Sessions)." },
              modifier = Modifier.fillMaxWidth(),
              shape = RoundedCornerShape(GriRadius.sm)
            ) {
              Icon(Icons.Default.Assignment, contentDescription = null, modifier = Modifier.size(14.dp))
              Spacer(modifier = Modifier.width(6.dp))
              Text("View CoE Invigilation Roster (ESE Nov 2026)", fontSize = 11.sp)
            }

            facultyActionMessage?.let { msg ->
              Spacer(modifier = Modifier.height(10.dp))
              Surface(
                color = GriGreenSuccess.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.xs),
                modifier = Modifier.fillMaxWidth()
              ) {
                Row(
                  modifier = Modifier.padding(10.dp),
                  verticalAlignment = Alignment.CenterVertically
                ) {
                  Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GriGreenSuccess, modifier = Modifier.size(16.dp))
                  Spacer(modifier = Modifier.width(6.dp))
                  Text(msg, style = MaterialTheme.typography.bodySmall, color = GriGreenSuccess, fontWeight = FontWeight.SemiBold)
                }
              }
            }
          }
        }
      }
    }

    // =====================================================================
    // 4. STUDENT ROLE PORTAL
    // =====================================================================
    if (uiState.currentRole == UserRole.STUDENT) {
      item {
        GriSectionHeader(
          title = "Student Academic Dashboard",
          subtitle = "CBCS curriculum, hall ticket, e-Gov receipts & hostel"
        )
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Column {
                Text("R. Anandhakumar", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Text("23MCAR018 • M.C.A. (CBCS)", style = MaterialTheme.typography.bodySmall, color = GriNavyPrimary, fontWeight = FontWeight.Bold)
              }
              Button(
                onClick = onFetchHallTicket,
                colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(16.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Hall Ticket")
              }
            }

            Spacer(modifier = Modifier.height(10.dp))
            HorizontalDivider()
            Spacer(modifier = Modifier.height(8.dp))
            Text("• Hostel Allotment: Thamarai Illam (Men's Residential Complex), Room 312", style = MaterialTheme.typography.bodySmall)
            Text("• Samarth e-Gov Fee Status: Even Semester Fees Cleared (Receipt #GRI-2026-FE-8812)", style = MaterialTheme.typography.bodySmall)
            Text("• ESE Exam Eligibility: Eligible in all 4 courses (>75% attendance threshold)", style = MaterialTheme.typography.bodySmall, color = GriGreenSuccess, fontWeight = FontWeight.Bold)

            Spacer(modifier = Modifier.height(12.dp))
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              OutlinedButton(
                onClick = { studentActionMessage = "Samarth e-Gov Fee Receipt #GRI-2026-FE-8812 downloaded to device storage." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Icon(Icons.Default.ConfirmationNumber, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Fee Receipt", fontSize = 11.sp)
              }
              OutlinedButton(
                onClick = { studentActionMessage = "Digital Out-Pass for Thamarai Illam generated (Valid until 21:00 hrs today)." },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Icon(Icons.Default.BookmarkBorder, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Hostel Pass", fontSize = 11.sp)
              }
            }

            studentActionMessage?.let { msg ->
              Spacer(modifier = Modifier.height(10.dp))
              Surface(
                color = GriGreenSuccess.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.xs),
                modifier = Modifier.fillMaxWidth()
              ) {
                Row(
                  modifier = Modifier.padding(10.dp),
                  verticalAlignment = Alignment.CenterVertically
                ) {
                  Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GriGreenSuccess, modifier = Modifier.size(16.dp))
                  Spacer(modifier = Modifier.width(6.dp))
                  Text(msg, style = MaterialTheme.typography.bodySmall, color = GriGreenSuccess, fontWeight = FontWeight.SemiBold)
                }
              }
            }
          }
        }
      }
    }

    // =====================================================================
    // 5. GUEST / VISITOR PORTAL
    // =====================================================================
    if (uiState.currentRole == UserRole.GUEST || uiState.currentRole == UserRole.PUBLIC) {
      item {
        GriSectionHeader(
          title = "Visitor & Guest Assistance",
          subtitle = "Campus passes, guest house reservations & navigation"
        )
      }

      item {
        val context = androidx.compose.ui.platform.LocalContext.current
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Text("Welcome to Gandhigram Rural Institute", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Text("Gandhian Rural University founded by Dr. T.S. Soundram & Dr. G. Ramachandran in 1956", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Spacer(modifier = Modifier.height(10.dp))
            Text("• International Guest House: Booking via registrar@ruraluniv.ac.in", style = MaterialTheme.typography.bodySmall)
            Text("• Gandhi Memorial Museum: Open 09:30 AM – 05:30 PM (Daily)", style = MaterialTheme.typography.bodySmall)
            Text("• University Gate Security: +91 451 2452371 Ext 101", style = MaterialTheme.typography.bodySmall)
            Text("• Public Information Officer (RTI Cell): pio@ruraluniv.ac.in", style = MaterialTheme.typography.bodySmall)
            Spacer(modifier = Modifier.height(12.dp))
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              OutlinedButton(
                onClick = {
                  val intent = android.content.Intent(android.content.Intent.ACTION_SENDTO).apply {
                    data = android.net.Uri.parse("mailto:registrar@ruraluniv.ac.in")
                    putExtra(android.content.Intent.EXTRA_SUBJECT, "Guest House Booking Request - Gandhigram Rural Institute")
                  }
                  try {
                    context.startActivity(intent)
                  } catch (_: Exception) {}
                },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Icon(Icons.Default.Hotel, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Book Guest House", fontSize = 11.sp)
              }
              Button(
                onClick = {
                  val intent = android.content.Intent(android.content.Intent.ACTION_DIAL).apply {
                    data = android.net.Uri.parse("tel:04512452371")
                  }
                  try {
                    context.startActivity(intent)
                  } catch (_: Exception) {}
                },
                colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(GriRadius.sm)
              ) {
                Icon(Icons.Default.Call, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Call Security", fontSize = 11.sp)
              }
            }
          }
        }
      }
    }

    // =====================================================================
    // 6. ADMIN ONLY MODULES — 5-STEP CONTENT PUBLISHING & AUDIT STREAM
    // =====================================================================
    if (uiState.currentRole == UserRole.ADMIN) {
      item {
        GriSectionHeader(
          title = "Official Content Publishing Flow (5 Steps)",
          subtitle = "1. Draft -> 2. Review -> 3. Authorization -> 4. Cryptographic Seal -> 5. Publish"
        )
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Text("Official University Order / Notification Flow", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(8.dp))

            // 5-Step Progress Indicators
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp),
              horizontalArrangement = Arrangement.SpaceBetween
            ) {
              listOf("1. Draft", "2. Review", "3. Auth", "4. Seal", "5. Live").forEachIndexed { index, stepName ->
                val stepNum = index + 1
                val isDone = currentPublishStep > stepNum
                val isCurrent = currentPublishStep == stepNum
                Surface(
                  color = if (isCurrent) GriNavyPrimary else if (isDone) GriGreenSuccess else MaterialTheme.colorScheme.surfaceVariant,
                  shape = RoundedCornerShape(GriRadius.xs)
                ) {
                  Text(
                    text = stepName,
                    style = MaterialTheme.typography.labelSmall,
                    color = if (isCurrent || isDone) Color.White else MaterialTheme.colorScheme.onSurfaceVariant,
                    fontWeight = FontWeight.Bold,
                    fontSize = 9.sp,
                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp)
                  )
                }
              }
            }

            Spacer(modifier = Modifier.height(10.dp))

            Text("Category:", style = MaterialTheme.typography.labelSmall)
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .horizontalScroll(rememberScrollState())
                .padding(vertical = 4.dp),
              horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
              noticeCategories.forEach { cat ->
                FilterChip(
                  selected = newNoticeCategory == cat,
                  onClick = { newNoticeCategory = cat },
                  label = { Text(cat, style = MaterialTheme.typography.labelSmall) }
                )
              }
            }

            OutlinedTextField(
              value = newNoticeTitle,
              onValueChange = {
                newNoticeTitle = it
                if (currentPublishStep == 1 && it.isNotBlank()) currentPublishStep = 2
              },
              label = { Text("Title / Official Subject") },
              singleLine = true,
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp)
                .testTag("input_publish_title")
            )

            OutlinedTextField(
              value = newNoticeSummary,
              onValueChange = { newNoticeSummary = it },
              label = { Text("Executive Order Text / Notification Summary") },
              modifier = Modifier
                .fillMaxWidth()
                .height(85.dp)
                .padding(vertical = 4.dp)
                .testTag("input_publish_summary")
            )

            Row(
              verticalAlignment = Alignment.CenterVertically,
              modifier = Modifier.padding(vertical = 4.dp)
            ) {
              androidx.compose.material3.Checkbox(
                checked = newNoticeIsUrgent,
                onCheckedChange = { newNoticeIsUrgent = it }
              )
              Text("Mark as High-Priority / Campus Emergency", style = MaterialTheme.typography.bodySmall)
            }

            // Step 3 & 4 Authorization Box
            Surface(
              color = GriGoldContainer.copy(alpha = 0.35f),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp)
            ) {
              Column(modifier = Modifier.padding(10.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                  androidx.compose.material3.Checkbox(
                    checked = isAuthorizedByRegistrar,
                    onCheckedChange = {
                      isAuthorizedByRegistrar = it
                      if (it) currentPublishStep = 4
                    }
                  )
                  Text(
                    text = "Executive Authorization: Verified & signed by Registrar / CoE Office (Step 3 & 4)",
                    style = MaterialTheme.typography.bodySmall,
                    fontWeight = FontWeight.Bold
                  )
                }
              }
            }

            Spacer(modifier = Modifier.height(10.dp))

            Button(
              onClick = {
                if (newNoticeTitle.isNotBlank() && newNoticeSummary.isNotBlank() && isAuthorizedByRegistrar) {
                  onPublishCircular(
                    newNoticeTitle,
                    newNoticeCategory,
                    newNoticeSummary,
                    newNoticeIsUrgent,
                    "Registrar & Controller of Examinations"
                  )
                  newNoticeTitle = ""
                  newNoticeSummary = ""
                  currentPublishStep = 1
                  isAuthorizedByRegistrar = false
                }
              },
              enabled = newNoticeTitle.isNotBlank() && newNoticeSummary.isNotBlank() && isAuthorizedByRegistrar,
              colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.fillMaxWidth().testTag("btn_publish_circular")
            ) {
              Icon(Icons.Default.Verified, contentDescription = null, modifier = Modifier.size(16.dp))
              Spacer(modifier = Modifier.width(6.dp))
              Text("Step 5: Sign & Publish to All Channels")
            }
          }
        }
      }

      // LIVE PUBLISHING AUDIT LOG
      item {
        GriSectionHeader(
          title = "Official Content Publishing Audit Log",
          subtitle = "Cryptographically recorded authorization events (${uiState.publishingAuditLogs.size} Events)"
        )
      }

      items(uiState.publishingAuditLogs) { entry ->
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 3.dp),
          shape = RoundedCornerShape(GriRadius.xs),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Row(
            modifier = Modifier
              .fillMaxWidth()
              .padding(10.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Column(modifier = Modifier.weight(1f)) {
              Text(
                text = "${entry.status} • ${entry.title}",
                style = MaterialTheme.typography.bodySmall,
                fontWeight = FontWeight.Bold
              )
              Text(
                text = "Operator: ${entry.author} (${entry.authorRole}) • Ref: ${entry.noticeId}",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                fontSize = 10.sp
              )
              Text(
                text = entry.timestamp,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                fontSize = 9.sp
              )
            }
            Surface(
              color = GriGreenSuccess.copy(alpha = 0.12f),
              shape = RoundedCornerShape(GriRadius.xs)
            ) {
              Text(
                text = entry.status,
                style = MaterialTheme.typography.labelSmall,
                color = GriGreenSuccess,
                fontWeight = FontWeight.Bold,
                fontSize = 9.sp,
                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
              )
            }
          }
        }
      }

      // EMERGENCY NOTIFICATION DISPATCH FLOW
      item {
        GriSectionHeader(
          title = "Emergency Notification Broadcast",
          subtitle = "Create -> Select Audience -> Preview -> Confirm & Send"
        )
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Text("Broadcast University Alert", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(10.dp))

            Text("Target Audience:", style = MaterialTheme.typography.labelSmall)
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .horizontalScroll(rememberScrollState())
                .padding(vertical = 4.dp),
              horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
              audiences.forEach { aud ->
                FilterChip(
                  selected = notifAudience == aud,
                  onClick = { notifAudience = aud },
                  label = { Text(aud, style = MaterialTheme.typography.labelSmall) }
                )
              }
            }

            OutlinedTextField(
              value = notifTitle,
              onValueChange = { notifTitle = it },
              label = { Text("Alert Headline") },
              singleLine = true,
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp)
                .testTag("input_notif_title")
            )

            OutlinedTextField(
              value = notifMessage,
              onValueChange = { notifMessage = it },
              label = { Text("Broadcast Message") },
              modifier = Modifier
                .fillMaxWidth()
                .height(80.dp)
                .padding(vertical = 4.dp)
                .testTag("input_notif_message")
            )

            if (showNotifPreview) {
              Surface(
                color = GriRedAlert.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.sm),
                modifier = Modifier
                  .fillMaxWidth()
                  .padding(vertical = 8.dp)
              ) {
                Column(modifier = Modifier.padding(12.dp)) {
                  Text("BROADCAST PREVIEW", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold, color = GriRedAlert)
                  Text("Target: $notifAudience", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
                  Text("Headline: $notifTitle", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
                  Text(notifMessage, style = MaterialTheme.typography.bodySmall)
                }
              }
            }

            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(top = 8.dp),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              OutlinedButton(
                onClick = { showNotifPreview = !showNotifPreview },
                shape = RoundedCornerShape(GriRadius.sm),
                modifier = Modifier.weight(1f)
              ) {
                Text(if (showNotifPreview) "Hide Preview" else "Preview Alert")
              }

              Button(
                onClick = {
                  if (notifTitle.isNotBlank() && notifMessage.isNotBlank()) {
                    onSendNotification(notifTitle, notifMessage, notifAudience)
                    notifTitle = ""
                    notifMessage = ""
                    showNotifPreview = false
                  }
                },
                enabled = notifTitle.isNotBlank() && notifMessage.isNotBlank(),
                colors = ButtonDefaults.buttonColors(containerColor = GriRedAlert),
                shape = RoundedCornerShape(GriRadius.sm),
                modifier = Modifier.weight(1f).testTag("btn_broadcast_alert")
              ) {
                Text("Confirm & Send")
              }
            }
          }
        }
      }

      // INSTITUTIONAL SYNCHRONIZATION & TELEMETRY
      item {
        GriSectionHeader(
          title = "Campus Synchronization & Cloud Integration",
          subtitle = "Secure Institutional Microservices, Offline Cache & Data Bus"
        )
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Default.Sync, contentDescription = null, tint = GriNavyPrimary)
                Spacer(modifier = Modifier.width(8.dp))
                Text("GRI Cloud Data Synchronizer", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
              }
              Surface(
                color = if (uiState.ktorServerStatus.contains("ONLINE")) GriGreenSuccess.copy(alpha = 0.12f) else GriGoldSecondary.copy(alpha = 0.12f),
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(
                  text = if (uiState.ktorServerStatus.contains("ONLINE")) "ACTIVE & SECURE" else "OFFLINE CACHE",
                  style = MaterialTheme.typography.labelSmall,
                  color = if (uiState.ktorServerStatus.contains("ONLINE")) GriGreenSuccess else GriGoldDark,
                  fontWeight = FontWeight.Bold,
                  modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                )
              }
            }

            Spacer(modifier = Modifier.height(10.dp))
            Text("• Synchronization: Encrypted TLS connection with Samarth eGov & e-SANAD", style = MaterialTheme.typography.bodySmall)
            Text("• Security: Role-Based Authorization with Cryptographic Signatures", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
            Text("• Handled Transactions: ${uiState.ktorRequestsCount} verified requests processed", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)

            Spacer(modifier = Modifier.height(14.dp))
            Button(
              onClick = onToggleServer,
              colors = ButtonDefaults.buttonColors(
                containerColor = GriNavyPrimary
              ),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.fillMaxWidth()
            ) {
              Icon(Icons.Default.Sync, contentDescription = null, modifier = Modifier.size(16.dp))
              Spacer(modifier = Modifier.width(6.dp))
              Text("Refresh Institutional Connection Health")
            }
          }
        }
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Icon(Icons.Default.Storage, contentDescription = null, tint = GriGoldSecondary)
              Spacer(modifier = Modifier.width(8.dp))
              Text("Room Database (Local SQLite)", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            }
            Spacer(modifier = Modifier.height(8.dp))
            Text("• Database: gri_portal_database.db", style = MaterialTheme.typography.bodySmall)
            Text("• Entities: Users (6), Courses (${uiState.courses.size}), Tickets (${uiState.grievances.size}), Buses (${uiState.transportRoutes.size}), Circulars (${uiState.circulars.size})", style = MaterialTheme.typography.bodySmall)
            Text("• Flow Queries: Reactive auto-updating StateFlow bindings", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
          }
        }
      }

      item {
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = GriSpacing.lg, vertical = 6.dp),
          shape = RoundedCornerShape(GriRadius.md),
          colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
          border = CardDefaults.outlinedCardBorder()
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Icon(Icons.Default.Sync, contentDescription = null, tint = GriNavyPrimary)
              Spacer(modifier = Modifier.width(8.dp))
              Text("Cloud Persistence (Firestore Sync)", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            }
            Spacer(modifier = Modifier.height(8.dp))
            Text("• Pending Offline Mutations: ${uiState.pendingSyncCount}", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
            Text("• Architecture: Room Write-First with background Sync Queue", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)

            Spacer(modifier = Modifier.height(12.dp))
            Button(
              onClick = onTriggerSync,
              enabled = !uiState.isSyncing,
              colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.fillMaxWidth()
            ) {
              if (uiState.isSyncing) {
                CircularProgressIndicator(color = Color.White, modifier = Modifier.size(16.dp))
                Spacer(modifier = Modifier.width(8.dp))
                Text("Synchronizing Records...")
              } else {
                Text("Trigger Immediate Cloud Sync")
              }
            }
          }
        }
      }
    }
  }
}
