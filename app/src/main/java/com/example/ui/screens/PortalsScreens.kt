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

    // 1. GRI BRANDING HERO BANNER
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
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
          verticalAlignment = Alignment.CenterVertically
        ) {
          Image(
            painter = painterResource(id = R.drawable.ic_gri_seal),
            contentDescription = "Official Seal",
            modifier = Modifier
              .size(60.dp)
              .clip(CircleShape)
              .border(1.5.dp, GriGoldSecondary, CircleShape)
          )

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
            Row(
              modifier = Modifier.padding(top = 4.dp),
              horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
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
                  text = "Nai Talim Heritage (Est. 1956)",
                  style = MaterialTheme.typography.labelSmall,
                  color = GriNavyPrimary,
                  fontWeight = FontWeight.Medium,
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                )
              }
            }
          }
        }
      }
    }

    // 2. SEARCH
    item {
      GriSearchBar(
        query = searchQuery,
        onQueryChange = { searchQuery = it },
        placeholder = "Search circulars, exams, faculty, services..."
      )
    }

    // 3. IMPORTANT NOTICE / ALERT
    item {
      GriNoticeAlert(
        title = "ESE Semester Examination & Admissions 2026",
        message = "Continuous Internal Assessment (CIA) marks frozen. Download verified e-SANAD hall ticket for upcoming exams.",
        isUrgent = true,
        onClick = onFetchHallTicket
      )
    }

    // 4. QUICK SERVICES
    item {
      GriSectionHeader(
        title = "Institutional Services",
        subtitle = "Fast access to essential campus modules"
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp)
      ) {
        QuickServiceButton(
          title = "Hall Ticket",
          icon = Icons.Default.ConfirmationNumber,
          iconTint = GriGoldSecondary,
          onClick = onFetchHallTicket,
          modifier = Modifier.weight(1f)
        )
        QuickServiceButton(
          title = "Attendance",
          icon = Icons.Default.CheckCircle,
          iconTint = GriGreenSuccess,
          onClick = onNavigateToAcademics,
          modifier = Modifier.weight(1f)
        )
        QuickServiceButton(
          title = "Bus Tracker",
          icon = Icons.Default.DirectionsBus,
          iconTint = MaterialTheme.colorScheme.primary,
          onClick = onNavigateToServices,
          modifier = Modifier.weight(1f)
        )
        QuickServiceButton(
          title = "GRI-Care",
          icon = Icons.Default.ReportProblem,
          iconTint = GriRedAlert,
          onClick = onNavigateToGrievances,
          modifier = Modifier.weight(1f)
        )
      }
    }

    // 5. ACADEMICS
    item {
      GriSectionHeader(
        title = "Academic Performance",
        subtitle = "CBCS Curriculum & Course Attendance",
        actionText = "Details",
        onActionClick = onNavigateToAcademics
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .padding(horizontal = GriSpacing.lg, vertical = 4.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp)
      ) {
        val avgAttendance = uiState.courses.map { it.attendancePercent }.average().takeIf { !it.isNaN() }?.toInt() ?: 84
        StatCard(
          title = "Avg Attendance",
          value = "$avgAttendance%",
          subtitle = if (avgAttendance >= 75) "Eligible for ESE (>75%)" else "Condonation Required",
          icon = Icons.Default.CheckCircle,
          iconTint = if (avgAttendance >= 75) GriGreenSuccess else GriRedAlert,
          modifier = Modifier.weight(1f)
        )
        StatCard(
          title = "Active Courses",
          value = "${uiState.courses.size}",
          subtitle = "CBCS Registered Sem 4",
          icon = Icons.Default.Assignment,
          iconTint = MaterialTheme.colorScheme.primary,
          modifier = Modifier.weight(1f)
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
              onClick = {},
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.weight(1f)
            ) {
              Text("Prospectus", style = MaterialTheme.typography.labelMedium)
            }
            Button(
              onClick = {},
              colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.weight(1f)
            ) {
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
          icon = Icons.Default.LibraryBooks,
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
  Row(
    modifier = Modifier.fillMaxWidth(),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
  ) {
    Column(modifier = Modifier.weight(1f)) {
      Text(title, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
      Text(url, style = MaterialTheme.typography.bodySmall, color = GriGoldDark, fontSize = 11.sp)
    }
    Icon(Icons.Default.OpenInNew, contentDescription = null, tint = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.size(16.dp))
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
          Column {
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
        subtitle = "Mark live attendance for lecture periods"
      )
    }

    items(courses) { course ->
      CourseAttendanceCard(
        course = course,
        onMarkAttendance = { onMarkAttendance(course.id) }
      )
    }
  }
}

@Composable
fun CourseAttendanceCard(
  course: CourseEntity,
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
              text = if (isEligible) "Eligible" else "Shortage",
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

        Button(
          onClick = onMarkAttendance,
          colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
          shape = RoundedCornerShape(GriRadius.sm),
          modifier = Modifier.testTag("btn_attend_${course.id}")
        ) {
          Icon(Icons.Default.Add, contentDescription = null, modifier = Modifier.size(16.dp))
          Spacer(modifier = Modifier.width(4.dp))
          Text("Mark Attended (+1)")
        }
      }
    }
  }
}

