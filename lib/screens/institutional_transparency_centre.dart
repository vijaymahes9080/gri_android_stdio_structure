import 'package:flutter/material.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';
import '../widgets/gri_primitives.dart';

/// Institutional Transparency Centre — centralized official disclosures.
///
/// Lists only verified institutional disclosure entries (NAAC, NIRF, AISHE,
/// IQAC, RTI, mandatory disclosures, rules & manuals, committees) with their
/// official source URLs. No accreditation grades, rankings, or compliance
/// claims are fabricated — every entry links to its official source.
class InstitutionalTransparencyCentre extends StatefulWidget {
  const InstitutionalTransparencyCentre({super.key});

  @override
  State<InstitutionalTransparencyCentre> createState() =>
      _InstitutionalTransparencyCentreState();
}

class _InstitutionalTransparencyCentreState
    extends State<InstitutionalTransparencyCentre> {
  String _query = '';
  String _category = 'All';

  List<String> get _categories {
    final set = <String>{'All'};
    for (final s in VerifiedContent.services) {
      set.add(s.category);
    }
    return set.toList()..sort();
  }

  List<InstitutionalService> get _filtered {
    final q = OfficialText.clean(_query).toLowerCase();
    return VerifiedContent.services.where((s) {
      if (_category != 'All' && s.category != _category) return false;
      if (q.isEmpty) return true;
      return '${s.title} ${s.description} ${s.category}'
          .toLowerCase()
          .contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Transparency Centre'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          GriSectionHeader(
            title: 'Official disclosures & mandatory publications',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Institutional transparency',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'All entries below are published by GRI on its official '
                  'website. This app does not verify or vouch for the '
                  'contents of external documents — open the source link for '
                  'the authoritative version.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search disclosures (NAAC, NIRF, RTI, …)',
                    prefixIcon: const Icon(Icons.search, size: 20),
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
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
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
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'DISCLOSURES • ${_filtered.length} of ${VerifiedContent.services.length}',
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: GriColors.forestPrimary,
            ),
          ),
          const SizedBox(height: 6),
          if (_filtered.isEmpty)
            GriEmptyState(
              icon: Icons.search_off,
              title: 'No matching disclosure',
              hint: 'Try a different keyword or category.',
            )
          else
            ..._filtered.map((s) => _disclosureTile(context, isDark, s)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GriColors.ochreContainer.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GriColors.ochrePrimary.withValues(alpha: 0.4),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_outlined,
                        size: 18, color: GriColors.ochrePrimary),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Source verification',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: GriColors.ochrePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Every disclosure links to its official page on '
                  'ruraluniv.ac.in. Accreditation grades (NAAC A++ Grade, '
                  '4th Cycle, CGPA 3.58) and ranking figures shown in this '
                  'app are taken directly from the official disclosures '
                  'page and are not independently verified by this app.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: isDark ? GriColors.ochreOnContainer : GriColors.ochrePrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclosureTile(
      BuildContext context, bool isDark, InstitutionalService s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.description_outlined,
            size: 20,
            color: GriColors.forestPrimary,
          ),
        ),
        title: Text(
          s.title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            '${s.category} • official GRI source',
            style: TextStyle(
              fontSize: 10.5,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => GriUrlLauncher.launch(context, s.url),
      )),
    );
  }
}
