import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/official_resource_registry.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';

class CampusFacilitiesScreen extends StatefulWidget {
  const CampusFacilitiesScreen({super.key});

  @override
  State<CampusFacilitiesScreen> createState() => _CampusFacilitiesScreenState();
}

class _CampusFacilitiesScreenState extends State<CampusFacilitiesScreen> {
  String _selectedFilter = "all";
  bool _showMap = true;

  final List<Map<String, dynamic>> _enhancedFacilities = [
    {
      "id": "fac_lib",
      "name": "Dr. Radhakrishnan Central Library",
      "category": "Academic",
      "description": "Multi-storey library facility holding 1,80,000+ accessioned volumes, rare palm-leaf manuscripts, e-ShodhSindhu consortium digital database, and automated DELNET/NDL kiosks.",
      "location": "North Campus, Opposite Administration Block",
      "inCharge": "Dr. K. Ramasamy (University Librarian)",
      "timings": "08:00 AM - 08:00 PM (Monday to Saturday)",
      "image": "assets/images/library_front.jpg",
      "phone": "+914512452371",
      "docTitle": "Library Rules & Directives",
      "docUrl": "https://ruraluniv.ac.in/facilities?content=library",
    },
    {
      "id": "fac_health",
      "name": "GRI Rural Health Centre",
      "category": "Health",
      "description": "24x7 clinical outpatient centre providing emergency treatment, basic diagnostic dispensary, observation beds, and free health camps for students, staff, and surrounding rural community.",
      "location": "West Campus, Near Batlagundu Gate",
      "inCharge": "Dr. S. Meenakshi (Chief Medical Officer)",
      "timings": "Open 24 Hours (Emergency Line Active)",
      "image": "assets/images/health_centre.jpg",
      "phone": "+914512452371",
      "docTitle": "Health Centre Facilities",
      "docUrl": "https://ruraluniv.ac.in/facilities?content=servicess",
    },
    {
      "id": "fac_hostel",
      "name": "Residential Hostels & Dining Mess",
      "category": "Hostel",
      "description": "Fully furnished resident halls (Kasturba for Women, Tagore for Men, and Working Women Hostel) with solar hot water, 24x7 high-speed Wi-Fi, modern hygienic steam dining mess, and reading halls.",
      "location": "East Residential Enclave",
      "inCharge": "Dr. P. Balasubramaniam (Chief Warden)",
      "timings": "Open 24/7 (Gate curfews: 08:30 PM)",
      "image": "assets/images/student_avatar.jpg",
      "phone": "+914512452371",
      "docTitle": "Official Hostel Manual PDF",
      "docUrl": "https://ruraluniv.ac.in/includes/infrastructure/hostel/HOSTEL_MANUAL.pdf",
    },
    {
      "id": "fac_farm",
      "name": "ICAR Krishi Vigyan Kendra & Demonstration Farm",
      "category": "Agriculture",
      "description": "100-acre agricultural research and extension campus featuring protected shade-net polyhouses, vermicompost units, agro-meteorological station, dairy herd, and farmer training complex.",
      "location": "South Agriculture Research Campus",
      "inCharge": "Dr. K. S. Pushpa (Dean, Agricultural Sciences)",
      "timings": "06:00 AM - 06:00 PM",
      "image": null,
      "phone": "+914512452371",
      "docTitle": "KVK Operational Profile PDF",
      "docUrl": "https://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf",
    },
    {
      "id": "fac_cc",
      "name": "Central Computer Centre (CCC)",
      "category": "Academic",
      "description": "Campus IT backbone with 500+ high-end networked workstations, 1 Gbps National Knowledge Network (NKN) optical fiber connectivity, institutional cloud servers, and cyber security nodes.",
      "location": "Main Academic Quadrangle, Ground Floor",
      "inCharge": "Dr. V. Sivakumar (Director, CCC)",
      "timings": "08:30 AM - 07:30 PM (Mon-Fri)",
      "image": null,
      "phone": "+914512452371",
      "docTitle": "IT & Wi-Fi Policy",
      "docUrl": "https://ruraluniv.ac.in/facilities?content=cedt",
    },
    {
      "id": "fac_guesthouse",
      "name": "Faculty Guest House & Seminar Complex",
      "category": "Facilities",
      "description": "Air-conditioned VIP suites, executive boarding rooms, dining facility, and seminar banquet rooms for visiting professors, examiners, and institutional delegates.",
      "location": "Adjacent to Main Entrance Boulevard",
      "inCharge": "Estate Officer / Caretaker",
      "timings": "Check-in: 12:00 PM • Check-out: 11:00 AM",
      "image": null,
      "phone": "+914512452371",
      "docTitle": "Guest House Manual PDF",
      "docUrl": "https://ruraluniv.ac.in/includes/infrastructure/guesthouse/pdf/FGH_operational_Manual.pdf",
    },
    {
      "id": "fac_sports",
      "name": "Sports Stadium & Yoga Pavilion",
      "category": "Sports",
      "description": "Standard 400m track, football stadium, floodlit basketball court, indoor badminton pavilion, multi-gymnasium, and Sarvodaya Daily Prayer & Yoga Hall.",
      "location": "East Campus, Physical Education Wing",
      "inCharge": "Dr. P. U. Mahalingam (Director of Physical Education)",
      "timings": "05:30 AM - 07:30 PM",
      "image": null,
      "phone": "+914512452371",
      "docTitle": "Sports Directives",
      "docUrl": "https://ruraluniv.ac.in/facilities?content=phyedu",
    },
    {
      "id": "fac_cif",
      "name": "Central Instrumentation Facility (CIF)",
      "category": "Research",
      "description": "High-end analytical research suite equipped with 400 MHz Bruker NMR, Powder XRD, FE-SEM, UV-Vis-NIR Spectrophotometer, and Atomic Absorption Spectrometer (AAS).",
      "location": "Science Complex, Ground Floor",
      "inCharge": "Dr. S. Meenakshi (Dean, School of Sciences)",
      "timings": "09:00 AM - 05:30 PM",
      "image": null,
      "phone": "+914512452371",
      "docTitle": "CIF Instrumentation Guidelines",
      "docUrl": "https://ruraluniv.ac.in/facilities?content=central_i",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? GriColors.darkSurface1 : Colors.white;
    final borderColor = isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant;

    final filtered = _selectedFilter == "all"
        ? _enhancedFacilities
        : _enhancedFacilities.where((f) => (f["category"] as String).toLowerCase() == _selectedFilter.toLowerCase()).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CAMPUS INFRASTRUCTURE",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: GriColors.forestPrimary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Facilities & 300-Acre Campus Grounds",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            GriPressable(
              onTap: () => setState(() => _showMap = !_showMap),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showMap ? Icons.visibility_off_outlined : Icons.map_outlined,
                      size: 14,
                      color: GriColors.forestPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _showMap ? "Hide Map" : "Show Map",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Interactive Campus Geographic Card
        if (_showMap) ...[
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/library_front.jpg',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        color: GriColors.forestPrimary.withValues(alpha: 0.15),
                        child: const Center(child: Icon(Icons.apartment, size: 50, color: GriColors.forestPrimary)),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: Colors.redAccent, size: 12),
                            SizedBox(width: 4),
                            Text(
                              "10.2798° N, 77.9333° E",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gandhigram Campus — Dindigul District, Tamil Nadu",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Spanning 300+ green acres in Sirumalai foothills. Pedestrian walkways with campus transit facilities on NH 44 corridor.",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GriPressable(
                              onTap: () async {
                                final uri = Uri.parse("https://maps.google.com/?q=10.2798,77.9333");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor, width: 0.8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.navigation_outlined, size: 13, color: GriColors.forestPrimary),
                                    SizedBox(width: 5),
                                    Text(
                                      "Google Maps Route",
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
                              onTap: () async {
                                final uri = Uri.parse("tel:+914512452371");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor, width: 0.8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.call_outlined, size: 13, color: GriColors.forestPrimary),
                                    SizedBox(width: 5),
                                    Text(
                                      "Campus Exchange",
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
          ),
          const SizedBox(height: 14),
        ],

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              "all",
              "academic",
              "health",
              "hostel",
              "agriculture",
              "facilities",
              "sports",
              "research",
            ].map((cat) {
              final isSel = _selectedFilter == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GriPressable(
                  onTap: () => setState(() => _selectedFilter = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSel ? GriColors.forestPrimary : cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSel ? GriColors.forestPrimary : borderColor,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      cat.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSel
                            ? Colors.white
                            : (isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Facilities Bento Cards
        ...filtered.asMap().entries.map((entry) {
          final fac = entry.value;
          final hasImg = fac["image"] != null;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImg)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                    child: Image.asset(
                      fac["image"]!,
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              fac["name"]!,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: GriColors.forestPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (fac["category"] as String).toUpperCase(),
                              style: const TextStyle(
                                color: GriColors.forestPrimary,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        fac["description"]!,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 13, color: GriColors.forestPrimary),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    fac["location"]!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.schedule_outlined, size: 13, color: GriColors.ochrePrimary),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    fac["timings"]!,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 13, color: Colors.blueGrey),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    fac["inCharge"]!,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (fac["phone"] != null)
                            Expanded(
                              child: GriPressable(
                                onTap: () async {
                                  final uri = Uri.parse("tel:${fac["phone"]}");
                                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: borderColor, width: 0.8),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.call, size: 12, color: GriColors.forestPrimary),
                                      SizedBox(width: 4),
                                      Text(
                                        "Direct Call",
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (fac["phone"] != null && fac["docUrl"] != null)
                            const SizedBox(width: 8),
                          if (fac["docUrl"] != null)
                            Expanded(
                              child: GriPressable(
                                onTap: () => OfficialResourceRegistry.openDocument(
                                  context,
                                  fac["docTitle"]!,
                                  fac["docUrl"]!,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: borderColor, width: 0.8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.picture_as_pdf_outlined, size: 12, color: GriColors.forestPrimary),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          fac["docTitle"]!,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GriColors.forestPrimary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
          );
        }),
      ],
    );
  }
}
