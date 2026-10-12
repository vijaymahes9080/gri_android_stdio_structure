import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../screens/global_website_search_screen.dart';
import '../services/official_resource_registry.dart';

class GriTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GriTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(108);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<GriProvider>();
    final currentUser = provider.currentUser;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Row 1: University Branding & Global Action Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  // Drawer Hamburger Menu Trigger
                  Builder(
                    builder: (drawerCtx) => IconButton(
                      icon: Icon(Icons.menu, color: colorScheme.primary, size: 22),
                      tooltip: "University Navigation",
                      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      onPressed: () => Scaffold.of(drawerCtx).openDrawer(),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // University Emblem / Logo (High-Res Official Crest)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: OfficialResourceRegistry.buildImage(
                      "IMG_OFFICIAL_CREST",
                      height: 38,
                      width: 38,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // University Title & Metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THE GANDHIGRAM RURAL INSTITUTE",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            letterSpacing: 0.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Deemed to be University • NAAC 'A' Grade • 1956",
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Global Website & Portal Search Shortcut
                  IconButton(
                    icon: Icon(Icons.search, color: colorScheme.primary, size: 21),
                    tooltip: "Search 247 Official Pages",
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GlobalWebsiteSearchScreen()),
                      );
                    },
                  ),

                  // AI Assistant Shortcut
                  IconButton(
                    icon: const Icon(Icons.auto_awesome, color: GriColors.ochrePrimary, size: 20),
                    tooltip: "GRI-Sahayak AI",
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    onPressed: () => provider.toggleAskAi(true),
                  ),

                  // Document Center Shortcut
                  IconButton(
                    icon: Icon(Icons.verified, color: colorScheme.primary, size: 20),
                    tooltip: "Official Documents",
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    onPressed: () => provider.toggleDocumentCenter(true),
                  ),

                  // Cloud Sync Indicator
                  IconButton(
                    icon: provider.isSyncing
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary),
                          )
                        : Icon(Icons.sync, color: colorScheme.onSurfaceVariant, size: 20),
                    tooltip: "Sync with Cloud",
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    onPressed: provider.isSyncing ? null : () => provider.triggerCloudSync(),
                  ),
                ],
              ),
            ),

            // Row 2: Role Switcher & Institutional Account Strip
            Container(
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5), width: 0.5),
                ),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                children: [
                  // Active Role Chip with Tactile Press
                  GriPressable(
                    onTap: () => provider.toggleRoleSwitcher(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.switch_account, color: Colors.white, size: 13),
                          const SizedBox(width: 4),
                          Text(
                            "${provider.currentRole.name} • ${provider.activeAccountStatus.name}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Quick Register Button
                  GriPressable(
                    onTap: () => provider.openRegistrationWizard(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: GriColors.ochrePrimary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.app_registration, color: Colors.white, size: 13),
                          SizedBox(width: 4),
                          Text(
                            "+ Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Preset Account Chips
                  ...provider.availableAccounts.map((acc) {
                    final isSelected = currentUser?.id == acc.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(
                          "${acc.name.split(' ').first} (${acc.role})",
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                          ),
                        ),
                        backgroundColor: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
                        side: BorderSide(
                          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                          width: isSelected ? 1.4 : 0.8,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onPressed: () => provider.switchUserAccount(acc),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
