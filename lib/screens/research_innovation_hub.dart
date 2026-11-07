import 'package:flutter/material.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';
import '../widgets/gri_primitives.dart';

/// Research & Innovation Hub — verified public research information.
///
/// Shows only verified research-related services and facilities published by
/// GRI (R&D Cell, IPR Cell, central instrumentation, etc.). No publications,
/// patents, or researcher credentials are invented — entries link to their
/// official source pages.
class ResearchInnovationHub extends StatelessWidget {
  const ResearchInnovationHub({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final researchServices = VerifiedContent.services
        .where((s) => s.category == 'Research')
        .toList();
    final researchFacilities = VerifiedContent.facilities
        .where((f) => f.category == 'Research')
        .toList();

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Research & Innovation'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          GriSectionHeader(
            title: 'Research services & cells',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          if (researchServices.isEmpty)
            GriEmptyState(
              icon: Icons.science_outlined,
              title: 'No research services published',
              hint: 'Research service information is not available in the verified dataset.',
            )
          else
            ...researchServices.map((s) => _serviceTile(context, isDark, s)),

          const SizedBox(height: 20),
          GriSectionHeader(
            title: 'Research facilities',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          if (researchFacilities.isEmpty)
            GriEmptyState(
              icon: Icons.science_outlined,
              title: 'No research facilities published',
              hint: 'Research facility information is not available in the verified dataset.',
            )
          else
            ...researchFacilities.map((f) => _facilityTile(context, isDark, f)),

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
                  'This app does not publish research publications, patents, or '
                  'researcher credentials unless they are officially published '
                  'by GRI. Open each source link for the authoritative details.',
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
            color: GriColors.tealSecondary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.science_outlined,
            size: 20,
            color: GriColors.tealSecondary,
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
            color: GriColors.tealSecondary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.science_outlined,
            size: 20,
            color: GriColors.tealSecondary,
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
