import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../utils/gri_colors.dart';

class GriTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GriTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(108);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();
    final currentUser = provider.currentUser;

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Row 1: University Branding & Global Action Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  // University Emblem / Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/gri_official_logo.png',
                      height: 38,
                      width: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        height: 38,
                        width: 38,
                        color: GriColors.forestPrimary,
                        child: const Icon(Icons.school, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // University Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "THE GANDHIGRAM RURAL INSTITUTE",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: GriColors.forestPrimary,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Deemed to be University • NAAC 'A' Grade • ruraluniv.ac.in",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // AI Assistant Shortcut
                  IconButton(
                    icon: const Icon(Icons.auto_awesome, color: GriColors.ochrePrimary, size: 20),
                    tooltip: "GRI-Sahayak AI",
                    onPressed: () => provider.toggleAskAi(true),
                    visualDensity: VisualDensity.compact,
                  ),

                  // Document Center Shortcut
                  IconButton(
                    icon: const Icon(Icons.verified, color: GriColors.forestPrimary, size: 20),
                    tooltip: "Official Documents",
                    onPressed: () => provider.toggleDocumentCenter(true),
                    visualDensity: VisualDensity.compact,
                  ),

                  // Cloud Sync Indicator
                  IconButton(
                    icon: provider.isSyncing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: GriColors.forestPrimary),
                          )
                        : const Icon(Icons.sync, color: Colors.black54, size: 20),
                    tooltip: "Sync with Cloud",
                    onPressed: provider.isSyncing ? null : () => provider.triggerCloudSync(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // Row 2: Role Switcher & Institutional Account Strip
            Container(
              height: 36,
              color: GriColors.surfaceVariant.withOpacity(0.5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                children: [
                  // Active Role Chip
                  InkWell(
                    onTap: () => provider.toggleRoleSwitcher(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary,
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
                  InkWell(
                    onTap: () => provider.openRegistrationWizard(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? GriColors.forestPrimary : Colors.black87,
                          ),
                        ),
                        backgroundColor: isSelected ? GriColors.forestContainer : Colors.white,
                        side: BorderSide(
                          color: isSelected ? GriColors.forestPrimary : Colors.grey.shade300,
                          width: isSelected ? 1.5 : 1,
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
