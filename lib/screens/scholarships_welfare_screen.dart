import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

class ScholarshipsWelfareScreen extends StatefulWidget {
  const ScholarshipsWelfareScreen({super.key});

  @override
  State<ScholarshipsWelfareScreen> createState() => _ScholarshipsWelfareScreenState();
}

class _ScholarshipsWelfareScreenState extends State<ScholarshipsWelfareScreen> with SingleTickerProviderStateMixin {
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
    final scholarships = seed.officialScholarships;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scholarships & Student Welfare"),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GriColors.ochrePrimary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: "Government Scholarships"),
            Tab(text: "APAAR & UMIS IDs"),
            Tab(text: "Student Welfare & Anti-Ragging"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Government Scholarships Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scholarships.length,
            itemBuilder: (context, index) {
              final s = scholarships[index];
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
                              s["title"] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: GriColors.ochrePrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                            child: const Text("Active 2026-27", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: GriColors.ochrePrimary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text("Sanctioning Authority: ${s['authority']}", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                      const SizedBox(height: 6),
                      Text("Eligible Beneficiaries: ${s['beneficiary']}", style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(s["details"] as String, style: const TextStyle(fontSize: 12, height: 1.35)),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Notice: ${s['noticeUrl']}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GriColors.forestPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                            icon: const Icon(Icons.description, size: 14),
                            label: const Text("View Guidelines", style: TextStyle(fontSize: 11)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 2. APAAR & UMIS IDs Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "APAAR ID — Automated Permanent Academic Account Registry",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Launched under NEP 2020 by the Ministry of Education, the APAAR ID is a unique 12-digit lifelong ID for every Indian student ('One Nation, One Student ID') connected to the Academic Bank of Credits (ABC).",
                        style: TextStyle(fontSize: 12, height: 1.35),
                      ),
                      const SizedBox(height: 10),
                      const Text("Mandatory Generation Steps:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      _buildIdStep("1", "Log in to DigiLocker portal (digilocker.gov.in) with Aadhaar credentials."),
                      _buildIdStep("2", "Search for 'Academic Bank of Credits' or 'APAAR' under Ministry of Education."),
                      _buildIdStep("3", "Select 'The Gandhigram Rural Institute' from institutional dropdown."),
                      _buildIdStep("4", "Submit roll number to generate your digital APAAR card."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "UMIS ID — University Management Information System",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Unified student registry mandated by the Tamil Nadu Higher Education Department for DBT scholarship disbursals and Naan Mudhalvan skill certifications.",
                        style: TextStyle(fontSize: 12, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Student Welfare & Anti-Ragging Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.gavel, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text("ZERO TOLERANCE TO RAGGING", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Ragging in any form is strictly banned inside and outside the GRI campus. Any student found guilty will face immediate expulsion, lodging of FIR with police, and cancellation of admission.",
                        style: TextStyle(fontSize: 12, height: 1.35),
                      ),
                      const SizedBox(height: 10),
                      const Text("National Anti-Ragging Helpline: 1800-180-5522 (Toll Free 24x7)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const Text("GRI Anti-Ragging Cell Email: antiragging@ruraluniv.ac.in", style: TextStyle(fontSize: 11.5)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Dean of Student Welfare (DSW)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary)),
                      const SizedBox(height: 4),
                      const Text("Dr. S. Manivel, Dean of Student Welfare", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const Text("Email: dsw@ruraluniv.ac.in • Phone: +91 451 2452371 Ext: 118", style: TextStyle(fontSize: 11.5)),
                      const SizedBox(height: 8),
                      const Text(
                        "Handles student hostel accommodations, welfare trusts, campus cultural activities, medical insurances, and internal complaints committee (ICC).",
                        style: TextStyle(fontSize: 12, height: 1.3),
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
  }

  Widget _buildIdStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: GriColors.forestPrimary,
            child: Text(num, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, height: 1.3))),
        ],
      ),
    );
  }
}
