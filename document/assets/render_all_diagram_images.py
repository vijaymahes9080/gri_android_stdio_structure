import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

output_dir = r"d:\current project\gri\document\assets"
os.makedirs(output_dir, exist_ok=True)

# Common Theme Colors
C_FOREST = "#1B5E20"
C_GOLD = "#B8860B"
C_IVORY = "#F9F9F4"
C_DARK = "#212121"
C_LIGHT_GREEN = "#E8F5E9"
C_LIGHT_GOLD = "#FFF8E1"
C_LIGHT_BLUE = "#E0F7FA"
C_LIGHT_PURPLE = "#EDE7F6"
C_LIGHT_GREY = "#ECEFF1"
C_CRIT_RED = "#C62828"

print("Generating 11 comprehensive diagram images at 300 DPI...")

# =========================================================================
# 0. Working Flow Diagram (diagram_working_flow.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(14, 9), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FAFAFA', edgecolor=C_FOREST, lw=2))

ax.text(50, 95, "GRI OFFICIAL MOBILE PORTAL — 12-STAGE COMPLETE OPERATIONAL WORKING FLOW", ha='center', va='center', fontsize=12, fontweight='bold', color=C_FOREST)

stages = [
    ("Stage 1: Boot & Splash", "Initialize Flutter engine,\nload SharedPreferences,\nplay crest animation.", 5, 78, "#C8E6C9"),
    ("Stage 2: Fast Seed Hydration", "Deserialize 8 schools, 30+ depts,\n309 routes from local JSON bundle\ninto SeedDataService in-memory.", 29, 78, "#C8E6C9"),
    ("Stage 3: Token & Session Check", "Read auth token from local disk,\nverify expiry against Supabase,\nresolve approved_roles array.", 53, 78, "#FFE082"),
    ("Stage 4: Dynamic Navigation Shell", "MainScaffold builds dynamic tabs\nbased on active role:\nStudent / Faculty / Admin / Guest.", 77, 78, "#FFE082"),

    ("Stage 8: Admin Dossier Review", "Statutory officers review pending\napplications in approval center:\nApprove / Reject / Request Info.", 77, 48, "#FFE082"),
    ("Stage 7: Local & Cloud Persistence", "Write mutations to Supabase PostgreSQL;\nif network offline, queue into local\nencrypted SharedPreferences.", 53, 48, "#D1C4E9"),
    ("Stage 6: Academic Business Logic", "Calculate aggregate attendance,\nevaluate 75% threshold gate,\nenable/disable exam hall ticket.", 29, 48, "#B2EBF2"),
    ("Stage 5: User Input & Form Validation", "Collect forms via TextFormField;\nvalidate @ruraluniv.ac.in email\nregex & 10-digit mobile numbers.", 5, 48, "#B2EBF2"),

    ("Stage 9: e-SANAD QR Synthesis", "Synthesize SHA-256 token digest\nwith student ID, roll no & exam center;\nrender ISO/IEC 18004 QR code.", 5, 18, "#FFCCBC"),
    ("Stage 10: External Gateway Launch", "Launch Samarth ERP, DigiLocker\nAPAAR & MEA e-SANAD portals\nvia secure url_launcher intents.", 29, 18, "#FFCCBC"),
    ("Stage 11: Real-Time Sync & WebSockets", "Listen to Supabase postgres_changes;\nupdate grievances, leave statuses\nand broadcast urgent notices.", 53, 18, "#D1C4E9"),
    ("Stage 12: Immutable Audit Ledgering", "Log operator UUID, target ID, action\nand timestamps permanently to\naudit_logs table in PostgreSQL.", 77, 18, "#CFD8DC")
]

for title, desc, x, y, col in stages:
    ax.add_patch(patches.FancyBboxPatch((x, y), 18, 20, boxstyle="round,pad=0.5", facecolor=col, edgecolor=C_FOREST, lw=1.2))
    ax.text(x+9, y+16.5, title, ha='center', va='center', fontsize=7.5, fontweight='bold', color=C_FOREST)
    ax.text(x+9, y+8.5, desc, ha='center', va='center', fontsize=6.2, color='#212121')

