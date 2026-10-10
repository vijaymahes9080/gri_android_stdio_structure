import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../models/academic_models.dart';
import '../utils/gri_colors.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();
    final user = provider.currentUser;

    return RefreshIndicator(
      onRefresh: () => provider.triggerCloudSync(),
      color: GriColors.forestPrimary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Personalized Institutional Header Card
          Card(
            color: GriColors.forestPrimary,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage('assets/images/student_avatar.jpg'),
                            child: user == null ? const Icon(Icons.person, color: GriColors.forestPrimary) : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? "Vijay Pradhap",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${user?.rollNo ?? '2024-MS-4011'} • ${user?.department ?? 'Computer Science'}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => provider.toggleRoleSwitcher(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: GriColors.ochrePrimary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            provider.currentRole.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric("Semester", user?.semester ?? "Sem IV"),
                        Container(height: 24, width: 1, color: Colors.white30),
                        _buildMetric("CGPA", user?.cgpa ?? "8.92"),
                        Container(height: 24, width: 1, color: Colors.white30),
                        _buildMetric("Attendance", "87% (Eligible)"),
                        Container(height: 24, width: 1, color: Colors.white30),
                        _buildMetric("Hostel", user?.isHostelite == true ? "Kasturba" : "Day Scholar"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Urgent / Official Announcement Banner
          if (provider.circulars.isNotEmpty) ...[
            Builder(
              builder: (context) {
                final urgent = provider.circulars.firstWhere(
                  (c) => c.isUrgent,
                  orElse: () => provider.circulars.first,
                );
                return Card(
                  color: Colors.amber.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.amber.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.campaign, color: Colors.amber, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                urgent.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                urgent.summary,
                                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade800),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${urgent.issuedBy} • ${urgent.publishedDate}",
                                    style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                                  ),
                                  InkWell(
                                    onTap: () => provider.fetchHallTicket(),
                                    child: const Text(
                                      "Download Hall Ticket →",
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          // 3. Quick Action Hub (8 Key Modules)
          const Text(
            "QUICK CAMPUS SERVICES",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: GriColors.forestPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildQuickAction(
                icon: Icons.school,
                label: "Courses",
                color: GriColors.forestPrimary,
                onTap: () => provider.switchTab(NavigationTab.ACADEMICS),
              ),
              _buildQuickAction(
                icon: Icons.confirmation_number,
                label: "Hall Ticket",
                color: Colors.deepOrange,
                onTap: () => provider.fetchHallTicket(),
              ),
              _buildQuickAction(
                icon: Icons.map,
                label: "Campus Map",
                color: GriColors.tealSecondary,
                onTap: () => provider.switchTab(NavigationTab.CAMPUS),
              ),
              _buildQuickAction(
                icon: Icons.support_agent,
                label: "Grievances",
                color: Colors.indigo,
                onTap: () => provider.switchTab(NavigationTab.SERVICES),
              ),
              _buildQuickAction(
                icon: Icons.auto_awesome,
                label: "Ask AI",
                color: GriColors.ochrePrimary,
                onTap: () => provider.toggleAskAi(true),
              ),
              _buildQuickAction(
                icon: Icons.verified,
                label: "Documents",
                color: Colors.teal,
                onTap: () => provider.toggleDocumentCenter(true),
              ),
              _buildQuickAction(
                icon: Icons.badge,
                label: "Staff Portal",
                color: Colors.brown,
                onTap: () => provider.toggleFacultyPortal(true),
              ),
              _buildQuickAction(
                icon: Icons.account_balance,
                label: "Directory",
                color: Colors.blueGrey,
                onTap: () => provider.switchTab(NavigationTab.MORE),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Enrolled Courses & Attendance Snapshot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "MY COURSES & ATTENDANCE",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: GriColors.forestPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton(
                onPressed: () => provider.switchTab(NavigationTab.ACADEMICS),
                child: const Text("View All", style: TextStyle(fontSize: 12, color: GriColors.forestPrimary)),
              ),
            ],
          ),
          ...provider.courses.take(3).map((course) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GriColors.forestContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${course.attendancePercent}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: GriColors.forestPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${course.code}: ${course.title}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${course.instructor} • ${course.schedule}",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_task, color: GriColors.forestPrimary, size: 20),
                        tooltip: "Mark Attendance",
                        onPressed: () => provider.markAttendance(course.id),
                      ),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 16),

          // 5. Official University Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/official_banner.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(16),
                color: GriColors.forestPrimary,
                child: const Center(
                  child: Text(
                    "The Gandhigram Rural Institute — Education for Life",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
