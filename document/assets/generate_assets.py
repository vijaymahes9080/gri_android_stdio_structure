import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.gridspec import GridSpec
import numpy as np

os.makedirs(r"d:\current project\gri\document\assets", exist_ok=True)

# -------------------------------------------------------------------------
# Visual 1: Project Timeline & Gantt Schedule (gantt_pert_chart.png)
# -------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(12, 7), dpi=300)
tasks = [
    ("1. Portal Crawl & Content Inventory", 0, 21, "#2E7D32"),
    ("2. Requirements Analysis & SRS Signoff", 20, 15, "#2E7D32"),
    ("3. DB Modeling & Supabase RLS", 34, 15, "#1565C0"),
    ("4. Gandhian UI Design System", 35, 12, "#B8860B"),
    ("5. Dual-Tier Data Sync Pipeline", 48, 12, "#1565C0"),
    ("6. SeedData & Asset Caching Layer", 58, 10, "#00838F"),
    ("7. 25 Native Flutter Application Screens", 67, 25, "#2E7D32"),
    ("8. Multi-Role RBAC & Approval Engine", 75, 14, "#6A1B9A"),
    ("9. e-SANAD QR Attestation & Hall Ticket", 88, 10, "#D84315"),
    ("10. Automated Unit/Widget Testing (25 Tests)", 97, 10, "#2E7D32"),
    ("11. Device Verification & SDK 36 Build", 106, 8, "#00838F"),
    ("12. Campus Pilot Deployment & Final Handover", 113, 20, "#B8860B"),
]

y_pos = np.arange(len(tasks))
for i, (task_name, start, dur, col) in enumerate(tasks):
    ax.barh(i, dur, left=start, height=0.55, align='center', color=col, alpha=0.9, edgecolor='#1B5E20', linewidth=1.2)
    ax.text(start + dur + 1, i, f"{dur}d", va='center', ha='left', fontsize=8.5, fontweight='bold', color='#1B5E20')

ax.set_yticks(y_pos)
ax.set_yticklabels([t[0] for t in tasks], fontsize=9, fontweight='medium')
ax.invert_yaxis()
ax.set_xlabel('Project Timeline Duration (Days from June 1, 2026)', fontsize=10, fontweight='bold', color='#1B5E20')
ax.set_title('The Gandhigram Rural Institute Official Mobile Portal — Engineering Gantt & Critical Path', fontsize=12, fontweight='bold', color='#1B5E20', pad=15)
ax.grid(axis='x', linestyle='--', alpha=0.4)
ax.set_axisbelow(True)

# Annotate milestones
milestones = [(35, "M1: SRS Signoff"), (60, "M2: Arch Freeze"), (97, "M3: Code Freeze"), (114, "M4: QA Certified"), (133, "M5: Handover")]
for x, label in milestones:
    ax.axvline(x, color='#C62828', linestyle=':', linewidth=1.5)
    ax.text(x, -0.7, label, rotation=45, ha='left', va='bottom', fontsize=7.5, fontweight='bold', color='#C62828')

plt.tight_layout()
plt.savefig(r"d:\current project\gri\document\assets\gantt_pert_chart.png", bbox_inches='tight')
plt.close()

# -------------------------------------------------------------------------
# Visual 2: System Architecture Block Diagram (architecture_diagram.png)
# -------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(13, 8.5), dpi=300)
ax.set_xlim(0, 100)
ax.set_ylim(0, 100)
ax.axis('off')

# Layer background blocks
layers = [
    ("LAYER 1: PRESENTATION TIER (FLUTTER 3.x / DART 3.5)", 74, 22, "#E8F5E9", "#1B5E20"),
    ("LAYER 2: STATE MANAGEMENT & ORCHESTRATION (GriProvider)", 54, 16, "#FFF8E1", "#B8860B"),
    ("LAYER 3: BUSINESS SERVICES & INTEGRATION (Services & Registry)", 34, 16, "#E0F7FA", "#00838F"),
    ("LAYER 4: DUAL-TIER DATA STORAGE (Local Assets + Supabase Cloud)", 14, 16, "#EDE7F6", "#4A148C"),
    ("LAYER 5: EXTERNAL NATIONAL GATEWAYS (e-SANAD, Samarth, DigiLocker)", 0, 10, "#ECEFF1", "#37474F"),
]

