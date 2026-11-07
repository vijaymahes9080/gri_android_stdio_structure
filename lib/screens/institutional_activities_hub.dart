import 'package:flutter/material.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';
import '../widgets/gri_primitives.dart';

/// Institutional Activities Hub — verified public activities.
///
/// Shows officially documented institutional initiatives (NSS, Unnat Bharat
/// Abhiyan, Shanti Sena) and heritage/cultural facilities (Museum, Art
/// Gallery, Theatre). No activity reports, participation statistics, or
/// beneficiary figures are invented.
class InstitutionalActivitiesHub extends StatelessWidget {
  const InstitutionalActivitiesHub({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activities = VerifiedContent.services
        .where((s) =>
            s.id == 'svc_nss' || s.id == 'svc_uba' || s.id == 'svc_shanti')
        .toList();
    final heritage = VerifiedContent.facilities
        .where((f) => f.category == 'Heritage')
        .toList();

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Institutional Activities'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          GriSectionHeader(
            title: 'National service & rural engagement',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          if (activities.isEmpty)
            GriEmptyState(
              icon: Icons.people_outline,
              title: 'No activities published',
              hint: 'Institutional activity information is not available in the verified dataset.',
            )
          else
            ...activities.map((s) => _serviceTile(context, isDark, s)),

          const SizedBox(height: 20),
          GriSectionHeader(
            title: 'Heritage & cultural facilities',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          if (heritage.isEmpty)
            GriEmptyState(
              icon: Icons.museum_outlined,
              title: 'No heritage facilities published',
              hint: 'Heritage facility information is not available in the verified dataset.',
            )
          else
            ...heritage.map((f) => _facilityTile(context, isDark, f)),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GriColors.ochreContainer.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GriColors.ochrePrimary.withValues(alpha: 0.4),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: GriColors.ochrePrimary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Verified information only',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: GriColors.ochrePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Activity reports, participation statistics, beneficiary '
                  'figures, and village placement details are not published in '
                  'the verified dataset and are therefore not shown. Open each '
                  'source link for official details.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: isDark ? GriColors.ochreOnContainer : GriColors.ochrePrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceTile(
      BuildContext context, bool isDark, InstitutionalService s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.volunteer_activism,
            size: 20,
            color: GriColors.ochrePrimary,
          ),
        ),
        title: Text(
          s.title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            '${s.category} • official GRI source',
            style: TextStyle(
              fontSize: 10.5,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => GriUrlLauncher.launch(context, s.url),
      )),
    );
  }

  Widget _facilityTile(
      BuildContext context, bool isDark, VerifiedFacility f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.museum_outlined,
            size: 20,
            color: GriColors.ochrePrimary,
          ),
        ),
        title: Text(
          f.name,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            '${f.category} • official GRI source',
            style: TextStyle(
              fontSize: 10.5,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => GriUrlLauncher.launch(context, f.sourceUrl),
      )),
    );
  }
}
