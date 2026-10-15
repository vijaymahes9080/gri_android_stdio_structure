import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../services/official_resource_registry.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

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
      "size": "5.4 MB",
      "cat": "Admissions",
      "url": "https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf",
    },
    {
      "title": "Application for Official Academic Transcripts (Form COE-01)",
      "authority": "Controller of Examinations",
      "date": "10 Aug 2026",
      "size": "240 KB",
      "cat": "Examinations",
      "url": "https://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf",
    },
    {
      "title": "Application for Duplicate Degree / Diploma (Form COE-02)",
      "authority": "Controller of Examinations",
      "date": "05 Jul 2026",
      "size": "190 KB",
      "cat": "Examinations",
      "url": "https://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf",
    },
    {
      "title": "Certificate for Compliance of Ph.D. with UGC Regulations",
      "authority": "Research & Development Cell",
      "date": "22 Dec 2025",
      "size": "320 KB",
      "cat": "Research",
      "url": "https://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf",
    },
    {
      "title": "e-SANAD Digital Attestation Procedure & Guidelines",
      "authority": "Ministry of External Affairs & GRI",
      "date": "30 Dec 2025",
      "size": "450 KB",
      "cat": "Attestation",
      "url": "https://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf",
    },
    {
      "title": "Tatkal Scheme Instructions for Urgent Certificates",
      "authority": "Controller of Examinations",
      "date": "15 May 2026",
      "size": "180 KB",
      "cat": "Examinations",
      "url": "https://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf",
    },
    {
      "title": "Choice Based Credit System (CBCS) Academic Regulations",
      "authority": "Dean, Academic Affairs",
      "date": "10 Jul 2026",
      "size": "2.8 MB",
      "cat": "Academic",
      "url": "https://ruraluniv.ac.in/academics?content=cbcssystem",
    },
    {
      "title": "Hostel Manual & Residential Living Guidelines",
      "authority": "Office of Chief Warden",
      "date": "01 Jun 2026",
      "size": "1.2 MB",
      "cat": "Hostels",
      "url": "https://ruraluniv.ac.in/includes/infrastructure/hostel/HOSTEL_MANUAL.pdf",
    },
    {
      "title": "Krishi Vigyan Kendra (KVK) Extension & Farmer Programmes",
      "authority": "ICAR - GRI KVK",
      "date": "20 Apr 2026",
      "size": "1.5 MB",
      "cat": "Extension",
      "url": "https://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf",
    },
  ];

  @override
  void dispose() {
    _verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Verification Bento Card
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_user_outlined, color: GriColors.forestPrimary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "e-SANAD Digital Document Verification",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Verify the canonical authenticity of degree certificates, provisional awards, grade cards, and official circulars against the University Registry.",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _verifyController,
                        style: TextStyle(fontSize: 12, color: isDark ? GriColors.darkOnSurface : GriColors.onSurface),
                        decoration: InputDecoration(
                          hintText: "Certificate No (e.g. GRI-CERT-2026-9042)",
                          hintStyle: TextStyle(fontSize: 11.5, color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey),
                          filled: true,
                          fillColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor, width: 0.8)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor, width: 0.8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GriPressable(
                      onTap: () {
                        if (_verifyController.text.trim().isNotEmpty) {
                          provider.verifyDocumentAuthenticity(_verifyController.text.trim());
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: GriColors.forestPrimary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Verify",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                if (provider.verifiedDocumentStatus != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: GriColors.forestPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: GriColors.forestPrimary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      provider.verifiedDocumentStatus!,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Official Publications List
        const Text(
          "OFFICIAL INSTITUTIONAL REPOSITORY",
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: GriColors.forestPrimary, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        ..._officialDocuments.map((doc) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: GriColors.forestPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.picture_as_pdf_outlined, color: GriColors.forestPrimary, size: 18),
                ),
                title: Text(
                  doc["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                ),
                subtitle: Text(
                  "${doc['authority']} • ${doc['date']} • ${doc['size']}",
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                trailing: GriPressable(
                  onTap: () => OfficialResourceRegistry.openDocument(context, doc["title"]!, doc["url"]!),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.open_in_new, size: 16, color: GriColors.forestPrimary),
                  ),
                ),
                onTap: () => OfficialResourceRegistry.openDocument(context, doc["title"]!, doc["url"]!),
              ),
            )),
      ],
    );
  }
}
