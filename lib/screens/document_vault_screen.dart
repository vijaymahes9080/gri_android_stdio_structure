import 'package:flutter/material.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Admissions",
    "Examinations",
    "Research",
    "Regulations",
    "Circulars",
    "Governance",
  ];

  @override
  Widget build(BuildContext context) {
    final allDocs = OfficialResourceRegistry.getDocuments();
    final query = _searchController.text.trim().toLowerCase();

    final filtered = allDocs.where((doc) {
      final title = doc.title.toLowerCase();
      final cat = doc.category.toLowerCase();
      final matchesQuery = query.isEmpty || title.contains(query) || cat.contains(query);
      final matchesCat = _selectedCategory == "All" || cat == _selectedCategory.toLowerCase();
      return matchesQuery && matchesCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Official Document Vault", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search & Metrics Header
          Container(
            padding: const EdgeInsets.all(12),
            color: GriColors.forestPrimary.withOpacity(0.06),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Search official prospectuses, COE forms, circulars...",
                    prefixIcon: const Icon(Icons.search, color: GriColors.forestPrimary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Registered Documents: ${allDocs.length}", style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: GriColors.forestPrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                      child: Text("${allDocs.where((d) => d.isBundledLocally).length} Pre-bundled Offline", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
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
                    label: Text(c, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: GriColors.forestPrimary.withOpacity(0.18),
                    checkmarkColor: GriColors.forestPrimary,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_off, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        const Text("No documents match your query", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      final isBundled = doc.isBundledLocally;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.withOpacity(0.12),
                          child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 22),
                        ),
                        title: Text(
                          doc.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text("${doc.module} • ${doc.formattedSize}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (isBundled)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                                    child: const Text("Pre-bundled Offline", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green)),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                                    child: const Text("Official Cloud Stream", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue)),
                                  ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                                  child: Text(doc.category, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBundled ? GriColors.forestPrimary : Colors.grey.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
