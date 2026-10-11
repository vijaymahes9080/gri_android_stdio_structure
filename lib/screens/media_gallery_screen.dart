import 'package:flutter/material.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

class MediaGalleryScreen extends StatelessWidget {
  const MediaGalleryScreen({super.key});

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
                      child: OfficialResourceRegistry.buildImage(
                        "IMG_ADMIN_BLOCK",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: GriColors.forestPrimary.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                      onPressed: () => OfficialResourceRegistry.openVideo(context, "VID_CAMPUS_TOUR"),
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
                      onPressed: () => OfficialResourceRegistry.openVideo(context, "VID_CAMPUS_TOUR"),
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
            onTap: () => OfficialResourceRegistry.openVideo(context, "VID_YOUTUBE_CHANNEL"),
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
            onTap: () => OfficialResourceRegistry.openVideo(context, "VID_ANTI_RAGGING_FILM"),
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
        _buildPhotoCard("IMG_OFFICIAL_CREST", "University Emblem", "Charkha & Rising Sun"),
        _buildPhotoCard("IMG_ADMIN_BLOCK", "Administrative Block", "Historic 1956 Facade"),
        _buildPhotoCard("IMG_CHANCELLOR_ANNAMALAI", "Chancellor", "Dr. KM. Annamalai"),
        _buildPhotoCard("IMG_VC_PANCHANATHAM", "Vice-Chancellor", "Prof. Dr. N. Panchanatham"),
        _buildPhotoCard("IMG_REGISTRAR_MARIMUTHU", "Registrar", "Dr. K. Marimuthu"),
        _buildPhotoCard("IMG_PORTAL_BANNER", "Official Banner", "ruraluniv.ac.in"),
      ],
    );
  }

  Widget _buildPhotoCard(String resourceId, String title, String subtitle) {
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
                child: OfficialResourceRegistry.buildImage(
                  resourceId,
                  fit: BoxFit.contain,
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
