# Phase H — Data Flow Architecture (DFD Levels 0 & 1)

## 1. DFD Level 0 — Context-Level Data Flow

The Context Diagram defines the interaction boundaries between external entities and the Gandhigram Rural Institute (GRI) Mobile Application System:

```mermaid
graph LR
    User["Student / Faculty / Admin User"]
    GRIWeb["Official Website (ruraluniv.ac.in)"]
    GovSamarth["National Samarth Portal"]
    AppSystem(("GRI Mobile Application System"))
    LocalStore[("Local Device Storage")]
    CloudDB[("Institutional Cloud Backend")]

    User -->|Authentication & Navigation Requests| AppSystem
    AppSystem -->|Dashboard Views, Schedules & Documents| User

    GRIWeb -->|Notices, Circulars & Syllabus Updates| AppSystem
    GovSamarth -->|Admission Lists & Institutional Records| AppSystem

    AppSystem <-->|Cache Read / Write| LocalStore
    AppSystem <-->|Secure Sync & Media Streaming| CloudDB
```

---

## 2. DFD Level 1 — Detailed System Decomposition

The Level 1 diagram breaks down the GRI Mobile App into its four primary processing engines:

```mermaid
graph TD
    subgraph Users ["User Ingestion & State"]
        U1["Student / Faculty User"]
    end

    subgraph Processes ["Core Functional Subsystems"]
        P1["1.0 Role & Authentication Controller"]
        P2["2.0 Academic & Examination Engine"]
        P3["3.0 Campus Services & Facilities Navigator"]
        P4["4.0 Offline Sync & Document Vault Manager"]
    end

    subgraph DataStores ["Data Persistence"]
        D1[("D1: User Profiles & Session Store")]
        D2[("D2: Academic Syllabi & Hall Tickets")]
        D3[("D3: Campus Facilities & GPS Database")]
        D4[("D4: Official Document Vault & Checksums")]
    end

    U1 -->|1. Switch Role / Login| P1
    P1 -->|Update Active Dossier| D1
    D1 -->|Return Permissions| P1

    U1 -->|2. Request Hall Ticket / Syllabus| P2
    P2 -->|Query Schedules & Results| D2
    D2 -->|Return Examination Ticket| P2
    P2 -->|Render E-Hall Ticket with QR| U1

    U1 -->|3. Explore Facilities & Navigation| P3
    P3 -->|Query Campus Map & GPS| D3
    D3 -->|Return Building Details & Contacts| P3
    P3 -->|Interactive Map View| U1

    P4 <-->|Background Delta Sync| D1
    P4 <-->|Background Delta Sync| D2
    P4 <-->|Verify Checksums & Cache PDFs| D4
```

---

## 3. Data Dictionary for Subsystem Exchanges

| Subsystem Process | Inbound Data Flows | Outbound Data Flows | Primary Data Store |
| :--- | :--- | :--- | :--- |
| **1.0 Auth Controller** | Role toggle, User credentials, Clarification responses | Active Role Token, Navigation Tab Permissions | `D1: User Profiles` |
| **2.0 Academic Engine** | Roll Number, Semester index, Course code query | Hall Ticket Dossier, QR Hash, Subject Syllabus | `D2: Academic Syllabi` |
| **3.0 Campus Navigator** | Facility Category filter, GPS location trigger | Coordinates (`10.2798, 77.9333`), Phone Hotlines | `D3: Campus Facilities` |
| **4.0 Sync Manager** | Local cache timestamps, Network connectivity status | Verified Document Blobs, Delta JSON Updates | `D4: Document Vault` |
