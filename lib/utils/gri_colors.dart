import 'package:flutter/material.dart';

class GriColors {
  // Primary GRI Gandhian Brand Colors
  static const Color forestPrimary = Color(0xFF1B5E20); // Gandhigram Forest Green
  static const Color forestOnPrimary = Color(0xFFFFFFFF);
  static const Color forestContainer = Color(0xFFD8E8D8);
  static const Color forestOnContainer = Color(0xFF002107);

  // Ochre / Khadi Gold Brand Colors
  static const Color ochrePrimary = Color(0xFFB8860B); // Khadi Golden Ochre
  static const Color ochreContainer = Color(0xFFFFF3D6);
  static const Color ochreOnContainer = Color(0xFF3B2D00);
  static const Color ochreTertiary = Color(0xFFD4A373);

  // Teal / Auxiliary Colors
  static const Color tealSecondary = Color(0xFF00695C);
  static const Color tealContainer = Color(0xFFD0F0EA);
  static const Color tealOnContainer = Color(0xFF00201B);

  // Surface & Neutrals (Khadi Ivory)
  static const Color surface = Color(0xFFF9F9F4);
  static const Color surfaceVariant = Color(0xFFECEEE7);
  static const Color onSurface = Color(0xFF1C1D1A);
  static const Color onSurfaceVariant = Color(0xFF43483E);
  static const Color outline = Color(0xFF73796D);
  static const Color outlineVariant = Color(0xFFC3C8BC);

  // Status Alerts
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFBA1A1A);
  static const Color info = Color(0xFF0288D1);

  // Theme definition
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: forestPrimary,
        onPrimary: forestOnPrimary,
        primaryContainer: forestContainer,
        onPrimaryContainer: forestOnContainer,
        secondary: tealSecondary,
        onSecondary: Colors.white,
        secondaryContainer: tealContainer,
        onSecondaryContainer: tealOnContainer,
        tertiary: ochrePrimary,
        tertiaryContainer: ochreContainer,
        onTertiaryContainer: ochreOnContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        error: error,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: forestPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: outlineVariant, width: 0.8),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}
