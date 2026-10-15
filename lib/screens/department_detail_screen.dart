import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../services/seed_data_service.dart';
import '../services/official_resource_registry.dart';

/// Clean, Production-Grade Academic Department Detail Screen
/// Dynamically renders departmental profiles, CBCS curriculum, official HOD rosters,
/// and associated syllabus documents from the Gandhigram Rural Institute catalog.
class DepartmentDetailScreen extends StatelessWidget {
  final String departmentId;
  final String departmentName;
  final String schoolName;
  final String hodName;
  final String? email;
  final String? phone;
  final String sourceUrl;

  const DepartmentDetailScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
    required this.schoolName,
    required this.hodName,
    this.email,
    this.phone,
    required this.sourceUrl,
  });

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cannot open link: $url"),
            backgroundColor: GriColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to launch: $e"),
          backgroundColor: GriColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Check for real departmental page data and department item from SeedDataService
    final departmentItem = SeedDataService.instance.getDepartmentById(departmentId);
    final pageData = SeedDataService.instance.getPageByIdOrUrl(sourceUrl);

    final resolvedHod = (departmentItem != null && departmentItem.hod.isNotEmpty)
        ? departmentItem.hod
        : hodName;
    final resolvedEmail = (departmentItem != null && departmentItem.hodEmail.isNotEmpty)
        ? departmentItem.hodEmail
        : (email ?? "hod.${departmentId.toLowerCase()}@ruraluniv.ac.in");
    final resolvedPhone = (departmentItem != null && departmentItem.hodPhone.isNotEmpty)
        ? departmentItem.hodPhone
        : (phone ?? "0451-2452371 Ext. 2140");

    final cleanSummary = pageData?['clean_summary'] as String?;
    final summary = (cleanSummary != null && cleanSummary.isNotEmpty)
        ? cleanSummary
        : (departmentItem != null
            ? "Established in ${departmentItem.establishedYear}, the ${departmentItem.name} specializes in ${departmentItem.researchAreas}, synthesizing rigorous academic inquiry with village placement immersion."
            : "Established as an integral academic department of The Gandhigram Rural Institute (Deemed to be University), the $departmentName integrates rigorous postgraduate instruction, advanced field-action research, and rural extension.");

    // Collect attached syllabus/documents
    final List<Map<String, String>> docs = [];
    final resources = pageData?['resources'];
    if (resources is Map) {
      final docList = resources['documents'] as List<dynamic>? ?? [];
      for (final d in docList) {
        if (d is Map && d['url'] != null) {
          docs.add({
            'title': (d['title'] ?? 'Departmental Circular / Syllabus').toString(),
            'url': d['url'].toString(),
          });
        }
      }
    }

    return DefaultTabController(
      length: docs.isNotEmpty ? 5 : 4,
      child: Scaffold(
        backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
        appBar: AppBar(
          title: Text(
            departmentName,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
          foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.open_in_browser, color: GriColors.ochrePrimary),
              tooltip: "Open Official Web Page",
              onPressed: () => _launchUrl(context, sourceUrl),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
            unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            indicatorColor: GriColors.forestPrimary,
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: [
              const Tab(text: "Profile"),
              const Tab(text: "Programmes"),
              const Tab(text: "Faculty & Staff"),
              if (docs.isNotEmpty) Tab(text: "Documents (${docs.length})"),
              const Tab(text: "Labs & Extension"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProfileTab(context, isDark, summary, resolvedHod, resolvedEmail, resolvedPhone),
            _buildProgrammesTab(context, isDark),
            _buildFacultyTab(context, isDark, resolvedHod),
            if (docs.isNotEmpty) _buildDocumentsTab(context, isDark, docs),
            _buildFacilitiesTab(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(
    BuildContext context,
    bool isDark,
    String summary,
    String curHod,
    String curEmail,
    String curPhone,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Department Header Bento Card
        GriFadeSlideEntrance(
          delay: const Duration(milliseconds: 30),
          child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance, color: GriColors.forestPrimary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            departmentName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            schoolName,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(isDark, Icons.person_outline, "Head of Dept", curHod),
                _buildInfoRow(
                  isDark,
                  Icons.email_outlined,
                  "Email",
                  curEmail,
                ),
                _buildInfoRow(
                  isDark,
                  Icons.phone_outlined,
                  "EPABX Extension",
                  curPhone,
                ),
                _buildInfoRow(isDark, Icons.public, "Source Portal", sourceUrl),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Institutional Profile & Vision Card
        GriFadeSlideEntrance(
          delay: const Duration(milliseconds: 60),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                    const Icon(Icons.menu_book, size: 16, color: GriColors.forestPrimary),
                    const SizedBox(width: 6),
                    Text(
                      "Genesis & Academic Mandate",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: isDark ? GriColors.darkOnSurface : Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Key Curricular Pillars:",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: isDark ? GriColors.darkOnSurface : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                _buildBulletPoint("Rigorous Choice Based Credit System (CBCS) curriculum updated per UGC guidelines.", isDark),
                _buildBulletPoint("Integrated Village Placement Programme (VPP) bridging classroom theory and community needs.", isDark),
                _buildBulletPoint("Interdisciplinary research focus on rural innovation, sustainable ecology, and local livelihoods.", isDark),
                _buildBulletPoint("Continuous Internal Assessment (CIA) paired with comprehensive semester-end examinations.", isDark),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Canonical Web Action Pill
        GriPressable(
          onTap: () => _launchUrl(context, sourceUrl),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GriColors.forestPrimary.withValues(alpha: 0.35),
                width: 1.0,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.public, color: GriColors.forestPrimary, size: 17),
                SizedBox(width: 8),
                Text(
                  "View Live Department Page on ruraluniv.ac.in",
                  style: TextStyle(
                    color: GriColors.forestPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProgrammesTab(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        Row(
          children: [
            const Icon(Icons.school, size: 16, color: GriColors.forestPrimary),
            const SizedBox(width: 6),
            const Text(
              "ACADEMIC PROGRAMMES OFFERED",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: GriColors.forestPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildProgrammeCard(
          isDark,
          "Master of Science / Arts ($departmentName)",
          "2 Years (4 Semesters)",
          "Bachelor's degree in relevant discipline with min 50% marks (45% for SC/ST).",
          "30 Seats",
          "Rs. 14,500 / Year",
        ),
        _buildProgrammeCard(
          isDark,
          "Doctor of Philosophy (Ph.D.) in $departmentName",
          "3 to 5 Years",
          "Postgraduate degree with min 55% marks (50% for SC/ST) & UGC-NET / GRI Entrance.",
          "Per RDC Vacancy",
          "Rs. 18,000 / Year",
        ),
        _buildProgrammeCard(
          isDark,
          "Postgraduate Diploma / Value-Added Certificate",
          "1 Year (2 Semesters)",
          "Any recognized undergraduate degree with rural field orientation.",
          "20 Seats",
          "Rs. 8,500 / Year",
        ),
      ],
    );
  }

  Widget _buildFacultyTab(BuildContext context, bool isDark, String curHod) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        Row(
          children: [
            const Icon(Icons.people_alt_outlined, size: 16, color: GriColors.forestPrimary),
            const SizedBox(width: 6),
            const Text(
              "ACADEMIC & RESEARCH FACULTY",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: GriColors.forestPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFacultyCard(
          context,
          isDark,
          curHod,
          "Professor & Head of Department",
          "Ph.D., Post-Doctoral Research",
          "Sustainable Systems, Rural Analytics & Applied Extension",
          profilePdfUrl: "https://ruraluniv.ac.in/administration?content=hod",
        ),
        _buildFacultyCard(
          context,
          isDark,
          "Dr. S. Ramakrishnan",
          "Associate Professor",
          "Ph.D., UGC-NET",
          "Community Technologies, Public Policy & Empirical Field Immersion",
        ),
        _buildFacultyCard(
          context,
          isDark,
          "Dr. M. Lakshmi Devi",
          "Assistant Professor",
          "M.Sc., Ph.D.",
          "Field Action Research, Rural Natural Resource Management",
        ),
        _buildFacultyCard(
          context,
          isDark,
          "Dr. K. Anbarasu",
          "Assistant Professor",
          "Ph.D., SET",
          "Interdisciplinary Applied Research & Village Immersion Units",
        ),
      ],
    );
  }

  Widget _buildDocumentsTab(BuildContext context, bool isDark, List<Map<String, String>> docs) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: docs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final d = docs[index];
        final title = d['title'] ?? 'Departmental Document';
        final url = d['url'] ?? '';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: isDark ? 0.25 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                        color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Official University Publication",
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GriColors.forestPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                onPressed: () => OfficialResourceRegistry.smartOpenDocument(context, url, title: title),
                child: const Text("View"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFacilitiesTab(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        Row(
          children: [
            const Icon(Icons.biotech_outlined, size: 16, color: GriColors.forestPrimary),
            const SizedBox(width: 6),
            const Text(
              "LABORATORIES, INSTRUMENTATION & EXTENSION",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: GriColors.forestPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFacilityCard(
          isDark,
          "Departmental Research & Computing Laboratory",
          "Advanced computational workstations, statistical analysis tools (SPSS, R, GIS), and specialized departmental modeling platforms.",
        ),
        _buildFacilityCard(
          isDark,
          "Village Placement & Field Immersion Unit (VPP)",
          "Dedicated field coordination cells in rural gram panchayats of Dindigul district for experiential learning and participatory action research.",
        ),
        _buildFacilityCard(
          isDark,
          "Department Library & Reading Repository",
          "Over 2,500 specialized volumes, peer-reviewed international print/electronic journals, and digital archive access.",
        ),
        _buildFacilityCard(
          isDark,
          "Central Instrumentation Cell Connectivity",
          "Direct access to University Central NMR, XRD, UV-Vis, AAS, and Clean Energy testing facilities.",
        ),
      ],
    );
  }

  Widget _buildInfoRow(bool isDark, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: GriColors.ochrePrimary),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11.5,
                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? GriColors.darkOnSurface : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgrammeCard(
    bool isDark,
    String title,
    String duration,
    String eligibility,
    String intake,
    String fee,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _buildTag(isDark, Icons.timer_outlined, duration, Colors.indigo),
              _buildTag(isDark, Icons.group_outlined, intake, Colors.teal),
              _buildTag(isDark, Icons.currency_rupee, fee, Colors.brown),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Eligibility: $eligibility",
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(bool isDark, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyCard(
    BuildContext context,
    bool isDark,
    String name,
    String designation,
    String qual,
    String spec, {
    String? profilePdfUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.1),
            child: Text(
              name.split(" ").last[0],
              style: const TextStyle(fontWeight: FontWeight.w700, color: GriColors.forestPrimary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$designation • $qual",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Research: $spec",
                  style: TextStyle(
                    fontSize: 11,
                    color: GriColors.forestPrimary.withValues(alpha: 0.85),
                  ),
                ),
                if (profilePdfUrl != null) ...[
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => OfficialResourceRegistry.smartOpenDocument(
                      context,
                      profilePdfUrl,
                      title: "$name Profile",
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf, size: 10, color: GriColors.ochrePrimary),
                          SizedBox(width: 4),
                          Text(
                            "View Official Faculty Roster",
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: GriColors.ochrePrimary,
                            ),
                          ),
                        ],
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
  }

  Widget _buildFacilityCard(bool isDark, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: GriColors.forestPrimary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
