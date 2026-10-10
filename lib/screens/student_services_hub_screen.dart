import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

class StudentServicesHubScreen extends StatefulWidget {
  const StudentServicesHubScreen({super.key});

  @override
  State<StudentServicesHubScreen> createState() => _StudentServicesHubScreenState();
}

class _StudentServicesHubScreenState extends State<StudentServicesHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // New Grievance Form Controllers
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = "Hostel Facility";
  bool _showGrievanceForm = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: GriColors.forestPrimary,
            unselectedColor: Colors.grey.shade600,
            indicatorColor: GriColors.forestPrimary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "STUDENT GRIEVANCE REDRESSAL",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.forestPrimary),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GriColors.forestPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: Text(_showGrievanceForm ? "Close Form" : "File Grievance"),
                        onPressed: () => setState(() => _showGrievanceForm = !_showGrievanceForm),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Grievance Submission Form
                  if (_showGrievanceForm) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Submit New Grievance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: InputDecoration(
                                labelText: "Category",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: [
                                "Hostel Facility",
                                "Library Services",
                                "Academic & Classes",
                                "Examination & Marks",
                                "Transport & Bus",
                                "Campus Infrastructure",
                              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCategory = val);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _subjectController,
                              decoration: InputDecoration(
                                labelText: "Subject / Summary *",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _descController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: "Detailed Description *",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => setState(() => _showGrievanceForm = false),
                                  child: const Text("Cancel"),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: GriColors.forestPrimary,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
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
                                  child: const Text("Submit Grievance"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Grievances List
                  ...provider.grievances.map((g) {
                    final isResolved = g.status == "RESOLVED";
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
                                  g.ticketNumber,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.forestPrimary),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isResolved ? Colors.green.shade100 : Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    g.status,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: isResolved ? Colors.green.shade800 : Colors.amber.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(g.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(g.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                            if (g.remarks.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "University Remark: ${g.remarks}",
                                  style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),

              // 2. Bus Pass & Transport Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Digital Bus Pass
                  Card(
                    color: GriColors.forestPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "GRI DIGITAL BUS PASS",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Icon(Icons.directions_bus, color: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            provider.currentUser?.name ?? "Vijay Pradhap",
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Pass No: BP-2026-NOV-812 • Roll: ${provider.currentUser?.rollNo ?? '2024-MS-4011'}",
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Route: Batlagundu / Dindigul", style: TextStyle(color: Colors.white, fontSize: 11.5)),
                                Text("Valid Thru: 31 Dec 2026", style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("ACTIVE UNIVERSITY BUS ROUTES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary)),
                  const SizedBox(height: 8),
                  ...provider.transportRoutes.map((route) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(backgroundColor: GriColors.forestContainer, child: Icon(Icons.directions_bus, color: GriColors.forestPrimary)),
                          title: Text("${route.routeNo}: ${route.routeName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text("Bus: ${route.busNumber} • Driver: ${route.driverName} (${route.driverPhone})\nDeparture: ${route.departureTime} • Return: ${route.returnTime}", style: const TextStyle(fontSize: 11.5)),
                          isThreeLine: true,
                        ),
                      )),
                ],
              ),

              // 3. Hostel & Mess Rebate Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.hotel, color: GriColors.forestPrimary, size: 24),
                              SizedBox(width: 8),
                              Text("Residential Hostels & Mess", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text("Allocated Room: Block B, Room 204 (Kasturba Complex)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const Text("Mess Type: Vegetarian • Committee: Student Elected", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: GriColors.forestPrimary, foregroundColor: Colors.white),
                            icon: const Icon(Icons.event_busy, size: 16),
                            label: const Text("Apply for Mess Rebate (Festival / Leave)"),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Mess rebate application window opens on 15th of each month.")),
                              );
                            },
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
      ],
    );
  }
}
