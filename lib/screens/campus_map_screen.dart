import 'package:flutter/material.dart';
import '../services/official_catalog_service.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../utils/gri_url_launcher.dart';
import 'department_detail_screen.dart';

/// Verified campus map and points of interest.
///
/// GRI publishes its campus map as a single official image and does not publish
/// per-building GPS coordinates. This screen therefore never places artificial
/// pins: it shows the official map, the exact Google Maps place link used by the
/// university website, and a searchable directory of published locations.
class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _category = 'All';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (!OfficialCatalogService.instance.isLoaded) {
      setState(() => _loading = true);
      OfficialCatalogService.instance.ensureLoaded().whenComplete(() {
        if (mounted) setState(() => _loading = false);
      }).catchError((_) {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final set = <String>{'All'};
    for (final f in VerifiedContent.facilities) {
      set.add(f.category);
    }
    for (final u in OfficialCatalogService.instance.units) {
      set.add(u.academicLevel);
    }
    return set.toList();
  }

  List<_Poi> _points() {
    final q = OfficialText.clean(_query).toLowerCase();
    final list = <_Poi>[];
    for (final f in VerifiedContent.facilities) {
      list.add(_Poi(
        id: f.id,
        name: f.name,
        category: f.category,
        subtitle: 'Official campus facility',
        url: f.sourceUrl,
        isUnit: false,
      ));
    }
    for (final u in OfficialCatalogService.instance.units) {
      list.add(_Poi(
        id: u.id,
        name: OfficialText.title(u.name),
        category: u.academicLevel,
        subtitle: OfficialCatalogService.instance.schoolById(u.schoolId)?.name ?? '',
        url: u.url,
        isUnit: true,
        unitId: u.id,
      ));
    }
    return list.where((p) {
      if (_category != 'All' && p.category != _category) return false;
      if (q.isEmpty) return true;
      return '${p.name} ${p.category} ${p.subtitle}'.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final points = _points();
    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Campus Map & Locations'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildMapCard(context, isDark),
          const SizedBox(height: 14),
          _buildSearch(context, isDark),
          const SizedBox(height: 8),
          _buildChips(isDark),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 13, color: GriColors.ochrePrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'GRI publishes the campus map as an image. Building-level GPS '
                  'coordinates are not published, so no pin positions are '
                  'invented here.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.35,
                    color: isDark
                        ? GriColors.darkOnSurfaceVariant
                        : GriColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (points.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No campus location matches this search.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? GriColors.darkOnSurfaceVariant
                      : GriColors.onSurfaceVariant,
                ),
              ),
            )
          else
            ...points.map((p) => _buildPoiTile(context, isDark, p)),
        ],
      ),
    );
  }

  Widget _buildMapCard(BuildContext context, bool isDark) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              VerifiedInstitution.campusMapImageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: GriColors.forestPrimary.withValues(alpha: 0.06),
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: GriColors.forestPrimary.withValues(alpha: 0.08),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_outlined,
                            size: 40, color: GriColors.forestPrimary),
                        SizedBox(height: 8),
                        Text(
                          'The official map image could not be loaded.\n'
                          'Open it in the browser instead.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gandhigram campus • Dindigul District, Tamil Nadu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Official campus map published by GRI • '
                  '${VerifiedInstitution.campusAcres}-acre campus',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? GriColors.darkOnSurfaceVariant
                        : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _mapAction(
                        context,
                        isDark,
                        icon: Icons.map_outlined,
                        label: 'Official map',
                        onTap: () => GriUrlLauncher.launch(
                            context, VerifiedInstitution.campusMapImageUrl),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _mapAction(
                        context,
                        isDark,
                        icon: Icons.navigation_outlined,
                        label: 'Google Maps',
                        onTap: () => GriUrlLauncher.launch(
                            context, VerifiedInstitution.googleMapsUrl),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapAction(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GriPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: GriColors.forestPrimary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: GriColors.forestPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, bool isDark) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: 'Search buildings, departments and facilities',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
        isDense: true,
        filled: true,
        fillColor: isDark ? GriColors.darkSurface2 : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildChips(bool isDark) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = category == _category;
          return ChoiceChip(
            label: Text(
              category,
              style: TextStyle(
                fontSize: 10.5,
                color: selected
                    ? Colors.white
                    : (isDark
                        ? GriColors.darkOnSurfaceVariant
                        : GriColors.onSurfaceVariant),
              ),
            ),
            selected: selected,
            selectedColor: GriColors.forestPrimary,
            backgroundColor: isDark ? GriColors.darkSurface2 : Colors.white,
            side: BorderSide(
              color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
            ),
            onSelected: (_) => setState(() => _category = category),
          );
        },
      ),
    );
  }

  Widget _buildPoiTile(BuildContext context, bool isDark, _Poi poi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.22 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            poi.isUnit ? Icons.account_balance_outlined : Icons.place_outlined,
            size: 17,
            color: GriColors.forestPrimary,
          ),
        ),
        title: Text(
          poi.name,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          [poi.category, poi.subtitle].where((e) => e.isNotEmpty).join(' • '),
          style: TextStyle(
            fontSize: 10.5,
            color: isDark
                ? GriColors.darkOnSurfaceVariant
                : GriColors.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () {
          if (poi.isUnit && poi.unitId != null) {
            final catalog = OfficialCatalogService.instance;
            final unit = catalog.unitById(poi.unitId!);
            final school = unit == null ? '' : catalog.schoolById(unit.schoolId)?.name ?? '';
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DepartmentDetailScreen(
                departmentId: poi.unitId!,
                departmentName: poi.name,
                schoolName: school,
                hodName: '',
                sourceUrl: poi.url,
              ),
            ));
          } else {
            GriUrlLauncher.launch(context, poi.url);
          }
        },
      ),
    );
  }
}

class _Poi {
  final String id;
  final String name;
  final String category;
  final String subtitle;
  final String url;
  final bool isUnit;
  final String? unitId;

  const _Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.url,
    required this.isUnit,
    this.unitId,
  });
}
