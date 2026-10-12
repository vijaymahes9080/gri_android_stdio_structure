import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_motion.dart';

class CampusFacilitiesScreen extends StatefulWidget {
  const CampusFacilitiesScreen({super.key});

  @override
  State<CampusFacilitiesScreen> createState() => _CampusFacilitiesScreenState();
}

class _CampusFacilitiesScreenState extends State<CampusFacilitiesScreen> {
  String _selectedFilter = "all";
  bool _showMap = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final seed = SeedDataService.instance;

    final allFacilities = seed.facilities.isNotEmpty
        ? seed.facilities
        : [
            FacilityItem(
              id: "fac_lib",
              name: "Dr. Radhakrishnan Central Library",
              category: "Academic",
              description: "State-of-the-art multi-storey library with 1,80,000+ volumes, classical Tamil palm-leaf archives, and IEEE/Springer digital access.",
              location: "North Campus, Opposite Administration Block",
              inCharge: "Dr. K. Ramasamy (University Librarian)",
              timings: "08:00 AM - 08:00 PM (Monday to Saturday)",
            ),
            FacilityItem(
              id: "fac_health",
              name: "GRI Rural Health Centre",
              category: "Health",
              description: "24x7 outpatient care, emergency medical officer, dispensary, free clinical diagnostic services for students and rural community.",
              location: "West Campus, Near Batlagundu Road Gate",
              inCharge: "Dr. S. Meenakshi (Chief Medical Officer)",
              timings: "24 Hours All Days",
            ),
            FacilityItem(
              id: "fac_hostel",
              name: "Residential Hostels (Kasturba & Tagore)",
              category: "Hostel",
              description: "Furnished resident halls with solar water heating, high-speed Wi-Fi, modern student dining mess, and reading rooms.",
              location: "East Residential Enclave",
              inCharge: "Dr. P. Balasubramaniam (Chief Warden)",
              timings: "Open 24/7 (Gate closes 08:30 PM)",
            ),
            FacilityItem(
              id: "fac_farm",
              name: "ICAR Agricultural Demonstration Farm & Dairy",
              category: "Agriculture",
              description: "100-acre organic research farm with protected polyhouses, vermicompost units, meteorological station, and dairy herd.",
              location: "South Agriculture Research Campus",
              inCharge: "Dr. K. S. Pushpa (Dean)",
              timings: "06:00 AM - 06:00 PM",
            ),
            FacilityItem(
              id: "fac_cc",
              name: "Central Computer Centre (CCC)",
              category: "Academic",
              description: "High-performance computing clusters, 500+ networked terminals, 1 Gbps NKN optical fiber backbone, and campus-wide Wi-Fi.",
              location: "Main Academic Quadrangle, Ground Floor",
              inCharge: "Dr. V. Sivakumar (Director, CCC)",
              timings: "08:30 AM - 07:30 PM (Mon-Fri)",
            ),
            FacilityItem(
              id: "fac_sports",
              name: "Gandhigram Sports Complex & Yoga Pavilion",
              category: "Sports",
              description: "Standard 400m track, football stadium, indoor badminton courts, dedicated Sarvodaya yoga hall, and gymnasium.",
              location: "East Campus, Adjacent to Physical Education Wing",
              inCharge: "Dr. P. U. Mahalingam (Director of Physical Education)",
              timings: "05:30 AM - 07:30 PM",
            ),
            FacilityItem(
              id: "fac_ibc",
              name: "Indo-Balkan Cultural Centre (IBC)",
              category: "Cultural",
              description: "International collaboration archive, European folk arts research lab, and international scholar guest suites.",
              location: "Heritage Enclave, Old Guest House Wing",
              inCharge: "Dr. K. Ravichandran (Coordinator)",
              timings: "09:30 AM - 05:30 PM",
            ),
            FacilityItem(
              id: "fac_cif",
              name: "Central Instrumentation Facility (CIF)",
              category: "Research",
              description: "Advanced characterization labs equipped with 400 MHz NMR, Powder XRD, FE-SEM, UV-Vis-NIR, and GC-MS for university researchers.",
              location: "Science Complex, Ground Floor",
              inCharge: "Dr. S. Meenakshi (Dean, School of Sciences)",
              timings: "09:00 AM - 05:30 PM",
            ),
          ];

    final filtered = _selectedFilter == "all"
        ? allFacilities
        : allFacilities.where((f) => f.category.toLowerCase().contains(_selectedFilter.toLowerCase())).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CAMPUS INFRASTRUCTURE",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  "Facilities & 300-Acre Campus Map",
                  style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            GriPressable(
              onTap: () => setState(() => _showMap = !_showMap),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_showMap ? Icons.visibility_off : Icons.map, size: 14, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      _showMap ? "Hide Map" : "Show Map",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Interactive Campus Map Card
        if (_showMap) ...[
          GriFadeSlideEntrance(
            delay: const Duration(milliseconds: 30),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/library_front.jpg',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          color: colorScheme.primary,
                          child: const Center(
                            child: Icon(Icons.apartment, size: 60, color: Colors.white70),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.redAccent, size: 14),
                              SizedBox(width: 4),
                              Text(
                                "10.2798° N, 77.9333° E",
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gandhigram Campus — Dindigul District, Tamil Nadu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Spanning 300+ green acres in Sirumalai foothills. Eco-friendly pedestrian walkways with e-buggy mobility.",
                          style: TextStyle(fontSize: 11.5, color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.navigation, size: 14),
                              label: const Text("Navigate via Google Maps", style: TextStyle(fontSize: 11)),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.phone, size: 14),
                              label: const Text("Security (+91 451 2452371)", style: TextStyle(fontSize: 11)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
              "sports",
              "research",
            ].map((cat) {
              final isSel = _selectedFilter == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat.toUpperCase()),
                  selected: isSel,
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                  side: BorderSide(
                    color: isSel ? colorScheme.primary : colorScheme.outlineVariant,
                    width: 0.8,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isSel ? Colors.white : colorScheme.onSurface,
                  ),
                  onSelected: (_) => setState(() => _selectedFilter = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // Facilities Cards
        ...filtered.asMap().entries.map((entry) {
          final index = entry.key;
          final fac = entry.value;
          return GriFadeSlideEntrance(
            delay: Duration(milliseconds: 40 + (index * 30)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            fac.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            fac.category,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      fac.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    Divider(height: 18, color: colorScheme.outlineVariant),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            fac.location,
                            style: TextStyle(fontSize: 11, color: colorScheme.onSurface),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: colorScheme.outline),
                        const SizedBox(width: 4),
                        Text(
                          fac.timings,
                          style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
