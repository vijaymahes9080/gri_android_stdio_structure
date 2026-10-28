import 'package:flutter/material.dart';
import 'gri_colors.dart';

/// GRI Typography System
/// Structured according to Material Design 3 and WCAG 2.1 AA/AAA accessibility.
/// Provides consistent hierarchy and typography scales across all institutional modules.
class GriTypography {
  // Primary Academic Font Family Stack
  static const String primaryFont = 'Roboto';
  static const List<String> fontFamilyFallback = ['Roboto', 'sans-serif', 'Noto Sans Tamil'];

  // Display Typography (For hero splash and grand institutional banners)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: GriColors.onSurface,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
    color: GriColors.onSurface,
  );

  // Headlines (For Screen Titles & Major Section Breaks)
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.3,
    color: GriColors.onSurface,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    height: 1.35,
    color: GriColors.onSurface,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.4,
    color: GriColors.onSurface,
  );

  // Title Typography (For Module Cards, Modal Headers, Sub-sections)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    color: GriColors.onSurface,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    color: GriColors.onSurface,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    color: GriColors.onSurface,
  );

  // Body Typography (For Narrative Copy, Regulations, Notices)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: GriColors.onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: GriColors.onSurfaceVariant,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.45,
    color: GriColors.onSurfaceVariant,
  );

  // Label Typography (For Action Buttons, Filter Pills, Status Badges)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: GriColors.onSurface,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: GriColors.onSurfaceVariant,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: GriColors.onSurfaceVariant,
  );

  // Institutional Bilingual Style (Tamil + English)
  static const TextStyle institutionalTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.4,
    color: GriColors.forestPrimary,
    fontFamilyFallback: fontFamilyFallback,
  );

  static const TextStyle institutionalSubtitle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: GriColors.onSurfaceVariant,
    letterSpacing: 0.2,
    fontFamilyFallback: fontFamilyFallback,
  );

  /// Brightness-aware TextTheme factory.
  ///
  /// The scale above is authored for light surfaces (dark ink). In dark mode
  /// the same *geometry* must be re-inked with dark-surface colors — otherwise
  /// dark mode would inherit light ink (or fall back to stock typography).
  /// Use this in both `GriColors.lightTheme` and `GriColors.darkTheme`.
  static TextTheme theme(Brightness brightness) {
    final Color primary = brightness == Brightness.dark
        ? GriColors.darkOnSurface
        : GriColors.onSurface;
    final Color secondary = brightness == Brightness.dark
        ? GriColors.darkOnSurfaceVariant
        : GriColors.onSurfaceVariant;

    return TextTheme(
      displayLarge: displayLarge.copyWith(color: primary),
      displayMedium: displayMedium.copyWith(color: primary),
      headlineLarge: headlineLarge.copyWith(color: primary),
      headlineMedium: headlineMedium.copyWith(color: primary),
      headlineSmall: headlineSmall.copyWith(color: primary),
      titleLarge: titleLarge.copyWith(color: primary),
      titleMedium: titleMedium.copyWith(color: primary),
      titleSmall: titleSmall.copyWith(color: primary),
      bodyLarge: bodyLarge.copyWith(color: primary),
      bodyMedium: bodyMedium.copyWith(color: secondary),
      bodySmall: bodySmall.copyWith(color: secondary),
      labelLarge: labelLarge.copyWith(color: primary),
      labelMedium: labelMedium.copyWith(color: secondary),
      labelSmall: labelSmall.copyWith(color: secondary),
    );
  }
}
