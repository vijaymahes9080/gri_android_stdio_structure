import 'package:flutter/material.dart';

import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../services/verified_institution_content.dart';import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../utils/gri_url_launcher.dart';
import 'campus_map_screen.dart';
import 'department_detail_screen.dart';

/// Verified campus facilities screen.
///
/// The previous version contained invented library holdings, staff names,
/// timings and GPS coordinates. This version lists only facilities that are
/// published by GRI, links every entry to its official page, and uses the
/// official campus map image instead of fabricated pin positions.
class CampusFacilitiesScreen extends StatefulWidget {
  const CampusFacilitiesScreen({super.key});

  @override
  State<CampusFacilitiesScreen> createState() => _CampusFacilitiesScreenState();
}

class _CampusFacilitiesScreenState extends State<CampusFacilitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _category = 'All';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (!OfficialCatalogService.instance.isLoaded) {
      setState(() => _loading = true);
      OfficialCatalogService.instance
          .ensureLoaded()
          .whenComplete(() {
            if (mounted) setState(() => _loading = false);
          })
          .catchError((_) {
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
    for (final facility in VerifiedContent.facilities) {
      set.add(facility.category);
    }
    return set.toList();
  }

  List<VerifiedFacility> _filtered() {
    final q = OfficialText.clean(_query).toLowerCase();
    return VerifiedContent.facilities.where((facility) {
      if (_category != 'All' && facility.category != _category) return false;
      if (q.isEmpty) return true;
      return '${facility.name} ${facility.category}'.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final facilities = _filtered();
    final units = OfficialCatalogService.instance.units;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Campus Facilities'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Open official campus map',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CampusMapScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Open official infrastructure page',
            icon: const Icon(Icons.public),
            onPressed: () => GriUrlLauncher.launch(
                context, VerifiedInstitution.infrastructureUrl),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _buildMapCard(context, isDark),
                const SizedBox(height: 14),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search facilities',
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
                        color: isDark
                            ? GriColors.darkOutlineVariant
                            : GriColors.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark
                            ? GriColors.darkOutlineVariant
                            : GriColors.outlineVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
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
                        backgroundColor:
                            isDark ? GriColors.darkSurface2 : Colors.white,
                        side: BorderSide(
                          color: isDark
                              ? GriColors.darkOutlineVariant
                              : GriColors.outlineVariant,
                        ),
                        onSelected: (_) =>
                            setState(() => _category = category),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'OFFICIAL FACILITIES • ${facilities.length} of '
                  '${VerifiedContent.facilities.length}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: GriColors.forestPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                if (facilities.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No facility matches this search.\n'
                      'Open the official facilities page for the full list.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: isDark
                            ? GriColors.darkOnSurfaceVariant
                            : GriColors.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  ...facilities.map(
                      (facility) => _buildFacilityTile(context, isDark, facility)),
                const SizedBox(height: 18),
                Text(
                  'ACADEMIC UNITS & CENTRES • ${units.length}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: GriColors.forestPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                ...units.take(12).map((unit) => _buildUnitTile(context, isDark, unit)),
                if (units.length > 12)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Showing 12 of ${units.length} units. Use Campus Map or the '
                      'schools directory to browse all units.',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark
                            ? GriColors.darkOnSurfaceVariant
                            : GriColors.onSurfaceVariant,
                      ),
                    ),
                  ),
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
            aspectRatio: 16 / 9,
            child: Image.network(
              VerifiedInstitution.campusMapImageUrl,
              fit: BoxFit.cover,
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
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Official map image could not be loaded. '
                      'Use the map button below to open it in the browser.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11.5),
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
                  '${VerifiedInstitution.campusAcres}-acre campus • '
                  'Gandhigram, Dindigul District',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Official campus map published by GRI. The university does '
                  'not publish building-level coordinates, so this app does '
                  'not place its own pins.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.4,
                    color: isDark
                        ? GriColors.darkOnSurfaceVariant
                        : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        icon: Icons.map_outlined,
                        label: 'Official map',
                        onTap: () => GriUrlLauncher.launch(
                            context, VerifiedInstitution.campusMapImageUrl),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionButton(
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

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GriPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: GriColors.forestPrimary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: GriColors.forestPrimary.withValues(alpha: 0.22),
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

  Widget _buildFacilityTile(
      BuildContext context, bool isDark, VerifiedFacility facility) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.22 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.apartment_outlined,
              size: 17, color: GriColors.forestPrimary),
        ),
        title: Text(
          facility.name,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${facility.category} • official GRI source',
          style: TextStyle(
            fontSize: 10.5,
            color: isDark
                ? GriColors.darkOnSurfaceVariant
                : GriColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 16),
        onTap: () => GriUrlLauncher.launch(context, facility.sourceUrl),
      )),
    );
  }

  Widget _buildUnitTile(
      BuildContext context, bool isDark, OfficialUnit unit) {
    final catalog = OfficialCatalogService.instance;
    final school = catalog.schoolById(unit.schoolId)?.name ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: GriColors.tealSecondary.withValues(alpha: isDark ? 0.22 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.account_balance_outlined,
              size: 17, color: GriColors.tealSecondary),
        ),
        title: Text(
          OfficialText.title(unit.name),
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          [unit.academicLevel, school].where((e) => e.isNotEmpty).join(' • '),
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
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DepartmentDetailScreen(
            departmentId: unit.id,
            departmentName: OfficialText.title(unit.name),
            schoolName: school,
            hodName: '',
            sourceUrl: unit.url,
          ),
        )),
      )),
    );
  }
}
