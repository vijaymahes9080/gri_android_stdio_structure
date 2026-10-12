import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

/// Production-Grade Examinations & Controller of Examinations (COE) Screen
/// Covers official COE forms, ESE exam timetables, Tatkal Scheme, and e-SANAD attestation.
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final seed = SeedDataService.instance;
    final forms = seed.officialForms;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Examinations & COE Services",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final f = forms[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface1 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                    width: 1.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            f["code"] ?? "",
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: GriColors.forestPrimary,
                            ),
                          ),
                        ),
                        Text(
                          f["authority"] ?? "",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      f["title"] ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      f["desc"] ?? "",
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.35,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            f["url"] ?? "",
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GriColors.forestPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.download, size: 14),
                          label: const Text("Open Form", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
              );
            },
          ),

          // 2. End Semester Exam Timetables Tab
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: _timetables.length,
            itemBuilder: (context, index) {
              final t = _timetables[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface1 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t["programme"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 13, color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Exam Window: ${t['dates']}",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? GriColors.darkOnSurface : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 13, color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Session: ${t['session']}",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.place, size: 13, color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Venue: ${t['centre']}",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // 3. Tatkal Scheme Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: GriColors.ochrePrimary.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TATKAL EXPEDITED CERTIFICATION SCHEME",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: GriColors.ochrePrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Under the Tatkal Scheme, students requiring urgent issuance of Provisional Certificate, Consolidated Statement of Marks, or Migration Certificate for employment or overseas admission can obtain verified documents within 48 to 72 hours.",
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: isDark ? GriColors.darkOnSurface : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildTatkalFeeItem(context, "Provisional Certificate", "Rs. 1,500/-", "Issued within 48 Hours"),
              _buildTatkalFeeItem(context, "Consolidated Mark Statement", "Rs. 2,000/-", "Issued within 72 Hours"),
              _buildTatkalFeeItem(context, "Migration Certificate", "Rs. 1,000/-", "Issued within 24 Hours"),
              _buildTatkalFeeItem(context, "Official Transcript (Per Copy)", "Rs. 1,500/-", "Dispatched in 48 Hours"),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GriColors.forestPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.open_in_browser, size: 16),
                label: const Text("Open Tatkal Online Registration Form", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  OfficialResourceRegistry.smartOpenDocument(
                    context,
                    "https://ruraluniv.ac.in/examination?content=tatkal",
                    title: "Tatkal Expedited Scheme",
                  );
                },
              ),
            ],
          ),

          // 4. e-SANAD Digital Attestation Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface1 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Ministry of External Affairs e-SANAD",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "e-SANAD is the project for online attestation/apostille of documents for Indian citizens traveling or seeking employment abroad. GRI has integrated its student examination repository with the e-SANAD portal.",
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.35,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    const Text("Step-by-Step Procedure:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    const SizedBox(height: 6),
                    _buildStep(context, "Step 1", "Register on the University e-SANAD portal (portal.ruraluniv.ac.in/esanad) and submit your certificate registration number."),
                    _buildStep(context, "Step 2", "Pay institutional verification fee online and obtain GRI Verification Acknowledgment."),
                    _buildStep(context, "Step 3", "Visit the MEA e-SANAD portal (esanad.nic.in) and upload document with GRI verification reference for electronic apostille."),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GriColors.forestPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.launch, size: 16),
                      label: const Text("Launch e-SANAD Registration Portal", style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        OfficialResourceRegistry.smartOpenDocument(
                          context,
                          "https://portal.ruraluniv.ac.in/esanad",
                          title: "e-SANAD Portal",
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTatkalFeeItem(BuildContext context, String service, String fee, String turnaround) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Turnaround: $turnaround",
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Text(
            fee,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: GriColors.ochrePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, String step, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface2 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              step,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark ? GriColors.darkOnSurface : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.35,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
