import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

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
    final provider = context.watch<GriProvider>();

    return Column(
      children: [
        // AI Assistant Top Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: GriColors.forestContainer.withOpacity(0.4),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/gri_sahayak_3d.jpg',
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const CircleAvatar(
                    backgroundColor: GriColors.forestPrimary,
                    child: Icon(Icons.auto_awesome, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "GRI-Sahayak AI Assistant",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                    ),
                    Text(
                      "Powered by Official GRI Institutional Repository (ruraluniv.ac.in)",
                      style: TextStyle(fontSize: 10.5, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Quick Suggestions
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            itemCount: _suggestedPrompts.length,
            itemBuilder: (context, index) {
              final prompt = _suggestedPrompts[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(prompt, style: const TextStyle(fontSize: 11)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  onPressed: () => _sendMessage(provider, prompt),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),

        // Messages List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: provider.sahayakMessages.length,
            itemBuilder: (context, index) {
              final msg = provider.sahayakMessages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!msg.isUser) ...[
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: GriColors.forestPrimary,
                        child: Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: msg.isUser ? GriColors.forestPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isUser ? Colors.white : Colors.black87,
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                            if (msg.source != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                "Source: ${msg.source}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: msg.isUser ? Colors.white70 : Colors.grey.shade600,
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
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.person, size: 14, color: Colors.black87),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // Input Field
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      hintText: "Ask about admissions, exams, hostel, circulars...",
                      hintStyle: const TextStyle(fontSize: 12.5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onSubmitted: (val) => _sendMessage(provider, val),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.filled(
                    backgroundColor: GriColors.forestPrimary,
                  ),
                  icon: const Icon(Icons.send, size: 18),
                  onPressed: () => _sendMessage(provider, _queryController.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
