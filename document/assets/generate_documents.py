import os
import re
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

report_md_path = r"d:\current project\gri\document\Project_Report.md"
docx_out_path = r"d:\current project\gri\document\Project_Report.docx"
pdf_out_path = r"d:\current project\gri\document\Project_Report.pdf"

print("Starting document export generation...")

# =========================================================================
# Part 1: Generate Professional Word Document (Project_Report.docx)
# =========================================================================
doc = Document()

# Page Margins
sections = doc.sections
for s in sections:
    s.top_margin = Inches(1.0)
    s.bottom_margin = Inches(1.0)
    s.left_margin = Inches(1.0)
    s.right_margin = Inches(1.0)

# Colors
C_FOREST = RGBColor(0x1B, 0x5E, 0x20)
C_GOLD = RGBColor(0xB8, 0x86, 0x0B)
C_DARK = RGBColor(0x21, 0x21, 0x21)

def add_custom_heading(text, level):
    h = doc.add_heading(text, level=level)
    run = h.runs[0]
    if level == 1:
        run.font.size = Pt(18)
        run.font.color.rgb = C_FOREST
        run.font.bold = True
        h.paragraph_format.space_before = Pt(14)
        h.paragraph_format.space_after = Pt(6)
    elif level == 2:
        run.font.size = Pt(14)
        run.font.color.rgb = C_GOLD
        run.font.bold = True
        h.paragraph_format.space_before = Pt(10)
        h.paragraph_format.space_after = Pt(4)
    elif level == 3:
        run.font.size = Pt(12)
        run.font.color.rgb = C_FOREST
        run.font.bold = True
        h.paragraph_format.space_before = Pt(8)
        h.paragraph_format.space_after = Pt(2)
    return h

