package com.example.ui.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AdminPanelSettings
import androidx.compose.material.icons.filled.Assignment
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Error
import androidx.compose.material.icons.filled.HelpOutline
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.HourglassEmpty
import androidx.compose.material.icons.filled.HourglassTop
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Send
import androidx.compose.material.icons.filled.VerifiedUser
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.RadioButton
import androidx.compose.material3.RadioButtonDefaults
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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.example.data.local.AccountStatus
import com.example.data.local.InstitutionalAuditLog
import com.example.data.local.RegistrationApplication
import com.example.data.local.UserEntity
import com.example.data.local.UserRole
import com.example.ui.GriUiState
import com.example.ui.theme.GriError
import com.example.ui.theme.GriErrorContainer
import com.example.ui.theme.GriForestPrimary
import com.example.ui.theme.GriOchreOnContainer
import com.example.ui.theme.GriOnErrorContainer
import com.example.ui.theme.GriOnSurfaceVariant
import com.example.ui.theme.GriOutline
import com.example.ui.theme.GriSuccess
import com.example.ui.theme.GriSuccessContainer
import com.example.ui.theme.GriSurfaceContainerHigh
import com.example.ui.theme.GriSurfaceContainerLowest
import com.example.ui.theme.GriTealSecondary

// =========================================================================
// 1. APPLICATION STATUS SCREEN
// Real-time verification tracker for PENDING, UNDER_REVIEW, REJECTED, SUSPENDED
// =========================================================================

