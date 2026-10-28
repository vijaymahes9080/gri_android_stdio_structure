import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/official_resource_registry.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final seed = SeedDataService.instance;
    final scholarships = seed.officialScholarships;
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Scholarships & Student Welfare",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: scholarships.length,
            itemBuilder: (context, index) {
              final s = scholarships[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                          Expanded(
                            child: Text(
                              s["title"] as String,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "AY 2026-27",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Sanctioning Body: ${s['authority']}",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Beneficiary: ${s['beneficiary']}",
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s["details"] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GriPressable(
                            onTap: () {
                              final noticeUrl = s['noticeUrl'] as String? ?? 'https://scholarships.gov.in/';
                              OfficialResourceRegistry.openDocument(context, s['title'] as String, noticeUrl);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: borderColor, width: 0.8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.open_in_new, size: 13, color: GriColors.forestPrimary),
                                  SizedBox(width: 5),
                                  Text(
                                    "Apply / Portal Guidelines",
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
              );
            },
          ),

          // 2. APAAR & UMIS IDs Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
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
                      const Text(
                        "APAAR ID — Automated Permanent Academic Account Registry",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Launched under NEP 2020 by the Ministry of Education, Government of India, the APAAR ID is a unique 12-digit lifelong student ID ('One Nation, One Student ID') connected to the Academic Bank of Credits (ABC) to store degrees, diplomas, and credits digitally.",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Mandatory Generation Steps:",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      _buildIdStep("1", "Log in to DigiLocker portal (digilocker.gov.in) with Aadhaar credentials.", isDark),
                      _buildIdStep("2", "Search for 'Academic Bank of Credits' or 'APAAR' under Ministry of Education.", isDark),
                      _buildIdStep("3", "Select 'The Gandhigram Rural Institute' from institutional dropdown.", isDark),
                      _buildIdStep("4", "Submit university roll number to generate your digital APAAR card.", isDark),
                      const SizedBox(height: 12),
                      GriPressable(
                        onTap: () async {
                          final uri = Uri.parse("https://www.abc.gov.in/");
                          if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.badge_outlined, size: 14, color: GriColors.forestPrimary),
                              SizedBox(width: 6),
                              Text(
                                "Launch Academic Bank of Credits (ABC)",
                                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                      const Text(
                        "UMIS ID — University Management Information System",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Mandatory state student registry administered by the Tamil Nadu Higher Education Department. Required for all state government DBT scholarship disbursals, bus concessions, and Naan Mudhalvan skill certifications.",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GriPressable(
                        onTap: () async {
                          final uri = Uri.parse("https://umis.tn.gov.in/");
                          if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.account_balance_outlined, size: 14, color: GriColors.forestPrimary),
                              SizedBox(width: 6),
                              Text(
                                "Open Tamil Nadu UMIS Portal",
                                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Student Welfare & Anti-Ragging Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF241515) : const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF4A2525) : const Color(0xFFFFD4D4),
                    width: 0.8,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.gavel, color: isDark ? GriColors.errorBright : GriColors.error, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "ZERO TOLERANCE TO RAGGING",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: isDark ? GriColors.errorBright : GriColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ragging in any form is strictly banned inside and outside the GRI campus in accordance with Supreme Court and UGC directives. Any student found abetting or guilty will face immediate expulsion, filing of police FIR, and debarment.",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? GriColors.errorBright : GriColors.error,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GriPressable(
                              onTap: () async {
                                final uri = Uri.parse("tel:18001805522");
                                if (await canLaunchUrl(uri)) await launchUrl(uri);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.errorBright.withValues(alpha: 0.16) : GriColors.errorContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.call, size: 13, color: isDark ? GriColors.errorBright : GriColors.error),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Toll Free: 1800-180-5522",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? GriColors.errorBright : GriColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GriPressable(
                              onTap: () async {
                                final uri = Uri.parse("mailto:antiragging@ruraluniv.ac.in");
                                if (await canLaunchUrl(uri)) await launchUrl(uri);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.errorBright.withValues(alpha: 0.16) : GriColors.errorContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.mail_outline, size: 13, color: isDark ? GriColors.errorBright : GriColors.error),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Email Cell",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? GriColors.errorBright : GriColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                      const Text(
                        "Office of the Dean of Student Welfare (DSW)",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Dr. S. Manivel — Dean, Student Welfare",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Administration Complex, GRI • Ext: 118",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Responsible for student hostel welfare, student council activities, youth festivals, sports travel insurance, cultural clubs, and internal grievance escalation.",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GriPressable(
                              onTap: () async {
                                final uri = Uri.parse("mailto:dsw@ruraluniv.ac.in");
                                if (await canLaunchUrl(uri)) await launchUrl(uri);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: borderColor, width: 0.8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.email_outlined, size: 13, color: GriColors.forestPrimary),
                                    SizedBox(width: 5),
                                    Text(
                                      "dsw@ruraluniv.ac.in",
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GriPressable(
                              onTap: () async {
                                final uri = Uri.parse("tel:+914512452371");
                                if (await canLaunchUrl(uri)) await launchUrl(uri);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: borderColor, width: 0.8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.phone_outlined, size: 13, color: GriColors.forestPrimary),
                                    SizedBox(width: 5),
                                    Text(
                                      "+91 451 2452371",
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildIdStep(String num, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: GriColors.forestPrimary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              num,
              style: const TextStyle(fontSize: 10, color: GriColors.forestPrimary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
