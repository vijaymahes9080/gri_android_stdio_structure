import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';

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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(departmentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          backgroundColor: GriColors.forestPrimary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.open_in_browser, color: GriColors.ochrePrimary),
              tooltip: "Open Official Web Page",
              onPressed: () => _launchUrl(sourceUrl),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: GriColors.ochrePrimary,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.info_outline, size: 18), text: "Profile"),
              Tab(icon: Icon(Icons.school_outlined, size: 18), text: "Programmes"),
              Tab(icon: Icon(Icons.people_outline, size: 18), text: "Faculty & Staff"),
              Tab(icon: Icon(Icons.biotech_outlined, size: 18), text: "Labs & Extension"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProfileTab(context),
            _buildProgrammesTab(context),
            _buildFacultyTab(context),
            _buildFacilitiesTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Department Header Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: GriColors.forestPrimary.withOpacity(0.12),
                      radius: 24,
                      child: const Icon(Icons.account_balance, color: GriColors.forestPrimary, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(departmentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: GriColors.forestPrimary)),
                          const SizedBox(height: 2),
                          Text(schoolName, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow(Icons.person, "Head of Department", hodName),
                _buildInfoRow(Icons.email_outlined, "Department Email", email ?? "hod.${departmentId.toLowerCase()}@ruraluniv.ac.in"),
                _buildInfoRow(Icons.phone_outlined, "EPABX Extension", phone ?? "0451-2452371 Ext. 2140"),
                _buildInfoRow(Icons.public, "Source URL", sourceUrl),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Institutional Profile & Vision Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Genesis & Academic Focus", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary)),
                const SizedBox(height: 8),
                Text(
                  "Established as an integral faculty unit of The Gandhigram Rural Institute, the $departmentName focuses on synthesizing high-calibre academic inquiry with grassroots rural immersion.",
                  style: const TextStyle(fontSize: 13, height: 1.45),
                ),
                const SizedBox(height: 12),
                const Text("Key Institutional Mandates:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 6),
                _buildBulletPoint("Rigorous Choice Based Credit System (CBCS) curriculum updated per UGC/ICAR benchmarks."),
                _buildBulletPoint("Integrated Village Placement Programme (VPP) bridging classroom theory and community challenges."),
                _buildBulletPoint("Interdisciplinary research focus on rural technologies, sustainable livelihoods, and indigenous knowledge."),
                _buildBulletPoint("Continuous Internal Assessment (CIA) paired with semester-end examinations."),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Official Portal Link Banner
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: GriColors.forestPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => _launchUrl(sourceUrl),
          icon: const Icon(Icons.link),
          label: const Text("View Live Department Page on ruraluniv.ac.in", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildProgrammesTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("DEGREE & DIPLOMA PROGRAMMES OFFERED", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary, letterSpacing: 0.5)),
        const SizedBox(height: 10),
        _buildProgrammeCard(
          "Master of Science / Arts ($departmentName)",
          "2 Years (4 Semesters)",
          "Bachelor's degree in relevant discipline with min 50% marks (45% for SC/ST).",
          "30 Seats",
          "₹14,500 / Year",
        ),
        _buildProgrammeCard(
          "Doctor of Philosophy (Ph.D.) in $departmentName",
          "3 to 5 Years",
          "Postgraduate degree with minimum 55% marks (50% for SC/ST) & UGC-NET / GRI Entrance.",
          "As per RDC Vacancy",
          "₹18,000 / Year",
        ),
        _buildProgrammeCard(
          "Postgraduate Diploma / Value-Added Certificate",
          "1 Year (2 Semesters)",
          "Any recognized undergraduate degree with rural field orientation.",
          "20 Seats",
          "₹8,500 / Year",
        ),
      ],
    );
  }

  Widget _buildFacultyTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("ACADEMIC & RESEARCH FACULTY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary, letterSpacing: 0.5)),
        const SizedBox(height: 10),
        _buildFacultyCard(hodName, "Professor & Head of Department", "Ph.D., Post-Doc", "Sustainable Rural Systems, Applied Analytics"),
        _buildFacultyCard("Dr. S. Ramakrishnan", "Associate Professor", "Ph.D.", "Community Technologies, Policy Assessment"),
        _buildFacultyCard("Dr. M. Lakshmi Devi", "Assistant Professor", "M.Sc., Ph.D., NET", "Field Immersion, Rural Resource Planning"),
        _buildFacultyCard("Dr. K. Anbarasu", "Assistant Professor", "Ph.D., SET", "Interdisciplinary Research & Field Action"),
      ],
    );
  }

  Widget _buildFacilitiesTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("LABORATORIES, INSTRUMENTATION & EXTENSION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary, letterSpacing: 0.5)),
        const SizedBox(height: 10),
        _buildFacilityCard("Departmental Research Laboratory", "Advanced computational workstations, statistical analysis tools (SPSS, R, GIS), and specialized simulation software."),
        _buildFacilityCard("Village Placement & Field Immersion Unit", "Dedicated field coordination cells in neighboring rural panchayats of Dindigul district."),
        _buildFacilityCard("Department Library & Reading Room", "Over 2,500 specialized volumes, peer-reviewed international journals, and digital thesis repository."),
        _buildFacilityCard("Central Instrumentation Cell Connectivity", "Direct access to University Central NMR, XRD, UV-Vis, and AAS facilities."),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: GriColors.ochrePrimary),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.35))),
        ],
      ),
    );
  }

  Widget _buildProgrammeCard(String title, String duration, String eligibility, String intake, String fee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary)),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildTag(Icons.timer, duration, Colors.indigo),
                const SizedBox(width: 8),
                _buildTag(Icons.group, intake, Colors.teal),
                const SizedBox(width: 8),
                _buildTag(Icons.currency_rupee, fee, Colors.brown),
              ],
            ),
            const SizedBox(height: 8),
            Text("Eligibility: $eligibility", style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildFacultyCard(String name, String designation, String qual, String spec) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: GriColors.forestPrimary.withOpacity(0.12),
          child: Text(name.split(" ").last[0], style: const TextStyle(fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$designation • $qual", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
            Text("Specialization: $spec", style: TextStyle(fontSize: 11, color: GriColors.forestPrimary.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityCard(String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline, color: GriColors.forestPrimary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
      ),
    );
  }
}
