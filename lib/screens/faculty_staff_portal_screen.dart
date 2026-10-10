import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../utils/gri_colors.dart';

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
    final provider = context.watch<GriProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Faculty Header
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: GriColors.forestPrimary,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dr. R. Subramanian",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text(
                        "Senior Associate Professor • Computer Science",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        "Employee ID: FAC-CS-108 • Ph.D. IIT Madras",
                        style: TextStyle(fontSize: 11.5, color: GriColors.forestPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Courses Taught
        const Text("COURSES ASSIGNED THIS SEMESTER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text("MCA-402: Mobile Application Engineering & Compose", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text("Batch: M.C.A. 2024-26 • Enrolled: 42 Students • Hall 204", style: TextStyle(fontSize: 11.5)),
                trailing: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Class Roll Register opened.")));
                  },
                  child: const Text("Roll Call", style: TextStyle(fontSize: 11)),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text("MCA-401: Cloud Native Microservices", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text("Batch: M.C.A. 2024-26 • Enrolled: 42 Students • Lab 4", style: TextStyle(fontSize: 11.5)),
                trailing: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Class Roll Register opened.")));
                  },
                  child: const Text("Roll Call", style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Staff Leave Management
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("STAFF LEAVE BALANCE & HISTORY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: GriColors.forestPrimary)),
            TextButton.icon(
              icon: Icon(_showApplyLeave ? Icons.close : Icons.add, size: 16),
              label: Text(_showApplyLeave ? "Close" : "Apply Leave"),
              onPressed: () => setState(() => _showApplyLeave = !_showApplyLeave),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Apply Leave Form
        if (_showApplyLeave) ...[
          Card(
            color: Colors.amber.shade50.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Submit Staff Leave Application", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedLeaveType,
                    decoration: InputDecoration(
                      labelText: "Leave Type",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      "Casual Leave (CL)",
                      "Earned Leave (EL)",
                      "Medical Leave (ML)",
                      "On Duty (OD) - Seminar / Valuation",
                    ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLeaveType = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      labelText: "Reason for Leave *",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: GriColors.forestPrimary, foregroundColor: Colors.white),
                        onPressed: () {
                          if (_reasonController.text.trim().isNotEmpty) {
                            provider.applyStaffLeave(_selectedLeaveType, "Tomorrow", "Next Day", _reasonController.text.trim());
                            _reasonController.clear();
                            setState(() => _showApplyLeave = false);
                          }
                        },
                        child: const Text("Submit to Dean"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Leave History
        ...provider.leaveRecords.map((lv) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text("${lv.leaveType} (${lv.days} Day)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text("Period: ${lv.fromDate} to ${lv.toDate} • Reason: ${lv.reason}", style: const TextStyle(fontSize: 11.5)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    lv.status,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green.shade900),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
