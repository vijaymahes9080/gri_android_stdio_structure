import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/gri_provider.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class AdminDirectoryScreen extends StatefulWidget {
  const AdminDirectoryScreen({super.key});

  @override
  State<AdminDirectoryScreen> createState() => _AdminDirectoryScreenState();
}

class _AdminDirectoryScreenState extends State<AdminDirectoryScreen> {
  final _cirTitleController = TextEditingController();
  final _cirCatController = TextEditingController();
  final _cirSummaryController = TextEditingController();
  bool _showPublishForm = false;

  @override
  void dispose() {
    _cirTitleController.dispose();
    _cirCatController.dispose();
    _cirSummaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final seed = SeedDataService.instance;
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    final officers = seed.officialLeadership;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Governance & Cloud Sync Bento Card
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.hub_outlined, color: GriColors.forestPrimary, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "SYSTEM GOVERNANCE NODE",
                          style: TextStyle(
                            color: GriColors.forestPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.5,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        provider.ktorServerStatus,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.green),
                      ),
                    ),
                  ],
                ),
                Divider(color: borderColor, height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Authoritative Cloud Sync",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            provider.isSyncing ? "Synchronizing with Server..." : "Supabase Cloud • Offline Vault Active",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GriPressable(
                      onTap: provider.isSyncing ? null : () => provider.triggerCloudSync(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: borderColor, width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (provider.isSyncing)
                              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: GriColors.forestPrimary))
                            else
                              const Icon(Icons.sync, size: 14, color: GriColors.forestPrimary),
                            const SizedBox(width: 4),
                            const Text(
                              "Sync Now",
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
          ),
        ),
        const SizedBox(height: 14),

        // Directorate Publishing Desk (Admin / Authorized Role)
        if (provider.currentRole.name == "ADMIN" || provider.currentRole.name == "SUPER_ADMIN") ...[
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "DIRECTORATE PUBLISHING DESK",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: GriColors.forestPrimary, letterSpacing: 0.5),
                      ),
                      GriPressable(
                        onTap: () => setState(() => _showPublishForm = !_showPublishForm),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_showPublishForm ? Icons.close : Icons.campaign_outlined, size: 13, color: GriColors.forestPrimary),
                              const SizedBox(width: 4),
                              Text(
                                _showPublishForm ? "Close" : "New Notice",
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showPublishForm) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cirTitleController,
                      decoration: InputDecoration(
                        labelText: "Circular / Notice Title *",
                        labelStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cirCatController,
                      decoration: InputDecoration(
                        labelText: "Category (e.g. Examinations, Admissions) *",
                        labelStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cirSummaryController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Official Circular Directives *",
                        labelStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GriPressable(
                          onTap: () {
                            if (_cirTitleController.text.trim().isNotEmpty && _cirSummaryController.text.trim().isNotEmpty) {
                              provider.publishCircular(
                                _cirTitleController.text.trim(),
                                _cirCatController.text.trim().isNotEmpty ? _cirCatController.text.trim() : "General",
                                _cirSummaryController.text.trim(),
                                true,
                                "Registrar's Directorate",
                              );
                              _cirTitleController.clear();
                              _cirCatController.clear();
                              _cirSummaryController.clear();
                              setState(() => _showPublishForm = false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Broadcast Circular",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // University Executive Leadership Directory (Authoritative)
        const Text(
          "EXECUTIVE ADMINISTRATION & CONTACTS",
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: GriColors.forestPrimary, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Column(
            children: officers.asMap().entries.map((entry) {
              final idx = entry.key;
              final officer = entry.value;
              final isLast = idx == officers.length - 1;

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.account_balance_outlined, color: GriColors.forestPrimary, size: 18),
                    ),
                    title: Text(
                      officer['name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          officer['designation'] ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (officer['email'] != null) ...[
                              InkWell(
                                onTap: () async {
                                  final uri = Uri.parse("mailto:${officer['email']}");
                                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                                },
                                child: Text(
                                  officer['email']!,
                                  style: const TextStyle(fontSize: 10.5, color: GriColors.forestPrimary, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Text(" • ", style: TextStyle(fontSize: 10.5, color: Colors.grey)),
                            ],
                            if (officer['phone'] != null)
                              InkWell(
                                onTap: () async {
                                  final uri = Uri.parse("tel:${officer['phone']}");
                                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                                },
                                child: Text(
                                  officer['phone']!,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(color: borderColor, height: 1),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // University Academic Schools & Deans
        const Text(
          "ACADEMIC SCHOOLS & DEANS",
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: GriColors.forestPrimary, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        ...seed.schools.map((s) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: GriColors.ochrePrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school_outlined, color: GriColors.ochrePrimary, size: 18),
                ),
                title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                subtitle: Text(
                  "Dean: ${s.dean}\nEmail: ${s.deanEmail} • Programmes: ${s.programmesCount}",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                onTap: () async {
                  if (s.deanEmail.isNotEmpty) {
                    final uri = Uri.parse("mailto:${s.deanEmail}");
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  }
                },
              ),
            )),
      ],
    );
  }
}
