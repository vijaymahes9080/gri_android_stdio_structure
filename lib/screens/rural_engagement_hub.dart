import 'package:flutter/material.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';
import '../widgets/gri_primitives.dart';

/// Rural Engagement & Village Placement — GRI's rural development identity.
///
/// Shows verified rural engagement content (Unnat Bharat Abhiyan seaweed
/// startup facility, rural engagement initiative). No village names,
/// beneficiary counts, placement statistics, or project outcomes are
/// invented — they are not published in the verified dataset.
class RuralEngagementHub extends StatelessWidget {
  const RuralEngagementHub({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final uba = VerifiedContent.services.firstWhere(
      (s) => s.id == 'svc_uba',
      orElse: () => throw StateError('UBA service not found'),
    );

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Rural Engagement'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          GriSectionHeader(
            title: 'Unnat Bharat Abhiyan (UBA)',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          _ubaCard(context, isDark, uba),
          const SizedBox(height: 20),
          GriSectionHeader(
            title: 'Rural development identity',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gandhian rural development philosophy',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'GRI was established on Gandhian principles of rural '
                  'transformation through education, research and extension. '
                  'The Nai Talim philosophy integrates teaching, research and '
                  'extension for rural development. Village placement and '
                  'fieldwork are part of the institutional academic '
                  'programme structure.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => GriUrlLauncher.launch(
                        context, VerifiedInstitution.aboutUrl),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('About GRI & heritage'),
                  ),
                ),
              ],
            ),
          ),
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
                  'Village names, beneficiary counts, placement statistics, '
                  'and specific project outcomes are not published in the '
                  'verified dataset and are therefore not shown. This app does '
                  'not fabricate rural engagement data. Open the UBA source '
                  'link for official details.',
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

  Widget _ubaCard(
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
            Icons.eco_outlined,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              Text(
                s.description,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => GriUrlLauncher.launch(context, s.url),
      )),
    );
  }
}
