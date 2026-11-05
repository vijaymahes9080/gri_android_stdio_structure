import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/official_models.dart';
import '../services/official_catalog_service.dart';
import '../utils/gri_colors.dart';
import 'department_detail_screen.dart';

/// Governance & Administration screen backed exclusively by the verified
/// official dataset. Direct officer emails/phones are not published by the
/// university, so only the official general office contact is shown.
class GovernanceLeadershipScreen extends StatefulWidget {
  const GovernanceLeadershipScreen({super.key});

  @override
  State<GovernanceLeadershipScreen> createState() => _GovernanceLeadershipScreenState();
}

class _GovernanceLeadershipScreenState extends State<GovernanceLeadershipScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchEmail(BuildContext context, String? email) async {
    if (email == null || email.trim().isEmpty) return;
    final clean = email.trim();
    final uri = Uri.parse('mailto:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(ClipboardData(text: clean));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email copied: $clean'), backgroundColor: GriColors.forestPrimary),
        );
      }
    }
  }

  Future<void> _launchPhone(BuildContext context, String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(ClipboardData(text: phone));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone copied: $phone'), backgroundColor: GriColors.forestPrimary),
        );
      }
    }
  }

  Future<void> _openSource(BuildContext context, String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = OfficialCatalogService.instance;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!catalog.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Governance & Authorities')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final officers = catalog.leadership;
    final schools = catalog.schools.where((s) => s.type == 'school').toList();

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          'Governance & Authorities',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: 'Executive Officers'),
            Tab(text: 'Deans & Schools'),
            Tab(text: 'Statutory Bodies'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOfficers(context, isDark, officers),
          _buildSchools(context, isDark, schools),
          _buildStatutory(context, isDark),
        ],
      ),
    );
  }

  Widget _buildOfficers(BuildContext context, bool isDark, List<OfficialLeader> officers) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _sourceBanner(context, isDark, 'Executive officers as published on the official Administration page.'),
        const SizedBox(height: 12),
        ...officers.map((o) => _officerCard(context, isDark, o)),
      ],
    );
  }

  Widget _officerCard(BuildContext context, bool isDark, OfficialLeader o) {
    final photo = OfficialCatalogService.assetKey(o.photoAsset);
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _portrait(photo, o.name),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        o.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          o.designation,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: GriColors.forestPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  o.contactNote.isNotEmpty
                      ? o.contactNote
                      : 'Official university office contact.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _contactRow(context, Icons.email_outlined, o.email, () => _launchEmail(context, o.email)),
                const SizedBox(height: 3),
                _contactRow(context, Icons.phone_outlined, o.phone, () => _launchPhone(context, o.phone)),
                if (o.profileUrl.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  _contactRow(
                    context,
                    Icons.open_in_new,
                    'Official profile',
                    () => _openSource(context, o.profileUrl),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchools(BuildContext context, bool isDark, List<OfficialSchool> schools) {
    final catalog = OfficialCatalogService.instance;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _sourceBanner(context, isDark, 'Deans and schools as published on the official Administration page.'),
        const SizedBox(height: 12),
        ...schools.map((s) {
          final units = catalog.unitsForSchool(s.id);
          final photo = OfficialCatalogService.assetKey(s.deanPhotoAsset);
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _portrait(photo, s.deanName),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            s.deanName.isEmpty ? 'Dean to be updated by the university' : s.deanName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11.5,
                              color: isDark ? GriColors.darkOnSurface : Colors.black87,
                            ),
                          ),
                          Text(
                            s.deanDesignation.isEmpty ? 'Dean' : s.deanDesignation,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (units.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: units
                        .map((u) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                u.name.replaceFirst('Department of ', '').replaceFirst('Centre for ', ''),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DepartmentDetailScreen(
                            departmentId: s.id,
                            departmentName: s.name,
                            schoolName: s.name,
                            hodName: s.deanName,
                            email: '',
                            phone: '',
                            sourceUrl: s.sourceUrls.isNotEmpty
                                ? s.sourceUrls.first
                                : 'https://www.ruraluniv.ac.in/page/administration',
                          ),
                        ));
                      },
                      icon: const Icon(Icons.school_outlined, size: 15),
                      label: const Text('View school'),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _launchEmail(context, 'grucc@ruraluniv.ac.in'),
                      icon: const Icon(Icons.email_outlined, size: 15),
                      label: const Text('General office'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatutory(BuildContext context, bool isDark) {
    const bodies = [
      (
        'Executive Council',
        'The principal executive body of the Institute.',
      ),
      (
        'Academic Council',
        'The principal academic body for standards of teaching, research and examination.',
      ),
      (
        'Planning and Monitoring Board',
        'Monitors academic development plans and UGC development programmes.',
      ),
      (
        'Finance Committee',
        'Advises on financial matters, budget estimates and audits.',
      ),
    ];
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _sourceBanner(
          context,
          isDark,
          'Statutory bodies are listed in the official Governance section. Current composition is published there and may change by notification.',
        ),
        const SizedBox(height: 12),
        ...bodies.map((b) => Container(
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
                    b.$1,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    b.$2,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _openSource(context, 'https://www.ruraluniv.ac.in/page/governance'),
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: const Text('Official composition'),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _portrait(String asset, String name) {
    return Container(
      width: 56,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GriColors.forestPrimary.withValues(alpha: 0.25)),
        color: GriColors.forestContainer,
      ),
      clipBehavior: Clip.antiAlias,
      child: asset.isNotEmpty
          ? Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _initials(name),
            )
          : _initials(name),
    );
  }

  Widget _initials(String name) {
    final clean = name.replaceAll(RegExp(r'[^A-Za-z ]'), '').trim();
    final parts = clean.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final text = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : (clean.isEmpty ? 'GRI' : clean.substring(0, clean.length >= 2 ? 2 : 1).toUpperCase());
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, color: GriColors.forestPrimary, fontSize: 16),
      ),
    );
  }

  Widget _contactRow(BuildContext context, IconData icon, String value, VoidCallback onTap) {
    if (value.isEmpty) return const SizedBox.shrink();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(icon, size: 13, color: GriColors.forestPrimary),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: GriColors.forestPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sourceBanner(BuildContext context, bool isDark, String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.18 : 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_outlined, size: 15, color: GriColors.forestPrimary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.35,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
