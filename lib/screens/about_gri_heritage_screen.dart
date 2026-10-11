import 'package:flutter/material.dart';
import '../utils/gri_colors.dart';

class AboutGriHeritageScreen extends StatefulWidget {
  const AboutGriHeritageScreen({super.key});

  @override
  State<AboutGriHeritageScreen> createState() => _AboutGriHeritageScreenState();
}

class _AboutGriHeritageScreenState extends State<AboutGriHeritageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About GRI & Institutional Heritage"),
        backgroundColor: GriColors.forestPrimary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: GriColors.ochrePrimary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: "Vision & Mission"),
            Tab(text: "Genesis & Founders"),
            Tab(text: "Emblem & Life at GRI"),
            Tab(text: "Leadership Chronicle"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Vision & Mission Tab
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
                      Row(
                        children: [
                          Icon(Icons.visibility, color: GriColors.forestPrimary),
                          const SizedBox(width: 8),
                          Text(
                            "INSTITUTIONAL VISION",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: GriColors.forestOnContainer),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "To provide knowledge support to the rural society for its comprehensive development, by imparting higher education that inculcates democratic, Sarvodaya and Gandhian values with focus on research, extension and teaching.",
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.flag, color: GriColors.ochrePrimary),
                          const SizedBox(width: 8),
                          const Text(
                            "INSTITUTIONAL MISSION",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildBulletItem("Academic Excellence: Provide value-oriented higher education in rural context with equal emphasis on 3H (Head, Heart, Hand)."),
                      _buildBulletItem("Gandhian Ideals: Foster character, truth, non-violence, community living, and dignity of manual labour."),
                      _buildBulletItem("Rural Extension: Undertake action-oriented research and village outreach to solve real problems of rural India."),
                      _buildBulletItem("Sustainable Technology: Develop and disseminate eco-friendly, appropriate rural technologies."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "NAAC A+ ACCREDITATION & STATUS",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "The Gandhigram Rural Institute was conferred Deemed to be University status in 1976 under Section 3 of the UGC Act, 1956. GRI is re-accredited with 'A+' Grade by NAAC in its Cycle-4 assessment and ranked among top rural institutions under Category-I by the Ministry of Education, Government of India.",
                        style: TextStyle(fontSize: 12.5, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. Genesis & Founders Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "GENESIS OF GRI (1956)",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Inspired by Mahatma Gandhi's revolutionary concept of 'Nai Talim' (Basic Education), two dedicated Gandhian disciples — Dr. T. S. Soundram (daughter of TVS founder T. V. Sundaram Iyengar) and Dr. G. Ramachandran — established The Gandhigram Rural Institute in 1956 in the picturesque Sirumalai foothills.",
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "GRI pioneered the integration of 3 dimensions: Teaching, Research, and Extension, moving education from ivory towers directly into the villages. In 1976, the Government of India declared GRI as a Deemed to be University.",
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "REVERED FOUNDERS",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 12),
                      _buildFounderCard(
                        "Dr. T. S. Soundram",
                        "Co-Founder & Renowned Social Reformer",
                        "Trained physician, freedom fighter, and Union Deputy Minister of Education. She conceptualized rural maternal health and dedicated her life to Kasturba Hospital and women's upliftment.",
                      ),
                      const SizedBox(height: 10),
                      _buildFounderCard(
                        "Dr. G. Ramachandran",
                        "Co-Founder & Gandhian Ideologue",
                        "Close associate of Mahatma Gandhi, veteran freedom fighter, educationist, and Member of Parliament. Pioneer of Nai Talim village universities in India.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Emblem & Life at GRI Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "GRI EMBLEM SYMBOLOGY",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 12),
                      _buildEmblemSymbol("Charkha (Spinning Wheel)", "Symbolizes dignity of manual labour, economic self-reliance, and khadi heritage."),
                      _buildEmblemSymbol("Rising Sun", "Signifies illumination of rural minds through higher learning and intellectual awakening."),
                      _buildEmblemSymbol("Rural Cottage / Hut", "Represents the focal point of the university's academic commitment: village service."),
                      _buildEmblemSymbol("Open Book & Lamp", "Represents non-dogmatic knowledge, truth, and democratic education."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "DISTINCTIVE LIFE & PRACTICES AT GRI",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 12),
                      _buildBulletItem("Sarvodaya Prayer: Daily inter-religious prayer promoting universal brotherhood, peace, and mindfulness."),
                      _buildBulletItem("Shanti Sena (Peace Brigade): Youth wing trained in disaster relief, conflict resolution, and non-violent community leadership."),
                      _buildBulletItem("Village Placement Programme (VPP): Mandatory 7-day village immersion where students live in rural habitations and solve local needs."),
                      _buildBulletItem("Khadi Heritage: Promotion of hand-spun, hand-woven attire cultivating simplicity, eco-consciousness, and rural employment."),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 4. Leadership Chronicle Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "FORMER CHANCELLORS",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 10),
                      _buildChronicleItem("Dr. T. S. Soundram", "1976 - 1984"),
                      _buildChronicleItem("Smt. Soundaram Ramachandran", "1984 - 1989"),
                      _buildChronicleItem("Dr. M. Aram", "1989 - 1993"),
                      _buildChronicleItem("Dr. V. C. Kulandaiswamy", "1993 - 1998"),
                      _buildChronicleItem("Dr. K. Venkatasubramanian", "1998 - 2004"),
                      _buildChronicleItem("Dr. V. Kurien (Father of White Revolution)", "2004 - 2009"),
                      _buildChronicleItem("Dr. Renana Jhabvala", "2010 - 2015"),
                      _buildChronicleItem("Dr. P. S. Ramamohan Rao", "2015 - 2021"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "FORMER VICE-CHANCELLORS",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary),
                      ),
                      const SizedBox(height: 10),
                      _buildChronicleItem("Dr. G. Ramachandran", "1976 - 1979"),
                      _buildChronicleItem("Dr. M. Aram", "1979 - 1986"),
                      _buildChronicleItem("Dr. D. K. Oza", "1987 - 1990"),
                      _buildChronicleItem("Dr. T. R. Balakrishnan", "1990 - 1993"),
                      _buildChronicleItem("Dr. S. M. Ramasamy", "2007 - 2012"),
                      _buildChronicleItem("Dr. S. Natarajan", "2013 - 2018"),
                      _buildChronicleItem("Dr. M. A. Sudhir", "2018 - 2021"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GriColors.forestPrimary)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildFounderCard(String name, String role, String bio) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GriColors.forestPrimary)),
          Text(role, style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(bio, style: const TextStyle(fontSize: 12, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildEmblemSymbol(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: GriColors.ochrePrimary.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.star, size: 14, color: GriColors.ochrePrimary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                Text(desc, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChronicleItem(String name, String tenure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
            child: Text(tenure, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GriColors.forestPrimary)),
          ),
        ],
      ),
    );
  }
}
