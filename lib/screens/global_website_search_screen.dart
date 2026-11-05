import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

/// Global website search screen that uses the verified OfficialCatalogService
/// search index instead of the legacy static inventory.
class GlobalWebsiteSearchScreen extends StatefulWidget {
  const GlobalWebsiteSearchScreen({super.key});

  @override
  State<GlobalWebsiteSearchScreen> createState() =>
      _GlobalWebsiteSearchScreenState();
}

class _GlobalWebsiteSearchScreenState extends State<GlobalWebsiteSearchScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  List<OfficialSearchHit> _hits = [];
  String _selectedCategory = 'All';
  bool _isSearching = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _hits = [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final catalog = OfficialCatalogService.instance;
    if (!catalog.isLoaded) {
      await catalog.ensureLoaded();
    }
    setState(() {
      _hits = catalog.search(query, category: _selectedCategory);
      _isSearching = _hits.isNotEmpty || query.isNotEmpty;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _hits = [];
      _isSearching = false;
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isInit) {
      _isInit = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure catalog is loaded; search will trigger on user input
      });
    }

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Global Website Search'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onSubmitted: (query) => _performSearch(query),
              decoration: InputDecoration(
                hintText: 'Search GRI website...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark
                        ? GriColors.darkOutlineVariant
                        : GriColors.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              onChanged: (query) {
                if (query.isNotEmpty || _hits.isNotEmpty) {
                  _performSearch(query);
                }
              },
            ),
            const SizedBox(height: 16),

            // Category filter
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedCategory == 'All',
                  backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  selectedColor: GriColors.forestPrimary,
                  disabledColor: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: _selectedCategory == 'All'
                        ? GriColors.forestPrimary
                        : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: 1.0,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedCategory = 'All');
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                ),
                FilterChip(
                  label: const Text('Faculty'),
                  selected: _selectedCategory == 'Faculty',
                  backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  selectedColor: GriColors.forestPrimary,
                  disabledColor: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: _selectedCategory == 'Faculty'
                        ? GriColors.forestPrimary
                        : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: 1.0,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedCategory = 'Faculty');
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                ),
                FilterChip(
                  label: const Text('Programmes'),
                  selected: _selectedCategory == 'Programmes',
                  backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  selectedColor: GriColors.forestPrimary,
                  disabledColor: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: _selectedCategory == 'Programmes'
                        ? GriColors.forestPrimary
                        : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: 1.0,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedCategory = 'Programmes');
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                ),
                FilterChip(
                  label: const Text('Notices'),
                  selected: _selectedCategory == 'Notices',
                  backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  selectedColor: GriColors.forestPrimary,
                  disabledColor: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: _selectedCategory == 'Notices'
                        ? GriColors.forestPrimary
                        : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: 1.0,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedCategory = 'Notices');
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                ),
                FilterChip(
                  label: const Text('Photos'),
                  selected: _selectedCategory == 'Media',
                  backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  selectedColor: GriColors.forestPrimary,
                  disabledColor: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: _selectedCategory == 'Media'
                        ? GriColors.forestPrimary
                        : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: 1.0,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedCategory = 'Media');
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                ),
                FilterChip(
                  label: const Text('Documents'),
                  selected: _selectedCategory == 'Documents',
                  backgroundColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  selectedColor: GriColors.forestPrimary,
                  disabledColor: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: _selectedCategory == 'Documents'
                        ? GriColors.forestPrimary
                        : (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
                    width: 1.0,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedCategory = 'Documents');
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search results
            if (_isSearching || _hits.isNotEmpty)
              _buildResultsList(isDark)
            else
              _buildSearchHint(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Found ${_hits.length} result${_hits.length == 1 ? '' : 's'}',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ..._hits.map((hit) => _buildResultTile(hit, isDark)).toList(),
      ],
    );
  }

  Widget _buildResultTile(OfficialSearchHit hit, bool isDark) {
    final isUrl = hit.url.startsWith('http') || hit.url.startsWith('/');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isDark ? GriColors.darkSurface1 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: _resultIcon(hit.category, isDark),
        title: Text(
          hit.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: isDark ? GriColors.darkOnSurface : Colors.black87,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        subtitle: Text(
          hit.subtitle,
          style: TextStyle(
            fontSize: 9,
            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        trailing: isUrl
            ? const Icon(Icons.open_in_new, size: 14, color: GriColors.ochrePrimary)
            : null,
        onTap: isUrl ? () => _launchUrl(hit.url) : null,
      ),
    );
  }

  Widget _resultIcon(String category, bool isDark) {
    final icons = {
      'Faculty': Icons.person_outlined,
      'Programmes': Icons.book_outlined,
      'Notices': Icons.notifications_outlined,
      'Media': Icons.photo_outlined,
      'Documents': Icons.picture_as_pdf,
      'All': Icons.search,
    };
    final icon = icons[category] ?? Icons.search;
    return Icon(icon, size: 20, color: GriColors.forestPrimary);
  }

  Widget _buildSearchHint(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_outlined,
            size: 64,
            color: isDark ? GriColors.darkSurfaceVariant : GriColors.outlineVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'Search the official GRI website',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Type keywords to search faculty, programmes, notices, documents and media',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}