@Composable
fun ApplicationStatusScreen(
  uiState: GriUiState,
  onSubmitClarification: (appId: String, text: String) -> Unit,
  onOpenPortal: () -> Unit = {}
) {
  val currentUser = uiState.currentUser
  val userApp = uiState.applicationsList.find {
    it.userId == currentUser?.id || it.id == currentUser?.applicationId
  } ?: uiState.applicationsList.firstOrNull()

  val status = userApp?.status ?: currentUser?.getAccountStatusEnum() ?: AccountStatus.PENDING_APPROVAL
  var clarificationInput by remember { mutableStateOf("") }

  Column(
    modifier = Modifier
      .fillMaxSize()
      .background(MaterialTheme.colorScheme.surface)
      .verticalScroll(rememberScrollState())
      .padding(16.dp)
      .testTag("screen_application_status")
  ) {
    // Header Banner
    Card(
      modifier = Modifier.fillMaxWidth(),
      shape = RoundedCornerShape(16.dp),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.6f)),
      border = BorderStroke(1.dp, GriForestPrimary.copy(alpha = 0.15f))
    ) {
      Row(
        modifier = Modifier.padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
      ) {
        Box(
          modifier = Modifier
            .size(48.dp)
            .clip(CircleShape)
            .background(
              when (status) {
                AccountStatus.APPROVED -> GriSuccess.copy(alpha = 0.15f)
                AccountStatus.UNDER_REVIEW -> Color(0xFF1E88E5).copy(alpha = 0.15f)
                AccountStatus.REJECTED -> GriError.copy(alpha = 0.15f)
                AccountStatus.SUSPENDED -> Color(0xFFE53935).copy(alpha = 0.15f)
                else -> GriOchreOnContainer.copy(alpha = 0.15f)
              }
            ),
          contentAlignment = Alignment.Center
        ) {
          Icon(
            imageVector = when (status) {
              AccountStatus.APPROVED -> Icons.Default.CheckCircle
              AccountStatus.UNDER_REVIEW -> Icons.Default.HourglassTop
              AccountStatus.REJECTED -> Icons.Default.Error
              AccountStatus.SUSPENDED -> Icons.Default.Lock
              else -> Icons.Default.HourglassEmpty
            },
            contentDescription = null,
            tint = when (status) {
              AccountStatus.APPROVED -> GriSuccess
              AccountStatus.UNDER_REVIEW -> Color(0xFF1E88E5)
              AccountStatus.REJECTED -> GriError
              AccountStatus.SUSPENDED -> Color(0xFFE53935)
              else -> GriOchreOnContainer
            },
            modifier = Modifier.size(26.dp)
          )
        }

        Spacer(modifier = Modifier.width(14.dp))

        Column(modifier = Modifier.weight(1f)) {
          Text(
            text = "Institutional Registration Status",
            style = MaterialTheme.typography.labelMedium,
            color = GriOnSurfaceVariant,
            fontWeight = FontWeight.Medium
          )
          Text(
            text = when (status) {
              AccountStatus.PENDING_APPROVAL -> "Pending Admin Approval"
              AccountStatus.UNDER_REVIEW -> "Application Under Review"
              AccountStatus.APPROVED -> "Account Verified & Approved"
              AccountStatus.REJECTED -> "Application Rejected"
              AccountStatus.SUSPENDED -> "Account Temporarily Suspended"
              AccountStatus.DISABLED -> "Account Disabled"
            },
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold,
            color = when (status) {
              AccountStatus.APPROVED -> GriSuccess
              AccountStatus.UNDER_REVIEW -> Color(0xFF1E88E5)
              AccountStatus.REJECTED, AccountStatus.SUSPENDED -> GriError
              else -> GriOchreOnContainer
            }
          )
          Text(
            text = "Application ID: ${userApp?.id ?: currentUser?.applicationId ?: "APP-2026-9042"}",
            style = MaterialTheme.typography.bodySmall,
            color = GriForestPrimary,
            fontWeight = FontWeight.SemiBold
          )
        }
      }
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Under Review Clarification Box
    if (status == AccountStatus.UNDER_REVIEW) {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = Color(0xFFE3F2FD)),
        border = BorderStroke(1.dp, Color(0xFF90CAF9))
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
              imageVector = Icons.Default.Info,
              contentDescription = null,
              tint = Color(0xFF1565C0),
              modifier = Modifier.size(20.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text(
              text = "Additional Verification Required",
              style = MaterialTheme.typography.titleSmall,
              fontWeight = FontWeight.Bold,
              color = Color(0xFF1565C0)
            )
          }

          Spacer(modifier = Modifier.height(8.dp))
          Text(
            text = userApp?.adminQuery?.ifEmpty {
              currentUser?.adminClarificationQuery ?: "Please provide proof of qualification or certificate registration number."
            } ?: "Please provide proof of qualification.",
            style = MaterialTheme.typography.bodyMedium,
            color = Color(0xFF0D47A1)
          )

          Spacer(modifier = Modifier.height(12.dp))

          OutlinedTextField(
            value = clarificationInput,
            onValueChange = { clarificationInput = it },
            placeholder = { Text("Type your clarification or registration details here...") },
            modifier = Modifier
              .fillMaxWidth()
              .testTag("input_clarification_response"),
            minLines = 3,
            colors = OutlinedTextFieldDefaults.colors(
              focusedBorderColor = Color(0xFF1976D2),
              unfocusedBorderColor = Color(0xFF90CAF9)
            )
          )

          Spacer(modifier = Modifier.height(10.dp))

          Button(
            onClick = {
              if (clarificationInput.isNotBlank()) {
                onSubmitClarification(userApp?.id ?: "APP-2026-8819", clarificationInput)
                clarificationInput = ""
              }
            },
            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF1976D2)),
            modifier = Modifier
              .align(Alignment.End)
              .testTag("btn_submit_clarification")
          ) {
            Icon(Icons.Default.Send, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(6.dp))
            Text("Submit Verification Clarification", fontWeight = FontWeight.Bold)
          }
        }
      }
      Spacer(modifier = Modifier.height(16.dp))
    }

    // Rejection Notice Box
    if (status == AccountStatus.REJECTED) {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriErrorContainer),
        border = BorderStroke(1.dp, GriError.copy(alpha = 0.3f))
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.Error, contentDescription = null, tint = GriError, modifier = Modifier.size(20.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Text(
              text = "Application Rejected by Registrar",
              style = MaterialTheme.typography.titleSmall,
              fontWeight = FontWeight.Bold,
              color = GriOnErrorContainer
            )
          }
          Spacer(modifier = Modifier.height(8.dp))
          Text(
            text = "Reason: ${userApp?.rejectionReason?.ifEmpty { currentUser?.rejectionReason ?: "Eligibility criteria unverified." } ?: "Eligibility criteria unverified."}",
            style = MaterialTheme.typography.bodyMedium,
            color = GriOnErrorContainer
          )
          Spacer(modifier = Modifier.height(12.dp))
          Text(
            text = "You may submit a revised application with correct institutional documentation or reach out to the Registrar's Secretariat.",
            style = MaterialTheme.typography.bodySmall,
            color = GriOnErrorContainer.copy(alpha = 0.8f)
          )
        }
      }
      Spacer(modifier = Modifier.height(16.dp))
    }

    // Approved Success Box
    if (status == AccountStatus.APPROVED) {
      Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSuccessContainer),
        border = BorderStroke(1.dp, GriSuccess.copy(alpha = 0.3f))
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GriSuccess, modifier = Modifier.size(22.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Text(
              text = "Account Approved & Role Activated!",
              style = MaterialTheme.typography.titleSmall,
              fontWeight = FontWeight.Bold,
              color = GriSuccess
            )
          }
          Spacer(modifier = Modifier.height(6.dp))
          Text(
            text = "Your institutional role (${userApp?.requestedRole ?: currentUser?.role}) has been activated with verified CBCS portal access.",
            style = MaterialTheme.typography.bodyMedium,
            color = GriForestPrimary
          )
          Spacer(modifier = Modifier.height(12.dp))
          Button(
            onClick = onOpenPortal,
            colors = ButtonDefaults.buttonColors(containerColor = GriSuccess),
            modifier = Modifier.fillMaxWidth()
          ) {
            Text("Enter GRI Institutional Dashboard", fontWeight = FontWeight.Bold)
          }
        }
      }
      Spacer(modifier = Modifier.height(16.dp))
    }

    // Applicant Dossier Summary
    Card(
      modifier = Modifier.fillMaxWidth(),
      shape = RoundedCornerShape(14.dp),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
      border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
    ) {
      Column(modifier = Modifier.padding(16.dp)) {
        Text(
          text = "Applicant Dossier",
          style = MaterialTheme.typography.titleSmall,
          fontWeight = FontWeight.Bold,
          color = GriForestPrimary
        )
        Spacer(modifier = Modifier.height(10.dp))
        DossierRow("Full Name", userApp?.fullName ?: currentUser?.name ?: "Kavitha Mohan")
        DossierRow("Email", userApp?.email ?: currentUser?.email ?: "kavitha.m26@ruraluniv.ac.in")
        DossierRow("Mobile", userApp?.mobile ?: currentUser?.mobileNumber ?: "9840123456")
        DossierRow("Institutional ID", userApp?.institutionalId ?: currentUser?.rollNo ?: "2026-MA-8821")
        DossierRow("Requested Role", (userApp?.requestedRole?.name ?: currentUser?.requestedRole ?: "STUDENT"))
        DossierRow("Department", userApp?.department ?: currentUser?.department ?: "Department of Rural Development")
        if (!userApp?.programme.isNullOrEmpty()) {
          DossierRow("Programme", userApp!!.programme)
        }
        if (!userApp?.yearSemester.isNullOrEmpty()) {
          DossierRow("Year / Semester", userApp!!.yearSemester)
        }
        DossierRow("Submitted Date", userApp?.submittedDate ?: currentUser?.applicationDate ?: "24 Sep 2026")
      }
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Verification Workflow Timeline
    Card(
      modifier = Modifier.fillMaxWidth(),
      shape = RoundedCornerShape(14.dp),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
      border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
    ) {
      Column(modifier = Modifier.padding(16.dp)) {
        Text(
          text = "Institutional Verification Workflow",
          style = MaterialTheme.typography.titleSmall,
          fontWeight = FontWeight.Bold,
          color = GriForestPrimary
        )
        Spacer(modifier = Modifier.height(14.dp))

        TimelineStepItem(
          stepNo = 1,
          title = "Registration Submitted",
          desc = "Identity credentials & role request recorded",
          isDone = true,
          isActive = false
        )
        TimelineStepItem(
          stepNo = 2,
          title = "Departmental Verification",
          desc = "Academic & service records scrutiny",
          isDone = status == AccountStatus.APPROVED,
          isActive = status == AccountStatus.PENDING_APPROVAL || status == AccountStatus.UNDER_REVIEW
        )
        TimelineStepItem(
          stepNo = 3,
          title = "Administrative Approval",
          desc = "Registrar & CoE authority sign-off",
          isDone = status == AccountStatus.APPROVED,
          isActive = false
        )
        TimelineStepItem(
          stepNo = 4,
          title = "Role Activation & Portal Access",
          desc = "Granular institutional permissions activated",
          isDone = status == AccountStatus.APPROVED,
          isActive = false,
          isLast = true
        )
      }
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Institutional Notice
    Card(
      modifier = Modifier.fillMaxWidth(),
      shape = RoundedCornerShape(12.dp),
      colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f))
    ) {
      Row(
        modifier = Modifier.padding(14.dp),
        verticalAlignment = Alignment.Top
      ) {
        Icon(
          imageVector = Icons.Default.Security,
          contentDescription = null,
          tint = GriForestPrimary,
          modifier = Modifier.size(20.dp)
        )
        Spacer(modifier = Modifier.width(10.dp))
        Text(
          text = "Notice: Privileged student, faculty, and examination services remain strictly gated until formal administrative approval as mandated by GRI Institutional IT Security Policy.",
          style = MaterialTheme.typography.bodySmall,
          color = GriOnSurfaceVariant,
          fontSize = 11.sp
        )
      }
    }
  }
}