# Draw Arrows
arrow_style = dict(arrowstyle="->", lw=2, color=C_GOLD)
ax.annotate("", xy=(29, 88), xytext=(23, 88), arrowprops=arrow_style)
ax.annotate("", xy=(53, 88), xytext=(47, 88), arrowprops=arrow_style)
ax.annotate("", xy=(77, 88), xytext=(71, 88), arrowprops=arrow_style)
# Down to row 2
ax.annotate("", xy=(86, 68), xytext=(86, 78), arrowprops=arrow_style)
# Row 2 right to left
ax.annotate("", xy=(71, 58), xytext=(77, 58), arrowprops=arrow_style)
ax.annotate("", xy=(47, 58), xytext=(53, 58), arrowprops=arrow_style)
ax.annotate("", xy=(23, 58), xytext=(29, 58), arrowprops=arrow_style)
# Down to row 3
ax.annotate("", xy=(14, 38), xytext=(14, 48), arrowprops=arrow_style)
# Row 3 left to right
ax.annotate("", xy=(29, 28), xytext=(23, 28), arrowprops=arrow_style)
ax.annotate("", xy=(53, 28), xytext=(47, 28), arrowprops=arrow_style)
ax.annotate("", xy=(77, 28), xytext=(71, 28), arrowprops=arrow_style)

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_working_flow.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_working_flow.png")

# =========================================================================
# 1. Diagram 1: Proposed Project Lifecycle (diagram_01_lifecycle.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(13, 8), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FFFFFF', edgecolor=C_FOREST, lw=2))

ax.text(50, 94, "DIAGRAM 1: PROPOSED PROJECT LIFECYCLE & ENGINEERING MILESTONES", ha='center', va='center', fontsize=12, fontweight='bold', color=C_FOREST)

phases = [
    ("PHASE 1: REQUIREMENTS & AUDIT", 8, 72, 84, 14, "#E8F5E9", [
        ("Stakeholder Interviews & Policy Audit", 10, 74, 25, 7),
        ("309-Route Web Crawl & Data Inventory", 38, 74, 26, 7),
        ("SRS Documentation & Signoff [M1]", 67, 74, 23, 7)
    ]),
    ("PHASE 2: SYSTEM ARCHITECTURE & DESIGN", 8, 54, 84, 14, "#FFF8E1", [
        ("Clean Architecture Specification", 10, 56, 25, 7),
        ("Database Modeling & Supabase RLS", 38, 56, 26, 7),
        ("Gandhian Design Tokens (GriColors) [M2]", 67, 56, 23, 7)
    ]),
    ("PHASE 3: CORE IMPLEMENTATION & INTEGRATION", 8, 36, 84, 14, "#E0F7FA", [
        ("Dual-Tier Data Layer (Seed + Cloud)", 10, 38, 25, 7),
        ("25 Native Application Screens", 38, 38, 26, 7),
        ("e-SANAD QR Engine & AI Hub [M3]", 67, 38, 23, 7)
    ]),
    ("PHASE 4: VERIFICATION & SECURITY AUDITING", 8, 18, 84, 14, "#EDE7F6", [
        ("Automated Tests (25 Test Cases)", 10, 20, 25, 7),
        ("Static Analysis (Zero Defect Gate)", 38, 20, 26, 7),
        ("Physical Device Verification [M4]", 67, 20, 23, 7)
    ]),
]

for p_title, px, py, pw, ph, bg, boxes in phases:
    ax.add_patch(patches.FancyBboxPatch((px, py), pw, ph, boxstyle="round,pad=0.5", facecolor=bg, edgecolor=C_FOREST, lw=1.2))
    ax.text(px+3, py+ph-3, p_title, fontsize=8.5, fontweight='bold', color=C_FOREST)
    for b_title, bx, by, bw, bh in boxes:
        ax.add_patch(patches.Rectangle((bx, by), bw, bh, facecolor='#FFFFFF', edgecolor=C_GOLD, lw=1))
        ax.text(bx+bw/2, by+bh/2, b_title, ha='center', va='center', fontsize=6.8, color='#212121', fontweight='medium')

# Quality Milestone Column
ax.add_patch(patches.FancyBboxPatch((8, 4), 84, 10, boxstyle="round,pad=0.5", facecolor='#FFEBEE', edgecolor=C_CRIT_RED, lw=1.5))
ax.text(50, 9, "PHASE 5: DEPLOYMENT & CAMPUS PILOT -> FINAL INSTITUTIONAL HANDOVER [M5: CERTIFIED]", ha='center', va='center', fontsize=8.5, fontweight='bold', color=C_CRIT_RED)

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_01_lifecycle.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_01_lifecycle.png")

