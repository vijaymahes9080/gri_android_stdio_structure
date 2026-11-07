import 'package:flutter/material.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';

/// Verified faculty directory built from the canonical official dataset.
///
/// Only values published by GRI are displayed. Contact details are omitted
/// unless they are present in the source record, and the official profile link
/// is always shown for traceability.
class FacultyDirectoryScreen extends StatefulWidget {
  final String initialQuery;

  const FacultyDirectoryScreen({super.key, this.initialQuery = ''});

  @override
  State<FacultyDirectoryScreen> createState() => _FacultyDirectoryScreenState();
}

class _FacultyDirectoryScreenState extends State<FacultyDirectoryScreen> {
  late final TextEditingController _searchController;
  String _query = '';
  String _selectedSchool = 'All institutions';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchController = TextEditingController(text: _query);
    _ensureCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _ensureCatalog() async {
    if (OfficialCatalogService.instance.isLoaded) return;
    setState(() => _loading = true);
    try {
      await OfficialCatalogService.instance.ensureLoaded();
    } catch (e) {
      _error = 'The verified faculty dataset could not be loaded. '
          'You can still open the official administration page.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<OfficialFaculty> _filtered() {
    final catalog = OfficialCatalogService.instance;
    final q = OfficialText.clean(_query).toLowerCase();
    return catalog.faculty.where((f) {
      if (_selectedSchool != 'All institutions') {
        final schools = f.affiliations.map((a) => a.schoolName).toSet();
        if (!schools.contains(_selectedSchool)) return false;
      }
      if (q.isEmpty) return true;
      final hay = '${OfficialText.clean(f.name)} '
              '${OfficialText.clean(f.designation)} '
              '${OfficialText.clean(f.specialization)} '
              '${OfficialText.clean(f.qualifications)} '
              '${f.affiliations.map((a) => '${a.unitName} ${a.schoolName}').join(' ')}'
          .toLowerCase();
      return hay.contains(q);
    }).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  List<String> _schools() {
    final names = OfficialCatalogService.instance.faculty
        .expand((f) => f.affiliations.map((a) => a.schoolName))
        .where((s) => s.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ['All institutions', ...names];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catalog = OfficialCatalogService.instance;
    final results = _filtered();

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Faculty Directory'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Open official administration page',
            icon: const Icon(Icons.public),
            onPressed: () =>
                GriUrlLauncher.launch(context, VerifiedInstitution.administrationUrl),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError(context)
              : Column(
                  children: [
                    _buildHeader(context, isDark, catalog, results.length),
                    _buildSearch(context, isDark),
                    _buildSchoolChips(context, isDark),
                    Expanded(
                      child: results.isEmpty
                          ? _buildEmpty(context)
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                              itemCount: results.length,
                              itemBuilder: (context, index) => _FacultyCard(
                                faculty: results[index],
                                isDark: isDark,
                                onTap: () => _showProfile(context, results[index]),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark,
      OfficialCatalogService catalog, int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VERIFIED FACULTY RECORDS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: GriColors.forestPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count of ${catalog.faculty.length} official faculty records • '
            'Source: ruraluniv.ac.in',
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: isDark
                  ? GriColors.darkOnSurfaceVariant
                  : GriColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Search name, designation, department or specialisation',
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
      ),
    );
  }

  Widget _buildSchoolChips(BuildContext context, bool isDark) {
    final schools = _schools();
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: schools.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final school = schools[index];
          final selected = school == _selectedSchool;
          return ChoiceChip(
            label: Text(
              school,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
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
            onSelected: (_) => setState(() => _selectedSchool = school),
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No faculty record matches this search.\n'
          'Try a department name, designation or specialisation.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 40, color: GriColors.warning),
            const SizedBox(height: 10),
            Text(_error ?? 'Faculty data unavailable.', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => GriUrlLauncher.launch(
                  context, VerifiedInstitution.administrationUrl),
              child: const Text('Open official administration page'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfile(BuildContext context, OfficialFaculty faculty) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = OfficialText.title(faculty.name, fallback: 'Faculty member');
    final sources = <String>{
      if (faculty.profileUrl.isNotEmpty) faculty.profileUrl,
      for (final a in faculty.affiliations)
        if (a.sourceUrl.isNotEmpty) a.sourceUrl,
    }.toList();
    final photoPath = OfficialCatalogService.assetKey(faculty.photoAsset);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FacultyAvatar(
                        faculty: faculty,
                        photoPath: photoPath,
                        size: 64,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (faculty.designation.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                OfficialText.clean(faculty.designation),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: GriColors.forestPrimary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  for (final a in faculty.affiliations)
                    _detailRow(
                      Icons.account_balance_outlined,
                      [a.unitName, a.schoolName]
                          .where((e) => e.isNotEmpty)
                          .join(' • '),
                    ),
                  if (faculty.qualifications.isNotEmpty)
                    _detailRow(Icons.school_outlined,
                        OfficialText.clean(faculty.qualifications)),
                  if (faculty.specialization.isNotEmpty)
                    _detailRow(Icons.science_outlined,
                        'Specialisation: ${OfficialText.clean(faculty.specialization)}'),
                  if (faculty.scholar.isNotEmpty)
                    _detailRow(Icons.link, 'Google Scholar listed on official profile'),
                  if (faculty.orcid.isNotEmpty)
                    _detailRow(Icons.badge_outlined, 'ORCID: ${faculty.orcid}'),
                  const SizedBox(height: 10),
                  Text(
                    'Only information published on the official GRI website is '
                    'shown. Private contact details are not exposed.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: isDark
                          ? GriColors.darkOnSurfaceVariant
                          : GriColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (sources.isEmpty)
                    const Text('No official profile link was published.')
                  else
                    ...sources.map(
                      (url) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton.icon(
                          onPressed: () => GriUrlLauncher.launch(ctx, url),
                          icon: const Icon(Icons.public, size: 16),
                          label: Text(
                            'Open official source',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String text) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: GriColors.forestPrimary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, height: 1.35)),
          ),
        ],
      ),
    );
  }
}

class _FacultyCard extends StatelessWidget {
  final OfficialFaculty faculty;
  final bool isDark;
  final VoidCallback onTap;

  const _FacultyCard({
    required this.faculty,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final photoPath = OfficialCatalogService.assetKey(faculty.photoAsset);
    final affiliation = faculty.affiliations.isNotEmpty
        ? faculty.affiliations.first
        : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: _FacultyAvatar(
          faculty: faculty,
          photoPath: photoPath,
          size: 44,
          isDark: isDark,
        ),
        title: Text(
          OfficialText.title(faculty.name, fallback: 'Faculty member'),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            [
              OfficialText.clean(faculty.designation),
              if (affiliation != null) affiliation.unitName,
            ].where((e) => e.isNotEmpty).join(' • '),
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? GriColors.darkOnSurfaceVariant
                  : GriColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
      )),
    );
  }
}

class _FacultyAvatar extends StatelessWidget {
  final OfficialFaculty faculty;
  final String photoPath;
  final double size;
  final bool isDark;

  const _FacultyAvatar({
    required this.faculty,
    required this.photoPath,
    required this.size,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        faculty.initials,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: GriColors.forestPrimary,
        ),
      ),
    );
    final source = photoPath.isNotEmpty
        ? photoPath
        : (faculty.photoUrl.isNotEmpty ? faculty.photoUrl : '');
    if (source.isEmpty) return fallback;
    return ClipOval(
      child: source.startsWith('http')
          ? Image.network(
              source,
              width: size,
              height: size,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null ? child : fallback,
              errorBuilder: (_, __, ___) => fallback,
            )
          : Image.asset(
              source,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}