@Composable
fun DossierRow(label: String, value: String) {
  Row(
    modifier = Modifier
      .fillMaxWidth()
      .padding(vertical = 4.dp),
    horizontalArrangement = Arrangement.SpaceBetween
  ) {
    Text(text = label, style = MaterialTheme.typography.bodySmall, color = GriOnSurfaceVariant)
    Text(text = value, style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.onSurface)
  }
}

@Composable
fun TimelineStepItem(
  stepNo: Int,
  title: String,
  desc: String,
  isDone: Boolean,
  isActive: Boolean,
  isLast: Boolean = false
) {
  Row(modifier = Modifier.fillMaxWidth()) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
      Box(
        modifier = Modifier
          .size(26.dp)
          .clip(CircleShape)
          .background(
            when {
              isDone -> GriSuccess
              isActive -> GriOchreOnContainer
              else -> MaterialTheme.colorScheme.outlineVariant
            }
          ),
        contentAlignment = Alignment.Center
      ) {
        if (isDone) {
          Icon(Icons.Default.Check, contentDescription = null, tint = Color.White, modifier = Modifier.size(16.dp))
        } else {
          Text(text = "$stepNo", color = Color.White, fontSize = 12.sp, fontWeight = FontWeight.Bold)
        }
      }
      if (!isLast) {
        Box(
          modifier = Modifier
            .width(2.dp)
            .height(28.dp)
            .background(if (isDone) GriSuccess else MaterialTheme.colorScheme.outlineVariant)
        )
      }
    }

    Spacer(modifier = Modifier.width(12.dp))

    Column(modifier = Modifier.padding(bottom = if (!isLast) 12.dp else 0.dp)) {
      Text(
        text = title,
        style = MaterialTheme.typography.bodyMedium,
        fontWeight = if (isActive || isDone) FontWeight.Bold else FontWeight.Normal,
        color = if (isActive) GriOchreOnContainer else MaterialTheme.colorScheme.onSurface
      )
      Text(
        text = desc,
        style = MaterialTheme.typography.bodySmall,
        color = GriOnSurfaceVariant,
        fontSize = 11.sp
      )
    }
  }
}

// =========================================================================
// 2. ADMIN REGISTRATION & ROLE APPROVAL CENTER
// Full management queue for pending, under-review, approved, rejected
// =========================================================================

