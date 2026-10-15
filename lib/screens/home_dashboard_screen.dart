import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/academic_models.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import 'schools_programmes_hub_screen.dart';
import 'admissions_prospectus_screen.dart';
import 'governance_leadership_screen.dart';
import 'examination_services_screen.dart';
import 'scholarships_welfare_screen.dart';
import 'campus_facilities_screen.dart';
import 'document_vault_screen.dart';
import 'global_website_search_screen.dart';
import 'official_portals_gateway_screen.dart';
import '../services/official_resource_registry.dart';

/// Production-Grade Home Dashboard for The Gandhigram Rural Institute
/// Engineered to executive government & university digital standards:
/// - Authoritative institutional header with NAAC 'A' accreditation
/// - Prominent universal catalog search across 247 official URLs
/// - Live circulars ticker with server sync & fallback
/// - Bento-style 8-module academic grid
/// - Interactive student/faculty desk & quick services
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final user = provider.currentUser;

    return RefreshIndicator(
      onRefresh: () => provider.triggerCloudSync(),
      color: colorScheme.primary,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // 1. Executive Institutional Header Card (Khadi Ivory & Forest Tone)
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 30),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? GriColors.darkSurface1 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  width: 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: User Avatar, Identity & Role Switcher
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with Institutional Border
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: GriColors.forestPrimary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/student_avatar.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => CircleAvatar(
                                backgroundColor: GriColors.forestContainer,
                                child: Icon(Icons.person, color: colorScheme.primary, size: 24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name, Roll Number, Department
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user?.name ?? "Vijay Pradhap",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.1,
                                        color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified,
                                    color: GriColors.ochrePrimary,
                                    size: 15,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${user?.rollNo ?? '2024-MS-4011'} • ${user?.department ?? 'Computer Science'}",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Role Selector Action Pill
                        InkWell(
                          onTap: () => provider.toggleRoleSwitcher(true),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: GriColors.forestPrimary.withValues(alpha: 0.25),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swap_horiz, size: 13, color: GriColors.forestPrimary),
                                const SizedBox(width: 4),
                                Text(
                                  provider.currentRole.name,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: GriColors.forestPrimary,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Academic Metrics Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric(context, "Semester", user?.semester ?? "Sem IV"),
                        _buildMetricDivider(context),
                        _buildMetric(context, "CGPA", user?.cgpa ?? "8.92"),
                        _buildMetricDivider(context),
                        _buildMetric(context, "Attendance", "87%", isHighlight: true),
                        _buildMetricDivider(context),
                        _buildMetric(context, "Hostel", user?.isHostelite == true ? "Kasturba" : "Day Scholar"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2. Prominent Universal Catalog Search Bar
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 60),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GlobalWebsiteSearchScreen()),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface2 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.forestPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Search 309 official pages, 602 documents, syllabi...",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "309 URLs",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: GriColors.forestPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Live University Circulars & Important Announcements
          if (provider.circulars.isNotEmpty) ...[
            GriFadeSlideEntrance(
              delay: const Duration(milliseconds: 90),
              child: Builder(
                builder: (context) {
                  final urgent = provider.circulars.firstWhere(
                    (c) => c.isUrgent,
                    orElse: () => provider.circulars.first,
                  );
                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? GriColors.darkSurface2 : GriColors.warningContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: GriColors.warning.withValues(alpha: 0.25),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: GriColors.warning.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.campaign, color: GriColors.warning, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: GriColors.warning,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "LIVE NOTICE",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    urgent.publishedDate,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                urgent.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                urgent.summary,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                  height: 1.35,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Source: ${urgent.issuedBy}",
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const DocumentVaultScreen(initialCategory: "Circulars"),
                                        ),
                                      );
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Open Circular",
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: GriColors.forestPrimary,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Icon(Icons.arrow_forward, size: 12, color: GriColors.forestPrimary),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
          ],

          // 4. Quick Campus Services Hub (8 Grid Actions)
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "QUICK SERVICES DOCK",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Essential Portals",
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.95,
                  children: [
                    _buildQuickAction(
                      context: context,
                      icon: Icons.school_outlined,
                      label: "Courses",
                      color: GriColors.forestPrimary,
                      onTap: () => provider.switchTab(NavigationTab.ACADEMICS),
                    ),
                    _buildQuickAction(
                      context: context,
                      icon: Icons.confirmation_number_outlined,
                      label: "Hall Ticket",
                      color: GriColors.ochrePrimary,
                      onTap: () => provider.fetchHallTicket(),
                    ),
                    _buildQuickAction(
                      context: context,
                      icon: Icons.map_outlined,
                      label: "Campus Map",
                      color: GriColors.tealSecondary,
                      onTap: () => provider.switchTab(NavigationTab.CAMPUS),
                    ),
                    _buildQuickAction(
                      context: context,
                      icon: Icons.support_agent_outlined,
                      label: "Grievances",
                      color: GriColors.forestPrimary,
                      onTap: () => provider.switchTab(NavigationTab.SERVICES),
                    ),
                    _buildQuickAction(
                      context: context,
                      icon: Icons.auto_awesome_outlined,
                      label: "Ask AI",
                      color: GriColors.ochrePrimary,
                      onTap: () => provider.toggleAskAi(true),
                    ),
                    _buildQuickAction(
                      context: context,
                      icon: Icons.verified_outlined,
                      label: "Documents",
                      color: GriColors.tealSecondary,
                      onTap: () => provider.toggleDocumentCenter(true),
                    ),
                    _buildQuickAction(
                      context: context,
                      icon: Icons.badge_outlined,
                      label: "Staff Portal",
                      color: GriColors.forestPrimary,
                      onTap: () => provider.toggleFacultyPortal(true),
                    ),
                    _buildQuickAction(
                      context: context,
                      icon: Icons.account_balance_outlined,
                      label: "Directory",
                      color: GriColors.tealSecondary,
                      onTap: () => provider.switchTab(NavigationTab.MORE),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. Bento Academic Grid: 8 Core University Modules
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "INSTITUTIONAL MODULES",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        "Official ruraluniv.ac.in",
                        style: TextStyle(
                          fontSize: 10,
                          color: GriColors.forestPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 2-Column Bento Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.45,
                  children: [
                    _buildBentoCard(
                      context: context,
                      title: "Schools & Academics",
                      subtitle: "8 Faculties • CUET Intake",
                      icon: Icons.account_balance_outlined,
                      badge: "8 Faculties",
                      badgeColor: GriColors.forestPrimary,
                      destination: const SchoolsProgrammesHubScreen(),
                    ),
                    _buildBentoCard(
                      context: context,
                      title: "Admissions 2026-27",
                      subtitle: "Prospectus • 5-Tier Refund",
                      icon: Icons.how_to_reg_outlined,
                      badge: "CUET 2026",
                      badgeColor: GriColors.ochrePrimary,
                      destination: const AdmissionsProspectusScreen(),
                    ),
                    _buildBentoCard(
                      context: context,
                      title: "COE & Examinations",
                      subtitle: "Timetables • Tatkal Scheme",
                      icon: Icons.assignment_turned_in_outlined,
                      badge: "COE Hub",
                      badgeColor: GriColors.forestPrimary,
                      destination: const ExaminationServicesScreen(),
                    ),
                    _buildBentoCard(
                      context: context,
                      title: "Governance & Officers",
                      subtitle: "Chancellor • VC • Syndicate",
                      icon: Icons.groups_outlined,
                      badge: "Authorities",
                      badgeColor: GriColors.ochrePrimary,
                      destination: const GovernanceLeadershipScreen(),
                    ),
                    _buildBentoCard(
                      context: context,
                      title: "Campus Facilities",
                      subtitle: "300-Acre Map • Library",
                      icon: Icons.apartment_outlined,
                      badge: "Infrastructure",
                      badgeColor: GriColors.tealSecondary,
                      destination: const CampusFacilitiesScreen(),
                    ),
                    _buildBentoCard(
                      context: context,
                      title: "Scholarships & Welfare",
                      subtitle: "Post-Matric • APAAR ID",
                      icon: Icons.volunteer_activism_outlined,
                      badge: "DigiLocker",
                      badgeColor: GriColors.tealSecondary,
                      destination: const ScholarshipsWelfareScreen(),
                    ),
                    _buildBentoCard(
                      context: context,
                      title: "Document Vault",
                      subtitle: "595 Institutional PDFs",
                      icon: Icons.folder_shared_outlined,
                      badge: "595 PDFs",
                      badgeColor: Colors.indigo,
                      destination: const DocumentVaultScreen(),
                    ),
                    _buildBentoCard(
                      context: context,
                      title: "Official Gateways",
                      subtitle: "Samarth • Webmail • ERP",
                      icon: Icons.shield_outlined,
                      badge: "10 Portals",
                      badgeColor: Colors.indigo,
                      destination: const OfficialPortalsGatewayScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 6. My Courses & Attendance Snapshot
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "MY COURSES & ATTENDANCE",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () => provider.switchTab(NavigationTab.ACADEMICS),
                      child: const Text(
                        "All Courses →",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: GriColors.forestPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...provider.courses.take(3).map((course) => _buildCourseItem(context, course, provider)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 7. Official Institutional Accreditation Footer Banner
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 210),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: OfficialResourceRegistry.buildImage(
                        "IMG_OFFICIAL_CREST",
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The Gandhigram Rural Institute",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                          ),
                        ),
                        Text(
                          "Ministry of Education, Govt. of India • NAAC 'A' Grade (3.63 CGPA)",
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value, {bool isHighlight = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isHighlight
                ? GriColors.forestPrimary
                : (isDark ? GriColors.darkOnSurface : GriColors.onSurface),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 22,
      width: 1.0,
      color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? GriColors.darkSurface1 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required Color badgeColor,
    required Widget destination,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => destination));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: badgeColor, size: 22),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: isDark ? 0.25 : 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(BuildContext context, CourseModel course, GriProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAboveThreshold = course.attendancePercent >= 75;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isAboveThreshold
                  ? GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08)
                  : GriColors.warning.withValues(alpha: isDark ? 0.25 : 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  "${course.attendancePercent}%",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                    color: isAboveThreshold ? GriColors.forestPrimary : GriColors.warning,
                  ),
                ),
                Text(
                  isAboveThreshold ? "Eligible" : "Low",
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: isAboveThreshold ? GriColors.forestPrimary : GriColors.warning,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${course.code}: ${course.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "${course.instructor} • ${course.schedule}",
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => provider.markAttendance(course.id),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: GriColors.forestPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: GriColors.forestPrimary, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
