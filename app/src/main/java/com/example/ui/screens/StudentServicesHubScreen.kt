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
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.filled.Apartment
import androidx.compose.material.icons.filled.AttachMoney
import androidx.compose.material.icons.filled.Campaign
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.DirectionsBus
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.ExpandLess
import androidx.compose.material.icons.filled.ExpandMore
import androidx.compose.material.icons.filled.HealthAndSafety
import androidx.compose.material.icons.filled.LocalHospital
import androidx.compose.material.icons.filled.LocalLibrary
import androidx.compose.material.icons.filled.PendingActions
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Work
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
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

data class StudentPortalCardData(
  val id: String,
  val title: String,
  val category: String,
  val subtitle: String,
  val detail1: String,
  val detail2: String,
  val icon: ImageVector,
  val actionLabel: String = "Access"
)

/**
 * Stitch Screen 4: Student Services Hub
 * gandhigram_rural_institute/gri_services_student_hub.html
 */
@Composable
fun StudentServicesHubScreen(
  uiState: GriUiState,
  onSubmitGrievance: (title: String, category: String, desc: String, anonymous: Boolean) -> Unit = { _, _, _, _ -> },
  onResolveGrievance: (String) -> Unit = {},
  onNavigateToDocuments: () -> Unit = {},
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  var activeHubCategory by remember { mutableStateOf(uiState.activeServicesCategory) }
  val categories = listOf("services" to "Services", "admissions" to "Admissions", "campus-life" to "Campus Life", "career-aid" to "Career & Aid")

  var showGrievanceModal by remember { mutableStateOf(false) }
  var grievanceTitle by remember { mutableStateOf("") }
  var grievanceCategory by remember { mutableStateOf("Hostel & Infrastructure") }
  var grievanceDesc by remember { mutableStateOf("") }
  var selectedPortalModal by remember { mutableStateOf<StudentPortalCardData?>(null) }

  val portalCards = listOf(
    StudentPortalCardData(
      id = "library",
      title = "Dr. G. Ramachandran Library",
      category = "Academic Resources",
      subtitle = "1,75,000+ volumes, RFID automated checkout & e-consortia.",
      detail1 = "Active Loan: Rural Energy Systems Vol. 2",
      detail2 = "Due in 2 days • Auto-Renew Enabled",
      icon = Icons.Default.LocalLibrary,
      actionLabel = "OPAC Search"
    ),
    StudentPortalCardData(
      id = "hostel",
      title = "Hostel Life & Mess Management",
      category = "Campus Life",
      subtitle = "Room B-114 • Malligai Illam • Dietary Hall 2",
      detail1 = "Today's Dinner: Chapati, Dhal Tadka & Fruit Salad",
      detail2 = "Gate Outpass QR Verified",
      icon = Icons.Default.Apartment,
      actionLabel = "Mess Rebate"
    ),
    StudentPortalCardData(
      id = "transport",
      title = "Campus Transport System",
      category = "Logistics",
      subtitle = "University bus fleet covering 3 primary regional routes.",
      detail1 = "Live Route: Dindigul Jn <-> Campus",
      detail2 = "Digital Bus Pass: Verified Active",
      icon = Icons.Default.DirectionsBus,
      actionLabel = "Bus Pass"
    ),
    StudentPortalCardData(
      id = "scholarships",
      title = "Scholarships & Grants",
      category = "Financial Aid",
      subtitle = "Central Post-Matric & Gandhian Higher Research fellowship.",
      detail1 = "Post-Matric SC/ST: ₹18,500 Disbursed",
      detail2 = "NSP Verification: Stage 2 Cleared",
      icon = Icons.Default.AttachMoney,
      actionLabel = "Apply Aid"
    ),
    StudentPortalCardData(
      id = "placement",
      title = "Career, Placement & Internships",
      category = "Career Aid",
      subtitle = "Corporate and rural development campus placement cell.",
      detail1 = "14 Active Placement Drives Listed",
      detail2 = "TCS Rural Digital, ICAR Agro, Aavin Dairy",
      icon = Icons.Default.Work,
      actionLabel = "Drives"
    ),
    StudentPortalCardData(
      id = "grievance",
      title = "GRI-Care & Grievance Cell",
      category = "Welfare",
      subtitle = "Direct confidential escalation to Dean of Student Welfare & ICC.",
      detail1 = "Anti-Ragging 24x7 Helpline: 1800-180-5522",
      detail2 = "Internal Complaints Committee (ICC)",
      icon = Icons.Default.Security,
      actionLabel = "Lodge Issue"
    )
  )

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("student_services_screen"),
    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
    verticalArrangement = Arrangement.spacedBy(14.dp)
  ) {

    // 1. TOP HEADER & CATEGORY PILLS
    item {
      Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Column {
          Text("One-Stop Academic ERP", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = GriOutline)
          Text("Student Services Hub", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
        }

        LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
          items(categories) { (key, label) ->
            val isSelected = activeHubCategory == key
            Surface(
              shape = RoundedCornerShape(999.dp),
              color = if (isSelected) GriForestPrimary else GriSurfaceContainerLow,
              modifier = Modifier.clickable { activeHubCategory = key }
            ) {
              Text(
                text = label,
                fontSize = 12.sp,
                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                color = if (isSelected) Color.White else GriOnSurfaceVariant,
                modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp)
              )
            }
          }
        }
      }
    }

    // 2. ADMISSIONS & NEW ENTRANTS BANNER
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("banner_admissions_prospectus"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriForestContainer)
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
                text = "CUET & GRI ENTRANCE 2025",
                fontSize = 9.sp,
                fontWeight = FontWeight.Bold,
                color = GriForestOnFixed,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
              )
            }
            Text("Session 2025-26", fontSize = 11.sp, color = Color.White.copy(alpha = 0.8f))
          }

          Spacer(modifier = Modifier.height(8.dp))
          Text(
            text = "UG, PG & Rural Technology Admissions",
            fontSize = 16.sp,
            fontWeight = FontWeight.Bold,
            color = Color.White
          )
          Text(
            text = "Online registration open for CUET-UG, CUET-PG and Non-CUET Diploma programmes. Check seat matrix and reservation rosters.",
            fontSize = 12.sp,
            color = Color.White.copy(alpha = 0.85f),
            modifier = Modifier.padding(top = 4.dp, bottom = 12.dp)
          )

          Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(
              onClick = {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/admissions/"))
                try { context.startActivity(intent) } catch (_: Exception) {}
              },
              shape = RoundedCornerShape(8.dp),
              colors = ButtonDefaults.buttonColors(containerColor = GriForestFixed, contentColor = GriForestOnFixed),
              contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
            ) {
              Text("Apply Online", fontSize = 11.sp, fontWeight = FontWeight.Bold)
            }

            Button(
              onClick = onNavigateToDocuments,
              shape = RoundedCornerShape(8.dp),
              colors = ButtonDefaults.buttonColors(containerColor = Color.White.copy(alpha = 0.2f), contentColor = Color.White),
              contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
            ) {
              Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(14.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text("Prospectus PDF", fontSize = 11.sp, fontWeight = FontWeight.SemiBold)
            }
          }
        }
      }
    }

    // 3. ACTIVE E-REQUESTS TRACKER
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_e_requests_tracker"),
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
            Text("Active e-Requests & Clearance", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
            Text("2 Active", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
          }

          Spacer(modifier = Modifier.height(10.dp))

          // Request 1: Bonafide
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
                Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(16.dp))
                Spacer(modifier = Modifier.width(8.dp))
                Column {
                  Text("Bonafide Certificate (#REQ-8821)", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
                  Text("Approved & Ready for Download", fontSize = 10.sp, color = GriForestPrimary)
                }
              }
              Icon(Icons.Default.Download, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(18.dp))
            }
          }

          Spacer(modifier = Modifier.height(6.dp))

          // Request 2: Wi-Fi issue
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
                Icon(Icons.Default.PendingActions, contentDescription = null, tint = GriOchreContainer, modifier = Modifier.size(16.dp))
                Spacer(modifier = Modifier.width(8.dp))
                Column {
                  Text("Hostel Wi-Fi Node (#REQ-8904)", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
                  Text("Assigned to Campus Network Team", fontSize = 10.sp, color = GriOutline)
                }
              }
              Text("In Progress", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriOchreContainer)
            }
          }
        }
      }
    }

    // 4. DIGITAL STUDENT DESK (6 PORTALS)
    item {
      Text("Digital Campus Portals", fontSize = 15.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
    }

    items(portalCards) { card ->
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .clickable {
            if (card.id == "grievance") {
              showGrievanceModal = true
            } else {
              selectedPortalModal = card
            }
          }
          .testTag("portal_${card.id}"),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.5.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.Top
          ) {
            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.weight(1f)) {
              Box(
                modifier = Modifier
                  .size(36.dp)
                  .clip(RoundedCornerShape(8.dp))
                  .background(GriSurfaceContainerLow),
                contentAlignment = Alignment.Center
              ) {
                Icon(imageVector = card.icon, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(20.dp))
              }
              Spacer(modifier = Modifier.width(10.dp))
              Column {
                Text(card.title, fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
                Text(card.category, fontSize = 10.sp, color = GriOutline)
              }
            }

            Surface(
              shape = RoundedCornerShape(6.dp),
              color = GriSurfaceContainerLow,
              modifier = Modifier.clickable {
                if (card.id == "grievance") {
                  showGrievanceModal = true
                } else {
                  selectedPortalModal = card
                }
              }
            ) {
              Text(
                text = card.actionLabel,
                fontSize = 11.sp,
                fontWeight = FontWeight.Bold,
                color = GriForestPrimary,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
              )
            }
          }

          Spacer(modifier = Modifier.height(8.dp))
          Text(card.subtitle, fontSize = 11.sp, color = GriOnSurfaceVariant)

          Spacer(modifier = Modifier.height(8.dp))
          Surface(
            shape = RoundedCornerShape(6.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier.fillMaxWidth()
          ) {
            Row(
              modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp),
              horizontalArrangement = Arrangement.SpaceBetween
            ) {
              Text(card.detail1, fontSize = 10.sp, color = GriOnSurface, fontWeight = FontWeight.Medium)
              Text(card.detail2, fontSize = 10.sp, color = GriTealSecondary, fontWeight = FontWeight.Bold)
            }
          }
        }
      }
    }

    // 5. DOWNLOADS & OFFICIAL FORMS
    item {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Text("Statutory Application Forms", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
          Spacer(modifier = Modifier.height(8.dp))

          OfficialFormItem(name = "Semester Fee Concession / EWS Form", code = "Form FA-09", onDownload = onNavigateToDocuments)
          OfficialFormItem(name = "Southern Railway Concession Voucher", code = "Form TR-02", onDownload = onNavigateToDocuments)
          OfficialFormItem(name = "Consolidated No-Dues Clearance Form", code = "Form CL-01", onDownload = onNavigateToDocuments)
        }
      }
    }

    // 6. LODGE GRIEVANCE EXPANDABLE MODAL / SECTION
    if (showGrievanceModal) {
      item {
        Card(
          modifier = Modifier.fillMaxWidth(),
          shape = RoundedCornerShape(14.dp),
          colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
          elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
        ) {
          Column(modifier = Modifier.padding(16.dp)) {
            Text("Lodge Confidential Grievance (GRI-Care)", fontSize = 15.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
            Text("Transmitted directly to Dean of Student Welfare & Internal Complaints Committee.", fontSize = 11.sp, color = GriOnSurfaceVariant)

            Spacer(modifier = Modifier.height(10.dp))

            OutlinedTextField(
              value = grievanceTitle,
              onValueChange = { grievanceTitle = it },
              label = { Text("Issue Title", fontSize = 12.sp) },
              modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(8.dp))

            OutlinedTextField(
              value = grievanceDesc,
              onValueChange = { grievanceDesc = it },
              label = { Text("Detailed Description", fontSize = 12.sp) },
              minLines = 3,
              modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(12.dp))

            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
              Button(
                onClick = {
                  if (grievanceTitle.isNotBlank()) {
                    onSubmitGrievance(grievanceTitle, grievanceCategory, grievanceDesc, false)
                    grievanceTitle = ""
                    grievanceDesc = ""
                    showGrievanceModal = false
                  }
                },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White)
              ) {
                Text("Submit Ticket", fontSize = 12.sp, fontWeight = FontWeight.Bold)
              }

              Button(
                onClick = { showGrievanceModal = false },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = GriSurfaceContainerHigh, contentColor = GriOnSurface)
              ) {
                Text("Cancel", fontSize = 12.sp)
              }
            }
          }
        }
      }
    }
  }

  selectedPortalModal?.let { portal ->
    androidx.compose.material3.AlertDialog(
      onDismissRequest = { selectedPortalModal = null },
      icon = {
        Icon(portal.icon, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(32.dp))
      },
      title = {
        Text(portal.title, fontWeight = FontWeight.Bold, color = GriForestPrimary, fontSize = 16.sp)
      },
      text = {
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
          Text(portal.subtitle, fontSize = 12.sp, color = GriOnSurfaceVariant)
          Surface(
            shape = RoundedCornerShape(8.dp),
            color = GriSurfaceContainerLow,
            modifier = Modifier.fillMaxWidth()
          ) {
            Column(modifier = Modifier.padding(10.dp)) {
              Text(portal.detail1, fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = GriOnSurface)
              Spacer(modifier = Modifier.height(2.dp))
              Text(portal.detail2, fontSize = 10.sp, color = GriTealSecondary, fontWeight = FontWeight.Bold)
            }
          }
          Text(
            text = "Integrated with GRI ERP, RFID & Samarth Gateway.",
            fontSize = 10.sp,
            color = GriOutline
          )
        }
      },
      confirmButton = {
        Button(
          onClick = {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
            try { context.startActivity(intent) } catch (_: Exception) {}
            selectedPortalModal = null
          },
          colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary)
        ) {
          Text(portal.actionLabel, fontSize = 12.sp, fontWeight = FontWeight.Bold)
        }
      },
      dismissButton = {
        androidx.compose.material3.TextButton(onClick = { selectedPortalModal = null }) {
          Text("Close", color = GriOnSurfaceVariant)
        }
      }
    )
  }
}

@Composable
fun OfficialFormItem(name: String, code: String, onDownload: () -> Unit) {
  Row(
    modifier = Modifier
      .fillMaxWidth()
      .padding(vertical = 6.dp),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
  ) {
    Column(modifier = Modifier.weight(1f)) {
      Text(name, fontSize = 12.sp, fontWeight = FontWeight.Medium, color = GriOnSurface)
      Text(code, fontSize = 10.sp, color = GriOutline)
    }

    IconButton(onClick = onDownload, modifier = Modifier.size(32.dp)) {
      Icon(Icons.Default.Download, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(16.dp))
    }
  }
}
