import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/gri_provider.dart';
import '../models/telegram_models.dart';
import '../utils/gri_colors.dart';

/// Secure Telegram Bot Integration Screen
/// Implements official BotFather connection (@Gandhigram_rural_institutebot),
/// Role-Based Access Control status, two-way message ledger, and notification controls.
class TelegramIntegrationScreen extends StatefulWidget {
  const TelegramIntegrationScreen({super.key});

  @override
  State<TelegramIntegrationScreen> createState() => _TelegramIntegrationScreenState();
}

class _TelegramIntegrationScreenState extends State<TelegramIntegrationScreen> {
  final TextEditingController _testMessageController =
      TextEditingController(text: "Test notification from GRI Mobile Portal.");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GriProvider>().refreshTelegramStatus();
    });
  }

  @override
  void dispose() {
    _testMessageController.dispose();
    super.dispose();
  }

  Future<void> _launchTelegramLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unable to open Telegram deep link. Please visit: $url"),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _confirmDisconnect(BuildContext context, GriProvider provider) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Disconnect Telegram Integration?"),
        content: const Text(
          "This will unlink your GRI account from the Telegram bot. "
          "You will no longer receive academic alerts or examination notices on Telegram until you reconnect.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: GriColors.error),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              provider.disconnectTelegram();
            },
            child: const Text("Disconnect"),
          ),
        ],
      ),
    );
  }

  void _showTestMessageDialog(BuildContext context, GriProvider provider) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Send Test Alert to Telegram"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dispatches an encrypted outbound test message to your connected Telegram chat.",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _testMessageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Alert Content",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: GriColors.forestPrimary),
            onPressed: () {
              final text = _testMessageController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(dialogCtx).pop();
                provider.sendTelegramTestMessage(text);
              }
            },
            child: const Text("Send Alert"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final isConnected = provider.isTelegramConnected;
    final conn = provider.telegramConnection;
    final prefs = provider.telegramPreferences;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "TELEGRAM BOT INTEGRATION",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              "Gandhigram Rural Institute • @Gandhigram_rural_institutebot",
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshTelegramStatus(),
        color: GriColors.forestPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Connection Overview Card
              _buildConnectionCard(context, provider, cardBg, isDark, isConnected, conn),
              const SizedBox(height: 14),

              // 2. Role-Based Access Control Info Card
              _buildRolePermissionsCard(provider, cardBg, isDark),
              const SizedBox(height: 14),

              // 3. Notification Channel Toggles
              _buildNotificationPreferencesCard(provider, prefs, cardBg, isDark),
              const SizedBox(height: 14),

              // 4. Message & Activity History
              _buildMessageHistoryCard(provider, cardBg, isDark),
              const SizedBox(height: 14),

              // 5. Security & Verification Badge
              _buildSecurityAssuranceCard(cardBg, isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionCard(
    BuildContext context,
    GriProvider provider,
    Color cardBg,
    bool isDark,
    bool isConnected,
    TelegramConnection? conn,
  ) {
    return Card(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2AABEE).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.send_rounded, color: Color(0xFF2AABEE), size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "GRI Official Telegram Bot",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "@Gandhigram_rural_institutebot",
                        style: TextStyle(
                          color: Color(0xFF2AABEE),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? GriColors.forestPrimary.withOpacity(0.12)
                        : Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isConnected ? GriColors.forestPrimary : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isConnected ? Icons.check_circle_rounded : Icons.info_outline,
                        size: 13,
                        color: isConnected ? GriColors.forestPrimary : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isConnected ? "CONNECTED" : "NOT LINKED",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isConnected ? GriColors.forestPrimary : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildMetaRow("Active Account", provider.currentUser?.name ?? "Vijay Pradhap", isDark),
            _buildMetaRow("Institutional ID", provider.currentUser?.rollNo ?? "2024-MS-4011", isDark),
            _buildMetaRow("Verified Role", provider.currentRole.name, isDark),
            if (isConnected && conn != null) ...[
              _buildMetaRow(
                "Linked Telegram Chat",
                conn.telegramUsername.isNotEmpty
                    ? "@${conn.telegramUsername}"
                    : "ID: ${conn.telegramChatId}",
                isDark,
              ),
              _buildMetaRow(
                "Last Interaction",
                "${conn.lastInteractionAt.hour.toString().padLeft(2, '0')}:${conn.lastInteractionAt.minute.toString().padLeft(2, '0')}",
                isDark,
              ),
            ],
            const SizedBox(height: 14),
            if (provider.isTelegramLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (!isConnected)
              FilledButton.icon(
                icon: const Icon(Icons.link, size: 18),
                label: const Text("Connect Telegram"),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2AABEE),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  final link = await provider.initiateTelegramLinking();
                  if (link != null && context.mounted) {
                    await _launchTelegramLink(context, link);
                  }
                },
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.notifications_active_outlined, size: 16),
                      label: const Text("Test Alert", style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GriColors.forestPrimary,
                        side: BorderSide(color: GriColors.forestPrimary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _showTestMessageDialog(context, provider),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.link_off, size: 16),
                      label: const Text("Disconnect", style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GriColors.error,
                        side: BorderSide(color: GriColors.error),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _confirmDisconnect(context, provider),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRolePermissionsCard(GriProvider provider, Color cardBg, bool isDark) {
    final role = provider.currentRole.name;

    return Card(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security, size: 18, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  "ROLE-BASED TELEGRAM GATING ($role)",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Data requests on Telegram are strictly gated behind Username & Password authentication. Only authorized datasets matching your institutional role are accessible:",
              style: TextStyle(fontSize: 11.5, height: 1.4),
            ),
            const SizedBox(height: 10),
            _buildPermissionPill("/attendance", "Course attendance & aggregate percentage", true),
            _buildPermissionPill("/exams", "End-semester schedule & hall ticket status", true),
            _buildPermissionPill("/grievance", "Submitted tickets and redressal timeline", true),
            _buildPermissionPill(
              "/leaves",
              "Faculty leave approvals",
              role == "FACULTY" || role == "ADMIN",
            ),
            _buildPermissionPill(
              "/approvals",
              "Pending student registrations review",
              role == "ADMIN" || role == "SUPER_ADMIN",
            ),
            _buildPermissionPill("/circulars", "Official registrar circulars & notices", true),
            const Divider(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.key, size: 16, color: Colors.indigo),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "To authenticate on Telegram, send:\n/login <username> <password>",
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionPill(String command, String desc, bool allowed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: allowed ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              command,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: allowed ? Colors.green.shade800 : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              desc,
              style: TextStyle(
                fontSize: 11.5,
                color: allowed ? null : Colors.grey,
                decoration: allowed ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
          Icon(
            allowed ? Icons.check_circle_outline : Icons.block,
            size: 15,
            color: allowed ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPreferencesCard(
    GriProvider provider,
    TelegramNotificationPreferences prefs,
    Color cardBg,
    bool isDark,
  ) {
    return Card(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, size: 18, color: Colors.indigo),
                const SizedBox(width: 8),
                const Text(
                  "NOTIFICATION DELIVERY CHANNELS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Telegram Alerts Active", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: const Text("Push alerts directly into Telegram chat", style: TextStyle(fontSize: 11)),
              value: prefs.telegramEnabled,
              activeColor: GriColors.forestPrimary,
              onChanged: (val) => provider.setTelegramNotificationPreferences(
                prefs.copyWith(telegramEnabled: val),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Academic Circulars", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: const Text("Notices from Registrar & Dean", style: TextStyle(fontSize: 11)),
              value: prefs.circularsEnabled,
              activeColor: GriColors.forestPrimary,
              onChanged: (val) => provider.setTelegramNotificationPreferences(
                prefs.copyWith(circularsEnabled: val),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Examination Alerts", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: const Text("Hall tickets and timetable alerts", style: TextStyle(fontSize: 11)),
              value: prefs.examAlertsEnabled,
              activeColor: GriColors.forestPrimary,
              onChanged: (val) => provider.setTelegramNotificationPreferences(
                prefs.copyWith(examAlertsEnabled: val),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Grievance Status Updates", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: const Text("Redressal and resolution alerts", style: TextStyle(fontSize: 11)),
              value: prefs.grievanceAlertsEnabled,
              activeColor: GriColors.forestPrimary,
              onChanged: (val) => provider.setTelegramNotificationPreferences(
                prefs.copyWith(grievanceAlertsEnabled: val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageHistoryCard(GriProvider provider, Color cardBg, bool isDark) {
    final messages = provider.telegramMessages;

    return Card(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history, size: 18, color: Colors.indigo),
                    const SizedBox(width: 8),
                    const Text(
                      "MESSAGE & DELIVERY LEDGER",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${messages.length} Records",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            if (messages.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "No messages recorded yet. Tap 'Test Alert' or interact with the bot on Telegram.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages.length > 5 ? 5 : messages.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (ctx, idx) {
                  final msg = messages[idx];
                  final isOut = msg.isOutbound;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isOut ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        size: 16,
                        color: isOut ? GriColors.forestPrimary : Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.content,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${isOut ? 'Outbound' : 'Inbound'} • ${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')} • ${msg.processingStatus}",
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          msg.processingStatus,
                          style: const TextStyle(fontSize: 9.5, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityAssuranceCard(Color cardBg, bool isDark) {
    return Card(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.verified_user_outlined, color: GriColors.forestPrimary, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Protected by Supabase Row Level Security (RLS) and SHA-256 cryptographic account linking. Telegram bot token is strictly isolated server-side.",
                style: TextStyle(fontSize: 11, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
