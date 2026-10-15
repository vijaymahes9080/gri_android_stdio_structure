import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../services/official_resource_registry.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class StudentServicesHubScreen extends StatefulWidget {
  const StudentServicesHubScreen({super.key});

  @override
  State<StudentServicesHubScreen> createState() => _StudentServicesHubScreenState();
}

class _StudentServicesHubScreenState extends State<StudentServicesHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _subjectController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = "Hostel Facility";
  bool _showGrievanceForm = false;

  // Mess rebate controllers
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _rebateReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _descController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _rebateReasonController.dispose();
    super.dispose();
  }

  void _showRebateDialog(BuildContext context, bool isDark, Color cardBg, Color borderColor) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? GriColors.darkSurface1 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Apply for Hostel Mess Rebate",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                "As per GRI Hostel Manual, rebate is sanctioned for continuous leave of 5 days or more with prior approval.",
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fromDateController,
                decoration: InputDecoration(
                  labelText: "From Date (DD/MM/YYYY)",
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _toDateController,
                decoration: InputDecoration(
                  labelText: "To Date (DD/MM/YYYY)",
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _rebateReasonController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Reason (Study Tour / Vacation / Medical)",
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GriPressable(
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mess rebate application recorded and forwarded to Chief Warden office."),
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
                        "Submit Application",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    return Column(
      children: [
        Container(
          color: isDark ? GriColors.darkSurface1 : Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
            unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            indicatorColor: GriColors.forestPrimary,
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(text: "Grievances"),
              Tab(text: "Bus Pass & Transport"),
              Tab(text: "Hostel & Mess"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 1. Grievance Redressal Tab
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "STUDENT GRIEVANCE REDRESSAL",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: GriColors.forestPrimary, letterSpacing: 0.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GriPressable(
                        onTap: () => setState(() => _showGrievanceForm = !_showGrievanceForm),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _showGrievanceForm ? Icons.close : Icons.add,
                                size: 14,
                                color: GriColors.forestPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _showGrievanceForm ? "Close Form" : "File Grievance",
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Grievance Submission Form
                  if (_showGrievanceForm) ...[
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
                          const Text(
                            "Submit New Grievance Docket",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              labelText: "Category",
                              labelStyle: const TextStyle(fontSize: 12),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            items: [
                              "Hostel Facility",
                              "Library Services",
                              "Academic & Classes",
                              "Examination & Marks",
                              "Transport & Bus",
                              "Campus Infrastructure",
                            ].map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _subjectController,
                            decoration: InputDecoration(
                              labelText: "Subject / Summary *",
                              labelStyle: const TextStyle(fontSize: 12),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Detailed Description *",
                              labelStyle: const TextStyle(fontSize: 12),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => setState(() => _showGrievanceForm = false),
                                child: Text("Cancel", style: TextStyle(color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant)),
                              ),
                              const SizedBox(width: 8),
                              GriPressable(
                                onTap: () {
                                  if (_subjectController.text.trim().isNotEmpty && _descController.text.trim().isNotEmpty) {
                                    provider.submitGrievance(
                                      _selectedCategory,
                                      _subjectController.text.trim(),
                                      _descController.text.trim(),
                                    );
                                    _subjectController.clear();
                                    _descController.clear();
                                    setState(() => _showGrievanceForm = false);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: GriColors.forestPrimary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "Submit Grievance",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Grievances List
                  ...provider.grievances.map((g) {
                    final isResolved = g.status == "RESOLVED";
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                g.ticketNumber,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: GriColors.forestPrimary),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isResolved ? Colors.green.withValues(alpha: 0.12) : Colors.amber.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  g.status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: isResolved ? Colors.green.shade800 : Colors.amber.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(g.subject, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 3),
                          Text(
                            g.description,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                            ),
                          ),
                          if (g.remarks.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "University Remark: ${g.remarks}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? GriColors.darkOnSurface : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),

              // 2. Bus Pass & Transport Tab
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // Digital Bus Pass Bento
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? GriColors.darkSurface1 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "GRI DIGITAL TRANSIT PASS",
                                style: TextStyle(
                                  color: GriColors.forestPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11.5,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Icon(Icons.directions_bus_outlined, size: 16, color: GriColors.forestPrimary),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.currentUser?.name ?? "Vijay Pradhap",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Pass No: BP-2026-NOV-812 • Roll: ${provider.currentUser?.rollNo ?? '2024-MS-4011'}",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Route: Dindigul / Chinnalapatti", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                    Text("Valid Thru: 31 Dec 2026", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "ACTIVE UNIVERSITY BUS ROUTES",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: GriColors.forestPrimary, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  ...provider.transportRoutes.map((route) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 0.8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: GriColors.forestPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.directions_bus, size: 18, color: GriColors.forestPrimary),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${route.routeNo}: ${route.routeName}",
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Bus: ${route.busNumber} • Driver: ${route.driverName} (${route.driverPhone})",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Departs: ${route.departureTime} • Returns: ${route.returnTime}",
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: GriColors.forestPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),

              // 3. Hostel & Mess Rebate Tab
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
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
                        const Row(
                          children: [
                            Icon(Icons.hotel_outlined, color: GriColors.forestPrimary, size: 20),
                            SizedBox(width: 8),
                            Text("Residential Hostels & Mess Allocation", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Allocated Accommodation: Block B, Room 204 (Kasturba Complex)",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Mess Scheme: Vegetarian • Committee: Student Elected Mess Representatives",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GriPressable(
                                onTap: () => _showRebateDialog(context, isDark, cardBg, borderColor),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: borderColor, width: 0.8),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.event_available, size: 13, color: GriColors.forestPrimary),
                                      SizedBox(width: 5),
                                      Text(
                                        "Apply for Mess Rebate",
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GriPressable(
                                onTap: () => OfficialResourceRegistry.openDocument(
                                  context,
                                  "GRI Hostel Manual PDF",
                                  "https://ruraluniv.ac.in/includes/infrastructure/hostel/HOSTEL_MANUAL.pdf",
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: borderColor, width: 0.8),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.picture_as_pdf_outlined, size: 13, color: GriColors.forestPrimary),
                                      SizedBox(width: 5),
                                      Text(
                                        "Hostel Manual",
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
