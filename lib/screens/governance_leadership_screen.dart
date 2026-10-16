import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

/// Production-Grade Governance & Administration Screen
/// Displays official leadership roster, executive portraits, statutory bodies, and Deans.
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

  Future<void> _launchEmail(BuildContext context, String? email) async {
    if (email == null || email.trim().isEmpty) return;
    final clean = email.trim();
    final uri = Uri.parse("mailto:$clean");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(ClipboardData(text: clean));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email copied to clipboard: $clean"),
            backgroundColor: GriColors.forestPrimary,
          ),
        );
      }
    }
  }

  Future<void> _launchPhone(BuildContext context, String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse("tel:$clean");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(ClipboardData(text: phone));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Phone copied to clipboard: $phone"),
            backgroundColor: GriColors.forestPrimary,
          ),
        );
      }
    }
  }

  String? _getOfficerImage(String? designation) {
    if (designation == null) return null;
    final d = designation.toLowerCase();
    if (d.contains('chancellor') && !d.contains('vice')) {
      return 'assets/official/images/chancellor_annamalai.jpg';
    } else if (d.contains('vice')) {
      return 'assets/official/images/vice_chancellor_panchanatham.jpg';
    } else if (d.contains('registrar')) {
      return 'assets/official/images/registrar_marimuthu.jpg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final seed = SeedDataService.instance;
    final officers = seed.officialLeadership;
    final schools = seed.schools;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Governance & Authorities",
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: officers.length,
            itemBuilder: (context, index) {
              final o = officers[index];
              final imageAsset = _getOfficerImage(o["designation"]);

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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Official Executive Portrait
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: GriColors.forestPrimary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: imageAsset != null
                            ? Image.asset(
                                imageAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => CircleAvatar(
                                  backgroundColor: GriColors.forestContainer,
                                  child: Icon(Icons.person, color: colorScheme.primary, size: 28),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: GriColors.forestContainer,
                                child: Icon(Icons.account_balance, color: colorScheme.primary, size: 24),
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Executive Metadata
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  o["name"] ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  o["designation"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: GriColors.forestPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            o["portfolio"] ?? "",
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.35,
                              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _launchEmail(context, o["email"]),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.email_outlined, size: 13, color: GriColors.forestPrimary),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      o["email"] ?? "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                                        decoration: TextDecoration.underline,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 9, color: GriColors.forestPrimary),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          InkWell(
                            onTap: () => _launchPhone(context, o["phone"]),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_outlined, size: 13, color: GriColors.forestPrimary),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      o["phone"] ?? "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.phone_forwarded, size: 10, color: GriColors.forestPrimary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. Deans & Heads of Departments
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final sch = schools[index];
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
                      sch.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Dean: ${sch.dean}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5,
                        color: isDark ? GriColors.darkOnSurface : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _launchEmail(context, sch.deanEmail),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.2 : 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.email_outlined, size: 12, color: GriColors.forestPrimary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      sch.deanEmail,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _launchPhone(context, sch.deanPhone),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant, width: 0.8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.phone, size: 12, color: GriColors.forestPrimary),
                                const SizedBox(width: 4),
                                Text(
                                  sch.deanPhone,
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Highlights: ${sch.highlights}",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 3. Statutory Councils
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildCouncilCard(
                context,
                "Executive Council (EC)",
                "The highest governing body of the Institute, responsible for the general superintendence, direction, and management of the university affairs.",
                "Vice-Chancellor (Chairman), 2 Deans by rotation, 1 Professor, 1 Associate Professor, 4 MHRD/UGC Nominees, Registrar (Secretary).",
                "Meets at least four times annually.",
              ),
              const SizedBox(height: 12),
              _buildCouncilCard(
                context,
                "Academic Council",
                "The principal academic body responsible for the maintenance of standards of education, teaching, research, and examination within the university.",
                "Vice-Chancellor (Chairman), All Deans of Schools, All Heads of Departments, 3 Professors by rotation, External Academic Experts, Registrar (Secretary).",
                "Meets once every semester prior to Board of Studies approvals.",
              ),
              const SizedBox(height: 12),
              _buildCouncilCard(
                context,
                "Planning & Monitoring Board",
                "Monitors academic development programmes, perspective five-year plans, infrastructure expansion, and UGC development grant allocations.",
                "Vice-Chancellor (Chairman), 3 External Nominees of UGC/MHRD, 2 Internal Senior Professors, Registrar.",
                "Annual strategic appraisal.",
              ),
              const SizedBox(height: 12),
              _buildCouncilCard(
                context,
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

  Widget _buildCouncilCard(
    BuildContext context,
    String title,
    String role,
    String composition,
    String frequency,
  ) {
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
              fontSize: 13.5,
              color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            role,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),
          const Text("Key Composition:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            composition,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 13, color: GriColors.ochrePrimary),
              const SizedBox(width: 4),
              Text(
                frequency,
                style: const TextStyle(
                  fontSize: 11,
                  color: GriColors.ochrePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