with open(report_md_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

in_code_block = False
code_buffer = []
in_table = False
table_rows = []

for line in lines:
    stripped = line.strip()

    # Code block detection (e.g. Mermaid or config)
    if stripped.startswith("```"):
        if in_code_block:
            in_code_block = False
            # Check if this was a diagram block or code
            code_str = "\n".join(code_buffer)
            # Add styled callout box for diagram/code
            p = doc.add_paragraph()
            p.paragraph_format.left_indent = Inches(0.4)
            p.paragraph_format.right_indent = Inches(0.4)
            run = p.add_run(f"[Diagram Source / Specification Block]\n{code_str}")
            run.font.name = "Consolas"
            run.font.size = Pt(7.5)
            run.font.color.rgb = RGBColor(0x33, 0x33, 0x33)
            code_buffer = []
        else:
            in_code_block = True
            code_buffer = []
        continue

    if in_code_block:
        code_buffer.append(line.rstrip())
        continue

    # Table detection
    if "|" in stripped and not stripped.startswith("#"):
        # Table row
        cells = [c.strip() for c in stripped.split("|")[1:-1]]
        # Skip separator line
        if cells and all(set(c) <= set("-: ") for c in cells):
            continue
        if not in_table:
            in_table = True
            table_rows = [cells]
        else:
            table_rows.append(cells)
        continue
    else:
        if in_table:
            in_table = False
            # Render Word table
            if table_rows:
                ncols = max(len(r) for r in table_rows)
                t = doc.add_table(rows=len(table_rows), cols=ncols)
                t.alignment = WD_TABLE_ALIGNMENT.CENTER
                for r_idx, row_data in enumerate(table_rows):
                    for c_idx, cell_value in enumerate(row_data):
                        if c_idx < ncols:
                            cell = t.cell(r_idx, c_idx)
                            cell.text = cell_value
                            for p in cell.paragraphs:
                                for r in p.runs:
                                    r.font.size = Pt(8.5)
                                    if r_idx == 0:
                                        r.font.bold = True
                                        r.font.color.rgb = C_FOREST
                            # Header shading
                            if r_idx == 0:
                                shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="E8F5E9"/>')
                                cell._tc.get_or_add_tcPr().append(shd)
            table_rows = []

    # Headings
    if stripped.startswith("# "):
        add_custom_heading(stripped[2:], level=1)
    elif stripped.startswith("## "):
        add_custom_heading(stripped[3:], level=2)
    elif stripped.startswith("### "):
        add_custom_heading(stripped[4:], level=3)
    elif stripped.startswith("#### "):
        add_custom_heading(stripped[5:], level=4)
    elif stripped.startswith("- "):
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_after = Pt(2)
        run = p.add_run(stripped[2:])
        run.font.size = Pt(10)
    elif stripped.startswith("---"):
        doc.add_paragraph()
    elif stripped:
        p = doc.add_paragraph()
        p.paragraph_format.space_after = Pt(4)
        p.paragraph_format.line_spacing = 1.15
        run = p.add_run(stripped)
        run.font.size = Pt(10)

# Add images to document if present
assets_dir = r"d:\current project\gri\document\assets"
for img_name, caption in [
    ("architecture_diagram.png", "Figure 2: Multi-Tier System Architecture Block Diagram"),
    ("gantt_pert_chart.png", "Figure 7: Engineering Gantt Schedule, Critical Path, and Milestone Gates"),
    ("wireframes_overview.png", "Figure 9: Core Application UI/UX Screen Wireframes")
]:
    img_path = os.path.join(assets_dir, img_name)
    if os.path.exists(img_path):
        doc.add_page_break()
        p_cap = doc.add_paragraph()
        p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = p_cap.add_run(caption)
        run.font.bold = True
        run.font.color.rgb = C_FOREST
        doc.add_picture(img_path, width=Inches(6.5))

doc.save(docx_out_path)
print(f"Project_Report.docx successfully written to {docx_out_path}")

# =========================================================================
# Part 2: Generate High-Quality Academic PDF (Project_Report.pdf)
# =========================================================================
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image, PageBreak, KeepTogether

pdf_doc = SimpleDocTemplate(
    pdf_out_path,
    pagesize=letter,
    leftMargin=40,
    rightMargin=40,
    topMargin=40,
    bottomMargin=40
)

styles = getSampleStyleSheet()

# Custom styles
title_style = ParagraphStyle(
    'DocTitle',
    parent=styles['Normal'],
    fontName='Helvetica-Bold',
    fontSize=18,
    leading=22,
    textColor=colors.HexColor('#1B5E20'),
    spaceAfter=6,
    alignment=1
)

sub_style = ParagraphStyle(
    'DocSub',
    parent=styles['Normal'],
    fontName='Helvetica-Bold',
    fontSize=12,
    leading=16,
    textColor=colors.HexColor('#B8860B'),
    spaceAfter=15,
    alignment=1
)

h1_style = ParagraphStyle(
    'DocH1',
    parent=styles['Normal'],
    fontName='Helvetica-Bold',
    fontSize=14,
    leading=18,
    textColor=colors.HexColor('#1B5E20'),
    spaceBefore=14,
    spaceAfter=6,
    keepWithNext=True
)

h2_style = ParagraphStyle(
    'DocH2',
    parent=styles['Normal'],
    fontName='Helvetica-Bold',
    fontSize=11,
    leading=15,
    textColor=colors.HexColor('#B8860B'),
    spaceBefore=10,
    spaceAfter=4,
    keepWithNext=True
)

body_style = ParagraphStyle(
    'DocBody',
    parent=styles['Normal'],
    fontName='Helvetica',
    fontSize=8.5,
    leading=11.5,
    textColor=colors.HexColor('#212121'),
    spaceAfter=4
)

code_style = ParagraphStyle(
    'DocCode',
    parent=styles['Normal'],
    fontName='Courier',
    fontSize=6.5,
    leading=8.5,
    textColor=colors.HexColor('#333333'),
    backColor=colors.HexColor('#F5F5F5'),
    spaceAfter=4
)

story = []

# Title Banner
story.append(Spacer(1, 15))
story.append(Paragraph("THE GANDHIGRAM RURAL INSTITUTE (DEEMED TO BE UNIVERSITY)", title_style))
story.append(Paragraph("OFFICIAL MOBILE APPLICATION PORTAL (GRI APP)", sub_style))
story.append(Paragraph("<b>Comprehensive Academic Project Report, System Architecture & Technical Audit</b>", ParagraphStyle('Sub2', parent=sub_style, fontSize=9.5, textColor=colors.HexColor('#424242'))))
story.append(Spacer(1, 10))

# Insert Key Visual Diagrams early in the PDF
for img_name, cap_text in [
    ("architecture_diagram.png", "Figure 2: Multi-Tier System Architecture Block Diagram"),
    ("gantt_pert_chart.png", "Figure 7: Engineering Gantt Schedule, Critical Path, and Milestone Gates"),
    ("wireframes_overview.png", "Figure 9: Core Application UI/UX Screen Wireframes")
]:
    img_path = os.path.join(assets_dir, img_name)
    if os.path.exists(img_path):
        story.append(Paragraph(f"<b>{cap_text}</b>", ParagraphStyle('Cap', parent=h2_style, alignment=1)))
        story.append(Spacer(1, 4))
        story.append(Image(img_path, width=530, height=300))
        story.append(Spacer(1, 10))

# Parse lines and add to story
in_cb = False
cb_text = []

with open(report_md_path, "r", encoding="utf-8") as f:
    for line in f:
        s = line.strip()
        if not s:
            continue
        if s.startswith("```"):
            if in_cb:
                in_cb = False
                c_block = "\n".join(cb_text[:15]) # truncate very long code
                story.append(Paragraph(f"<font face='Courier'>{c_block}</font>", code_style))
                cb_text = []
            else:
                in_cb = True
                cb_text = []
            continue
        if in_cb:
            cb_text.append(s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))
            continue
        if s.startswith("# "):
            story.append(Paragraph(s[2:], h1_style))
        elif s.startswith("## "):
            story.append(Paragraph(s[3:], h2_style))
        elif s.startswith("### "):
            story.append(Paragraph(s[4:], ParagraphStyle('H3', parent=h2_style, fontSize=9.5, textColor=colors.HexColor('#1B5E20'))))
        elif s.startswith("- "):
            clean_s = s[2:].replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            story.append(Paragraph(f"• {clean_s}", body_style))
        elif not s.startswith("|") and not s.startswith("---"):
            clean_s = s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            story.append(Paragraph(clean_s, body_style))

pdf_doc.build(story)
print(f"Project_Report.pdf successfully written to {pdf_out_path}")
print("All deliverables generated successfully!")
