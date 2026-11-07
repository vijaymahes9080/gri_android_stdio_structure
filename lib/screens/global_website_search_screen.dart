import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../services/official_resource_registry.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';
import 'campus_map_screen.dart';
import 'department_detail_screen.dart';
import 'faculty_directory_screen.dart';
import 'media_gallery_screen.dart';
import 'schools_programmes_hub_screen.dart';

/// Unified search over the verified official GRI dataset.
///
/// Results are drawn from the canonical catalogue (units, faculty, programmes,
/// notices, documents, media, governance and facilities) plus the audited
/// institutional services list. Each result either navigates inside the app or
/// opens the exact official source URL — nothing is opened speculatively.
class GlobalWebsiteSearchScreen extends StatefulWidget {
  final String initialQuery;

  const GlobalWebsiteSearchScreen({super.key, this.initialQuery = ''});

  @override
  State<GlobalWebsiteSearchScreen> createState() =>
      _GlobalWebsiteSearchScreenState();
}

class _GlobalWebsiteSearchScreenState extends State<GlobalWebsiteSearchScreen> {
  static const String _recentKey = 'gri.search.recent';
  static const int _maxRecent = 8;

  static const List<String> _suggestions = [
    'NAAC',
    'Admissions',
    'Library',
    'Computer Centre',
    'Hostel',
    'Mathematics',
    'Examination',
    'Scholarship',
  ];

  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  List<OfficialSearchHit> _hits = [];
  List<String> _recent = [];
  List<String> _categories = const ['All'];
  String _selectedCategory = 'All';
  String _query = '';
  bool _loadingCatalog = false;
  String? _catalogError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _query = widget.initialQuery;
    _loadRecent();
    _ensureCatalog();
    if (_query.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _runSearch(_query));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(_recentKey) ?? const [];
      if (mounted) setState(() => _recent = stored);
    } catch (_) {
      // Recent searches are a convenience only; failures are non-fatal.
    }
  }

  Future<void> _remember(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return;
    final next = <String>[
      trimmed,
      ..._recent.where((e) => e.toLowerCase() != trimmed.toLowerCase()),
    ].take(_maxRecent).toList();
    setState(() => _recent = next);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_recentKey, next);
    } catch (_) {
      // Ignore persistence failures.
    }
  }

  Future<void> _clearRecent() async {
    setState(() => _recent = []);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentKey);
    } catch (_) {}
  }

  Future<void> _ensureCatalog() async {
    final catalog = OfficialCatalogService.instance;
    if (catalog.isLoaded) {
      _refreshCategories();
      return;
    }
    setState(() => _loadingCatalog = true);
    try {
      await catalog.ensureLoaded();
      _refreshCategories();
    } catch (_) {
      if (mounted) {
        setState(() => _catalogError =
            'The verified catalogue could not be loaded. You can still open '
            'the official GRI website.');
      }
    } finally {
      if (mounted) setState(() => _loadingCatalog = false);
    }
  }

  void _refreshCategories() {
    final catalog = OfficialCatalogService.instance;
    if (!catalog.isLoaded) return;
    final categories = <String>{'All'};
    for (final hit in catalog.search('')) {
      categories.add(hit.category);
    }
    final ordered = ['All', ...categories.where((c) => c != 'All').toList()..sort()];
    if (mounted) setState(() => _categories = ordered);
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      if (value.trim().isEmpty) {
        setState(() => _hits = []);
      } else {
        _runSearch(value, remember: false);
      }
    });
  }

  void _submit(String value) {
    _debounce?.cancel();
    _runSearch(value, remember: true);
  }

  /// Ranked search: exact/prefix title matches first, then title substring,
  /// then subtitle matches. Services are appended as their own category.
  void _runSearch(String rawQuery, {bool remember = false}) {
    final catalog = OfficialCatalogService.instance;
    final query = OfficialText.clean(rawQuery).toLowerCase().trim();
    if (remember) _remember(rawQuery);
    if (!catalog.isLoaded) {
      setState(() {
        _query = rawQuery;
        _hits = _matchServices(query);
      });
      return;
    }

    final base = catalog.search('');
    final scored = <MapEntry<int, OfficialSearchHit>>[];
    for (final hit in base) {
      final score = _score(query, hit.title, hit.subtitle, hit.category);
      if (score > 0) scored.add(MapEntry(score, hit));
    }
    for (final service in _matchServices(query)) {
      final score = _score(query, service.title, service.subtitle, service.category);
      if (score > 0) scored.add(MapEntry(score, service));
    }
    scored.sort((a, b) => b.key.compareTo(a.key));
    final filtered = scored
        .where((e) =>
            _selectedCategory == 'All' ||
            e.value.category.toLowerCase() == _selectedCategory.toLowerCase())
        .map((e) => e.value)
        .toList();

    setState(() {
      _query = rawQuery;
      _hits = filtered;
    });
  }

  int _score(String query, String title, String subtitle, String category) {
    if (query.isEmpty) return 1;
    final t = title.toLowerCase();
    final s = subtitle.toLowerCase();
    final c = category.toLowerCase();
    if (t == query) return 100;
    if (t.startsWith(query)) return 80;
    if (t.contains(query)) return 60;
    if (s.contains(query)) return 30;
    if (c.contains(query)) return 15;
    // Multi-word queries: require every token somewhere.
    final tokens = query.split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    if (tokens.length > 1) {
      final hay = '$t $s $c';
      if (tokens.every(hay.contains)) return 20;
    }
    return 0;
  }

  List<OfficialSearchHit> _matchServices(String query) {
    if (query.isEmpty) return const [];
    return VerifiedContent.services
        .where((s) =>
            '${s.title} ${s.description} ${s.category}'
                .toLowerCase()
                .contains(query))
        .map((s) => OfficialSearchHit(
              id: 'service_${s.id}',
              title: s.title,
              subtitle: '${s.category} • official GRI page',
              category: 'Services',
              url: s.url,
              kind: 'service',
              payloadId: s.id,
            ))
        .toList();
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
    _runSearch(_query);
  }

  void _applySuggestion(String value) {
    _controller.text = value;
    _controller.selection =
        TextSelection.collapsed(offset: _controller.text.length);
    _focusNode.requestFocus();
    _runSearch(value, remember: true);
  }

  void _clear() {
    _debounce?.cancel();
    setState(() {
      _controller.clear();
      _query = '';
      _hits = [];
      _selectedCategory = 'All';
    });
    _focusNode.requestFocus();
  }

  Future<void> _openHit(OfficialSearchHit hit) async {
    final catalog = OfficialCatalogService.instance;
    switch (hit.kind) {
      case 'unit':
        final unit = catalog.unitById(hit.payloadId);
        if (unit == null) {
          await GriUrlLauncher.launch(context, hit.url);
          return;
        }
        final school = catalog.schoolById(unit.schoolId)?.name ?? '';
        if (!mounted) return;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DepartmentDetailScreen(
            departmentId: unit.id,
            departmentName: OfficialText.title(unit.name),
            schoolName: school,
            hodName: '',
            sourceUrl: unit.url,
          ),
        ));
        return;
      case 'faculty':
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => FacultyDirectoryScreen(initialQuery: hit.title),
        ));
        return;
      case 'programme':
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const SchoolsProgrammesHubScreen(),
        ));
        return;
      case 'photo':
      case 'video':
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const MediaGalleryScreen(),
        ));
        return;
      case 'facility':
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const CampusMapScreen(),
        ));
        return;
      case 'notice':
      case 'document':
        await OfficialResourceRegistry.smartOpenDocument(
          context,
          hit.url,
          title: OfficialText.title(hit.title),
        );
        return;
      default:
        await GriUrlLauncher.launch(context, hit.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Search GRI'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor:
            isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Open official GRI website',
            icon: const Icon(Icons.public),
            onPressed: () =>
                GriUrlLauncher.launch(context, VerifiedInstitution.website),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.search,
              onChanged: _onQueryChanged,
              onSubmitted: _submit,
              decoration: InputDecoration(
                hintText: 'Search faculty, programmes, notices, documents...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: _clear,
                      ),
                isDense: true,
                filled: true,
                fillColor: isDark ? GriColors.darkSurface2 : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? GriColors.darkOutlineVariant
                        : GriColors.outlineVariant,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? GriColors.darkOutlineVariant
                        : GriColors.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
          if (_categories.length > 1)
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == _selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      category,
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
                    backgroundColor:
                        isDark ? GriColors.darkSurface2 : Colors.white,
                    side: BorderSide(
                      color: isDark
                          ? GriColors.darkOutlineVariant
                          : GriColors.outlineVariant,
                    ),
                    onSelected: (_) => _selectCategory(category),
                  );
                },
              ),
            ),
          const SizedBox(height: 6),
          Expanded(child: _buildBody(isDark)),
        ],
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_loadingCatalog) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_catalogError != null) {
      return _buildCatalogError(isDark);
    }
    if (_query.trim().isEmpty) {
      return _buildDiscovery(isDark);
    }
    return _buildResults(isDark);
  }

  Widget _buildCatalogError(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 42, color: GriColors.warning),
            const SizedBox(height: 10),
            Text(
              _catalogError!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: isDark
                    ? GriColors.darkOnSurfaceVariant
                    : GriColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () =>
                  GriUrlLauncher.launch(context, VerifiedInstitution.website),
              icon: const Icon(Icons.public, size: 16),
              label: const Text('Open official website'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscovery(bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (_recent.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  'RECENT SEARCHES',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: isDark
                        ? GriColors.darkOnSurfaceVariant
                        : GriColors.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: _clearRecent,
                child: const Text('Clear', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _recent
                .map((value) => ActionChip(
                      avatar: const Icon(Icons.history, size: 14),
                      label: Text(value, style: const TextStyle(fontSize: 11)),
                      onPressed: () => _applySuggestion(value),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          'SUGGESTED SEARCHES',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color:
                isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _suggestions
              .map((value) => ActionChip(
                    avatar: const Icon(Icons.search, size: 14),
                    label: Text(value, style: const TextStyle(fontSize: 11)),
                    onPressed: () => _applySuggestion(value),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? GriColors.darkSurface1 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_outlined,
                      size: 15, color: GriColors.forestPrimary),
                  const SizedBox(width: 6),
                  Text(
                    'Verified sources only',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? GriColors.darkOnSurface
                          : GriColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Results come from the official GRI dataset collected from '
                'ruraluniv.ac.in. Opening a document downloads it from the '
                'university server; no result is generated locally.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: isDark
                      ? GriColors.darkOnSurfaceVariant
                      : GriColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(bool isDark) {
    if (_hits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off,
                  size: 42,
                  color: isDark
                      ? GriColors.darkOnSurfaceVariant
                      : GriColors.outline),
              const SizedBox(height: 10),
              Text(
                'No verified record matches “${_query.trim()}”.\n'
                'Try a shorter keyword, or open the official website search.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: isDark
                      ? GriColors.darkOnSurfaceVariant
                      : GriColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () =>
                    GriUrlLauncher.launch(context, VerifiedInstitution.website),
                icon: const Icon(Icons.public, size: 16),
                label: const Text('Open official website'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
      itemCount: _hits.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '${_hits.length} verified result${_hits.length == 1 ? '' : 's'}'
              '${_selectedCategory == 'All' ? '' : ' • $_selectedCategory'}',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? GriColors.darkOnSurfaceVariant
                    : GriColors.onSurfaceVariant,
              ),
            ),
          );
        }
        final hit = _hits[index - 1];
        return _buildResultTile(isDark, hit);
      },
    );
  }

  Widget _buildResultTile(bool isDark, OfficialSearchHit hit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color:
              isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.22 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _iconFor(hit.category),
            size: 17,
            color: GriColors.forestPrimary,
          ),
        ),
        title: Text(
          OfficialText.title(hit.title),
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            [OfficialText.clean(hit.subtitle), hit.category]
                .where((e) => e.isNotEmpty)
                .join(' • '),
            style: TextStyle(
              fontSize: 10.5,
              color: isDark
                  ? GriColors.darkOnSurfaceVariant
                  : GriColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Icon(
          _opensInApp(hit.kind) ? Icons.chevron_right : Icons.open_in_new,
          size: 16,
          color: GriColors.ochrePrimary,
        ),
        onTap: () => _openHit(hit),
      )),
    );
  }

  bool _opensInApp(String kind) => const {
        'unit',
        'faculty',
        'programme',
        'photo',
        'video',
        'facility',
      }.contains(kind);

  IconData _iconFor(String category) {
    switch (category) {
      case 'Faculty':
        return Icons.person_outline;
      case 'Programmes':
        return Icons.school_outlined;
      case 'Notices':
        return Icons.notifications_outlined;
      case 'Documents':
        return Icons.picture_as_pdf_outlined;
      case 'Media':
        return Icons.photo_library_outlined;
      case 'Governance':
        return Icons.account_balance_outlined;
      case 'Facilities':
        return Icons.place_outlined;
      case 'Services':
        return Icons.miscellaneous_services_outlined;
      case 'Academics':
        return Icons.menu_book_outlined;
      default:
        return Icons.search;
    }
  }
}