for title, y, h, bg, border in layers:
    rect = patches.FancyBboxPatch((2, y), 96, h, boxstyle="round,pad=1", facecolor=bg, edgecolor=border, linewidth=1.8)
    ax.add_patch(rect)
    ax.text(4, y + h - 3, title, fontsize=9.5, fontweight='bold', color=border)

# Add sub-components
# Layer 1 Subcomponents
l1_boxes = [
    ("25 Native Application Screens\n(Home, Academics, Approvals,\nServices, Documents, AI Chat)", 5, 76, 28, 14, "#C8E6C9"),
    ("Institutional Dialogs & Modals\n(RoleSwitcher, RegistrationWizard,\nAdminReview, HallTicketModal)", 36, 76, 28, 14, "#C8E6C9"),
    ("Gandhian Aesthetic System\n(Forest Green #1B5E20, Khadi Ochre\nNoto Sans Tamil, GriMotion)", 67, 76, 28, 14, "#C8E6C9")
]
for text, x, y, w, h, c in l1_boxes:
    ax.add_patch(patches.Rectangle((x, y), w, h, facecolor=c, edgecolor='#1B5E20', linewidth=1))
    ax.text(x + w/2, y + h/2, text, ha='center', va='center', fontsize=8, color='#1B5E20', fontweight='semibold')

# Layer 2 Subcomponents
l2_boxes = [
    ("Role-Based Access Control\n(Student, Faculty, Admin, COE, Scholar)", 5, 56, 28, 10, "#FFE082"),
    ("Account Status Workflow Engine\n(Pending -> Under Review -> Approved)", 36, 56, 28, 10, "#FFE082"),
    ("Biometric & Course Attendance Cache\n(Dynamic Threshold & Eligibility Checks)", 67, 56, 28, 10, "#FFE082")
]
for text, x, y, w, h, c in l2_boxes:
    ax.add_patch(patches.Rectangle((x, y), w, h, facecolor=c, edgecolor='#B8860B', linewidth=1))
    ax.text(x + w/2, y + h/2, text, ha='center', va='center', fontsize=8, color='#5D4037', fontweight='semibold')

# Layer 3 Subcomponents
l3_boxes = [
    ("SeedDataService\n(8 Schools, 30+ Depts, Courses)", 5, 36, 21, 10, "#B2EBF2"),
    ("SupabaseService\n(Realtime Client & Offline Sync)", 28, 36, 21, 10, "#B2EBF2"),
    ("OfficialResourceRegistry\n(309 Web Routes & PDF Resolvers)", 51, 36, 21, 10, "#B2EBF2"),
    ("OfficialWebSyncService\n(SHA-256 Checksums & Content Hashes)", 74, 36, 21, 10, "#B2EBF2")
]
for text, x, y, w, h, c in l3_boxes:
    ax.add_patch(patches.Rectangle((x, y), w, h, facecolor=c, edgecolor='#00838F', linewidth=1))
    ax.text(x + w/2, y + h/2, text, ha='center', va='center', fontsize=7.5, color='#006064', fontweight='semibold')

# Layer 4 Subcomponents
l4_boxes = [
    ("Local SharedPreferences\n(Tokens, Cache, Themes)", 5, 16, 28, 10, "#D1C4E9"),
    ("Pre-Packaged Asset Bundle\n(website_inventory.json, 7 PDFs, 17 Imgs)", 36, 16, 28, 10, "#D1C4E9"),
    ("Supabase PostgreSQL 16 (Cloud)\n(22 Tables with Row-Level Security)", 67, 16, 28, 10, "#D1C4E9")
]
for text, x, y, w, h, c in l4_boxes:
    ax.add_patch(patches.Rectangle((x, y), w, h, facecolor=c, edgecolor='#4A148C', linewidth=1))
    ax.text(x + w/2, y + h/2, text, ha='center', va='center', fontsize=8, color='#4A148C', fontweight='semibold')

# Layer 5 Subcomponents
l5_boxes = [
    ("MEA e-SANAD Apostille", 5, 2, 28, 6, "#CFD8DC"),
    ("Samarth@GRI ERP Portal", 36, 2, 28, 6, "#CFD8DC"),
    ("DigiLocker APAAR / NAD", 67, 2, 28, 6, "#CFD8DC")
]
for text, x, y, w, h, c in l5_boxes:
    ax.add_patch(patches.Rectangle((x, y), w, h, facecolor=c, edgecolor='#37474F', linewidth=1))
    ax.text(x + w/2, y + h/2, text, ha='center', va='center', fontsize=8, color='#263238', fontweight='semibold')

