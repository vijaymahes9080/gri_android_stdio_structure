# Phase H — Entity-Relationship Diagram (ERD) & Database Schemas

> [!NOTE]
> **Schema Design Proposal**: All database schemas documented below represent the normalized relational design for the upcoming institutional cloud backend. No production databases have been altered.

---

## 1. Entity-Relationship Diagram (ERD)

```mermaid
erDiagram
    USERS ||--o{ USER_ROLES : has
    USERS ||--o{ GRIEVANCES : submits
    USERS ||--o| HALL_TICKETS : receives
    USERS ||--o{ APPLICATION_CLARIFICATIONS : files

    SCHOOLS ||--|{ DEPARTMENTS : contains
    DEPARTMENTS ||--|{ PROGRAMMES : offers
    PROGRAMMES ||--|{ COURSES : curriculum
    COURSES ||--o{ EXAM_SCHEDULES : timetabled

    HALL_TICKETS ||--|{ EXAM_SCHEDULES : includes

    MODULES ||--|{ WEB_PAGES : organizes
    WEB_PAGES ||--o{ PAGE_ASSETS : references
    OFFICIAL_DOCUMENTS ||--o{ PAGE_ASSETS : cataloged

    USERS {
        uuid id PK
        string full_name
        string email UK
        string phone
        string register_number UK
        string avatar_url
        string active_status
        timestamp created_at
    }

    HALL_TICKETS {
        uuid id PK
        uuid user_id FK
        string roll_number
        string student_name
        string degree_name
        string semester
        string exam_center
        string qr_verification_hash
        boolean is_esanad_verified
        timestamp generated_at
    }

    COURSES {
        string course_code PK
        string title
        int credits
        string semester
        string department_id FK
        text syllabus_description
        string pdf_syllabus_url
    }

    EXAM_SCHEDULES {
        uuid id PK
        string course_code FK
        timestamp exam_date
        string session_time
        string hall_number
    }

    GRIEVANCES {
        uuid id PK
        uuid user_id FK
        string tracking_id UK
        string category
        string subject
        text description
        string status
        text admin_remark
        timestamp submitted_at
        timestamp resolved_at
    }

    CAMPUS_FACILITIES {
        uuid id PK
        string facility_name
        string category
        string latitude
        string longitude
        string contact_phone
        text description
        string cover_image_url
    }

    OFFICIAL_DOCUMENTS {
        uuid id PK
        string document_id UK
        string title
        string download_url
        string file_type
        bigint file_size_bytes
        string sha256_checksum
        string access_status
    }
```

---

## 2. Table Schemas & Relational Specifications

### 2.1 Table: `users`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | Primary Key, `default gen_random_uuid()` | Unique user identifier |
| `full_name` | `VARCHAR(150)` | NOT NULL | User's full name |
| `email` | `VARCHAR(255)` | UNIQUE, NOT NULL | Institutional or personal email |
| `register_number` | `VARCHAR(50)` | UNIQUE, NULLABLE | Student Roll No. or Staff ID |
| `active_role` | `VARCHAR(30)` | NOT NULL, DEFAULT 'STUDENT' | Current active role enum |
| `account_status` | `VARCHAR(30)` | NOT NULL, DEFAULT 'PENDING' | Approval state lifecycle |

### 2.2 Table: `hall_tickets`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | Primary Key | Unique hall ticket voucher ID |
| `user_id` | `UUID` | Foreign Key -> `users(id)` | Recipient student |
| `roll_number` | `VARCHAR(50)` | NOT NULL | Roll number (e.g. `2024-MS-4011`) |
| `exam_center` | `VARCHAR(150)` | NOT NULL | Assigned examination hall |
| `qr_verification_hash`| `TEXT` | NOT NULL | Cryptographic SHA-256 validation token |
| `is_esanad_verified` | `BOOLEAN` | DEFAULT TRUE | External MEA e-SANAD attestation flag |

### 2.3 Table: `official_documents`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | Primary Key | Internal document identifier |
| `document_id` | `VARCHAR(50)` | UNIQUE | Catalog ID (e.g. `AST-DOC-0001`) |
| `title` | `VARCHAR(255)` | NOT NULL | Descriptive document name |
| `download_url` | `TEXT` | NOT NULL | Official source link on `ruraluniv.ac.in` |
| `sha256_checksum` | `VARCHAR(64)` | NULLABLE | SHA-256 hash for local offline verification |
| `access_status` | `VARCHAR(40)` | NOT NULL | `PUBLIC_VERIFIED`, `RESTRICTED_LAN`, etc. |


---

## 4. Institutional Portals & E-Governance Data Models

```sql
-- Table: Portal Gateway Registry
CREATE TABLE portal_gateways (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    portal_key VARCHAR(50) UNIQUE NOT NULL, -- e.g., 'hostel', 'griims', 'etrack', 'lms', 'attendance'
    display_name VARCHAR(150) NOT NULL,
    endpoint_url TEXT NOT NULL,
    auth_strategy VARCHAR(50) NOT NULL, -- 'SSO_COOKIE', 'JWT_BEARER', 'EXTERNAL_REDIRECT'
    target_persona VARCHAR(50) NOT NULL, -- 'STUDENT', 'SCHOLAR', 'FACULTY', 'ADMIN'
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: User Secure Portal Sessions
CREATE TABLE user_portal_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    portal_id UUID REFERENCES portal_gateways(id) ON DELETE CASCADE,
    session_token TEXT NOT NULL,
    refresh_token TEXT,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: G-Track Digital File Tracking Dockets
CREATE TABLE etrack_dockets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    docket_number VARCHAR(100) UNIQUE NOT NULL,
    subject TEXT NOT NULL,
    origin_department VARCHAR(150) NOT NULL,
    current_location VARCHAR(150) NOT NULL,
    current_officer VARCHAR(150),
    status VARCHAR(50) NOT NULL, -- 'DISPATCHED', 'IN_TRANSIT', 'RECEIVED', 'CLOSED'
    movement_history JSONB NOT NULL DEFAULT '[]'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```
