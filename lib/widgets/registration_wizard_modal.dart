import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gri_provider.dart';
import '../models/user_model.dart';
import '../utils/gri_colors.dart';

class RegistrationWizardModal extends StatefulWidget {
  const RegistrationWizardModal({super.key});

  @override
  State<RegistrationWizardModal> createState() => _RegistrationWizardModalState();
}

class _RegistrationWizardModalState extends State<RegistrationWizardModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _idController = TextEditingController();
  final _deptController = TextEditingController();
  final _programmeController = TextEditingController();
  final _yearController = TextEditingController();
  final _desigController = TextEditingController();
  final _researchController = TextEditingController();

  UserRole _selectedRole = UserRole.STUDENT;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _idController.dispose();
    _deptController.dispose();
    _programmeController.dispose();
    _yearController.dispose();
    _desigController.dispose();
    _researchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 680),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.app_registration, color: GriColors.forestPrimary),
                    SizedBox(width: 8),
                    Text(
                      "Institutional Registration",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => provider.closeRegistrationWizard(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Submit credentials to verify your role with the Registrar Directorate.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 14),

                      // Role Dropdown
                      const Text("Requested Role", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<UserRole>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: [
                          UserRole.STUDENT,
                          UserRole.FACULTY,
                          UserRole.SCHOLAR,
                          UserRole.COE_STAFF,
                          UserRole.STAFF,
                          UserRole.GUEST,
                        ].map((r) => DropdownMenuItem(value: r, child: Text(r.name))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedRole = val);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Full Official Name *",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      // Email & Mobile
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Institutional Email *",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              validator: (v) => (v == null || !v.contains('@')) ? "Valid email required" : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Mobile Number *",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              validator: (v) => (v == null || v.length < 10) ? "10 digits required" : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Institutional ID / Roll No
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: "Roll No / Employee ID / Gate Pass No *",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      // Department
                      TextFormField(
                        controller: _deptController,
                        decoration: InputDecoration(
                          labelText: "School / Department *",
                          hintText: "e.g. Computer Science, Rural Development",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      // Dynamic Fields based on Role
                      if (_selectedRole == UserRole.STUDENT) ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _programmeController,
                                decoration: InputDecoration(
                                  labelText: "Degree Programme",
                                  hintText: "M.C.A., B.Sc. Agri",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _yearController,
                                decoration: InputDecoration(
                                  labelText: "Year / Semester",
                                  hintText: "Sem IV / 2nd Year",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else if (_selectedRole == UserRole.SCHOLAR) ...[
                        TextFormField(
                          controller: _researchController,
                          decoration: InputDecoration(
                            labelText: "Doctoral Research Topic",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ] else if (_selectedRole == UserRole.FACULTY || _selectedRole == UserRole.STAFF) ...[
                        TextFormField(
                          controller: _desigController,
                          decoration: InputDecoration(
                            labelText: "Academic / Staff Designation",
                            hintText: "Associate Professor, Assistant Registrar",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => provider.closeRegistrationWizard(),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GriColors.forestPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      provider.submitRegistrationApplication(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        mobile: _mobileController.text.trim(),
                        id: _idController.text.trim(),
                        role: _selectedRole,
                        department: _deptController.text.trim(),
                        programme: _programmeController.text.trim(),
                        yearSemester: _yearController.text.trim(),
                        designation: _desigController.text.trim(),
                        researchTopic: _researchController.text.trim(),
                      );
                    }
                  },
                  child: const Text("Submit Application"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
