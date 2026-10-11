import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';
import '../screens/about_gri_heritage_screen.dart';
import '../screens/governance_leadership_screen.dart';
import '../screens/schools_programmes_hub_screen.dart';
import '../screens/admissions_prospectus_screen.dart';
import '../screens/examination_services_screen.dart';
import '../screens/scholarships_welfare_screen.dart';
import '../screens/contact_campus_info_screen.dart';
import '../screens/campus_facilities_screen.dart';
import '../screens/official_document_center_screen.dart';
import '../screens/global_website_search_screen.dart';
import '../screens/department_detail_screen.dart';
import '../screens/institutional_article_screen.dart';
import '../screens/document_vault_screen.dart';
import '../screens/media_gallery_screen.dart';
import '../services/official_resource_registry.dart';

class GriUniversityDrawer extends StatelessWidget {
  const GriUniversityDrawer({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).pop(); // close drawer
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Institutional Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: const BoxDecoration(
              color: GriColors.forestPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: OfficialResourceRegistry.buildImage(
                          "IMG_OFFICIAL_CREST",
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "THE GANDHIGRAM",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                          ),
                          Text(
                            "RURAL INSTITUTE",
                            style: TextStyle(color: GriColors.ochrePrimary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Deemed to be University • Estd. 1956",
                            style: TextStyle(color: Colors.white70, fontSize: 10),
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
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.white70, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Search 247 official pages...",
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
              padding: EdgeInsets.zero,
              children: [
                // 1. About & Heritage
                ExpansionTile(
                  leading: const Icon(Icons.history_edu, color: GriColors.forestPrimary),
                  title: const Text("1. About GRI & Heritage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "Heritage, Genesis & Founders", () => _push(context, const AboutGriHeritageScreen())),
                    _buildSubItem(context, "Vision & Mission", () => _push(context, const AboutGriHeritageScreen())),
                    _buildSubItem(context, "3H Nai Talim Philosophy", () => _push(context, const AboutGriHeritageScreen())),
                    _buildSubItem(context, "Former Chancellors & VCs", () => _push(context, const AboutGriHeritageScreen())),
                    _buildSubItem(context, "Best Practices & Shanti Sena", () => _push(context, const InstitutionalArticleScreen(
                      title: "Best Practices & Institutional Distinctiveness",
                      category: "Institutional Heritage",
                      sourceUrl: "https://ruraluniv.ac.in/aboutgri?content=best_practices",
                    ))),
                  ],
                ),

                // 2. Governance & Leadership
                ExpansionTile(
                  leading: const Icon(Icons.account_balance, color: GriColors.ochrePrimary),
                  title: const Text("2. Governance & Authorities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "Chancellor & Vice-Chancellor", () => _push(context, const GovernanceLeadershipScreen())),
                    _buildSubItem(context, "Registrar & Executive Officers", () => _push(context, const GovernanceLeadershipScreen())),
                    _buildSubItem(context, "Deans & Heads of Departments", () => _push(context, const GovernanceLeadershipScreen())),
                    _buildSubItem(context, "Statutory Bodies (Syndicate/Senate)", () => _push(context, const GovernanceLeadershipScreen())),
                  ],
                ),

                // 3. 8 Schools & Academic Departments
                ExpansionTile(
                  leading: const Icon(Icons.school, color: Colors.indigo),
                  title: const Text("3. Schools & Departments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "Overview of 8 Statutory Schools", () => _push(context, const SchoolsProgrammesHubScreen())),
                    _buildSubItem(context, "School of Sciences", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "Maths",
                      departmentName: "DEPARTMENT OF MATHEMATICS",
                      schoolName: "School of Sciences",
                      hodName: "Dr. P. Balasubramaniam",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=maths_profile",
                    ))),
                    _buildSubItem(context, "Department of Physics", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "Physics",
                      departmentName: "DEPARTMENT OF PHYSICS",
                      schoolName: "School of Sciences",
                      hodName: "Dr. S. Arumugam",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=Physics_profile",
                    ))),
                    _buildSubItem(context, "Department of Chemistry", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "Chemistry",
                      departmentName: "DEPARTMENT OF CHEMISTRY",
                      schoolName: "School of Sciences",
                      hodName: "Dr. S. Meenakshi",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=Chemistry_profile",
                    ))),
                    _buildSubItem(context, "School of Agriculture & Animal Sciences", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "Agri",
                      departmentName: "FACULTY OF AGRICULTURE & ANIMAL HUSBANDRY",
                      schoolName: "School of Agriculture",
                      hodName: "Dr. T. Senthivel",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=Agri_profile",
                    ))),
                    _buildSubItem(context, "School of Management Studies", () => _push(context, const DepartmentDetailScreen(
                      departmentId: "RIM",
                      departmentName: "RURAL INDUSTRIES & MANAGEMENT (RIM)",
                      schoolName: "School of Management Studies",
                      hodName: "Dr. K. Ravichandran",
                      sourceUrl: "https://ruraluniv.ac.in/faculties?department=RIM_profile",
                    ))),
                  ],
                ),

                // 4. Admissions & Prospectuses
                ExpansionTile(
                  leading: const Icon(Icons.app_registration, color: Colors.deepPurple),
                  title: const Text("4. Admissions & Prospectus", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "Prospectus 2026-27 & 2025-26", () => _push(context, const AdmissionsProspectusScreen())),
                    _buildSubItem(context, "UGC 5-Tier Fee Refund Policy", () => _push(context, const AdmissionsProspectusScreen())),
                    _buildSubItem(context, "Research Regulations (Ph.D./D.Sc.)", () => _push(context, const AdmissionsProspectusScreen())),
                    _buildSubItem(context, "CUET Samarth Admission Portal", () => _launchUrl("https://ruraluniv.samarth.ac.in/")),
                    _buildSubItem(context, "Study in India Portal", () => _launchUrl("https://www.studyinindia.gov.in/")),
                  ],
                ),

                // 5. Examinations & COE Services
                ExpansionTile(
                  leading: const Icon(Icons.assignment_turned_in, color: Colors.teal),
                  title: const Text("5. Examinations & COE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "COE Forms (Transcript, Duplicate)", () => _push(context, const ExaminationServicesScreen())),
                    _buildSubItem(context, "Tatkal Scheme Portal", () => _push(context, const ExaminationServicesScreen())),
                    _buildSubItem(context, "MEA e-SANAD Digital Attestation", () => _push(context, const ExaminationServicesScreen())),
                    _buildSubItem(context, "End Semester Timetables", () => _push(context, const ExaminationServicesScreen())),
                  ],
                ),

                // 6. Research & Development Cell
                ExpansionTile(
                  leading: const Icon(Icons.science, color: Colors.blueGrey),
                  title: const Text("6. Research & Development", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "RDC Governance & Patents", () => _push(context, const InstitutionalArticleScreen(
                      title: "Research & Development Cell (RDC)",
                      category: "Research",
                      sourceUrl: "https://ruraluniv.ac.in/academics?content=Patents",
                    ))),
                    _buildSubItem(context, "Ongoing Sponsored Projects", () => _push(context, const InstitutionalArticleScreen(
                      title: "Ongoing Sponsored Research Projects",
                      category: "Research",
                      sourceUrl: "https://ruraluniv.ac.in/academics?content=Projects",
                    ))),
                  ],
                ),

                // 7. Student Welfare & Scholarships
                ExpansionTile(
                  leading: const Icon(Icons.volunteer_activism, color: Colors.brown),
                  title: const Text("7. Scholarships & Welfare", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "SC/ST/SCC Government Scholarships", () => _push(context, const ScholarshipsWelfareScreen())),
                    _buildSubItem(context, "APAAR ID & DigiLocker Setup", () => _push(context, const ScholarshipsWelfareScreen())),
                    _buildSubItem(context, "Anti-Ragging 24x7 Helpline", () => _push(context, const ScholarshipsWelfareScreen())),
                  ],
                ),

                // 8. Campus Facilities
                ExpansionTile(
                  leading: const Icon(Icons.domain, color: Colors.orange),
                  title: const Text("8. Campus Facilities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  children: [
                    _buildSubItem(context, "Library & e-ShodhSindhu", () => _push(context, const CampusFacilitiesScreen())),
                    _buildSubItem(context, "Computer Centre & IT Labs", () => _push(context, const CampusFacilitiesScreen())),
                    _buildSubItem(context, "Kasturba Hospital & Health Centre", () => _push(context, const CampusFacilitiesScreen())),
                    _buildSubItem(context, "Sports & Yoga Centre", () => _push(context, const CampusFacilitiesScreen())),
                  ],
                ),

                // 9. Document Vault (595 Documents)
                ListTile(
                  leading: const Icon(Icons.folder_shared, color: Colors.red),
                  title: const Text("9. Official Document Vault (595)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text("Downloadable PDFs, Forms & Regulations", style: TextStyle(fontSize: 10)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => _push(context, const DocumentVaultScreen()),
                ),

                // 10. Media & Videos
                ListTile(
                  leading: const Icon(Icons.video_library, color: Colors.deepOrange),
                  title: const Text("10. Media & Video Tour", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text("Campus Video Tour & YouTube", style: TextStyle(fontSize: 10)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => _push(context, const MediaGalleryScreen()),
                ),

                // 11. Disclosures & Accreditation
                ListTile(
                  leading: const Icon(Icons.verified, color: Colors.purple),
                  title: const Text("11. NAAC, NIRF & Disclosures", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text("Accreditation, SSR & RTI Roster", style: TextStyle(fontSize: 10)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => _push(context, const OfficialDocumentCenterScreen()),
                ),

                // 12. Contact & Transit
                ListTile(
                  leading: const Icon(Icons.directions_bus, color: Colors.teal),
                  title: const Text("12. Contact & Campus Directions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text("EPABX, Dindigul 12km & Emergencies", style: TextStyle(fontSize: 10)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => _push(context, const ContactCampusInfoScreen()),
                ),

                // 13. Universal Search
                ListTile(
                  leading: const Icon(Icons.search, color: GriColors.forestPrimary),
                  title: const Text("13. Universal Website Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text("Search all 247 official URLs", style: TextStyle(fontSize: 10)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => _push(context, const GlobalWebsiteSearchScreen()),
                ),
              ],
            ),
          ),

          // Drawer Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("v1.0.0+1 • NAAC 'A' Grade", style: TextStyle(fontSize: 11, color: Colors.grey)),
                InkWell(
                  onTap: () => _launchUrl("https://ruraluniv.ac.in/"),
                  child: const Text(
                    "ruraluniv.ac.in",
                    style: TextStyle(fontSize: 11, color: GriColors.forestPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 48, right: 16),
      title: Text(title, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey),
      dense: true,
      onTap: onTap,
    );
  }
}
