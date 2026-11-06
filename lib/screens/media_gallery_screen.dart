import 'package:flutter/material.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../utils/gri_url_launcher.dart';

/// Clean, Production-Grade Media Gallery Screen
/// Integrates 4 verified official YouTube documentary videos and 28 high-resolution
/// archive photographs from the official Gandhigram Rural Institute website.
class MediaGalleryScreen extends StatefulWidget {
  const MediaGalleryScreen({super.key});

  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPhotoGroup = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (!OfficialCatalogService.instance.isLoaded) {
      OfficialCatalogService.instance.ensureLoaded().then((_) {
        if (mounted) setState(() {});
      }).catchError((_) {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showOfficialPhotoDialog(BuildContext context, OfficialPhoto photo, bool isDark) {
    final asset = OfficialCatalogService.assetKey(photo.assetPath);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? GriColors.darkSurface1 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
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
                  maxScale: 4.0,
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                    height: 300,
                    errorBuilder: (_, __, ___) => Image.network(
                      photo.fullUrl,
                      fit: BoxFit.contain,
                      height: 300,
                      errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            photo.group.isNotEmpty ? photo.group : "Official Archive",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: GriColors.forestPrimary,
                            ),
                          ),
                        ),
                        Text(
                          "Photo #${photo.number}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      photo.title.isNotEmpty ? photo.title : "Gandhigram Rural Institute Archive",
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                    ),
                    if (photo.caption.isNotEmpty && photo.caption != photo.title) ...[
                      const SizedBox(height: 4),
                      Text(
                        photo.caption,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (photo.fullUrl.isNotEmpty)
                          TextButton.icon(
                            onPressed: () => GriUrlLauncher.launch(context, photo.fullUrl),
                            icon: const Icon(Icons.open_in_browser, size: 14, color: GriColors.forestPrimary),
                            label: const Text(
                              "View Full Res",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: GriColors.forestPrimary),
                            ),
                          ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            foregroundColor: GriColors.forestPrimary,
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          child: const Text("Close"),
                        ),
                      ],
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
    final catalog = OfficialCatalogService.instance;
    final videos = catalog.videos.isNotEmpty ? catalog.videos : null;
    final photos = catalog.photos.isNotEmpty ? catalog.photosForDisplay() : null;

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
          videos != null
              ? _buildOfficialVideosTab(context, isDark, videos)
              : _buildLegacyVideosTab(context, isDark),
          photos != null
              ? _buildOfficialPhotosTab(context, isDark, photos)
              : _buildLegacyPhotosTab(context, isDark),
        ],
      ),
    );
  }

  Widget _buildOfficialVideosTab(
    BuildContext context,
    bool isDark,
    List<OfficialVideo> videos,
  ) {
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: videos.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.2 : 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.35 : 0.15),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: GriColors.forestPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.video_library, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "OFFICIAL VIDEO ARCHIVES",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: GriColors.forestPrimary,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${videos.length} Verified Institutional Documentaries & Historical Addresses",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final v = videos[index - 1];
        final thumbAsset = OfficialCatalogService.assetKey(v.thumbnailAssetPath);

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
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
                      height: 180,
                      width: double.infinity,
                      color: isDark ? Colors.black45 : Colors.grey.shade100,
                      child: thumbAsset.isNotEmpty
                          ? Image.asset(
                              thumbAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _videoFallback(v),
                            )
                          : _videoFallback(v),
                    ),
                  ),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  GriPressable(
                    onTap: () => GriUrlLauncher.launch(context, v.watchUrl),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
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
                            color: Colors.red.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle_fill, size: 11, color: Colors.red),
                              SizedBox(width: 4),
                              Text(
                                "YOUTUBE ARCHIVE",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "ID: ${v.youtubeId}",
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      v.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    GriPressable(
                      onTap: () => GriUrlLauncher.launch(context, v.watchUrl),
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
                              "Watch on Official YouTube",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: GriColors.forestPrimary,
                              ),
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

  Widget _videoFallback(OfficialVideo v) {
    return Image.network(
      v.thumbnailUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: GriColors.forestPrimary.withValues(alpha: 0.15),
        child: const Icon(Icons.video_collection_outlined, size: 48, color: GriColors.forestPrimary),
      ),
    );
  }

  Widget _buildOfficialPhotosTab(
    BuildContext context,
    bool isDark,
    List<OfficialPhoto> photos,
  ) {
    final groups = ['All', ...photos.map((p) => p.group).toSet()];
    final filtered = _selectedPhotoGroup == 'All'
        ? photos
        : photos.where((p) => p.group == _selectedPhotoGroup).toList();

    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return Column(
      children: [
        if (groups.length > 2)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Row(
              children: groups.map((g) {
                final isSelected = _selectedPhotoGroup == g;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(
                      g == 'All' ? 'All Photos (${photos.length})' : g,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : (isDark ? GriColors.darkOnSurface : Colors.black87),
                      ),
                    ),
                    selectedColor: GriColors.forestPrimary,
                    backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? GriColors.forestPrimary : borderColor,
                      width: 0.8,
                    ),
                    onSelected: (_) => setState(() => _selectedPhotoGroup = g),
                  ),
                );
              }).toList(),
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(14),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.84,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final p = filtered[index];
              final asset = OfficialCatalogService.assetKey(p.assetPath);

              return GriPressable(
                onTap: () => _showOfficialPhotoDialog(context, p, isDark),
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
                              asset,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.network(
                                p.thumbUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.photo_outlined, size: 32, color: Colors.grey),
                                ),
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
                              "Archive #${p.number}",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              p.group.isNotEmpty ? p.group : "Gandhigram Gallery",
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
          ),
        ),
      ],
    );
  }

  Widget _buildLegacyVideosTab(BuildContext context, bool isDark) {
    return const Center(child: Text("Loading official videos..."));
  }

  Widget _buildLegacyPhotosTab(BuildContext context, bool isDark) {
    return const Center(child: Text("Loading campus photography..."));
  }
}