# =========================================================================
# 2. Diagram 2: System Architecture (diagram_02_architecture.png)
# =========================================================================
# Already generated by generate_assets.py as architecture_diagram.png; let's copy/save as diagram_02_architecture.png
import shutil
shutil.copyfile(os.path.join(output_dir, "architecture_diagram.png"), os.path.join(output_dir, "diagram_02_architecture.png"))
print("Saved diagram_02_architecture.png")

# =========================================================================
# 3. Diagram 3: Level-0 DFD Context (diagram_03_dfd_level_0.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(13, 9), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FFFFFF', edgecolor=C_FOREST, lw=2))

ax.text(50, 95, "DIAGRAM 3: LEVEL-0 DATA FLOW DIAGRAM (CONTEXT DIAGRAM)", ha='center', va='center', fontsize=12, fontweight='bold', color=C_FOREST)

# Central Process Circle
circle = patches.Circle((50, 50), 16, facecolor=C_LIGHT_GREEN, edgecolor=C_FOREST, lw=2.5)
ax.add_patch(circle)
ax.text(50, 52, "0.0\nGRI Official Mobile\nPortal System\n(com.aistudio.grist)", ha='center', va='center', fontsize=8.5, fontweight='bold', color=C_FOREST)

# External Entities
entities = [
    ("Student User\n(Enrolled UG/PG)", 10, 80, "#E8F5E9"),
    ("Faculty Member\n(Teaching & Guides)", 80, 80, "#E8F5E9"),
    ("University Administrator\n(Registrar & Systems)", 10, 20, "#FFF8E1"),
    ("COE Staff\n(Exam Controller)", 80, 20, "#FFF8E1"),
    ("Research Scholar\n(PhD / JRF Fellows)", 10, 50, "#E0F7FA"),
    ("National Portals\n(e-SANAD, Samarth)", 80, 50, "#ECEFF1")
]

for title, ex, ey, col in entities:
    ax.add_patch(patches.FancyBboxPatch((ex-8, ey-5), 18, 10, boxstyle="round,pad=0.5", facecolor=col, edgecolor=C_FOREST, lw=1.2))
    ax.text(ex+1, ey, title, ha='center', va='center', fontsize=7.2, fontweight='bold', color='#212121')

# Arrows and Flow Annotations
ax.annotate("Registration, Grievances, Queries ->", xy=(36, 58), xytext=(19, 78), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST), fontsize=6, rotation=35)
ax.annotate("<- Hall Tickets, Attendance, Bus Pass", xy=(19, 74), xytext=(36, 54), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_GOLD), fontsize=6, rotation=35)

ax.annotate("<- Leaves, Roll Updates", xy=(64, 58), xytext=(81, 78), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST), fontsize=6, rotation=-35)
ax.annotate("Leave Approvals, Timetables ->", xy=(81, 74), xytext=(64, 54), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_GOLD), fontsize=6, rotation=-35)

ax.annotate("Approvals, Notices, Policies ->", xy=(36, 42), xytext=(19, 24), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST), fontsize=6, rotation=-35)
ax.annotate("<- Pending Dossiers, Audit Logs", xy=(19, 28), xytext=(36, 46), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_GOLD), fontsize=6, rotation=-35)

ax.annotate("<- Timetables, Tatkal Rules", xy=(64, 42), xytext=(81, 24), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST), fontsize=6, rotation=35)
ax.annotate("Candidate Roster, e-SANAD Tokens ->", xy=(81, 28), xytext=(64, 46), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_GOLD), fontsize=6, rotation=35)

ax.annotate("Thesis Reg, Grants ->", xy=(34, 50), xytext=(20, 50), arrowprops=dict(arrowstyle="<->", lw=1.2, color=C_FOREST), fontsize=6)
ax.annotate("<- Attestation, Transcripts ->", xy=(80, 50), xytext=(66, 50), arrowprops=dict(arrowstyle="<->", lw=1.2, color=C_FOREST), fontsize=6)

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_03_dfd_level_0.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_03_dfd_level_0.png")

# =========================================================================
# 4. Diagram 4: Level-1 DFD Process Breakdown (diagram_04_dfd_level_1.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(14, 9), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FFFFFF', edgecolor=C_FOREST, lw=2))

