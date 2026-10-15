import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

/// Clean, Production-Grade Contact, Transit & Emergency Services Screen
/// Features comprehensive directory contacts, NH 44 transit access, and verified 24/7 emergency hotlines.
class ContactCampusInfoScreen extends StatefulWidget {
  const ContactCampusInfoScreen({super.key});

  @override
  State<ContactCampusInfoScreen> createState() => _ContactCampusInfoScreenState();
}

class _ContactCampusInfoScreenState extends State<ContactCampusInfoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final seed = SeedDataService.instance;
    final contact = seed.universityContact;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "Contact & Transit Directory",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: "Directory"),
            Tab(text: "Transit & Access"),
            Tab(text: "Emergency Lines"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. University Directory Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              GriFadeSlideEntrance(
                delay: const Duration(milliseconds: 30),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? GriColors.darkSurface1 : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                      width: 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "CENTRAL CAMPUS",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: GriColors.forestPrimary,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            contact['accreditation'] ?? "NAAC 'A' Grade",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        contact["university_name"] as String? ?? "The Gandhigram Rural Institute",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        contact['address'] as String? ?? "Gandhigram, Dindigul District, Tamil Nadu - 624302",
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: isDark ? GriColors.darkOnSurfaceVariant : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildContactTile(isDark, "EPABX Board Lines", contact["epabx"] as String? ?? "0451-2452371 to 2452376", Icons.phone_outlined, "6 Lines connecting all Academic Units"),
              _buildContactTile(isDark, "University Official Fax", contact["fax"] as String? ?? "0451-2454466", Icons.print_outlined, "Administrative Block Secretariat"),
              _buildContactTile(isDark, "General Inquiries", contact["email_general"] as String? ?? "contact@ruraluniv.ac.in", Icons.email_outlined, "Central Registry & Student Helpdesk"),
              _buildContactTile(isDark, "Admissions Directorate", contact["email_admissions"] as String? ?? "admissions@ruraluniv.ac.in", Icons.school_outlined, "Directorate of Admissions Helpdesk"),
              _buildContactTile(isDark, "Registrar's Secretariat", contact["email_registrar"] as String? ?? "registrar@ruraluniv.ac.in", Icons.badge_outlined, "Administrative, Statutory & Legal Affairs"),
              _buildContactTile(isDark, "Controller of Examinations", contact["email_coe"] as String? ?? "coe@ruraluniv.ac.in", Icons.fact_check_outlined, "Examinations, Transcripts & Verifications"),
            ],
          ),

          // 2. Transit & Directions Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface1 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_bus_outlined, color: GriColors.forestPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "HOW TO REACH GANDHIGRAM CAMPUS",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildTransitRow(isDark, "Railway (Major)", "Dindigul Junction (DG) — 12 km", "Connected by frequent town buses (Bus No: 4, 7, Batlagundu bound) and round-the-clock taxis from Dindigul Central Bus Stand."),
                    _buildTransitRow(isDark, "Railway (Local)", "Ambathurai Station (ABI) — 2 km", "Walking distance or 5-min auto ride to the University Main Entrance Gate."),
                    _buildTransitRow(isDark, "Aviation", "Madurai Airport (IXM) — 65 km", "Pre-paid taxis available directly to Gandhigram via NH 44 (approx 1 hr 15 mins commute)."),
                    _buildTransitRow(isDark, "Roadways", "NH 44 (Madurai - Dindigul Corridor)", "All mofussil buses running between Madurai and Dindigul stop at Gandhigram bus stop upon request."),
                  ],
                ),
              ),
            ],
          ),

          // 3. Emergency Lines Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildEmergencyCard(isDark, "Rural Health Centre (24x7 Ambulance)", "+91 451 2452371 Ext: 250", "Dr. S. Meenakshi, CMO • 24 Hours Emergency Dispensary", Colors.red.shade700),
              _buildEmergencyCard(isDark, "Campus Security Control Room", "+91 451 2452371 Ext: 155", "Main Security Gate 1 • Round-the-clock patrol & surveillance", GriColors.forestPrimary),
              _buildEmergencyCard(isDark, "Chief Warden (Hostels)", "+91 451 2452371 Ext: 280", "Kasturba & Tagore Residential Enclaves", GriColors.ochrePrimary),
              _buildEmergencyCard(isDark, "National Anti-Ragging Helpline", "1800-180-5522 (Toll Free)", "24x7 UGC National Emergency Support & Grievance Desk", Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(bool isDark, String title, String detail, IconData icon, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: GriColors.forestPrimary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: GriColors.forestPrimary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitRow(bool isDark, String mode, String dist, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.25 : 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  mode,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5, color: GriColors.forestPrimary),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dist,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: isDark ? GriColors.darkOnSurface : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(bool isDark, String title, String phone, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.25 : 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.emergency_outlined, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? GriColors.darkOnSurface : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? GriColors.darkOnSurfaceVariant : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
