import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

class AdminReviewModal extends StatefulWidget {
  const AdminReviewModal({super.key});

  @override
  State<AdminReviewModal> createState() => _AdminReviewModalState();
}

class _AdminReviewModalState extends State<AdminReviewModal> {
  final _queryController = TextEditingController();
  final _rejectController = TextEditingController();
  bool _showQueryInput = false;
  bool _showRejectInput = false;

  @override
  void dispose() {
    _queryController.dispose();
    _rejectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();
    final app = provider.selectedApplication;

    if (app == null) return const SizedBox.shrink();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 680),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fact_check, color: GriColors.forestPrimary),
                    const SizedBox(width: 8),
                    Text(
                      "Review Dossier: ${app.id}",
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => provider.closeAdminReviewModal(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Applicant Details Card
                    Card(
                      color: GriColors.surfaceVariant.withOpacity(0.4),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  app.fullName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: GriColors.forestPrimary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    app.requestedRole.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text("Email: ${app.email} • Mobile: ${app.mobile}", style: const TextStyle(fontSize: 12)),
                            Text("ID: ${app.institutionalId} • Dept: ${app.department}", style: const TextStyle(fontSize: 12)),
                            if (app.programme.isNotEmpty)
                              Text("Programme: ${app.programme} (${app.yearSemester})", style: const TextStyle(fontSize: 12)),
                            if (app.researchTopic.isNotEmpty)
                              Text("Research: ${app.researchTopic}", style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                            if (app.designation.isNotEmpty)
                              Text("Designation: ${app.designation}", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Current Status & Queries
                    Text("STATUS: ${app.status.name}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    if (app.adminQuery.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Registrar Clarification Query:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(app.adminQuery, style: const TextStyle(fontSize: 12)),
                            if (app.applicantResponse.isNotEmpty) ...[
                              const Divider(),
                              const Text("Applicant Response:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(app.applicantResponse, style: const TextStyle(fontSize: 12)),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    const Text("AUDIT HISTORY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary)),
                    const SizedBox(height: 6),
                    ...app.history.map((h) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.circle, size: 8, color: GriColors.forestPrimary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "${h.timestamp} — ${h.actor}: ${h.details}",
                                  style: const TextStyle(fontSize: 11.5),
                                ),
                              ),
                            ],
                          ),
                        )),

                    if (_showQueryInput) ...[
                      const SizedBox(height: 14),
                      TextField(
                        controller: _queryController,
                        decoration: InputDecoration(
                          labelText: "Query / Required Document Clarification",
                          hintText: "e.g. Please provide PG provisional register number",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],

                    if (_showRejectInput) ...[
                      const SizedBox(height: 14),
                      TextField(
                        controller: _rejectController,
                        decoration: InputDecoration(
                          labelText: "Reason for Rejection *",
                          hintText: "e.g. Credentials not found in official university rolls",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_showRejectInput && !_showQueryInput) ...[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.question_answer, size: 16),
                    label: const Text("Request Info"),
                    onPressed: () => setState(() => _showQueryInput = true),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: GriColors.error),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text("Reject"),
                    onPressed: () => setState(() => _showRejectInput = true),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GriColors.forestPrimary,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text("Approve Roll"),
                    onPressed: () => provider.adminApproveApplication(app.id),
                  ),
                ] else if (_showQueryInput) ...[
                  TextButton(
                    onPressed: () => setState(() => _showQueryInput = false),
                    child: const Text("Back"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: GriColors.ochrePrimary, foregroundColor: Colors.white),
                    onPressed: () {
                      if (_queryController.text.trim().isNotEmpty) {
                        provider.adminRequestMoreInformation(app.id, _queryController.text.trim());
                      }
                    },
                    child: const Text("Send Query"),
                  ),
                ] else if (_showRejectInput) ...[
                  TextButton(
                    onPressed: () => setState(() => _showRejectInput = false),
                    child: const Text("Back"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: GriColors.error, foregroundColor: Colors.white),
                    onPressed: () {
                      if (_rejectController.text.trim().isNotEmpty) {
                        provider.adminRejectApplication(app.id, _rejectController.text.trim());
                      }
                    },
                    child: const Text("Confirm Rejection"),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