ax.text(50, 95, "DIAGRAM 4: LEVEL-1 DATA FLOW DIAGRAM (FUNCTIONAL PROCESS BREAKDOWN)", ha='center', va='center', fontsize=12, fontweight='bold', color=C_FOREST)

# 6 Processes
procs = [
    ("1.0: Authentication &\nRole Validation", 18, 75, "#C8E6C9"),
    ("2.0: Academic Curricula &\nAttendance Gating", 50, 75, "#C8E6C9"),
    ("3.0: Examination &\ne-SANAD Certification", 82, 75, "#FFE082"),
    ("4.0: Student Welfare &\nGrievance Redressal", 18, 30, "#E0F7FA"),
    ("5.0: Administrative Review &\nAudit Ledgering", 50, 30, "#FFE082"),
    ("6.0: Cloud Sync &\nOffline Vault Dispatch", 82, 30, "#D1C4E9"),
]

for title, px, py, col in procs:
    ax.add_patch(patches.Circle((px, py), 9, facecolor=col, edgecolor=C_FOREST, lw=1.5))
    ax.text(px, py, title, ha='center', va='center', fontsize=6.8, fontweight='bold', color=C_FOREST)

# 6 Data Stores (Horizontal bars)
stores = [
    ("D1: user_profiles (PostgreSQL)", 34, 60),
    ("D2: student_courses & programmes", 66, 60),
    ("D3: examinations & circulars", 84, 52),
    ("D4: grievances & faculty_leaves", 34, 45),
    ("D5: audit_logs (Immutable Ledger)", 50, 12),
    ("D6: Pre-Packaged Asset Vault (JSON)", 82, 12),
]

for title, sx, sy in stores:
    ax.add_patch(patches.Rectangle((sx-12, sy-2.5), 24, 5, facecolor='#ECEFF1', edgecolor='#455A64', lw=1))
    ax.text(sx, sy, title, ha='center', va='center', fontsize=6.2, fontweight='bold', color='#37474F')

# Connective lines
ax.annotate("", xy=(26, 75), xytext=(41, 75), arrowprops=dict(arrowstyle="<->", lw=1, color=C_FOREST))
ax.annotate("", xy=(59, 75), xytext=(73, 75), arrowprops=dict(arrowstyle="<->", lw=1, color=C_FOREST))
ax.annotate("", xy=(18, 66), xytext=(18, 39), arrowprops=dict(arrowstyle="<->", lw=1, color=C_GOLD))
ax.annotate("", xy=(50, 66), xytext=(50, 39), arrowprops=dict(arrowstyle="<->", lw=1, color=C_GOLD))
ax.annotate("", xy=(82, 66), xytext=(82, 39), arrowprops=dict(arrowstyle="<->", lw=1, color=C_GOLD))

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_04_dfd_level_1.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_04_dfd_level_1.png")

# =========================================================================
# 5. Diagram 5: System Sequence Diagram (diagram_05_sequence.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(14, 9.5), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FFFFFF', edgecolor=C_FOREST, lw=2))

ax.text(50, 96, "DIAGRAM 5: UML SYSTEM SEQUENCE DIAGRAM — REGISTRATION & EXAM ATTESTATION", ha='center', va='center', fontsize=11, fontweight='bold', color=C_FOREST)

# Lifeline headers
lifelines = [
    ("Student", 10),
    ("Flutter UI", 26),
    ("GriProvider", 42),
    ("SupabaseService", 58),
    ("Cloud PostgreSQL", 74),
    ("Admin / MEA", 90)
]

for name, lx in lifelines:
    ax.add_patch(patches.Rectangle((lx-6, 88), 12, 5, facecolor='#E8F5E9', edgecolor=C_FOREST, lw=1))
    ax.text(lx, 90.5, name, ha='center', va='center', fontsize=7, fontweight='bold', color=C_FOREST)
    ax.plot([lx, lx], [10, 88], color='#B0BEC5', linestyle='--', lw=1)

