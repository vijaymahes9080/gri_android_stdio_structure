import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

class ExaminationServicesScreen extends StatefulWidget {
  const ExaminationServicesScreen({super.key});

  @override
  State<ExaminationServicesScreen> createState() => _ExaminationServicesScreenState();
}

class _ExaminationServicesScreenState extends State<ExaminationServicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _timetables = [
    {"programme": "B.Sc. (Hons.) Agriculture - Sem VIII", "session": "Forenoon (10:00 AM - 01:00 PM)", "dates": "15 Nov 2026 - 28 Nov 2026", "centre": "Examination Hall A"},
    {"programme": "M.Sc. Data Analytics - Sem IV", "session": "Forenoon (10:00 AM - 01:00 PM)", "dates": "18 Nov 2026 - 30 Nov 2026", "centre": "Computer Centre Lab 2"},
    {"programme": "Master of Computer Applications (MCA) - Sem IV", "session": "Afternoon (02:00 PM - 05:00 PM)", "dates": "18 Nov 2026 - 02 Dec 2026", "centre": "Main Exam Hall C"},
    {"programme": "MBA (Rural Management) - Sem IV", "session": "Forenoon (10:00 AM - 01:00 PM)", "dates": "16 Nov 2026 - 01 Dec 2026", "centre": "Management Block Hall 1"},
    {"programme": "Diploma in Sanitary Inspector - Sem II", "session": "Afternoon (02:00 PM - 05:00 PM)", "dates": "20 Nov 2026 - 29 Nov 2026", "centre": "Health Sciences Hall"},
  ];

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
    final forms = seed.officialForms;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Examinations & Evaluation Services"),
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
            Tab(text: "Official COE Forms"),
            Tab(text: "ESE Timetables"),
            Tab(text: "Tatkal Scheme"),
            Tab(text: "e-SANAD Attestation"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Official Downloadable Forms Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final f = forms[index];
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: GriColors.forestPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(f["code"] ?? "", style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
                          ),
                          Text(f["authority"] ?? "", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(f["title"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      const SizedBox(height: 4),
                      Text(f["desc"] ?? "", style: const TextStyle(fontSize: 12, height: 1.3)),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(f["url"] ?? "", style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GriColors.forestPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                            icon: const Icon(Icons.download, size: 14),
                            label: const Text("Open Form", style: TextStyle(fontSize: 11)),
                            onPressed: () {
                              final code = f["code"] ?? "";
                              String docId = "DOC_COE_TRANSCRIPT";
                              if (code == "COE-02") docId = "DOC_COE_DUPLICATE_CERT";
                              OfficialResourceRegistry.openDocument(context, docId);
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

          // 2. End Semester Exam Timetables Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _timetables.length,
            itemBuilder: (context, index) {
              final t = _timetables[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t["programme"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 13, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text("Exam Window: ${t['dates']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 13, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text("Session: ${t['session']}", style: TextStyle(fontSize: 11.5, color: Colors.grey.shade800)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place, size: 13, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text("Venue: ${t['centre']}", style: TextStyle(fontSize: 11.5, color: Colors.grey.shade800)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 3. Tatkal Scheme Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: GriColors.ochrePrimary.withOpacity(0.12),
                child: const Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("TATKAL EXPEDITED CERTIFICATION SCHEME", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.ochrePrimary)),
                      SizedBox(height: 6),
                      Text(
                        "Under the Tatkal Scheme, students requiring urgent issuance of Provisional Certificate, Consolidated Statement of Marks, or Migration Certificate for employment or overseas admission can obtain verified documents within 48 to 72 hours.",
                        style: TextStyle(fontSize: 12, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTatkalFeeItem("Provisional Certificate", "Rs. 1,500/-", "Issued within 48 Hours"),
              _buildTatkalFeeItem("Consolidated Mark Statement", "Rs. 2,000/-", "Issued within 72 Hours"),
              _buildTatkalFeeItem("Migration Certificate", "Rs. 1,000/-", "Issued within 24 Hours"),
              _buildTatkalFeeItem("Official Transcript (Per Copy)", "Rs. 1,500/-", "Dispatched in 48 Hours"),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GriColors.forestPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
                icon: const Icon(Icons.open_in_browser),
                label: const Text("Open Tatkal Online Registration Form"),
                onPressed: () {},
              ),
            ],
          ),

          // 4. e-SANAD Digital Attestation Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text("Ministry of External Affairs e-SANAD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "e-SANAD is the project for online attestation/apostille of documents for Indian citizens traveling or seeking employment abroad. GRI has integrated its student examination repository with the e-SANAD portal.",
                        style: TextStyle(fontSize: 12, height: 1.35),
                      ),
                      const Divider(height: 20),
                      const Text("Step-by-Step Procedure:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      _buildStep("Step 1", "Register on the University e-SANAD portal (portal.ruraluniv.ac.in/esanad) and submit your certificate registration number."),
                      _buildStep("Step 2", "Pay institutional verification fee online and obtain GRI Verification Acknowledgment."),
                      _buildStep("Step 3", "Visit the MEA e-SANAD portal (esanad.nic.in) and upload document with GRI verification reference for electronic apostille."),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GriColors.forestPrimary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.launch, size: 14),
                        label: const Text("Launch e-SANAD Registration Portal"),
                        onPressed: () {},
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

  Widget _buildTatkalFeeItem(String service, String fee, String turnaround) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                Text("Turnaround: $turnaround", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
              ],
            ),
            Text(fee, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.ochrePrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
            child: Text(step, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, height: 1.3))),
        ],
      ),
    );
  }
}
