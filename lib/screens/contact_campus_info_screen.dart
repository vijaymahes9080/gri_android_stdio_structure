import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

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
    final seed = SeedDataService.instance;
    final contact = seed.universityContact;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact & Campus Directions"),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GriColors.ochrePrimary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: "University Directory"),
            Tab(text: "Transit & Directions"),
            Tab(text: "Emergency Lines"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. University Directory Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: GriColors.forestContainer.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact["university_name"] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: GriColors.forestOnContainer),
                      ),
                      const SizedBox(height: 6),
                      Text("Accreditation: ${contact['accreditation']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text("Address:\n${contact['address']}", style: const TextStyle(fontSize: 12.5, height: 1.4)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildContactTile("EPABX Board Lines", contact["epabx"] as String, Icons.phone, "6 Lines connecting all Departments"),
              _buildContactTile("University Fax", contact["fax"] as String, Icons.print, "Administrative Block"),
              _buildContactTile("General Inquiries", contact["email_general"] as String, Icons.email, "Central Registry"),
              _buildContactTile("Admissions Helpdesk", contact["email_admissions"] as String, Icons.school, "Directorate of Admissions"),
              _buildContactTile("Registrar's Secretariat", contact["email_registrar"] as String, Icons.badge, "Administrative & Legal Affairs"),
              _buildContactTile("Controller of Examinations", contact["email_coe"] as String, Icons.fact_check, "Examinations & Transcripts"),
            ],
          ),

          // 2. Transit & Directions Tab
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
                          Icon(Icons.directions, color: GriColors.forestPrimary),
                          SizedBox(width: 8),
                          Text("HOW TO REACH GRI CAMPUS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTransitRow("By Train (Major)", "Dindigul Junction (DG) — 12 km", "Connected by frequent town buses (Bus No: 4, 7, Batlagundu bound) and taxis from Dindigul Central Bus Stand."),
                      _buildTransitRow("By Train (Local)", "Ambathurai Railway Station (ABI) — 2 km", "Walking distance or 5-min auto ride to GRI Main Gate."),
                      _buildTransitRow("By Air", "Madurai International Airport (IXM) — 65 km", "Pre-paid taxis available directly to Gandhigram via NH 44 (approx 1 hr 15 mins)."),
                      _buildTransitRow("By Bus", "NH 44 (Madurai - Dindigul Highway)", "All mofussil buses running between Madurai and Dindigul stop at Gandhigram bus stop upon request."),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Emergency Lines Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildEmergencyCard("Rural Health Centre (24x7 Ambulance)", "+91 451 2452371 Ext: 250", "Dr. S. Meenakshi, CMO • 24 Hours Dispensary & Emergency Care", Colors.red.shade700),
              _buildEmergencyCard("Campus Security Control Room", "+91 451 2452371 Ext: 155", "Main Security Gate 1 • Round-the-clock patrol", GriColors.forestPrimary),
              _buildEmergencyCard("Chief Warden (Hostels)", "+91 451 2452371 Ext: 280", "Kasturba & Tagore Residential Halls", GriColors.ochrePrimary),
              _buildEmergencyCard("National Anti-Ragging Helpline", "1800-180-5522 (Toll Free)", "24x7 National Emergency Support", Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(String title, String detail, IconData icon, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: GriColors.forestPrimary.withOpacity(0.1),
          child: Icon(icon, color: GriColors.forestPrimary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detail, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: GriColors.forestPrimary)),
            Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitRow(String mode, String dist, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: GriColors.forestPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(mode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: GriColors.forestPrimary)),
              ),
              const SizedBox(width: 8),
              Text(dist, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 12, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(String title, String phone, String desc, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emergency, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: color))),
              ],
            ),
            const SizedBox(height: 6),
            Text(phone, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}
