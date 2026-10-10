import 'package:flutter/material.dart';
import '../services/seed_data_service.dart';
import '../utils/gri_colors.dart';

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
          ];

    final filtered = allFacilities.where((f) {
      if (_selectedFilter == "all") return true;
      return f.category.toLowerCase().contains(_selectedFilter.toLowerCase());
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Map Toggle & Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "GRI CAMPUS FACILITIES & MAP",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GriColors.forestPrimary),
            ),
            TextButton.icon(
              icon: Icon(_showMap ? Icons.view_list : Icons.map, size: 18),
              label: Text(_showMap ? "Hide Map" : "Show Map"),
              onPressed: () => setState(() => _showMap = !_showMap),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Interactive Campus Map Card
        if (_showMap) ...[
          Card(
            clipBehavior: Clip.antiAlias,
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
                        color: Colors.green.shade900,
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gandhigram Campus — Dindigul District, Tamil Nadu",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Spanning 300+ green acres in Sirumalai foothills. Eco-friendly pedestrian walkways with e-buggy mobility.",
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.navigation, size: 15),
                            label: const Text("Navigate via Google Maps", style: TextStyle(fontSize: 11.5)),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.phone, size: 15),
                            label: const Text("Security (+91 451 2452371)", style: TextStyle(fontSize: 11.5)),
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
            ].map((cat) {
              final isSel = _selectedFilter == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat.toUpperCase()),
                  selected: isSel,
                  selectedColor: GriColors.forestPrimary,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSel ? Colors.white : Colors.black87,
                  ),
                  onSelected: (_) => setState(() => _selectedFilter = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Facilities Cards
        ...filtered.map((fac) => Card(
              margin: const EdgeInsets.only(bottom: 12),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: GriColors.forestContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            fac.category,
                            style: const TextStyle(
                              color: GriColors.forestPrimary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      fac.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.3),
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: GriColors.forestPrimary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            fac.location,
                            style: const TextStyle(fontSize: 11, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          fac.timings,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
