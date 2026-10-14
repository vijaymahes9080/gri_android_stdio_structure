import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../utils/gri_colors.dart';

/// Production-Grade Role Switcher Bottom Sheet
/// Allows toggling student, faculty, admin, scholar, and guest profiles for full workflow verification.
class RoleSwitcherModal extends StatelessWidget {
  const RoleSwitcherModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final currentUser = provider.currentUser;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? GriColors.darkSurface1 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(
              color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
              width: 1.0,
            ),
          ),
        ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.switch_account, color: GriColors.forestPrimary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Switch Institutional Role",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => provider.toggleRoleSwitcher(false),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Select an approved role for ${currentUser?.name ?? 'User'} to inspect workflow views.",
              style: TextStyle(
                fontSize: 12,
                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 14),

            // Roles List
            const Text(
              "AVAILABLE ROLES",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                UserRole.STUDENT,
                UserRole.FACULTY,
                UserRole.ADMIN,
                UserRole.COE_STAFF,
                UserRole.SCHOLAR,
                UserRole.GUEST,
              ].map((role) {
                final isCurrent = provider.currentRole == role;
                return ChoiceChip(
                  label: Text(role.name),
                  selected: isCurrent,
                  selectedColor: GriColors.forestPrimary,
                  backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  labelStyle: TextStyle(
                    color: isCurrent ? Colors.white : (isDark ? GriColors.darkOnSurface : Colors.black87),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                  side: BorderSide(
                    color: isCurrent ? GriColors.forestPrimary : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: 0.8,
                  ),
                  onSelected: (_) {
                    provider.switchAuthorizedRole(role);
                    provider.toggleRoleSwitcher(false);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            const Text(
              "PRESET INSTITUTIONAL DOSSIERS",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
            ),
            const SizedBox(height: 8),
            ...provider.availableAccounts.map((acc) {
              final isCurrent = currentUser?.id == acc.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08)
                      : (isDark ? GriColors.darkSurface2 : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrent
                        ? GriColors.forestPrimary
                        : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: isCurrent ? 1.4 : 1.0,
                  ),
                ),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: GriColors.forestPrimary,
                    radius: 16,
                    child: Text(
                      acc.name[0],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  title: Text(
                    acc.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    "${acc.role} • ${acc.department} • Status: ${acc.accountStatus}",
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle, color: GriColors.forestPrimary, size: 20)
                      : const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () {
                    provider.switchUserAccount(acc);
                    provider.toggleRoleSwitcher(false);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    ),
  );
}
}
