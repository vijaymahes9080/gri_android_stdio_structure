import 'package:flutter/material.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../services/official_resource_registry.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../utils/gri_url_launcher.dart';

/// Official events and notice boards.
///
/// Notices come from the canonical dataset collected from ruraluniv.ac.in.
/// Events and tenders are read from the live official boards and carry their
/// exact source URLs. Careers is shown honestly as empty when the official
/// board publishes no notices.
class EventsNoticesScreen extends StatefulWidget {
  final int initialIndex;

  const EventsNoticesScreen({super.key, this.initialIndex = 0});

  @override
  State<EventsNoticesScreen> createState() => _EventsNoticesScreenState();
}

class _EventsNoticesScreenState extends State<EventsNoticesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;
  String _query = '';
  String _noticeCategory = 'All';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, 3),
    );
    _searchController = TextEditingController();
    if (!OfficialCatalogService.instance.isLoaded) {
      setState(() => _loading = true);
      OfficialCatalogService.instance
          .ensureLoaded()
          .whenComplete(() {
            if (mounted) setState(() => _loading = false);
          })
          .catchError((_) {
            if (mounted) setState(() => _loading = false);
          });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _activeBoardUrl() {
    switch (_tabController.index) {
      case 1:
        return VerifiedInstitution.eventsUrl;
      case 2:
        return VerifiedInstitution.tendersUrl;
      case 3:
        return VerifiedInstitution.careersUrl;
      default:
        return VerifiedInstitution.circularsUrl;
    }
  }

  List<OfficialNotice> _filteredNotices() {
    final q = OfficialText.clean(_query).toLowerCase();
    return OfficialCatalogService.instance.notices.where((n) {
      if (_noticeCategory != 'All' &&
          n.category.toLowerCase() != _noticeCategory.toLowerCase()) {
        return false;
      }
      if (q.isEmpty) return true;
      return '${OfficialText.clean(n.title)} ${OfficialText.clean(n.summary)} ${n.category}'
          .toLowerCase()
          .contains(q);
    }).toList();
  }

  List<VerifiedEvent> _filterEvents(List<VerifiedEvent> source) {
    final q = OfficialText.clean(_query).toLowerCase();
    if (q.isEmpty) return source;
    return source
        .where((e) =>
            '${e.title} ${e.detail} ${e.dateDisplay}'.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Events & Notices'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Open the current official board',
            icon: const Icon(Icons.open_in_new),
            onPressed: () => GriUrlLauncher.launch(context, _activeBoardUrl()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor:
              isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          indicatorColor: GriColors.forestPrimary,
          onTap: (_) => setState(() {}),
          tabs: const [
            Tab(text: 'Notices'),
            Tab(text: 'Events'),
            Tab(text: 'Tenders'),
            Tab(text: 'Careers'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearch(context, isDark),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotices(context, isDark),
                      _buildEvents(context, isDark),
                      _buildTenders(context, isDark),
                      _buildCareers(context, isDark),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearch(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Search this board',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
          isDense: true,
          filled: true,
          fillColor: isDark ? GriColors.darkSurface2 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotices(BuildContext context, bool isDark) {
    final notices = _filteredNotices();
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: ['All', 'circular', 'student'].map((category) {
              final selected = category == _noticeCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(
                    category == 'All' ? 'All notices' : category,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: selected
                          ? Colors.white
                          : (isDark
                              ? GriColors.darkOnSurfaceVariant
                              : GriColors.onSurfaceVariant),
                    ),
                  ),
                  selected: selected,
                  selectedColor: GriColors.forestPrimary,
                  backgroundColor: isDark ? GriColors.darkSurface2 : Colors.white,
                  side: BorderSide(
                    color: isDark
                        ? GriColors.darkOutlineVariant
                        : GriColors.outlineVariant,
                  ),
                  onSelected: (_) =>
                      setState(() => _noticeCategory = category),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: notices.isEmpty
              ? _emptyState(
                  context,
                  isDark,
                  'No notice matches this filter.',
                  VerifiedInstitution.circularsUrl,
                  'Open official circulars board',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
                  itemCount: notices.length,
                  itemBuilder: (context, index) =>
                      _noticeTile(context, isDark, notices[index]),
                ),
        ),
      ],
    );
  }

  Widget _noticeTile(
      BuildContext context, bool isDark, OfficialNotice notice) {
    final title = OfficialText.title(notice.title);
    final summary = OfficialText.clean(notice.summary);
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        onTap: () => OfficialResourceRegistry.smartOpenDocument(
          context,
          notice.url,
          title: title,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.22 : 0.08),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.description_outlined,
              size: 18, color: GriColors.forestPrimary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '${notice.displayDate} • ${notice.category}'
            '${summary.isEmpty ? '' : '\n$summary'}',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.35,
              color: isDark
                  ? GriColors.darkOnSurfaceVariant
                  : GriColors.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
      )),
    );
  }

  Widget _buildEvents(BuildContext context, bool isDark) {
    final events = _filterEvents(VerifiedContent.events);
    return Column(
      children: [
        _sourceBanner(
          context,
          isDark,
          'Live official events board • ${events.length} of ${VerifiedContent.events.length} events',
          VerifiedInstitution.eventsUrl,
        ),
        Expanded(
          child: events.isEmpty
              ? _emptyState(context, isDark, 'No event matches this search.',
                  VerifiedInstitution.eventsUrl, 'Open official events board')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
                  itemCount: events.length,
                  itemBuilder: (context, index) =>
                      _eventTile(context, isDark, events[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildTenders(BuildContext context, bool isDark) {
    final tenders = _filterEvents(VerifiedContent.tenders);
    return Column(
      children: [
        _sourceBanner(
          context,
          isDark,
          'Live official tender board • ${tenders.length} item(s)',
          VerifiedInstitution.tendersUrl,
        ),
        Expanded(
          child: tenders.isEmpty
              ? _emptyState(context, isDark, 'No tender matches this search.',
                  VerifiedInstitution.tendersUrl, 'Open official tender board')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
                  itemCount: tenders.length,
                  itemBuilder: (context, index) =>
                      _eventTile(context, isDark, tenders[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildCareers(BuildContext context, bool isDark) {
    return _emptyState(
      context,
      isDark,
      'The official GRI careers board currently shows no open notices.\n'
      'New recruitment notices will appear here only when GRI publishes them.',
      VerifiedInstitution.careersUrl,
      'Open official careers board',
    );
  }

  Widget _eventTile(BuildContext context, bool isDark, VerifiedEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        onTap: () => GriUrlLauncher.launch(context, event.url),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: GriColors.ochrePrimary.withValues(alpha: isDark ? 0.22 : 0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.event_outlined,
              size: 18, color: GriColors.ochrePrimary),
        ),
        title: Text(
          OfficialText.clean(event.title),
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '${event.dateDisplay}\n${event.detail}',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.35,
              color: isDark
                  ? GriColors.darkOnSurfaceVariant
                  : GriColors.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 16),
      )),
    );
  }

  Widget _sourceBanner(
      BuildContext context, bool isDark, String text, String url) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Row(
        children: [
          const Icon(Icons.verified, size: 14, color: GriColors.forestPrimary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                color: isDark
                    ? GriColors.darkOnSurfaceVariant
                    : GriColors.onSurfaceVariant,
              ),
            ),
          ),
          InkWell(
            onTap: () => GriUrlLauncher.launch(context, url),
            child: const Text(
              'Open board ↗',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: GriColors.forestPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, bool isDark, String message,
      String url, String action) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 42,
                color: isDark
                    ? GriColors.darkOnSurfaceVariant
                    : GriColors.outline),
            const SizedBox(height: 10),
            Text(
              message,
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
            GriPressable(
              onTap: () => GriUrlLauncher.launch(context, url),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: GriColors.forestPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: GriColors.forestPrimary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.open_in_new,
                        size: 14, color: GriColors.forestPrimary),
                    const SizedBox(width: 6),
                    Text(
                      action,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: GriColors.forestPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
