import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class FacultyStaffPortalScreen extends StatefulWidget {
  const FacultyStaffPortalScreen({super.key});

  @override
  State<FacultyStaffPortalScreen> createState() => _FacultyStaffPortalScreenState();
}

class _FacultyStaffPortalScreenState extends State<FacultyStaffPortalScreen> {
  final _reasonController = TextEditingController();
  String _selectedLeaveType = "Casual Leave (CL)";
  bool _showApplyLeave = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Faculty Bento Header
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: GriColors.forestPrimary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.person_outline, color: GriColors.forestPrimary, size: 28),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dr. R. Subramanian",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Senior Associate Professor • Computer Science",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "Employee ID: FAC-CS-108 • Ph.D. IIT Madras",
                        style: TextStyle(fontSize: 11, color: GriColors.forestPrimary, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Quick Portals Row (Samarth ERP & Webmail)
        Row(
          children: [
            Expanded(
              child: GriPressable(
                onTap: () async {
                  final uri = Uri.parse("https://webmail.ruraluniv.ac.in");
                  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 0.8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mail_outline, size: 14, color: GriColors.forestPrimary),
                      SizedBox(width: 5),
                      Text(
                        "Staff Webmail",
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GriPressable(
                onTap: () async {
                  final uri = Uri.parse("https://portal.ruraluniv.ac.in");
                  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 0.8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.token_outlined, size: 14, color: GriColors.forestPrimary),
                      SizedBox(width: 5),
                      Text(
                        "Samarth ERP Portal",
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Courses Taught
        const Text(
          "COURSES ASSIGNED THIS SEMESTER",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: GriColors.forestPrimary, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                title: const Text("MCA-402: Mobile Application Engineering & Flutter", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                subtitle: Text(
                  "Batch: M.C.A. 2024-26 • Enrolled: 42 Students • Hall 204",
                  style: TextStyle(fontSize: 11, color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
                ),
                onTap: () => _openRollCallModal(
                  context,
                  "MCA-402",
                  "Mobile Application Engineering & Flutter",
                  "M.C.A. 2024-26 (Hall 204)",
                ),
                trailing: GriPressable(
                  onTap: () => _openRollCallModal(
                    context,
                    "MCA-402",
                    "Mobile Application Engineering & Flutter",
                    "M.C.A. 2024-26 (Hall 204)",
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor, width: 0.8),
                    ),
                    child: const Text("Roll Call", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary)),
                  ),
                ),
              ),
              Divider(color: borderColor, height: 1),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                title: const Text("MCA-401: Cloud Native Microservices", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                subtitle: Text(
                  "Batch: M.C.A. 2024-26 • Enrolled: 42 Students • Lab 4",
                  style: TextStyle(fontSize: 11, color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
                ),
                onTap: () => _openRollCallModal(
                  context,
                  "MCA-401",
                  "Cloud Native Microservices",
                  "M.C.A. 2024-26 (Lab 4)",
                ),
                trailing: GriPressable(
                  onTap: () => _openRollCallModal(
                    context,
                    "MCA-401",
                    "Cloud Native Microservices",
                    "M.C.A. 2024-26 (Lab 4)",
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor, width: 0.8),
                    ),
                    child: const Text("Roll Call", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: GriColors.forestPrimary)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Staff Leave Management
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "STAFF LEAVE BALANCE & HISTORY",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: GriColors.forestPrimary, letterSpacing: 0.5),
            ),
            GriPressable(
              onTap: () => setState(() => _showApplyLeave = !_showApplyLeave),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: borderColor, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_showApplyLeave ? Icons.close : Icons.add, size: 13, color: GriColors.forestPrimary),
                    const SizedBox(width: 4),
                    Text(
                      _showApplyLeave ? "Close" : "Apply Leave",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Apply Leave Bento Form
        if (_showApplyLeave) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Submit Staff Leave Application", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedLeaveType,
                  decoration: InputDecoration(
                    labelText: "Leave Type",
                    labelStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    "Casual Leave (CL)",
                    "Earned Leave (EL)",
                    "Medical Leave (ML)",
                    "On Duty (OD) - Seminar / Valuation",
                  ].map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLeaveType = val);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: "Reason for Leave *",
                    labelStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GriPressable(
                      onTap: () {
                        final reason = _reasonController.text.trim();
                        if (reason.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a reason for the leave application."),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        provider.applyStaffLeave(_selectedLeaveType, "Tomorrow", "Next Day", reason);
                        _reasonController.clear();
                        setState(() => _showApplyLeave = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Leave request for $_selectedLeaveType submitted to Dean."),
                            backgroundColor: GriColors.forestPrimary,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: GriColors.forestPrimary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Submit to Dean",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Leave History Bento List
        ...provider.leaveRecords.map((lv) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${lv.leaveType} (${lv.days} Day)", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                        const SizedBox(height: 2),
                        Text(
                          "Period: ${lv.fromDate} to ${lv.toDate} • Reason: ${lv.reason}",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      lv.status,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5, color: Colors.green.shade800),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  void _openRollCallModal(
    BuildContext context,
    String code,
    String title,
    String batch,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.read<GriProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final students =
                provider.rollCallRosterFor(code).map((e) => e).toList();
            final presentCount =
                students.where((s) => s.status == "Present").length;
            final absentCount =
                students.where((s) => s.status == "Absent").length;
            final odCount = students.where((s) => s.status == "OD").length;

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? GriColors.darkSurface1 : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$code: $title",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "$batch • Attendance Register",
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Present: $presentCount", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11.5)),
                        Text("Absent: $absentCount", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11.5)),
                        Text("On-Duty: $odCount", style: const TextStyle(color: GriColors.ochrePrimary, fontWeight: FontWeight.bold, fontSize: 11.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Tap status pill to cycle (Present -> Absent -> OD):", style: TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 6),
                  Expanded(
                    child: students.isEmpty
                        ? Center(
                            child: Text(
                              "No roll register found for $code.",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? GriColors.darkOnSurfaceVariant
                                    : GriColors.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: students.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (c, idx) {
                              final st = students[idx];
                              final status = st.status;
                              Color color = Colors.green;
                              if (status == "Absent") color = Colors.red;
                              if (status == "OD") color = GriColors.ochrePrimary;

                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: GriColors.forestPrimary.withValues(alpha: 0.12),
                                  child: Text(
                                    st.name.substring(0, 1),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                                  ),
                                ),
                                title: Text(st.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                subtitle: Text("Roll: ${st.roll}", style: const TextStyle(fontSize: 10)),
                                trailing: InkWell(
                                  onTap: () {
                                    provider.setRollStatus(code, st.roll);
                                    setModalState(() {});
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: color, width: 0.8),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10.5),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GriColors.forestPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text(
                        "Submit & Sync to Samarth ERP",
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                      onPressed: students.isEmpty
                          ? null
                          : () {
                              final record = provider.submitRollCall(code, batch);
                              if (record == null) return;
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Register for $code recorded (${record.presentCount} Present, ${record.absentCount} Absent, ${record.odCount} OD) and queued for ERP sync.",
                                  ),
                                  backgroundColor: GriColors.forestPrimary,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
