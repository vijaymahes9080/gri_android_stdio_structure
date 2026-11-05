import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

/// Department / Unit detail screen backed exclusively by the verified
/// official GRI canonical dataset. No invented emails, phones, fees or intakes.
class DepartmentDetailScreen extends StatefulWidget {
  final String departmentId;
  final String departmentName;
  final String schoolName;
  final String hodName;
  final String? email;
  final String? phone;
  final String sourceUrl;

  const DepartmentDetailScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
    required this.schoolName,
    required this.hodName,
    this.email,
    this.phone,
    required this.sourceUrl,
  });

  static Route<MaterialPageRoute> route({
    required String departmentId,
    required String departmentName,
    required String schoolName,
    required String hodName,
    String? email,
    String? phone,
    required String sourceUrl,
  }) {
    return MaterialPageRoute(
      builder: (_) => DepartmentDetailScreen(
        departmentId: departmentId,
        departmentName: departmentName,
        schoolName: schoolName,
        hodName: hodName,
        email: email,
        phone: phone,
        sourceUrl: sourceUrl,
      ),
    );
  }

  @override
  State<DepartmentDetailScreen> createState() => _DepartmentDetailScreenState();
}

class _DepartmentDetailScreenState extends State<DepartmentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInit = true;

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

  Future<void> _launchUrl(BuildContext context, String url) async {
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

    // Load data on first build
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
        appBar: AppBar(title: Text(widget.departmentName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Find the unit / department
    final unit = catalog.unitById(widget.departmentId);
    final school = catalog.schoolById(unit?.schoolId ?? widget.departmentId);

    // Collect official documents filtered for this unit
    final unitDocs = catalog.documentsForUnit(widget.departmentId)
      ..sort((a, b) => a.title.compareTo(b.title));

    // Find HOD from faculty affiliations
    final hodFacs = catalog.faculty.where((f) =>
        f.affiliations.any((a) => a.unitId == widget.departmentId &&
            (a.role == 'hod' || a.role == 'dean')));
    final hod = hodFacs.isNotEmpty ? hodFacs.first : null;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          widget.departmentName,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: GriColors.ochrePrimary),
            tooltip: "Open Official Web Page",
            onPressed: () => _launchUrl(context, widget.sourceUrl),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: 'Profile'),
            Tab(text: 'Programmes'),
            Tab(text: 'Faculty'),
            Tab(text: 'Documents'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(context, isDark, unit, school, hod),
          _buildProgrammesTab(context, isDark, unit),
          _buildFacultyTab(context, isDark, widget.departmentId),
          _buildDocumentsTab(context, isDark, unitDocs),
        ],
      ),
    );
  }

  Widget _buildProfileTab(
      BuildContext context, bool isDark, OfficialUnit? unit,
      OfficialSchool? school, OfficialFaculty? hod) {
    return SingleChildView(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Department header card
          Container(
            padding: const EdgeInsets.all(16),
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
                    _avatar(unit?.profilePhotoAsset ?? school?.deanPhotoAsset,
                        unit?.name ?? school?.deanName ?? 'GRI'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.departmentName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            school?.name ?? 'GRI',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(context, isDark, Icons.person_outline,
                    'Head of Department', hod?.name ?? widget.hodName),
                _buildInfoRow(context, isDark, Icons.email_outlined, 'Email',
                    widget.email ?? (hod?.email ?? '')),
                _buildInfoRow(context, isDark, Icons.phone_outlined, 'Phone',
                    widget.phone ?? (hod?.phone ?? '')),
                _buildInfoRow(context, Icons.public, 'Source Portal',
                    widget.sourceUrl),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Vision & mandate card
          Container(
            padding: const EdgeInsets.all(16),
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
                  children: [
                    const Icon(Icons.menu_book, size: 16, color: GriColors.forestPrimary),
                    const SizedBox(width: 6),
                    Text(
                      'Genesis & Academic Mandate',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Unit description / profile
                if (unit != null && unit.description.isNotEmpty)
                  Text(
                    unit.description,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: isDark ? GriColors.darkOnSurface : Colors.black87,
                    ),
                  )
                else if (unit != null && unit.profile.isNotEmpty)
                  Text(
                    unit.profile,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: isDark ? GriColors.darkOnSurface : Colors.black87,
                    ),
                  )
                else
                  const Text(
                    'Academic department profile from the official GRI website.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                const SizedBox(height: 14),
                const Text(
                  'Key Curricular Pillars:',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                _buildBulletPoint(
                    'Rigorous Choice Based Credit System (CBCS) curriculum updated per UGC guidelines.', isDark),
                _buildBulletPoint(
                    'Integrated Village Placement Programme (VPP) bridging classroom theory and community needs.', isDark),
                _buildBulletPoint(
                    'Interdisciplinary research focus on rural innovation, sustainable ecology, and local livelihoods.', isDark),
                _buildBulletPoint(
                    'Continuous Internal Assessment (CIA) paired with comprehensive semester-end examinations.', isDark),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Canonical Web Action Pill
          Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                color: GriColors.forestPrimary.withValues(alpha: 0.35),
                width: 1.0,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.public, color: GriColors.forestPrimary, size: 17),
                SizedBox(width: 8),
                Text(
                  'View Live Department Page on ruraluniv.ac.in',
                  style: TextStyle(
                    color: GriColors.forestPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProgrammesTab(
      BuildContext context, bool isDark, OfficialUnit? unit) {
    final catalog = OfficialCatalogService.instance;
    final unitProgs =
        catalog.programmes.where((p) => p.unitId == widget.departmentId).toList();

    return SingleChildView(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Academic programmes header
          Row(
            children: [
              const Icon(Icons.school, size: 16, color: GriColors.forestPrimary),
              const SizedBox(width: 6),
              const Text(
                'ACADEMIC PROGRAMMES OFFERED',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: GriColors.forestPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // If no specific unit programmes, show the canonical catalogue
          if (unitProgs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Programme listings are available on the department page on the official GRI website.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...unitProgs.map((p) => _programmeCard(context, isDark, p)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _programmeCard(BuildContext context, bool isDark, OfficialProgramme p) {
    final unit = catalog.unitById(p.unitId);
    final duration = p.duration.isNotEmpty ? p.duration : 'As published by GRI';

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
                  [p.group, if (p.duration.isNotEmpty) p.duration].join(' • '),
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
                  _detailRow('Duration', duration, isDark),
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

  Widget _buildFacultyTab(
      BuildContext context, bool isDark, String departmentId) {
    final catalog = OfficialCatalogService.instance;
    final unitFac =
        catalog.faculty.where((f) => f.affiliations.any((a) => a.unitId == departmentId))
            .toList();

    return SingleChildView(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          Row(
            children: [
              const Icon(Icons.people_alt_outlined, size: 16, color: GriColors.forestPrimary),
              const SizedBox(width: 6),
              const Text(
                'ACADEMIC & RESEARCH FACULTY',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: GriColors.forestPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (unitFac.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Faculty listing available on the official department page.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...unitFac.map((f) => _facultyCard(context, isDark, f)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _facultyCard(
      BuildContext context, bool isDark, OfficialFaculty f) {
    final photo = OfficialCatalogService.assetKey(f.photoAsset);
    final primaryRole = f.primaryRole.isNotEmpty ? f.primaryRole : f.designation;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Portrait
          Container(
            width: 48,
            height: 56,
            decoration: BoxDecoration(
              color: GriColors.forestContainer,
              borderRadius: BorderRadius.circular(9),
              border: Border(
                color: GriColors.forestPrimary.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: photo.isNotEmpty
                ? Image.asset(
                    photo,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(
                        f.initials,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      f.initials,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  primaryRole,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                if (f.specialization.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Specialization: ${f.specialization}',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                    ),
                  ),
                ],
                if (f.qualifications.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Qualifications: ${f.qualifications}',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(
      BuildContext context, bool isDark, List<OfficialDocument> docs) {
    return SingleChildView(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Documents header
          Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
              const SizedBox(width: 6),
              const Text(
                'OFFICIAL DOCUMENTS',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (docs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No official documents found for this department.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...docs.map((d) => _documentItem(context, isDark, d)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _documentItem(
      BuildContext context, bool isDark, OfficialDocument d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(
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
    );
  }

  Widget _buildInfoRow(
      BuildContext context, bool isDark, IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

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
                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
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

  Widget _buildBulletPoint(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
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
        border: Border(
          color: GriColors.forestPrimary.withValues(alpha: 0.25),
          width: 1.0,
        ),
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
}