@Composable
fun AdminApprovalCenterScreen(
  uiState: GriUiState,
  onOpenReview: (RegistrationApplication) -> Unit,
  onFilterChange: (String) -> Unit,
  onSearchChange: (String) -> Unit
) {
  var activeTab by remember { mutableStateOf("QUEUE") } // "QUEUE" or "AUDIT"

  val pendingCount = uiState.applicationsList.count { it.status == AccountStatus.PENDING_APPROVAL }
  val reviewCount = uiState.applicationsList.count { it.status == AccountStatus.UNDER_REVIEW }
  val approvedCount = uiState.applicationsList.count { it.status == AccountStatus.APPROVED }
  val rejectedCount = uiState.applicationsList.count { it.status == AccountStatus.REJECTED }

  val filteredApps = uiState.applicationsList.filter { app ->
    val matchesFilter = when (uiState.applicationFilter) {
      "PENDING" -> app.status == AccountStatus.PENDING_APPROVAL
      "UNDER_REVIEW" -> app.status == AccountStatus.UNDER_REVIEW
      "APPROVED" -> app.status == AccountStatus.APPROVED
      "REJECTED" -> app.status == AccountStatus.REJECTED
      else -> true
    }
    val q = uiState.applicationSearchQuery.trim().lowercase()
    val matchesQuery = q.isEmpty() ||
      app.fullName.lowercase().contains(q) ||
      app.email.lowercase().contains(q) ||
      app.institutionalId.lowercase().contains(q) ||
      app.id.lowercase().contains(q) ||
      app.department.lowercase().contains(q)

    matchesFilter && matchesQuery
  }

  Column(
    modifier = Modifier
      .fillMaxSize()
      .background(MaterialTheme.colorScheme.surface)
      .padding(16.dp)
      .testTag("screen_admin_approval_center")
  ) {
    // Header
    Row(
      modifier = Modifier.fillMaxWidth(),
      horizontalArrangement = Arrangement.SpaceBetween,
      verticalAlignment = Alignment.CenterVertically
    ) {
      Column {
        Text(
          text = "Approval & Governance Center",
          style = MaterialTheme.typography.titleLarge,
          fontWeight = FontWeight.Bold,
          color = GriForestPrimary
        )
        Text(
          text = "Registrar & Statutory Role Assignment Directorate",
          style = MaterialTheme.typography.bodySmall,
          color = GriOnSurfaceVariant
        )
      }

      Surface(
        shape = RoundedCornerShape(8.dp),
        color = GriForestPrimary.copy(alpha = 0.12f)
      ) {
        Row(
          modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
          verticalAlignment = Alignment.CenterVertically
        ) {
          Icon(Icons.Default.VerifiedUser, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(16.dp))
          Spacer(modifier = Modifier.width(4.dp))
          Text("Admin Gated", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.Bold, color = GriForestPrimary)
        }
      }
    }

    Spacer(modifier = Modifier.height(14.dp))

    // Summary Metric Cards
    Row(
      modifier = Modifier.fillMaxWidth(),
      horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
      StatSummaryCard("Pending", pendingCount, GriOchreOnContainer, Modifier.weight(1f)) { onFilterChange("PENDING") }
      StatSummaryCard("In Review", reviewCount, Color(0xFF1E88E5), Modifier.weight(1f)) { onFilterChange("UNDER_REVIEW") }
      StatSummaryCard("Approved", approvedCount, GriSuccess, Modifier.weight(1f)) { onFilterChange("APPROVED") }
      StatSummaryCard("Rejected", rejectedCount, GriError, Modifier.weight(1f)) { onFilterChange("REJECTED") }
    }

    Spacer(modifier = Modifier.height(14.dp))

    // Search Box
    OutlinedTextField(
      value = uiState.applicationSearchQuery,
      onValueChange = onSearchChange,
      placeholder = { Text("Search by name, email, register no, or App ID...") },
      leadingIcon = { Icon(Icons.Default.Search, contentDescription = null, tint = GriOutline) },
      trailingIcon = {
        if (uiState.applicationSearchQuery.isNotEmpty()) {
          IconButton(onClick = { onSearchChange("") }) {
            Icon(Icons.Default.Close, contentDescription = "Clear")
          }
        }
      },
      singleLine = true,
      modifier = Modifier
        .fillMaxWidth()
        .testTag("input_admin_approval_search"),
      colors = OutlinedTextFieldDefaults.colors(
        focusedBorderColor = GriForestPrimary,
        unfocusedBorderColor = MaterialTheme.colorScheme.outlineVariant
      )
    )

    Spacer(modifier = Modifier.height(10.dp))

    // Filter Chips
    LazyRow(
      modifier = Modifier.fillMaxWidth(),
      horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
      item {
        FilterChip(
          selected = uiState.applicationFilter == "ALL",
          onClick = { onFilterChange("ALL") },
          label = { Text("All (${uiState.applicationsList.size})") }
        )
      }
      item {
        FilterChip(
          selected = uiState.applicationFilter == "PENDING",
          onClick = { onFilterChange("PENDING") },
          label = { Text("Pending ($pendingCount)") }
        )
      }
      item {
        FilterChip(
          selected = uiState.applicationFilter == "UNDER_REVIEW",
          onClick = { onFilterChange("UNDER_REVIEW") },
          label = { Text("Under Review ($reviewCount)") }
        )
      }
      item {
        FilterChip(
          selected = uiState.applicationFilter == "APPROVED",
          onClick = { onFilterChange("APPROVED") },
          label = { Text("Approved ($approvedCount)") }
        )
      }
      item {
        FilterChip(
          selected = uiState.applicationFilter == "REJECTED",
          onClick = { onFilterChange("REJECTED") },
          label = { Text("Rejected ($rejectedCount)") }
        )
      }
    }

    Spacer(modifier = Modifier.height(12.dp))

    // Tab Toggle: Applications Queue vs Institutional Audit Trail
    Row(modifier = Modifier.fillMaxWidth()) {
      OutlinedButton(
        onClick = { activeTab = "QUEUE" },
        colors = ButtonDefaults.outlinedButtonColors(
          containerColor = if (activeTab == "QUEUE") GriForestPrimary.copy(alpha = 0.12f) else Color.Transparent
        ),
        modifier = Modifier.weight(1f)
      ) {
        Icon(Icons.Default.Assignment, contentDescription = null, modifier = Modifier.size(16.dp))
        Spacer(modifier = Modifier.width(6.dp))
        Text("Applications Queue", fontWeight = FontWeight.Bold)
      }

      Spacer(modifier = Modifier.width(8.dp))

      OutlinedButton(
        onClick = { activeTab = "AUDIT" },
        colors = ButtonDefaults.outlinedButtonColors(
          containerColor = if (activeTab == "AUDIT") GriForestPrimary.copy(alpha = 0.12f) else Color.Transparent
        ),
        modifier = Modifier.weight(1f)
      ) {
        Icon(Icons.Default.History, contentDescription = null, modifier = Modifier.size(16.dp))
        Spacer(modifier = Modifier.width(6.dp))
        Text("Audit Trail", fontWeight = FontWeight.Bold)
      }
    }

    Spacer(modifier = Modifier.height(12.dp))

    if (activeTab == "QUEUE") {
      // Applications List
      if (filteredApps.isEmpty()) {
        Box(
          modifier = Modifier
            .fillMaxWidth()
            .weight(1f),
          contentAlignment = Alignment.Center
        ) {
          Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Icon(Icons.Default.HourglassEmpty, contentDescription = null, tint = GriOutline, modifier = Modifier.size(42.dp))
            Spacer(modifier = Modifier.height(8.dp))
            Text("No applications matching the selected criteria.", color = GriOnSurfaceVariant)
          }
        }
      } else {
        LazyColumn(
          modifier = Modifier.weight(1f),
          verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
          items(filteredApps) { app ->
            ApplicantQueueCard(
              app = app,
              onReviewClick = { onOpenReview(app) }
            )
          }
        }
      }
    } else {
      // Audit Trail List
      LazyColumn(
        modifier = Modifier.weight(1f),
        verticalArrangement = Arrangement.spacedBy(8.dp)
      ) {
        items(uiState.institutionalAuditTrail) { audit ->
          AuditLogItemCard(audit)
        }
      }
    }
  }
}

@Composable
fun StatSummaryCard(
  title: String,
  count: Int,
  color: Color,
  modifier: Modifier = Modifier,
  onClick: () -> Unit = {}
) {
  Card(
    modifier = modifier.clickable(onClick = onClick),
    shape = RoundedCornerShape(12.dp),
    colors = CardDefaults.cardColors(containerColor = color.copy(alpha = 0.10f)),
    border = BorderStroke(1.dp, color.copy(alpha = 0.25f))
  ) {
    Column(
      modifier = Modifier.padding(10.dp),
      horizontalAlignment = Alignment.CenterHorizontally
    ) {
      Text(text = "$count", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = color)
      Text(text = title, fontSize = 10.sp, fontWeight = FontWeight.Medium, color = MaterialTheme.colorScheme.onSurface)
    }
  }
}

@Composable
fun ApplicantQueueCard(
  app: RegistrationApplication,
  onReviewClick: () -> Unit
) {
  Card(
    modifier = Modifier.fillMaxWidth(),
    shape = RoundedCornerShape(14.dp),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
  ) {
    Column(modifier = Modifier.padding(14.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
          Surface(
            shape = CircleShape,
            color = GriForestPrimary.copy(alpha = 0.12f),
            modifier = Modifier.size(36.dp)
          ) {
            Box(contentAlignment = Alignment.Center) {
              Text(
                text = app.fullName.take(2).uppercase(),
                fontWeight = FontWeight.Bold,
                color = GriForestPrimary,
                fontSize = 12.sp
              )
            }
          }

          Spacer(modifier = Modifier.width(10.dp))

          Column {
            Text(
              text = app.fullName,
              style = MaterialTheme.typography.titleMedium,
              fontWeight = FontWeight.Bold,
              fontSize = 15.sp
            )
            Text(
              text = "${app.institutionalId} • ${app.department}",
              style = MaterialTheme.typography.bodySmall,
              color = GriOnSurfaceVariant,
              fontSize = 11.sp
            )
          }
        }

        // Status Badge
        Surface(
          shape = RoundedCornerShape(999.dp),
          color = when (app.status) {
            AccountStatus.APPROVED -> GriSuccess.copy(alpha = 0.15f)
            AccountStatus.UNDER_REVIEW -> Color(0xFF1E88E5).copy(alpha = 0.15f)
            AccountStatus.REJECTED -> GriError.copy(alpha = 0.15f)
            else -> GriOchreOnContainer.copy(alpha = 0.15f)
          }
        ) {
          Text(
            text = app.status.name.replace("_", " "),
            style = MaterialTheme.typography.labelSmall,
            fontWeight = FontWeight.Bold,
            color = when (app.status) {
              AccountStatus.APPROVED -> GriSuccess
              AccountStatus.UNDER_REVIEW -> Color(0xFF1E88E5)
              AccountStatus.REJECTED -> GriError
              else -> GriOchreOnContainer
            },
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp),
            fontSize = 9.sp
          )
        }
      }

      Spacer(modifier = Modifier.height(10.dp))
      HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f))
      Spacer(modifier = Modifier.height(8.dp))

      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Column {
          Text(
            text = "Requested Role: ${app.requestedRole.name}",
            style = MaterialTheme.typography.bodySmall,
            fontWeight = FontWeight.SemiBold,
            color = GriForestPrimary
          )
          Text(
            text = "Submitted: ${app.submittedDate}",
            style = MaterialTheme.typography.labelSmall,
            color = GriOnSurfaceVariant,
            fontSize = 10.sp
          )
        }

        Button(
          onClick = onReviewClick,
          colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary),
          shape = RoundedCornerShape(8.dp),
          contentPadding = androidx.compose.foundation.layout.PaddingValues(horizontal = 12.dp, vertical = 6.dp),
          modifier = Modifier.testTag("btn_review_dossier_${app.id}")
        ) {
          Text("Review Dossier", fontSize = 12.sp, fontWeight = FontWeight.Bold)
        }
      }
    }
  }
}

