import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class AcademicsHubScreen extends StatefulWidget {
  const AcademicsHubScreen({super.key});

  @override
  State<AcademicsHubScreen> createState() => _AcademicsHubScreenState();
}

class _AcademicsHubScreenState extends State<AcademicsHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<GriProvider>();

    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant, width: 0.8),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicatorColor: colorScheme.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(text: "Courses & Attendance"),
              Tab(text: "Examinations & Hall Ticket"),
              Tab(text: "Grade Cards & SGPA"),
              Tab(text: "Academic Calendar"),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 1. Courses & Attendance Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GriFadeSlideEntrance(
                    delay: const Duration(milliseconds: 30),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2), width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: colorScheme.primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "CBCS Regulations: 75% minimum attendance is mandatory for appearing in End Semester Examinations.",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...provider.courses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final course = entry.value;
                    final isLow = course.attendancePercent < 75;
                    return GriFadeSlideEntrance(
                      delay: Duration(milliseconds: 50 + (index * 35)),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${course.code}: ${course.title}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isLow ? GriColors.warningContainer : GriColors.forestContainer,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "${course.attendancePercent}%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: isLow ? GriColors.warning : GriColors.forestPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Instructor: ${course.instructor}",
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                "Schedule: ${course.schedule}",
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: course.attendancePercent / 100,
                                  minHeight: 6,
                                  backgroundColor: colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isLow ? GriColors.warning : colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Attended: ${course.attendedClasses} / ${course.totalClasses} classes (${course.credits} Credits)",
                                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                  ),
                                  GriPressable(
                                    onTap: () => provider.markAttendance(course.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle_outline, size: 14, color: colorScheme.primary),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Mark Attendance",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),

              // 2. Examinations & Hall Ticket Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GriFadeSlideEntrance(
                    delay: const Duration(milliseconds: 30),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.confirmation_number, color: colorScheme.primary, size: 22),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Controller of Examinations (CoE)",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "End Semester Examinations — November/December 2026",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Verified e-Hall Tickets are available for enrolled students who satisfy the 75% attendance criteria and have cleared exam fees.",
                            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 14),
                          GriPressable(
                            onTap: () => provider.fetchHallTicket(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.download, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    "Generate & View E-Hall Ticket",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "EXAMINATION TIMETABLE PREVIEW",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(Icons.event, color: colorScheme.primary, size: 20),
                          ),
                          title: const Text("MCA-401 Cloud Native Computing", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("16 Nov 2026 • 10:00 AM - 01:00 PM • Hall 201", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 0.8, color: colorScheme.outlineVariant),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(Icons.event, color: colorScheme.primary, size: 20),
                          ),
                          title: const Text("MCA-402 Mobile Application Engineering", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("19 Nov 2026 • 10:00 AM - 01:00 PM • Hall 204", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 0.8, color: colorScheme.outlineVariant),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(Icons.event, color: colorScheme.primary, size: 20),
                          ),
                          title: const Text("MCA-403 Enterprise Database Systems", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("23 Nov 2026 • 10:00 AM - 01:00 PM • Hall 201", style: TextStyle(fontSize: 11.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 3. Grade Cards & SGPA Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GriFadeSlideEntrance(
                    delay: const Duration(milliseconds: 30),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: GriColors.ochreContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: GriColors.ochrePrimary.withValues(alpha: 0.3), width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cumulative Grade Point Average (CGPA)",
                            style: TextStyle(fontSize: 12, color: GriColors.ochreOnContainer),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "8.92 / 10.00",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: GriColors.ochreOnContainer,
                            ),
                          ),
                          Text(
                            "Classification: First Class with Distinction",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    {"sem": "Semester III", "sgpa": "9.10", "credits": "24", "status": "Passed"},
                    {"sem": "Semester II", "sgpa": "8.85", "credits": "24", "status": "Passed"},
                    {"sem": "Semester I", "sgpa": "8.80", "credits": "22", "status": "Passed"},
                  ].asMap().entries.map((entry) {
                    final index = entry.key;
                    final s = entry.value;
                    return GriFadeSlideEntrance(
                      delay: Duration(milliseconds: 60 + (index * 35)),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
                        ),
                        child: ListTile(
                          title: Text(
                            s["sem"]!,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: colorScheme.onSurface),
                          ),
                          subtitle: Text(
                            "Credits Earned: ${s['credits']} • ${s['status']}",
                            style: TextStyle(fontSize: 11.5, color: colorScheme.onSurfaceVariant),
                          ),
                          trailing: Text(
                            "SGPA: ${s['sgpa']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),

              // 4. Academic Calendar Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "OFFICIAL ACADEMIC CALENDAR 2026-2027",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: colorScheme.primary),
                          title: const Text("Commencement of Odd Semester Classes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("15 July 2026", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 0.8, color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: colorScheme.primary),
                          title: const Text("First Continuous Assessment Test (CAT-I)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("25 - 31 August 2026", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 0.8, color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: colorScheme.primary),
                          title: const Text("End Semester Practical Examinations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("02 - 08 November 2026", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 0.8, color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: colorScheme.primary),
                          title: const Text("End Semester Theory Examinations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("16 November - 05 December 2026", style: TextStyle(fontSize: 11.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
