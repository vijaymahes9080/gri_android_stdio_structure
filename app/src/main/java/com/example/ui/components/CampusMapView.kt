package com.example.ui.components

import android.content.Intent
import android.net.Uri
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.DirectionsWalk
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Agriculture
import androidx.compose.material.icons.filled.Apartment
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.DirectionsBus
import androidx.compose.material.icons.filled.Explore
import androidx.compose.material.icons.filled.FitnessCenter
import androidx.compose.material.icons.filled.GridOn
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.LocalHospital
import androidx.compose.material.icons.filled.LocalLibrary
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Museum
import androidx.compose.material.icons.filled.MyLocation
import androidx.compose.material.icons.filled.Navigation
import androidx.compose.material.icons.filled.Remove
import androidx.compose.material.icons.filled.RestartAlt
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.SolarPower
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.theme.GriForestContainer
import com.example.ui.theme.GriForestFixed
import com.example.ui.theme.GriForestOnContainer
import com.example.ui.theme.GriForestOnFixed
import com.example.ui.theme.GriForestPrimary
import com.example.ui.theme.GriOchreContainer
import com.example.ui.theme.GriOchreTertiary
import com.example.ui.theme.GriOchreFixed
import com.example.ui.theme.GriOchreOnContainer
import com.example.ui.theme.GriOnSurface
import com.example.ui.theme.GriOnSurfaceVariant
import com.example.ui.theme.GriOutline
import com.example.ui.theme.GriSurfaceContainer
import com.example.ui.theme.GriSurfaceContainerHigh
import com.example.ui.theme.GriSurfaceContainerLow
import com.example.ui.theme.GriSurfaceContainerLowest
import com.example.ui.theme.GriTealContainer
import com.example.ui.theme.GriTealOnContainer
import com.example.ui.theme.GriTealSecondary
import kotlin.math.roundToInt
import kotlin.math.sqrt

enum class CampusZoneCategory(val label: String, val color: Color, val onColor: Color) {
  ADMIN("Administration", GriTealSecondary, Color.White),
  ACADEMIC("Academics & Labs", GriForestPrimary, Color.White),
  HERITAGE("Gandhian Heritage", GriOchreTertiary, Color.White),
  RESIDENTIAL("Hostels & Living", Color(0xFF3F51B5), Color.White),
  HEALTH("Health & Care", Color(0xFFC2185B), Color.White),
  SPORTS("Sports & Wellness", Color(0xFF00796B), Color.White),
  UTILITY("Green Energy & Transit", Color(0xFFE65100), Color.White)
}

data class GriBuilding(
  val id: String,
  val code: String,
  val name: String,
  val shortName: String,
  val sector: String, // e.g. "B2"
  val gridCol: Int, // 0..3 (A..D)
  val gridRow: Int, // 0..3 (1..4)
  val normX: Float, // 0.0f..1.0f on campus canvas
  val normY: Float, // 0.0f..1.0f on campus canvas
  val category: CampusZoneCategory,
  val icon: ImageVector,
  val description: String,
  val facilities: List<String>,
  val hours: String = "09:00 AM - 05:30 PM",
  val phoneExt: String = "Ext 200",
  val walkingTimeMins: Int = 4
)