# Sequence Messages
seq_msgs = [
    (10, 26, 84, "1. Tap 'Register for Access' & Submit Wizard"),
    (26, 42, 79, "2. submitRegistration(dossier)"),
    (42, 58, 74, "3. registerUserDossier(data)"),
    (58, 74, 69, "4. INSERT user_profiles (status='PENDING')"),
    (74, 58, 64, "5. 201 Created (App_ID: APP-2026-9042)"),
    (58, 26, 59, "6. Redirect to ApplicationStatusScreen"),
    (90, 26, 53, "7. Admin reviews pending dossier (23MCA042)"),
    (26, 74, 47, "8. UPDATE status='APPROVED' & INSERT audit_logs"),
    (74, 42, 42, "9. Broadcast status update event"),
    (10, 26, 36, "10. Student opens Academics Hub -> Download Hall Ticket"),
    (26, 74, 30, "11. Query attendance: 88.5% (Threshold >= 75% MET)"),
    (42, 90, 24, "12. Synthesize e-SANAD Cryptographic Token Digest"),
    (90, 26, 18, "13. Return verified ISO/IEC 18004 QR Token"),
    (26, 10, 13, "14. Render HallTicketModal with QR & Print controls")
]

for x1, x2, y, txt in seq_msgs:
    c = C_FOREST if x1 < x2 else C_GOLD
    ax.annotate("", xy=(x2, y), xytext=(x1, y), arrowprops=dict(arrowstyle="->", lw=1.2, color=c))
    mid_x = (x1 + x2) / 2
    ax.text(mid_x, y + 1.2, txt, ha='center', va='bottom', fontsize=6.2, fontweight='semibold', color='#212121')

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_05_sequence.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_05_sequence.png")

# =========================================================================
# 6. Diagram 6: Entity-Relationship Schema (diagram_06_er_schema.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(14, 9.5), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FFFFFF', edgecolor=C_FOREST, lw=2))

ax.text(50, 96, "DIAGRAM 6: ENTITY-RELATIONSHIP (ER) RELATIONAL DATABASE SCHEMA", ha='center', va='center', fontsize=12, fontweight='bold', color=C_FOREST)

tables = [
    ("user_profiles (Core Identity)", 5, 58, 28, 34, [
        ("id", "UUID PK"), ("auth_user_id", "UUID FK"), ("name", "TEXT"), ("email", "TEXT UK"),
        ("requested_role", "TEXT"), ("approved_roles", "TEXT[]"), ("active_role", "TEXT"),
        ("status", "TEXT"), ("attendance", "NUMERIC"), ("application_id", "TEXT UK")
    ]),
    ("audit_logs (Immutable Ledger)", 36, 58, 28, 34, [
        ("id", "UUID PK"), ("actor_user_id", "TEXT"), ("actor_name", "TEXT"),
        ("target_user_id", "TEXT"), ("action", "TEXT"), ("previous_status", "TEXT"),
        ("new_status", "TEXT"), ("remarks", "TEXT"), ("created_at", "TIMESTAMPTZ")
    ]),
    ("circulars_notices", 67, 58, 28, 34, [
        ("id", "TEXT PK"), ("title", "TEXT"), ("category", "TEXT"),
        ("date", "TEXT"), ("issued_by", "TEXT"), ("urgent", "BOOLEAN"),
        ("stage", "TEXT"), ("audience", "TEXT"), ("doc_url", "TEXT")
    ]),
    ("student_courses", 5, 14, 28, 38, [
        ("id", "TEXT PK"), ("user_id", "TEXT FK"), ("code", "TEXT"),
        ("title", "TEXT"), ("credits", "INTEGER"), ("instructor", "TEXT"),
        ("attendance", "NUMERIC"), ("total", "INTEGER"), ("attended", "INTEGER")
    ]),
    ("grievances (GRI-Care)", 36, 14, 28, 38, [
        ("id", "TEXT PK"), ("user_id", "TEXT FK"), ("user_name", "TEXT"),
        ("category", "TEXT"), ("subject", "TEXT"), ("description", "TEXT"),
        ("status", "TEXT"), ("remarks", "TEXT"), ("created_at", "TIMESTAMPTZ")
    ]),
    ("schools & departments", 67, 14, 28, 38, [
        ("id", "TEXT PK"), ("name", "TEXT"), ("dean / hod", "TEXT"),
        ("programmes_offered", "TEXT[]"), ("source_url", "TEXT"),
        ("content_hash", "TEXT UNIQUE"), ("status", "TEXT")
    ]),
]

