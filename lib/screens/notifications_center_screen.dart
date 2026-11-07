import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/academic_models.dart';
import '../models/official_models.dart';
import '../providers/gri_provider.dart';
import '../services/notification_service.dart';
import '../services/official_catalog_service.dart';
import '../services/official_resource_registry.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import 'settings_screen.dart';

/// Official Institutional Notification & Circulars Center
///
/// Provides a unified feed of verified institutional notifications:
/// - Official Registrar circulars & office orders
/// - Controller of Examinations (CoE) alerts and timetable updates
/// - Student welfare, scholarship, and campus administration notices
/// - Hardware notification test trigger for connected device verification
class NotificationsCenterScreen extends StatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  State<NotificationsCenterScreen> createState() =>
      _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isTestingDeviceNotification = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _triggerTestNotification(BuildContext context) async {
    setState(() => _isTestingDeviceNotification = true);
    final granted =
        await NotificationService.instance.showTestNotification();
    if (mounted) {
      setState(() => _isTestingDeviceNotification = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? "Notification sent! Pull down phone notification shade to view."
                : "Notification triggered. Ensure notifications are enabled in Android settings.",
          ),
          backgroundColor: GriColors.forestPrimary,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();

    final circulars = provider.circulars;
    final catalogNotices = OfficialCatalogService.instance.notices;

    // Filter items based on selected category & query
    final filteredCirculars = circulars.where((c) {
      if (_selectedFilter == 'Examinations' &&
          !c.category.toLowerCase().contains('exam')) {
        return false;
      }
      if (_selectedFilter == 'Academic' &&
          !c.category.toLowerCase().contains('acad')) {
        return false;
      }
      if (_selectedFilter == 'Welfare' &&
          !c.category.toLowerCase().contains('welfare') &&
          !c.category.toLowerCase().contains('hostel') &&
          !c.category.toLowerCase().contains('transport')) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return c.title.toLowerCase().contains(q) ||
            c.summary.toLowerCase().contains(q) ||
            c.issuedBy.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    final unreadCount = circulars.where((c) => !c.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "NOTIFICATIONS & CIRCULARS",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              "The Gandhigram Rural Institute",
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: _isTestingDeviceNotification
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.notifications_active_outlined),
            tooltip: "Send Test Alert to Phone",
            onPressed: () => _triggerTestNotification(context),
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: "Mark all as read",
            onPressed: unreadCount > 0
                ? () {
                    provider.markAllCircularsRead();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("All notifications marked as read."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: "Notification Settings",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Device Test Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
            child: Row(
              children: [
                Icon(
                  Icons.phone_android,
                  size: 20,
                  color: isDark ? GriColors.ochrePrimary : GriColors.forestPrimary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Android Push & System Alerts Active",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                        ),
                      ),
                      Text(
                        unreadCount > 0
                            ? "$unreadCount unread institutional alert(s)"
                            : "All circulars up to date",
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark ? Colors.white60 : GriColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _triggerTestNotification(context),
                  icon: const Icon(Icons.vibration, size: 15),
                  label: const Text("Test Alert", style: TextStyle(fontSize: 11)),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDark ? GriColors.ochrePrimary : GriColors.forestPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search circulars by subject, office, or keyword...",
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                isDense: true,
                filled: true,
                fillColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              children: [
                _buildFilterChip('All', unreadCount),
                const SizedBox(width: 8),
                _buildFilterChip('Examinations', null),
                const SizedBox(width: 8),
                _buildFilterChip('Academic', null),
                const SizedBox(width: 8),
                _buildFilterChip('Welfare', null),
              ],
            ),
          ),
          const Divider(height: 1),

          // Notification List
          Expanded(
            child: filteredCirculars.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 48,
                            color: isDark ? Colors.white30 : GriColors.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? "No notifications match '$_searchQuery'"
                                : "No notifications in this category",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : GriColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Official notifications are synced automatically with the university portal.",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    itemCount: filteredCirculars.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredCirculars[index];
                      return _buildNotificationCard(
                        context,
                        item,
                        provider,
                        isDark,
                        catalogNotices,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int? count) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count != null && count > 0) ...[
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : GriColors.terracotta,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? GriColors.forestPrimary : Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedFilter = label);
      },
      selectedColor: GriColors.forestPrimary,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : null,
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    CircularModel item,
    GriProvider provider,
    bool isDark,
    List<OfficialNotice> catalogNotices,
  ) {
    final isUrgent = item.isUrgent;
    final isRead = item.isRead;

    // Determine category theme color
    Color badgeColor = GriColors.forestPrimary;
    if (item.category.toLowerCase().contains('exam')) {
      badgeColor = Colors.deepOrange;
    } else if (item.category.toLowerCase().contains('welfare') ||
        item.category.toLowerCase().contains('hostel')) {
      badgeColor = Colors.indigo;
    } else if (item.category.toLowerCase().contains('transport')) {
      badgeColor = Colors.teal;
    }

    // Try finding matching official catalog notice
    OfficialNotice? matchedCatalogNotice;
    try {
      matchedCatalogNotice = catalogNotices.firstWhere(
        (n) => n.title.toLowerCase() == item.title.toLowerCase(),
      );
    } catch (_) {}

    return Card(
      margin: EdgeInsets.zero,
      elevation: isRead ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUrgent
              ? Colors.red.withValues(alpha: 0.5)
              : isRead
                  ? (isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant)
                  : GriColors.forestPrimary.withValues(alpha: 0.4),
          width: isUrgent ? 1.5 : (isRead ? 1 : 1.2),
        ),
      ),
      color: isRead
          ? (isDark ? GriColors.darkSurface1 : Colors.white)
          : (isDark
              ? GriColors.darkSurface2
              : GriColors.forestPrimary.withValues(alpha: 0.03)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!isRead) {
            provider.markCircularRead(item.id);
          }
          _showNoticeDetailModal(context, item, matchedCatalogNotice);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Category badge, Urgency, Unread indicator
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      item.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  if (isUrgent) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "URGENT",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    item.publishedDate,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? Colors.white60 : GriColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: GriColors.ochrePrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                  color: isDark ? GriColors.darkOnSurface : Colors.black87,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),

              // Summary
              Text(
                item.summary,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : GriColors.onSurfaceVariant,
                  height: 1.35,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // Footer: Issuer + Actions
              Row(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    size: 13,
                    color: isDark ? Colors.white54 : GriColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.issuedBy,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white54 : GriColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!isRead) {
                        provider.markCircularRead(item.id);
                      }
                      _showNoticeDetailModal(context, item, matchedCatalogNotice);
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Notice",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? GriColors.ochrePrimary
                                  : GriColors.forestPrimary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: isDark
                                ? GriColors.ochrePrimary
                                : GriColors.forestPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoticeDetailModal(
    BuildContext context,
    CircularModel item,
    OfficialNotice? matchedCatalogNotice,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noticeUrl = matchedCatalogNotice?.url ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? GriColors.darkSurface1 : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: GriColors.forestPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: GriColors.forestPrimary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item.publishedDate,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Issued by: ${item.issuedBy}",
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: GriColors.ochrePrimary,
                ),
              ),
              const Divider(height: 24),
              Text(
                item.summary,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (noticeUrl.isNotEmpty) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf, size: 16),
                        label: const Text("Open Official Document"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GriColors.forestPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          OfficialResourceRegistry.smartOpenDocument(
                            context,
                            noticeUrl,
                            title: item.title,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