// The primary buildings on the 300-acre Gandhigram Rural Institute Campus
val griPrimaryBuildings = listOf(
  GriBuilding(
    id = "admin_bhavan",
    code = "ADM-01",
    name = "Administrative Bhavan & VC Secretariat",
    shortName = "Admin Block",
    sector = "B2",
    gridCol = 1,
    gridRow = 1,
    normX = 0.42f,
    normY = 0.36f,
    category = CampusZoneCategory.ADMIN,
    icon = Icons.Default.School,
    description = "Statutory headquarters housing the Vice-Chancellor's Secretariat, Registrar, Controller of Examinations (COE) and Senate Hall.",
    facilities = listOf("VC Office", "Registrar Wing", "COE Exam Cell", "Senate Chamber"),
    hours = "09:30 AM - 05:30 PM (Mon-Fri)",
    phoneExt = "Ext 101 / 102",
    walkingTimeMins = 3
  ),
  GriBuilding(
    id = "central_library",
    code = "LIB-01",
    name = "Dr. G. Ramachandran Central Library",
    shortName = "Central Library",
    sector = "C2",
    gridCol = 2,
    gridRow = 1,
    normX = 0.65f,
    normY = 0.38f,
    category = CampusZoneCategory.ACADEMIC,
    icon = Icons.Default.LocalLibrary,
    description = "Premier research facility with 1,75,000+ print volumes, 24x7 Digital Wing, RFID automated loan desks, and rare Gandhian archives.",
    facilities = listOf("RFID Self-Checkout", "Digital Reference Lab", "Gandhian Archive", "24x7 Reading Hall"),
    hours = "08:00 AM - 08:00 PM (Reading Room 24x7)",
    phoneExt = "Ext 225",
    walkingTimeMins = 4
  ),
  GriBuilding(
    id = "crd_pr",
    code = "RUR-01",
    name = "Centre for Rural Development & Panchayati Raj",
    shortName = "CRD & PR Lab",
    sector = "B3",
    gridCol = 1,
    gridRow = 2,
    normX = 0.38f,
    normY = 0.58f,
    category = CampusZoneCategory.HERITAGE,
    icon = Icons.Default.Explore,
    description = "Pioneering grassroots rural institute lab conducting village field internships, participatory panchayat planning, and rural technology transfer.",
    facilities = listOf("Panchayat Simulation Hall", "GIS Mapping Lab", "Field Immersion Desk", "Village Survey Cell"),
    hours = "09:00 AM - 05:00 PM",
    phoneExt = "Ext 310",
    walkingTimeMins = 5
  ),
  GriBuilding(
    id = "agri_school",
    code = "AGR-01",
    name = "Faculty of Agriculture & Animal Husbandry",
    shortName = "Agri Faculty",
    sector = "A2",
    gridCol = 0,
    gridRow = 1,
    normX = 0.16f,
    normY = 0.40f,
    category = CampusZoneCategory.ACADEMIC,
    icon = Icons.Default.Agriculture,
    description = "ICAR-accredited agricultural school featuring experimental farm research plots, polyhouse nurseries, organic soil labs, and dairy herds.",
    facilities = listOf("Organic Farm Plots", "Soil Testing Lab", "Dairy & Apiary Unit", "Polyhouse Nursery"),
    hours = "08:30 AM - 05:00 PM",
    phoneExt = "Ext 405",
    walkingTimeMins = 7
  ),
  GriBuilding(
    id = "kasturba_hospital",
    code = "MED-01",
    name = "Kasturba Hospital & Campus Health Centre",
    shortName = "Kasturba Hospital",
    sector = "C1",
    gridCol = 2,
    gridRow = 0,
    normX = 0.62f,
    normY = 0.18f,
    category = CampusZoneCategory.HEALTH,
    icon = Icons.Default.LocalHospital,
    description = "24x7 campus medical center serving students, staff, and surrounding rural hamlets with emergency trauma care and subsidized dispensary.",
    facilities = listOf("24x7 Emergency Room", "Resident Doctor", "Pharmacy", "Ambulance Bay"),
    hours = "24 Hours Emergency",
    phoneExt = "Ext 222 (Emergency)",
    walkingTimeMins = 5
  ),
  GriBuilding(
    id = "gandhi_museum",
    code = "MUS-01",
    name = "Gandhian Memorial Museum & Khadi Unit",
    shortName = "Gandhi Museum",
    sector = "B1",
    gridCol = 1,
    gridRow = 0,
    normX = 0.40f,
    normY = 0.16f,
    category = CampusZoneCategory.HERITAGE,
    icon = Icons.Default.Museum,
    description = "Sacred historic complex with the Prayer Ground, Gandhi Peace Charkha archive, spinning guild, and photo gallery of Mahatma Gandhi's 1946 visit.",
    facilities = listOf("Historic Prayer Ground", "Charkha Spinning Unit", "Khadi Sales Outlet", "Peace Memorial"),
    hours = "09:00 AM - 06:00 PM",
    phoneExt = "Ext 115",
    walkingTimeMins = 4
  ),
  GriBuilding(
    id = "convocation_hall",
    code = "AUD-01",
    name = "Multi-Purpose Convocation Auditorium",
    shortName = "Convocation Hall",
    sector = "C3",
    gridCol = 2,
    gridRow = 2,
    normX = 0.68f,
    normY = 0.62f,
    category = CampusZoneCategory.ACADEMIC,
    icon = Icons.Default.School,
    description = "Air-conditioned 1,800-seat university auditorium for convocations, national symposia, youth festivals, and cultural performances.",
    facilities = listOf("1800 Main Auditorium", "Acoustic Stage", "VIP Green Rooms", "Audio-Visual Console"),
    hours = "Event Based",
    phoneExt = "Ext 180",
    walkingTimeMins = 6
  ),
  GriBuilding(
    id = "student_hostels",
    code = "HOS-01",
    name = "Thamarai & Malligai Student Hostels",
    shortName = "Student Hostels",
    sector = "D3",
    gridCol = 3,
    gridRow = 2,
    normX = 0.86f,
    normY = 0.66f,
    category = CampusZoneCategory.RESIDENTIAL,
    icon = Icons.Default.Apartment,
    description = "Hostel quadrangle with dining messes, study halls, high-speed Wi-Fi, solar hot water, and 24x7 warden assistance.",
    facilities = listOf("RO Water Plants", "Organic Mess Halls", "Common Reading Rooms", "Indoor Game Lounge"),
    hours = "Gate Hours 06:00 AM - 08:30 PM",
    phoneExt = "Ext 501 / 502",
    walkingTimeMins = 8
  ),
  GriBuilding(
    id = "solar_microgrid",
    code = "ENG-01",
    name = "Solar Microgrid & Clean Energy Park",
    shortName = "Solar Microgrid",
    sector = "A3",
    gridCol = 0,
    gridRow = 2,
    normX = 0.18f,
    normY = 0.68f,
    category = CampusZoneCategory.UTILITY,
    icon = Icons.Default.SolarPower,
    description = "1.2 MW photovoltaic campus grid power station with grid-tied inverters, solar tracking tests, and biogas slurry demo facility.",
    facilities = listOf("1.2 MW PV Farm", "Weather Monitoring Tower", "Biogas Demo", "Battery Storage Bank"),
    hours = "Technical Visits on Request",
    phoneExt = "Ext 430",
    walkingTimeMins = 9
  ),
  GriBuilding(
    id = "sports_pavilion",
    code = "SPT-01",
    name = "Indoor Sports Complex & Stadium",
    shortName = "Sports Pavilion",
    sector = "D2",
    gridCol = 3,
    gridRow = 1,
    normX = 0.88f,
    normY = 0.35f,
    category = CampusZoneCategory.SPORTS,
    icon = Icons.Default.FitnessCenter,
    description = "Multi-court indoor wooden badminton courts, gymnasium, 400m running track, basketball pavilion, and kabaddi arena.",
    facilities = listOf("Synthetic Track", "Gymnasium", "Badminton Wooden Courts", "Cricket Oval"),
    hours = "06:00 AM - 08:30 AM & 04:30 PM - 07:30 PM",
    phoneExt = "Ext 610",
    walkingTimeMins = 7
  ),
  GriBuilding(
    id = "main_gate",
    code = "GT-01",
    name = "Main University Gate 1 (NH-44)",
    shortName = "Gate 1 (NH-44)",
    sector = "B4",
    gridCol = 1,
    gridRow = 3,
    normX = 0.44f,
    normY = 0.90f,
    category = CampusZoneCategory.UTILITY,
    icon = Icons.Default.DirectionsBus,
    description = "Primary transit gateway connecting Dindigul-Madurai NH-44 with e-cart shuttle terminus, visitor entry passes, and automated barrier.",
    facilities = listOf("Security Checkpoint", "E-Shuttle Terminus", "Visitor Registry", "Auto Stand"),
    hours = "Open 24x7",
    phoneExt = "Ext 100",
    walkingTimeMins = 2
  )
)