for t_name, tx, ty, tw, th, cols in tables:
    ax.add_patch(patches.Rectangle((tx, ty), tw, th, facecolor='#FAFAFA', edgecolor=C_FOREST, lw=1.2))
    ax.add_patch(patches.Rectangle((tx, ty+th-6), tw, 6, facecolor=C_FOREST))
    ax.text(tx+tw/2, ty+th-3, t_name, color='white', ha='center', va='center', fontsize=6.8, fontweight='bold')
    
    for c_idx, (col_n, col_t) in enumerate(cols):
        cy = ty + th - 9 - (c_idx * 3.2)
        ax.text(tx+1.5, cy, col_n, fontsize=5.8, fontweight='bold' if "PK" in col_t else 'normal', color='#212121')
        ax.text(tx+tw-1.5, cy, col_t, fontsize=5.5, color='#0277BD' if "PK" in col_t or "FK" in col_t else '#555555', ha='right')

# Relationship lines
ax.annotate("", xy=(36, 75), xytext=(33, 75), arrowprops=dict(arrowstyle="<->", lw=1.5, color=C_GOLD))
ax.annotate("", xy=(5, 34), xytext=(5, 58), arrowprops=dict(arrowstyle="<->", lw=1.5, color=C_GOLD))
ax.annotate("", xy=(36, 34), xytext=(33, 65), arrowprops=dict(arrowstyle="<->", lw=1.5, color=C_GOLD))

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_06_er_schema.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_06_er_schema.png")

# =========================================================================
# 7. Diagram 7: Project Timeline PERT / Gantt (diagram_07_gantt_pert.png)
# =========================================================================
shutil.copyfile(os.path.join(output_dir, "gantt_pert_chart.png"), os.path.join(output_dir, "diagram_07_gantt_pert.png"))
print("Saved diagram_07_gantt_pert.png")

# =========================================================================
# 8. Diagram 8: UML Use Case Diagram (diagram_08_use_case.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(14, 9.5), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FFFFFF', edgecolor=C_FOREST, lw=2))

ax.text(50, 96, "DIAGRAM 8: UML USE CASE DIAGRAM WITH INCLUDE & EXTEND DEPENDENCIES", ha='center', va='center', fontsize=11, fontweight='bold', color=C_FOREST)

# System Boundary Box
ax.add_patch(patches.Rectangle((26, 5), 68, 88, facecolor='#F9FBE7', edgecolor=C_FOREST, lw=1.5, linestyle='--'))
ax.text(60, 90, "SYSTEM BOUNDARY: THE GRI OFFICIAL MOBILE APPLICATION", ha='center', va='center', fontsize=8.5, fontweight='bold', color=C_FOREST)

# Actors on the left
actors = [
    ("Student User", 10, 80),
    ("Faculty Member", 10, 64),
    ("COE Staff", 10, 48),
    ("Research Scholar", 10, 32),
    ("Administrator", 10, 16)
]

for a_name, ax_pos, ay_pos in actors:
    # Draw simple stick figure representation
    head = patches.Circle((ax_pos, ay_pos+3), 1.8, facecolor='#FFE082', edgecolor=C_FOREST, lw=1)
    ax.add_patch(head)
    ax.plot([ax_pos, ax_pos], [ay_pos-1.5, ay_pos+1.2], color=C_FOREST, lw=1.5)
    ax.plot([ax_pos-2, ax_pos+2], [ay_pos, ay_pos], color=C_FOREST, lw=1.5)
    ax.plot([ax_pos, ax_pos-1.5], [ay_pos-1.5, ay_pos-4], color=C_FOREST, lw=1.5)
    ax.plot([ax_pos, ax_pos+1.5], [ay_pos-1.5, ay_pos-4], color=C_FOREST, lw=1.5)
    ax.text(ax_pos, ay_pos-6.5, a_name, ha='center', va='center', fontsize=6.8, fontweight='bold', color=C_FOREST)

# Use Case Ovals inside boundary
use_cases = [
    ("UC01: Submit Self-Registration", 40, 82),
    ("UC02: Switch Active Role", 65, 82),
    ("UC03: Track Enrolled Courses & Attendance", 40, 68),
    ("UC04: Generate Verified Hall Ticket", 65, 68),
    ("UC04.1: Verify Attendance Threshold (>=75%)", 85, 68),
    ("UC05: File Grievance Petition (GRI-Care)", 40, 52),
    ("UC06: View Digital Campus Transit Pass", 65, 52),
    ("UC07: Apply for Faculty Duty/Casual Leave", 40, 36),
    ("UC08: Publish Exam Timetables & Regulations", 65, 36),
    ("UC09: Review Pending Dossiers (Approve/Reject)", 40, 20),
    ("UC09.1: Request Clarification Notes", 65, 20),
    ("UC10: Consult GRI-Sahayak AI Assistant", 85, 20),
    ("UC11: Download 595-PDF Statutory Vault", 60, 10),
]

