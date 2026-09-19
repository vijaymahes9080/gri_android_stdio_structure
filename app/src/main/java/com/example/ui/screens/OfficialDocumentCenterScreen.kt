package com.example.ui.screens

import android.content.Intent
import android.net.Uri
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
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.FileDownload
import androidx.compose.material.icons.filled.Fingerprint
import androidx.compose.material.icons.filled.HistoryEdu
import androidx.compose.material.icons.filled.QrCodeScanner
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
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

data class OfficialDocItem(
  val id: String,
  val refNo: String,
  val title: String,
  val authority: String,
  val category: String,
  val date: String,
  val size: String,
  val isPinned: Boolean = false,
  val isShaVerified: Boolean = true
)

/**
 * Stitch Screen 7: Official Document Center
 * gandhigram_rural_institute/gri_official_document_center.html
 */
@Composable
fun OfficialDocumentCenterScreen(
  uiState: GriUiState,
  onVerifyAuthenticity: (String) -> Unit = {},
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  var searchQuery by remember { mutableStateOf("") }
  var selectedCategory by remember { mutableStateOf("All") }
  var verifyHashInput by remember { mutableStateOf("") }

  val categories = listOf("All", "Circulars", "Exam Orders", "Regulations", "Forms", "Gazette")

  val documents = listOf(
    OfficialDocItem(
      id = "doc_1",
      refNo = "GRI/RO/2025/084",
      title = "Schedule for Even Semester Examination Fee Payment without Penalty",
      authority = "Registrar Secretariat",
      category = "Circulars",
      date = "Today",
      size = "480 KB",
      isShaVerified = true
    ),
    OfficialDocItem(
      id = "doc_2",
      refNo = "GRI/COE/ESE-25/09",
      title = "End Semester Comprehensive Examination Timetable (UG/PG & CBCS)",
      authority = "Controller of Examinations",
      category = "Exam Orders",
      date = "Yesterday",
      size = "1.2 MB",
      isShaVerified = true
    ),
    OfficialDocItem(
      id = "doc_3",
      refNo = "AC-2024/V2/NEP",
      title = "NEP-2020 Curricular Framework & Multiple Entry-Exit Ordinances",
      authority = "Academic Council",
      category = "Regulations",
      date = "08 Apr 2025",
      size = "3.4 MB",
      isShaVerified = true
    ),
    OfficialDocItem(
      id = "doc_4",
      refNo = "Form FA-12",
      title = "Application Form for Institutional Bus Pass & Concession Voucher",
      authority = "Transport Office",
      category = "Forms",
      date = "04 Apr 2025",
      size = "150 KB",
      isShaVerified = false
    ),
    OfficialDocItem(
      id = "doc_5",
      refNo = "Form SCH-04",
      title = "National Scholarship Portal & Tamil Nadu State Post-Matric Undertaking",
      authority = "Dean of Student Welfare",
      category = "Forms",
      date = "01 Apr 2025",
      size = "310 KB",
      isShaVerified = true
    )
  )

  val filteredDocs = remember(searchQuery, selectedCategory) {
    documents.filter {
      val matchesCat = if (selectedCategory == "All") true else it.category.equals(selectedCategory, ignoreCase = true)
      val matchesSearch = if (searchQuery.isBlank()) true else {
        it.title.contains(searchQuery, ignoreCase = true) ||
        it.refNo.contains(searchQuery, ignoreCase = true) ||
        it.authority.contains(searchQuery, ignoreCase = true)
      }
      matchesCat && matchesSearch
    }
  }

  LazyColumn(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("official_document_center_screen"),
    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
    verticalArrangement = Arrangement.spacedBy(14.dp)
  ) {

    // 1. TOP ACCREDITATION & HEADER
    item {
      Column {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Column {
            Text("NAAC 'A+' • e-Office Live Feed", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = GriOutline)
            Text("Official Document Center", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
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
              Text("e-Office Live", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = Color.White)
            }
          }
        }

        Spacer(modifier = Modifier.height(4.dp))
        Text(
          text = "Authenticated repository of university orders, gazettes, and academic instruments.",
          fontSize = 12.sp,
          color = GriOnSurfaceVariant
        )
      }
    }

    // 2. SEARCH BAR & CATEGORY PILLS
    item {
      Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Surface(
          shape = RoundedCornerShape(12.dp),
          color = GriSurfaceContainerLowest,
          shadowElevation = 0.5.dp
        ) {
          Row(
            modifier = Modifier
              .fillMaxWidth()
              .padding(horizontal = 12.dp, vertical = 8.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Icon(Icons.Default.Search, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(18.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Box(modifier = Modifier.weight(1f)) {
              if (searchQuery.isEmpty()) {
                Text("Search by Circular No., Subject, or Dept...", fontSize = 12.sp, color = GriOutline)
              }
              androidx.compose.foundation.text.BasicTextField(
                value = searchQuery,
                onValueChange = { searchQuery = it },
                textStyle = androidx.compose.ui.text.TextStyle(fontSize = 12.sp, color = GriOnSurface),
                modifier = Modifier.fillMaxWidth()
              )
            }
          }
        }

        LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
          items(categories) { cat ->
            val isSelected = selectedCategory == cat
            Surface(
              shape = RoundedCornerShape(999.dp),
              color = if (isSelected) GriForestPrimary else GriSurfaceContainerLow,
              modifier = Modifier.clickable { selectedCategory = cat }
            ) {
              Text(
                text = cat,
                fontSize = 11.sp,
                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                color = if (isSelected) Color.White else GriOnSurfaceVariant,
                modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp)
              )
            }
          }
        }
      }
    }

    // 3. PRIORITY PINNED DOCUMENT (HERITAGE GOLD SEALED CARD)
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_priority_pinned_doc"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.5.dp)
      ) {
        Box(modifier = Modifier.fillMaxWidth()) {
          Box(
            modifier = Modifier
              .matchParentSize()
              .background(GriOchreFixed.copy(alpha = 0.25f))
          )

          Column(modifier = Modifier.padding(16.dp)) {
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Surface(
                shape = RoundedCornerShape(999.dp),
                color = GriOchreContainer
              ) {
                Text(
                  text = "PRIORITY NOTIFICATION",
                  fontSize = 9.sp,
                  fontWeight = FontWeight.Bold,
                  color = Color.White,
                  letterSpacing = 0.5.sp,
                  modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                )
              }
              Text("10 April 2025 • 5.8 MB", fontSize = 10.sp, color = GriOutline)
            }

            Spacer(modifier = Modifier.height(8.dp))

            Text(
              text = "NIRF 2024 Institutional Ranking & UGC Autonomy Statutory Guidelines",
              fontSize = 15.sp,
              fontWeight = FontWeight.Bold,
              color = GriOnSurface,
              lineHeight = 20.sp
            )

            Text(
              text = "Gazette Extraordinary published by Vice-Chancellor Secretariat detailing university ranking metrics, rural extension patents, and research excellence.",
              fontSize = 12.sp,
              color = GriOnSurfaceVariant,
              modifier = Modifier.padding(top = 4.dp, bottom = 12.dp)
            )

            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
              Button(
                onClick = {
                  val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
                  try { context.startActivity(intent) } catch (_: Exception) {}
                },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White),
                contentPadding = PaddingValues(horizontal = 14.dp, vertical = 6.dp)
              ) {
                Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Download (5.8 MB)", fontSize = 11.sp, fontWeight = FontWeight.Bold)
              }

              Button(
                onClick = {
                  val share = Intent(Intent.ACTION_SEND).apply {
                    type = "text/plain"
                    putExtra(Intent.EXTRA_TEXT, "GRI NIRF & UGC Gazette: https://www.ruraluniv.ac.in/")
                  }
                  try { context.startActivity(Intent.createChooser(share, "Share Circular")) } catch (_: Exception) {}
                },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = GriSurfaceContainerHigh, contentColor = GriForestPrimary),
                contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
              ) {
                Icon(Icons.Default.Share, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Share", fontSize = 11.sp, fontWeight = FontWeight.SemiBold)
              }
            }
          }
        }
      }
    }

    // 4. VERIFY DOCUMENT AUTHENTICITY TOOL CARD
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_verify_document_authenticity"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
              modifier = Modifier
                .size(32.dp)
                .clip(CircleShape)
                .background(GriForestPrimary),
              contentAlignment = Alignment.Center
            ) {
              Icon(Icons.Default.Fingerprint, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
            }
            Spacer(modifier = Modifier.width(10.dp))
            Column {
              Text("Verify Document Authenticity", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
              Text("Validate cryptographic signatures & e-Office registration", fontSize = 10.sp, color = GriOutline)
            }
          }

          Spacer(modifier = Modifier.height(10.dp))

          Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
          ) {
            OutlinedTextField(
              value = verifyHashInput,
              onValueChange = { verifyHashInput = it },
              placeholder = { Text("Enter Ref No (e.g., GRI/RO/2025/084)", fontSize = 11.sp) },
              textStyle = androidx.compose.ui.text.TextStyle(fontSize = 11.sp),
              modifier = Modifier.weight(1f),
              singleLine = true
            )

            Spacer(modifier = Modifier.width(8.dp))

            Button(
              onClick = {
                if (verifyHashInput.isNotBlank()) {
                  onVerifyAuthenticity(verifyHashInput)
                }
              },
              shape = RoundedCornerShape(8.dp),
              colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White),
              contentPadding = PaddingValues(horizontal = 12.dp, vertical = 10.dp)
            ) {
              Text("Verify", fontSize = 12.sp, fontWeight = FontWeight.Bold)
            }
          }

          if (uiState.verifiedDocumentStatus != null) {
            Spacer(modifier = Modifier.height(8.dp))
            Surface(
              shape = RoundedCornerShape(8.dp),
              color = if (uiState.verifiedDocumentStatus.contains("Verified")) GriForestFixed else GriSurfaceContainerLow,
              modifier = Modifier.fillMaxWidth()
            ) {
              Text(
                text = uiState.verifiedDocumentStatus,
                fontSize = 11.sp,
                fontWeight = FontWeight.SemiBold,
                color = if (uiState.verifiedDocumentStatus.contains("Verified")) GriForestOnFixed else Color(0xFFBA1A1A),
                modifier = Modifier.padding(10.dp)
              )
            }
          }
        }
      }
    }

    // 5. OFFICIAL REPOSITORY DISPATCHES FEED
    item {
      Text(
        text = "Repository Dispatches (${filteredDocs.size})",
        fontSize = 15.sp,
        fontWeight = FontWeight.Bold,
        color = GriOnSurface
      )
    }

    items(filteredDocs) { doc ->
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("doc_item_${doc.id}"),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.5.dp)
      ) {
        Column(modifier = Modifier.padding(12.dp)) {
          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Surface(
              shape = RoundedCornerShape(4.dp),
              color = GriForestContainer
            ) {
              Text(
                text = doc.refNo,
                fontSize = 10.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White,
                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
              )
            }

            Text("${doc.date} • ${doc.size}", fontSize = 10.sp, color = GriOutline)
          }

          Spacer(modifier = Modifier.height(6.dp))

          Text(
            text = doc.title,
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
            Text(doc.authority, fontSize = 11.sp, color = GriTealSecondary, fontWeight = FontWeight.Medium)

            Row(verticalAlignment = Alignment.CenterVertically) {
              if (doc.isShaVerified) {
                Icon(Icons.Default.Verified, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("SHA-256", fontSize = 10.sp, color = GriForestPrimary, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.width(8.dp))
              }

              IconButton(
                onClick = {
                  val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
                  try { context.startActivity(intent) } catch (_: Exception) {}
                },
                modifier = Modifier.size(28.dp)
              ) {
                Icon(Icons.Default.Download, contentDescription = "Download", tint = GriForestPrimary, modifier = Modifier.size(16.dp))
              }
            }
          }
        }
      }
    }
  }
}
