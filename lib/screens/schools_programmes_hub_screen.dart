import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

class SchoolsProgrammesHubScreen extends StatefulWidget {
  const SchoolsProgrammesHubScreen({super.key});

  @override
  State<SchoolsProgrammesHubScreen> createState() => _SchoolsProgrammesHubScreenState();
}

class _SchoolsProgrammesHubScreenState extends State<SchoolsProgrammesHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _programmeFilter = "all";

  final List<Map<String, dynamic>> _programmes = [
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
    final seed = SeedDataService.instance;
    final schools = seed.schools;

    final filteredProgs = _programmes.where((p) {
      if (_programmeFilter == "all") return true;
      return p["degree"].toString().toLowerCase() == _programmeFilter.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Schools & Academic Programmes"),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: GriColors.ochrePrimary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
            padding: const EdgeInsets.all(16),
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final sch = schools[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sch.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: GriColors.ochrePrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                            child: Text("${sch.programmesCount} Progs", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.ochrePrimary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text("Dean: ${sch.dean}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      Text("Email: ${sch.deanEmail} • Phone: ${sch.deanPhone}", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text("Key Highlights: ${sch.highlights}", style: const TextStyle(fontSize: 11.5, height: 1.3)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProgs.length,
                  itemBuilder: (context, index) {
                    final p = filteredProgs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(p["name"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: GriColors.forestPrimary.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
                                  child: Text(p["degree"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: GriColors.forestPrimary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text("School: ${p['school']} • Duration: ${p['duration']}", style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700)),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Intake: ${p['intake']} Seats", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                Text("Fee: ${p['fee']}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.ochrePrimary)),
                              ],
                            ),
                          ],
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
            padding: const EdgeInsets.all(16),
            itemCount: _centres.length,
            itemBuilder: (context, index) {
              final c = _centres[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c["name"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: GriColors.forestPrimary)),
                      const SizedBox(height: 4),
                      Text("Director / Head: ${c['director']}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5)),
                      const SizedBox(height: 6),
                      Text(c["mandate"] ?? "", style: const TextStyle(fontSize: 12, height: 1.35)),
                      const Divider(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 13, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(c["contact"] ?? "", style: TextStyle(fontSize: 11, color: Colors.grey.shade800)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 4. CBCS Academic Regulations
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: GriColors.forestContainer.withOpacity(0.5),
                child: const Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    "Choice Based Credit System (CBCS) Framework",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestOnContainer),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCbcsCard("Core Courses (CC)", "Compulsory discipline-specific papers covering foundational and advanced domain expertise. Accounting for ~60% of total credits."),
              _buildCbcsCard("Discipline Specific Electives (DSE)", "Advanced elective papers chosen by students from their respective department domain."),
              _buildCbcsCard("Generic Electives / Non-Major (GE)", "Interdisciplinary papers selected from other Schools (e.g., Computer Science student studying Rural Energy or Folk Arts)."),
              _buildCbcsCard("Nai Talim & Village Placement (VPP)", "Mandatory 2 credits field immersion where students stay in designated rural villages for participatory research."),
              _buildCbcsCard("Continuous Internal Assessment (CIA)", "40% weightage allocated across mid-semester tests, seminar presentations, assignments, and class attendance (>75% mandatory)."),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _programmeFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black87)),
        selectedColor: GriColors.forestPrimary,
        backgroundColor: Colors.grey.shade100,
        checkmarkColor: Colors.white,
        onSelected: (_) => setState(() => _programmeFilter = value),
      ),
    );
  }

  Widget _buildCbcsCard(String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.forestPrimary)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(fontSize: 12, height: 1.3)),
          ],
        ),
      ),
    );
  }
}
