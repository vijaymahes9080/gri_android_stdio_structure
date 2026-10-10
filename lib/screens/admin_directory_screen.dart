import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

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
    final provider = context.watch<GriProvider>();
    final seed = SeedDataService.instance;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Governance & Cloud Sync Terminal
        Card(
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.terminal, color: Colors.greenAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "SYSTEM GOVERNANCE TERMINAL",
                          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      provider.ktorServerStatus,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Cloud Backend Engine", style: TextStyle(color: Colors.white60, fontSize: 11)),
                        Text(
                          provider.isSyncing ? "Synchronizing..." : "Supabase Cloud • Offline Ready",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GriColors.forestPrimary,
                        foregroundColor: Colors.white,
                      ),
                      icon: provider.isSyncing
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.sync, size: 16),
                      label: const Text("Sync Now", style: TextStyle(fontSize: 12)),
                      onPressed: provider.isSyncing ? null : () => provider.triggerCloudSync(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Publish Circular (Admin Action)
        if (provider.currentRole.name == "ADMIN" || provider.currentRole.name == "SUPER_ADMIN") ...[
          Card(
            color: Colors.white,
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary),
                      ),
                      TextButton.icon(
                        icon: Icon(_showPublishForm ? Icons.close : Icons.campaign, size: 16),
                        label: Text(_showPublishForm ? "Close" : "Publish Circular"),
                        onPressed: () => setState(() => _showPublishForm = !_showPublishForm),
                      ),
                    ],
                  ),
                  if (_showPublishForm) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cirTitleController,
                      decoration: InputDecoration(
                        labelText: "Circular Title *",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cirCatController,
                      decoration: InputDecoration(
                        labelText: "Category (e.g. Examinations, Admissions) *",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cirSummaryController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Official Circular Summary *",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: GriColors.forestPrimary, foregroundColor: Colors.white),
                          onPressed: () {
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
                          child: const Text("Broadcast Circular"),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // University Executive Leadership Directory
        const Text(
          "EXECUTIVE ADMINISTRATION & CONTACTS",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              _buildLeaderTile("Prof. Panch. Ramalingam", "Vice-Chancellor", "vc@ruraluniv.ac.in", "+91 451 2452371"),
              const Divider(height: 1),
              _buildLeaderTile("Dr. M. Sundaramari", "Registrar (in-charge)", "registrar@ruraluniv.ac.in", "+91 451 2452323"),
              const Divider(height: 1),
              _buildLeaderTile("Dr. M. Sadasivam", "Controller of Examinations (CoE)", "coe@ruraluniv.ac.in", "+91 451 2452371 Ext: 301"),
              const Divider(height: 1),
              _buildLeaderTile("Prof. R. Mani", "Dean, Academic Affairs", "dean_academics@ruraluniv.ac.in", "+91 451 2452371 Ext: 302"),
              const Divider(height: 1),
              _buildLeaderTile("Dr. P. Anandharajakumar", "Dean, Student Welfare", "dean_welfare@ruraluniv.ac.in", "+91 451 2452371 Ext: 305"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // University Academic Schools & Deans
        const Text(
          "ACADEMIC SCHOOLS & DIRECTORS",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
        ),
        const SizedBox(height: 10),
        ...seed.schools.map((s) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: GriColors.forestContainer, child: Icon(Icons.school, color: GriColors.forestPrimary)),
                title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text("Dean: ${s.dean}\nEmail: ${s.deanEmail} • Programmes: ${s.programmesCount}", style: const TextStyle(fontSize: 11)),
                isThreeLine: true,
              ),
            )),
      ],
    );
  }

  Widget _buildLeaderTile(String name, String role, String email, String phone) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: GriColors.forestContainer,
        child: Icon(Icons.account_balance, color: GriColors.forestPrimary, size: 20),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
      subtitle: Text("$role\n$email • $phone", style: const TextStyle(fontSize: 11)),
      isThreeLine: true,
    );
  }
}
