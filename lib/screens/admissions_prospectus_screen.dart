import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

class AdmissionsProspectusScreen extends StatefulWidget {
  const AdmissionsProspectusScreen({super.key});

  @override
  State<AdmissionsProspectusScreen> createState() => _AdmissionsProspectusScreenState();
}

class _AdmissionsProspectusScreenState extends State<AdmissionsProspectusScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seed = SeedDataService.instance;
    final prospectuses = seed.officialProspectuses;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admissions & Prospectuses"),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: GriColors.ochrePrimary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: "Official Prospectuses"),
            Tab(text: "Research Regulations"),
            Tab(text: "Fee & Refund Policies"),
            Tab(text: "Online Portals"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Official Prospectuses Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prospectuses.length,
            itemBuilder: (context, index) {
              final p = prospectuses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: GriColors.forestPrimary, borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              "Academic Year ${p['year']}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          Text("Size: ${p['size']}", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        p["title"] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p["summary"] as String,
                        style: const TextStyle(fontSize: 12, height: 1.35),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (p["programmes"] as List<String>)
                            .map((prog) => Chip(
                                  label: Text(prog, style: const TextStyle(fontSize: 10.5)),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              p["pdfUrl"] as String,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GriColors.ochrePrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                            icon: const Icon(Icons.download, size: 14),
                            label: const Text("Download PDF", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Downloading ${p['title']}..."),
                                  backgroundColor: GriColors.forestPrimary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 2. Higher Doctorates & Research Degrees Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildResearchCard(
                "Ph.D. Regulations & Norms",
                "Full-time and part-time doctoral research guidelines governed by UGC Regulations 2022. Course work examination, RAC committee reviews, and synopsis submission guidelines.",
                "admissions?content=PhD_Regulations",
              ),
              const SizedBox(height: 12),
              _buildResearchCard(
                "M.Phil. Regulations",
                "Regulations governing pre-doctoral Master of Philosophy programmes across Humanities, Rural Development, and Sciences.",
                "admissions?content=MPhil_Regulations",
              ),
              const SizedBox(height: 12),
              _buildResearchCard(
                "D.Sc. & D.Litt. Regulations (Higher Doctorates)",
                "Post-doctoral higher doctoral awards recognizing sustained, internationally distinguished contributions in science, literature, and rural sociology.",
                "admissions?content=Dsc_Regulations",
              ),
              const SizedBox(height: 12),
              _buildResearchCard(
                "D.Sc. and D.Litt. Official Application Form",
                "Prescribed downloadable registration application dossier for candidates submitting published works for higher doctorate evaluation.",
                "https://ruraluniv.ac.in/admn1?content=Dsc_app",
              ),
            ],
          ),

          // 3. Fee & Statutory Refund Policies Tab
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
                        "UGC STATUTORY FEE REFUND POLICY",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Adheres strictly to the UGC Notification on Refund of Fees and Non-Retention of Original Certificates:",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      _buildPolicyRow("100% Refund", "15 days or more before formally notified last date of admission."),
                      _buildPolicyRow("90% Refund", "Less than 15 days before formally notified last date."),
                      _buildPolicyRow("80% Refund", "15 days or less after formally notified last date of admission."),
                      _buildPolicyRow("50% Refund", "30 days or less, but more than 15 days, after last date."),
                      _buildPolicyRow("0% (Nil)", "More than 30 days after formally notified last date."),
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
                        "HOSTEL FEES & MESS DEPOSITS",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Residential hostels operate on a dividing system with cooperative mess management:",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      _buildPolicyRow("Admission Fee", "Rs. 1,000/- (One time, Non-refundable)"),
                      _buildPolicyRow("Room Rent & Water", "Rs. 4,500/- Per Semester"),
                      _buildPolicyRow("Caution Deposit", "Rs. 3,000/- (Refundable upon vacating)"),
                      _buildPolicyRow("Mess Advance", "Rs. 18,000/- Per Semester (Dividing mess system)"),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 4. Online Portals Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPortalCard(
                "Samarth@GRI Admission & Academic Portal",
                "Official e-Governance portal for online registration, application fee payment, entrance admit cards, and student enrollment verification.",
                "https://ruraluniv.samarth.ac.in/index.php/site/login",
                Icons.account_balance,
              ),
              const SizedBox(height: 14),
              _buildPortalCard(
                "Study in India (SII) Portal",
                "Government of India centralized portal for international foreign nationals and NRI students applying for higher education at GRI.",
                "https://www.studyinindia.gov.in/admission/registrations",
                Icons.public,
              ),
              const SizedBox(height: 14),
              _buildPortalCard(
                "GRIIMS Ph.D. Scholar Tracking System",
                "Online research portal for research scholars, supervisors, and doctoral committees to record RAC meetings and thesis progress.",
                "https://www.ruraluniv.ac.in/GRIIMS1/",
                Icons.biotech,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResearchCard(String title, String desc, String url) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary)),
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(fontSize: 12, height: 1.35)),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ref: $url", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                TextButton.icon(
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text("View Norms", style: TextStyle(fontSize: 11.5)),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(left, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: GriColors.forestPrimary)),
          ),
          Expanded(child: Text(right, style: const TextStyle(fontSize: 11.5))),
        ],
      ),
    );
  }

  Widget _buildPortalCard(String title, String desc, String url, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: GriColors.forestPrimary),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              ],
            ),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(fontSize: 12, height: 1.35)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: GriColors.forestPrimary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.launch, size: 14),
              label: const Text("Open Portal", style: TextStyle(fontSize: 12)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
