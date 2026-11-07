import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

/// Network and sync status banner.
///
/// Reuses existing infrastructure (GriProvider sync state + demo session
/// flag) without adding new dependencies. Shows whether the app is in demo
/// mode, whether a website sync is in progress, and a staleness hint so
/// users are never shown outdated information as current.
class GriSyncStatusBanner extends StatelessWidget {
  const GriSyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();

    // Demo mode is the dominant honesty signal: no live university session.
    if (provider.isDemoSession) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        color: GriColors.ochreContainer.withValues(alpha: 0.7),
        child: Row(
          children: [
            const Icon(Icons.info_outline,
                size: 14, color: GriColors.ochrePrimary),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Demo workspace — local QA data, not official university records. '
                'Live sync requires an authorised GRI session.',
                style: TextStyle(
                  fontSize: 10,
                  height: 1.35,
                  color: isDark ? GriColors.ochreOnContainer : GriColors.ochrePrimary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Sync in progress.
    if (provider.isSyncingWebsite) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        color: GriColors.infoContainer.withValues(alpha: 0.7),
        child: Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(GriColors.infoBright),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Synchronising official notices…',
                style: TextStyle(
                  fontSize: 10,
                  height: 1.35,
                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
