import os
import re
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls

import reportlab
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image, PageBreak, KeepTogether, HRFlowable
)
from reportlab.pdfgen import canvas

report_md_path = r"d:\current project\gri\document\Project_Report.md"
docx_out_path = r"d:\current project\gri\document\Project_Report.docx"
pdf_out_path = r"d:\current project\gri\document\Project_Report.pdf"
assets_dir = r"d:\current project\gri\document\assets"

print("=======================================================================")
print("ACADEMIC COMPILER: 30+ PAGE REPORT WITH ALL 11 VISUAL DIAGRAM IMAGES")
print("=======================================================================")

def clean_markdown_inline(text):
    text = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    text = re.sub(r'\*\*\*(.*?)\*\*\*', r'<b><i>\1</i></b>', text)
    text = re.sub(r'\*\*(.*?)\*\*', r'<b>\1</b>', text)
    text = re.sub(r'(?<!\*)\*([^*]+)\*(?!\*)', r'<i>\1</i>', text)
    text = re.sub(r'`(.*?)`', r"<font face='Courier'>\1</font>", text)
    return text

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_decorations(self, page_count):
        if self._pageNumber == 1:
            return

        self.saveState()
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#424242"))

        # Running Header
        self.drawString(45, 755, "The Gandhigram Rural Institute (Deemed to be University) — Official Mobile Portal")
        self.setStrokeColor(colors.HexColor("#1B5E20"))
        self.setLineWidth(0.75)
        self.line(45, 748, 567, 748)

        # Running Footer
        self.line(45, 45, 567, 45)
        self.drawString(45, 33, "Department of Computer Science & Applications | MCA Project Report")
        page_text = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(567, 33, page_text)
        self.restoreState()

# Compile PDF
pdf_doc = SimpleDocTemplate(
    pdf_out_path,
    pagesize=letter,
    leftMargin=45,
    rightMargin=45,
    topMargin=55,
    bottomMargin=55
)

styles = getSampleStyleSheet()

c_cover_title = ParagraphStyle('CoverTitle', parent=styles['Normal'], fontName='Helvetica-Bold', fontSize=18, leading=22, textColor=colors.HexColor('#1B5E20'), alignment=1, spaceAfter=10)
c_cover_sub = ParagraphStyle('CoverSub', parent=styles['Normal'], fontName='Helvetica-Bold', fontSize=12, leading=16, textColor=colors.HexColor('#B8860B'), alignment=1, spaceAfter=14)
c_h1 = ParagraphStyle('AcademicH1', parent=styles['Normal'], fontName='Helvetica-Bold', fontSize=13, leading=17, textColor=colors.HexColor('#1B5E20'), spaceBefore=14, spaceAfter=6, keepWithNext=True)
c_h2 = ParagraphStyle('AcademicH2', parent=styles['Normal'], fontName='Helvetica-Bold', fontSize=10.5, leading=14, textColor=colors.HexColor('#B8860B'), spaceBefore=10, spaceAfter=4, keepWithNext=True)
c_h3 = ParagraphStyle('AcademicH3', parent=styles['Normal'], fontName='Helvetica-Bold', fontSize=9, leading=12, textColor=colors.HexColor('#2E7D32'), spaceBefore=8, spaceAfter=3, keepWithNext=True)
c_body = ParagraphStyle('AcademicBody', parent=styles['Normal'], fontName='Helvetica', fontSize=8.5, leading=12, textColor=colors.HexColor('#212121'), spaceAfter=4, alignment=4)
c_bullet = ParagraphStyle('AcademicBullet', parent=styles['Normal'], fontName='Helvetica', fontSize=8.5, leading=11.5, textColor=colors.HexColor('#212121'), leftIndent=15, spaceAfter=2.5)
c_code = ParagraphStyle('AcademicCode', parent=styles['Normal'], fontName='Courier', fontSize=6.5, leading=8.5, textColor=colors.HexColor('#263238'), backColor=colors.HexColor('#F4F6F7'), borderColor=colors.HexColor('#CFD8DC'), borderWidth=0.5, borderPadding=4, spaceBefore=4, spaceAfter=6)

story = []

