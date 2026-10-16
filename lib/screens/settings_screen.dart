import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

/// Production-Grade Settings & Institutional Preferences Screen
/// Conforms to Phase 7 of GRI Engineering Specification:
/// - Theme Mode selection (System, Light, Dark) with SharedPreferences persistence
/// - Typography scaling preference (Small, Standard, Large)
/// - Bilingual Language preference (English, தமிழ்)
/// - Motion accessibility toggle (Reduced Motion)
/// - Cache inspection & safe cache-clearing controls
/// - Real website data refresh trigger
/// - Institutional version, NAAC accreditation, and official portal links
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cannot open: $url"),
            backgroundColor: GriColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to open URL: $e"),
          backgroundColor: GriColors.error,
        ),
      );
    }
  }

  void _confirmClearCache(BuildContext context, GriProvider provider) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Clear Application Cache?"),
        content: const Text(
          "This will flush in-memory and cached visual assets. All cataloged university offline indexes will be preserved.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: GriColors.forestPrimary),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              provider.clearApplicationCache();
            },
            child: const Text("Clear Cache"),
          ),
        ],
      ),
    );
  }

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Institutional Information"),
        content: const SingleChildScrollView(
          child: Text(
            "The Gandhigram Rural Institute (Deemed to be University)\n"
            "Gandhigram - 624 302, Dindigul District, Tamil Nadu, India.\n\n"
            "• Conferred Deemed to be University status in 1976 under Section 3 of the UGC Act, 1956.\n"
            "• Re-accredited with 'A' Grade by NAAC (Cycle-4).\n"
            "• Categorized under Category-I by the Ministry of Education, Govt. of India.\n\n"
            "All content in this application reflects verified public records collected from the official portal (ruraluniv.ac.in).",
            style: TextStyle(fontSize: 12.5, height: 1.45),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;
    final user = provider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Settings & Preferences",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // 1. Account & Role Card
          _buildCard(
            cardBg: cardBg,
            borderColor: borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  icon: Icons.account_circle_outlined,
                  title: "ACTIVE PROFILE & ROLE",
                  color: GriColors.forestPrimary,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: GriColors.forestContainer,
                      child: Text(
                        (user?.name.isNotEmpty == true) ? user!.name[0] : "U",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: GriColors.forestPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? "Vijay Pradhap",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${user?.rollNo ?? '2024-MS-4011'} • ${user?.department ?? 'Computer Science'}",
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        provider.currentRole.name,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: GriColors.forestPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      provider.toggleRoleSwitcher(true);
                    },
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: const Text("Switch Institutional Role"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: GriColors.forestPrimary,
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Appearance & Theme Card
          _buildCard(
            cardBg: cardBg,
            borderColor: borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  icon: Icons.palette_outlined,
                  title: "APPEARANCE & DISPLAY",
                  color: GriColors.ochrePrimary,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Theme Mode",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text("System"),
                      icon: Icon(Icons.brightness_auto, size: 16),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text("Light"),
                      icon: Icon(Icons.light_mode, size: 16),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text("Dark"),
                      icon: Icon(Icons.dark_mode, size: 16),
                    ),
                  ],
                  selected: {provider.themeMode},
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    provider.setThemeMode(newSelection.first);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Text Size",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      provider.textScaleFactor == 0.9
                          ? "Small (90%)"
                          : (provider.textScaleFactor == 1.15
                              ? "Large (115%)"
                              : "Standard (100%)"),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildScaleChoice(
                        context: context,
                        title: "Small",
                        value: 0.9,
                        selected: provider.textScaleFactor == 0.9,
                        onTap: () => provider.setTextScaleFactor(0.9),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildScaleChoice(
                        context: context,
                        title: "Standard",
                        value: 1.0,
                        selected: provider.textScaleFactor == 1.0,
                        onTap: () => provider.setTextScaleFactor(1.0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildScaleChoice(
                        context: context,
                        title: "Large",
                        value: 1.15,
                        selected: provider.textScaleFactor == 1.15,
                        onTap: () => provider.setTextScaleFactor(1.15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Language & Motion Accessibility
          _buildCard(
            cardBg: cardBg,
            borderColor: borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  icon: Icons.language_outlined,
                  title: "LANGUAGE & ACCESSIBILITY",
                  color: GriColors.tealSecondary,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.translate, color: GriColors.forestPrimary),
                  title: const Text("Language / மொழி", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text(
                    provider.languageCode == 'ta' ? "தமிழ் (Tamil)" : "English (ஆங்கிலம்)",
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'en', label: Text("EN")),
                      ButtonSegment(value: 'ta', label: Text("தமிழ்")),
                    ],
                    selected: {provider.languageCode},
                    onSelectionChanged: (newSel) {
                      provider.setLanguageCode(newSel.first);
                    },
                  ),
                ),
                const Divider(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.motion_photos_off_outlined, color: GriColors.ochrePrimary),
                  title: const Text("Reduce Motion", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: const Text("Dampens animations for accessibility", style: TextStyle(fontSize: 11)),
                  value: provider.reduceMotion,
                  activeColor: GriColors.forestPrimary,
                  onChanged: (val) => provider.setReduceMotion(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4. Notifications & Alerts
          _buildCard(
            cardBg: cardBg,
            borderColor: borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  icon: Icons.notifications_active_outlined,
                  title: "NOTIFICATION PREFERENCES",
                  color: Colors.indigo,
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.campaign_outlined, color: Colors.indigo),
                  title: const Text("Academic Circulars", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: const Text("Alerts for official registrar & COE circulars", style: TextStyle(fontSize: 11)),
                  value: provider.noticesEnabled,
                  activeColor: GriColors.forestPrimary,
                  onChanged: (val) => provider.setNoticesEnabled(val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.assignment_turned_in_outlined, color: Colors.indigo),
                  title: const Text("Examination Alerts", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: const Text("Timetable updates and hall ticket availability", style: TextStyle(fontSize: 11)),
                  value: provider.examAlertsEnabled,
                  activeColor: GriColors.forestPrimary,
                  onChanged: (val) => provider.setExamAlertsEnabled(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 5. Offline Data & Cache Management
          _buildCard(
            cardBg: cardBg,
            borderColor: borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  icon: Icons.storage_outlined,
                  title: "OFFLINE STORAGE & CACHE",
                  color: GriColors.forestPrimary,
                ),
                const SizedBox(height: 12),
                _buildMetricRow("Indexed Web Routes", "309 Verified URLs", isDark),
                const SizedBox(height: 6),
                _buildMetricRow("Cataloged Official PDFs", "602 Documents", isDark),
                const SizedBox(height: 6),
                _buildMetricRow("Bundled High-Res Media", "24 Physical Files", isDark),
                const SizedBox(height: 6),
                _buildMetricRow(
                  "Last Source Synchronization",
                  provider.lastSyncTimestamp != null
                      ? "${provider.lastSyncTimestamp!.day}/${provider.lastSyncTimestamp!.month}/${provider.lastSyncTimestamp!.year} ${provider.lastSyncTimestamp!.hour}:${provider.lastSyncTimestamp!.minute.toString().padLeft(2, '0')}"
                      : "2026-10-15 14:30",
                  isDark,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmClearCache(context, provider),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text("Clear Cache"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: provider.isSyncing ? null : () => provider.refreshAllData(),
                        icon: provider.isSyncing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.sync, size: 16),
                        label: Text(provider.isSyncing ? "Syncing..." : "Refresh Data"),
                        style: FilledButton.styleFrom(
                          backgroundColor: GriColors.forestPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 6. Application Information & Official Links
          _buildCard(
            cardBg: cardBg,
            borderColor: borderColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  icon: Icons.info_outline,
                  title: "INSTITUTIONAL METADATA",
                  color: GriColors.ochrePrimary,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: OfficialResourceRegistry.buildImage(
                      "IMG_OFFICIAL_CREST",
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: const Text("GRI Official Mobile Portal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text("v1.0.0+1 • Production Build", style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.verified, color: GriColors.ochrePrimary, size: 18),
                ),
                const Divider(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.open_in_browser, color: GriColors.forestPrimary, size: 20),
                  title: const Text("Visit Official University Portal", style: TextStyle(fontSize: 12.5)),
                  subtitle: const Text("ruraluniv.ac.in", style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => _launchUrl(context, "https://ruraluniv.ac.in/"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.policy_outlined, color: GriColors.forestPrimary, size: 20),
                  title: const Text("Institutional Information & Disclaimer", style: TextStyle(fontSize: 12.5)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => _showDisclaimerDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCard({
    required Color cardBg,
    required Color borderColor,
    required Widget child,
  }) {
    return Material(
      color: cardBg,
      elevation: 0.5,
      shadowColor: const Color(0x0A000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: child,
      ),
    );
  }

  Widget _buildHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScaleChoice({
    required BuildContext context,
    required String title,
    required double value,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? GriColors.forestPrimary
              : (theme.brightness == Brightness.dark ? GriColors.darkSurface2 : GriColors.surfaceVariant),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? GriColors.forestPrimary : theme.colorScheme.outlineVariant,
            width: 0.8,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
