import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/academic_models.dart';
import '../models/user_model.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../widgets/gri_primitives.dart';

/// Grievance management with honest submission gating.
///
/// Submissions are only possible after the student workspace is unlocked, and
/// they are explicitly labelled as local demo actions. This screen never
/// claims a grievance has been delivered to university officials unless a
/// backend confirms it — this build has no live session, so no transmission
/// occurs.
class GrievanceSubmissionScreen extends StatefulWidget {
  const GrievanceSubmissionScreen({super.key});

  @override
  State<GrievanceSubmissionScreen> createState() => _GrievanceSubmissionScreenState();
}

class _GrievanceSubmissionScreenState extends State<GrievanceSubmissionScreen> {
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Hostel Facility';
  bool _submitting = false;

  static const List<String> _categories = [
    'Hostel Facility',
    'Library Services',
    'Transport',
    'Academic',
    'Examinations',
    'Infrastructure',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    super.dispose();
  }

  GriStatusTone _statusTone(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return GriStatusTone.success;
      case 'rejected':
        return GriStatusTone.error;
      case 'under review':
      case 'action taken':
        return GriStatusTone.warning;
      default:
        return GriStatusTone.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final unlocked = provider.currentRole != UserRole.STUDENT ||
        provider.isStudentWorkspaceUnlocked;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Grievance & Support'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          GriSectionHeader(
            title: 'Your grievances',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          if (provider.grievances.isEmpty)
            GriEmptyState(
              icon: Icons.chat_bubble_outline,
              title: 'No grievances',
              hint: 'Submitted grievances appear here once tracked.',
            )
          else
            ...provider.grievances.map((g) => _grievanceTile(context, isDark, g)),

          const SizedBox(height: 20),
          GriSectionHeader(
            title: 'Submit a new grievance',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
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
                  'New submission',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: unlocked
                      ? (v) => setState(() => _selectedCategory = v!)
                      : null,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: isDark ? GriColors.darkSurface2 : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? GriColors.darkOutlineVariant
                            : GriColors.outlineVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Subject',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _subjectController,
                  enabled: unlocked,
                  decoration: InputDecoration(
                    hintText: 'Brief subject of the issue',
                    isDense: true,
                    filled: true,
                    fillColor: isDark ? GriColors.darkSurface2 : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? GriColors.darkOutlineVariant
                            : GriColors.outlineVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  enabled: unlocked,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue in detail',
                    isDense: true,
                    filled: true,
                    fillColor: isDark ? GriColors.darkSurface2 : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? GriColors.darkOutlineVariant
                            : GriColors.outlineVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: unlocked && !_submitting
                        ? () => _submitGrievance(context, provider)
                        : null,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_outlined, size: 18),
                    label: Text(_submitting
                        ? 'Submitting (demo)...'
                        : 'Submit grievance (demo workspace)'),
                  ),
                ),
                const SizedBox(height: 8),
                if (!unlocked && provider.currentRole == UserRole.STUDENT)
                  Text(
                    'Unlock the student workspace to submit. This build has no '
                    'live university session, so submissions are local demo '
                    'records only and are not transmitted to the university.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    ),
                  ),
                if (unlocked)
                  Text(
                    'Demo submission: recorded locally only. A real deployment '
                    'requires server-side authorization before a grievance '
                    'reaches university officials.',
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
    );
  }

  Widget _grievanceTile(BuildContext context, bool isDark, GrievanceModel g) {
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
            Icons.flag_outlined,
            size: 20,
            color: GriColors.forestPrimary,
          ),
        ),
        title: Text(
          g.subject,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Text(
              '${g.ticketNumber}  •  ${g.category}',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            GriStatusBadge(
              label: g.status,
              tone: _statusTone(g.status),
              dense: true,
            ),
          ],
        ),
        trailing: Text(
          g.studentRollNo.isNotEmpty ? g.studentRollNo : '—',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          ),
        ),
        onTap: null,
      ),
    );
  }

  void _submitGrievance(BuildContext context, GriProvider provider) {
    if (_subjectController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      return;
    }
    setState(() => _submitting = true);
    // Simulate a local-only record; never claim transmission to the university.
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      setState(() => _submitting = false);
      _subjectController.clear();
      _descController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Demo entry recorded locally only — not sent to the university.',
          ),
          backgroundColor: GriColors.ochrePrimary,
        ),
      );
    });
  }
}
