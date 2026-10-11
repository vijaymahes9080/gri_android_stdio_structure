import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Admissions",
    "Examinations",
    "Research",
    "Regulations",
    "Circulars",
  ];

  final List<Map<String, dynamic>> _officialDocs = [
    {
      "title": "GRI Admissions Prospectus 2026-27 (All Programmes)",
      "authority": "Directorate of Admissions",
      "date": "15 Aug 2026",
      "size": "2.4 MB",
      "cat": "Admissions",
      "url": "https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf",
      "isBundled": true,
      "localPath": "assets/official/documents/GRI_Prospectus_2026-27.pdf",
    },
    {
      "title": "Application for Official Academic Transcripts (Form COE-01)",
      "authority": "Controller of Examinations",
      "date": "10 Aug 2026",
      "size": "238 KB",
      "cat": "Examinations",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf",
      "isBundled": true,
      "localPath": "assets/official/documents/COE_Form_Transcript_Application.pdf",
    },
    {
      "title": "Application for Duplicate Degree / Diploma (Form COE-02)",
      "authority": "Controller of Examinations",
      "date": "05 Jul 2026",
      "size": "45 KB",
      "cat": "Examinations",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf",
      "isBundled": true,
      "localPath": "assets/official/documents/COE_Form_Duplicate_Certificate.pdf",
    },
    {
      "title": "Tatkal Scheme Instructions & Fee Schedule for Urgent Certificates",
      "authority": "Controller of Examinations",
      "date": "15 May 2026",
      "size": "267 KB",
      "cat": "Examinations",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf",
      "isBundled": true,
      "localPath": "assets/official/documents/COE_Tatkal_Scheme_Instructions.pdf",
    },
    {
      "title": "Ministry of External Affairs e-SANAD Digital Attestation Guidelines",
      "authority": "MEA & Controller of Examinations",
      "date": "30 Dec 2025",
      "size": "2.0 MB",
      "cat": "Examinations",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf",
      "isBundled": true,
      "localPath": "assets/official/documents/MEA_eSANAD_Attestation_Procedure.pdf",
    },
    {
      "title": "Certificate for Compliance of Ph.D. with UGC Regulations",
      "authority": "Research & Development Cell",
      "date": "22 Dec 2025",
      "size": "936 KB",
      "cat": "Research",
      "url": "http://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf",
      "isBundled": true,
      "localPath": "assets/official/documents/UGC_PhD_Compliance_Certificate.pdf",
    },
    {
      "title": "Krishi Vigyan Kendra (KVK) Farm Science Centre Institutional Brochure",
      "authority": "ICAR & School of Agriculture",
      "date": "18 Nov 2025",
      "size": "638 KB",
      "cat": "Regulations",
      "url": "http://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf",
      "isBundled": true,
      "localPath": "assets/official/documents/ICAR_KVK_Farm_Science_Brochure.pdf",
    },
    {
      "title": "Choice Based Credit System (CBCS) Academic Regulations & Syllabus",
      "authority": "Dean, Academic Affairs",
      "date": "10 Jul 2026",
      "size": "2.8 MB",
      "cat": "Regulations",
      "url": "https://ruraluniv.ac.in/academics?content=CBCSsystem",
      "isBundled": false,
      "localPath": "",
    },
    {
      "title": "NAAC Self Study Report (SSR) — Cycle 4 Institutional Re-Accreditation",
      "authority": "Director, IQAC",
      "date": "02 May 2026",
      "size": "12.5 MB",
      "cat": "Regulations",
      "url": "https://ruraluniv.ac.in/iqac",
      "isBundled": false,
      "localPath": "",
    },
    {
      "title": "NIRF 2026 Institutional Data Disclosure Submission",
      "authority": "Registrar, GRI",
      "date": "20 Jan 2026",
      "size": "1.9 MB",
      "cat": "Regulations",
      "url": "https://ruraluniv.ac.in/nirf",
      "isBundled": false,
      "localPath": "",
    },
    {
      "title": "Rules Governing Student Conduct, Discipline & Anti-Ragging Policy",
      "authority": "Proctorial Board & Dean of Student Welfare",
      "date": "12 Jun 2026",
      "size": "850 KB",
      "cat": "Circulars",
      "url": "https://ruraluniv.ac.in/antiragging",
      "isBundled": false,
      "localPath": "",
    },
    {
      "title": "End Semester Examination (ESE) Official Timetables & Schedules",
      "authority": "Controller of Examinations",
      "date": "10 Apr 2026",
      "size": "420 KB",
      "cat": "Examinations",
      "url": "http://ruraluniv.ac.in/examtt",
      "isBundled": false,
      "localPath": "",
    },
    {
      "title": "Application Form for Migration Certificate (Form COE-03)",
      "authority": "Controller of Examinations",
      "date": "14 Mar 2026",
      "size": "180 KB",
      "cat": "Examinations",
      "url": "http://ruraluniv.ac.in/includes/examination/pdf/MigrationCertificate.pdf",
      "isBundled": false,
      "localPath": "",
    },
    {
      "title": "GRI Annual Accounts & Audit Statements (2025-26)",
      "authority": "Finance Officer",
      "date": "15 Feb 2026",
      "size": "4.1 MB",
      "cat": "Regulations",
      "url": "https://ruraluniv.ac.in/gridu?content=AnnualAccountStaments",
      "isBundled": false,
      "localPath": "",
    },
    {
      "title": "RTI Statutory Public Information Officers Roster",
      "authority": "Public Information Officer",
      "date": "05 Jan 2026",
      "size": "150 KB",
      "cat": "Circulars",
      "url": "https://ruraluniv.ac.in/gridu?content=rtiofficers",
      "isBundled": false,
      "localPath": "",
    },
  ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _officialDocs.where((doc) {
      final title = doc['title'].toString().toLowerCase();
      final cat = doc['cat'].toString().toLowerCase();
      final matchesQuery = query.isEmpty || title.contains(query) || cat.contains(query);
      final matchesCat = _selectedCategory == "All" || cat == _selectedCategory.toLowerCase();
      return matchesQuery && matchesCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Official Document Vault", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search & Metrics Header
          Container(
            padding: const EdgeInsets.all(12),
            color: GriColors.forestPrimary.withOpacity(0.06),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Search 595 official documents, prospectuses, forms...",
                    prefixIcon: const Icon(Icons.search, color: GriColors.forestPrimary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Discovered in Audit: 595 Documents", style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: GriColors.forestPrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                      child: const Text("7 Pre-bundled Offline", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Categories Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: _categories.map((c) {
                final isSelected = _selectedCategory == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(c, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: GriColors.forestPrimary.withOpacity(0.18),
                    checkmarkColor: GriColors.forestPrimary,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = c;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Document List
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final doc = filtered[index];
                final isBundled = doc['isBundled'] as bool;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.12),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 22),
                  ),
                  title: Text(
                    doc['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text("${doc['authority']} • ${doc['size']} • ${doc['date']}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isBundled)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                              child: const Text("Pre-bundled Offline", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green)),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                              child: const Text("Official Cloud Stream", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue)),
                            ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                            child: Text(doc['cat'], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBundled ? GriColors.forestPrimary : Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _launchUrl(doc['url']),
                    icon: Icon(isBundled ? Icons.visibility : Icons.download, size: 14),
                    label: Text(isBundled ? "Open" : "Download"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