for uc_text, ux, uy in use_cases:
    ax.add_patch(patches.FancyBboxPatch((ux-8, uy-3), 16, 6, boxstyle="round,pad=0.5", facecolor='#FFFFFF', edgecolor=C_GOLD, lw=1.2))
    ax.text(ux, uy, uc_text, ha='center', va='center', fontsize=5.8, fontweight='semibold', color='#212121')

# Actor Associations
for ay_pos, target_y in [(80, 82), (80, 68), (80, 52), (64, 36), (48, 36), (32, 10), (16, 20)]:
    ax.plot([14, 32], [ay_pos, target_y], color=C_FOREST, lw=0.9)

# Include & Extend Lines
ax.annotate("<<include>>", xy=(77, 68), xytext=(73, 68), arrowprops=dict(arrowstyle="->", lw=1, color=C_CRIT_RED, linestyle='--'), fontsize=5.5)
ax.annotate("<<extend>>", xy=(57, 20), xytext=(48, 20), arrowprops=dict(arrowstyle="->", lw=1, color=C_CRIT_RED, linestyle='--'), fontsize=5.5)

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_08_use_case.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_08_use_case.png")

# =========================================================================
# 9. Diagram 9: UI/UX Wireframes & Navigation (diagram_09_navigation_wireframes.png)
# =========================================================================
shutil.copyfile(os.path.join(output_dir, "wireframes_overview.png"), os.path.join(output_dir, "diagram_09_navigation_wireframes.png"))
print("Saved diagram_09_navigation_wireframes.png")

# =========================================================================
# 10. Diagram 10: Registration & Auth Flowchart (diagram_10_auth_flowchart.png)
# =========================================================================
fig, ax = plt.subplots(figsize=(14, 9.5), dpi=300)
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((1, 1), 98, 98, boxstyle="round,pad=1", facecolor='#FFFFFF', edgecolor=C_FOREST, lw=2))

ax.text(50, 96, "DIAGRAM 10: USER REGISTRATION & MULTI-ROLE AUTHENTICATION FLOWCHART", ha='center', va='center', fontsize=11, fontweight='bold', color=C_FOREST)

# Flowchart steps
# Step 1: Start
ax.add_patch(patches.FancyBboxPatch((40, 88), 20, 5, boxstyle="round,pad=0.5", facecolor=C_LIGHT_GREEN, edgecolor=C_FOREST, lw=1.2))
ax.text(50, 90.5, "App Launch & Splash Hydration", ha='center', va='center', fontsize=7, fontweight='bold', color=C_FOREST)

# Step 2: Decision Token
ax.add_patch(patches.RegularPolygon((50, 77), 4, radius=6, orientation=0, facecolor=C_LIGHT_GOLD, edgecolor=C_GOLD, lw=1.2))
ax.text(50, 77, "Session\nFound?", ha='center', va='center', fontsize=6.5, fontweight='bold')

# Branch Yes -> Active Status
ax.add_patch(patches.RegularPolygon((78, 77), 4, radius=6, orientation=0, facecolor=C_LIGHT_GOLD, edgecolor=C_GOLD, lw=1.2))
ax.text(78, 77, "Status ==\nAPPROVED?", ha='center', va='center', fontsize=6, fontweight='bold')

# Yes -> Full MainScaffold
ax.add_patch(patches.Rectangle((68, 58), 20, 7, facecolor='#C8E6C9', edgecolor=C_FOREST, lw=1.2))
ax.text(78, 61.5, "Render MainScaffold\n(Dynamic Role Navigation)", ha='center', va='center', fontsize=6.5, fontweight='bold', color=C_FOREST)

# Branch No -> Public Guest
ax.add_patch(patches.Rectangle((10, 74), 22, 6, facecolor='#ECEFF1', edgecolor='#455A64', lw=1.2))
ax.text(21, 77, "Set Role = GUEST\n(Render Public Campus View)", ha='center', va='center', fontsize=6.2, fontweight='bold')

