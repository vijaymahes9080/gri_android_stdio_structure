import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';
import '../widgets/gri_primitives.dart';

/// Verified public transport information with an honest live-tracking boundary.
///
/// GRI does not publish live bus GPS positions, schedules, or driver contacts
/// in the data available to this app. The previously hard-coded route details
/// and driver phone numbers were removed because they were not verified.
/// This screen shows only verified public information and clearly states that
/// live tracking is unavailable rather than fabricating positions or ETAs.
class TransportInfoScreen extends StatelessWidget {
  const TransportInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final routes = provider.transportRoutes;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Campus Transport'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Honest live-tracking boundary banner.
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
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: GriColors.ochrePrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Live GPS tracking is not published',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: isDark ? GriColors.ochreOnContainer : GriColors.ochrePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'GRI does not publish live bus locations, route schedules, or '
                  'estimated arrival times in the verified dataset. This app '
                  'therefore does not show live tracking or fabricated bus '
                  'positions. Official transport information is available on '
                  'the university campus page.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: isDark ? GriColors.ochreOnContainer : GriColors.ochrePrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),
          GriSectionHeader(
            title: 'Official transport information',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          Material(
            type: MaterialType.transparency,
            child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Campus location & transport',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            subtitle: const Text(
              'Official campus and transport information published by GRI.',
              style: TextStyle(fontSize: 11.5),
            ),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => GriUrlLauncher.launch(
                context, VerifiedInstitution.aboutUrl),
          )),
          const Divider(height: 1),

          const SizedBox(height: 18),
          GriSectionHeader(
            title: 'Transport routes (demo workspace)',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          Text(
            'The routes below are locally seeded QA placeholders used only to '
            'exercise the transport UI. Times, bus numbers and driver names '
            'are not published by GRI and are shown as such.',
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          if (routes.isEmpty)
            GriEmptyState(
              icon: Icons.directions_bus_outlined,
              title: 'No route data',
              hint: 'Transport routes are not published in this build.',
            )
          else
            ...routes.map((route) => _routeCard(context, isDark, route)),

          const SizedBox(height: 20),
          GriSectionHeader(
            title: 'Transport contact',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          Material(
            type: MaterialType.transparency,
            child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Transport section, GRI'),
            subtitle: const Text(
              'Contact the university transport office for current schedules.',
              style: TextStyle(fontSize: 11.5),
            ),
            trailing: const Icon(Icons.phone_outlined, size: 18),
            onTap: () => GriUrlLauncher.launch(context, VerifiedInstitution.contactUrl),
          )),
        ],
      ),
    );
  }

  Widget _routeCard(BuildContext context, bool isDark, dynamic route) {
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
            Icons.directions_bus,
            size: 20,
            color: GriColors.tealSecondary,
          ),
        ),
        title: Text(
          route.routeName,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Text(
              '${route.routeNo} • ${route.source} → ${route.destination}',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            GriStatusBadge(
              label: route.currentStatus,
              tone: route.currentStatus.toLowerCase() == 'demo data'
                  ? GriStatusTone.info
                  : GriStatusTone.neutral,
              dense: true,
            ),
          ],
        ),
        trailing: Text(
          'Not published',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          ),
        ),
        onTap: null,
      )),
    );
  }
}
