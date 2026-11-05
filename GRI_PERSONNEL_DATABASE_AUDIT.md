# GRI Personnel Database Audit

## Audit Date: 2026-11-05

## Scope

Audited the verified official faculty, leadership, and administrative personnel
from the canonical dataset generated from https://www.ruraluniv.ac.in/.

## Faculty Overview

| Metric | Count |
|--------|-------|
| Unique Faculty Records | 118 |
| Total Affiliations (before dedup) | ~200+ |
| Primary Roles Distribution | HOD: 18, Professor: 38, Associate Professor: 25, Assistant Professor: 37 |

## Deduplication

- Faculty deduplicated by `data-fid`/profile id
- Merging all affiliations per unique individual
- Preferring role designations (HOD/dean/officer) for display
- Final count of 118 unique individuals after merging

## Faculty Distribution by Role

- **HOD/Dean**: 18 (includes 9 school deans + 9 department HODs)
- **Professor**: 38
- **Associate Professor**: 25
- **Assistant Professor**: 37

## Gender & Representation (as published)

The canonical dataset does not publish gender markers; representation
analysis is not possible from the available data fields.

## Leadership Roles (13 verified)

| Name | Designation | Portfolio |
|------|-------------|-----------|
| Dr. KM. Annamalai | Chancellor | — |
| Prof. Dr. N. Panchanatham | Vice-Chancellor | — |
| Dr. K. Marimuthu | Registrar | — |
| Dr. V. Sivakumar | CoE | — |
| Dr. K. Ravichandran | Finance Officer (i/c) | — |
| Dr. P. Balasubramaniam | CVO | — |
| + 8 additional executive officers | Various | — |

## Deans (9 verified)

| Dean | School | Designation |
|------|--------|-------------|
| Dr. P. Anandakumar | School of Tamil, Indian Languages and Rural Arts | School of Tamil, Indian Languages and Rural Arts |
| Dr. S. Balasundari | School of English & Foreign Languages | Professor & Dean |
| Dr. R. Venkataravi | School of Health Sciences & Rural Development | — |
| Dr. R. Mani | School of Social Sciences | — |
| B. Tamilmani | School of Management | — |
| Dr. P. Balasubramaniam | School of Sciences & Rural Technology | — |
| Dr. P. Kalavathi | School of Computer Science & Technologies | — |
| Dr. A. Ramanathan | School of Agriculture & Rural Innovation | — |
| S. Manivel | Student Welfare | Student Welfare |

## Contact Policy

- **Direct emails, phone extensions, and fees are not published** by the
  university on the official website. The app UI respects this and never
  invents or displays such fields.
- Only the general office contact is shown: `grucc@ruraluniv.ac.in` and
  `0451-2452371`.

## Audit Findings

- No fabricated personnel records detected.
- All faculty records traceable to official page source URLs.
- Person-photo mapping accurate via `data-fid`/`profile_id` deduplication.
- 0 records with invented contact fields (enforced by service layer).