# Registration Wizard (4 steps)
ax.add_patch(patches.FancyBboxPatch((10, 48), 26, 18, boxstyle="round,pad=0.5", facecolor='#FFFFFF', edgecolor=C_GOLD, lw=1.2))
ax.text(23, 63, "RegistrationWizardModal", fontsize=7, fontweight='bold', color=C_FOREST, ha='center')
ax.text(23, 58, "1. Identity & Credentials (Email regex)", fontsize=5.8, ha='center')
ax.text(23, 54, "2. Role Selection (Student/Faculty/Scholar)", fontsize=5.8, ha='center')
ax.text(23, 50, "3. School, Dept, Roll & Semester", fontsize=5.8, ha='center')

# Submission -> Cloud or Local Queue
ax.add_patch(patches.Rectangle((40, 48), 20, 8, facecolor='#E0F7FA', edgecolor='#00838F', lw=1.2))
ax.text(50, 52, "INSERT user_profiles\nstatus = PENDING_APPROVAL\nGenerate APP-2026-XXXX", ha='center', va='center', fontsize=6.2, fontweight='bold', color='#006064')

# Stepper View
ax.add_patch(patches.Rectangle((40, 32), 20, 8, facecolor='#FFF8E1', edgecolor=C_GOLD, lw=1.2))
ax.text(50, 36, "ApplicationStatusScreen\n(Step Tracker Active)", ha='center', va='center', fontsize=6.5, fontweight='bold', color=C_GOLD)

# Administrative Decision
ax.add_patch(patches.RegularPolygon((50, 17), 4, radius=7, orientation=0, facecolor='#FFEBEE', edgecolor=C_CRIT_RED, lw=1.2))
ax.text(50, 17, "Admin\nDecision?", ha='center', va='center', fontsize=6.5, fontweight='bold', color=C_CRIT_RED)

# 3 Decision Branches
ax.add_patch(patches.Rectangle((75, 13), 18, 8, facecolor='#C8E6C9', edgecolor=C_FOREST, lw=1.2))
ax.text(84, 17, "APPROVE\n-> Grant Role\n-> Log audit_logs", ha='center', va='center', fontsize=6.2, fontweight='bold', color=C_FOREST)

ax.add_patch(patches.Rectangle((75, 27), 18, 8, facecolor='#FFE0B2', edgecolor='#E65100', lw=1.2))
ax.text(84, 31, "REQUEST INFO\n-> UNDER_REVIEW\n-> Inquiry Notes", ha='center', va='center', fontsize=6.2, fontweight='bold', color='#E65100')

ax.add_patch(patches.Rectangle((10, 13), 18, 8, facecolor='#FFCDD2', edgecolor='#C62828', lw=1.2))
ax.text(19, 17, "REJECT\n-> REJECTED\n-> Mandatory Reason", ha='center', va='center', fontsize=6.2, fontweight='bold', color='#C62828')

# Connective lines
ax.annotate("", xy=(50, 83), xytext=(50, 88), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST))
ax.annotate("Yes", xy=(72, 77), xytext=(56, 77), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST), fontsize=7)
ax.annotate("No", xy=(32, 77), xytext=(44, 77), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST), fontsize=7)
ax.annotate("", xy=(78, 65), xytext=(78, 71), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST))
ax.annotate("Tap Register", xy=(23, 66), xytext=(21, 74), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_GOLD), fontsize=6.5)
ax.annotate("", xy=(40, 52), xytext=(36, 52), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST))
ax.annotate("", xy=(50, 40), xytext=(50, 48), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST))
ax.annotate("", xy=(50, 24), xytext=(50, 32), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST))
ax.annotate("Approve", xy=(75, 17), xytext=(57, 17), arrowprops=dict(arrowstyle="->", lw=1.2, color=C_FOREST), fontsize=6)
ax.annotate("Request Info", xy=(75, 31), xytext=(55, 22), arrowprops=dict(arrowstyle="->", lw=1.2, color='#E65100'), fontsize=6)
ax.annotate("Reject", xy=(28, 17), xytext=(43, 17), arrowprops=dict(arrowstyle="->", lw=1.2, color='#C62828'), fontsize=6)

plt.tight_layout()
plt.savefig(os.path.join(output_dir, "diagram_10_auth_flowchart.png"), bbox_inches='tight')
plt.close()
print("Saved diagram_10_auth_flowchart.png")

print("ALL 11 HIGH-RESOLUTION DIAGRAM IMAGES SUCCESSFULLY GENERATED!")
