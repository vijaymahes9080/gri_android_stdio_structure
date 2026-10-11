import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

class GovernanceLeadershipScreen extends StatefulWidget {
  const GovernanceLeadershipScreen({super.key});

  @override
  State<GovernanceLeadershipScreen> createState() => _GovernanceLeadershipScreenState();
}

class _GovernanceLeadershipScreenState extends State<GovernanceLeadershipScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seed = SeedDataService.instance;
    final officers = seed.officialLeadership;
    final schools = seed.schools;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Governance & Administration"),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GriColors.ochrePrimary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: "Executive Officers"),
            Tab(text: "Deans & HODs"),
            Tab(text: "Statutory Councils"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Executive Officers Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: officers.length,
            itemBuilder: (context, index) {
              final o = officers[index];
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
                          Expanded(
                            child: Text(
                              o["name"] ?? "",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              o["designation"] ?? "",
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        o["portfolio"] ?? "",
                        style: const TextStyle(fontSize: 12, height: 1.3),
                      ),
                      const Divider(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(o["email"] ?? "", style: const TextStyle(fontSize: 11.5, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(o["phone"] ?? "", style: const TextStyle(fontSize: 11.5, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(o["location"] ?? "", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 2. Deans & Heads of Departments
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final sch = schools[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sch.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text("Dean: ${sch.dean}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      Text("Email: ${sch.deanEmail} • Phone: ${sch.deanPhone}", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text("Highlights: ${sch.highlights}", style: const TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 3. Statutory Councils
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCouncilCard(
                "Executive Council (EC)",
                "The highest governing body of the Institute, responsible for the general superintendence, direction, and management of the university affairs.",
                "Vice-Chancellor (Chairman), 2 Deans by rotation, 1 Professor, 1 Associate Professor, 4 MHRD/UGC Nominees, Registrar (Secretary).",
                "Meets at least four times annually.",
              ),
              const SizedBox(height: 12),
              _buildCouncilCard(
                "Academic Council",
                "The principal academic body responsible for the maintenance of standards of education, teaching, research, and examination within the university.",
                "Vice-Chancellor (Chairman), All Deans of Schools, All Heads of Departments, 3 Professors by rotation, External Academic Experts, Registrar (Secretary).",
                "Meets once every semester prior to Board of Studies approvals.",
              ),
              const SizedBox(height: 12),
              _buildCouncilCard(
                "Planning & Monitoring Board",
                "Monitors academic development programmes, perspective five-year plans, infrastructure expansion, and UGC development grant allocations.",
                "Vice-Chancellor (Chairman), 3 External Nominees of UGC/MHRD, 2 Internal Senior Professors, Registrar.",
                "Annual strategic appraisal.",
              ),
              const SizedBox(height: 12),
              _buildCouncilCard(
                "Finance Committee",
                "Advises the Executive Council on all financial matters, prepares annual estimates, audits university funds, and sanctions non-recurring expenditures.",
                "Vice-Chancellor (Chairman), 1 MHRD Nominee, 1 UGC Nominee, 1 EC Member, Finance Officer (Secretary).",
                "Meets prior to budget presentation.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCouncilCard(String title, String role, String composition, String frequency) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary)),
            const SizedBox(height: 6),
            Text(role, style: const TextStyle(fontSize: 12, height: 1.35)),
            const Divider(height: 16),
            const Text("Key Composition:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            const SizedBox(height: 2),
            Text(composition, style: TextStyle(fontSize: 11, color: Colors.grey.shade800, height: 1.3)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.schedule, size: 13, color: GriColors.ochrePrimary),
                const SizedBox(width: 4),
                Text(frequency, style: const TextStyle(fontSize: 11, color: GriColors.ochrePrimary, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
