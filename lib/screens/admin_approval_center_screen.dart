import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../utils/gri_colors.dart';

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
    final provider = context.watch<GriProvider>();

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
      padding: const EdgeInsets.all(16),
      children: [
        // Title & Search
        const Text(
          "INSTITUTIONAL APPROVAL CENTER",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search applications by name, roll no, department...",
            prefixIcon: const Icon(Icons.search, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(f.replaceAll('_', ' ')),
                  selected: isSel,
                  selectedColor: GriColors.forestPrimary,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSel ? Colors.white : Colors.black87,
                  ),
                  onSelected: (_) => provider.setApplicationFilter(f),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // Applications List
        if (filtered.isEmpty) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text("No applications matching current filter."),
            ),
          ),
        ] else ...[
          ...filtered.map((app) {
            Color statusColor;
            switch (app.status) {
              case AccountStatus.APPROVED:
                statusColor = Colors.green;
                break;
              case AccountStatus.UNDER_REVIEW:
                statusColor = Colors.orange;
                break;
              case AccountStatus.REJECTED:
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.blue;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          app.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: statusColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            app.status.name.replaceAll('_', ' '),
                            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID: ${app.institutionalId} • Requested: ${app.requestedRole.name}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Department: ${app.department}",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    if (app.adminQuery.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Active Query: ${app.adminQuery}",
                        style: const TextStyle(fontSize: 11.5, color: Colors.orange, fontWeight: FontWeight.w500),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Submitted: ${app.submittedDate}",
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GriColors.forestPrimary,
                            foregroundColor: Colors.white,
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.fact_check, size: 15),
                          label: const Text("Review Dossier", style: TextStyle(fontSize: 11.5)),
                          onPressed: () => provider.openAdminReviewModal(app),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],

        const SizedBox(height: 16),
        // Institutional Audit Trail
        const Text(
          "RECENT ADMINISTRATIVE AUDIT TRAIL",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
        ),
        const SizedBox(height: 8),
        ...provider.auditLogs.map((log) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: GriColors.forestContainer,
                  child: Icon(Icons.history, color: GriColors.forestPrimary, size: 20),
                ),
                title: Text("${log.action}: ${log.targetUser} (${log.targetRole})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text("${log.timestamp} • Officer: ${log.adminName}\nNotes: ${log.reasonOrNotes}", style: const TextStyle(fontSize: 11)),
                isThreeLine: true,
              ),
            )),
      ],
    );
  }
}