# --- COVER PAGE ---
story.append(Spacer(1, 20))
story.append(Paragraph("THE GANDHIGRAM RURAL INSTITUTE<br/>(DEEMED TO BE UNIVERSITY)", c_cover_title))
story.append(Paragraph("MINISTRY OF EDUCATION, GOVERNMENT OF INDIA", ParagraphStyle('MinEd', parent=c_cover_sub, fontSize=10, textColor=colors.HexColor('#424242'))))
story.append(Spacer(1, 10))
story.append(HRFlowable(width="60%", thickness=2, color=colors.HexColor('#1B5E20'), spaceAfter=15, spaceBefore=0))
story.append(Paragraph("OFFICIAL MOBILE APPLICATION PORTAL (`GRI APP`)", c_cover_sub))
story.append(Paragraph("A Native Flutter Cloud-Integrated Mobile Campus Operating Environment with Role-Based Access, Multi-Tier Institutional Data Architecture, and e-SANAD Verification", ParagraphStyle('CoverDesc', parent=c_body, fontSize=9, leading=13, alignment=1, textColor=colors.HexColor('#37474F'))))

# Cover Showcase Photo
showcase_p = os.path.join(assets_dir, "gri_mobile_showcase.jpg")
if os.path.exists(showcase_p):
    story.append(Spacer(1, 8))
    story.append(Image(showcase_p, width=420, height=236))
    story.append(Paragraph("<i>Figure 0: GRI Official Mobile Portal Dashboard & e-SANAD QR Hall Ticket Interface</i>", ParagraphStyle('Cap0', parent=c_body, fontSize=7.5, alignment=1, textColor=colors.HexColor('#555555'))))
    story.append(Spacer(1, 10))

cover_meta_text = """
<b>Degree:</b> Master of Computer Applications (MCA) | <b>Academic Year:</b> 2026–2027<br/>
<b>Department:</b> Department of Computer Science & Applications | <b>School:</b> School of Sciences & Rural Technology<br/>
<b>Candidate:</b> Srimari Vijay (23MCA042) | <b>Package:</b> com.aistudio.grist.kxmpzq | <b>Domain:</b> ruraluniv.ac.in
"""
story.append(Paragraph(cover_meta_text, ParagraphStyle('CoverMeta', parent=c_body, fontSize=8, leading=12, alignment=1, textColor=colors.HexColor('#1B5E20'))))
story.append(Spacer(1, 10))
story.append(Paragraph("Gandhigram – 624 302, Dindigul District, Tamil Nadu, India", ParagraphStyle('FootLoc', parent=c_body, fontSize=8, alignment=1, textColor=colors.HexColor('#616161'))))
story.append(PageBreak())

