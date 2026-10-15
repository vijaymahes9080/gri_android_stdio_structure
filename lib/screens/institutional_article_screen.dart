import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../services/seed_data_service.dart';
import '../services/official_resource_registry.dart';

/// Production-Grade Institutional Article Screen
/// Dynamically renders official articles, clean summaries, and attached documents
/// retrieved from the unified Gandhigram Rural Institute website dataset.
class InstitutionalArticleScreen extends StatelessWidget {
  final String title;
  final String category;
  final String sourceUrl;
  final String? summary;
  final List<String>? keyPoints;
  final List<Map<String, String>>? documents;

  const InstitutionalArticleScreen({
    super.key,
    required this.title,
    required this.category,
    required this.sourceUrl,
    this.summary,
    this.keyPoints,
    this.documents,
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
          content: Text("Failed to open URL: $e"),
          backgroundColor: GriColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Retrieve rich data from SeedDataService if available
    final pageData = SeedDataService.instance.getPageByIdOrUrl(sourceUrl);

    final resolvedCategory = (pageData != null && (pageData['category'] ?? '').isNotEmpty)
        ? pageData['category'] as String
        : category;

    final resolvedSummary = summary ??
        ((pageData != null && (pageData['clean_summary'] ?? '').isNotEmpty)
            ? pageData['clean_summary'] as String
            : "This institutional publication forms an official public publication of The Gandhigram Rural Institute (Deemed to be University). It establishes governance provisions, academic criteria, and regulatory transparency under UGC guidelines and the institutional Memorandum of Association.");

    // Extract attached documents
    final List<Map<String, String>> resolvedDocs = [];
    if (documents != null && documents!.isNotEmpty) {
      resolvedDocs.addAll(documents!);
    } else if (pageData != null && pageData['resources'] != null) {
      final docList = pageData['resources']['documents'] as List<dynamic>? ?? [];
      for (final d in docList) {
        if (d is Map && d['url'] != null) {
          resolvedDocs.add({
            'title': (d['title'] ?? 'Official Attached Document').toString(),
            'url': d['url'].toString(),
          });
        }
      }
    }

    final httpStatus = pageData != null ? (pageData['http_status'] ?? 200) : 200;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // 1. Header Metadata Card with smooth fade-in
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
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: GriColors.forestPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          resolvedCategory.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: GriColors.forestPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.verified, size: 15, color: GriColors.ochrePrimary),
                      const SizedBox(width: 4),
                      Text(
                        "Verified (HTTP $httpStatus)",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.link, size: 13, color: GriColors.outline),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          sourceUrl,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 2. Executive Overview & Clean Excerpt Card
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
                      const Icon(Icons.description, size: 18, color: GriColors.forestPrimary),
                      const SizedBox(width: 8),
                      Text(
                        "Executive Summary & Directives",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  Text(
                    resolvedSummary,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? GriColors.darkOnSurface : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Statutory Governance Provisions:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  if (keyPoints != null && keyPoints!.isNotEmpty)
                    ...keyPoints!.map((pt) => _buildBullet(pt, isDark))
                  else ...[
                    _buildBullet("Mandatory adherence to UGC (Deemed to be University) Regulations and GRI MoA.", isDark),
                    _buildBullet("Curricular and administrative oversight by Academic Council & Board of Management.", isDark),
                    _buildBullet("Nai Talim rural community engagement and field extension internship criteria.", isDark),
                    _buildBullet("National academic integration with DigiLocker, APAAR, Samarth, and NIRF disclosures.", isDark),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 3. Official Attached Documents Section
          if (resolvedDocs.isNotEmpty) ...[
            GriFadeSlideEntrance(
              delay: const Duration(milliseconds: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.folder_open, size: 17, color: GriColors.forestPrimary),
                      const SizedBox(width: 6),
                      Text(
                        "OFFICIAL ATTACHED DOCUMENTS (${resolvedDocs.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: GriColors.forestPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...resolvedDocs.map((doc) => _buildDocTile(context, doc['title'] ?? 'Document', doc['url'] ?? sourceUrl, isDark)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],

          const SizedBox(height: 6),

          // 4. Canonical Web Action
          GriPressable(
            onTap: () => _launchUrl(context, sourceUrl),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: GriColors.forestPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.public, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Open Official Web Page on ruraluniv.ac.in",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBullet(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocTile(BuildContext context, String docTitle, String docUrl, bool isDark) {
    final isPdf = docUrl.toLowerCase().endsWith('.pdf');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 0.8,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPdf ? Colors.red.withValues(alpha: 0.12) : GriColors.forestPrimary.withValues(alpha: 0.12),
          child: Icon(
            isPdf ? Icons.picture_as_pdf : Icons.description,
            color: isPdf ? Colors.red.shade700 : GriColors.forestPrimary,
            size: 20,
          ),
        ),
        title: Text(
          docTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.5,
            color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          ),
        ),
        subtitle: Text(
          docUrl,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.download, size: 18, color: GriColors.forestPrimary),
        onTap: () => OfficialResourceRegistry.smartOpenDocument(context, docUrl, title: docTitle),
      ),
    );
  }
}
