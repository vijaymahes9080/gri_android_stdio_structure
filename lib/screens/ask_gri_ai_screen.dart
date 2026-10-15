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
    "Admissions 2026 eligibility?",
    "Attendance rules for exam?",
    "Hostel facilities and mess rebate",
    "Bus routes from Dindigul",
    "Library hours and e-resources",
    "Nai Talim philosophy of GRI",
  ];

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(GriProvider provider, String text) {
    if (text.trim().isEmpty) return;
    provider.sendSahayakMessage(text.trim());
    _queryController.clear();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
                      const Text(
                        "GRI-Sahayak AI Assistant",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        "Powered by Official GRI Institutional Repository (ruraluniv.ac.in)",
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
