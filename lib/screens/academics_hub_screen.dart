import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

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
    final provider = context.watch<GriProvider>();

    return Column(
      children: [
        // Tab Bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: GriColors.forestPrimary,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: GriColors.forestPrimary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                  Card(
                    color: GriColors.forestContainer.withOpacity(0.4),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: GriColors.forestPrimary),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "CBCS Regulations: 75% minimum attendance is mandatory for appearing in End Semester Examinations.",
                              style: TextStyle(fontSize: 11.5, color: GriColors.forestOnContainer),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...provider.courses.map((course) {
                    final isLow = course.attendancePercent < 75;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${course.code}: ${course.title}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isLow ? Colors.red.shade100 : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "${course.attendancePercent}%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: isLow ? Colors.red.shade800 : Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text("Instructor: ${course.instructor}", style: const TextStyle(fontSize: 12)),
                            Text("Schedule: ${course.schedule}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: course.attendancePercent / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isLow ? Colors.red : GriColors.forestPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Attended: ${course.attendedClasses} / ${course.totalClasses} classes (${course.credits} Credits)",
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                  icon: const Icon(Icons.check_circle_outline, size: 16),
                                  label: const Text("Mark Attendance", style: TextStyle(fontSize: 11)),
                                  onPressed: () => provider.markAttendance(course.id),
                                ),
                              ],
                            ),
                          ],
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
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.confirmation_number, color: GriColors.forestPrimary, size: 26),
                              SizedBox(width: 10),
                              Text(
                                "Controller of Examinations (CoE)",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "End Semester Examinations — November/December 2026",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Verified e-Hall Tickets are available for enrolled students who satisfy the 75% attendance criteria and have cleared exam fees.",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GriColors.forestPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text("Generate & View E-Hall Ticket"),
                            onPressed: () => provider.fetchHallTicket(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text("EXAMINATION TIMETABLE PREVIEW", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const CircleAvatar(backgroundColor: GriColors.forestContainer, child: Icon(Icons.event, color: GriColors.forestPrimary)),
                          title: const Text("MCA-401 Cloud Native Computing", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("16 Nov 2026 • 10:00 AM - 01:00 PM • Hall 201", style: TextStyle(fontSize: 11.5)),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const CircleAvatar(backgroundColor: GriColors.forestContainer, child: Icon(Icons.event, color: GriColors.forestPrimary)),
                          title: const Text("MCA-402 Mobile Application Engineering", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: const Text("19 Nov 2026 • 10:00 AM - 01:00 PM • Hall 204", style: TextStyle(fontSize: 11.5)),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const CircleAvatar(backgroundColor: GriColors.forestContainer, child: Icon(Icons.event, color: GriColors.forestPrimary)),
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
                  Card(
                    color: GriColors.ochreContainer.withOpacity(0.5),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cumulative Grade Point Average (CGPA)", style: TextStyle(fontSize: 12, color: GriColors.ochreOnContainer)),
                          SizedBox(height: 4),
                          Text("8.92 / 10.00", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: GriColors.ochreOnContainer)),
                          Text("Classification: First Class with Distinction", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...[
                    {"sem": "Semester III", "sgpa": "9.10", "credits": "24", "status": "Passed"},
                    {"sem": "Semester II", "sgpa": "8.85", "credits": "24", "status": "Passed"},
                    {"sem": "Semester I", "sgpa": "8.80", "credits": "22", "status": "Passed"},
                  ].map((s) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(s["sem"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text("Credits Earned: ${s['credits']} • ${s['status']}", style: const TextStyle(fontSize: 12)),
                          trailing: Text("SGPA: ${s['sgpa']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.forestPrimary)),
                        ),
                      )),
                ],
              ),

              // 4. Academic Calendar Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text("OFFICIAL ACADEMIC CALENDAR 2026-2027", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.forestPrimary)),
                  SizedBox(height: 10),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: GriColors.forestPrimary),
                          title: Text("Commencement of Odd Semester Classes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text("15 July 2026", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: GriColors.forestPrimary),
                          title: Text("First Continuous Assessment Test (CAT-I)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text("25 - 31 August 2026", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: GriColors.forestPrimary),
                          title: Text("End Semester Practical Examinations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text("02 - 08 November 2026", style: TextStyle(fontSize: 11.5)),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.calendar_month, color: GriColors.forestPrimary),
                          title: Text("End Semester Theory Examinations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text("16 November - 05 December 2026", style: TextStyle(fontSize: 11.5)),
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