@Composable
fun AuditLogItemCard(audit: InstitutionalAuditLog) {
  Card(
    modifier = Modifier.fillMaxWidth(),
    shape = RoundedCornerShape(10.dp),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f)),
    border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f))
  ) {
    Column(modifier = Modifier.padding(12.dp)) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Text(
          text = audit.action.replace("_", " "),
          style = MaterialTheme.typography.labelSmall,
          fontWeight = FontWeight.Bold,
          color = GriForestPrimary
        )
        Text(
          text = audit.timestamp,
          style = MaterialTheme.typography.labelSmall,
          color = GriOnSurfaceVariant,
          fontSize = 10.sp
        )
      }

      Spacer(modifier = Modifier.height(4.dp))

      Text(
        text = "Target: ${audit.targetUser} (${audit.targetRole}) • By: ${audit.adminName}",
        style = MaterialTheme.typography.bodySmall,
        fontWeight = FontWeight.Medium
      )

      if (audit.reasonOrNotes.isNotEmpty()) {
        Text(
          text = "Note: ${audit.reasonOrNotes}",
          style = MaterialTheme.typography.bodySmall,
          color = GriOnSurfaceVariant,
          fontSize = 11.sp
        )
      }
    }
  }
}

// =========================================================================
// 3. ADMIN REVIEW DOSSIER DIALOG (Approve, Reject, Request Info)
// =========================================================================

@Composable
fun AdminReviewDialog(
  app: RegistrationApplication,
  onDismiss: () -> Unit,
  onApprove: () -> Unit,
  onReject: (reason: String) -> Unit,
  onRequestInfo: (query: String) -> Unit
) {
  var showRejectDialog by remember { mutableStateOf(false) }
  var showRequestInfoDialog by remember { mutableStateOf(false) }
  var rejectionReasonText by remember { mutableStateOf("") }
  var requestInfoQueryText by remember { mutableStateOf("") }

  Dialog(
    onDismissRequest = onDismiss,
    properties = DialogProperties(usePlatformDefaultWidth = false)
  ) {
    Surface(
      shape = RoundedCornerShape(18.dp),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 8.dp,
      modifier = Modifier
        .fillMaxWidth(0.94f)
        .padding(vertical = 20.dp)
        .testTag("dialog_admin_review_dossier")
    ) {
      Column(
        modifier = Modifier
          .fillMaxWidth()
          .verticalScroll(rememberScrollState())
          .padding(20.dp)
      ) {
        // Dialog Title
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Column {
            Text(
              text = "Application Review Dossier",
              style = MaterialTheme.typography.titleMedium,
              fontWeight = FontWeight.Bold,
              color = GriForestPrimary
            )
            Text(
              text = "Application ID: ${app.id}",
              style = MaterialTheme.typography.bodySmall,
              color = GriOnSurfaceVariant
            )
          }

          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close")
          }
        }

        Spacer(modifier = Modifier.height(14.dp))
        HorizontalDivider()
        Spacer(modifier = Modifier.height(14.dp))

        // Profile Fields
        DossierRow("Full Name", app.fullName)
        DossierRow("Email", app.email)
        DossierRow("Mobile", app.mobile)
        DossierRow("Institutional ID", app.institutionalId)
        DossierRow("Requested Role", app.requestedRole.name)
        DossierRow("Department", app.department)
        if (app.programme.isNotEmpty()) DossierRow("Programme", app.programme)
        if (app.yearSemester.isNotEmpty()) DossierRow("Year / Sem", app.yearSemester)
        if (app.designation.isNotEmpty()) DossierRow("Designation", app.designation)
        if (app.researchTopic.isNotEmpty()) DossierRow("Research Focus", app.researchTopic)
        DossierRow("Current Status", app.status.name)
        DossierRow("Submitted Date", app.submittedDate)

        if (app.applicantResponse.isNotEmpty()) {
          Spacer(modifier = Modifier.height(10.dp))
          Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = Color(0xFFE8F5E9)),
            border = BorderStroke(1.dp, GriSuccess.copy(alpha = 0.3f))
          ) {
            Column(modifier = Modifier.padding(10.dp)) {
              Text("Applicant Clarification Provided:", fontWeight = FontWeight.Bold, fontSize = 11.sp, color = GriSuccess)
              Text(app.applicantResponse, fontSize = 12.sp, color = GriForestPrimary)
            }
          }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // History Log
        Text(text = "Application Audit Trail", style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.Bold, color = GriForestPrimary)
        Spacer(modifier = Modifier.height(6.dp))
        app.history.forEach { h ->
          Row(modifier = Modifier.padding(vertical = 2.dp)) {
            Text("• ${h.timestamp} - ${h.details}", fontSize = 11.sp, color = GriOnSurfaceVariant)
          }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Action Buttons
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
          Button(
            onClick = onApprove,
            colors = ButtonDefaults.buttonColors(containerColor = GriSuccess),
            modifier = Modifier
              .weight(1f)
              .testTag("btn_modal_approve")
          ) {
            Icon(Icons.Default.Check, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text("Approve", fontWeight = FontWeight.Bold)
          }

          OutlinedButton(
            onClick = { showRequestInfoDialog = true },
            modifier = Modifier
              .weight(1f)
              .testTag("btn_modal_request_info")
          ) {
            Text("Query", fontWeight = FontWeight.Bold)
          }

          Button(
            onClick = { showRejectDialog = true },
            colors = ButtonDefaults.buttonColors(containerColor = GriError),
            modifier = Modifier
              .weight(1f)
              .testTag("btn_modal_reject")
          ) {
            Text("Reject", fontWeight = FontWeight.Bold)
          }
        }
      }
    }
  }

  // Reject Reason Prompt Dialog
  if (showRejectDialog) {
    Dialog(onDismissRequest = { showRejectDialog = false }) {
      Surface(
        shape = RoundedCornerShape(14.dp),
        color = MaterialTheme.colorScheme.surface,
        modifier = Modifier.padding(16.dp)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Text("Reject Application", fontWeight = FontWeight.Bold, color = GriError)
          Spacer(modifier = Modifier.height(8.dp))
          Text("Please provide an institutional reason for rejection (mandatory):", fontSize = 12.sp)
          Spacer(modifier = Modifier.height(8.dp))
          OutlinedTextField(
            value = rejectionReasonText,
            onValueChange = { rejectionReasonText = it },
            placeholder = { Text("Reason for rejection...") },
            minLines = 3,
            modifier = Modifier.fillMaxWidth()
          )
          Spacer(modifier = Modifier.height(14.dp))
          Row(horizontalArrangement = Arrangement.End, modifier = Modifier.fillMaxWidth()) {
            TextButton(onClick = { showRejectDialog = false }) { Text("Cancel") }
            Spacer(modifier = Modifier.width(8.dp))
            Button(
              onClick = {
                if (rejectionReasonText.isNotBlank()) {
                  onReject(rejectionReasonText)
                  showRejectDialog = false
                }
              },
              colors = ButtonDefaults.buttonColors(containerColor = GriError)
            ) {
              Text("Confirm Rejection")
            }
          }
        }
      }
    }
  }

  // Request Information Prompt Dialog
  if (showRequestInfoDialog) {
    Dialog(onDismissRequest = { showRequestInfoDialog = false }) {
      Surface(
        shape = RoundedCornerShape(14.dp),
        color = MaterialTheme.colorScheme.surface,
        modifier = Modifier.padding(16.dp)
      ) {
        Column(modifier = Modifier.padding(16.dp)) {
          Text("Request Additional Information", fontWeight = FontWeight.Bold, color = Color(0xFF1565C0))
          Spacer(modifier = Modifier.height(8.dp))
          Text("Enter the specific clarification required from the applicant:", fontSize = 12.sp)
          Spacer(modifier = Modifier.height(8.dp))
          OutlinedTextField(
            value = requestInfoQueryText,
            onValueChange = { requestInfoQueryText = it },
            placeholder = { Text("e.g. Please provide provisional certificate register number...") },
            minLines = 3,
            modifier = Modifier.fillMaxWidth()
          )
          Spacer(modifier = Modifier.height(14.dp))
          Row(horizontalArrangement = Arrangement.End, modifier = Modifier.fillMaxWidth()) {
            TextButton(onClick = { showRequestInfoDialog = false }) { Text("Cancel") }
            Spacer(modifier = Modifier.width(8.dp))
            Button(
              onClick = {
                if (requestInfoQueryText.isNotBlank()) {
                  onRequestInfo(requestInfoQueryText)
                  showRequestInfoDialog = false
                }
              },
              colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF1565C0))
            ) {
              Text("Send Request")
            }
          }
        }
      }
    }
  }
}

