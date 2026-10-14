import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../utils/gri_colors.dart';

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
    final provider = context.watch<GriProvider>();
    final user = provider.currentUser;
    final status = provider.activeAccountStatus;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            // Status Icon & Header
            Icon(
              status == AccountStatus.PENDING_APPROVAL
                  ? Icons.hourglass_top
                  : status == AccountStatus.UNDER_REVIEW
                      ? Icons.policy
                      : Icons.error_outline,
              size: 56,
              color: status == AccountStatus.PENDING_APPROVAL
                  ? GriColors.ochrePrimary
                  : status == AccountStatus.UNDER_REVIEW
                      ? Colors.orange
                      : GriColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              "Account Status: ${status.name.replaceAll('_', ' ')}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "Applicant: ${user?.name ?? 'User'} • Requested Role: ${user?.requestedRole ?? 'STUDENT'}",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            // Progress Stepper Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStep("1. Application Submitted", true, "Verified with Application ID: ${user?.applicationId.isNotEmpty == true ? user!.applicationId : 'APP-2026-9042'}", context),
                    _buildStep("2. Department Roll Verification", status != AccountStatus.PENDING_APPROVAL, "Cross-verified with Head of the Department", context),
                    _buildStep("3. Registrar Directorate Approval", status == AccountStatus.APPROVED, "Authorized for full institutional campus access", context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Clarification Form if Admin Query is present
            if (user?.adminClarificationQuery.isNotEmpty == true) ...[
              Card(
                color: Theme.of(context).brightness == Brightness.dark ? GriColors.darkSurface2 : Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? GriColors.darkOutlineVariant : Colors.amber.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Clarification Requested by Registrar:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.amberAccent : Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(user!.adminClarificationQuery, style: const TextStyle(fontSize: 12.5)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _responseController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "Enter your response or certificate reference...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: GriColors.forestPrimary, foregroundColor: Colors.white),
                          onPressed: () {
                            if (_responseController.text.trim().isNotEmpty) {
                              provider.submitApplicantClarification(user.applicationId, _responseController.text.trim());
                              _responseController.clear();
                            }
                          },
                          child: const Text("Submit Response"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Switch to approved demo user button
            OutlinedButton.icon(
              icon: const Icon(Icons.switch_account),
              label: const Text("Switch to Approved Student / Admin Account"),
              onPressed: () => provider.toggleRoleSwitcher(true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, bool isDone, String sub, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? GriColors.forestPrimary : (isDark ? Colors.grey.shade600 : Colors.grey),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDone
                        ? (isDark ? Colors.white : Colors.black87)
                        : (isDark ? Colors.grey.shade500 : Colors.grey),
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