ax.set_title('The Gandhigram Rural Institute Official Mobile Portal — 5-Tier System Architecture', fontsize=12, fontweight='bold', color='#1B5E20', pad=10)
plt.tight_layout()
plt.savefig(r"d:\current project\gri\document\assets\architecture_diagram.png", bbox_inches='tight')
plt.close()

# -------------------------------------------------------------------------
# Visual 3: Wireframes of Core Mobile Screens (wireframes_overview.png)
# -------------------------------------------------------------------------
fig, axes = plt.subplots(1, 4, figsize=(15, 8.5), dpi=300)

screen_titles = [
    "1. Home Dashboard\n(home_dashboard_screen.dart)",
    "2. Academics & Exams\n(academics_hub_screen.dart)",
    "3. Admin Approvals\n(admin_approval_center_screen.dart)",
    "4. GRI-Sahayak AI\n(ask_gri_ai_screen.dart)"
]

# Wireframe 1: Home Dashboard
ax = axes[0]
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((2, 2), 96, 96, boxstyle="round,pad=1", facecolor='#F9F9F4', edgecolor='#1B5E20', lw=2))
# Top Bar
ax.add_patch(patches.Rectangle((5, 85), 90, 10, facecolor='#1B5E20'))
ax.text(50, 90, "GRI OFFICIAL MOBILE PORTAL", color='white', ha='center', va='center', fontsize=7, fontweight='bold')
# Role Badge
ax.add_patch(patches.Rectangle((5, 78), 90, 5, facecolor='#FFE082'))
ax.text(50, 80.5, "Role: STUDENT (23MCA042) [Switch]", color='#5D4037', ha='center', va='center', fontsize=6, fontweight='bold')
# Banner Carousel
ax.add_patch(patches.Rectangle((5, 62), 90, 14, facecolor='#C8E6C9', edgecolor='#1B5E20'))
ax.text(50, 69, "Samarth@GRI End Semester Exams\nOfficial Timetable & Hall Tickets Live", ha='center', va='center', fontsize=6.5, color='#1B5E20')
# Quick Action Grid (4 buttons)
for idx, (bx, by, lbl) in enumerate([(8, 48, "Courses"), (52, 48, "Attendance"), (8, 34, "Hall Ticket"), (52, 34, "Bus Pass")]):
    ax.add_patch(patches.Rectangle((bx, by), 40, 11, facecolor='#FFFFFF', edgecolor='#B8860B', lw=1))
    ax.text(bx+20, by+5.5, lbl, ha='center', va='center', fontsize=7, fontweight='bold', color='#1B5E20')
# Circulars Section
ax.text(8, 28, "Statutory Circulars & Notices", fontsize=7.5, fontweight='bold', color='#1B5E20')
for cy in [20, 12]:
    ax.add_patch(patches.Rectangle((5, cy), 90, 6, facecolor='#FFFFFF', edgecolor='#CCCCCC'))
    ax.text(8, cy+3, "[URGENT] e-SANAD Attestation Guidelines", fontsize=5.5, va='center')
# Bottom Nav
ax.add_patch(patches.Rectangle((5, 3), 90, 6, facecolor='#1B5E20'))
ax.text(50, 6, "Home | Academics | Campus | Services | More", color='white', ha='center', va='center', fontsize=6)
ax.set_title(screen_titles[0], fontsize=8.5, fontweight='bold', color='#1B5E20')

