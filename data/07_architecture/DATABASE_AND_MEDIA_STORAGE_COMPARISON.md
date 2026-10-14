# Phase H — Cloud Database & Media Storage Architecture Comparison

> [!NOTE]
> **Independent Architectural Evaluation**: Conducted objectively based on verified institutional data volumes (250 pages, 1,047 assets, ~500 MB storage footprint) and offline-first mobile requirements.

---

## 1. Architectural Criteria for GRI Institutional Backend
1. **Relational Rigor**: Complex university structures (Schools -> Departments -> Programmes -> Courses -> Students -> Hall Tickets) demand strict ACID relational integrity.
2. **Offline-First Synchronization**: Students and staff in rural zones require instant cached access to syllabi and hall tickets with seamless delta syncing.
3. **Role-Based Row-Level Security (RLS)**: Enforce granular access so students only query authorized dossiers while administrators maintain governance oversight.
4. **Document & Media Storage CDN**: High-throughput delivery for large academic PDFs (prospectuses, forms) and leadership portraits.
5. **Operational Cost**: Must offer a sustainable free-tier or open-source self-hosting capability for educational institutions.

---

## 2. Comparative Matrix

| Evaluation Dimension | Supabase (PostgreSQL) | Google Firebase (Firestore) | Appwrite Cloud | Custom REST / Ktor + Postgres |
| :--- | :--- | :--- | :--- | :--- |
| **Data Paradigm** | **Relational (PostgreSQL 15+)** | NoSQL (Document Store) | Document Store | Relational (PostgreSQL) |
| **Relational Integrity** | Native Foreign Keys, Cascades, Joins | Manual denormalization | Limited relational indexing | Native Foreign Keys |
| **Row-Level Security (RLS)**| **Native PostgreSQL RLS** (Industry Standard) | Firestore Security Rules | Teams & Role Permissions | Custom middleware code |
| **Media / Storage CDN** | S3-Compatible Buckets (500 MB free) | Google Cloud Storage (5 GB free) | File Buckets (2 GB free) | Custom MinIO / S3 integration |
| **Offline Sync Support** | Realtime WebSockets + SQLite local | Native SDK offline cache | Manual client synchronization | Custom sync protocol |
| **Vector Search (AI)** | **`pgvector` Native** (Powers GRI-Sahayak AI) | Firebase Extensions (Vertex AI) | None / External | Custom vector extension |
| **Free Tier Tiering** | 500 MB DB, 1 GB Storage, 50K MAU | 1 GB DB, 10 GB/mo transfer | 2 GB Storage, 75K MAU | Depends on VPS hosting |
| **Vendor Lock-in** | **Zero** (100% Open-Source PostgreSQL) | High (Proprietary Google SDKs) | Low (Open-Source Core) | Zero |
| **Recommendation** | **STRONGLY RECOMMENDED** | Alternative for Notifications | Viable Alternative | Viable for Self-Hosted LAN |

---

## 3. Recommended Hybrid Architecture

### 3.1 Structured Data & Auth: **Supabase PostgreSQL**
- **Schema**: Tables for `users`, `hall_tickets`, `grievances`, `facilities`, and `official_documents`.
- **Security**: Granular RLS policies bound to user JWT role claims (`auth.jwt() -> role`).
- **AI Integration**: Direct semantic embeddings stored in PostgreSQL using `pgvector` for instant student queries across university circulars.

### 3.2 Media & Large Assets: **Supabase Storage with Local Checksum Cache**
- Large prospectuses and PDFs (e.g. `GRI_Prospectus_2026-27.pdf` 2.4 MB) are served via CDN edge endpoints.
- The mobile app maintains an LRU local file cache with SHA-256 integrity validation to eliminate redundant data transfer.
