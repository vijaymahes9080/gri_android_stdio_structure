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
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.FactCheck
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.QrCodeScanner
import androidx.compose.material.icons.filled.ThumbDown
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
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
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.AnnotatedString
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
 * Stitch Screen 5: Ask GRI AI & Universal Search
 * gandhigram_rural_institute/ask_gri_ai_universal_search.html
 */
@Composable
fun AskGriAiScreen(
  uiState: GriUiState,
  onSendQuery: (String) -> Unit,
  onNavigateToDocuments: () -> Unit = {},
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  val clipboardManager = LocalClipboardManager.current
  var inputQuery by remember { mutableStateOf("") }
  var copiedFeedback by remember { mutableStateOf(false) }

  val sampleQueries = listOf(
    "End Sem Hall Ticket deadline",
    "Fee concession bus pass",
    "Dr. G. Ramachandran Library",
    "NEP multiple entry-exit rules"
  )

  Column(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("ask_gri_ai_screen")
  ) {

    // 1. TOP HEADER BANNER
    Surface(
      color = GriSurfaceContainerLowest,
      shadowElevation = 1.dp,
      modifier = Modifier.fillMaxWidth()
    ) {
      Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.SpaceBetween,
          verticalAlignment = Alignment.CenterVertically
        ) {
          Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
              modifier = Modifier
                .size(34.dp)
                .clip(CircleShape)
                .background(GriForestPrimary),
              contentAlignment = Alignment.Center
            ) {
              Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
            }
            Spacer(modifier = Modifier.width(8.dp))
            Column {
              Text("Ask GRI AI", fontSize = 16.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
              Text("Powered by GRI Knowledge Base & UGC e-Office", fontSize = 10.sp, color = GriOutline)
            }
          }

          Surface(
            shape = RoundedCornerShape(999.dp),
            color = GriForestFixed
          ) {
            Row(
              modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp),
              verticalAlignment = Alignment.CenterVertically
            ) {
              Box(modifier = Modifier.size(6.dp).clip(CircleShape).background(GriForestPrimary))
              Spacer(modifier = Modifier.width(4.dp))
              Text("Samarth Sync", fontSize = 9.sp, fontWeight = FontWeight.Bold, color = GriForestOnFixed)
            }
          }
        }

        Spacer(modifier = Modifier.height(6.dp))

        // Student context tag
        Surface(
          shape = RoundedCornerShape(6.dp),
          color = GriSurfaceContainerLow,
          modifier = Modifier.fillMaxWidth()
        ) {
          Row(
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            horizontalArrangement = Arrangement.SpaceBetween
          ) {
            Text("Scoped: B.Sc. (Hons) Agriculture • Sem IV", fontSize = 10.sp, fontWeight = FontWeight.Medium, color = GriOnSurface)
            Text("AY 2024-25 Regs", fontSize = 10.sp, color = GriOutline)
          }
        }
      }
    }

    // 2. CONVERSATION CONTENT
    LazyColumn(
      modifier = Modifier
        .weight(1f)
        .padding(horizontal = 16.dp),
      contentPadding = PaddingValues(vertical = 12.dp),
      verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {

      // Sample Queries Quick Carousel
      item {
        Column {
          Text("Common Institutional Inquiries", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = GriOutline)
          Spacer(modifier = Modifier.height(6.dp))
          LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            items(sampleQueries) { q ->
              Surface(
                shape = RoundedCornerShape(999.dp),
                color = GriSurfaceContainerLowest,
                border = androidx.compose.foundation.BorderStroke(1.dp, GriOutlineVariant),
                modifier = Modifier.clickable {
                  inputQuery = q
                  onSendQuery(q)
                }
              ) {
                Text(
                  text = q,
                  fontSize = 11.sp,
                  color = GriForestPrimary,
                  fontWeight = FontWeight.Medium,
                  modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp)
                )
              }
            }
          }
        }
      }

      // Default Grounded Conversation Thread: Clause 7.2 Attendance & Medical Exemption
      item {
        // User Message Bubble
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.End
        ) {
          Surface(
            shape = RoundedCornerShape(topStart = 14.dp, topEnd = 4.dp, bottomStart = 14.dp, bottomEnd = 14.dp),
            color = GriForestPrimary,
            modifier = Modifier.widthIn(max = 290.dp)
          ) {
            Text(
              text = "What is the minimum attendance required to get the End Semester Hall Ticket, and can I get a medical exemption?",
              fontSize = 13.sp,
              color = Color.White,
              modifier = Modifier.padding(12.dp)
            )
          }
        }
      }

      item {
        // Grounded AI Response Card with Official Citation
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .testTag("ai_response_card"),
          shape = RoundedCornerShape(14.dp),
          colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
          elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
        ) {
          Column(modifier = Modifier.padding(14.dp)) {
            // Authority Citation Badge
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Surface(
                shape = RoundedCornerShape(4.dp),
                color = GriOchreContainer
              ) {
                Row(
                  modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp),
                  verticalAlignment = Alignment.CenterVertically
                ) {
                  Icon(Icons.Default.Verified, contentDescription = null, tint = Color.White, modifier = Modifier.size(11.dp))
                  Spacer(modifier = Modifier.width(4.dp))
                  Text(
                    text = "Clause 7.2 • GRI Academic Council Norms",
                    fontSize = 9.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                  )
                }
              }

              Text("Gazette 2024", fontSize = 10.sp, color = GriOutline)
            }

            Spacer(modifier = Modifier.height(10.dp))

            Text(
              text = "Under the official GRI CBCS Examination Regulations, the statutory attendance criteria are governed as follows:",
              fontSize = 12.sp,
              color = GriOnSurface,
              lineHeight = 17.sp
            )

            Spacer(modifier = Modifier.height(8.dp))

            // Points
            AiPointItem(
              title = "1. Mandatory Minimum:",
              desc = "Every registered candidate must achieve at least 75% attendance in each course to be eligible to appear for the End Semester Examinations."
            )

            AiPointItem(
              title = "2. Medical Condonation (65% to 74%):",
              desc = "Exemption can be recommended by the Dean on valid medical grounds (hospitalization certificate & medical fitness) upon payment of condonation fee through SBI Collect."
            )

            AiPointItem(
              title = "3. Shortage Below 65%:",
              desc = "Candidates with attendance below 65% are strictly detained and must re-enroll to repeat the course in a subsequent semester."
            )

            Spacer(modifier = Modifier.height(10.dp))

            // Embedded Utility Card 1: Official Regulation PDF
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
                Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.weight(1f)) {
                  Icon(Icons.Default.Description, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(20.dp))
                  Spacer(modifier = Modifier.width(8.dp))
                  Column {
                    Text("GRI/AC/REG-2024/7.2 (PDF)", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
                    Text("Official Regulation on Attendance & Condonation", fontSize = 9.sp, color = GriOutline)
                  }
                }
                IconButton(onClick = onNavigateToDocuments, modifier = Modifier.size(28.dp)) {
                  Icon(Icons.Default.Download, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(16.dp))
                }
              }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Embedded Utility Card 2: Student's Real-time Attendance Snapshot
            Surface(
              shape = RoundedCornerShape(8.dp),
              color = GriForestFixed,
              modifier = Modifier.fillMaxWidth()
            ) {
              Column(modifier = Modifier.padding(10.dp)) {
                Row(
                  modifier = Modifier.fillMaxWidth(),
                  horizontalArrangement = Arrangement.SpaceBetween,
                  verticalAlignment = Alignment.CenterVertically
                ) {
                  Text("Your Real-Time Attendance Snapshot", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriForestOnFixed)
                  Text("Eligible for Hall Ticket", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriForestOnFixed)
                }
                Spacer(modifier = Modifier.height(4.dp))
                LinearProgressIndicator(
                  progress = { 0.885f },
                  modifier = Modifier
                    .fillMaxWidth()
                    .height(5.dp)
                    .clip(RoundedCornerShape(999.dp)),
                  color = GriForestPrimary,
                  trackColor = Color.White.copy(alpha = 0.5f)
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text("88.5% Aggregated (147 / 166 classes recorded) • Safe Zone", fontSize = 10.sp, color = GriForestOnFixed)
              }
            }

            Spacer(modifier = Modifier.height(10.dp))

            // Micro-bar with Citation Verification & Copy
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Text(
                text = "Controller of Examinations Gazette verified",
                fontSize = 9.sp,
                color = GriOutline
              )

              Row(verticalAlignment = Alignment.CenterVertically) {
                IconButton(
                  onClick = {
                    clipboardManager.setText(AnnotatedString("Clause 7.2 • GRI Academic Council: Minimum 75% attendance required."))
                    copiedFeedback = true
                  },
                  modifier = Modifier.size(24.dp)
                ) {
                  Icon(
                    imageVector = if (copiedFeedback) Icons.Default.Check else Icons.Default.ContentCopy,
                    contentDescription = "Copy Citation",
                    tint = GriForestPrimary,
                    modifier = Modifier.size(13.dp)
                  )
                }
                IconButton(onClick = {}, modifier = Modifier.size(24.dp)) {
                  Icon(Icons.Default.ThumbUp, contentDescription = "Helpful", tint = GriOutline, modifier = Modifier.size(13.dp))
                }
                IconButton(onClick = {}, modifier = Modifier.size(24.dp)) {
                  Icon(Icons.Default.ThumbDown, contentDescription = "Not Helpful", tint = GriOutline, modifier = Modifier.size(13.dp))
                }
              }
            }
          }
        }
      }

      // Dynamic User Messages from UI State
      items(uiState.sahayakMessages) { msg ->
        if (msg.isUser) {
          Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
            Surface(
              shape = RoundedCornerShape(12.dp),
              color = GriForestPrimary,
              modifier = Modifier.widthIn(max = 280.dp)
            ) {
              Text(msg.text, fontSize = 12.sp, color = Color.White, modifier = Modifier.padding(10.dp))
            }
          }
        } else {
          Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Start) {
            Card(
              shape = RoundedCornerShape(12.dp),
              colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
              elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
              modifier = Modifier.widthIn(max = 300.dp)
            ) {
              Column(modifier = Modifier.padding(12.dp)) {
                Text(msg.text, fontSize = 12.sp, color = GriOnSurface, lineHeight = 17.sp)
                if (msg.source != null) {
                  Text("Source: ${msg.source}", fontSize = 9.sp, color = GriOutline, modifier = Modifier.padding(top = 4.dp))
                }
              }
            }
          }
        }
      }
    }

    // 3. INTERACTIVE QUERY INPUT BAR
    Surface(
      color = GriSurfaceContainerLowest,
      shadowElevation = 3.dp,
      modifier = Modifier.fillMaxWidth()
    ) {
      Column(modifier = Modifier.padding(horizontal = 12.dp, vertical = 8.dp)) {
        Row(
          modifier = Modifier.fillMaxWidth(),
          verticalAlignment = Alignment.CenterVertically
        ) {
          IconButton(onClick = {}, modifier = Modifier.size(32.dp)) {
            Icon(Icons.Default.QrCodeScanner, contentDescription = "Scan QR", tint = GriOutline, modifier = Modifier.size(18.dp))
          }

          Box(modifier = Modifier.weight(1f).padding(horizontal = 6.dp)) {
            if (inputQuery.isEmpty()) {
              Text("Ask anything about GRI regulations, exams, hostels...", fontSize = 12.sp, color = GriOutline)
            }
            androidx.compose.foundation.text.BasicTextField(
              value = inputQuery,
              onValueChange = { inputQuery = it },
              textStyle = androidx.compose.ui.text.TextStyle(fontSize = 12.sp, color = GriOnSurface),
              modifier = Modifier.fillMaxWidth()
            )
          }

          IconButton(onClick = {}, modifier = Modifier.size(32.dp)) {
            Icon(Icons.Default.Mic, contentDescription = "Mic", tint = GriOutline, modifier = Modifier.size(18.dp))
          }

          IconButton(
            onClick = {
              if (inputQuery.isNotBlank()) {
                onSendQuery(inputQuery)
                inputQuery = ""
              }
            },
            modifier = Modifier
              .size(36.dp)
              .clip(CircleShape)
              .background(GriForestPrimary)
          ) {
            Icon(Icons.AutoMirrored.Filled.Send, contentDescription = "Send", tint = Color.White, modifier = Modifier.size(16.dp))
          }
        }

        Text(
          text = "Authenticated responses verified against GRI Academic Council orders & CoE Gazette.",
          fontSize = 9.sp,
          color = GriOutline,
          modifier = Modifier.padding(top = 4.dp, start = 6.dp)
        )
      }
    }
  }
}

@Composable
fun AiPointItem(title: String, desc: String) {
  Column(modifier = Modifier.padding(vertical = 3.dp)) {
    Text(title, fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
    Text(desc, fontSize = 11.sp, color = GriOnSurfaceVariant, lineHeight = 15.sp)
  }
}
