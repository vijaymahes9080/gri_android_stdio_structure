import 'package:flutter/material.dart';
import '../services/official_resource_registry.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class MediaGalleryScreen extends StatefulWidget {
  const MediaGalleryScreen({super.key});

  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _videos = [
    {
      "id": "VID_CAMPUS_TOUR",
      "title": "GRI Campus Panoramic Video Tour",
      "duration": "08:45 • Full HD",
      "badge": "CAMPUS OVERVIEW",
      "desc": "Walkthrough featuring the 300-acre Gandhigram campus, 8 academic schools, specialized research laboratories, and rural extensions.",
      "image": "assets/official/images/gri_admin_block.png",
    },
    {
      "id": "VID_YOUTUBE_CHANNEL",
      "title": "Official GRI YouTube Channel & Convocation Archives",
      "duration": "Official Channel",
      "badge": "LIVESTREAM ARCHIVES",
      "desc": "Official convocation ceremonies, Chancellor & Vice-Chancellor addresses, national seminars, and rural cultural festivals.",
      "image": "assets/images/gri_emblem_3d.jpg",
    },
    {
      "id": "VID_ANTI_RAGGING_FILM",
      "title": "Statutory UGC Anti-Ragging Awareness Film",
      "duration": "12:10 • Documentary",
      "badge": "STATUTORY DIRECTIVE",
      "desc": "National directive documentary on creating a safe, inclusive campus with 24x7 grievance escalation hotlines.",
      "image": "assets/images/student_avatar.jpg",
    },
  ];

  final List<Map<String, String>> _photos = [
    {
      "title": "Dr. Radhakrishnan Central Library",
      "subtitle": "1,80,000+ volumes & digital archives",
      "path": "assets/images/library_front.jpg",
      "category": "Academic Infrastructure",
    },
    {
      "title": "GRI Rural Health Centre",
      "subtitle": "24x7 clinical care & outpatient dispensary",
      "path": "assets/images/health_centre.jpg",
      "category": "Healthcare & Welfare",
    },
    {
      "title": "Administrative Heritage Block",
      "subtitle": "Foundational 1956 facade & Secretariat",
      "path": "assets/official/images/gri_admin_block.png",
      "category": "Institutional Heritage",
    },
    {
      "title": "Official University Crest",
      "subtitle": "Charkha, rising sun & rural emblem",
      "path": "assets/official/images/gri_official_crest.jpg",
      "category": "Emblem & Insignia",
    },
    {
      "title": "Dr. KM. Annamalai",
      "subtitle": "Hon'ble Chancellor",
      "path": "assets/official/images/chancellor_annamalai.jpg",
      "category": "Leadership",
    },
    {
      "title": "Prof. Dr. N. Panchanatham",
      "subtitle": "Vice-Chancellor (Officiating)",
      "path": "assets/official/images/vice_chancellor_panchanatham.jpg",
      "category": "Leadership",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPhotoDialog(BuildContext context, Map<String, String> photo) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).brightness == Brightness.dark ? GriColors.darkSurface1 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(ctx).brightness == Brightness.dark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: InteractiveViewer(
                  maxScale: 3.5,
                  child: Image.asset(
                    photo["path"]!,
                    fit: BoxFit.contain,
                    height: 280,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 280,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        photo["category"]!,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      photo["title"]!,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      photo["subtitle"]!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(ctx).brightness == Brightness.dark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          foregroundColor: GriColors.forestPrimary,
                          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        child: const Text("Close"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Media & Video Galleries",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: "Official Videos"),
            Tab(text: "Campus Photography"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVideosTab(context, isDark),
          _buildPhotosTab(context, isDark),
        ],
      ),
    );
  }

  Widget _buildVideosTab(BuildContext context, bool isDark) {
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final v = _videos[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      color: isDark ? Colors.black45 : Colors.grey.shade100,
                      child: Image.asset(
                        v["image"],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: GriColors.forestPrimary.withValues(alpha: 0.15),
                          child: const Icon(Icons.video_collection_outlined, size: 48, color: GriColors.forestPrimary),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                  GriPressable(
                    onTap: () => OfficialResourceRegistry.openVideo(context, v["id"]),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            v["badge"],
                            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          v["duration"],
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      v["title"],
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      v["desc"],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GriPressable(
                      onTap: () => OfficialResourceRegistry.openVideo(context, v["id"]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor, width: 0.8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_new, size: 14, color: GriColors.forestPrimary),
                            SizedBox(width: 6),
                            Text(
                              "Launch Official Stream",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GriColors.forestPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotosTab(BuildContext context, bool isDark) {
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return GridView.builder(
      padding: const EdgeInsets.all(14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        final p = _photos[index];
        return GriPressable(
          onTap: () => _showPhotoDialog(context, p),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                    child: Container(
                      width: double.infinity,
                      color: isDark ? Colors.black38 : Colors.grey.shade100,
                      child: Image.asset(
                        p["path"]!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.photo_outlined, size: 32, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p["subtitle"]!,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
