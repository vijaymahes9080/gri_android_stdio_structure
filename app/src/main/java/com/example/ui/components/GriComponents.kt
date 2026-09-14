package com.example.ui.components

import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
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
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Campaign
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material.icons.filled.CloudDone
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.QrCode2
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Search
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
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import com.example.R
import com.example.backend.HallTicketResponse
import com.example.data.local.UserEntity
import com.example.data.local.UserRole
import com.example.ui.theme.GriColors
import com.example.ui.theme.GriGoldDark
import com.example.ui.theme.GriGoldSecondary
import com.example.ui.theme.GriGreenSuccess
import com.example.ui.theme.GriNavyPrimary
import com.example.ui.theme.GriRadius
import com.example.ui.theme.GriRedAlert
import com.example.ui.theme.GriSpacing

/**
 * Official GRI Top Bar Component
 * Featuring the official circular seal, institutional name, Tamil motto, and live backend indicators.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GriTopBar(
  serverStatus: String,
  pendingSyncs: Int,
  isSyncing: Boolean,
  onSyncClick: () -> Unit,
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
        // Official GRI Seal Vector
        Image(
          painter = painterResource(id = R.drawable.ic_gri_seal),
          contentDescription = "GRI University Seal",
          modifier = Modifier
            .size(42.dp)
            .clip(CircleShape)
            .border(1.dp, GriGoldSecondary, CircleShape)
        )

        Spacer(modifier = Modifier.width(10.dp))

        Column {
          Text(
            text = "GANDHIGRAM RURAL INSTITUTE",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary,
            fontSize = 14.sp,
            lineHeight = 18.sp,
            letterSpacing = 0.2.sp,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
          )
          Text(
            text = "Deemed to be University • NAAC 'A+'",
            style = MaterialTheme.typography.bodySmall,
            fontSize = 11.sp,
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
      // Live Ktor Server Status Badge
      Surface(
        color = if (serverStatus.contains("ONLINE")) GriGreenSuccess.copy(alpha = 0.12f) else MaterialTheme.colorScheme.surfaceVariant,
        shape = RoundedCornerShape(GriRadius.xs),
        modifier = Modifier.padding(end = 4.dp)
      ) {
        Row(
          modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp),
          verticalAlignment = Alignment.CenterVertically
        ) {
          Box(
            modifier = Modifier
              .size(6.dp)
              .clip(CircleShape)
              .background(
                if (serverStatus.contains("ONLINE")) GriGreenSuccess.copy(alpha = pulseAlpha) else Color.Gray
              )
          )
          Spacer(modifier = Modifier.width(4.dp))
          Text(
            text = "KTOR :8080",
            style = MaterialTheme.typography.labelSmall,
            fontSize = 9.sp,
            fontWeight = FontWeight.Bold,
            color = if (serverStatus.contains("ONLINE")) GriGreenSuccess else MaterialTheme.colorScheme.onSurfaceVariant
          )
        }
      }

      // Sync Trigger Button with pending syncs badge
      IconButton(
        onClick = onSyncClick,
        modifier = Modifier
          .size(48.dp)
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
            modifier = Modifier.size(22.dp)
          )
        }
      }
    }
  )
}

/**
 * Role Selector Bar
 * Allows effortless switching between STUDENT, FACULTY, SCHOLAR, ALUMNI, ADMIN, and PUBLIC
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
      text = "PORTAL:",
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
  Dialog(onDismissRequest = onDismiss) {
    Surface(
      shape = RoundedCornerShape(GriRadius.xl),
      color = MaterialTheme.colorScheme.surface,
      tonalElevation = 6.dp,
      modifier = Modifier
        .fillMaxWidth()
        .padding(vertical = 16.dp)
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
                .size(32.dp)
                .clip(CircleShape)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Column {
              Text(
                text = "EXAMINATION HALL TICKET",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = GriNavyPrimary
              )
              Text(
                text = ticket.examSession,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
              )
            }
          }
          IconButton(onClick = onDismiss) {
            Icon(Icons.Default.Close, contentDescription = "Close")
          }
        }

        Spacer(modifier = Modifier.height(12.dp))
        HorizontalDivider()
        Spacer(modifier = Modifier.height(12.dp))

        // Student details block
        Surface(
          color = MaterialTheme.colorScheme.surfaceVariant,
          shape = RoundedCornerShape(GriRadius.md)
        ) {
          Column(modifier = Modifier.padding(12.dp)) {
            Text(
              text = "Candidate: ${ticket.studentName} (${ticket.registerNumber})",
              style = MaterialTheme.typography.bodyMedium,
              fontWeight = FontWeight.Bold
            )
            Text(
              text = "Degree: ${ticket.degree}",
              style = MaterialTheme.typography.bodySmall
            )
            Text(
              text = "Center: ${ticket.examinationCenter}",
              style = MaterialTheme.typography.bodySmall,
              color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Row(
              modifier = Modifier.padding(top = 4.dp),
              verticalAlignment = Alignment.CenterVertically
            ) {
              Icon(
                imageVector = Icons.Default.Verified,
                contentDescription = null,
                tint = GriGreenSuccess,
                modifier = Modifier.size(16.dp)
              )
              Spacer(modifier = Modifier.width(4.dp))
              Text(
                text = "e-SANAD Token: ${ticket.sanadVerificationCode}",
                style = MaterialTheme.typography.labelSmall,
                color = GriGreenSuccess,
                fontWeight = FontWeight.Medium
              )
            }
          }
        }

        Spacer(modifier = Modifier.height(14.dp))
        Text(
          text = "Examination Schedule",
          style = MaterialTheme.typography.titleSmall,
          fontWeight = FontWeight.Bold
        )
        Spacer(modifier = Modifier.height(6.dp))

        ticket.exams.forEach { exam ->
          Card(
            modifier = Modifier
              .fillMaxWidth()
              .padding(vertical = 4.dp),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.background),
            shape = RoundedCornerShape(GriRadius.sm),
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
                  text = "${exam.courseCode} • ${exam.courseTitle}",
                  style = MaterialTheme.typography.bodyMedium,
                  fontWeight = FontWeight.SemiBold
                )
                Text(
                  text = "${exam.date} | ${exam.session}",
                  style = MaterialTheme.typography.bodySmall,
                  color = MaterialTheme.colorScheme.onSurfaceVariant
                )
              }
              Surface(
                color = GriNavyPrimary.copy(alpha = 0.1f),
                shape = RoundedCornerShape(GriRadius.xs)
              ) {
                Text(
                  text = exam.hallNumber,
                  style = MaterialTheme.typography.labelSmall,
                  color = GriNavyPrimary,
                  fontWeight = FontWeight.Bold,
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp)
                )
              }
            }
          }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Button(
          onClick = onDismiss,
          colors = ButtonDefaults.buttonColors(containerColor = GriNavyPrimary),
          shape = RoundedCornerShape(GriRadius.md),
          modifier = Modifier.fillMaxWidth()
        ) {
          Text("Close Hall Ticket", color = Color.White, fontWeight = FontWeight.Bold)
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
