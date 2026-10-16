import 'package:flutter/material.dart';
import '../utils/gri_colors.dart';
import '../services/official_resource_registry.dart';

/// Production-Grade Heritage & Institutional Dossier Screen
/// Covers Vision & Mission, Genesis & Founders, Emblem Symbology, and Leadership Chronicle.
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text(
          "About GRI & Heritage",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: GriColors.forestPrimary,
          indicatorWeight: 2.5,
          labelColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
          unselectedLabelColor: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildContentCard(
                context,
                title: "INSTITUTIONAL VISION",
                icon: Icons.visibility,
                iconColor: GriColors.forestPrimary,
                child: const Text(
                  "To provide knowledge support to the rural society for its comprehensive development, by imparting higher education that inculcates democratic, Sarvodaya and Gandhian values with focus on research, extension and teaching.",
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
              const SizedBox(height: 12),
              _buildContentCard(
                context,
                title: "INSTITUTIONAL MISSION",
                icon: Icons.flag,
                iconColor: GriColors.ochrePrimary,
                child: Column(
                  children: [
                    _buildBulletItem("Academic Excellence: Provide value-oriented higher education in rural context with equal emphasis on 3H (Head, Heart, Hand)."),
                    _buildBulletItem("Gandhian Ideals: Foster character, truth, non-violence, community living, and dignity of manual labour."),
                    _buildBulletItem("Rural Extension: Undertake action-oriented research and village outreach to solve real problems of rural India."),
                    _buildBulletItem("Sustainable Technology: Develop and disseminate eco-friendly, appropriate rural technologies."),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildContentCard(
                context,
                title: "NAAC 'A' GRADE & DEEMED STATUS",
                icon: Icons.workspace_premium,
                iconColor: GriColors.forestPrimary,
                child: const Text(
                  "The Gandhigram Rural Institute was conferred Deemed to be University status in 1976 under Section 3 of the UGC Act, 1956. GRI is re-accredited with 'A' Grade by NAAC in its Cycle-4 assessment and ranked among top rural institutions under Category-I by the Ministry of Education, Government of India.",
                  style: TextStyle(fontSize: 12.5, height: 1.45),
                ),
              ),
            ],
          ),

          // 2. Genesis & Founders Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildContentCard(
                context,
                title: "GENESIS OF GRI (1956)",
                icon: Icons.history_edu,
                iconColor: GriColors.forestPrimary,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inspired by Mahatma Gandhi's revolutionary concept of 'Nai Talim' (Basic Education), two dedicated Gandhian disciples — Dr. T. S. Soundram (daughter of TVS founder T. V. Sundaram Iyengar) and Dr. G. Ramachandran — established The Gandhigram Rural Institute in 1956 in the picturesque Sirumalai foothills.",
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "GRI pioneered the integration of 3 dimensions: Teaching, Research, and Extension, moving education from ivory towers directly into the villages. In 1976, the Government of India declared GRI as a Deemed to be University.",
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildContentCard(
                context,
                title: "REVERED FOUNDERS",
                icon: Icons.group,
                iconColor: GriColors.forestPrimary,
                child: Column(
                  children: [
                    _buildFounderCard(
                      context,
                      "Dr. T. S. Soundram",
                      "Co-Founder & Renowned Social Reformer",
                      "Trained physician, freedom fighter, and Union Deputy Minister of Education. She conceptualized rural maternal health and dedicated her life to Kasturba Hospital and women's upliftment.",
                    ),
                    const SizedBox(height: 10),
                    _buildFounderCard(
                      context,
                      "Dr. G. Ramachandran",
                      "Co-Founder & Gandhian Ideologue",
                      "Close associate of Mahatma Gandhi, veteran freedom fighter, educationist, and Member of Parliament. Pioneer of Nai Talim village universities in India.",
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 3. Emblem & Life at GRI Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildContentCard(
                context,
                title: "GRI EMBLEM SYMBOLOGY",
                icon: Icons.shield,
                iconColor: GriColors.forestPrimary,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: GriColors.ochrePrimary.withValues(alpha: 0.3),
                            width: 1.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: OfficialResourceRegistry.buildImage(
                            "IMG_OFFICIAL_CREST",
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    _buildEmblemSymbol(context, "Charkha (Spinning Wheel)", "Symbolizes dignity of manual labour, economic self-reliance, and khadi heritage."),
                    _buildEmblemSymbol(context, "Rising Sun", "Signifies illumination of rural minds through higher learning and intellectual awakening."),
                    _buildEmblemSymbol(context, "Rural Cottage / Hut", "Represents the focal point of the university's academic commitment: village service."),
                    _buildEmblemSymbol(context, "Open Book & Lamp", "Represents non-dogmatic knowledge, truth, and democratic education."),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildContentCard(
                context,
                title: "DISTINCTIVE LIFE & PRACTICES AT GRI",
                icon: Icons.eco,
                iconColor: GriColors.forestPrimary,
                child: Column(
                  children: [
                    _buildBulletItem("Sarvodaya Prayer: Daily inter-religious prayer promoting universal brotherhood, peace, and mindfulness."),
                    _buildBulletItem("Shanti Sena (Peace Brigade): Youth wing trained in disaster relief, conflict resolution, and non-violent community leadership."),
                    _buildBulletItem("Village Placement Programme (VPP): Mandatory 7-day village immersion where students live in rural habitations and solve local needs."),
                    _buildBulletItem("Khadi Heritage: Promotion of hand-spun, hand-woven attire cultivating simplicity, eco-consciousness, and rural employment."),
                  ],
                ),
              ),
            ],
          ),

          // 4. Leadership Chronicle Tab
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              _buildContentCard(
                context,
                title: "FORMER CHANCELLORS",
                icon: Icons.stars,
                iconColor: GriColors.ochrePrimary,
                child: Column(
                  children: [
                    _buildChronicleItem(context, "Dr. T. S. Soundram", "1976 - 1984"),
                    _buildChronicleItem(context, "Smt. Soundaram Ramachandran", "1984 - 1989"),
                    _buildChronicleItem(context, "Dr. M. Aram", "1989 - 1993"),
                    _buildChronicleItem(context, "Dr. V. C. Kulandaiswamy", "1993 - 1998"),
                    _buildChronicleItem(context, "Dr. K. Venkatasubramanian", "1998 - 2004"),
                    _buildChronicleItem(context, "Dr. V. Kurien (Father of White Revolution)", "2004 - 2009"),
                    _buildChronicleItem(context, "Dr. Renana Jhabvala", "2010 - 2015"),
                    _buildChronicleItem(context, "Dr. P. S. Ramamohan Rao", "2015 - 2021"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildContentCard(
                context,
                title: "FORMER VICE-CHANCELLORS",
                icon: Icons.school,
                iconColor: GriColors.forestPrimary,
                child: Column(
                  children: [
                    _buildChronicleItem(context, "Dr. G. Ramachandran", "1976 - 1979"),
                    _buildChronicleItem(context, "Dr. M. Aram", "1979 - 1986"),
                    _buildChronicleItem(context, "Dr. D. K. Oza", "1987 - 1990"),
                    _buildChronicleItem(context, "Dr. T. R. Balakrishnan", "1990 - 1993"),
                    _buildChronicleItem(context, "Dr. S. M. Ramasamy", "2007 - 2012"),
                    _buildChronicleItem(context, "Dr. S. Natarajan", "2013 - 2018"),
                    _buildChronicleItem(context, "Dr. M. A. Sudhir", "2018 - 2021"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
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
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  letterSpacing: 0.2,
                  color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          child,
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

  Widget _buildFounderCard(BuildContext context, String name, String role, String bio) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface2 : GriColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
            ),
          ),
          Text(role, style: TextStyle(fontSize: 11, color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(bio, style: const TextStyle(fontSize: 12, height: 1.35)),
        ],
      ),
    );
  }

  Widget _buildEmblemSymbol(BuildContext context, String title, String desc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: GriColors.ochrePrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, size: 14, color: GriColors.ochrePrimary),
          ),
          const SizedBox(width: 10),
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
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChronicleItem(BuildContext context, String name, String tenure) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: GriColors.forestPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              tenure,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: GriColors.forestPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
