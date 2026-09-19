package com.example.ui.theme

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * The Gandhigram Rural Institute (Deemed to be University)
 * Official Design Tokens System
 */

object GriColors {
  // Stitch Primary Institutional Palette (Forest Green)
  val ForestPrimary = Color(0xFF003622)
  val ForestContainer = Color(0xFF134E35)
  val ForestOnContainer = Color(0xFF85BE9E)
  val ForestFixed = Color(0xFFB4F0CD)
  val ForestOnFixed = Color(0xFF002113)

  // Stitch Secondary Academic Palette (Academic Teal)
  val TealSecondary = Color(0xFF006A62)
  val TealContainer = Color(0xFF9CF2E6)
  val TealOnContainer = Color(0xFF047168)
  val TealFixed = Color(0xFF9CF2E6)
  val TealOnFixed = Color(0xFF00201D)

  // Stitch Tertiary Gandhian Heritage Saffron / Ochre
  val OchreTertiary = Color(0xFF4A2500)
  val OchreContainer = Color(0xFF6B3700)
  val OchreOnContainer = Color(0xFFFF993B)
  val OchreFixed = Color(0xFFFFDCC3)
  val OchreOnFixed = Color(0xFF2F1500)

  // Stitch Surfaces
  val Background = Color(0xFFF9F9FF)
  val Surface = Color(0xFFFFFFFF)
  val SurfaceLow = Color(0xFFF1F3FF)
  val SurfaceContainer = Color(0xFFE9EDFF)
  val SurfaceHigh = Color(0xFFE1E8FD)
  val SurfaceHighest = Color(0xFFDCE2F7)
  val SurfaceBorder = Color(0xFFC0C9C1)
  val SurfaceBorderFocused = Color(0xFF003622)

  // Typography Colors
  val TextPrimary = Color(0xFF141B2B)
  val TextSecondary = Color(0xFF404943)
  val TextMuted = Color(0xFF707972)
  val TextInverse = Color(0xFFFFFFFF)
  val TextGold = Color(0xFF6B3700)

  // Status & Semantic Feedback
  val Success = Color(0xFF059669)
  val SuccessContainer = Color(0xFFD1FAE5)
  val SuccessText = Color(0xFF065F46)

  val Alert = Color(0xFFBA1A1A)
  val AlertContainer = Color(0xFFFFDAD6)
  val AlertText = Color(0xFF93000A)

  val Warning = Color(0xFFD97706)
  val WarningContainer = Color(0xFFFFDCC3)
  val WarningText = Color(0xFF6E3900)

  val Info = Color(0xFF006A62)
  val InfoContainer = Color(0xFF9CF2E6)
  val InfoText = Color(0xFF047168)

  // Backwards compatibility mappings
  val NavyPrimary = ForestPrimary
  val NavyDeep = ForestContainer
  val NavySurface = ForestContainer
  val NavyContainer = ForestFixed
  val NavyOnContainer = ForestOnFixed

  val GoldAccent = OchreContainer
  val GoldDark = OchreTertiary
  val GoldLight = OchreFixed
  val GoldContainer = OchreFixed
  val GoldOnContainer = OchreOnFixed

  val RuralTerracotta = OchreContainer
  val RuralTerracottaLight = OchreFixed
  val RuralTerracottaDark = OchreTertiary

  val BackgroundIvory = Background
  val SurfaceSubtle = SurfaceLow
}

object GriSpacing {
  val none: Dp = 0.dp
  val xxs: Dp = 2.dp
  val xs: Dp = 4.dp
  val sm: Dp = 8.dp
  val md: Dp = 12.dp
  val lg: Dp = 16.dp
  val xl: Dp = 20.dp
  val xxl: Dp = 24.dp
  val xxxl: Dp = 32.dp
  val section: Dp = 40.dp
}

object GriRadius {
  val xs: Dp = 4.dp
  val sm: Dp = 6.dp
  val md: Dp = 10.dp
  val lg: Dp = 14.dp
  val xl: Dp = 18.dp
  val sheet: Dp = 24.dp
  val pill: Dp = 999.dp
}

object GriElevation {
  val none: Dp = 0.dp
  val card: Dp = 1.5.dp
  val raised: Dp = 3.dp
  val floating: Dp = 6.dp
  val modal: Dp = 12.dp
}

object GriIconSize {
  val badge: Dp = 14.dp
  val sm: Dp = 18.dp
  val md: Dp = 22.dp
  val lg: Dp = 28.dp
  val hero: Dp = 40.dp
}

object GriTypography {
  // Heading scale
  val Display = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Bold,
    fontSize = 24.sp,
    lineHeight = 32.sp,
    letterSpacing = (-0.2).sp,
    color = GriColors.TextPrimary
  )

  val Headline = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Bold,
    fontSize = 20.sp,
    lineHeight = 26.sp,
    letterSpacing = (-0.1).sp,
    color = GriColors.TextPrimary
  )

  val Title = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.SemiBold,
    fontSize = 17.sp,
    lineHeight = 22.sp,
    color = GriColors.TextPrimary
  )

  val Subtitle = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Medium,
    fontSize = 15.sp,
    lineHeight = 20.sp,
    color = GriColors.TextSecondary
  )

  // Body scale
  val Body = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Normal,
    fontSize = 14.sp,
    lineHeight = 20.sp,
    color = GriColors.TextPrimary
  )

  val BodyMedium = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Medium,
    fontSize = 14.sp,
    lineHeight = 20.sp,
    color = GriColors.TextPrimary
  )

  val BodySmall = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Normal,
    fontSize = 12.sp,
    lineHeight = 17.sp,
    color = GriColors.TextSecondary
  )

  // Label & Caption scale
  val Label = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.SemiBold,
    fontSize = 12.sp,
    lineHeight = 16.sp,
    letterSpacing = 0.4.sp,
    color = GriColors.TextSecondary
  )

  val LabelSmall = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Bold,
    fontSize = 10.sp,
    lineHeight = 14.sp,
    letterSpacing = 0.5.sp,
    color = GriColors.TextMuted
  )

  val Button = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.SemiBold,
    fontSize = 14.sp,
    lineHeight = 18.sp,
    letterSpacing = 0.2.sp
  )

  val TamilMotto = TextStyle(
    fontFamily = FontFamily.Default,
    fontWeight = FontWeight.Medium,
    fontSize = 12.sp,
    lineHeight = 16.sp,
    color = GriColors.TextGold
  )
}
