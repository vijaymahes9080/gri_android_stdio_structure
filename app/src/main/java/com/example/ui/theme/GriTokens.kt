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
  // Primary Institutional Palette
  val NavyPrimary = Color(0xFF0B2545)
  val NavyDeep = Color(0xFF05192D)
  val NavySurface = Color(0xFF133660)
  val NavyContainer = Color(0xFFE8EEF5)
  val NavyOnContainer = Color(0xFF071A30)

  // Institutional Gold / Brass Accents
  val GoldAccent = Color(0xFFC28437)
  val GoldDark = Color(0xFF925E1F)
  val GoldLight = Color(0xFFF7E7D2)
  val GoldContainer = Color(0xFFFFF3E0)
  val GoldOnContainer = Color(0xFF422700)

  // Rural Innovation / Nai Talim Terracotta Accent
  val RuralTerracotta = Color(0xFFC85A32)
  val RuralTerracottaLight = Color(0xFFFDF0EC)
  val RuralTerracottaDark = Color(0xFF8F3414)

  // Neutral Foundations (Clean Institutional)
  val Background = Color(0xFFF8FAFC)
  val BackgroundIvory = Color(0xFFFCFDFE)
  val Surface = Color(0xFFFFFFFF)
  val SurfaceSubtle = Color(0xFFF1F5F9)
  val SurfaceBorder = Color(0xFFE2E8F0)
  val SurfaceBorderFocused = Color(0xFF0B2545)

  // Typography Colors
  val TextPrimary = Color(0xFF0F172A)
  val TextSecondary = Color(0xFF475569)
  val TextMuted = Color(0xFF64748B)
  val TextInverse = Color(0xFFFFFFFF)
  val TextGold = Color(0xFF925E1F)

  // Status & Semantic Feedback
  val Success = Color(0xFF15803D)
  val SuccessContainer = Color(0xFFDCFCE7)
  val SuccessText = Color(0xFF14532D)

  val Alert = Color(0xFFB91C1C)
  val AlertContainer = Color(0xFFFEE2E2)
  val AlertText = Color(0xFF7F1D1D)

  val Warning = Color(0xFFD97706)
  val WarningContainer = Color(0xFFFEF3C7)
  val WarningText = Color(0xFF78350F)

  val Info = Color(0xFF0284C7)
  val InfoContainer = Color(0xFFE0F2FE)
  val InfoText = Color(0xFF0369A1)
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
