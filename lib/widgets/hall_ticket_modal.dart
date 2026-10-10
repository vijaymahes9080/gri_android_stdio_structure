import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

class HallTicketModal extends StatelessWidget {
  const HallTicketModal({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();
    final ticket = provider.hallTicketData;

    if (ticket == null) return const SizedBox.shrink();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/gri_official_logo.png',
                      height: 36,
                      errorBuilder: (_, __, ___) => const Icon(Icons.school, color: GriColors.forestPrimary),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CONTROLLER OF EXAMINATIONS",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.forestPrimary),
                        ),
                        Text(
                          "End Semester Examinations E-Hall Ticket",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => provider.clearHallTicket(),
                ),
              ],
            ),
            const Divider(),

            // Ticket Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Card with Avatar
                    Card(
                      color: GriColors.surfaceVariant.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/student_avatar.jpg',
                                width: 64,
                                height: 74,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 64,
                                  height: 74,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.person, size: 40),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.studentName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text("Roll No: ${ticket.rollNo}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                                  Text(ticket.degree, style: const TextStyle(fontSize: 12)),
                                  Text(ticket.semester, style: const TextStyle(fontSize: 11.5, color: Colors.black87)),
                                  const SizedBox(height: 2),
                                  Text("Center: ${ticket.examCenter}", style: const TextStyle(fontSize: 11, color: GriColors.forestPrimary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Exam Timetable Table
                    const Text(
                      "SCHEDULE OF EXAMINATIONS",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            color: GriColors.forestContainer.withOpacity(0.4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: const Row(
                              children: [
                                Expanded(flex: 2, child: Text("Course", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(flex: 3, child: Text("Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(flex: 2, child: Text("Date & Session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(flex: 1, child: Text("Hall", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                              ],
                            ),
                          ),
                          ...ticket.subjects.map((sub) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(sub.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                    Expanded(flex: 3, child: Text(sub.title, style: const TextStyle(fontSize: 10.5))),
                                    Expanded(flex: 2, child: Text("${sub.date}\n${sub.session.split(' - ').first}", style: const TextStyle(fontSize: 10))),
                                    Expanded(flex: 1, child: Text(sub.venue, style: const TextStyle(fontSize: 10.5))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Candidate Instructions
                    const Text(
                      "EXAMINATION RULES & INSTRUCTIONS",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket.instructions,
                      style: const TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Print / Close Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.qr_code, size: 28, color: Colors.grey.shade700),
                    const SizedBox(width: 6),
                    const Text("e-SANAD Verified", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GriColors.forestPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text("Save / Print E-Ticket"),
                  onPressed: () {
                    provider.clearHallTicket();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
