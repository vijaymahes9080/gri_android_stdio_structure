# Rule: Central Resource Registry Pattern for Institutional Flutter Apps

When integrating external media, documents, and videos into a Flutter application:
1. **Central Registry Mandatory:** All official assets must be registered in a centralized singleton registry (e.g. `OfficialResourceRegistry`) with stable, semantic IDs (e.g. `DOC_PROSPECTUS_2026`, `IMG_OFFICIAL_CREST`).
2. **Three-Tier Fallback Chain:**
   - Tier 1: Check pre-bundled local asset path (`assets/official/...`).
   - Tier 2: Attempt streaming / downloading from verified official remote URL.
   - Tier 3: Display a graceful, non-blocking branded placeholder or SnackBar error boundary.
3. **Centralized Action Handlers:** Never call `launchUrl` with raw strings directly inside UI widgets. Always route through `OfficialResourceRegistry.openDocument(context, id)` and `OfficialResourceRegistry.openVideo(context, id)` to guarantee uniform permissions, MIME typing, and error recovery.
4. **Verification Ledger:** Generate an authoritative markdown report (`RESOURCE_INTEGRATION_VERIFICATION.md`) documenting the runtime verification status and last-checked timestamp of every registered resource.