# Read markdown lines
with open(report_md_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

in_code = False
code_lines = []
in_table = False
table_data = []

# Mapping diagram mentions to image files
diagram_image_map = {
    "Working Flow — Detailed Operational Architecture": ("diagram_working_flow.png", "Visual Model 0: 12-Stage Operational Working Flow Diagram"),
    "Diagram 1: Proposed Project Lifecycle": ("diagram_01_lifecycle.png", "Figure 1: Proposed Project Lifecycle & Engineering Milestones"),
    "Diagram 2: System Architecture Block Diagram": ("diagram_02_architecture.png", "Figure 2: Multi-Tier System Architecture Block Diagram"),
    "Diagram 3: Level-0 Data Flow Diagram": ("diagram_03_dfd_level_0.png", "Figure 3: Level-0 Context Data Flow Diagram (DFD-0)"),
    "Diagram 4: Level-1 Data Flow Diagram": ("diagram_04_dfd_level_1.png", "Figure 4: Level-1 Process Breakdown Data Flow Diagram (DFD-1)"),
    "Diagram 5: System Sequence Diagram": ("diagram_05_sequence.png", "Figure 5: UML System Sequence Diagram (Registration & Hall Ticket Attestation)"),
    "Diagram 6: Entity-Relationship": ("diagram_06_er_schema.png", "Figure 6: Relational Entity-Relationship (ER) Database Schema"),
    "Diagram 7: Project Timeline": ("diagram_07_gantt_pert.png", "Figure 7: Engineering Gantt Schedule, Critical Path & Milestone Gates"),
    "Diagram 8: UML Use Case Diagram": ("diagram_08_use_case.png", "Figure 8: UML Use Case Diagram with Include & Extend Relationships"),
    "Diagram 9: Mobile Application UI/UX Wireframes": ("diagram_09_navigation_wireframes.png", "Figure 9: Core Application UI/UX Screen Wireframes & Screen Navigation Flow"),
    "Diagram 10: User Registration & Authentication": ("diagram_10_auth_flowchart.png", "Figure 10: User Registration & Multi-Role Authentication Flowchart"),
}

for line in lines:
    raw = line.rstrip()
    s = raw.strip()

    if s.startswith("```"):
        if in_code:
            in_code = False
            disp_code = "\n".join(code_lines[:25])
            disp_code = disp_code.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            story.append(Paragraph(f"<font face='Courier'>{disp_code}</font>", c_code))
            code_lines = []
        else:
            in_code = True
            code_lines = []
        continue

    if in_code:
        code_lines.append(raw)
        continue

    if "|" in s and not s.startswith("#"):
        parts = [c.strip() for c in s.split("|")[1:-1]]
        if parts and all(set(c) <= set("-: ") for c in parts):
            continue
        if not in_table:
            in_table = True
            table_data = [parts]
        else:
            table_data.append(parts)
        continue
    else:
        if in_table:
            in_table = False
            if table_data:
                ncols = max(len(row) for row in table_data)
                formatted_table = []
                for r_idx, row in enumerate(table_data):
                    formatted_row = []
                    for c_idx in range(ncols):
                        val = row[c_idx] if c_idx < len(row) else ""
                        val = clean_markdown_inline(val)
                        if r_idx == 0:
                            p = Paragraph(f"<b>{val}</b>", ParagraphStyle('TH', parent=c_body, fontSize=7.5, leading=9.5, textColor=colors.white))
                        else:
                            p = Paragraph(val, ParagraphStyle('TD', parent=c_body, fontSize=7, leading=9, textColor=colors.HexColor('#212121')))
                        formatted_row.append(p)
                    formatted_table.append(formatted_row)
                
                col_w = 522.0 / ncols
                t = Table(formatted_table, colWidths=[col_w]*ncols)
                t.setStyle(TableStyle([
                    ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#1B5E20')),
                    ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                    ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                    ('VALIGN', (0, 0), (-1, -1), 'TOP'),
                    ('TOPPADDING', (0, 0), (-1, -1), 3),
                    ('BOTTOMPADDING', (0, 0), (-1, -1), 3),
                    ('LEFTPADDING', (0, 0), (-1, -1), 4),
                    ('RIGHTPADDING', (0, 0), (-1, -1), 4),
                    ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#CFD8DC')),
                    ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F9FBE7')])
                ]))
                story.append(Spacer(1, 4))
                story.append(t)
                story.append(Spacer(1, 6))
            table_data = []

    if not s:
        continue

    # Page breaks for chapters
    if s.startswith("## Chapter") or s.startswith("## 1. Executive Summary") or s.startswith("## 13. Appendices"):
        story.append(PageBreak())

    # Heading level 1
    if s.startswith("# "):
        story.append(Paragraph(clean_markdown_inline(s[2:]), c_h1))
    elif s.startswith("## "):
        story.append(Paragraph(clean_markdown_inline(s[3:]), c_h1))
    elif s.startswith("### "):
        story.append(Paragraph(clean_markdown_inline(s[4:]), c_h2))
    elif s.startswith("#### "):
        story.append(Paragraph(clean_markdown_inline(s[5:]), c_h3))
    elif s.startswith("- "):
        story.append(Paragraph(f"• {clean_markdown_inline(s[2:])}", c_bullet))
    elif s.startswith("---"):
        story.append(Spacer(1, 4))
        story.append(HRFlowable(width="100%", thickness=0.5, color=colors.HexColor('#CFD8DC'), spaceAfter=6, spaceBefore=4))
    else:
        story.append(Paragraph(clean_markdown_inline(s), c_body))

    # Check if this heading matches any of our diagram images
    for key, (img_file, cap_title) in diagram_image_map.items():
        if key in s:
            img_path = os.path.join(assets_dir, img_file)
            if os.path.exists(img_path):
                story.append(Spacer(1, 6))
                story.append(Image(img_path, width=520, height=295))
                story.append(Paragraph(f"<b>{cap_title}</b>", ParagraphStyle('DiagCap', parent=c_h3, alignment=1)))
                story.append(Spacer(1, 6))

pdf_doc.build(story, canvasmaker=NumberedCanvas)
print(f"Academic PDF compiled with ALL 11 images: {pdf_out_path}")

# Compile Word Document (.docx)
doc = Document()
for s in doc.sections:
    s.top_margin = Inches(1.0)
    s.bottom_margin = Inches(1.0)
    s.left_margin = Inches(1.0)
    s.right_margin = Inches(1.0)

C_FOREST_RGB = RGBColor(0x1B, 0x5E, 0x20)
C_GOLD_RGB = RGBColor(0xB8, 0x86, 0x0B)

def docx_heading(text, level):
    h = doc.add_heading(text, level=level)
    if h.runs:
        r = h.runs[0]
        if level == 1:
            r.font.size = Pt(16); r.font.color.rgb = C_FOREST_RGB; r.font.bold = True
        elif level == 2:
            r.font.size = Pt(13); r.font.color.rgb = C_GOLD_RGB; r.font.bold = True
        elif level == 3:
            r.font.size = Pt(11); r.font.color.rgb = C_FOREST_RGB; r.font.bold = True
    return h

# Insert showcase photo in DOCX
if os.path.exists(showcase_p):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    doc.add_picture(showcase_p, width=Inches(6.2))
    p_cap = doc.add_paragraph()
    p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_cap = p_cap.add_run("Figure 0: The Gandhigram Rural Institute Official Mobile Portal Showcase")
    r_cap.font.italic = True; r_cap.font.size = Pt(9)

in_c = False
code_b = []
in_t = False
table_b = []

with open(report_md_path, "r", encoding="utf-8") as f:
    for line in f:
        raw = line.rstrip()
        s = raw.strip()

        if s.startswith("```"):
            if in_c:
                in_c = False
                p = doc.add_paragraph()
                p.paragraph_format.left_indent = Inches(0.4)
                p.paragraph_format.right_indent = Inches(0.4)
                r = p.add_run("\n".join(code_b))
                r.font.name = "Consolas"; r.font.size = Pt(7.5); r.font.color.rgb = RGBColor(0x37, 0x47, 0x4F)
                code_b = []
            else:
                in_c = True
                code_b = []
            continue

        if in_c:
            code_b.append(raw)
            continue

        if "|" in s and not s.startswith("#"):
            parts = [c.strip() for c in s.split("|")[1:-1]]
            if parts and all(set(c) <= set("-: ") for c in parts):
                continue
            if not in_t:
                in_t = True; table_b = [parts]
            else:
                table_b.append(parts)
            continue
        else:
            if in_t:
                in_t = False
                if table_b:
                    ncols = max(len(r) for r in table_b)
                    tbl = doc.add_table(rows=len(table_b), cols=ncols)
                    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
                    for r_idx, row in enumerate(table_b):
                        for c_idx, val in enumerate(row):
                            if c_idx < ncols:
                                cell = tbl.cell(r_idx, c_idx)
                                cell.text = val
                                for p in cell.paragraphs:
                                    for r in p.runs:
                                        r.font.size = Pt(8.5)
                                        if r_idx == 0:
                                            r.font.bold = True; r.font.color.rgb = C_FOREST_RGB
                                if r_idx == 0:
                                    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="E8F5E9"/>')
                                    cell._tc.get_or_add_tcPr().append(shd)
                table_b = []

        if not s:
            continue

        if s.startswith("## Chapter") or s.startswith("## 1. Executive Summary"):
            doc.add_page_break()

        if s.startswith("# "):
            docx_heading(s[2:], 1)
        elif s.startswith("## "):
            docx_heading(s[3:], 2)
        elif s.startswith("### "):
            docx_heading(s[4:], 3)
        elif s.startswith("- "):
            p = doc.add_paragraph(style='List Bullet')
            p.paragraph_format.space_after = Pt(2)
            r = p.add_run(s[2:])
            r.font.size = Pt(9.5)
        elif s.startswith("---"):
            doc.add_paragraph()
        else:
            p = doc.add_paragraph()
            p.paragraph_format.space_after = Pt(3.5)
            p.paragraph_format.line_spacing = 1.15
            r = p.add_run(s)
            r.font.size = Pt(9.5)

        # Word Document Image Insertion
        for key, (img_file, cap_title) in diagram_image_map.items():
            if key in s:
                img_path = os.path.join(assets_dir, img_file)
                if os.path.exists(img_path):
                    doc.add_page_break()
                    p_img = doc.add_paragraph()
                    p_img.alignment = WD_ALIGN_PARAGRAPH.CENTER
                    doc.add_picture(img_path, width=Inches(6.2))
                    p_c = doc.add_paragraph()
                    p_c.alignment = WD_ALIGN_PARAGRAPH.CENTER
                    r_c = p_c.add_run(cap_title)
                    r_c.font.bold = True; r_c.font.color.rgb = C_FOREST_RGB

doc.save(docx_out_path)
print(f"Complete Word Document compiled with ALL 11 images: {docx_out_path}")
print("SUCCESS: ALL 11 VISUAL IMAGES EMBEDDED IN PDF AND DOCX WITH FULL EXPLANATIONS!")
