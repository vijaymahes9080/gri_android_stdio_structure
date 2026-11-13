import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../screens/global_website_search_screen.dart';
import '../screens/notifications_center_screen.dart';
import '../services/official_resource_registry.dart';

/// Refined Pro-Level Institutional App Bar (58dp)
/// Built according to government & academic design standards:
/// - Prominent official crest and university hierarchy
/// - Clean global action icons with accessible 48x48dp touch targets
/// - Integrated role status badge
class GriTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GriTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(62);

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
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Row(
            children: [
              // Drawer Hamburger Trigger
              Builder(
                builder: (drawerCtx) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                    size: 22,
                  ),
                  tooltip: "University Navigation Menu",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  onPressed: () => Scaffold.of(drawerCtx).openDrawer(),
                ),
              ),

              const SizedBox(width: 2),

              // Official University Crest
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: OfficialResourceRegistry.buildImage(
                  "IMG_OFFICIAL_CREST",
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 6),

              // University Title & Metadata (Guaranteed Full Visibility)
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
                            letterSpacing: -0.25,
                            color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Deemed to be University • NAAC A++",
                          style: TextStyle(
                            fontSize: 8.5,
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
                  size: 19,
                ),
                tooltip: "Search verified official records",
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GlobalWebsiteSearchScreen()),
                  );
                },
              ),

              // Official Notifications & Circulars Center Shortcut
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      provider.unreadNotificationsCount > 0
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_none_outlined,
                      color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      size: 19,
                    ),
                    tooltip: "Official Notifications & Circulars",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationsCenterScreen(),
                        ),
                      );
                    },
                  ),
                  if (provider.unreadNotificationsCount > 0)
                    Positioned(
                      top: 1,
                      right: 1,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: const BoxDecoration(
                            color: GriColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${provider.unreadNotificationsCount > 9 ? '9+' : provider.unreadNotificationsCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Active Role Status Trigger (Compact Institutional Pill)
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 2),
                child: Tooltip(
                  message: "Active Role: ${provider.currentRole.name} (Tap to switch)",
                  child: InkWell(
                    onTap: () => provider.toggleRoleSwitcher(true),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                            size: 12,
                            color: GriColors.forestPrimary,
                          ),
                          const SizedBox(width: 2.5),
                          Text(
                            provider.currentRole.name.length > 3
                                ? provider.currentRole.name.substring(0, 3)
                                : provider.currentRole.name,
                            style: const TextStyle(
                              fontSize: 9,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
