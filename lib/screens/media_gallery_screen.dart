import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../utils/gri_colors.dart';

/// Official gallery screen displaying GRI's verified gallery photographs and
/// official YouTube videos. All assets are sourced from the canonical dataset
/// generated from https://www.ruraluniv.ac.in/.
class MediaGalleryScreen extends StatefulWidget {
  const MediaGalleryScreen({super.key});

  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInit = true;

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

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = OfficialCatalogService.instance;

    if (_isInit) {
      _isInit = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        catalog.ensureLoaded().then((_) => setState(() {}));
      });
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!catalog.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Gallery & Videos')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final photos = catalog.photosForDisplay();
    final videos = catalog.videos;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Gallery & Videos'),
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
            Tab(text: 'Photos'),
            Tab(text: 'Videos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPhotoGrid(context, isDark, photos),
          _buildVideoGrid(context, isDark, videos),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, bool isDark, List<OfficialPhoto> photos) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1 / 1.2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final p = photos[index];
        final thumbPath = p.thumbAssetPath;
        return _GalleryPressable(
          onTap: () => _showFullImage(context, p.fullUrl, p.title),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
            ),
            child: thumbPath.isNotEmpty
                ? Image.asset(
                    thumbPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_outlined,
                      color: GriColors.forestPrimary,
                      size: 64,
                    ),
                  )
                : const Icon(
                    Icons.image_outlined,
                    color: GriColors.forestPrimary,
                    size: 64,
                  ),
          ),
        );
      },
    );
  }

  void _showFullImage(
      BuildContext context, String fullUrl, String title) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 3.0,
            child: Image.network(
              fullUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoGrid(BuildContext context, bool isDark, List<OfficialVideo> videos) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 16 / 22,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final v = videos[index];
        return _GalleryPressable(
          onTap: () => _launchUrl(v.watchUrl),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_arrow,
                  color: GriColors.forestPrimary,
                  size: 48,
                ),
                const SizedBox(height: 6),
                Text(
                  v.title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? GriColors.darkOnSurface : Colors.black87,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Official YouTube video',
                  style: TextStyle(
                    fontSize: 8,
                    color: GriColors.forestPrimary,
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

class _GalleryPressable extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _GalleryPressable({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }
}