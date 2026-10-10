import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

class OfficialDocumentCenterScreen extends StatefulWidget {
  const OfficialDocumentCenterScreen({super.key});

  @override
  State<OfficialDocumentCenterScreen> createState() => _OfficialDocumentCenterScreenState();
}

class _OfficialDocumentCenterScreenState extends State<OfficialDocumentCenterScreen> {
  final _verifyController = TextEditingController();

  final List<Map<String, String>> _officialDocuments = [
    {
      "title": "GRI Admissions Prospectus 2026-27 (All Programmes)",
      "authority": "Directorate of Admissions",
      "date": "15 Aug 2026",
      "size": "4.2 MB",
      "cat": "Admissions",
    },
    {
      "title": "Choice Based Credit System (CBCS) Academic Regulations & Curriculum",
      "authority": "Dean, Academic Affairs",
      "date": "10 Jul 2026",
      "size": "2.8 MB",
      "cat": "Academic",
    },
    {
      "title": "NAAC Self Study Report (SSR) — Cycle 4 Re-Accreditation",
      "authority": "Internal Quality Assurance Cell (IQAC)",
      "date": "02 May 2026",
      "size": "12.5 MB",
      "cat": "Accreditation",
    },
    {
      "title": "NIRF 2026 Institutional Data Disclosure Submission",
      "authority": "Registrar's Office",
      "date": "20 Jan 2026",
      "size": "1.9 MB",
      "cat": "Governance",
    },
    {
      "title": "Rules Governing Student Conduct, Discipline & Anti-Ragging Policy",
      "authority": "Proctorial Board & Dean of Student Welfare",
      "date": "12 Jun 2026",
      "size": "850 KB",
      "cat": "Student Welfare",
    },
  ];

  @override
  void dispose() {
    _verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Verification Card
        Card(
          color: GriColors.forestContainer.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_user, color: GriColors.forestPrimary, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "e-SANAD Digital Document Verification",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: GriColors.forestOnContainer),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Verify authenticity of degree certificates, provisional awards, grade cards, and official circulars against the University Registry.",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _verifyController,
                        decoration: InputDecoration(
                          hintText: "Enter Certificate No (e.g. GRI-CERT-2026-9042)",
                          hintStyle: const TextStyle(fontSize: 11.5),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GriColors.forestPrimary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_verifyController.text.trim().isNotEmpty) {
                          provider.verifyDocumentAuthenticity(_verifyController.text.trim());
                        }
                      },
                      child: const Text("Verify"),
                    ),
                  ],
                ),
                if (provider.verifiedDocumentStatus != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: GriColors.forestPrimary),
                    ),
                    child: Text(
                      provider.verifiedDocumentStatus!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Official Publications List
        const Text(
          "OFFICIAL INSTITUTIONAL REPOSITORY",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
        ),
        const SizedBox(height: 10),
        ..._officialDocuments.map((doc) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: GriColors.forestContainer,
                  child: Icon(Icons.picture_as_pdf, color: GriColors.forestPrimary),
                ),
                title: Text(
                  doc["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  "${doc['authority']} • ${doc['date']} • ${doc['size']}",
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.download, size: 20, color: GriColors.forestPrimary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Downloading ${doc['title']}...")),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}
