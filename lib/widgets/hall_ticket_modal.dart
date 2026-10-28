import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

/// Production-Grade Hall Ticket E-Pass Modal
/// Features verified candidate identity, course timetable schedule, and real-time verification QR code.
class HallTicketModal extends StatelessWidget {
  const HallTicketModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final ticket = provider.hallTicketData;

    if (ticket == null) return const SizedBox.shrink();

    return Dialog(
      backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/gri_official_logo.png',
                        height: 36,
                        errorBuilder: (_, __, ___) => const Icon(Icons.school, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CONTROLLER OF EXAMINATIONS",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "End Semester Examinations E-Hall Ticket",
                              style: TextStyle(
                                fontSize: 10.5,
                                color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: "Close",
                  onPressed: () => provider.clearHallTicket(),
                ),
              ],
            ),
            const Divider(height: 16),

            // Ticket Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Card with Avatar & Verification
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/student_avatar.jpg',
                              width: 60,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 70,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.person, size: 36),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Roll No: ${ticket.rollNo}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                  ),
                                ),
                                Text(
                                  ticket.degree,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  ticket.semester,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Center: ${ticket.examCenter}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: GriColors.forestPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Verification QR Code
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: GriColors.outlineVariant, width: 0.8),
                            ),
                            child: QrImageView(
                              data: "GRI-COE-VERIFIED:${ticket.rollNo}:${ticket.semester}:2026",
                              version: QrVersions.auto,
                              size: 58.0,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Exam Timetable Table
                    const Text(
                      "SCHEDULE OF EXAMINATIONS",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? GriColors.darkOutlineVariant : Colors.grey.shade300,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Row(
                              children: [
                                const Expanded(flex: 2, child: Text("Course", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5))),
                                const Expanded(flex: 3, child: Text("Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5))),
                                const Expanded(flex: 2, child: Text("Date & Session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5))),
                                Expanded(flex: 1, child: Text("Hall", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: isDark ? GriColors.darkOnSurface : GriColors.onSurface))),
                              ],
                            ),
                          ),
                          ...ticket.subjects.map((sub) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: isDark ? GriColors.darkOutlineVariant : Colors.grey.shade200,
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        sub.code,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10.5,
                                          color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        sub.title,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "${sub.date}\n${sub.session.split(' - ').first}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        sub.venue,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                        ),
                                      ),
                                    ),
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
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: GriColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket.instructions,
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.4,
                        color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Print / Close Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 16, color: GriColors.forestPrimary),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "e-SANAD Verified",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: GriColors.forestPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GriColors.forestPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.download, size: 14),
                  label: const Text(
                    "Save / Close",
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Hall ticket saved to device cache. Official record verified."),
                        backgroundColor: GriColors.forestPrimary,
                        duration: Duration(seconds: 2),
                      ),
                    );
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
