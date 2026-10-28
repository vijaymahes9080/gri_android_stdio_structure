import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../screens/global_website_search_screen.dart';
import '../screens/settings_screen.dart';
import '../services/official_resource_registry.dart';

/// Refined Pro-Level Institutional App Bar (58dp)
/// Built according to government & academic design standards:
/// - Prominent official crest and university hierarchy
/// - Clean global action icons with accessible 48x48dp touch targets
/// - Integrated role status badge
class GriTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GriTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();

    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
            width: 1.0,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              // Drawer Hamburger Trigger
              Builder(
                builder: (drawerCtx) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                    size: 24,
                  ),
                  tooltip: "University Navigation Menu",
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  onPressed: () => Scaffold.of(drawerCtx).openDrawer(),
                ),
              ),

              const SizedBox(width: 4),

              // Official University Crest
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: OfficialResourceRegistry.buildImage(
                  "IMG_OFFICIAL_CREST",
                  height: 34,
                  width: 34,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 10),

              // University Title & Metadata
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Quick return to Home
                    if (provider.currentTab != NavigationTab.HOME) {
                      provider.switchTab(NavigationTab.HOME);
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THE GANDHIGRAM RURAL INSTITUTE",
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Deemed to be University • NAAC 'A'",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                            letterSpacing: -0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Universal Catalog Search Shortcut
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                  size: 20,
                ),
                tooltip: "Search 247 Official Pages",
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GlobalWebsiteSearchScreen()),
                  );
                },
              ),

              // Cloud Sync Status Indicator
              IconButton(
                icon: provider.isSyncing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                        ),
                      )
                    : Icon(
                        Icons.cloud_done_outlined,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        size: 19,
                      ),
                tooltip: "Cloud Data Synchronized",
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                onPressed: provider.isSyncing ? null : () => provider.triggerCloudSync(),
              ),

              // Settings Shortcut
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                  size: 20,
                ),
                tooltip: "Settings & Preferences",
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),

              // Active Role Status Badge Button
              Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: InkWell(
                  onTap: () => provider.toggleRoleSwitcher(true),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.3 : 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: GriColors.forestPrimary.withValues(alpha: 0.25),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 13,
                          color: GriColors.forestPrimary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          provider.currentRole.name,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: GriColors.forestPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
