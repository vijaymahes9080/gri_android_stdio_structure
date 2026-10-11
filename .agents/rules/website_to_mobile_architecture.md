# Rule: Comprehensive Website-to-Mobile Architecture Pattern

When porting a large institutional website to a mobile application:
1. **Inventory First:** Perform recursive discovery producing both human-readable documentation and a machine-readable DAG inventory (`assets/website_inventory.json`).
2. **Domain-Specific Parametric Templates:** Use reusable data-driven templates (e.g. `DepartmentDetailScreen`, `InstitutionalArticleScreen`, `DocumentVaultScreen`) for recurring page types rather than writing hundreds of redundant static screen files.
3. **Universal Reachability:** Implement a multi-level Navigation Drawer and Global Search engine driven by the machine-readable inventory to ensure 100% of discovered pages are accessible within 2 taps.
4. **Tiered Asset Storage:**
   - Tier 1: Bundle only core identity brand assets (< 3 MB) locally.
   - Tier 2: Stream large official PDFs on-demand with local cache fallback.
   - Tier 3: Link high-definition video assets via official streaming intents.
5. **Strict Native UI:** Never use WebViews or raw HTML/CSS copies as substitutes for native widgets.
6. **End-to-End Traceability:** Generate a mapping matrix (`WEBSITE_TO_FLUTTER_MAPPING.csv`) correlating 100% of discovered URLs to their corresponding mobile routes, models, and verification states.
