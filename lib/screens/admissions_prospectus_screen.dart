import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

/// Production-Grade Admissions & Prospectus Screen
/// Features downloadable prospectuses, UGC statutory refund policy, research norms, and verified portals.
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final seed = SeedDataService.instance;
    final prospectuses = seed.officialProspectuses;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Admissions & Prospectuses",
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: prospectuses.length,
            itemBuilder: (context, index) {
              final p = prospectuses[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Academic Year ${p['year']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                        Text(
                          "Size: ${p['size']}",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p["title"] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      p["summary"] as String,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (p["programmes"] as List<String>)
                          .map((prog) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  prog,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
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
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GriColors.forestPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.download, size: 14),
                          label: const Text(
                            "Open Prospectus",
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            final docId = p['year'] == '2026-27' ? 'DOC_PROSPECTUS_2026' : 'DOC_PROSPECTUS_2025';
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

          // 2. Higher Doctorates & Research Degrees Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildResearchCard(
                context,
                "Ph.D. Regulations & Norms",
                "Full-time and part-time doctoral research guidelines governed by UGC Regulations 2022. Course work examination, RAC committee reviews, and synopsis submission guidelines.",
                "https://ruraluniv.ac.in/admissions?content=PhD_Regulations",
              ),
              const SizedBox(height: 12),
              _buildResearchCard(
                context,
                "M.Phil. Regulations",
                "Regulations governing pre-doctoral Master of Philosophy programmes across Humanities, Rural Development, and Sciences.",
                "https://ruraluniv.ac.in/admissions?content=MPhil_Regulations",
              ),
              const SizedBox(height: 12),
              _buildResearchCard(
                context,
                "D.Sc. & D.Litt. Regulations (Higher Doctorates)",
                "Post-doctoral higher doctoral awards recognizing sustained, internationally distinguished contributions in science, literature, and rural sociology.",
                "https://ruraluniv.ac.in/admissions?content=Dsc_Regulations",
              ),
              const SizedBox(height: 12),
              _buildResearchCard(
                context,
                "D.Sc. and D.Litt. Official Application Form",
                "Prescribed downloadable registration application dossier for candidates submitting published works for higher doctorate evaluation.",
                "https://ruraluniv.ac.in/admn1?content=Dsc_app",
              ),
            ],
          ),

          // 3. Fee & Statutory Refund Policies Tab
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
                    Text(
                      "UGC STATUTORY FEE REFUND POLICY",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Adheres strictly to the UGC Notification on Refund of Fees and Non-Retention of Original Certificates:",
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPolicyRow(context, "100% Refund", "15 days or more before formally notified last date of admission."),
                    _buildPolicyRow(context, "90% Refund", "Less than 15 days before formally notified last date."),
                    _buildPolicyRow(context, "80% Refund", "15 days or less after formally notified last date of admission."),
                    _buildPolicyRow(context, "50% Refund", "30 days or less, but more than 15 days, after last date."),
                    _buildPolicyRow(context, "0% (Nil)", "More than 30 days after formally notified last date."),
                  ],
                ),
              ),
              const SizedBox(height: 14),
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
                    Text(
                      "HOSTEL FEES & MESS DEPOSITS",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Residential hostels operate on a dividing system with cooperative mess management:",
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPolicyRow(context, "Admission Fee", "Rs. 1,000/- (One time, Non-refundable)"),
                    _buildPolicyRow(context, "Room Rent & Water", "Rs. 4,500/- Per Semester"),
                    _buildPolicyRow(context, "Caution Deposit", "Rs. 3,000/- (Refundable upon vacating)"),
                    _buildPolicyRow(context, "Mess Advance", "Rs. 18,000/- Per Semester (Dividing mess system)"),
                  ],
                ),
              ),
            ],
          ),

          // 4. Online Portals Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildPortalCard(
                context,
                "Samarth@GRI Admission & Academic Portal",
                "Official e-Governance portal for online registration, application fee payment, entrance admit cards, and student enrollment verification.",
                "https://ruraluniv.samarth.ac.in/index.php/site/login",
                Icons.account_balance,
              ),
              const SizedBox(height: 14),
              _buildPortalCard(
                context,
                "Study in India (SII) Portal",
                "Government of India centralized portal for international foreign nationals and NRI students applying for higher education at GRI.",
                "https://www.studyinindia.gov.in/admission/registrations",
                Icons.public,
              ),
              const SizedBox(height: 14),
              _buildPortalCard(
                context,
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

  Widget _buildResearchCard(BuildContext context, String title, String desc, String url) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
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
                  url,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text("View Norms", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(foregroundColor: GriColors.forestPrimary),
                onPressed: () {
                  OfficialResourceRegistry.smartOpenDocument(context, url, title: title);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyRow(BuildContext context, String left, String right) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
                color: GriColors.forestPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              right,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? GriColors.darkOnSurface : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortalCard(BuildContext context, String title, String desc, String url, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
              Icon(icon, color: GriColors.forestPrimary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: GriColors.forestPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.launch, size: 14),
            label: const Text("Open Portal", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
            onPressed: () {
              OfficialResourceRegistry.smartOpenDocument(context, url, title: title);
            },
          ),
        ],
      ),
    );
  }
}
