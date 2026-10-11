import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';

class MediaGalleryScreen extends StatelessWidget {
  const MediaGalleryScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Media & Video Galleries", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          backgroundColor: GriColors.forestPrimary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: GriColors.ochrePrimary,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.video_library), text: "Official Videos"),
              Tab(icon: Icon(Icons.photo_library), text: "Campus Photography"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVideosTab(context),
            _buildPhotosTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Featured Campus Video Tour
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.black87,
                      child: Image.asset(
                        'assets/official/images/gri_admin_block.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.videocam, color: Colors.white54, size: 48),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: GriColors.forestPrimary.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                      onPressed: () => _launchUrl('https://drive.google.com/file/d/1OCMbFWcuSt2gzrlB8akSkFkTJ39U1ucF/preview'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                          child: const Text("OFFICIAL STREAM", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                        const SizedBox(width: 8),
                        Text("Duration: 08:45 • HD", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text("GRI Campus Panoramic Video Tour", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: GriColors.forestPrimary)),
                    const SizedBox(height: 4),
                    Text(
                      "Comprehensive video walkthrough featuring the 300-acre Gandhigram campus, academic schools, laboratories, library, and rural extension facilities.",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GriColors.forestPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _launchUrl('https://drive.google.com/file/d/1OCMbFWcuSt2gzrlB8akSkFkTJ39U1ucF/preview'),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text("Launch Video Tour Stream"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Official YouTube Channel Tile
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
            ),
            title: const Text("Official GRI YouTube Channel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text("Official broadcasts, convocation ceremonies, seminars & cultural archives.", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => _launchUrl('https://www.youtube.com/channel/UCSxbqMXHb-NUau5lFUwDRyA'),
          ),
        ),

        const SizedBox(height: 10),

        // Anti-Ragging UGC Documentary
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: CircleAvatar(
              backgroundColor: GriColors.ochrePrimary.withOpacity(0.2),
              child: const Icon(Icons.security, color: GriColors.ochrePrimary, size: 26),
            ),
            title: const Text("UGC Anti-Ragging Awareness Film", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text("Statutory national anti-ragging documentary & helpline directives.", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => _launchUrl('https://www.antiragging.in/video.html'),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosTab(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _buildPhotoCard("assets/official/images/gri_official_crest.jpg", "University Emblem", "Charkha & Rising Sun"),
        _buildPhotoCard("assets/official/images/gri_admin_block.png", "Administrative Block", "Historic 1956 Facade"),
        _buildPhotoCard("assets/official/images/chancellor_annamalai.jpg", "Chancellor", "Dr. KM. Annamalai"),
        _buildPhotoCard("assets/official/images/vice_chancellor_panchanatham.jpg", "Vice-Chancellor", "Prof. Dr. N. Panchanatham"),
        _buildPhotoCard("assets/official/images/registrar_marimuthu.jpg", "Registrar", "Dr. K. Marimuthu"),
        _buildPhotoCard("assets/official/images/gri_portal_banner.png", "Official Banner", "ruraluniv.ac.in"),
      ],
    );
  }

  Widget _buildPhotoCard(String assetPath, String title, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, color: Colors.grey)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