/**
 * Interactive Campus Map View with:
 * - Spatial 4x4 Sector Grid (A1 to D4)
 * - Two-finger Zoom & Pan gesture handler (clamped between 0.75x and 3.5x)
 * - Clickable Building Markers with sector badge and animated focus halo
 * - Floating on-screen zoom in / out / reset controls
 * - Grid overlay toggle & Sector quick-jump pills
 * - Detailed building inspector bottom-card
 */
@Composable
fun CampusMapView(
  modifier: Modifier = Modifier,
  onNavigateExternalMap: () -> Unit = {}
) {
  val context = LocalContext.current
  val density = LocalDensity.current

  // Zoom and Pan states
  var scale by remember { mutableFloatStateOf(1.0f) }
  var offset by remember { mutableStateOf(Offset.Zero) }

  // Map settings
  var showGridOverlay by remember { mutableStateOf(true) }
  var showRoadNames by remember { mutableStateOf(true) }
  var selectedCategoryFilter by remember { mutableStateOf<CampusZoneCategory?>(null) }
  var selectedBuilding by remember { mutableStateOf<GriBuilding?>(griPrimaryBuildings.first()) }

  // Pulsing animation for selected marker
  val infiniteTransition = rememberInfiniteTransition(label = "marker_pulse")
  val pulseScale by infiniteTransition.animateFloat(
    initialValue = 1.0f,
    targetValue = 1.5f,
    animationSpec = infiniteRepeatable(
      animation = tween(1200),
      repeatMode = RepeatMode.Reverse
    ),
    label = "pulse_scale"
  )

  val filteredBuildings = remember(selectedCategoryFilter) {
    if (selectedCategoryFilter == null) {
      griPrimaryBuildings
    } else {
      griPrimaryBuildings.filter { it.category == selectedCategoryFilter }
    }
  }

  Column(
    modifier = modifier
      .fillMaxSize()
      .background(GriSurfaceContainerLowest)
      .testTag("interactive_campus_map_view")
  ) {

    // 1. TOP STATUS & QUICK CONTROLS BAR
    Row(
      modifier = Modifier
        .fillMaxWidth()
        .padding(horizontal = 14.dp, vertical = 8.dp),
      horizontalArrangement = Arrangement.SpaceBetween,
      verticalAlignment = Alignment.CenterVertically
    ) {
      Column {
        Row(verticalAlignment = Alignment.CenterVertically) {
          Box(
            modifier = Modifier
              .size(8.dp)
              .clip(CircleShape)
              .background(GriForestPrimary)
          )
          Spacer(modifier = Modifier.width(6.dp))
          Text(
            text = "GRI SPATIAL CAMPUS GRID",
            fontSize = 11.sp,
            fontWeight = FontWeight.Bold,
            color = GriForestPrimary,
            letterSpacing = 0.5.sp
          )
        }
        Text(
          text = "Pinch to zoom • Drag to pan • Tap markers",
          fontSize = 10.sp,
          color = GriOnSurfaceVariant
        )
      }

      // Quick Action Buttons
      Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
        // Toggle Grid Lines Button
        Surface(
          shape = RoundedCornerShape(8.dp),
          color = if (showGridOverlay) GriForestPrimary else GriSurfaceContainerHigh,
          modifier = Modifier.clickable { showGridOverlay = !showGridOverlay }
        ) {
          Row(
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Icon(
              imageVector = Icons.Default.GridOn,
              contentDescription = "Toggle Grid",
              tint = if (showGridOverlay) Color.White else GriOnSurface,
              modifier = Modifier.size(13.dp)
            )
            Spacer(modifier = Modifier.width(4.dp))
            Text(
              text = if (showGridOverlay) "Grid On" else "Grid Off",
              fontSize = 10.sp,
              fontWeight = FontWeight.Bold,
              color = if (showGridOverlay) Color.White else GriOnSurface
            )
          }
        }

        // External Link to University Map
        Surface(
          shape = RoundedCornerShape(8.dp),
          color = GriSurfaceContainerHigh,
          modifier = Modifier.clickable {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
            try { context.startActivity(intent) } catch (_: Exception) {}
          }
        ) {
          Row(
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Icon(
              imageVector = Icons.Default.Navigation,
              contentDescription = "Official Map",
              tint = GriForestPrimary,
              modifier = Modifier.size(13.dp)
            )
            Spacer(modifier = Modifier.width(3.dp))
            Text(
              text = "Portal",
              fontSize = 10.sp,
              fontWeight = FontWeight.Bold,
              color = GriForestPrimary
            )
          }
        }
      }
    }

    // 2. CATEGORY FILTER CHIPS
    Row(
      modifier = Modifier
        .fillMaxWidth()
        .horizontalScroll(rememberScrollState())
        .padding(horizontal = 14.dp, vertical = 4.dp),
      horizontalArrangement = Arrangement.spacedBy(6.dp)
    ) {
      // All Filter Chip
      Surface(
        shape = RoundedCornerShape(999.dp),
        color = if (selectedCategoryFilter == null) GriForestPrimary else GriSurfaceContainerLow,
        modifier = Modifier.clickable { selectedCategoryFilter = null }
      ) {
        Text(
          text = "All Buildings (${griPrimaryBuildings.size})",
          fontSize = 11.sp,
          fontWeight = if (selectedCategoryFilter == null) FontWeight.Bold else FontWeight.Medium,
          color = if (selectedCategoryFilter == null) Color.White else GriOnSurfaceVariant,
          modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp)
        )
      }

      CampusZoneCategory.values().forEach { category ->
        val isSelected = selectedCategoryFilter == category
        Surface(
          shape = RoundedCornerShape(999.dp),
          color = if (isSelected) category.color else GriSurfaceContainerLow,
          modifier = Modifier.clickable {
            selectedCategoryFilter = if (isSelected) null else category
          }
        ) {
          Text(
            text = category.label,
            fontSize = 11.sp,
            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
            color = if (isSelected) category.onColor else GriOnSurfaceVariant,
            modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp)
          )
        }
      }
    }

    // 3. THE INTERACTIVE ZOOM & PAN CANVAS WITH GRID
    BoxWithConstraints(
      modifier = Modifier
        .fillMaxWidth()
        .weight(1f)
        .padding(horizontal = 10.dp, vertical = 6.dp)
        .clip(RoundedCornerShape(16.dp))
        .background(Color(0xFFE8EFE8)) // Soft institutional campus lawn tone
        .border(1.dp, GriForestPrimary.copy(alpha = 0.2f), RoundedCornerShape(16.dp))
        .testTag("campus_map_canvas_container")
    ) {
      val containerWidthPx = constraints.maxWidth.toFloat()
      val containerHeightPx = constraints.maxHeight.toFloat()

      // Map gesture detector
      Box(
        modifier = Modifier
          .fillMaxSize()
          .pointerInput(Unit) {
            // Zoom & Pan Gesture Detection
            detectTransformGestures { centroid, pan, zoom, _ ->
              val newScale = (scale * zoom).coerceIn(0.75f, 3.5f)
              // Limit pan offset so map doesn't fly off screen
              val maxPanX = containerWidthPx * (newScale - 0.5f)
              val maxPanY = containerHeightPx * (newScale - 0.5f)

              val newOffset = Offset(
                x = (offset.x + pan.x).coerceIn(-maxPanX, maxPanX),
                y = (offset.y + pan.y).coerceIn(-maxPanY, maxPanY)
              )

              scale = newScale
              offset = newOffset
            }
          }
          .pointerInput(filteredBuildings, scale, offset) {
            // Tap gesture detection for markers
            detectTapGestures { tapOffset ->
              // Convert screen tap offset to world canvas coordinate (0.0f..1.0f)
              val canvasX = (tapOffset.x - offset.x - (containerWidthPx * (1f - scale) / 2f)) / (containerWidthPx * scale)
              val canvasY = (tapOffset.y - offset.y - (containerHeightPx * (1f - scale) / 2f)) / (containerHeightPx * scale)

              // Check if any building is close to tap
              val thresholdDist = 0.08f / scale
              var closestBuilding: GriBuilding? = null
              var minDist = Float.MAX_VALUE

              for (b in filteredBuildings) {
                val dx = b.normX - canvasX
                val dy = b.normY - canvasY
                val dist = sqrt(dx * dx + dy * dy)
                if (dist < thresholdDist && dist < minDist) {
                  minDist = dist
                  closestBuilding = b
                }
              }

              if (closestBuilding != null) {
                selectedBuilding = closestBuilding
              }
            }
          }
      ) {
        // Transformed Graphic Map Layer
        Canvas(
          modifier = Modifier
            .fillMaxSize()
            .graphicsLayer {
              scaleX = scale
              scaleY = scale
              translationX = offset.x
              translationY = offset.y
            }
        ) {
          val w = size.width
          val h = size.height

          // --- CAMPUS TERRAIN & ZONES ---
          // Agro Farm (West)
          drawRoundRect(
            color = Color(0xFFD4E6D2),
            topLeft = Offset(w * 0.05f, h * 0.1f),
            size = Size(w * 0.25f, h * 0.75f),
            cornerRadius = CornerRadius(20f, 20f)
          )

          // Central Heritage Quadrangle
          drawRoundRect(
            color = Color(0xFFFCF7EE),
            topLeft = Offset(w * 0.32f, h * 0.1f),
            size = Size(w * 0.38f, h * 0.65f),
            cornerRadius = CornerRadius(24f, 24f)
          )

          // Academic Science & Tech Sector
          drawRoundRect(
            color = Color(0xFFE2EFF6),
            topLeft = Offset(w * 0.58f, h * 0.12f),
            size = Size(w * 0.28f, h * 0.55f),
            cornerRadius = CornerRadius(20f, 20f)
          )

          // East Residential Complex & Stadium
          drawRoundRect(
            color = Color(0xFFECEBFA),
            topLeft = Offset(w * 0.75f, h * 0.25f),
            size = Size(w * 0.22f, h * 0.55f),
            cornerRadius = CornerRadius(20f, 20f)
          )

          // Kasturba Water Harvesting Pond (Amrit Sarovar)
          val pondPath = Path().apply {
            moveTo(w * 0.55f, h * 0.14f)
            cubicTo(w * 0.58f, h * 0.10f, w * 0.65f, h * 0.12f, w * 0.66f, h * 0.17f)
            cubicTo(w * 0.67f, h * 0.22f, w * 0.60f, h * 0.25f, w * 0.56f, h * 0.22f)
            close()
          }
          drawPath(pondPath, color = Color(0xFF90CAF9).copy(alpha = 0.7f))

          // --- ROAD ARTERIAL NETWORK ---
          // NH-44 Highway (South perimeter)
          val highwayY = h * 0.94f
          drawLine(
            color = Color(0xFF546E7A),
            start = Offset(0f, highwayY),
            end = Offset(w, highwayY),
            strokeWidth = 14f
          )
          // Highway Dashed Yellow Divider
          drawLine(
            color = Color(0xFFFFD54F),
            start = Offset(0f, highwayY),
            end = Offset(w, highwayY),
            strokeWidth = 2.5f,
            pathEffect = PathEffect.dashPathEffect(floatArrayOf(15f, 15f), 0f)
          )

          // Gandhi Memorial Ring Road (Loops around central campus)
          val ringRoad = Path().apply {
            moveTo(w * 0.44f, highwayY) // From Gate 1 NH44
            lineTo(w * 0.44f, h * 0.75f)
            cubicTo(w * 0.35f, h * 0.70f, w * 0.32f, h * 0.45f, w * 0.34f, h * 0.25f)
            cubicTo(w * 0.36f, h * 0.10f, w * 0.65f, h * 0.10f, w * 0.72f, h * 0.25f)
            cubicTo(w * 0.76f, h * 0.45f, w * 0.75f, h * 0.70f, w * 0.68f, h * 0.75f)
            lineTo(w * 0.44f, h * 0.75f)
          }
          drawPath(
            ringRoad,
            color = Color(0xFFB0BEC5),
            style = Stroke(width = 8f)
          )

          // East-West Rural Tech Corridor
          drawLine(
            color = Color(0xFFCFD8DC),
            start = Offset(w * 0.15f, h * 0.48f),
            end = Offset(w * 0.88f, h * 0.48f),
            strokeWidth = 6f
          )

          // North-South Central Spine (Swaraj Path)
          drawLine(
            color = Color(0xFFCFD8DC),
            start = Offset(w * 0.50f, h * 0.10f),
            end = Offset(w * 0.50f, h * 0.75f),
            strokeWidth = 6f
          )

          // --- 4x4 SECTOR GRID OVERLAY (A1 - D4) ---
          if (showGridOverlay) {
            val gridCols = 4
            val gridRows = 4
            val colLabels = listOf("Sector A", "Sector B", "Sector C", "Sector D")
            val rowLabels = listOf("Row 1", "Row 2", "Row 3", "Row 4")

            // Vertical grid lines
            for (i in 1 until gridCols) {
              val x = w * (i.toFloat() / gridCols)
              drawLine(
                color = GriForestPrimary.copy(alpha = 0.25f),
                start = Offset(x, 0f),
                end = Offset(x, h),
                strokeWidth = 1.5f,
                pathEffect = PathEffect.dashPathEffect(floatArrayOf(8f, 8f), 0f)
              )
            }

            // Horizontal grid lines
            for (j in 1 until gridRows) {
              val y = h * (j.toFloat() / gridRows)
              drawLine(
                color = GriForestPrimary.copy(alpha = 0.25f),
                start = Offset(0f, y),
                end = Offset(w, y),
                strokeWidth = 1.5f,
                pathEffect = PathEffect.dashPathEffect(floatArrayOf(8f, 8f), 0f)
              )
            }

            // Sector Label Watermarks inside each grid cell (e.g., A1, B2, C3)
            val letters = listOf("A", "B", "C", "D")
            val numbers = listOf("1", "2", "3", "4")

            for (col in 0 until gridCols) {
              for (row in 0 until gridRows) {
                val sectorCode = "${letters[col]}${numbers[row]}"
                val cellX = w * (col.toFloat() / gridCols) + 12f
                val cellY = h * (row.toFloat() / gridRows) + 22f

                // Sector Tag in top-left of each cell
                drawContext.canvas.nativeCanvas.apply {
                  val paint = android.graphics.Paint().apply {
                    color = android.graphics.Color.argb(70, 27, 59, 34)
                    textSize = 18f
                    isFakeBoldText = true
                  }
                  drawText(sectorCode, cellX, cellY, paint)
                }
              }
            }
          }

          // Highlight selected building's sector grid box
          selectedBuilding?.let { building ->
            val gridCols = 4
            val gridRows = 4
            val cellW = w / gridCols
            val cellH = h / gridRows
            val cellLeft = building.gridCol * cellW
            val cellTop = building.gridRow * cellH

            drawRoundRect(
              color = GriOchreContainer.copy(alpha = 0.22f),
              topLeft = Offset(cellLeft, cellTop),
              size = Size(cellW, cellH),
              cornerRadius = CornerRadius(12f, 12f)
            )

            drawRoundRect(
              color = GriOchreTertiary.copy(alpha = 0.6f),
              topLeft = Offset(cellLeft, cellTop),
              size = Size(cellW, cellH),
              cornerRadius = CornerRadius(12f, 12f),
              style = Stroke(width = 2.5f)
            )
          }

          // --- DRAW BUILDING MARKERS ON CANVAS ---
          for (b in filteredBuildings) {
            val bx = w * b.normX
            val by = h * b.normY
            val isSelected = b.id == selectedBuilding?.id

            // Selection Animated Halo
            if (isSelected) {
              drawCircle(
                color = b.category.color.copy(alpha = 0.25f),
                radius = 32f * pulseScale,
                center = Offset(bx, by)
              )
              drawCircle(
                color = GriOchreTertiary.copy(alpha = 0.45f),
                radius = 24f,
                center = Offset(bx, by),
                style = Stroke(width = 3f)
              )
            }

            // Marker Pin Shadow
            drawCircle(
              color = Color.Black.copy(alpha = 0.25f),
              radius = 16f,
              center = Offset(bx, by + 4f)
            )

            // Marker Pin Outer Ring
            drawCircle(
              color = Color.White,
              radius = 16f,
              center = Offset(bx, by)
            )

            // Marker Pin Inner Category Color
            drawCircle(
              color = b.category.color,
              radius = 13f,
              center = Offset(bx, by)
            )

            // Center White Dot
            drawCircle(
              color = Color.White,
              radius = 5.5f,
              center = Offset(bx, by)
            )

            // Marker Label Pill (Visible when zoomed in or when selected)
            if (scale > 1.15f || isSelected) {
              val labelText = b.shortName
              drawContext.canvas.nativeCanvas.apply {
                val paint = android.graphics.Paint().apply {
                  color = if (isSelected) android.graphics.Color.WHITE else android.graphics.Color.argb(235, 255, 255, 255)
                  textSize = 20f
                  isFakeBoldText = true
                  textAlign = android.graphics.Paint.Align.CENTER
                }

                val bgPaint = android.graphics.Paint().apply {
                  color = if (isSelected) android.graphics.Color.argb(230, 27, 59, 34) else android.graphics.Color.argb(210, 40, 40, 40)
                  style = android.graphics.Paint.Style.FILL
                }

                val textBounds = android.graphics.Rect()
                paint.getTextBounds(labelText, 0, labelText.length, textBounds)

                val pillWidth = textBounds.width() + 24f
                val pillHeight = 28f
                val pillLeft = bx - (pillWidth / 2f)
                val pillTop = by + 22f

                drawRoundRect(
                  android.graphics.RectF(pillLeft, pillTop, pillLeft + pillWidth, pillTop + pillHeight),
                  14f, 14f, bgPaint
                )
                drawText(labelText, bx, pillTop + 20f, paint)
              }
            }
          }
        }

        // --- OVERLAY: FLOATING ZOOM & PAN TOOLBAR ---
        Column(
          modifier = Modifier
            .align(Alignment.TopEnd)
            .padding(10.dp),
          verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
          // Zoom In Button (+)
          Surface(
            shape = RoundedCornerShape(8.dp),
            color = GriSurfaceContainerLowest,
            shadowElevation = 2.dp,
            modifier = Modifier
              .size(36.dp)
              .clickable {
                scale = (scale + 0.25f).coerceAtMost(3.5f)
              }
              .testTag("btn_map_zoom_in")
          ) {
            Box(contentAlignment = Alignment.Center) {
              Icon(Icons.Default.Add, contentDescription = "Zoom In", tint = GriForestPrimary, modifier = Modifier.size(18.dp))
            }
          }

          // Zoom Out Button (-)
          Surface(
            shape = RoundedCornerShape(8.dp),
            color = GriSurfaceContainerLowest,
            shadowElevation = 2.dp,
            modifier = Modifier
              .size(36.dp)
              .clickable {
                scale = (scale - 0.25f).coerceAtLeast(0.75f)
              }
              .testTag("btn_map_zoom_out")
          ) {
            Box(contentAlignment = Alignment.Center) {
              Icon(Icons.Default.Remove, contentDescription = "Zoom Out", tint = GriForestPrimary, modifier = Modifier.size(18.dp))
            }
          }

          // Reset View Button (Center & 1.0x scale)
          Surface(
            shape = RoundedCornerShape(8.dp),
            color = GriSurfaceContainerLowest,
            shadowElevation = 2.dp,
            modifier = Modifier
              .size(36.dp)
              .clickable {
                scale = 1.0f
                offset = Offset.Zero
              }
              .testTag("btn_map_reset_view")
          ) {
            Box(contentAlignment = Alignment.Center) {
              Icon(Icons.Default.RestartAlt, contentDescription = "Reset Map View", tint = GriOnSurfaceVariant, modifier = Modifier.size(18.dp))
            }
          }

          // Re-center on Selected Building Button
          selectedBuilding?.let { b ->
            Surface(
              shape = RoundedCornerShape(8.dp),
              color = GriForestPrimary,
              shadowElevation = 2.dp,
              modifier = Modifier
                .size(36.dp)
                .clickable {
                  scale = 1.6f
                  val targetX = -((b.normX - 0.5f) * containerWidthPx * 1.6f)
                  val targetY = -((b.normY - 0.5f) * containerHeightPx * 1.6f)
                  offset = Offset(targetX, targetY)
                }
                .testTag("btn_map_center_selected")
            ) {
              Box(contentAlignment = Alignment.Center) {
                Icon(Icons.Default.MyLocation, contentDescription = "Center Selected Marker", tint = Color.White, modifier = Modifier.size(17.dp))
              }
            }
          }
        }

        // --- OVERLAY: BOTTOM-LEFT CURRENT ZOOM / SECTOR STATUS ---
        Surface(
          shape = RoundedCornerShape(999.dp),
          color = Color.White.copy(alpha = 0.92f),
          shadowElevation = 1.dp,
          modifier = Modifier
            .align(Alignment.BottomStart)
            .padding(10.dp)
        ) {
          Row(
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Icon(Icons.Default.Explore, contentDescription = null, tint = GriForestPrimary, modifier = Modifier.size(12.dp))
            Spacer(modifier = Modifier.width(4.dp))
            Text(
              text = "Zoom: ${(scale * 100).roundToInt()}% • ${selectedBuilding?.let { "Sector ${it.sector}" } ?: "All Sectors"}",
              fontSize = 10.sp,
              fontWeight = FontWeight.Bold,
              color = GriForestPrimary
            )
          }
        }
      }
    }

    // 4. QUICK BUILDING CAROUSEL PILLS (HORIZONTAL SCROLL)
    Text(
      text = "Primary Campus Buildings (Tap to Focus)",
      fontSize = 12.sp,
      fontWeight = FontWeight.Bold,
      color = GriOnSurface,
      modifier = Modifier.padding(horizontal = 14.dp, vertical = 4.dp)
    )

    Row(
      modifier = Modifier
        .fillMaxWidth()
        .horizontalScroll(rememberScrollState())
        .padding(horizontal = 14.dp, vertical = 2.dp),
      horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
      filteredBuildings.forEach { building ->
        val isSelected = building.id == selectedBuilding?.id
        Surface(
          shape = RoundedCornerShape(10.dp),
          color = if (isSelected) GriForestPrimary else GriSurfaceContainerLowest,
          border = if (isSelected) null else androidx.compose.foundation.BorderStroke(1.dp, GriSurfaceContainerHigh),
          shadowElevation = if (isSelected) 2.dp else 0.5.dp,
          modifier = Modifier
            .clickable {
              selectedBuilding = building
              // Auto pan towards the building
              scale = 1.5f
              offset = Offset(
                x = -((building.normX - 0.5f) * 600f),
                y = -((building.normY - 0.5f) * 400f)
              )
            }
            .testTag("chip_building_${building.id}")
        ) {
          Row(
            modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp),
            verticalAlignment = Alignment.CenterVertically
          ) {
            Box(
              modifier = Modifier
                .size(20.dp)
                .clip(CircleShape)
                .background(if (isSelected) Color.White.copy(alpha = 0.2f) else building.category.color.copy(alpha = 0.15f)),
              contentAlignment = Alignment.Center
            ) {
              Icon(
                imageVector = building.icon,
                contentDescription = null,
                tint = if (isSelected) Color.White else building.category.color,
                modifier = Modifier.size(12.dp)
              )
            }
            Spacer(modifier = Modifier.width(6.dp))
            Column {
              Text(
                text = building.shortName,
                fontSize = 11.sp,
                fontWeight = FontWeight.Bold,
                color = if (isSelected) Color.White else GriOnSurface
              )
              Text(
                text = "Sector ${building.sector} • ${building.code}",
                fontSize = 9.sp,
                color = if (isSelected) Color.White.copy(alpha = 0.8f) else GriOutline
              )
            }
          }
        }
      }
    }

    // 5. SELECTED BUILDING DETAIL INSPECTOR SHEET (COLLAPSIBLE / EXPANDABLE)
    AnimatedVisibility(
      visible = selectedBuilding != null,
      enter = slideInVertically(initialOffsetY = { it }) + fadeIn(),
      exit = slideOutVertically(targetOffsetY = { it }) + fadeOut()
    ) {
      selectedBuilding?.let { building ->
        Card(
          modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 12.dp, vertical = 8.dp)
            .testTag("card_selected_building_inspector"),
          shape = RoundedCornerShape(14.dp),
          colors = CardDefaults.cardColors(containerColor = GriSurfaceContainerLowest),
          elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
        ) {
          Column(modifier = Modifier.padding(14.dp)) {
            // Header Row: Icon, Name, Sector Pill, Close
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.SpaceBetween,
              verticalAlignment = Alignment.Top
            ) {
              Row(
                modifier = Modifier.weight(1f),
                verticalAlignment = Alignment.CenterVertically
              ) {
                Box(
                  modifier = Modifier
                    .size(36.dp)
                    .clip(RoundedCornerShape(8.dp))
                    .background(building.category.color.copy(alpha = 0.12f)),
                  contentAlignment = Alignment.Center
                ) {
                  Icon(
                    imageVector = building.icon,
                    contentDescription = null,
                    tint = building.category.color,
                    modifier = Modifier.size(20.dp)
                  )
                }

                Spacer(modifier = Modifier.width(10.dp))

                Column {
                  Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                      text = building.name,
                      fontSize = 13.sp,
                      fontWeight = FontWeight.Bold,
                      color = GriOnSurface,
                      maxLines = 1,
                      overflow = TextOverflow.Ellipsis
                    )
                  }
                  Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                    modifier = Modifier.padding(top = 2.dp)
                  ) {
                    // Sector Badge
                    Surface(
                      shape = RoundedCornerShape(4.dp),
                      color = GriForestPrimary.copy(alpha = 0.12f)
                    ) {
                      Text(
                        text = "Sector ${building.sector}",
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        color = GriForestPrimary,
                        modifier = Modifier.padding(horizontal = 5.dp, vertical = 1.dp)
                      )
                    }

                    // Category Badge
                    Surface(
                      shape = RoundedCornerShape(4.dp),
                      color = building.category.color.copy(alpha = 0.12f)
                    ) {
                      Text(
                        text = building.category.label,
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        color = building.category.color,
                        modifier = Modifier.padding(horizontal = 5.dp, vertical = 1.dp)
                      )
                    }

                    Text(
                      text = "${building.walkingTimeMins} min walk",
                      fontSize = 10.sp,
                      color = GriTealSecondary,
                      fontWeight = FontWeight.SemiBold
                    )
                  }
                }
              }

              // Close / Dismiss
              IconButton(
                onClick = { selectedBuilding = null },
                modifier = Modifier.size(28.dp)
              ) {
                Icon(
                  imageVector = Icons.Default.Close,
                  contentDescription = "Dismiss Details",
                  tint = GriOutline,
                  modifier = Modifier.size(16.dp)
                )
              }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Description
            Text(
              text = building.description,
              fontSize = 11.sp,
              color = GriOnSurfaceVariant,
              lineHeight = 16.sp
            )

            Spacer(modifier = Modifier.height(8.dp))

            // Key Facilities Tags
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
              building.facilities.take(3).forEach { fac ->
                Surface(
                  shape = RoundedCornerShape(6.dp),
                  color = GriSurfaceContainerLow
                ) {
                  Text(
                    text = "• $fac",
                    fontSize = 10.sp,
                    color = GriOnSurface,
                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                  )
                }
              }
            }

            Spacer(modifier = Modifier.height(10.dp))

            // Bottom Action Buttons: Walking Directions & Helpdesk Call
            Row(
              modifier = Modifier.fillMaxWidth(),
              horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
              Button(
                onClick = {
                  val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ruraluniv.ac.in/"))
                  try { context.startActivity(intent) } catch (_: Exception) {}
                },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(
                  containerColor = GriForestPrimary,
                  contentColor = Color.White
                ),
                contentPadding = PaddingValues(horizontal = 10.dp, vertical = 6.dp),
                modifier = Modifier
                  .weight(1f)
                  .testTag("btn_get_directions_${building.id}")
              ) {
                Icon(Icons.AutoMirrored.Filled.DirectionsWalk, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Walking Route (${building.walkingTimeMins}m)", fontSize = 11.sp, fontWeight = FontWeight.Bold)
              }

              Button(
                onClick = {
                  val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:04512452371"))
                  try { context.startActivity(intent) } catch (_: Exception) {}
                },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(
                  containerColor = GriSurfaceContainerHigh,
                  contentColor = GriForestPrimary
                ),
                contentPadding = PaddingValues(horizontal = 10.dp, vertical = 6.dp),
                modifier = Modifier.testTag("btn_call_building_${building.id}")
              ) {
                Icon(Icons.Default.Call, contentDescription = null, modifier = Modifier.size(14.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text(building.phoneExt, fontSize = 11.sp, fontWeight = FontWeight.Bold)
              }
            }
          }
        }
      }
    }
  }
}