# Wireframe 2: Academics & Examination Hub
ax = axes[1]
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((2, 2), 96, 96, boxstyle="round,pad=1", facecolor='#F9F9F4', edgecolor='#1B5E20', lw=2))
ax.add_patch(patches.Rectangle((5, 85), 90, 10, facecolor='#1B5E20'))
ax.text(50, 90, "ACADEMICS & EXAMINATION HUB", color='white', ha='center', va='center', fontsize=7, fontweight='bold')
# Tab Bar
ax.add_patch(patches.Rectangle((5, 78), 90, 6, facecolor='#E0E0E0'))
ax.text(50, 81, "[Courses]  |  Timetable  |  Results  |  COE Forms", ha='center', va='center', fontsize=6, fontweight='bold')
# Aggregate Attendance Card
ax.add_patch(patches.Rectangle((5, 62), 90, 13, facecolor='#E8F5E9', edgecolor='#2E7D32'))
ax.text(10, 71, "Overall Attendance: 88.5% (Eligible)", fontsize=7, fontweight='bold', color='#1B5E20')
ax.text(10, 65, "Total Classes: 160  |  Attended: 142  |  Threshold: 75%", fontsize=5.5, color='#333333')
# Course Cards
for cy, code, title, att in [(48, "CS501", "Advanced Cloud Computing", "91%"), (34, "RD402", "Gandhian Reconstruction", "84%"), (20, "CS505", "Distributed Mobile Architectures", "88%")]:
    ax.add_patch(patches.Rectangle((5, cy), 90, 11, facecolor='#FFFFFF', edgecolor='#B8860B', lw=1))
    ax.text(8, cy+7, f"{code}: {title}", fontsize=6.5, fontweight='bold', color='#1B5E20')
    ax.text(8, cy+3, f"Faculty: Prof. Incharge  |  Attendance: {att}", fontsize=5.5, color='#666666')
# Hall Ticket Button
ax.add_patch(patches.Rectangle((15, 10), 70, 7, facecolor='#B8860B'))
ax.text(50, 13.5, "DOWNLOAD e-SANAD HALL TICKET (QR)", color='white', ha='center', va='center', fontsize=6, fontweight='bold')
# Bottom Nav
ax.add_patch(patches.Rectangle((5, 3), 90, 6, facecolor='#1B5E20'))
ax.text(50, 6, "Home | [Academics] | Campus | Services | More", color='white', ha='center', va='center', fontsize=6)
ax.set_title(screen_titles[1], fontsize=8.5, fontweight='bold', color='#1B5E20')

# Wireframe 3: Admin Approval Center
ax = axes[2]
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((2, 2), 96, 96, boxstyle="round,pad=1", facecolor='#F9F9F4', edgecolor='#1B5E20', lw=2))
ax.add_patch(patches.Rectangle((5, 85), 90, 10, facecolor='#1B5E20'))
ax.text(50, 90, "ADMIN REGISTRATION APPROVAL DOSSIER", color='white', ha='center', va='center', fontsize=6.5, fontweight='bold')
# Filter Chips
ax.text(8, 80, "Filters: [All (14)]  [Pending (8)]  [Under Review (4)]  [Approved]", fontsize=5.5, color='#1B5E20', fontweight='bold')
# Dossier Card 1
ax.add_patch(patches.Rectangle((5, 54), 90, 22, facecolor='#FFFFFF', edgecolor='#B8860B', lw=1.2))
ax.text(8, 72, "Application: APP-2026-9042", fontsize=6.5, fontweight='bold', color='#1B5E20')
ax.text(8, 67, "Applicant: Srimari Vijay (23MCA042)", fontsize=6, color='#333333')
ax.text(8, 62, "Role: STUDENT | Dept: Computer Science", fontsize=5.5, color='#666666')
ax.add_patch(patches.Rectangle((8, 56), 26, 5, facecolor='#2E7D32'))
ax.text(21, 58.5, "APPROVE", color='white', ha='center', va='center', fontsize=5.5, fontweight='bold')
ax.add_patch(patches.Rectangle((37, 56), 26, 5, facecolor='#D84315'))
ax.text(50, 58.5, "REJECT", color='white', ha='center', va='center', fontsize=5.5, fontweight='bold')
ax.add_patch(patches.Rectangle((66, 56), 26, 5, facecolor='#0277BD'))
ax.text(79, 58.5, "REQUEST INFO", color='white', ha='center', va='center', fontsize=5, fontweight='bold')
# Dossier Card 2
ax.add_patch(patches.Rectangle((5, 28), 90, 22, facecolor='#FFFFFF', edgecolor='#CCCCCC'))
ax.text(8, 46, "Application: APP-2026-9043", fontsize=6.5, fontweight='bold', color='#333333')
ax.text(8, 41, "Applicant: Dr. R. Subramanian (FAC-108)", fontsize=6, color='#333333')
ax.text(8, 36, "Role: FACULTY | Dept: Rural Technology", fontsize=5.5, color='#666666')
ax.add_patch(patches.Rectangle((8, 30), 26, 5, facecolor='#2E7D32'))
ax.text(21, 32.5, "APPROVE", color='white', ha='center', va='center', fontsize=5.5, fontweight='bold')
ax.add_patch(patches.Rectangle((37, 30), 26, 5, facecolor='#D84315'))
ax.text(50, 32.5, "REJECT", color='white', ha='center', va='center', fontsize=5.5, fontweight='bold')
ax.add_patch(patches.Rectangle((66, 30), 26, 5, facecolor='#0277BD'))
ax.text(79, 32.5, "REQUEST INFO", color='white', ha='center', va='center', fontsize=5, fontweight='bold')
# Audit Log Bar
ax.add_patch(patches.Rectangle((5, 12), 90, 10, facecolor='#ECEFF1'))
ax.text(8, 18, "Audit Trail: 14 dossiers processed today by Admin-01", fontsize=5.5, color='#455A64')
ax.text(8, 14, "Cloud Ledger: 100% in sync with Supabase PostgreSQL", fontsize=5.5, color='#2E7D32')
# Bottom Nav
ax.add_patch(patches.Rectangle((5, 3), 90, 6, facecolor='#1B5E20'))
ax.text(50, 6, "Home | [Approvals] | Academics | Services | More", color='white', ha='center', va='center', fontsize=6)
ax.set_title(screen_titles[2], fontsize=8.5, fontweight='bold', color='#1B5E20')

