import 'package:flutter/material.dart';

/// GRI Layout Metrics — Spacing, Radius & Shadow Tokens
/// Single source of truth for dimensional styling so screens stop inventing
/// one-off values (the audit found 21 paddings, 12 radii and 3 shadow
/// dialects in active use).
///
/// Adoption guideline:
/// - Spacing follows a 4-pt base scale: 4 / 8 / 12 / 16 / 20 / 24 / 32.
///   Legacy 14-pt paddings map to [GriSpacing.md] (16) when a widget is touched.
/// - Radii: badges/pills use [GriRadii.pill] or [GriRadii.sm]; cards use
///   [GriRadii.lg] (14, matches CardThemeData); modals use [GriRadii.xl] (16).
/// - Shadows: exactly one canonical shadow per elevation step — never a
///   bespoke opacity.
abstract final class GriSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double md = 12;
  static const double l = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double section = 32;

  /// Screen horizontal gutter used by app bars, drawers and page bodies.
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: l);

  /// Card content padding (the dominant legacy value, now tokenized).
  static const EdgeInsets card = EdgeInsets.all(14);
}

abstract final class GriRadii {
  /// Tags, tiny status dots, inline chips.
  static const double sm = 6;

  /// Text fields, small buttons, snackbars.
  static const double md = 10;

  /// Cards (matches `CardThemeData` in `GriColors`).
  static const double lg = 14;

  /// Dialogs and bottom sheets.
  static const double xl = 16;

  /// Hero banners / top-corner sheet crowns.
  static const double sheet = 20;

  /// Fully-rounded pills.
  static const double pill = 999;

  static BorderRadius r(double value) => BorderRadius.circular(value);
}

abstract final class GriShadows {
  /// Resting card shadow (the canonical form of the legacy 0x08/2/8 recipe).
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// Hovered / sticky header shadow.
  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 3)),
  ];

  /// Floating panels (modals, FAB overlays).
  static const List<BoxShadow> raised = [
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 6)),
  ];
}
