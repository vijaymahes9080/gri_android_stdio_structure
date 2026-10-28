import 'package:flutter/material.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_metrics.dart';
import '../utils/gri_motion.dart';
import '../utils/gri_typography.dart';

/// GRI Shared UI Primitives
///
/// The audit found zero shared presentation primitives — every screen
/// hand-builds section headers, empty states and status chips with one-off
/// styles. These components encode the institutional design language once so
/// screens stay consistent by construction.
///

/// Eyebrow-style section header ("AVAILABLE ROLES", "NOTICES", …) with an
/// optional trailing action. Use [titleCase] = true for uppercase tracking
/// labels; false for sentence-case section titles.
class GriSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool titleCase;
  final Color? color;

  const GriSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.titleCase = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = color ?? (isDark ? GriColors.darkOnSurface : GriColors.onSurface);
    final resolvedAction = (actionLabel != null && onAction != null) ? onAction : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            titleCase ? title.toUpperCase() : title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GriTypography.labelMedium.copyWith(
              color: baseColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (resolvedAction != null)
          TextButton(
            onPressed: resolvedAction,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(actionLabel!, style: GriTypography.labelMedium),
          ),
      ],
    );
  }
}

/// Institutional empty state: icon in a bordered well, headline, supporting
/// hint and optional recovery action. Honors reduced-motion for its entrance.
class GriEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? hint;
  final Widget? action;

  const GriEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.hint,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wellColor = isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant;
    final onWell = isDark ? GriColors.darkOnSurface : GriColors.onSurface;
    final muted = isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant;

    return GriFadeSlideEntrance(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GriSpacing.xl, vertical: GriSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: wellColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                ),
                child: Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: GriSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GriTypography.titleMedium.copyWith(color: onWell),
              ),
              if (hint != null) ...[
                const SizedBox(height: GriSpacing.xs),
                Text(
                  hint!,
                  textAlign: TextAlign.center,
                  style: GriTypography.bodySmall.copyWith(color: muted),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: GriSpacing.md),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Semantic tone for [GriStatusBadge] — mirrors the WCAG-tuned status tokens
/// in `GriColors` so screens stop improvising with raw `Colors.green` etc.
enum GriStatusTone { success, warning, error, info, neutral }

class GriStatusBadge extends StatelessWidget {
  final String label;
  final GriStatusTone tone;
  final bool dense;

  const GriStatusBadge({
    super.key,
    required this.label,
    required this.tone,
    this.dense = false,
  });

  (Color, Color) _resolve(bool isDark) {
    switch (tone) {
      case GriStatusTone.success:
        return (GriColors.successContainer, GriColors.successOnContainer);
      case GriStatusTone.warning:
        return (GriColors.warningContainer, GriColors.warningOnContainer);
      case GriStatusTone.error:
        return (GriColors.errorContainer, GriColors.errorOnContainer);
      case GriStatusTone.info:
        return (GriColors.infoContainer, GriColors.infoOnContainer);
      case GriStatusTone.neutral:
        return (isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
            isDark ? GriColors.darkOnSurface : GriColors.onSurface);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color container;
    Color onContainer;
    Color ink;
    if (isDark && tone != GriStatusTone.neutral) {
      // Dark mode: tinted well + bright ink (dark container tokens are
      // light-tinted pastels designed for light surfaces).
      ink = switch (tone) {
        GriStatusTone.success => GriColors.successBright,
        GriStatusTone.warning => GriColors.warningBright,
        GriStatusTone.error => GriColors.errorBright,
        GriStatusTone.info => GriColors.infoBright,
        GriStatusTone.neutral => GriColors.darkOnSurface,
      };
      container = ink.withValues(alpha: 0.16);
      onContainer = ink;
    } else {
      (container, onContainer) = _resolve(isDark);
      ink = onContainer;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? GriSpacing.s : GriSpacing.md,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: container,
        borderRadius: BorderRadius.circular(GriRadii.sm),
        border: Border.all(color: ink.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: GriTypography.labelSmall.copyWith(
          color: onContainer,
          fontSize: dense ? 10 : 11,
        ),
      ),
    );
  }
}
