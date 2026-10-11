import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../models/academic_models.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import 'about_gri_heritage_screen.dart';
import 'schools_programmes_hub_screen.dart';
import 'admissions_prospectus_screen.dart';
import 'governance_leadership_screen.dart';
import 'examination_services_screen.dart';
import 'scholarships_welfare_screen.dart';
import 'contact_campus_info_screen.dart';
import 'document_vault_screen.dart';
import 'media_gallery_screen.dart';
import 'global_website_search_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<GriProvider>();
    final user = provider.currentUser;

    return RefreshIndicator(
      onRefresh: () => provider.triggerCloudSync(),
      color: colorScheme.primary,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // 1. Personalized Institutional Header Card (Gandhian Heritage Identity)
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [GriColors.forestDark, GriColors.forestPrimary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: GriColors.forestDark.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: GriColors.ochrePrimary, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  backgroundImage: const AssetImage('assets/images/student_avatar.jpg'),
                                  child: user == null
                                      ? const Icon(Icons.person, color: GriColors.forestPrimary)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            user?.name ?? "Vijay Pradhap",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.2,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.verified, color: GriColors.ochreTertiary, size: 16),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${user?.rollNo ?? '2024-MS-4011'} • ${user?.department ?? 'Computer Science'}",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GriPressable(
                          onTap: () => provider.toggleRoleSwitcher(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: GriColors.ochrePrimary,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swap_horiz, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  provider.currentRole.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Academic Metrics Glass Container
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.18), width: 0.8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetric("Semester", user?.semester ?? "Sem IV"),
                          Container(height: 26, width: 0.8, color: Colors.white24),
                          _buildMetric("CGPA", user?.cgpa ?? "8.92"),
                          Container(height: 26, width: 0.8, color: Colors.white24),
                          _buildMetric("Attendance", "87% (Eligible)", isHighlight: true),
                          Container(height: 26, width: 0.8, color: Colors.white24),
                          _buildMetric("Hostel", user?.isHostelite == true ? "Kasturba" : "Day Scholar"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 2. Urgent / Official Announcement Banner
          if (provider.circulars.isNotEmpty) ...[
            GriFadeSlideEntrance(
              delay: const Duration(milliseconds: 70),
              child: Builder(
                builder: (context) {
                  final urgent = provider.circulars.firstWhere(
                    (c) => c.isUrgent,
                    orElse: () => provider.circulars.first,
                  );
                  return Container(
                    decoration: BoxDecoration(
                      color: GriColors.warningContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GriColors.ochrePrimary.withOpacity(0.3), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: GriColors.warning.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.campaign, color: GriColors.warning, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: GriColors.warning,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "URGENT CIRCULAR",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      urgent.publishedDate,
                                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  urgent.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  urgent.summary,
                                  style: TextStyle(fontSize: 11.5, color: colorScheme.onSurfaceVariant),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Issued by: ${urgent.issuedBy}",
                                      style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant),
                                    ),
                                    GriPressable(
                                      onTap: () => provider.fetchHallTicket(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Hall Ticket",
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          Icon(Icons.arrow_forward, size: 13, color: colorScheme.primary),
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
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 3. Quick Campus Services Hub (Harmonized Gandhian Palette)
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "QUICK CAMPUS SERVICES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      "Essential Portals",
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 10,
                  children: [
                    _buildQuickAction(
                      context: context,
                      icon: Icons.school_outlined,
                      label: "Courses",
                      color: colorScheme.primary,
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
                      color: colorScheme.primary,
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
                      color: colorScheme.primary,
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
          const SizedBox(height: 22),

          // 4. Enrolled Courses & Attendance Snapshot
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "MY COURSES & ATTENDANCE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    GriPressable(
                      onTap: () => provider.switchTab(NavigationTab.ACADEMICS),
                      child: Text(
                        "View All →",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
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
          const SizedBox(height: 22),

          // 5. Categorized Official University Portals & Hubs
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "OFFICIAL UNIVERSITY PORTALS & HUBS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
                      ),
                      child: Text(
                        "ruraluniv.ac.in",
                        style: TextStyle(
                          fontSize: 10.5,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Group A: Heritage & Governance
                _buildSectionHeader("INSTITUTIONAL HERITAGE & GOVERNANCE"),
                _buildInstitutionalCard(
                  context: context,
                  title: "About GRI & Heritage",
                  subtitle: "1956 Genesis, Vision, Mission, Founders & Emblem",
                  icon: Icons.history_edu,
                  badge: "1956 Genesis",
                  destination: const AboutGriHeritageScreen(),
                ),
                _buildInstitutionalCard(
                  context: context,
                  title: "Governance & University Leadership",
                  subtitle: "Chancellor, VC, Registrar, Deans, Councils & Organogram",
                  icon: Icons.groups_outlined,
                  badge: "Statutory",
                  destination: const GovernanceLeadershipScreen(),
                ),

                const SizedBox(height: 10),
                // Group B: Academics & Admissions
                _buildSectionHeader("ACADEMIC HUBS & ADMISSIONS"),
                _buildInstitutionalCard(
                  context: context,
                  title: "8 Schools & Academic Programmes",
                  subtitle: "Schools, 20+ Departments, Programmes, CBCS & Centres",
                  icon: Icons.account_balance_outlined,
                  badge: "8 Schools",
                  destination: const SchoolsProgrammesHubScreen(),
                ),
                _buildInstitutionalCard(
                  context: context,
                  title: "Admissions & Prospectus 2026-27",
                  subtitle: "Prospectuses, Seat Intake, Higher Doctorates & Samarth",
                  icon: Icons.school_outlined,
                  badge: "2026-27",
                  destination: const AdmissionsProspectusScreen(),
                ),

                const SizedBox(height: 10),
                // Group C: Examination & Welfare
                _buildSectionHeader("EXAMINATION & WELFARE SERVICES"),
                _buildInstitutionalCard(
                  context: context,
                  title: "Examinations & Official Forms",
                  subtitle: "ESE Timetables, Transcript Forms, Tatkal & e-SANAD",
                  icon: Icons.assignment_turned_in_outlined,
                  badge: "COE Services",
                  destination: const ExaminationServicesScreen(),
                ),
                _buildInstitutionalCard(
                  context: context,
                  title: "Scholarships & Student Welfare",
                  subtitle: "SC/ST/SCC Schemes, APAAR ID, UMIS & Anti-Ragging",
                  icon: Icons.volunteer_activism_outlined,
                  badge: "APAAR / DigiLocker",
                  destination: const ScholarshipsWelfareScreen(),
                ),

                const SizedBox(height: 10),
                // Group D: Archives, Directory & Transit
                _buildSectionHeader("CAMPUS, VAULT & ARCHIVES"),
                _buildInstitutionalCard(
                  context: context,
                  title: "Official Document Vault",
                  subtitle: "Catalog of 595 Official PDFs, Circulars & Statutory Reports",
                  icon: Icons.folder_shared_outlined,
                  badge: "595 PDFs",
                  destination: const DocumentVaultScreen(),
                ),
                _buildInstitutionalCard(
                  context: context,
                  title: "Media & Campus Video Tour",
                  subtitle: "300-Acre Panoramic Video, YouTube Channel & Photo Archive",
                  icon: Icons.video_library_outlined,
                  badge: "Media Gallery",
                  destination: const MediaGalleryScreen(),
                ),
                _buildInstitutionalCard(
                  context: context,
                  title: "Universal Portal Directory & Search",
                  subtitle: "Instant Search Across All 247 Discovered Official Pages",
                  icon: Icons.search,
                  badge: "247 Pages",
                  destination: const GlobalWebsiteSearchScreen(),
                ),
                _buildInstitutionalCard(
                  context: context,
                  title: "Contact & Campus Directions",
                  subtitle: "EPABX Board Lines, Dindigul/Madurai Transit & Emergencies",
                  icon: Icons.directions_bus_outlined,
                  badge: "EPABX Directory",
                  destination: const ContactCampusInfoScreen(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 6. Institutional Brand Banner
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 230),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school, color: colorScheme.primary, size: 20),
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
                            fontSize: 12.5,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          "Education for Life • NAAC 'A' Grade (3.63 CGPA)",
                          style: TextStyle(
                            fontSize: 10.5,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, top: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: GriColors.ochrePrimary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildCourseItem(BuildContext context, CourseModel course, GriProvider provider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAboveThreshold = course.attendancePercent >= 75;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isAboveThreshold ? GriColors.forestContainer : GriColors.warningContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "${course.attendancePercent}%",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: isAboveThreshold ? GriColors.forestPrimary : GriColors.warning,
                    ),
                  ),
                  Text(
                    isAboveThreshold ? "Eligible" : "Warning",
                    style: TextStyle(
                      fontSize: 9,
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
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${course.instructor} • ${course.schedule}",
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            GriPressable(
              onTap: () => provider.markAttendance(course.id),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_task, color: colorScheme.primary, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionalCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required Widget destination,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GriPressable(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => destination));
        },
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: GriColors.ochreContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: GriColors.ochreOnContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 12, color: colorScheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? GriColors.ochreTertiary : Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GriPressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
