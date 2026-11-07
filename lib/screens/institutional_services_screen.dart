import 'package:flutter/material.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../utils/gri_url_launcher.dart';

/// Directory of verified institutional services and information pages.
///
/// Every entry maps to a page that exists on the current official GRI website.
/// Items the university does not currently publish (for example a dedicated
/// Shanti Sena page or AISHE report) are explicitly described as such.
class InstitutionalServicesScreen extends StatefulWidget {
  final String initialCategory;

  const InstitutionalServicesScreen({super.key, this.initialCategory = 'All'});

  @override
  State<InstitutionalServicesScreen> createState() =>
      _InstitutionalServicesScreenState();
}

class _InstitutionalServicesScreenState
    extends State<InstitutionalServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _category;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _category = VerifiedContent.serviceCategories.contains(widget.initialCategory)
        ? widget.initialCategory
        : 'All';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categories =>
      ['All', ...VerifiedContent.serviceCategories];

  List<InstitutionalService> _filtered() {
    final q = OfficialText.clean(_query).toLowerCase();
    return VerifiedContent.services.where((s) {
      if (_category != 'All' && s.category != _category) return false;
      if (q.isEmpty) return true;
      return '${s.title} ${s.description} ${s.category}'.toLowerCase().contains(q);
    }).toList();
  }

  IconData _iconFor(String category) {
    switch (category) {
      case 'Governance':
        return Icons.account_balance_outlined;
      case 'Academics':
        return Icons.school_outlined;
      case 'Research':
        return Icons.science_outlined;
      case 'Accreditation':
        return Icons.workspace_premium_outlined;
      case 'Student Support':
        return Icons.volunteer_activism_outlined;
      case 'Compliance':
        return Icons.gavel_outlined;
      case 'Media':
        return Icons.campaign_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = _filtered();
    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Institutional Services'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Open GRI sitemap',
            icon: const Icon(Icons.public),
            onPressed: () => GriUrlLauncher.launch(
                context, 'https://www.ruraluniv.ac.in/site-map'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'VERIFIED OFFICIAL COVERAGE • ${results.length} of '
                '${VerifiedContent.services.length} entries',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: GriColors.forestPrimary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search research, NSS, IQAC, RTI, policies...',
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
                    color: isDark
                        ? GriColors.darkOutlineVariant
                        : GriColors.outlineVariant,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark
                        ? GriColors.darkOutlineVariant
                        : GriColors.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final selected = category == _category;
                return ChoiceChip(
                  label: Text(
                    category,
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
                  backgroundColor:
                      isDark ? GriColors.darkSurface2 : Colors.white,
                  side: BorderSide(
                    color: isDark
                        ? GriColors.darkOutlineVariant
                        : GriColors.outlineVariant,
                  ),
                  onSelected: (_) => setState(() => _category = category),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text(
                        'No institutional service matches this search.\n'
                        'Try "NAAC", "NSS", "research", "RTI" or "policy".',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: isDark
                              ? GriColors.darkOnSurfaceVariant
                              : GriColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final service = results[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        decoration: BoxDecoration(
                          color: isDark ? GriColors.darkSurface1 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? GriColors.darkOutlineVariant
                                : GriColors.outlineVariant,
                          ),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary
                                  .withValues(alpha: isDark ? 0.22 : 0.08),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              _iconFor(service.category),
                              size: 18,
                              color: GriColors.forestPrimary,
                            ),
                          ),
                          title: Text(
                            service.title,
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${service.description}\n${service.category}',
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
                          trailing: GriPressable(
                            onTap: () =>
                                GriUrlLauncher.launch(context, service.url),
                            child: const Icon(Icons.open_in_new,
                                size: 17, color: GriColors.forestPrimary),
                          ),
                          onTap: () =>
                              GriUrlLauncher.launch(context, service.url),
                        )),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
