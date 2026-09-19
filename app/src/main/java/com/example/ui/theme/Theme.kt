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
  primary = GriForestInverse,
  onPrimary = GriForestPrimary,
  primaryContainer = GriForestContainer,
  onPrimaryContainer = GriForestOnContainer,
  secondary = GriTealFixedDim,
  onSecondary = GriTealOnFixed,
  secondaryContainer = GriTealContainer,
  onSecondaryContainer = GriTealOnContainer,
  tertiary = GriOchreFixedDim,
  onTertiary = GriOchreOnFixed,
  tertiaryContainer = GriOchreContainer,
  onTertiaryContainer = GriOchreOnContainer,
  error = Color(0xFFFFB4AB),
  onError = Color(0xFF690005),
  errorContainer = Color(0xFF93000A),
  onErrorContainer = GriErrorContainer,
  background = GriBackgroundDark,
  surface = GriSurfaceDark,
  surfaceVariant = GriSurfaceVariantDark,
  onSurface = GriOnSurfaceDark,
  onBackground = GriOnSurfaceDark,
  onSurfaceVariant = GriOnSurfaceVariantDark,
  outline = GriOutlineDark,
  outlineVariant = Color(0xFF334B3F)
)

private val LightColorScheme = lightColorScheme(
  primary = GriForestPrimary,
  onPrimary = Color.White,
  primaryContainer = GriForestContainer,
  onPrimaryContainer = GriForestOnContainer,
  secondary = GriTealSecondary,
  onSecondary = Color.White,
  secondaryContainer = GriTealContainer,
  onSecondaryContainer = GriTealOnContainer,
  tertiary = GriOchreTertiary,
  onTertiary = Color.White,
  tertiaryContainer = GriOchreContainer,
  onTertiaryContainer = GriOchreOnContainer,
  error = GriError,
  onError = GriOnError,
  errorContainer = GriErrorContainer,
  onErrorContainer = GriOnErrorContainer,
  background = GriSurface,
  surface = GriSurfaceContainerLowest,
  surfaceVariant = GriSurfaceVariant,
  onSurface = GriOnSurface,
  onBackground = GriOnSurface,
  onSurfaceVariant = GriOnSurfaceVariant,
  outline = GriOutline,
  outlineVariant = GriOutlineVariant
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
