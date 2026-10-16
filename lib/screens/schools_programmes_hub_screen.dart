import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/official_resource_registry.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import 'admissions_prospectus_screen.dart';
import 'department_detail_screen.dart';

/// Production-Grade Schools & Academic Programmes Screen
/// Covers the 8 statutory schools, degree browser with filters, specialized research centres, and CBCS framework.
class SchoolsProgrammesHubScreen extends StatefulWidget {
  const SchoolsProgrammesHubScreen({super.key});

  @override
  State<SchoolsProgrammesHubScreen> createState() => _SchoolsProgrammesHubScreenState();
}

class _SchoolsProgrammesHubScreenState extends State<SchoolsProgrammesHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _programmeFilter = "all";

  final List<Map<String, dynamic>> _baseProgrammes = [
    {"name": "B.Sc. (Hons.) Agriculture", "degree": "UG", "school": "Agriculture", "duration": "4 Years (8 Sem)", "intake": 60, "fee": "Rs. 24,500/Sem"},
    {"name": "M.Sc. Data Analytics", "degree": "PG", "school": "Computer Science", "duration": "2 Years (4 Sem)", "intake": 30, "fee": "Rs. 18,200/Sem"},
    {"name": "Master of Computer Applications (MCA)", "degree": "PG", "school": "Computer Science", "duration": "2 Years (4 Sem)", "intake": 60, "fee": "Rs. 19,500/Sem"},
    {"name": "MBA (Rural Management)", "degree": "PG", "school": "Management", "duration": "2 Years (4 Sem)", "intake": 60, "fee": "Rs. 22,000/Sem"},
    {"name": "M.Sc. Chemistry", "degree": "PG", "school": "Sciences", "duration": "2 Years (4 Sem)", "intake": 35, "fee": "Rs. 14,000/Sem"},
    {"name": "M.Sc. Physics", "degree": "PG", "school": "Sciences", "duration": "2 Years (4 Sem)", "intake": 35, "fee": "Rs. 14,000/Sem"},
    {"name": "M.Sc. Mathematics", "degree": "PG", "school": "Sciences", "duration": "2 Years (4 Sem)", "intake": 40, "fee": "Rs. 11,500/Sem"},
    {"name": "B.Voc. Renewable Energy", "degree": "B.Voc", "school": "Computer Science", "duration": "3 Years (6 Sem)", "intake": 50, "fee": "Rs. 8,500/Sem"},
    {"name": "B.Voc. Farm Machinery & Processing", "degree": "B.Voc", "school": "Agriculture", "duration": "3 Years (6 Sem)", "intake": 50, "fee": "Rs. 8,500/Sem"},
    {"name": "Diploma in Sanitary Inspector", "degree": "Diploma", "school": "Rural Health", "duration": "1 Year (2 Sem)", "intake": 60, "fee": "Rs. 12,000/Sem"},
    {"name": "Ph.D. in Rural Development", "degree": "Doctoral", "school": "Social Sciences", "duration": "3-5 Years", "intake": 15, "fee": "Rs. 15,000/Yr"},
    {"name": "Ph.D. in Computer Science", "degree": "Doctoral", "school": "Computer Science", "duration": "3-5 Years", "intake": 12, "fee": "Rs. 16,000/Yr"},
  ];

  List<Map<String, dynamic>> _getAllProgrammes(SeedDataService seed) {
    final list = <Map<String, dynamic>>[];
    if (seed.programmes.isNotEmpty) {
      for (final p in seed.programmes) {
        final dept = seed.getDepartmentById(p.departmentId);
        final schoolName = dept != null && dept.schoolId.isNotEmpty
            ? dept.schoolId.replaceAll('sch_', '').toUpperCase()
            : "GRI Academic";
        list.add({
          "name": p.name,
          "degree": p.degree.isNotEmpty ? p.degree : (p.name.startsWith("B.") ? "UG" : (p.name.startsWith("M.") ? "PG" : "General")),
          "school": schoolName,
          "duration": p.duration.isNotEmpty ? p.duration : "2-4 Years",
          "intake": p.intake > 0 ? p.intake : 40,
          "fee": p.feePerSemester.isNotEmpty ? "Rs. ${p.feePerSemester}/Sem" : "As per UGC Norms",
        });
      }
    }
    // Also merge base programmes ensuring no duplicate names
    for (final base in _baseProgrammes) {
      if (!list.any((item) => item["name"].toString().toLowerCase() == base["name"].toString().toLowerCase())) {
        list.add(base);
      }
    }
    return list;
  }

  final List<Map<String, String>> _centres = [
    {
      "name": "Centre for Women's Studies",
      "director": "Dr. P. Baby",
      "mandate": "UGC-sponsored centre promoting gender equality, rural women micro-enterprises, legal literacy, and SHG capacity building.",
      "contact": "womensstudies@ruraluniv.ac.in",
    },
    {
      "name": "Centre for Geoinformatics",
      "director": "Dr. R. Balasubramani",
      "mandate": "NRDMS & ISRO supported centre offering spatial analysis, GIS watershed modeling, natural hazard mapping, and drone cartography.",
      "contact": "geoinformatics@ruraluniv.ac.in",
    },
    {
      "name": "Centre for Social Exclusion and Inclusive Policy (CSEIP)",
      "director": "Dr. S. Rajendran",
      "mandate": "Conducts affirmative policy research on tribal livelihoods, marginalized rural demographics, and social welfare programmes.",
      "contact": "cseip@ruraluniv.ac.in",
    },
    {
      "name": "Rural Energy Centre",
      "director": "Dr. L. Veeranjaneyulu",
      "mandate": "MNRE recognized testing unit for Biomass Gasifiers, solar photovoltaic pumps, and rural decentralized energy systems.",
      "contact": "energy@ruraluniv.ac.in",
    },
    {
      "name": "Krishi Vigyan Kendra (ICAR - KVK Dindigul)",
      "director": "Senior Scientist & Head, KVK",
      "mandate": "ICAR Farm Science Centre offering on-farm testing, frontline demonstrations, farmer trainings, seed multiplication, and organic dairy farm.",
      "contact": "kvkdindigul@ruraluniv.ac.in",
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final seed = SeedDataService.instance;
    final schools = seed.schools;

    final allProgs = _getAllProgrammes(seed);
    final filteredProgs = allProgs.where((p) {
      if (_programmeFilter == "all") return true;
      final deg = (p["degree"] ?? "").toString().toLowerCase();
      final filt = _programmeFilter.toLowerCase();
      return deg == filt || deg.contains(filt) || filt.contains(deg);
    }).toList();

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
            Tab(text: "8 Schools of Study"),
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
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final sch = schools[index];
              return GriPressable(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DepartmentDetailScreen(
                        departmentId: sch.id,
                        departmentName: sch.name,
                        schoolName: sch.name,
                        hodName: sch.dean,
                        email: sch.deanEmail,
                        phone: sch.deanPhone,
                        sourceUrl: "https://ruraluniv.ac.in/academics?content=faculties",
                      ),
                    ),
                  );
                },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sch.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${sch.programmesCount} Progs",
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: GriColors.ochrePrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Dean: ${sch.dean}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: isDark ? GriColors.darkOnSurface : Colors.black87,
                        ),
                      ),
                      Text(
                        "Email: ${sch.deanEmail} • Phone: ${sch.deanPhone}",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Key Highlights: ${sch.highlights}",
                          style: TextStyle(
                            fontSize: 11.5,
                            height: 1.35,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "View School Departments & Labs",
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
            },
          ),

          // 2. Programmes Offered Browser
          Column(
            children: [
              // Degree Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    _filterChip("All", "all"),
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
                  itemCount: filteredProgs.length,
                  itemBuilder: (context, index) {
                    final p = filteredProgs[index];
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
                          onTap: () => _showProgrammeModal(context, p, isDark),
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
                                        p["name"] as String,
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
                                        p["degree"] as String,
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
                                  "School: ${p['school']} • Duration: ${p['duration']}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Intake: ${p['intake']} Seats",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Fee: ${p['fee']}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: GriColors.ochrePrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_forward_ios, size: 10, color: GriColors.ochrePrimary),
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
          ),

          // 3. Specialized Centres & Extension
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: _centres.length,
            itemBuilder: (context, index) {
              final c = _centres[index];
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
                      "Director / Head: ${c['director']}",
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
                          child: InkWell(
                            onTap: () async {
                              final email = c["contact"] ?? "";
                              if (email.isNotEmpty) {
                                final uri = Uri.parse("mailto:$email");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  await Clipboard.setData(ClipboardData(text: email));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Email copied: $email")),
                                    );
                                  }
                                }
                              }
                            },
                            child: Text(
                              c["contact"] ?? "",
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: GriColors.forestPrimary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 14, color: GriColors.forestPrimary),
                          tooltip: "Copy Email",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          onPressed: () async {
                            final email = c["contact"] ?? "";
                            await Clipboard.setData(ClipboardData(text: email));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Email copied: $email")),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // 4. CBCS Academic Regulations
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: GriColors.forestPrimary.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
                child: const Text(
                  "Choice Based Credit System (CBCS) Framework",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: GriColors.forestPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCbcsCard(context, "Core Courses (CC)", "Compulsory discipline-specific papers covering foundational and advanced domain expertise. Accounting for ~60% of total credits."),
              _buildCbcsCard(context, "Discipline Specific Electives (DSE)", "Advanced elective papers chosen by students from their respective department domain."),
              _buildCbcsCard(context, "Generic Electives / Non-Major (GE)", "Interdisciplinary papers selected from other Schools (e.g., Computer Science student studying Rural Energy or Folk Arts)."),
              _buildCbcsCard(context, "Nai Talim & Village Placement (VPP)", "Mandatory 2 credits field immersion where students stay in designated rural villages for participatory research."),
              _buildCbcsCard(context, "Continuous Internal Assessment (CIA)", "40% weightage allocated across mid-semester tests, seminar presentations, assignments, and class attendance (>75% mandatory)."),
            ],
          ),
        ],
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
          color: isSelected ? GriColors.forestPrimary : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
          width: 0.8,
        ),
        onSelected: (_) => setState(() => _programmeFilter = value),
      ),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showCbcsModal(context, title, desc, isDark),
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
                    const Icon(Icons.info_outline, size: 14, color: GriColors.forestPrimary),
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
        ),
      ),
    );
  }

  void _showProgrammeModal(BuildContext context, Map<String, dynamic> p, bool isDark) {
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
                      p["name"] as String,
                      style: TextStyle(
                        fontSize: 16,
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
                      p["degree"] as String,
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
              _buildModalDetailRow("Statutory School", p["school"]?.toString() ?? "GRI Academic School", isDark),
              _buildModalDetailRow("Duration / Semesters", p["duration"]?.toString() ?? "2-4 Semesters", isDark),
              _buildModalDetailRow("Approved Intake", "${p['intake']} Seats (with reservation norms)", isDark),
              _buildModalDetailRow("Semester Tuition Fee", p["fee"]?.toString() ?? "As per UGC Regulations", isDark),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        OfficialResourceRegistry.smartOpenDocument(
                          context,
                          "cbcs_curriculum",
                          title: "${p['name']} Syllabus",
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
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showCbcsModal(BuildContext context, String title, String desc, bool isDark) {
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
                children: [
                  const Icon(Icons.verified_outlined, color: GriColors.forestPrimary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              _buildModalDetailRow("Academic Framework", "UGC Choice Based Credit System (CBCS)", isDark),
              _buildModalDetailRow("Minimum Attendance", "75% Mandatory for End Semester Exams", isDark),
              _buildModalDetailRow("Internal Weightage", "40% CIA + 60% End-Semester Examination", isDark),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    OfficialResourceRegistry.smartOpenDocument(
                      context,
                      "cbcs_curriculum",
                      title: "UGC CBCS Regulations",
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf, size: 16),
                  label: const Text("Open UGC CBCS Regulations Document"),
                  style: FilledButton.styleFrom(
                    backgroundColor: GriColors.forestPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
