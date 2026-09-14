package com.example.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext

private val DarkColorScheme = darkColorScheme(
  primary = Color(0xFF8FB9E5),
  onPrimary = GriNavyDark,
  primaryContainer = GriNavySurface,
  onPrimaryContainer = Color(0xFFD6E6F7),
  secondary = GriGoldSecondary,
  onSecondary = Color(0xFF351E00),
  secondaryContainer = Color(0xFF523305),
  onSecondaryContainer = Color(0xFFFFE0B2),
  background = GriBackgroundDark,
  surface = GriSurfaceDark,
  surfaceVariant = GriSurfaceVariantDark,
  onSurface = GriOnSurfaceDark,
  onBackground = GriOnSurfaceDark,
  onSurfaceVariant = GriOnSurfaceVariantDark,
  outline = GriOutlineDark
)

private val LightColorScheme = lightColorScheme(
  primary = GriNavyPrimary,
  onPrimary = Color.White,
  primaryContainer = GriNavyContainer,
  onPrimaryContainer = GriNavyPrimary,
  secondary = GriGoldSecondary,
  onSecondary = Color.White,
  secondaryContainer = GriGoldContainer,
  onSecondaryContainer = GriGoldOnContainer,
  background = GriBackgroundLight,
  surface = GriSurfaceLight,
  surfaceVariant = GriSurfaceVariant,
  onSurface = GriOnSurfaceLight,
  onBackground = GriOnSurfaceLight,
  onSurfaceVariant = GriOnSurfaceVariant,
  outline = GriOutlineLight
)

@Composable
fun MyApplicationTheme(
  darkTheme: Boolean = isSystemInDarkTheme(),
  dynamicColor: Boolean = false,
  content: @Composable () -> Unit,
) {
  // Respect institutional GRI identity rather than arbitrary dynamic system colors
  val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme

  MaterialTheme(
    colorScheme = colorScheme,
    typography = Typography,
    content = content
  )
}
