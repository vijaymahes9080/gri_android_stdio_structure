import 'package:flutter/material.dart';
import '../utils/gri_url_launcher.dart';
import '../utils/gri_colors.dart';
import '../screens/about_gri_heritage_screen.dart';
import '../screens/governance_leadership_screen.dart';
import '../screens/schools_programmes_hub_screen.dart';
import '../screens/admissions_prospectus_screen.dart';
import '../screens/examination_services_screen.dart';
import '../screens/scholarships_welfare_screen.dart';
import '../screens/contact_campus_info_screen.dart';
import '../screens/campus_facilities_screen.dart';
import '../screens/global_website_search_screen.dart';
import '../screens/department_detail_screen.dart';
import '../screens/institutional_article_screen.dart';
import '../screens/document_vault_screen.dart';
import '../screens/media_gallery_screen.dart';
import '../screens/official_portals_gateway_screen.dart';
import '../screens/settings_screen.dart';
import '../services/official_resource_registry.dart';

/// Pro-Level Institutional University Drawer
/// Categorized logically into five official governance and academic divisions.
class GriUniversityDrawer extends StatelessWidget {
  const GriUniversityDrawer({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    await GriUrlLauncher.launch(context, url);
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).pop(); // close drawer
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
      child: Column(
        children: [
          // Institutional Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 18,
              right: 18,
            ),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface2 : GriColors.forestDark,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? GriColors.darkOutlineVariant : GriColors.forestPrimary,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: GriColors.ochrePrimary, width: 1.5),
                      ),
                      child: ClipOval(
                        child: OfficialResourceRegistry.buildImage(
                          "IMG_OFFICIAL_CREST",
                          width: 46,
                          height: 46,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "THE GANDHIGRAM",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            "RURAL INSTITUTE",
                            style: TextStyle(
                              color: GriColors.ochreAccent,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Deemed to be University • NAAC 'A' Grade • 1956",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Search Shortcut Bar inside Drawer
                InkWell(
                  onTap: () => _push(context, const GlobalWebsiteSearchScreen()),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 0.8,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.white70, size: 17),
                        SizedBox(width: 8),
                        Text(
                          "Search 247 official web pages...",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Categorized Navigation List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // SECTION 1: ACADEMICS & SCHOOLS
                _buildSectionHeader("ACADEMICS & PROGRAMMES"),
                ExpansionTile(
                  leading: const Icon(Icons.school, color: GriColors.forestPrimary, size: 21),
                  title: const Text("Schools & Departments", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "All 8 Statutory Schools", () => _push(context, const SchoolsProgrammesHubScreen())),
                    _buildSubItem(context, "School of Sciences", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "Maths",
                      departmentName: "Department of Mathematics",
                      schoolName: "School of Sciences",
                      hodName: "Dr. P. Balasubramaniam",
                      email: "hodmaths@ruraluniv.ac.in",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=maths",
                    ))),
                    _buildSubItem(context, "School of Agriculture & Rural Dev.", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "Agriculture",
                      departmentName: "Faculty of Rural Development",
                      schoolName: "School of Agriculture and Animal Husbandry",
                      hodName: "Dr. T. Senthilvel",
                      email: "hodagri@ruraluniv.ac.in",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=agri",
                    ))),
                    _buildSubItem(context, "School of Social Sciences", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "SocialSciences",
                      departmentName: "Department of Applied Research",
                      schoolName: "School of Social Sciences",
                      hodName: "Dr. S. Radhakrishnan",
                      email: "hodsocial@ruraluniv.ac.in",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=social",
                    ))),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined, color: GriColors.forestPrimary, size: 21),
                  title: const Text("CBCS Curriculum & Syllabi", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const DocumentVaultScreen(initialCategory: "CBCS Syllabus")),
                ),

                // SECTION 2: ADMISSIONS & EXAMINATIONS
                const Divider(height: 16),
                _buildSectionHeader("ADMISSIONS & EXAMINATIONS"),
                ListTile(
                  leading: const Icon(Icons.how_to_reg_outlined, color: GriColors.forestPrimary, size: 21),
                  title: const Text("Admissions 2026-27 & CUET", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const AdmissionsProspectusScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_turned_in_outlined, color: GriColors.forestPrimary, size: 21),
                  title: const Text("Controller of Examinations (COE)", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const ExaminationServicesScreen()),
                ),

                // SECTION 3: GOVERNANCE & HERITAGE
                const Divider(height: 16),
                _buildSectionHeader("GOVERNANCE & HERITAGE"),
                ListTile(
                  leading: const Icon(Icons.history_edu, color: GriColors.ochrePrimary, size: 21),
                  title: const Text("About GRI & Gandhian Heritage", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const AboutGriHeritageScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance, color: GriColors.ochrePrimary, size: 21),
                  title: const Text("Governance & Authorities", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const GovernanceLeadershipScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.gavel_outlined, color: GriColors.ochrePrimary, size: 21),
                  title: const Text("Mandatory Disclosures & NAAC", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const InstitutionalArticleScreen(
                    title: "Mandatory Disclosures & NAAC SSR",
                    category: "Statutory Compliance",
                    sourceUrl: "https://ruraluniv.ac.in/naac?content=ssr",
                  )),
                ),

                // SECTION 4: CAMPUS & STUDENT LIFE
                const Divider(height: 16),
                _buildSectionHeader("CAMPUS & STUDENT WELFARE"),
                ListTile(
                  leading: const Icon(Icons.apartment, color: GriColors.tealSecondary, size: 21),
                  title: const Text("300-Acre Campus & Facilities", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const CampusFacilitiesScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.card_giftcard, color: GriColors.tealSecondary, size: 21),
                  title: const Text("Scholarships & Welfare Schemes", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const ScholarshipsWelfareScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.video_library_outlined, color: GriColors.tealSecondary, size: 21),
                  title: const Text("Media Gallery & Campus 360", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const MediaGalleryScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.contact_phone_outlined, color: GriColors.tealSecondary, size: 21),
                  title: const Text("Campus Directory & Emergency", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const ContactCampusInfoScreen()),
                ),

                // SECTION 5: DIGITAL SERVICES & PORTALS
                const Divider(height: 16),
                _buildSectionHeader("DIGITAL SERVICES & VAULT"),
                ListTile(
                  leading: const Icon(Icons.folder_shared_outlined, color: Colors.indigo, size: 21),
                  title: const Text("Official Document Vault", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: const Text("595 institutional PDFs & circulars", style: TextStyle(fontSize: 10.5)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const DocumentVaultScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.shield_outlined, color: Colors.indigo, size: 21),
                  title: const Text("Official Portals & Gateways", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: const Text("Samarth, Webmail, e-SANAD & Portals", style: TextStyle(fontSize: 10.5)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const OfficialPortalsGatewayScreen()),
                ),

                // SECTION 6: SYSTEM & PREFERENCES
                const Divider(height: 16),
                _buildSectionHeader("SYSTEM & PREFERENCES"),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: GriColors.forestPrimary, size: 21),
                  title: const Text("Settings & Preferences", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: const Text("Theme, Text scale, Language & Storage", style: TextStyle(fontSize: 10.5)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () => _push(context, const SettingsScreen()),
                ),
              ],
            ),
          ),

          // Drawer Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
              border: Border(
                top: BorderSide(
                  color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "GRI v1.0 • NAAC 'A' Grade",
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () => _launchUrl(context, "https://ruraluniv.ac.in/"),
                  child: Text(
                    "ruraluniv.ac.in ↗",
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSubItem(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 48, right: 16),
      title: Text(title, style: const TextStyle(fontSize: 12.5)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey),
      dense: true,
      onTap: onTap,
    );
  }
}
