import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class AskGriAiScreen extends StatefulWidget {
  const AskGriAiScreen({super.key});

  @override
  State<AskGriAiScreen> createState() => _AskGriAiScreenState();
}

class _AskGriAiScreenState extends State<AskGriAiScreen> {
  final _queryController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _suggestedPrompts = [
    "What is GRI's NAAC grade?",
    "Admissions and CUET process",
    "Library and e-resources",
    "Examination rules and e-SANAD",
    "Latest events and tenders",
    "Contact and campus location",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animate: false);
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (animate) {
      _scrollController.animateTo(
        maxScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(maxScroll);
    }
  }

  void _sendMessage(GriProvider provider, String text) {
    if (text.trim().isEmpty) return;
    provider.sendSahayakMessage(text.trim());
    _queryController.clear();
    Future.delayed(const Duration(milliseconds: 150), () => _scrollToBottom(animate: true));
    Future.delayed(const Duration(milliseconds: 700), () => _scrollToBottom(animate: true));
  }

  void _confirmClearHistory(BuildContext context, GriProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear Assistant History?"),
        content: const Text(
          "This will reset your conversation history with GRI-Sahayak and restore the baseline greeting. All institutional records remain unaffected.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: GriColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.clearSahayakHistory();
            },
            child: const Text("Clear History"),
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

    return Container(
      color: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      child: Column(
        children: [
          // AI Assistant Top Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/gri_sahayak_3d.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: GriColors.forestPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: GriColors.forestPrimary, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "GRI-Sahayak AI Assistant",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                          if (provider.sahayakMessages.length > 1) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: GriColors.forestPrimary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${provider.sahayakMessages.length} msgs",
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: GriColors.forestPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        "Grounded in verified GRI dataset • History saved",
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.sahayakMessages.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    tooltip: "Clear Chat History",
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () => _confirmClearHistory(context, provider),
                  ),
              ],
            ),
          ),

          // Quick Suggestions Carousel
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _suggestedPrompts.length,
              itemBuilder: (context, index) {
                final prompt = _suggestedPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GriPressable(
                    onTap: () => _sendMessage(provider, prompt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 0.8),
                      ),
                      child: Text(
                        prompt,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, color: borderColor),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              itemCount: provider.sahayakMessages.length,
              itemBuilder: (context, index) {
                final msg = provider.sahayakMessages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!msg.isUser) ...[
                        Container(
                          width: 26,
                          height: 26,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_awesome, size: 14, color: GriColors.forestPrimary),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? GriColors.forestPrimary
                                : cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: msg.isUser ? GriColors.forestPrimary : borderColor,
                              width: 0.8,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.text,
                                style: TextStyle(
                                  color: msg.isUser ? Colors.white : (isDark ? GriColors.darkOnSurface : GriColors.onSurface),
                                  fontSize: 12.5,
                                  height: 1.4,
                                ),
                              ),
                              if (msg.source != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Source: ${msg.source}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: msg.isUser ? Colors.white70 : (isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              if (!msg.isUser && msg.confidence < 1.0) ...[
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 10,
                                      color: GriColors.ochrePrimary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Confidence: ${(msg.confidence * 100).round()}% • ${msg.grounded ? 'grounded' : 'not grounded'}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 3),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  msg.timestamp,
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    color: msg.isUser
                                        ? Colors.white.withOpacity(0.65)
                                        : (isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (msg.isUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 26,
                          height: 26,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: isDark ? GriColors.darkSurface2 : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, size: 14, color: isDark ? Colors.white70 : Colors.black87),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Input Field Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              border: Border(top: BorderSide(color: borderColor, width: 0.8)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: "Ask about admissions, exams, hostel, circulars...",
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        filled: true,
                        fillColor: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: borderColor, width: 0.8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: borderColor, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: GriColors.forestPrimary, width: 1.2),
                        ),
                      ),
                      onSubmitted: (val) => _sendMessage(provider, val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GriPressable(
                    onTap: () => _sendMessage(provider, _queryController.text),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: GriColors.forestPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
