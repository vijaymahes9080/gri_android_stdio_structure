import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key});

  @override
  State<ApplicationStatusScreen> createState() => _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  final _responseController = TextEditingController();

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final user = provider.currentUser;
    final status = provider.activeAccountStatus;
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shrinkWrap: true,
          children: [
            // Status Icon & Header
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (status == AccountStatus.PENDING_APPROVAL
                        ? GriColors.ochrePrimary
                        : status == AccountStatus.UNDER_REVIEW
                            ? Colors.orange
                            : GriColors.error)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                status == AccountStatus.PENDING_APPROVAL
                    ? Icons.hourglass_top_rounded
                    : status == AccountStatus.UNDER_REVIEW
                        ? Icons.policy_outlined
                        : Icons.error_outline_rounded,
                size: 32,
                color: status == AccountStatus.PENDING_APPROVAL
                    ? GriColors.ochrePrimary
                    : status == AccountStatus.UNDER_REVIEW
                        ? Colors.orange
                        : GriColors.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Account Status: ${status.name.replaceAll('_', ' ')}",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "Applicant: ${user?.name ?? 'User'} • Requested Role: ${user?.requestedRole ?? 'STUDENT'}",
              style: TextStyle(
                fontSize: 12,
                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            // Progress Stepper Bento Card
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStep(
                      "1. Application Submitted",
                      true,
                      "Verified with Application ID: ${user?.applicationId.isNotEmpty == true ? user!.applicationId : 'APP-2026-9042'}",
                      isDark,
                    ),
                    _buildStep(
                      "2. Department Roll Verification",
                      status != AccountStatus.PENDING_APPROVAL,
                      "Cross-verified with Head of the Department",
                      isDark,
                    ),
                    _buildStep(
                      "3. Registrar Directorate Approval",
                      status == AccountStatus.APPROVED,
                      "Authorized for full institutional campus access",
                      isDark,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Clarification Form if Admin Query is present
            if (user?.adminClarificationQuery.isNotEmpty == true) ...[
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF241E15) : const Color(0xFFFFFBEA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF4A3E20) : const Color(0xFFFFE58F),
                    width: 0.8,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Clarification Requested by Registrar:",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: GriColors.ochrePrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(user!.adminClarificationQuery, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _responseController,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: "Enter your response or certificate reference...",
                          hintStyle: const TextStyle(fontSize: 11.5),
                          filled: true,
                          fillColor: cardBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor, width: 0.8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GriPressable(
                          onTap: () {
                            if (_responseController.text.trim().isNotEmpty) {
                              provider.submitApplicantClarification(user.applicationId, _responseController.text.trim());
                              _responseController.clear();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Submit Response",
                              style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Switch to approved demo user button
            GriPressable(
              onTap: () => provider.toggleRoleSwitcher(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 0.8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.switch_account_outlined, size: 16, color: GriColors.forestPrimary),
                    SizedBox(width: 6),
                    Text(
                      "Switch to Student / Faculty / Admin Role",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, bool isDone, String sub, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: isDone ? GriColors.forestPrimary : (isDark ? Colors.grey.shade600 : Colors.grey),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: isDone
                        ? (isDark ? GriColors.darkOnSurface : GriColors.onSurface)
                        : (isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  sub,
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
}