// =========================================================================
// 4. REGISTRATION WIZARD DIALOG (3-Step Wizard)
// Step 1: Identity -> Step 2: Role Selection -> Step 3: Institutional Details
// =========================================================================

@Composable
fun RegistrationWizardDialog(
  onDismiss: () -> Unit,
  onSubmit: (
    fullName: String,
    email: String,
    mobile: String,
    institutionalId: String,
    requestedRole: UserRole,
    department: String,
    programme: String,
    yearSemester: String,
    designation: String,
    researchTopic: String
  ) -> Unit
) {
  var currentStep by remember { mutableStateOf(1) }

  // Step 1 Fields
  var fullName by remember { mutableStateOf("") }
  var email by remember { mutableStateOf("") }
  var mobile by remember { mutableStateOf("") }
  var instId by remember { mutableStateOf("") }
  var password by remember { mutableStateOf("") }
  var confirmPassword by remember { mutableStateOf("") }

  // Step 2 Fields
  var selectedRole by remember { mutableStateOf(UserRole.STUDENT) }

  // Step 3 Fields
  var department by remember { mutableStateOf("Computer Science & Applications") }
  var programme by remember { mutableStateOf("M.Sc. Computer Science") }
  var yearSemester by remember { mutableStateOf("1st Year / Semester I") }
  var designation by remember { mutableStateOf("Assistant Professor") }
  var researchTopic by remember { mutableStateOf("Rural Sustainable Informatics") }
  var agreedToDeclaration by remember { mutableStateOf(false) }

  var validationError by remember { mutableStateOf<String?>(null) }

  Dialog(
    onDismissRequest = onDismiss,
    properties = DialogProperties(usePlatformDefaultWidth = false)
  ) {
    Surface(
      shape = RoundedCornerShape(18.dp),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 8.dp,
      modifier = Modifier
        .fillMaxWidth(0.94f)
        .padding(vertical = 20.dp)
        .testTag("dialog_registration_wizard")
    ) {
      Column(
        modifier = Modifier
          .fillMaxWidth()
          .verticalScroll(rememberScrollState())
          .padding(20.dp)
      ) {
        // Header
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Column {
            Text(
              text = "Create Institutional Account",
              style = MaterialTheme.typography.titleMedium,
              fontWeight = FontWeight.Bold,
              color = GriForestPrimary
            )
            Text(
              text = "Step $currentStep of 3 • " + when (currentStep) {
                1 -> "Identity Credentials"
                2 -> "Account Type Selection"
                else -> "Institutional Details"
              },
              style = MaterialTheme.typography.bodySmall,
              color = GriOnSurfaceVariant
            )
          }

          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close")
          }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Step Tracker Dots
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.Center
        ) {
          listOf(1, 2, 3).forEach { step ->
            Box(
              modifier = Modifier
                .size(if (currentStep == step) 24.dp else 18.dp)
                .clip(CircleShape)
                .background(if (step <= currentStep) GriForestPrimary else MaterialTheme.colorScheme.outlineVariant),
              contentAlignment = Alignment.Center
            ) {
              Text(
                text = "$step",
                color = Color.White,
                fontSize = if (currentStep == step) 11.sp else 9.sp,
                fontWeight = FontWeight.Bold
              )
            }
            if (step < 3) {
              Box(
                modifier = Modifier
                  .width(36.dp)
                  .height(3.dp)
                  .align(Alignment.CenterVertically)
                  .background(if (step < currentStep) GriForestPrimary else MaterialTheme.colorScheme.outlineVariant)
              )
            }
          }
        }

        Spacer(modifier = Modifier.height(16.dp))

        validationError?.let { err ->
          Text(text = err, color = GriError, style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
          Spacer(modifier = Modifier.height(8.dp))
        }

        // STEP 1: IDENTITY
        if (currentStep == 1) {
          OutlinedTextField(
            value = fullName,
            onValueChange = { fullName = it },
            label = { Text("Full Name (as in institutional records)") },
            modifier = Modifier.fillMaxWidth().testTag("reg_fullName"),
            singleLine = true
          )
          Spacer(modifier = Modifier.height(10.dp))

          OutlinedTextField(
            value = email,
            onValueChange = { email = it },
            label = { Text("Institutional / Personal Email") },
            modifier = Modifier.fillMaxWidth().testTag("reg_email"),
            singleLine = true
          )
          Spacer(modifier = Modifier.height(10.dp))

          OutlinedTextField(
            value = mobile,
            onValueChange = { mobile = it },
            label = { Text("Mobile Number") },
            modifier = Modifier.fillMaxWidth().testTag("reg_mobile"),
            singleLine = true
          )
          Spacer(modifier = Modifier.height(10.dp))

          OutlinedTextField(
            value = instId,
            onValueChange = { instId = it },
            label = { Text("Institutional ID / Roll / Emp / App No") },
            modifier = Modifier.fillMaxWidth().testTag("reg_instId"),
            singleLine = true
          )
          Spacer(modifier = Modifier.height(10.dp))

          OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Password") },
            modifier = Modifier.fillMaxWidth().testTag("reg_password"),
            singleLine = true
          )
          Spacer(modifier = Modifier.height(10.dp))

          OutlinedTextField(
            value = confirmPassword,
            onValueChange = { confirmPassword = it },
            label = { Text("Confirm Password") },
            modifier = Modifier.fillMaxWidth().testTag("reg_confirmPassword"),
            singleLine = true
          )

          Spacer(modifier = Modifier.height(18.dp))

          Button(
            onClick = {
              if (fullName.isBlank() || email.isBlank() || mobile.isBlank()) {
                validationError = "Please fill in all mandatory identity fields."
              } else {
                validationError = null
                currentStep = 2
              }
            },
            colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary),
            modifier = Modifier.fillMaxWidth().testTag("btn_step1_next")
          ) {
            Text("Next: Select Account Role", fontWeight = FontWeight.Bold)
          }
        }

        // STEP 2: ACCOUNT TYPE
        if (currentStep == 2) {
          Text(
            text = "Select Requested Institutional Role:",
            style = MaterialTheme.typography.titleSmall,
            fontWeight = FontWeight.Bold,
            color = GriForestPrimary
          )
          Text(
            text = "Note: Admin roles cannot be requested directly and require administrator-controlled assignment.",
            style = MaterialTheme.typography.bodySmall,
            color = GriOnSurfaceVariant,
            fontSize = 11.sp
          )

          Spacer(modifier = Modifier.height(12.dp))

          val allowedRoles = listOf(
            UserRole.STUDENT to "Student (Degree, CBCS, Examinations, Hall Tickets)",
            UserRole.FACULTY to "Faculty (Teaching, Attendance, Marks, Academic Duty)",
            UserRole.COE_STAFF to "CoE Staff (Controller of Examinations Directorate)",
            UserRole.SCHOLAR to "Research Scholar (Doctoral Fellow, JRF/SRF)",
            UserRole.GUEST to "Guest (Public visitor, Prospective student)"
          )

          allowedRoles.forEach { (role, desc) ->
            Card(
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp)
                .clickable { selectedRole = role },
              shape = RoundedCornerShape(10.dp),
              colors = CardDefaults.cardColors(
                containerColor = if (selectedRole == role) GriForestPrimary.copy(alpha = 0.12f) else MaterialTheme.colorScheme.surface
              ),
              border = BorderStroke(
                if (selectedRole == role) 2.dp else 1.dp,
                if (selectedRole == role) GriForestPrimary else MaterialTheme.colorScheme.outlineVariant
              )
            ) {
              Row(
                modifier = Modifier.padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
              ) {
                RadioButton(
                  selected = selectedRole == role,
                  onClick = { selectedRole = role },
                  colors = RadioButtonDefaults.colors(selectedColor = GriForestPrimary)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Column {
                  Text(text = role.name, fontWeight = FontWeight.Bold, color = GriForestPrimary)
                  Text(text = desc, fontSize = 11.sp, color = GriOnSurfaceVariant)
                }
              }
            }
          }

          Spacer(modifier = Modifier.height(16.dp))

          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            OutlinedButton(onClick = { currentStep = 1 }) { Text("Back") }
            Button(
              onClick = { currentStep = 3 },
              colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary),
              modifier = Modifier.testTag("btn_step2_next")
            ) {
              Text("Next: Institutional Details", fontWeight = FontWeight.Bold)
            }
          }
        }

        // STEP 3: DYNAMIC INSTITUTIONAL INFORMATION
        if (currentStep == 3) {
          Text(
            text = "Institutional Information for ${selectedRole.name}:",
            style = MaterialTheme.typography.titleSmall,
            fontWeight = FontWeight.Bold,
            color = GriForestPrimary
          )

          Spacer(modifier = Modifier.height(12.dp))

          OutlinedTextField(
            value = department,
            onValueChange = { department = it },
            label = { Text("Department / School / Directorate") },
            modifier = Modifier.fillMaxWidth().testTag("reg_department"),
            singleLine = true
          )
          Spacer(modifier = Modifier.height(10.dp))

          when (selectedRole) {
            UserRole.STUDENT -> {
              OutlinedTextField(
                value = programme,
                onValueChange = { programme = it },
                label = { Text("Degree Programme (e.g. M.Sc. CS, B.Tech, M.A.)") },
                modifier = Modifier.fillMaxWidth().testTag("reg_programme"),
                singleLine = true
              )
              Spacer(modifier = Modifier.height(10.dp))
              OutlinedTextField(
                value = yearSemester,
                onValueChange = { yearSemester = it },
                label = { Text("Year / Semester (e.g. 1st Year / Sem I)") },
                modifier = Modifier.fillMaxWidth().testTag("reg_yearSem"),
                singleLine = true
              )
            }
            UserRole.FACULTY -> {
              OutlinedTextField(
                value = designation,
                onValueChange = { designation = it },
                label = { Text("Designation (Professor / Assoc / Asst Professor)") },
                modifier = Modifier.fillMaxWidth().testTag("reg_designation"),
                singleLine = true
              )
            }
            UserRole.COE_STAFF -> {
              OutlinedTextField(
                value = designation,
                onValueChange = { designation = it },
                label = { Text("Staff Designation / Office Wing") },
                modifier = Modifier.fillMaxWidth().testTag("reg_coe_designation"),
                singleLine = true
              )
            }
            UserRole.SCHOLAR -> {
              OutlinedTextField(
                value = researchTopic,
                onValueChange = { researchTopic = it },
                label = { Text("Doctoral Research Area / Fellowship (e.g. UGC JRF)") },
                modifier = Modifier.fillMaxWidth().testTag("reg_researchTopic"),
                singleLine = true
              )
            }
            else -> {}
          }

          Spacer(modifier = Modifier.height(12.dp))

          Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.clickable { agreedToDeclaration = !agreedToDeclaration }
          ) {
            Checkbox(
              checked = agreedToDeclaration,
              onCheckedChange = { agreedToDeclaration = it },
              colors = CheckboxDefaults.colors(checkedColor = GriForestPrimary),
              modifier = Modifier.testTag("reg_declaration_check")
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
              text = "I declare that the information provided is accurate and subject to institutional verification by GRI Registrar.",
              fontSize = 11.sp,
              color = GriOnSurfaceVariant
            )
          }

          Spacer(modifier = Modifier.height(16.dp))

          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            OutlinedButton(onClick = { currentStep = 2 }) { Text("Back") }
            Button(
              onClick = {
                if (!agreedToDeclaration) {
                  validationError = "Please agree to the institutional declaration."
                } else {
                  onSubmit(
                    fullName,
                    email,
                    mobile,
                    instId.ifEmpty { "REG-2026-${(100..999).random()}" },
                    selectedRole,
                    department,
                    programme,
                    yearSemester,
                    designation,
                    researchTopic
                  )
                }
              },
              colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary),
              modifier = Modifier.testTag("btn_submit_registration")
            ) {
              Text("Submit Application", fontWeight = FontWeight.Bold)
            }
          }
        }
      }
    }
  }
}

