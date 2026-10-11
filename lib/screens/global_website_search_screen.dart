import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';
import 'about_gri_heritage_screen.dart';
import 'governance_leadership_screen.dart';
import 'schools_programmes_hub_screen.dart';
import 'admissions_prospectus_screen.dart';
import 'examination_services_screen.dart';
import 'scholarships_welfare_screen.dart';
import 'contact_campus_info_screen.dart';
import 'campus_facilities_screen.dart';
import 'official_document_center_screen.dart';
import 'department_detail_screen.dart';
import 'institutional_article_screen.dart';
import 'document_vault_screen.dart';
import 'media_gallery_screen.dart';

class GlobalWebsiteSearchScreen extends StatefulWidget {
  const GlobalWebsiteSearchScreen({super.key});

  @override
  State<GlobalWebsiteSearchScreen> createState() => _GlobalWebsiteSearchScreenState();
}

class _GlobalWebsiteSearchScreenState extends State<GlobalWebsiteSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allPages = [];
  List<Map<String, dynamic>> _filteredPages = [];
  bool _isLoading = true;
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Academics",
    "Admissions",
    "Examinations",
    "Governance",
    "Heritage",
    "Research",
    "Facilities",
    "Student Welfare",
    "Disclosures",
  ];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/website_inventory.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final pagesList = data['pages'] as List<dynamic>? ?? [];
      
      setState(() {
        _allPages = pagesList.map((e) => e as Map<String, dynamic>).toList();
        _filteredPages = _allPages;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback if asset load fails
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFilterChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredPages = _allPages.where((page) {
        final title = (page['title'] ?? '').toString().toLowerCase();
        final cat = (page['category'] ?? '').toString().toLowerCase();
        final url = (page['url'] ?? '').toString().toLowerCase();

        final matchesQuery = query.isEmpty ||
            title.contains(query) ||
            cat.contains(query) ||
            url.contains(query);

        final matchesCat = _selectedCategory == "All" ||
            cat.contains(_selectedCategory.toLowerCase());

        return matchesQuery && matchesCat;
      }).toList();
    });
  }

  void _navigateToPage(Map<String, dynamic> page) {
    final url = (page['url'] ?? '').toString().toLowerCase();
    final cat = (page['category'] ?? '').toString().toLowerCase();
    final title = (page['title'] ?? 'GRI Official Portal').toString();

    if (url.contains('department=')) {
      final deptSlug = Uri.tryParse(url)?.queryParameters['department'] ?? 'Department';
      final cleanName = deptSlug.replaceAll('_programmes', '').replaceAll('_profile', '').replaceAll('_', ' ');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DepartmentDetailScreen(
            departmentId: deptSlug,
            departmentName: cleanName.toUpperCase(),
            schoolName: "School of $cleanName Studies",
            hodName: "Head of the Department",
            sourceUrl: page['url'] ?? 'https://ruraluniv.ac.in/',
          ),
        ),
      );
    } else if (url.contains('videotour') || url.contains('video')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MediaGalleryScreen()));
    } else if (url.contains('aboutgri') || url.contains('genesis') || url.contains('chancellor') || url.contains('emblem')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutGriHeritageScreen()));
    } else if (url.contains('governance') || url.contains('administration') || url.contains('council') || url.contains('deans') || url.contains('hod')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GovernanceLeadershipScreen()));
    } else if (url.contains('faculties') || url.contains('schools') || url.contains('cbcs')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SchoolsProgrammesHubScreen()));
    } else if (url.contains('admi') || url.contains('prospect') || url.contains('refund') || url.contains('hostel_fee')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdmissionsProspectusScreen()));
    } else if (url.contains('exam') || url.contains('coe') || url.contains('tatkal') || url.contains('esanad') || url.contains('timetable')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ExaminationServicesScreen()));
    } else if (url.contains('scholar') || url.contains('welfare') || url.contains('apaar') || url.contains('ragging')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ScholarshipsWelfareScreen()));
    } else if (url.contains('contact') || url.contains('reach') || url.contains('map')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactCampusInfoScreen()));
    } else if (url.contains('facilities') || url.contains('library') || url.contains('sports') || url.contains('hospital')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CampusFacilitiesScreen()));
    } else if (url.contains('nirf') || url.contains('naac') || url.contains('rti') || url.contains('iqac')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OfficialDocumentCenterScreen()));
    } else {
      // General Institutional Article Template
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InstitutionalArticleScreen(
            title: title,
            category: page['category'] ?? 'Institutional Information',
            sourceUrl: page['url'] ?? 'https://ruraluniv.ac.in/',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GRI Portal & Directory Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_shared, color: GriColors.ochrePrimary),
            tooltip: "Document Vault",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DocumentVaultScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: GriColors.forestPrimary.withOpacity(0.06),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onFilterChanged(),
              decoration: InputDecoration(
                hintText: "Search 247 official pages, courses, forms, policies...",
                prefixIcon: const Icon(Icons.search, color: GriColors.forestPrimary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onFilterChanged();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(cat, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: GriColors.forestPrimary.withOpacity(0.18),
                    checkmarkColor: GriColors.forestPrimary,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      _onFilterChanged();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Results Counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Found ${_filteredPages.length} official items",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Source: ruraluniv.ac.in",
                  style: TextStyle(fontSize: 11, color: GriColors.forestPrimary.withOpacity(0.8)),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Search Results List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 56, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text("No matching pages or documents found", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text("Try searching 'physics', 'prospectus', 'tatkal', or 'hostel'", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredPages.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final page = _filteredPages[index];
                          final title = page['title'] ?? 'The Gandhigram Rural Institute';
                          final category = page['category'] ?? 'General';
                          final url = page['url'] ?? '';
                          final docsCount = (page['resources']?['documents'] as List?)?.length ?? 0;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(category).withOpacity(0.15),
                              child: Icon(_getCategoryIcon(category), color: _getCategoryColor(category), size: 20),
                            ),
                            title: Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(category).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        category,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getCategoryColor(category)),
                                      ),
                                    ),
                                    if (docsCount > 0) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          "$docsCount PDFs",
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  url,
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            onTap: () => _navigateToPage(page),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    final c = cat.toLowerCase();
    if (c.contains('heritage') || c.contains('profile')) return GriColors.forestPrimary;
    if (c.contains('governance') || c.contains('admin')) return GriColors.ochrePrimary;
    if (c.contains('academic') || c.contains('school') || c.contains('department')) return Colors.indigo;
    if (c.contains('admiss') || c.contains('prospect')) return Colors.deepPurple;
    if (c.contains('exam') || c.contains('coe')) return Colors.teal;
    if (c.contains('scholar') || c.contains('welfare')) return Colors.brown;
    if (c.contains('research')) return Colors.blueGrey;
    if (c.contains('facilit')) return Colors.orange.shade800;
    return Colors.blue;
  }

  IconData _getCategoryIcon(String cat) {
    final c = cat.toLowerCase();
    if (c.contains('heritage') || c.contains('profile')) return Icons.history_edu;
    if (c.contains('governance') || c.contains('admin')) return Icons.account_balance;
    if (c.contains('academic') || c.contains('school') || c.contains('department')) return Icons.school;
    if (c.contains('admiss') || c.contains('prospect')) return Icons.app_registration;
    if (c.contains('exam') || c.contains('coe')) return Icons.assignment_turned_in;
    if (c.contains('scholar') || c.contains('welfare')) return Icons.volunteer_activism;
    if (c.contains('research')) return Icons.science;
    if (c.contains('facilit')) return Icons.domain;
    return Icons.article;
  }
}
