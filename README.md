# GRI — The Gandhigram Rural Institute (Deemed to be University) Official Mobile Portal

A production-grade Flutter application providing complete institutional workflows
for Students, Scholars, Faculty, CoE Staff and Administrators: admissions
registration with registrar review, academics and attendance, examination
hall tickets with eligibility enforcement, grievance redressal, statutory
circular publishing, certificate authenticity verification, a grounded
offline AI assistant (GRI-Sahayak), and persistent on-device data vaulting
with optional Supabase cloud mirroring.

- **Framework:** Flutter 3.x / Dart >= 3.5 (Material 3)
- **State management:** `provider` (`ChangeNotifier` based)
- **Persistence:** `shared_preferences` vault (`lib/services/local_data_store_service.dart`)
- **Cloud backend (optional):** Supabase (`supabase_flutter`), schema + RLS in `supabase/migrations/`
- **Web sync:** live notices scraped from `https://ruraluniv.ac.in` with verified seed fallback

---

## 1. Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | 3.24+ (tested with 3.47.x) |
| Dart SDK | >= 3.5 |
| Android SDK + JDK 17 | for Android builds (Flutter toolchain) |
| Supabase project | optional, see §5 |

Verify: `flutter doctor` — no blocking issues.

## 2. Install & Run (development)

```powershell
flutter pub get
flutter run                       # offline-vault mode, works without credentials
```

Windows one-click device launcher (installs to a connected Android phone):

```bat
launch_app.bat
```

### With cloud backend enabled

```powershell
flutter run `
  --dart-define=SUPABASE_URL=https://<your-project-ref>.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=<your-anon-public-key>
```

Without these defines the app still runs exactly the same feature set in
**offline-vault mode** — every workflow persists on-device — and the admin
directory displays the honest runtime mode: `Offline Vault • Local Store`
(or `Cloud Connected • Supabase` when credentials are supplied).

## 3. Test & Verify

```powershell
flutter analyze                    # static analysis (0 issues expected)
flutter test                       # full unit + widget suite
flutter build apk --debug          # compilation verification
flutter build apk --release        # production artifacts
```

Test suites:
- `test/widget_test.dart` — screens, dashboard render, role authorization gate
- `test/models_and_resources_test.dart` — official registries, seed datasets, settings
- `test/integrity_and_intelligence_test.dart` — serialization roundtrips, persistent
  vault restart-safety, hall-ticket eligibility, certificate verification honesty,
  GRI-Sahayak grounding, document-center verification UI
- `test/rollcall_and_authorization_test.dart` — faculty roll-call register
  (status cycling, submission counts, vault durability, cloud queue), hall-ticket
  eligibility refusals, RBAC denial for unapproved role activation
- `test/design_system_test.dart` — typography parity across light/dark modes,
  10px legibility floor, component themes (buttons/inputs/dialogs/sheets/nav),
  shared primitives (empty state, section header, status badge tones),
  reduced-motion compliance, metric token coherence

## 4. Build & Deploy (Android)

```powershell
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
# (add --split-per-abi for smaller per-device bundles)
```

Play Store / App Store packaging follows standard `flutter build appbundle`
workflow. Web/desktop targets are not enabled by default (channel-specific
plugins like `url_launcher` work, but the app is tuned for handheld form factors).

## 5. Backend setup (optional Supabase)

1. Create a project at [supabase.com](https://supabase.com).
2. Link and push the schema (requires the Supabase CLI):
   ```powershell
   supabase link --project-ref <your-ref>
   supabase db push
   ```
3. Copy the **anon public** key (never the service-role key) and run the app
   with the two `--dart-define` flags from §2.

Migrations create: `user_profiles`, `audit_logs`, `circulars_notices`,
`grievances`, `faculty_leaves`, `notifications`, `student_courses`,
`document_certificates`, `registration_applications`, `attendance_registers`
— all with Row Level Security policies.

**RLS hardening (20261028010000):** the original policies granted anonymous
(anon-key) sessions *write* access to official circulars and attendance
records, and read access to grievances, audit logs and leave records. The
hardening migration fails those closed: cloud reads/writes now require either
the owning institutional profile or an approved admin/staff role. Consequence:
an app session running **without a Supabase Auth identity** sees no cloud rows
for these tables (local vault data is unaffected) — wire Supabase Auth before
relying on cloud-mode data for these features.

## 6. Architecture overview

```
lib/
├── main.dart                 # bootstrap: Supabase init → seed load → app
├── providers/gri_provider.dart   # central ChangeNotifier: navigation, roles,
│                             # workflows, persistence + cloud queue orchestration
├── models/                   # user_model.dart (roles/permissions/applications),
│                             # academic_models.dart (+ full toMap/fromMap codecs)
├── services/
│   ├── local_data_store_service.dart # persistent JSON vault (restart-safe)
│   ├── supabase_service.dart         # conditional cloud client + typed sync ops
│   ├── document_certification_service.dart # checksum + register verification
│   ├── sahayak_knowledge_engine.dart # grounded offline retrieval assistant
│   ├── official_web_sync_service.dart# live notice scraping w/ fallback
│   ├── official_resource_registry.dart # verified document/portal registry
│   └── seed_data_service.dart        # institutional seed datasets
├── screens/                  # 30+ feature screens (dashboard, academics, campus…)
├── widgets/                  # top bar, drawer, modals (wizard, review, ticket)
│                             # + shared primitives (GriEmptyState, GriSectionHeader,
│                             #   GriStatusBadge — dark-mode aware, motion-respecting)
└── utils/                    # design system: colors, typography, metrics
                              # (spacing/radii/shadows), motion (reduced-motion
                              # compliant), + full ThemeData component themes
