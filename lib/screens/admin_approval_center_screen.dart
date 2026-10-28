import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../widgets/gri_primitives.dart';

class AdminApprovalCenterScreen extends StatefulWidget {
  const AdminApprovalCenterScreen({super.key});

  @override
  State<AdminApprovalCenterScreen> createState() => _AdminApprovalCenterScreenState();
}

class _AdminApprovalCenterScreenState extends State<AdminApprovalCenterScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    final filtered = provider.applications.where((app) {
      if (provider.applicationFilter != "ALL" && app.status.name != provider.applicationFilter) {
        return false;
      }
      if (provider.applicationSearchQuery.isNotEmpty) {
        final q = provider.applicationSearchQuery.toLowerCase();
        final match = app.fullName.toLowerCase().contains(q) ||
            app.institutionalId.toLowerCase().contains(q) ||
            app.department.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Title & Search
        const Text(
          "INSTITUTIONAL APPROVAL CENTER",
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: GriColors.forestPrimary, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          style: TextStyle(fontSize: 12.5, color: isDark ? GriColors.darkOnSurface : GriColors.onSurface),
          decoration: InputDecoration(
            hintText: "Search applications by name, roll no, department...",
            hintStyle: TextStyle(fontSize: 12, color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
            prefixIcon: const Icon(Icons.search, size: 18),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            filled: true,
            fillColor: cardBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor, width: 0.8)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor, width: 0.8)),
          ),
          onChanged: (val) => provider.setApplicationSearchQuery(val),
        ),
        const SizedBox(height: 10),

        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              "ALL",
              "PENDING_APPROVAL",
              "UNDER_REVIEW",
              "APPROVED",
              "REJECTED",
            ].map((f) {
              final isSel = provider.applicationFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GriPressable(
                  onTap: () => provider.setApplicationFilter(f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSel ? GriColors.forestPrimary : cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSel ? GriColors.forestPrimary : borderColor,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      f.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSel ? Colors.white : (isDark ? GriColors.darkOnSurface : GriColors.onSurface),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Applications List
        if (filtered.isEmpty) ...[
          const GriEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No applications found',
            hint: 'No dossiers match the current filter. Adjust the status filter to see more.',
          ),
        ] else ...[
          ...filtered.map((app) {
            GriStatusTone statusTone;
            switch (app.status) {
              case AccountStatus.APPROVED:
                statusTone = GriStatusTone.success;
                break;
              case AccountStatus.UNDER_REVIEW:
                statusTone = GriStatusTone.warning;
                break;
              case AccountStatus.REJECTED:
                statusTone = GriStatusTone.error;
                break;
              default:
                statusTone = GriStatusTone.info;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      GriStatusBadge(
                        label: app.status.name.replaceAll('_', ' '),
                        tone: statusTone,
                        dense: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "ID: ${app.institutionalId} • Requested: ${app.requestedRole.name}",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    "Department: ${app.department}",
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                  ),
                  if (app.adminQuery.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Active Query: ${app.adminQuery}",
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? GriColors.warningBright : GriColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Submitted: ${app.submittedDate}",
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                      GriPressable(
                        onTap: () => provider.openAdminReviewModal(app),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.fact_check_outlined, size: 13, color: GriColors.forestPrimary),
                              SizedBox(width: 4),
                              Text(
                                "Review Dossier",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],

        const SizedBox(height: 14),
        // Institutional Audit Trail
        const Text(
          "RECENT ADMINISTRATIVE AUDIT TRAIL",
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: GriColors.forestPrimary, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        ...provider.auditLogs.map((log) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: GriColors.forestPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.history, color: GriColors.forestPrimary, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${log.action}: ${log.targetUser} (${log.targetRole})",
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${log.timestamp} • Officer: ${log.adminName}\nNotes: ${log.reasonOrNotes}",
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
