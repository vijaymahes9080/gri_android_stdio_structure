import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import 'department_detail_screen.dart';

/// Production-Grade Governance & Administration Screen
/// Displays verified official leadership roster, executive portraits, Deans, and statutory bodies
/// backed by the official Gandhigram Rural Institute catalog.
class GovernanceLeadershipScreen extends StatefulWidget {
  const GovernanceLeadershipScreen({super.key});

  @override
  State<GovernanceLeadershipScreen> createState() => _GovernanceLeadershipScreenState();
}

class _GovernanceLeadershipScreenState extends State<GovernanceLeadershipScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (!OfficialCatalogService.instance.isLoaded) {
      OfficialCatalogService.instance.ensureLoaded().then((_) {
        if (mounted) setState(() {});
      }).catchError((_) {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(BuildContext context, String? url) async {
    if (url == null || url.trim().isEmpty) return;
    final uri = Uri.parse(url.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not open: $url"),
          backgroundColor: GriColors.forestPrimary,
        ),
      );
    }
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

  String _cleanTitle(String raw) {
    return raw.replaceAll(RegExp(r'\s*↗'), '').trim();
  }

  Widget _buildAvatar(String? assetPath, String name, {double size = 56}) {
    final clean = _cleanTitle(name);
    final initials = clean.isNotEmpty
        ? clean.split(' ').where((p) => p.isNotEmpty).take(2).map((p) => p[0]).join()
        : 'GRI';

    final resolvedAsset = assetPath != null && assetPath.isNotEmpty
        ? OfficialCatalogService.assetKey(assetPath)
        : '';

    if (resolvedAsset.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: GriColors.forestPrimary.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            resolvedAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallbackAvatar(initials, size),
          ),
        ),
      );
    }
    return _fallbackAvatar(initials, size);
  }

  Widget _fallbackAvatar(String text, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GriColors.forestContainer,
        border: Border.all(
          color: GriColors.forestPrimary.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size * 0.34,
          fontWeight: FontWeight.bold,
          color: GriColors.forestPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catalog = OfficialCatalogService.instance;
    final leaders = catalog.leadership;
    final schools = catalog.schools.isNotEmpty ? catalog.schools : null;
    final seedSchools = SeedDataService.instance.schools;

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
          leaders.isNotEmpty
              ? _buildOfficialLeadersList(context, isDark, leaders)
              : _buildLegacyLeadersList(context, isDark),

          // 2. Deans & Heads of Departments
          schools != null
              ? _buildOfficialSchoolsList(context, isDark, schools, catalog)
              : _buildLegacySchoolsList(context, isDark, seedSchools),

          // 3. Statutory Councils
          _buildCouncilsTab(context, isDark),
        ],
      ),
    );
  }

  Widget _buildOfficialLeadersList(
      BuildContext context, bool isDark, List<OfficialLeader> leaders) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: leaders.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeaderBanner(
            context,
            isDark,
            title: "STATUTORY UNIVERSITY OFFICERS",
            subtitle:
                "Verified executive administration of The Gandhigram Rural Institute (Deemed to be University), accredited A++ by NAAC.",
            badge: "${leaders.length} Verified Officers",
          );
        }

        final leader = leaders[index - 1];
        final cleanName = _cleanTitle(leader.name);
        final cleanDesig = _cleanTitle(leader.designation);

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
              _buildAvatar(leader.photoAsset, cleanName, size: 58),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            cleanName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                              color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            cleanDesig,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: GriColors.forestPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (leader.portfolio.isNotEmpty && leader.portfolio != cleanDesig) ...[
                      const SizedBox(height: 4),
                      Text(
                        leader.portfolio,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    if (leader.email.isNotEmpty)
                      InkWell(
                        onTap: () => _launchEmail(context, leader.email),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.email_outlined,
                                  size: 13, color: GriColors.forestPrimary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  leader.email,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 9, color: GriColors.forestPrimary),
                            ],
                          ),
                        ),
                      ),
                    if (leader.phone.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      InkWell(
                        onTap: () => _launchPhone(context, leader.phone),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_outlined,
                                  size: 13, color: GriColors.forestPrimary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  leader.phone,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                  ),
                                ),
                              ),
                              const Icon(Icons.phone_forwarded,
                                  size: 10, color: GriColors.forestPrimary),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (leader.contactNote.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        leader.contactNote,
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (leader.profileUrl.isNotEmpty || leader.sourceUrl.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: BorderSide(
                              color: GriColors.forestPrimary.withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () => _launchUrl(
                            context,
                            leader.profileUrl.isNotEmpty ? leader.profileUrl : leader.sourceUrl,
                          ),
                          icon: const Icon(Icons.open_in_new, size: 11, color: GriColors.forestPrimary),
                          label: const Text(
                            "Official Profile",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: GriColors.forestPrimary),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfficialSchoolsList(BuildContext context, bool isDark,
      List<OfficialSchool> schools, OfficialCatalogService catalog) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: schools.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeaderBanner(
            context,
            isDark,
            title: "STATUTORY SCHOOLS & DEANS",
            subtitle:
                "9 Academic Schools of Study and KAUSHAL Kendra comprising 33 specialized teaching departments and research centres.",
            badge: "${schools.length} Schools of Study",
          );
        }

        final sch = schools[index - 1];
        final cleanDean = _cleanTitle(sch.deanName);
        final cleanDesig = _cleanTitle(sch.deanDesignation);
        final depts = catalog.unitsForSchool(sch.id);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sch.deanPhotoAsset.isNotEmpty) ...[
                    _buildAvatar(sch.deanPhotoAsset, cleanDean, size: 46),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sch.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                          ),
                        ),
                        if (cleanDean.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            "Dean: $cleanDean",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: isDark ? GriColors.darkOnSurface : Colors.black87,
                            ),
                          ),
                          if (cleanDesig.isNotEmpty)
                            Text(
                              cleanDesig,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: isDark
                                    ? GriColors.darkOnSurfaceVariant
                                    : GriColors.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${sch.programmeCount} Progs",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: GriColors.ochrePrimary,
                      ),
                    ),
                  ),
                ],
              ),
              if (depts.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Text(
                  "Departments & Units (${depts.length}):",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: depts.map((d) {
                    final facultyCount = catalog.facultyForUnit(d.id).length;
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DepartmentDetailScreen(
                              departmentId: d.id,
                              departmentName: d.name,
                              schoolName: sch.name,
                              hodName: cleanDean,
                              email: "grucc@ruraluniv.ac.in",
                              phone: "0451-2452371",
                              sourceUrl: d.url,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                            width: 0.7,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              d.name,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                              ),
                            ),
                            if (facultyCount > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: GriColors.forestPrimary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "$facultyCount",
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: GriColors.forestPrimary,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 3),
                            const Icon(Icons.arrow_forward, size: 10, color: GriColors.forestPrimary),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegacyLeadersList(BuildContext context, bool isDark) {
    final officers = SeedDataService.instance.officialLeadership;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: officers.length,
      itemBuilder: (context, index) {
        final o = officers[index];
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
                o["name"] ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                o["designation"] ?? "",
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: GriColors.forestPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                o["portfolio"] ?? "",
                style: TextStyle(fontSize: 11, color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegacySchoolsList(
      BuildContext context, bool isDark, List<SchoolItem> schools) {
    return ListView.builder(
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildCouncilsTab(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _buildHeaderBanner(
          context,
          isDark,
          title: "STATUTORY GOVERNANCE COUNCILS",
          subtitle:
              "High-level decision-making authorities constituted under the UGC Deemed to be University Regulations and GRI Memorandum of Association.",
          badge: "4 Apex Bodies",
        ),
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
    );
  }

  Widget _buildHeaderBanner(
    BuildContext context,
    bool isDark, {
    required String title,
    required String subtitle,
    required String badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.2 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.35 : 0.15),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: GriColors.forestPrimary,
                  letterSpacing: 0.6,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: GriColors.forestPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
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