# Wireframe 4: Ask GRI AI Assistant
ax = axes[3]
ax.set_xlim(0, 100); ax.set_ylim(0, 100); ax.axis('off')
ax.add_patch(patches.FancyBboxPatch((2, 2), 96, 96, boxstyle="round,pad=1", facecolor='#F9F9F4', edgecolor='#1B5E20', lw=2))
ax.add_patch(patches.Rectangle((5, 85), 90, 10, facecolor='#1B5E20'))
ax.text(50, 90, "GRI-SAHAYAK AI ASSISTANT", color='white', ha='center', va='center', fontsize=7, fontweight='bold')
# Chat Message 1 (User)
ax.add_patch(patches.FancyBboxPatch((40, 72), 52, 10, boxstyle="round,pad=0.5", facecolor='#DCEDC8'))
ax.text(42, 77, "When do End-Semester Exams start\nfor MCA Semester 3?", fontsize=5.5, color='#1B5E20')
# Chat Message 2 (Bot)
ax.add_patch(patches.FancyBboxPatch((8, 52), 70, 16, boxstyle="round,pad=0.5", facecolor='#FFFFFF', edgecolor='#B8860B'))
ax.text(10, 63, "End-Semester Examinations commence\non November 18, 2026 according to the\nCOE Statutory Circular CIR-2026-NOV-01.\nHall tickets with e-SANAD QR tokens are live.", fontsize=5.5, color='#333333')
# Suggested Quick Prompts
ax.text(8, 44, "Suggested Queries:", fontsize=6, fontweight='bold', color='#1B5E20')
for py, prompt in [(36, "How do I apply for a duplicate degree?"), (28, "What are the Kasturba Hospital clinic hours?"), (20, "What is the bus schedule to Dindigul?")]:
    ax.add_patch(patches.Rectangle((5, py), 90, 6, facecolor='#F0F4C3', edgecolor='#9E9D24'))
    ax.text(8, py+3, f"• {prompt}", fontsize=5.5, color='#33691E')
# Input Field
ax.add_patch(patches.Rectangle((5, 10), 72, 7, facecolor='#FFFFFF', edgecolor='#B8860B'))
ax.text(8, 13.5, "Ask a question about GRI admissions, courses...", fontsize=5, color='#999999')
ax.add_patch(patches.Rectangle((80, 10), 15, 7, facecolor='#1B5E20'))
ax.text(87.5, 13.5, "SEND", color='white', ha='center', va='center', fontsize=5.5, fontweight='bold')
# Bottom Nav
ax.add_patch(patches.Rectangle((5, 3), 90, 6, facecolor='#1B5E20'))
ax.text(50, 6, "Home | Academics | Campus | Services | More", color='white', ha='center', va='center', fontsize=6)
ax.set_title(screen_titles[3], fontsize=8.5, fontweight='bold', color='#1B5E20')

plt.tight_layout()
plt.savefig(r"d:\current project\gri\document\assets\wireframes_overview.png", bbox_inches='tight')
plt.close()

print("Assets successfully generated in d:\\current project\\gri\\document\\assets")
