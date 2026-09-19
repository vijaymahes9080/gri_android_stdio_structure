package com.example.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.Canvas
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
import androidx.compose.material.icons.automirrored.filled.DirectionsWalk
import androidx.compose.material.icons.filled.Agriculture
import androidx.compose.material.icons.filled.Apartment
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.DirectionsBus
import androidx.compose.material.icons.filled.ElectricCar
import androidx.compose.material.icons.filled.Explore
import androidx.compose.material.icons.filled.Fastfood
import androidx.compose.material.icons.filled.LocalHospital
import androidx.compose.material.icons.filled.LocalLibrary
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.Museum
import com.example.ui.components.CampusMapView
import androidx.compose.material.icons.filled.Navigation
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.ShoppingBag
import androidx.compose.material.icons.filled.SolarPower
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
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
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

data class CampusLandmark(
  val id: String,
  val name: String,
  val category: String,
  val distance: String,
  val description: String,
  val icon: ImageVector,
  val actionLabel: String = "Navigate"
)

/**
 * Stitch Screen 3: Explore GRI Campus Facilities & Map
 * gandhigram_rural_institute/explore_gri_campus_facilities.html
 */
@Composable
fun CampusFacilitiesScreen(
  uiState: GriUiState,
  modifier: Modifier = Modifier
) {
  val context = LocalContext.current
  var activeTab by remember { mutableStateOf(0) } // 0: Interactive Campus Map, 1: Facilities Directory
  var searchQuery by remember { mutableStateOf("") }
  var selectedFilter by remember { mutableStateOf("All") }

  val filters = listOf("All", "Schools & Depts", "Facilities", "Hostels", "Admin", "Heritage & Memorial")

  val landmarks = listOf(
    CampusLandmark(
      id = "crd",
      name = "Centre for Rural Dev. & Panchayat Raj",
      category = "Heritage & Memorial",
      distance = "180m away",
      description = "Estd 1956 • Grassroots governance lab, model village reconstruction museum & archives.",
      icon = Icons.Default.Museum
    ),
    CampusLandmark(
      id = "lib",
      name = "Dr. G. Ramachandran Central Library",
      category = "Facilities",
      distance = "350m away",
      description = "24x7 Digital Wing • 1,75,000+ volumes, RFID automated checkout & e-consortia.",
      icon = Icons.Default.LocalLibrary,
      actionLabel = "Catalogue"
    ),
    CampusLandmark(
      id = "health",
      name = "Kasturba Hospital & Health Centre",
      category = "Facilities",
      distance = "420m away",
      description = "Emergency 24x7 (Ext 222) • Resident Medical Officer, pharmacy & trauma care.",
      icon = Icons.Default.LocalHospital,
      actionLabel = "Call Desk"
    ),
    CampusLandmark(
      id = "hostels",
      name = "Thamarai & Malligai Student Hostels",
      category = "Hostels",
      distance = "600m away",
      description = "Residential Complexes • RO water plants, Wi-Fi mesh, organic dining mess hall.",
      icon = Icons.Default.Apartment,
      actionLabel = "Gate Pass"
    ),
    CampusLandmark(
      id = "solar",
      name = "Solar Microgrid & Biogas Demo Park",
      category = "Facilities",
      distance = "750m away",
      description = "Green Initiative • 1.2 MW Eco Farm, vermicomposting yard & climate weather station.",
      icon = Icons.Default.SolarPower,
      actionLabel = "Tour Demo"
    ),
    CampusLandmark(
      id = "guest",
      name = "University Guest House & VIP Bhavan",
      category = "Admin",
      distance = "850m away",
      description = "Hospitality • East Campus Gate, air-conditioned suites & conference dining.",
      icon = Icons.Default.Explore,
      actionLabel = "Check Vacancy"
    )
  )

  val filteredLandmarks = remember(searchQuery, selectedFilter) {
    landmarks.filter {
      val matchesCat = if (selectedFilter == "All") true else it.category.equals(selectedFilter, ignoreCase = true)
      val matchesSearch = if (searchQuery.isBlank()) true else {
        it.name.contains(searchQuery, ignoreCase = true) ||
        it.description.contains(searchQuery, ignoreCase = true)
      }
      matchesCat && matchesSearch
    }
  }

  Column(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurface)
      .testTag("campus_explore_screen")
  ) {
    // 1. TOP HEADER & VIEW MODE SELECTOR
    Column(
      modifier = Modifier
        .fillMaxWidth()
        .padding(start = 16.dp, end = 16.dp, top = 12.dp, bottom = 4.dp),
      verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
      Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
      ) {
        Column {
          Text("Campus Navigator", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = GriOutline)
          Text("Explore GRI Campus", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
        }

        Surface(
          shape = RoundedCornerShape(999.dp),
          color = GriForestFixed
        ) {
          Row(
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Box(
              modifier = Modifier
                .size(6.dp)
                .clip(CircleShape)
                .background(GriForestPrimary)
            )
            Spacer(modifier = Modifier.width(4.dp))
            Text("300 Acres Open", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriForestOnFixed)
          }
        }
      }

      // Segmented View Toggle: Interactive Map vs Directory
      Row(
        modifier = Modifier
          .fillMaxWidth()
          .clip(RoundedCornerShape(10.dp))
          .background(GriSurfaceContainerLow)
          .padding(3.dp),
        horizontalArrangement = Arrangement.spacedBy(4.dp)
      ) {
        Surface(
          shape = RoundedCornerShape(8.dp),
          color = if (activeTab == 0) GriForestPrimary else Color.Transparent,
          modifier = Modifier
            .weight(1f)
            .clickable { activeTab = 0 }
            .testTag("tab_interactive_map")
        ) {
          Row(
            modifier = Modifier.padding(vertical = 7.dp),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Icon(
              imageVector = Icons.Default.Map,
              contentDescription = null,
              tint = if (activeTab == 0) Color.White else GriOnSurfaceVariant,
              modifier = Modifier.size(15.dp)
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
              text = "Campus Map (Grid)",
              fontSize = 12.sp,
              fontWeight = FontWeight.Bold,
              color = if (activeTab == 0) Color.White else GriOnSurfaceVariant
            )
          }
        }

        Surface(
          shape = RoundedCornerShape(8.dp),
          color = if (activeTab == 1) GriForestPrimary else Color.Transparent,
          modifier = Modifier
            .weight(1f)
            .clickable { activeTab = 1 }
            .testTag("tab_facilities_directory")
        ) {
          Row(
            modifier = Modifier.padding(vertical = 7.dp),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Icon(
              imageVector = Icons.Default.List,
              contentDescription = null,
              tint = if (activeTab == 1) Color.White else GriOnSurfaceVariant,
              modifier = Modifier.size(15.dp)
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
              text = "Directory & Shuttles",
              fontSize = 12.sp,
              fontWeight = FontWeight.Bold,
              color = if (activeTab == 1) Color.White else GriOnSurfaceVariant
            )
          }
        }
      }
    }

    if (activeTab == 0) {
      // FULL INTERACTIVE CAMPUS MAP VIEW (Grid layout, clickable building markers, zoom & pan gestures)
      CampusMapView(
        modifier = Modifier
          .fillMaxWidth()
          .weight(1f)
      )
    } else {
      // LANDMARKS & DIRECTORY LAZY COLUMN
      LazyColumn(
        modifier = Modifier
          .fillMaxSize()
          .testTag("campus_explore_screen"),
        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 10.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp)
      ) {

        // 2. SEARCH & FILTER PILLS
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
                Text("Search departments, hostels, guest house...", fontSize = 12.sp, color = GriOutline)
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
          items(filters) { cat ->
            val isSelected = selectedFilter == cat
            Surface(
              shape = RoundedCornerShape(999.dp),
              color = if (isSelected) GriForestPrimary else GriSurfaceContainerLow,
              modifier = Modifier.clickable { selectedFilter = cat }
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

    // 3. VECTOR STYLIZED CAMPUS MAP GRAPHIC
    item {
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("card_vector_campus_map"),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
      ) {
        Column(modifier = Modifier.padding(14.dp)) {
          Box(
            modifier = Modifier
              .fillMaxWidth()
              .height(160.dp)
              .clip(RoundedCornerShape(10.dp))
              .background(GriForestContainer)
          ) {
            // Stylized Campus Map Layout Drawn on Canvas
            Canvas(modifier = Modifier.fillMaxSize()) {
              val w = size.width
              val h = size.height

              // Roads (Ring Road & NH44)
              drawLine(color = Color.White.copy(alpha = 0.35f), start = Offset(0f, h * 0.4f), end = Offset(w, h * 0.6f), strokeWidth = 8f)
              drawLine(color = Color.White.copy(alpha = 0.25f), start = Offset(w * 0.4f, 0f), end = Offset(w * 0.5f, h), strokeWidth = 6f)

              // Academic Green Zones
              drawCircle(color = GriForestOnContainer.copy(alpha = 0.3f), radius = 55f, center = Offset(w * 0.25f, h * 0.35f))
              drawCircle(color = GriTealContainer.copy(alpha = 0.3f), radius = 45f, center = Offset(w * 0.7f, h * 0.5f))
              drawCircle(color = GriOchreContainer.copy(alpha = 0.35f), radius = 35f, center = Offset(w * 0.5f, h * 0.3f))

              // Gandhi Pillar / Memorial Landmark Pin
              drawCircle(color = Color.White, radius = 7f, center = Offset(w * 0.48f, h * 0.38f))
              drawCircle(color = GriOchreOnContainer, radius = 4f, center = Offset(w * 0.48f, h * 0.38f))

              // Library Pin
              drawCircle(color = Color.White, radius = 6f, center = Offset(w * 0.68f, h * 0.48f))
              drawCircle(color = GriForestPrimary, radius = 3.5f, center = Offset(w * 0.68f, h * 0.48f))
            }

            // Floating Location Tag
            Surface(
              shape = RoundedCornerShape(999.dp),
              color = Color.White.copy(alpha = 0.95f),
              modifier = Modifier
                .align(Alignment.TopStart)
                .padding(10.dp)
            ) {
              Row(
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
                verticalAlignment = Alignment.CenterVertically
              ) {
                Icon(Icons.Default.LocationOn, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(12.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Near Admin Block • Gate 1 NH44", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
              }
            }
          }

          Spacer(modifier = Modifier.height(10.dp))

          Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
          ) {
            Column(modifier = Modifier.weight(1f)) {
              Text("Spatial Campus Guide", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
              Text("Walking routes, e-cart shuttle stops & offline vector zones.", fontSize = 11.sp, color = GriOnSurfaceVariant)
            }

            Button(
              onClick = { activeTab = 0 },
              shape = RoundedCornerShape(8.dp),
              colors = ButtonDefaults.buttonColors(containerColor = GriForestPrimary, contentColor = Color.White),
              contentPadding = PaddingValues(horizontal = 10.dp, vertical = 6.dp)
            ) {
              Icon(Icons.Default.Map, contentDescription = null, modifier = Modifier.size(13.dp))
              Spacer(modifier = Modifier.width(4.dp))
              Text("Interactive Grid", fontSize = 11.sp, fontWeight = FontWeight.Bold)
            }
          }
        }
      }
    }

    // 4. KEY CENTERS & LANDMARKS
    item {
      Text(
        text = "Key Centers & Landmarks (${filteredLandmarks.size})",
        fontSize = 15.sp,
        fontWeight = FontWeight.Bold,
        color = GriOnSurface
      )
    }

    items(filteredLandmarks) { item ->
      Card(
        modifier = Modifier
          .fillMaxWidth()
          .testTag("landmark_${item.id}"),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.5.dp)
      ) {
        Row(
          modifier = Modifier
            .fillMaxWidth()
            .padding(12.dp),
          verticalAlignment = Alignment.Top
        ) {
          Box(
            modifier = Modifier
              .size(38.dp)
              .clip(RoundedCornerShape(8.dp))
              .background(GriSurfaceContainerLow),
            contentAlignment = Alignment.Center
          ) {
            Icon(imageVector = item.icon, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(20.dp))
          }

          Spacer(modifier = Modifier.width(12.dp))

          Column(modifier = Modifier.weight(1f)) {
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.CenterVertically
            ) {
              Text(
                text = item.name,
                fontSize = 13.sp,
                fontWeight = FontWeight.Bold,
                color = GriOnSurface,
                modifier = Modifier.weight(1f)
              )
              Text(
                text = item.distance,
                fontSize = 10.sp,
                fontWeight = FontWeight.Bold,
                color = GriTealSecondary
              )
            }

            Text(
              text = item.description,
              fontSize = 11.sp,
              color = GriOnSurfaceVariant,
              modifier = Modifier.padding(top = 2.dp, bottom = 6.dp)
            )

            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
              Surface(
                shape = RoundedCornerShape(6.dp),
                color = GriSurfaceContainerLow,
                modifier = Modifier.clickable { activeTab = 0 }
              ) {
                Row(
                  modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp),
                  verticalAlignment = Alignment.CenterVertically
                ) {
                  Icon(Icons.AutoMirrored.Filled.DirectionsWalk, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(12.dp))
                  Spacer(modifier = Modifier.width(3.dp))
                  Text("Walking Path", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
                }
              }

              Surface(
                shape = RoundedCornerShape(6.dp),
                color = GriSurfaceContainer,
                modifier = Modifier.clickable {
                  val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
                  try { context.startActivity(intent) } catch (_: Exception) {}
                }
              ) {
                Text(
                  text = item.actionLabel,
                  fontSize = 10.sp,
                  fontWeight = FontWeight.SemiBold,
                  color = GriOnSurface,
                  modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                )
              }
            }
          }
        }
      }
    }

    // 5. TRANSIT & DAILY SERVICES (SHUTTLES, CAFE, CO-OP)
    item {
      Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text("Transit & Daily Campus Life", fontSize = 15.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)

        // Shuttle Bus Departure Board
        Surface(
          shape = RoundedCornerShape(12.dp),
          color = GriSurfaceContainerLowest,
          modifier = Modifier.fillMaxWidth()
        ) {
          Column(modifier = Modifier.padding(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
              Icon(Icons.Default.DirectionsBus, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(16.dp))
              Spacer(modifier = Modifier.width(6.dp))
              Text("University Shuttle Departures", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
            }
            Spacer(modifier = Modifier.height(8.dp))
            ShuttleRow(time = "08:15 AM", route = "Dindigul Jn <-> Campus", status = "Departs in 20m")
            ShuttleRow(time = "09:00 AM", route = "Madurai Periyar <-> Campus", status = "On Schedule")
            ShuttleRow(time = "09:45 AM", route = "Chinnalapatti Terminus", status = "Eco E-Cart")
          }
        }

        // Cafeteria & Co-op Society Cards
        Row(
          modifier = Modifier.fillMaxWidth(),
          horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
          // Cafeteria Card
          Surface(
            shape = RoundedCornerShape(12.dp),
            color = GriSurfaceContainerLowest,
            modifier = Modifier.weight(1f)
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Icon(Icons.Default.Fastfood, contentDescription = null, tint = GriOchreContainer, modifier = Modifier.size(18.dp))
              Spacer(modifier = Modifier.height(4.dp))
              Text("University Canteen", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
              Text("Open • Ragi Sevai & Herbal Soup", fontSize = 10.sp, color = GriOnSurfaceVariant)
            }
          }

          // Co-op Card
          Surface(
            shape = RoundedCornerShape(12.dp),
            color = GriSurfaceContainerLowest,
            modifier = Modifier.weight(1f)
          ) {
            Column(modifier = Modifier.padding(12.dp)) {
              Icon(Icons.Default.ShoppingBag, contentDescription = null, tint = GriTealSecondary, modifier = Modifier.size(18.dp))
              Spacer(modifier = Modifier.height(4.dp))
              Text("Khadi & Co-op Store", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = GriOnSurface)
              Text("20% Student Discount", fontSize = 10.sp, color = GriOnSurfaceVariant)
            }
          }
        }
      }
    }
  }
}
}
}

@Composable
fun ShuttleRow(time: String, route: String, status: String) {
  Row(
    modifier = Modifier
      .fillMaxWidth()
      .padding(vertical = 4.dp),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
  ) {
    Row(verticalAlignment = Alignment.CenterVertically) {
      Text(time, fontSize = 11.sp, fontWeight = FontWeight.Bold, color = GriForestPrimary)
      Spacer(modifier = Modifier.width(8.dp))
      Text(route, fontSize = 11.sp, color = GriOnSurface, maxLines = 1, overflow = TextOverflow.Ellipsis)
    }

    Surface(
      shape = RoundedCornerShape(999.dp),
      color = GriSurfaceContainerLow
    ) {
      Text(
        text = status,
        fontSize = 9.sp,
        fontWeight = FontWeight.Medium,
        color = GriTealSecondary,
        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
      )
    }
  }
}
