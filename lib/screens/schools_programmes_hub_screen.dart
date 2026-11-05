import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import 'admissions_prospectus_screen.dart';
import 'department_detail_screen.dart';

/// Schools, programmes and research centres exactly as published by GRI.
/// No intake numbers, fees or direct contacts are shown because the official
/// pages do not publish them in a stable, verifiable form.
class SchoolsProgrammesHubScreen extends StatefulWidget {
  const SchoolsProgrammesHubScreen({super.key});

  @override
  State<SchoolsProgrammesHubScreen> createState() => _SchoolsProgrammesHubScreenState();
}

class _SchoolsProgrammesHubScreenState extends State<SchoolsProgrammesHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _programmeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!catalog.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Schools & Programmes')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final schools = catalog.schools.where((s) => s.type == 'school').toList();
    final programmes = catalog.programmes.where((p) {
      if (_programmeFilter == 'all') return true;
      return p.level.toLowerCase() == _programmeFilter.toLowerCase();
    }).toList();
    final centres = catalog.units.where((u) => u.type == 'centre' || u.type == 'kaushal-kendra').toList();

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          'Schools & Academic Programmes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: [
            Tab(text: '${schools.length} Schools'),
            Tab(text: 'Programmes (${catalog.programmes.length})'),
            Tab(text: 'Centres (${centres.length})'),
            const Tab(text: 'Regulations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSchools(context, isDark, schools),
          _buildProgrammes(context, isDark, programmes),
          _buildCentres(context, isDark, centres),
          _buildRegulations(context, isDark),
        ],
      ),
    );
  }

  Widget _buildSchools(BuildContext context, bool isDark, List<OfficialSchool> schools) {
    final catalog = OfficialCatalogService.instance;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _banner(context, isDark,
            'Official school-to-department mapping from the Academics and Administration pages.'),
        const SizedBox(height: 12),
        ...schools.map((s) {
          final units = catalog.unitsForSchool(s.id);
          final photo = OfficialCatalogService.assetKey(s.deanPhotoAsset);
          return GriPressable(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DepartmentDetailScreen(
                departmentId: s.id,
                departmentName: s.name,
                schoolName: s.name,
                hodName: s.deanName,
                sourceUrl: s.sourceUrls.isNotEmpty
                    ? s.sourceUrls.first
                    : 'https://www.ruraluniv.ac.in/page/academics',
              ),
            )),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _avatar(photo, s.deanName),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.deanName.isEmpty ? 'Dean not published' : s.deanName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.5,
                                color: isDark ? GriColors.darkOnSurface : Colors.black87,
                              ),
                            ),
                            Text(
                              s.deanDesignation.isEmpty ? 'Dean' : s.deanDesignation,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${units.length} units',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: GriColors.ochrePrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: units
                        .map((u) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                u.name.replaceFirst('Department of ', '').replaceFirst('Centre for ', ''),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'View departments, faculty & syllabi',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: GriColors.forestPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 10, color: GriColors.forestPrimary),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProgrammes(BuildContext context, bool isDark, List<OfficialProgramme> programmes) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _filterChip('All', 'all'),
              _filterChip('UG', 'UG'),
              _filterChip('PG', 'PG'),
              _filterChip('Vocational', 'Vocational'),
              _filterChip('Diploma', 'Diploma'),
              _filterChip('Integrated', 'Integrated'),
            ],
          ),
        ),
        Expanded(
          child: programmes.isEmpty
              ? _empty(context, 'No programmes match this filter.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: programmes.length,
                  itemBuilder: (context, index) {
                    final p = programmes[index];
                    final unit = OfficialCatalogService.instance.unitById(p.unitId);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isDark ? GriColors.darkSurface1 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                          width: 1.0,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _showProgrammeModal(context, p, unit, isDark),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p.displayName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        p.level,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                          color: GriColors.forestPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  [
                                    p.group,
                                    if (p.duration.isNotEmpty) p.duration,
                                    if (unit != null) unit.name,
                                  ].join(' • '),
                                  style: TextStyle(
                                    fontSize: 11,
                                    height: 1.35,
                                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      p.syllabi.isEmpty
                                          ? 'Syllabus on department page'
                                          : '${p.syllabi.length} official syllabus version${p.syllabi.length == 1 ? '' : 's'}',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 10, color: GriColors.ochrePrimary),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCentres(BuildContext context, bool isDark, List<OfficialUnit> centres) {
    final catalog = OfficialCatalogService.instance;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _banner(context, isDark,
            'Research centres and the DDU-Kaushal Kendra listed on the official department pages.'),
        const SizedBox(height: 12),
        ...centres.map((u) {
          final heads = catalog.faculty.where(
            (f) => f.affiliations.any((a) => a.unitId == u.id && (a.role == 'hod' || a.role == 'dean')),
          );
          return GriPressable(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DepartmentDetailScreen(
                departmentId: u.id,
                departmentName: u.name,
                schoolName: catalog.schoolById(u.schoolId)?.name ?? 'GRI',
                hodName: heads.isNotEmpty ? heads.first.name : '',
                sourceUrl: u.url,
              ),
            )),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
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
                  Text(
                    u.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    heads.isNotEmpty ? 'Head / Director: ${heads.first.name}' : 'Head / Director as published by GRI',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                      color: isDark ? GriColors.darkOnSurface : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    u.profile.isNotEmpty ? u.profile : u.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRegulations(BuildContext context, bool isDark) {
    final catalog = OfficialCatalogService.instance;
    final docs = catalog.documents
        .where((d) => d.valid && ['regulation', 'student-corner', 'official-document'].contains(d.category))
        .take(40)
        .toList();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _banner(context, isDark,
            'CBCS and academic regulations are published by the university. Open the official document for the current rules.'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choice Based Credit System (CBCS)',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: GriColors.forestPrimary),
              ),
              const SizedBox(height: 5),
              Text(
                'GRI follows the UGC Choice Based Credit System. The official regulations PDF below is the authoritative source for credits, assessment and attendance.',
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _open('https://www.ruraluniv.ac.in/page/academics'),
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text('Official Academics page'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...docs.map((d) => Container(
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
                dense: true,
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                title: Text(
                  d.title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${d.authority} • ${d.sizeLabel}',
                  style: const TextStyle(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.open_in_new, size: 14),
                onTap: () => _open(d.url),
              ),
            )),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdmissionsProspectusScreen()),
          ),
          icon: const Icon(Icons.school_outlined, size: 16),
          label: const Text('Prospectus & admissions'),
        ),
      ],
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _programmeFilter == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
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
          color: isSelected ? GriColors.forestPrimary : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
          width: 0.8,
        ),
        onSelected: (_) => setState(() => _programmeFilter = value),
      ),
    );
  }

  void _showProgrammeModal(
      BuildContext context, OfficialProgramme p, OfficialUnit? unit, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? GriColors.darkSurface1 : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    p.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    [p.group, if (p.approval.isNotEmpty) p.approval].join(' • '),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _detailRow('School / Department', unit?.name ?? p.group, isDark),
                  _detailRow('Duration', p.duration.isEmpty ? 'As published by GRI' : p.duration, isDark),
                  if (p.approval.isNotEmpty) _detailRow('Approval', p.approval, isDark),
                  if (p.eligibility.isNotEmpty) _detailRow('Eligibility', p.eligibility, isDark),
                  _detailRow(
                    'Official catalogue',
                    'https://www.ruraluniv.ac.in/page/academics',
                    isDark,
                  ),
                  if (p.syllabi.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Syllabus versions',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    const SizedBox(height: 6),
                    ...p.syllabi.map((s) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
                          title: Text(s.label, style: const TextStyle(fontSize: 12)),
                          trailing: const Icon(Icons.open_in_new, size: 13),
                          onTap: () => _open(s.url),
                        )),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            if (unit != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => DepartmentDetailScreen(
                                  departmentId: unit.id,
                                  departmentName: unit.name,
                                  schoolName: p.group,
                                  hodName: '',
                                  sourceUrl: unit.url,
                                ),
                              ));
                            }
                          },
                          icon: const Icon(Icons.menu_book, size: 16),
                          label: const Text('Department page'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const AdmissionsProspectusScreen(),
                            ));
                          },
                          icon: const Icon(Icons.school, size: 16),
                          label: const Text('Admissions'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isDark ? GriColors.darkOnSurface : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String asset, String name) {
    final clean = name.replaceAll(RegExp(r'[^A-Za-z ]'), '').trim();
    final parts = clean.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : (clean.isEmpty ? 'GRI' : clean.substring(0, clean.length >= 2 ? 2 : 1).toUpperCase());
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: GriColors.forestContainer,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: GriColors.forestPrimary.withValues(alpha: 0.25)),
      ),
      clipBehavior: Clip.antiAlias,
      child: asset.isNotEmpty
          ? Image.asset(asset, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                    child: Text(initials,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: GriColors.forestPrimary)),
                  ))
          : Center(
              child: Text(initials,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: GriColors.forestPrimary)),
            ),
    );
  }

  Widget _banner(BuildContext context, bool isDark, String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.18 : 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_outlined, size: 15, color: GriColors.forestPrimary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.35,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
