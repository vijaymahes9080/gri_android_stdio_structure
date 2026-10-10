import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../utils/gri_colors.dart';

class RoleSwitcherModal extends StatelessWidget {
  const RoleSwitcherModal({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();
    final currentUser = provider.currentUser;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.switch_account, color: GriColors.forestPrimary),
                  SizedBox(width: 8),
                  Text(
                    "Switch Institutional Role",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => provider.toggleRoleSwitcher(false),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Select an approved role for ${currentUser?.name ?? 'User'} or switch institutional profile for end-to-end workflow verification.",
            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),

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
                labelStyle: TextStyle(
                  color: isCurrent ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                onSelected: (_) {
                  provider.switchAuthorizedRole(role);
                  provider.toggleRoleSwitcher(false);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 18),
          const Text(
            "PRESET INSTITUTIONAL DOSSIERS",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
          ),
          const SizedBox(height: 8),
          ...provider.availableAccounts.map((acc) {
            final isCurrent = currentUser?.id == acc.id;
            return Card(
              color: isCurrent ? GriColors.forestContainer.withOpacity(0.4) : Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: GriColors.forestPrimary,
                  child: Text(
                    acc.name[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  acc.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                subtitle: Text(
                  "${acc.role} • ${acc.department} • Status: ${acc.accountStatus}",
                  style: const TextStyle(fontSize: 11.5),
                ),
                trailing: isCurrent
                    ? const Icon(Icons.check_circle, color: GriColors.forestPrimary)
                    : const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  provider.switchUserAccount(acc);
                  provider.toggleRoleSwitcher(false);
                },
              ),
            );
          }),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
