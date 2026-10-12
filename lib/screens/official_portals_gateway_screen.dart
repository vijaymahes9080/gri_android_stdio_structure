import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';

class OfficialPortalItem {
  final String id;
  final String title;
  final String subtitle;
  final String url;
  final String authority;
  final String audience;
  final IconData icon;
  final Color color;
  final String authRequirement;
  final bool isExternalGov;

  const OfficialPortalItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.authority,
    required this.audience,
    required this.icon,
    required this.color,
    required this.authRequirement,
    this.isExternalGov = false,
  });
}

class OfficialPortalsGatewayScreen extends StatelessWidget {
  const OfficialPortalsGatewayScreen({super.key});

  static const List<OfficialPortalItem> portals = [
    OfficialPortalItem(
      id: "portal_samarth",
      title: "Samarth@GRI Admission & Academic Engine",
      subtitle: "Centralized CUET UG/PG application, merit rank list & student lifecycle management",
      url: "https://ruraluniv.samarth.ac.in/index.php/site/login",
      authority: "Ministry of Education & GRI Admissions",
      audience: "Applicants & Enrolled Students",
      icon: Icons.account_balance,
      color: Colors.blue,
      authRequirement: "Requires CUET Application No. / Registered Email and Password",
      isExternalGov: true,
    ),
    OfficialPortalItem(
      id: "portal_student_erp",
      title: "GRI Integrated Student Portal",
      subtitle: "Semester grade cards, fee receipts, hostel allotments, and internal assessments",
      url: "https://portal.ruraluniv.ac.in/",
      authority: "Computer Centre & Examination Directorate",
      audience: "Enrolled Students",
      icon: Icons.school,
      color: GriColors.forestPrimary,
      authRequirement: "Requires Roll Number and Student Portal Password",
    ),
    OfficialPortalItem(
      id: "portal_esanad",
      title: "e-SANAD Digital Degree Attestation",
      subtitle: "Paperless document verification and apostille attestation with MEA",
      url: "https://www.portal.ruraluniv.ac.in/esanad",
      authority: "Ministry of External Affairs & CoE GRI",
      audience: "Graduating Students & Alumni",
      icon: Icons.verified_user,
      color: Colors.orange,
      authRequirement: "Requires e-SANAD Registration ID and Degree Certificate number",
      isExternalGov: true,
    ),
    OfficialPortalItem(
      id: "portal_tatkal",
      title: "COE Tatkal Scheme Expedited Portal",
      subtitle: "Fast-track provisional degree and academic transcript generation within 48 hours",
      url: "https://www.portal.ruraluniv.ac.in/tatkal",
      authority: "Controller of Examinations",
      audience: "Alumni & Final Year Candidates",
      icon: Icons.electric_bolt,
      color: Colors.deepOrange,
      authRequirement: "Requires Student Registration No. and Online SBI Collect Fee Receipt",
    ),
    OfficialPortalItem(
      id: "portal_attendance",
      title: "Faculty & Staff Bio-Attendance Portal",
      subtitle: "Real-time biometric attendance logs, CL/EL leave applications, and duty requests",
      url: "https://attendance.ruraluniv.ac.in/",
      authority: "Registrar Secretariat",
      audience: "Teaching & Non-Teaching Staff",
      icon: Icons.fingerprint,
      color: Colors.teal,
      authRequirement: "Requires Employee Staff Code and Biometric Portal PIN",
    ),
    OfficialPortalItem(
      id: "portal_apaar",
      title: "DigiLocker & APAAR ID Portal (ABC)",
      subtitle: "Academic Bank of Credits automated permanent academic account registry",
      url: "https://apaar.education.gov.in/",
      authority: "National Academic Depository (NAD)",
      audience: "All Indian Students",
      icon: Icons.credit_card,
      color: Colors.indigo,
      authRequirement: "Requires Aadhaar Authentication via DigiLocker OTP",
      isExternalGov: true,
    ),
    OfficialPortalItem(
      id: "portal_study_in_india",
      title: "Study in India Portal (MoE)",
      subtitle: "International foreign national admissions and cultural exchange programme onboarding",
      url: "https://www.studyinindia.gov.in/admission/registrations",
      authority: "Ministry of Education (Govt. of India)",
      audience: "International Applicants",
      icon: Icons.public,
      color: Colors.deepPurple,
      authRequirement: "Requires Passport / National Identity and SII Application ID",
      isExternalGov: true,
    ),
    OfficialPortalItem(
      id: "portal_webmail",
      title: "GRI Institutional Webmail",
      subtitle: "Official university Zimbra email client for faculties, research scholars, and departments",
      url: "https://webmail.ruraluniv.ac.in/",
      authority: "Computer Centre Network Operations",
      audience: "Faculty & Registered Scholars",
      icon: Icons.email,
      color: Colors.blueGrey,
      authRequirement: "Requires official @ruraluniv.ac.in email ID and password",
    ),
    OfficialPortalItem(
      id: "portal_phd_tracking",
      title: "GRIIMS Doctoral Research Tracking",
      subtitle: "Ph.D. registration coursework, DC meetings, comprehensive viva, and thesis tracking",
      url: "https://www.ruraluniv.ac.in/GRIIMS1/",
      authority: "Research and Development Cell (RDC)",
      audience: "Ph.D. Scholars & Research Supervisors",
      icon: Icons.science,
      color: Colors.cyan,
      authRequirement: "Requires Ph.D. Scholar Registration ID and Supervisor Code",
    ),
    OfficialPortalItem(
      id: "portal_pension",
      title: "GRI Pensioners Welfare Portal",
      subtitle: "Monthly pension slips, life certificate status, and medical reimbursement claims",
      url: "https://pension.ruraluniv.ac.in/",
      authority: "Finance & Accounts Wing",
      audience: "Retired Employees & Pensioners",
      icon: Icons.elderly,
      color: Colors.brown,
      authRequirement: "Requires PPO (Pension Payment Order) Number and Date of Birth",
    ),
  ];

  Future<void> _showLaunchDialog(BuildContext context, OfficialPortalItem portal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.security, color: portal.color, size: 24),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "External Portal Gateway",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You are navigating to an external, authorization-protected institutional portal:",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: portal.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: portal.color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    portal.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: portal.color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    portal.url,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                  const Divider(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.key, size: 14, color: Colors.orange),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          portal.authRequirement,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "For your security and privacy, authentication is performed directly on the secure server using your device's web browser.",
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: portal.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.open_in_browser, size: 16),
            label: const Text("Open in Browser"),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final uri = Uri.parse(portal.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Cannot launch browser for ${portal.url}"),
              backgroundColor: Colors.red.shade800,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Official Portals & Gateways", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Security Advisory Header Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield, color: Colors.amber.shade900, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Official Authentication Disclaimer",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber.shade900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "The portals listed below are official university and national government services that require personal credentials or OTPs. All sessions open in your trusted device browser.",
                        style: TextStyle(fontSize: 11, color: Colors.amber.shade900, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Portals List
          ...portals.map((portal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showLaunchDialog(context, portal),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: portal.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(portal.icon, color: portal.color, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            portal.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        ),
                                        if (portal.isExternalGov)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.indigo.shade50,
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: Colors.indigo.shade200),
                                            ),
                                            child: const Text(
                                              "Gov of India",
                                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.indigo),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      portal.subtitle,
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.25),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            children: [
                              Icon(Icons.group, size: 12, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                portal.audience,
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                "Launch Portal",
                                style: TextStyle(fontSize: 11, color: portal.color, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 10, color: portal.color),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
