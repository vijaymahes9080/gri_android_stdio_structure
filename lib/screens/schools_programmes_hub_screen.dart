import 'package:flutter/material.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../services/official_resource_registry.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import 'admissions_prospectus_screen.dart';
import 'department_detail_screen.dart';

/// Production-Grade Schools & Academic Programmes Screen
/// Covers the 9 statutory schools of study, 33 departments, 68+ CBCS degree programmes,
/// specialized research centres, and official academic regulations.
class SchoolsProgrammesHubScreen extends StatefulWidget {
  const SchoolsProgrammesHubScreen({super.key});

  @override
  State<SchoolsProgrammesHubScreen> createState() => _SchoolsProgrammesHubScreenState();
}

class _SchoolsProgrammesHubScreenState extends State<SchoolsProgrammesHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _programmeFilter = "all";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

  String _clean(String text) {
    return text.replaceAll(RegExp(r'\s*↗'), '').trim();
  }

  List<OfficialProgramme> _getFilteredProgrammes(List<OfficialProgramme> all) {
    if (_programmeFilter == "all") return all;
    final filt = _programmeFilter.toLowerCase();
    return all.where((p) {
      final lvl = p.level.toLowerCase();
      final grp = p.group.toLowerCase();
      final deg = p.degree.toLowerCase();
      return lvl == filt ||
          grp.contains(filt) ||
          deg.contains(filt) ||
          (filt == 'b.voc' && (deg.contains('b.voc') || deg.contains('vocational')));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catalog = OfficialCatalogService.instance;
    final schools = catalog.schools.isNotEmpty ? catalog.schools : null;
    final seedSchools = SeedDataService.instance.schools;
    final programmes = catalog.programmes;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Schools & Academic Programmes",
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
          tabs: const [
            Tab(text: "Schools of Study"),
            Tab(text: "Programmes Offered"),
            Tab(text: "Specialized Centres"),
            Tab(text: "CBCS Regulations"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Schools of Study
          schools != null
              ? _buildOfficialSchoolsList(context, isDark, schools, catalog)
              : _buildLegacySchoolsList(context, isDark, seedSchools),

          // 2. Programmes Offered Browser
          programmes.isNotEmpty
              ? _buildOfficialProgrammesBrowser(context, isDark, programmes, catalog)
              : _buildLegacyProgrammesBrowser(context, isDark),

          // 3. Specialized Centres & Extension
          _buildCentresTab(context, isDark, catalog),

          // 4. CBCS Academic Regulations
          _buildCbcsTab(context, isDark),
        ],
      ),
    );
  }

  Widget _buildOfficialSchoolsList(
    BuildContext context,
    bool isDark,
    List<OfficialSchool> schools,
    OfficialCatalogService catalog,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: schools.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildBanner(
            context,
            isDark,
            title: "STATUTORY SCHOOLS OF STUDY",
            subtitle:
                "9 Academic Schools of Study and KAUSHAL Kendra comprising 33 specialized teaching departments and research centres.",
            badge: "${schools.length} Schools of Study",
          );
        }

        final sch = schools[index - 1];
        final cleanDean = _clean(sch.deanName);
        final cleanDesig = _clean(sch.deanDesignation);
        final depts = catalog.unitsForSchool(sch.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? GriColors.darkSurface1 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
              width: 1.0,
            ),
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
              GriPressable(
                onTap: () {
                  final primaryUnit = depts.isNotEmpty ? depts.first : null;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DepartmentDetailScreen(
                        departmentId: primaryUnit?.id ?? sch.id,
                        departmentName: sch.name,
                        schoolName: sch.name,
                        hodName: cleanDean.isNotEmpty ? cleanDean : "Dean of School",
                        email: "grucc@ruraluniv.ac.in",
                        phone: "0451-2452371",
                        sourceUrl: sch.sourceUrls.isNotEmpty
                            ? sch.sourceUrls.first
                            : "https://ruraluniv.ac.in/page/academics",
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (sch.deanPhotoAsset.isNotEmpty) ...[
                            _buildAvatar(sch.deanPhotoAsset, cleanDean, size: 48),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sch.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                                  ),
                                ),
                                if (cleanDean.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    "Dean: $cleanDean",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                    ),
                                  ),
                                  if (cleanDesig.isNotEmpty)
                                    Text(
                                      cleanDesig,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: isDark
                                            ? GriColors.darkOnSurfaceVariant
                                            : GriColors.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${sch.programmeCount} Progs",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: GriColors.ochrePrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (depts.isNotEmpty) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Teaching Departments & Units (${depts.length}):",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: depts.map((d) {
                          final fCount = catalog.facultyForUnit(d.id).length;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DepartmentDetailScreen(
                                    departmentId: d.id,
                                    departmentName: d.name,
                                    schoolName: sch.name,
                                    hodName: cleanDean,
                                    email: "grucc@ruraluniv.ac.in",
                                    phone: "0451-2452371",
                                    sourceUrl: d.url,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? GriColors.darkSurface2
                                    : GriColors.surfaceVariant.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isDark
                                      ? GriColors.darkOutlineVariant
                                      : GriColors.outlineVariant,
                                  width: 0.7,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    d.name,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                                    ),
                                  ),
                                  if (fCount > 0) ...[
                                    const SizedBox(width: 4),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: GriColors.forestPrimary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "$fCount",
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: GriColors.forestPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(width: 3),
                                  const Icon(Icons.arrow_forward,
                                      size: 10, color: GriColors.forestPrimary),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfficialProgrammesBrowser(
    BuildContext context,
    bool isDark,
    List<OfficialProgramme> allProgs,
    OfficialCatalogService catalog,
  ) {
    final filtered = _getFilteredProgrammes(allProgs);

    return Column(
      children: [
        // Degree Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _filterChip("All (${allProgs.length})", "all"),
              _filterChip("UG", "UG"),
              _filterChip("PG", "PG"),
              _filterChip("B.Voc.", "B.Voc"),
              _filterChip("Diploma", "Diploma"),
              _filterChip("Doctoral / Ph.D.", "Doctoral"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final p = filtered[index];
              final unit = catalog.unitById(p.unitId);
              final school = unit != null ? catalog.schoolById(unit.schoolId) : null;
              final offeringDept = unit?.name ?? p.group;

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
                    onTap: () => _showOfficialProgrammeModal(context, p, unit, school, isDark),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: GriColors.forestPrimary
                                      .withValues(alpha: isDark ? 0.25 : 0.08),
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
                            "$offeringDept • ${p.duration.isNotEmpty ? p.duration : 'Semester Mode'}",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? GriColors.darkOnSurfaceVariant
                                  : GriColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                p.approval.isNotEmpty ? p.approval : "UGC Approved",
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  if (p.syllabi.isNotEmpty) ...[
                                    const Icon(Icons.picture_as_pdf,
                                        size: 11, color: GriColors.ochrePrimary),
                                    const SizedBox(width: 3),
                                    Text(
                                      "${p.syllabi.length} Syllabi",
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: GriColors.ochrePrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 10, color: GriColors.ochrePrimary),
                                ],
                              ),
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

  void _showOfficialProgrammeModal(
    BuildContext context,
    OfficialProgramme p,
    OfficialUnit? unit,
    OfficialSchool? school,
    bool isDark,
  ) {
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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      p.displayName,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p.level,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: GriColors.forestPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildModalRow("Department / Unit", unit?.name ?? p.group, isDark),
              if (school != null) _buildModalRow("School of Study", school.name, isDark),
              if (p.duration.isNotEmpty) _buildModalRow("Duration / Mode", p.duration, isDark),
              if (p.approval.isNotEmpty) _buildModalRow("Approval Status", p.approval, isDark),
              if (p.eligibility.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  "Eligibility Criteria:",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p.eligibility,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
              ],
              if (p.syllabi.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  "Available CBCS Syllabi (${p.syllabi.length}):",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: p.syllabi.map((s) {
                    return ActionChip(
                      avatar: const Icon(Icons.picture_as_pdf, size: 14, color: Colors.red),
                      label: Text(s.label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        OfficialResourceRegistry.smartOpenDocument(
                          context,
                          s.url,
                          title: "${p.displayName} - ${s.label}",
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        OfficialResourceRegistry.smartOpenDocument(
                          context,
                          p.officialUrl.isNotEmpty ? p.officialUrl : "cbcs_curriculum",
                          title: "${p.displayName} Regulations",
                        );
                      },
                      icon: const Icon(Icons.menu_book, size: 16),
                      label: const Text("View Syllabus"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GriColors.forestPrimary,
                        side: const BorderSide(color: GriColors.forestPrimary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AdmissionsProspectusScreen()),
                        );
                      },
                      icon: const Icon(Icons.school, size: 16),
                      label: const Text("Admissions"),
                      style: FilledButton.styleFrom(
                        backgroundColor: GriColors.forestPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
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

  Widget _buildCentresTab(
    BuildContext context,
    bool isDark,
    OfficialCatalogService catalog,
  ) {
    final centres = [
      {
        "name": "Centre for Rural Technology",
        "director": "Coordinator, CRT",
        "mandate":
            "Applied rural technology incubation, low-cost civil materials, biomass systems, and community micro-machinery.",
        "contact": "crt@ruraluniv.ac.in",
        "unit_id": "centre-for-rural-technology",
      },
      {
        "name": "Centre for Rural Energy",
        "director": "Coordinator, CRE",
        "mandate":
            "MNRE testing unit for Biomass gasifiers, Solar PV pumps, biogas digesters, and rural decentralized clean energy grids.",
        "contact": "energy@ruraluniv.ac.in",
        "unit_id": "centre-for-rural-energy",
      },
      {
        "name": "Centre for Geoinformatics",
        "director": "Director, Geoinformatics",
        "mandate":
            "NRDMS & ISRO supported spatial analysis, GIS watershed modeling, natural hazard cartography, and remote sensing.",
        "contact": "geoinformatics@ruraluniv.ac.in",
        "unit_id": "centre-for-geoinformatics",
      },
      {
        "name": "Centre for Applied Geology",
        "director": "Director, Applied Geology",
        "mandate":
            "Hydrogeology, groundwater exploration, village geophysical surveys, and mineral studies.",
        "contact": "geology@ruraluniv.ac.in",
        "unit_id": "centre-for-applied-geology",
      },
      {
        "name": "Centre for Women's Studies",
        "director": "Director, CWS",
        "mandate":
            "UGC-sponsored centre promoting gender equality, rural women micro-enterprises, legal literacy, and SHG capacity building.",
        "contact": "womensstudies@ruraluniv.ac.in",
        "unit_id": "",
      },
      {
        "name": "Centre for Social Exclusion and Inclusive Policy (CSEIP)",
        "director": "Director, CSEIP",
        "mandate":
            "Conducts affirmative policy research on tribal livelihoods, marginalized rural demographics, and social welfare programmes.",
        "contact": "cseip@ruraluniv.ac.in",
        "unit_id": "",
      },
      {
        "name": "Krishi Vigyan Kendra (ICAR - KVK Dindigul)",
        "director": "Senior Scientist & Head, KVK",
        "mandate":
            "ICAR Farm Science Centre offering on-farm testing, frontline demonstrations, farmer trainings, seed multiplication, and organic dairy farm.",
        "contact": "kvkdindigul@ruraluniv.ac.in",
        "unit_id": "",
      },
      {
        "name": "Physical Education and Yoga Centre",
        "director": "Director, Sports & Yoga",
        "mandate":
            "Holistic health, indigenous sports, university gymnasiums, and state-of-the-art yoga therapy centre.",
        "contact": "sports@ruraluniv.ac.in",
        "unit_id": "physical-education-and-yoga-centre",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: centres.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildBanner(
            context,
            isDark,
            title: "SPECIALIZED RESEARCH & EXTENSION CENTRES",
            subtitle:
                "Interdisciplinary institutions operating under national mandates (ICAR, MNRE, ISRO, UGC) dedicated to rural transformation.",
            badge: "${centres.length} Apex Centres",
          );
        }

        final c = centres[index - 1];
        final unitId = c["unit_id"] ?? "";

        return Container(
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
                c["name"] ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Director / Coordinator: ${c['director']}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.5,
                  color: isDark ? GriColors.darkOnSurface : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                c["mandate"] ?? "",
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.35,
                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 14, color: GriColors.forestPrimary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      c["contact"] ?? "",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: GriColors.forestPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (unitId.isNotEmpty)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        final u = catalog.unitById(unitId);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DepartmentDetailScreen(
                              departmentId: unitId,
                              departmentName: c["name"]!,
                              schoolName: "Specialized Centre",
                              hodName: c["director"]!,
                              email: c["contact"]!,
                              phone: "0451-2452371",
                              sourceUrl: u?.url ?? "https://ruraluniv.ac.in",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward, size: 12, color: GriColors.forestPrimary),
                      label: const Text(
                        "Details",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCbcsTab(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _buildBanner(
          context,
          isDark,
          title: "CHOICE BASED CREDIT SYSTEM (CBCS)",
          subtitle:
              "Academic regulations governing credit architecture, grading, village placement, and continuous assessments.",
          badge: "Curriculum Framework",
        ),
        _buildCbcsCard(
          context,
          "Core Courses (CC)",
          "Compulsory discipline-specific papers covering foundational and advanced domain expertise. Accounting for ~60% of total credits across UG and PG degrees.",
        ),
        _buildCbcsCard(
          context,
          "Discipline Specific Electives (DSE)",
          "Advanced elective papers chosen by students from their respective department domain to build deep specialization in research or industry applications.",
        ),
        _buildCbcsCard(
          context,
          "Generic Electives / Non-Major (GE)",
          "Interdisciplinary papers selected from other Schools (e.g., Computer Science student studying Rural Energy, Organic Agriculture, or Folk Arts).",
        ),
        _buildCbcsCard(
          context,
          "Nai Talim & Village Placement (VPP)",
          "Mandatory 2 credits field immersion where students stay in designated rural villages for participatory research, community mobilization, and village surveys.",
        ),
        _buildCbcsCard(
          context,
          "Continuous Internal Assessment (CIA)",
          "40% weightage allocated across mid-semester tests, seminar presentations, assignments, and class attendance (>75% mandatory to appear for ESE).",
        ),
        const SizedBox(height: 8),
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: GriColors.forestPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              OfficialResourceRegistry.smartOpenDocument(
                context,
                "DOC_CBCS_REGULATIONS",
                title: "GRI CBCS Academic Regulations Handbook",
              );
            },
            icon: const Icon(Icons.picture_as_pdf, size: 18),
            label: const Text(
              "Download CBCS Regulations PDF",
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCbcsCard(BuildContext context, String title, String desc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.check_circle_outline, size: 15, color: GriColors.forestPrimary),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              desc,
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
  }

  Widget _buildLegacySchoolsList(
      BuildContext context, bool isDark, List<SchoolItem> schools) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        final sch = schools[index];
        return Container(
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
                sch.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Dean: ${sch.dean}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.5,
                  color: isDark ? GriColors.darkOnSurface : Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegacyProgrammesBrowser(BuildContext context, bool isDark) {
    return const Center(
      child: Text("Loading academic programmes..."),
    );
  }

  Widget _buildAvatar(String assetPath, String name, {double size = 46}) {
    final clean = _clean(name);
    final initials = clean.isNotEmpty
        ? clean.split(' ').where((p) => p.isNotEmpty).take(2).map((p) => p[0]).join()
        : 'GRI';
    final resolved = OfficialCatalogService.assetKey(assetPath);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: GriColors.forestPrimary.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: ClipOval(
        child: resolved.isNotEmpty
            ? Image.asset(
                resolved,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackAvatar(initials, size),
              )
            : _fallbackAvatar(initials, size),
      ),
    );
  }

  Widget _fallbackAvatar(String text, double size) {
    return Container(
      width: size,
      height: size,
      color: GriColors.forestContainer,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.bold,
          color: GriColors.forestPrimary,
        ),
      ),
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
          color: isSelected
              ? GriColors.forestPrimary
              : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
          width: 0.8,
        ),
        onSelected: (_) => setState(() => _programmeFilter = value),
      ),
    );
  }

  Widget _buildBanner(
    BuildContext context,
    bool isDark, {
    required String title,
    required String subtitle,
    required String badge,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: GriColors.forestPrimary,
                  letterSpacing: 0.6,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: GriColors.forestPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