```

### Design system rules (enforced by `GriColors`/`GriTypography`/`GriMetrics`/`GriMotion`)
- **Colors:** status/feedback uses the WCAG-tuned semantic tokens
  (`success`/`warning`/`error`/`info` + containers); dark mode uses the
  matching `*Bright` inks. Raw `Colors.green/red/...` must not be used for
  status. Dark and light modes define **identical typographic geometry** —
  only the ink differs (`GriTypography.theme(brightness)`).
- **Typography:** the 10 px legibility floor is absolute; every tokenized
  style is ≥ 10 px.
- **Components:** buttons, inputs, dialogs, snackbars, bottom sheets and the
  navigation bar are themed centrally — screens inherit consistent states
  (incl. disabled) for free.
- **Motion:** durations/curves come from `GriMotion`; entrance animations and
  press feedback honor `MediaQuery.disableAnimations` (and the in-app
  reduced-motion setting).

### Data flow rules
- Every mutation writes the local vault **immediately**; if cloud credentials
  are absent the record is queued (`pending_cloud_ops`) and drained on the
  next successful cloud sync.
- Read-state, attendance, grievances, applications, audit ledger, leave
  requests and assistant conversation all survive restarts.
- First launch snapshots the verified seed baseline; later sessions restore
  user modifications instead of overwriting them.

## 7. Authentication & authorization model

- Account dossiers carry `approvedRolesCsv`; **role activation is gated** —
  only roles on the account's approved dossier can be activated, others are
  refused with an explicit notice (enforced in `switchAuthorizedRole`).
- Registration wizard applications enter `PENDING_APPROVAL` and require an
  admin review; every admin decision appends to the immutable audit ledger.
- Hall tickets are generated **only** for approved students/scholars meeting
  the 75% per-course attendance rule; refusals state the exact shortfall.
- Faculty roll-call registers are recorded per course session (Present/Absent/OD
  counts), stored append-only in the vault, and queued for the cloud
  `attendance_registers` table; submissions are never fabricated when the
  roster is empty.
- Cloud side: RLS restricts profile updates to owners, review actions to
  admins, and the certificate register to read-only public access.
- Demo/seed accounts exist for QA of each role; production deployments should
  provision Supabase Auth identities and drop the preset accounts
  (see `lib/providers/gri_provider.dart::_availableAccounts`).

## 8. Known limitations

- The AI assistant is a deterministic local retrieval engine, not a generative
  LLM; it answers only institution-grounded topics and says so otherwise.
- Full Supabase Auth (email/password, OTP) is scaffolded at the service layer
  but not yet wired into the login flow; the app boots into the last-selected
  local account. This is the largest remaining gap before multi-user cloud
  rollout. Related: the 20261028010000 RLS hardening makes grievance/leave/
  attendance cloud tables fail closed without an Auth session (see §5), and
  the `attendance_registers` mirror likewise requires an authenticated
  approved-staff session.
- Web notice scraping depends on the university site's HTML structure; if the
  markup changes, the verified seed fallback keeps the app accurate.
- Certificate register ships a small development sample set; production must
  import the real CoE register into `document_certificates`.
- Kotlin 2.3.20 is not usable on this machine: the pub cache
  (`C:\Users\vijay\AppData\Local\Pub\Cache`) and the project (`D:\`) live on
  different drives, which breaks the 2.3.x Kotlin incremental-cache
  infrastructure even with `kotlin.incremental=false` ("Could not close
  incremental caches"). The project therefore pins Kotlin 2.2.20 in
  `android/settings.gradle`; upgrade only on a single-drive toolchain.

## 9. Troubleshooting

| Symptom | Fix |
|---|---|
| `flutter doctor` Android licenses error | `flutter doctor --android-licenses` |
| Build warns about Kotlin plugin version | harmless; Gradle resolves the pinned Kotlin version in `android/settings.gradle` |
| Cloud shows `Offline Vault` despite credentials | ensure `--dart-define` flags were used at build/run time (they are compile-time constants) |
| Cloud-mode grievances/leaves empty after sync | expected with hardening: these tables fail closed without a Supabase Auth session (see §5 RLS hardening) |
| Tests hang briefly on first run | network probes to the official site use an 8 s timeout then fall back to seeds |
| Reset all local data | Settings → reset institutional data (or `LocalDataStoreService.clearAll()`) |
