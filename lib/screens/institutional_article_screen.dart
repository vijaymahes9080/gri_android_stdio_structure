import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';

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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: GriColors.ochrePrimary),
            tooltip: "Open Official Web Page",
            onPressed: () => _launchUrl(sourceUrl),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Badge Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: GriColors.forestPrimary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.verified, size: 16, color: GriColors.ochrePrimary),
                      const SizedBox(width: 4),
                      Text("Official GRI Record", style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
                  const SizedBox(height: 6),
                  Text(
                    "Source Domain: $sourceUrl",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Overview & Executive Content
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Executive Overview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    summary ??
                        "This institutional section forms an official public publication of The Gandhigram Rural Institute (Deemed to be University). It establishes governance provisions, academic criteria, and regulatory transparency under UGC guidelines and the institutional Memorandum of Association.",
                    style: const TextStyle(fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  const Text("Statutory Key Directives:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  if (keyPoints != null && keyPoints!.isNotEmpty)
                    ...keyPoints!.map((pt) => _buildBullet(pt))
                  else ...[
                    _buildBullet("Mandatory adherence to UGC (Deemed to be University) Regulations and GRI MoA."),
                    _buildBullet("Regular review and approval by Academic Council and Syndicate bodies."),
                    _buildBullet("Public dissemination for student welfare, research transparency, and accountability."),
                    _buildBullet("Digital synchronization with national platforms (DigiLocker, SAMARTH, NIRF, NAAC)."),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Attached Documents Section (if any)
          if (documents != null && documents!.isNotEmpty) ...[
            const Text("OFFICIAL DOWNLOADABLE DOCUMENTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            ...documents!.map((doc) => _buildDocTile(doc['title'] ?? 'Official Document', doc['url'] ?? sourceUrl)),
            const SizedBox(height: 16),
          ],

          // Open Web Source Action Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: GriColors.forestPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => _launchUrl(sourceUrl),
            icon: const Icon(Icons.public),
            label: const Text("View Canonical Article on ruraluniv.ac.in", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.35))),
        ],
      ),
    );
  }

  Widget _buildDocTile(String docTitle, String docUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(docTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        trailing: const Icon(Icons.download, size: 18, color: GriColors.forestPrimary),
        onTap: () => _launchUrl(docUrl),
      ),
    );
  }
}
