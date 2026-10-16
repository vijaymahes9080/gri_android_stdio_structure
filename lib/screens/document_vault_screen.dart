import 'package:flutter/material.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

/// Production-Grade Official Document Vault Screen
/// Instant indexing across 595 institutional PDFs, circulars, prospectuses, and statutory reports.
class DocumentVaultScreen extends StatefulWidget {
  final String? initialCategory;
  const DocumentVaultScreen({super.key, this.initialCategory});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCategory;

  final List<String> _categories = [
    "All",
    "Admissions",
    "Examinations",
    "Research",
    "Regulations",
    "Circulars",
    "Governance",
    "CBCS Syllabus",
    "Welfare",
    "General",
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? "All";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allDocs = OfficialResourceRegistry.getFullDocumentVault();
    final query = _searchController.text.trim().toLowerCase();

    final filtered = allDocs.where((doc) {
      final title = doc.title.toLowerCase();
      final cat = doc.category.toLowerCase();
      final module = doc.module.toLowerCase();
      final summary = (doc.summary ?? '').toLowerCase();

      final matchesQuery = query.isEmpty ||
          title.contains(query) ||
          cat.contains(query) ||
          module.contains(query) ||
          summary.contains(query);

      final matchesCat = _selectedCategory == "All" ||
          cat.contains(_selectedCategory.toLowerCase()) ||
          module.contains(_selectedCategory.toLowerCase());

      return matchesQuery && matchesCat;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Official Document Vault",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search & Metrics Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Search 595 official prospectuses, forms, circulars...",
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                    prefixIcon: const Icon(Icons.search, color: GriColors.forestPrimary, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: GriColors.forestPrimary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Catalog: ${allDocs.length} Official Documents",
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${allDocs.where((d) => d.isBundledLocally).length} Pre-bundled Offline",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: GriColors.forestPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Categories Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: _categories.map((c) {
                final isSelected = _selectedCategory == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(
                      c,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : (isDark ? GriColors.darkOnSurface : Colors.black87),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: GriColors.forestPrimary,
                    backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? GriColors.forestPrimary : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                      width: 0.8,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = c;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Document List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_off_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            _selectedCategory != "All"
                                ? "No documents found under '$_selectedCategory'"
                                : "No documents match your query",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          if (_selectedCategory != "All" || _searchController.text.isNotEmpty)
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = "All";
                                  _searchController.clear();
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text("View All Cataloged Documents"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: GriColors.forestPrimary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      final isBundled = doc.isBundledLocally;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: isDark ? 0.25 : 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                        ),
                        title: Text(
                          doc.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              "${doc.module} • ${doc.formattedSize}",
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
                              ),
                            ),
                            if (doc.summary != null && doc.summary!.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                doc.summary!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  height: 1.3,
                                  color: isDark ? GriColors.darkOnSurfaceVariant.withValues(alpha: 0.85) : Colors.black54,
                                ),
                              ),
                            ],
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                if (isBundled)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "Pre-bundled Offline",
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "Official Cloud Stream",
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue),
                                    ),
                                  ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? GriColors.darkSurface2 : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    doc.category,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBundled ? GriColors.forestPrimary : (isDark ? GriColors.darkSurface2 : Colors.grey.shade800),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => OfficialResourceRegistry.openDocument(context, doc.id),
                          icon: Icon(isBundled ? Icons.visibility : Icons.download, size: 14),
                          label: Text(isBundled ? "Open" : "Download"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