// =========================================================================
// SERVICES SCREEN
// =========================================================================

@Composable
fun ServicesScreen(
  transportRoutes: List<TransportRouteEntity>,
  modifier: Modifier = Modifier
) {
  var selectedTab by remember { mutableStateOf(0) }
  val tabs = listOf("University Buses", "Hostels", "Central Library")

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("services_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "Campus Facilities & Services",
        subtitle = "Transport Fleet, Residential Hostels & Library Resources"
      )
    }

    item {
      Row(
        modifier = Modifier
          .fillMaxWidth()
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
            ),
            modifier = Modifier.weight(1f)
          )
        }
      }
    }

    when (selectedTab) {
      0 -> {
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
      1 -> {
        item {
          HostelInfoSection()
        }
      }
      2 -> {
        item {
          LibraryInfoSection()
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
      shape = RoundedCornerShape(GriRadius.md),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
      elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
      border = CardDefaults.outlinedCardBorder()
    ) {
      Column(modifier = Modifier.padding(16.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
          Icon(Icons.Default.Hotel, contentDescription = null, tint = GriGoldSecondary)
          Spacer(modifier = Modifier.width(8.dp))
          Text("Residential Hostels & Mess", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        }
        Spacer(modifier = Modifier.height(8.dp))
        Text(
          text = "GRI provides residential complexes with modern dining facilities, high-speed campus Wi-Fi, and solar water heating:",
          style = MaterialTheme.typography.bodySmall
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text("• Thamarai Illam (Men's Hostel) — 450 beds", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
        Text("• Malligai Illam (Women's Hostel) — 500 beds", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
        Text("• Kasturba Research Scholars Hostel — 120 single suites", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
        Text("• Working Women's Hostel — Safe faculty accommodation", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
        Spacer(modifier = Modifier.height(10.dp))
        Text("Chief Warden Office: +91 451 2452371 Ext 310", style = MaterialTheme.typography.labelSmall, color = GriGoldDark)
      }
    }
  }
}

@Composable
fun LibraryInfoSection() {
  Column(modifier = Modifier.padding(horizontal = GriSpacing.lg, vertical = 6.dp)) {
    Card(
      shape = RoundedCornerShape(GriRadius.md),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
      elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
      border = CardDefaults.outlinedCardBorder()
    ) {
      Column(modifier = Modifier.padding(16.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
          Icon(Icons.Default.LibraryBooks, contentDescription = null, tint = GriNavyPrimary)
          Spacer(modifier = Modifier.width(8.dp))
          Text("Dr. Radhakrishnan Central Library", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        }
        Spacer(modifier = Modifier.height(8.dp))
        Text("• Total Print Volumes: 1,75,000+ books, 3,500 rare Gandhian manuscripts", style = MaterialTheme.typography.bodySmall)
        Text("• E-Journals & Consortia: DELNET, e-ShodhSindhu, IEEE Xplore, ScienceDirect", style = MaterialTheme.typography.bodySmall)
        Text("• Automated RFID Book Issue & Return Kiosk", style = MaterialTheme.typography.bodySmall)
        Text("• Library Working Hours: 08:00 AM – 08:00 PM (Monday – Saturday)", style = MaterialTheme.typography.bodySmall)
        Spacer(modifier = Modifier.height(10.dp))
        Button(
          onClick = {},
          colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
          shape = RoundedCornerShape(GriRadius.sm),
          modifier = Modifier.fillMaxWidth()
        ) {
          Text("Open OPAC Web Catalog Search")
        }
      }
    }
  }
}

// =========================================================================
// GRIEVANCES SCREEN (GRI-CARE)
// =========================================================================

@Composable
fun GrievancesScreen(
  grievances: List<GrievanceEntity>,
  userRole: UserRole,
  onSubmitGrievance: (String, String, String) -> Unit,
  onResolveGrievance: (Long, String) -> Unit,
  modifier: Modifier = Modifier
) {
  var showForm by remember { mutableStateOf(false) }
  var category by remember { mutableStateOf("Hostel") }
  var subject by remember { mutableStateOf("") }
  var description by remember { mutableStateOf("") }

  val categories = listOf("Hostel", "Transport", "Academic", "Sanitation", "Infrastructure")

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("grievances_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "GRI-Care Grievance Redressal",
        subtitle = "Direct, transparent portal for student & campus complaints"
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
        Column(modifier = Modifier.padding(14.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Column {
              Text("Grievance Redressal Committee", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
              Text("UGC Regulations compliant anti-harassment cell", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
            Button(
              onClick = { showForm = !showForm },
              colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
              shape = RoundedCornerShape(GriRadius.sm),
              modifier = Modifier.testTag("btn_toggle_grievance_form")
            ) {
              Text(if (showForm) "Close" else "Register")
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
    }

    item {
      GriSectionHeader(
        title = "Ticket History (${grievances.size})",
        subtitle = "Track resolution status in real time"
      )
    }

    items(grievances) { ticket ->
      GrievanceItemCard(
        ticket = ticket,
        isAdmin = userRole == UserRole.ADMIN,
        onResolve = { remarks -> onResolveGrievance(ticket.id, remarks) }
      )
    }
  }
}

@Composable
fun GrievanceItemCard(
  ticket: GrievanceEntity,
  isAdmin: Boolean,
  onResolve: (String) -> Unit
) {
  val statusColor = when (ticket.status) {
    "RESOLVED" -> GriGreenSuccess
    "IN_PROGRESS" -> GriGoldSecondary
    else -> GriRedAlert
  }

  var showResolveInput by remember { mutableStateOf(false) }
  var resolutionRemarks by remember { mutableStateOf("") }

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

      if (isAdmin && ticket.status != "RESOLVED") {
        Spacer(modifier = Modifier.height(8.dp))
        if (!showResolveInput) {
          OutlinedButton(
            onClick = { showResolveInput = true },
            shape = RoundedCornerShape(GriRadius.sm)
          ) {
            Text("Resolve as Admin", style = MaterialTheme.typography.labelMedium)
          }
        } else {
          Column {
            OutlinedTextField(
              value = resolutionRemarks,
              onValueChange = { resolutionRemarks = it },
              label = { Text("Resolution note / action taken") },
              modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(6.dp))
            Button(
              onClick = {
                onResolve(resolutionRemarks.ifBlank { "Action taken by administrative officer" })
                showResolveInput = false
              },
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
// ADMIN CONSOLE SCREEN
// =========================================================================

@Composable
fun AdminScreen(
  uiState: GriUiState,
  onToggleServer: () -> Unit,
  onTriggerSync: () -> Unit,
  modifier: Modifier = Modifier
) {
  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("admin_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "Infrastructure & Server Console",
        subtitle = "Embedded Ktor CIO Engine, Room SQLite & Cloud Queue"
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
              Icon(Icons.Default.Dns, contentDescription = null, tint = GriNavyPrimary)
              Spacer(modifier = Modifier.width(8.dp))
              Text("Embedded Ktor 2.3 Server", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            }
            Surface(
              color = if (uiState.ktorServerStatus.contains("ONLINE")) GriGreenSuccess.copy(alpha = 0.12f) else GriRedAlert.copy(alpha = 0.12f),
              shape = RoundedCornerShape(GriRadius.xs)
            ) {
              Text(
                text = uiState.ktorServerStatus,
                style = MaterialTheme.typography.labelSmall,
                color = if (uiState.ktorServerStatus.contains("ONLINE")) GriGreenSuccess else GriRedAlert,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
              )
            }
          }

          Spacer(modifier = Modifier.height(10.dp))
          Text("• Engine: CIO (Non-blocking Coroutine I/O on 0.0.0.0:${uiState.ktorServerPort})", style = MaterialTheme.typography.bodySmall)
          Text("• Requests Handled: ${uiState.ktorRequestsCount}", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
          Text("• Active Routes: /health, /auth/login, /examinations, /transport, /grievances, /sync", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)

          Spacer(modifier = Modifier.height(14.dp))
          Button(
            onClick = onToggleServer,
            colors = ButtonDefaults.buttonColors(
              containerColor = if (uiState.ktorServerStatus.contains("ONLINE")) GriRedAlert else GriGreenSuccess
            ),
            shape = RoundedCornerShape(GriRadius.sm),
            modifier = Modifier.fillMaxWidth()
          ) {
            Text(if (uiState.ktorServerStatus.contains("ONLINE")) "Stop Ktor Server" else "Start Ktor Server")
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
          Text("• Entities: Users (6), Courses (${uiState.courses.size}), Tickets (${uiState.grievances.size}), Buses (${uiState.transportRoutes.size})", style = MaterialTheme.typography.bodySmall)
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

// =========================================================================
// PUBLIC EXPLORE SCREEN
// =========================================================================

@Composable
fun PublicExploreScreen(modifier: Modifier = Modifier) {
  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .testTag("public_explore_screen"),
    contentPadding = PaddingValues(bottom = 90.dp)
  ) {
    item {
      GriSectionHeader(
        title = "Gandhigram Rural Institute",
        subtitle = "Deemed to be University • Gandhigram, Dindigul, Tamil Nadu"
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
          Row(verticalAlignment = Alignment.CenterVertically) {
            Image(painter = painterResource(id = R.drawable.ic_gri_seal), contentDescription = null, modifier = Modifier.size(36.dp))
            Spacer(modifier = Modifier.width(10.dp))
            Text("Heritage & Gandhian Legacy", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
          }
          Spacer(modifier = Modifier.height(8.dp))
          Text(
            text = "Founded in 1956 by Dr. T.S. Soundram and Dr. G. Ramachandran under the inspiring leadership of Mahatma Gandhi, GRI has dedicated over 70 years to rural higher education, sustainable agro-technologies, and extension.",
            style = MaterialTheme.typography.bodySmall
          )
        }
      }
    }

    item {
      GriSectionHeader(
        title = "Statutory Leadership",
        subtitle = "Ministry of Education, Government of India"
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
          Text("• Chancellor: Shri K.M. Annamalai", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
          Text("• Vice-Chancellor: Prof. Dr. Panch. Ramalingam", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
          Text("• Registrar: Dr. C. Sivapragasam", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
          Text("• Controller of Examinations: Dr. R. Subramanian", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.SemiBold)
        }
      }
    }
  }
}