// =========================================================================
// 5. AUTHORIZED MULTI-ROLE SWITCHER DIALOG
// Only allows switching among already-approved roles for the active user
// =========================================================================

@Composable
fun AuthorizedRoleSwitcherDialog(
  currentUser: UserEntity?,
  currentRole: UserRole,
  onDismiss: () -> Unit,
  onRoleSelected: (UserRole) -> Unit
) {
  val approvedRoles = currentUser?.getApprovedRolesList() ?: listOf(currentRole)

  Dialog(onDismissRequest = onDismiss) {
    Surface(
      shape = RoundedCornerShape(18.dp),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 8.dp,
      modifier = Modifier
        .fillMaxWidth(0.92f)
        .padding(vertical = 20.dp)
        .testTag("dialog_authorized_role_switcher")
    ) {
      Column(modifier = Modifier.padding(20.dp)) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Column {
            Text(
              text = "Authorized Role Switcher",
              style = MaterialTheme.typography.titleMedium,
              fontWeight = FontWeight.Bold,
              color = GriForestPrimary
            )
            Text(
              text = "Switch between Registrar-approved identities",
              style = MaterialTheme.typography.bodySmall,
              color = GriOnSurfaceVariant
            )
          }

          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close")
          }
        }

        Spacer(modifier = Modifier.height(14.dp))
        HorizontalDivider()
        Spacer(modifier = Modifier.height(14.dp))

        if (approvedRoles.size <= 1) {
          Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f))
          ) {
            Column(modifier = Modifier.padding(14.dp)) {
              Text(
                text = "Single Approved Role: ${currentRole.name}",
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Bold,
                color = GriForestPrimary
              )
              Spacer(modifier = Modifier.height(4.dp))
              Text(
                text = "Your account currently has one authorized role. Multi-role access (such as Faculty + Research Scholar) requires administrative role assignment.",
                style = MaterialTheme.typography.bodySmall,
                color = GriOnSurfaceVariant,
                fontSize = 11.sp
              )
            }
          }
        } else {
          Text(
            text = "Select Active Institutional Role:",
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.Bold,
            color = GriOnSurfaceVariant
          )
          Spacer(modifier = Modifier.height(10.dp))

          approvedRoles.forEach { role ->
            val isActive = role == currentRole
            Card(
              modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp)
                .clickable { onRoleSelected(role) }
                .testTag("role_switch_${role.name}"),
              shape = RoundedCornerShape(12.dp),
              colors = CardDefaults.cardColors(
                containerColor = if (isActive) GriForestPrimary.copy(alpha = 0.12f) else MaterialTheme.colorScheme.surface
              ),
              border = BorderStroke(
                if (isActive) 2.dp else 1.dp,
                if (isActive) GriForestPrimary else MaterialTheme.colorScheme.outlineVariant
              )
            ) {
              Row(
                modifier = Modifier.padding(14.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
              ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                  Icon(
                    imageVector = when (role) {
                      UserRole.STUDENT -> Icons.Default.School
                      UserRole.FACULTY -> Icons.Default.Person
                      UserRole.COE_STAFF -> Icons.Default.Assignment
                      UserRole.ADMIN, UserRole.SUPER_ADMIN -> Icons.Default.AdminPanelSettings
                      else -> Icons.Default.Person
                    },
                    contentDescription = null,
                    tint = if (isActive) GriForestPrimary else GriOnSurfaceVariant,
                    modifier = Modifier.size(22.dp)
                  )
                  Spacer(modifier = Modifier.width(12.dp))
                  Column {
                    Text(
                      text = role.name,
                      style = MaterialTheme.typography.bodyLarge,
                      fontWeight = if (isActive) FontWeight.Bold else FontWeight.Medium,
                      color = if (isActive) GriForestPrimary else MaterialTheme.colorScheme.onSurface
                    )
                    Text(
                      text = if (isActive) "Active Institutional Session" else "Approved Role • Tap to activate",
                      style = MaterialTheme.typography.bodySmall,
                      color = GriOnSurfaceVariant,
                      fontSize = 11.sp
                    )
                  }
                }

                if (isActive) {
                  Icon(
                    imageVector = Icons.Default.CheckCircle,
                    contentDescription = "Active",
                    tint = GriForestPrimary,
                    modifier = Modifier.size(20.dp)
                  )
                }
              }
            }
          }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(
          onClick = onDismiss,
          colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary),
          modifier = Modifier.fillMaxWidth()
        ) {
          Text("Done", fontWeight = FontWeight.Bold)
        }
      }
    }
  }
}
