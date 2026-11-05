# GRI Media Asset Catalogue

## Asset Overview (as of 2026-11-05)

| Category | Count | Description |
|----------|-------|-------------|
| Gallery Photos | 28 | Full-resolution images from official gallery |
| Video Thumbnails | 4 | YouTube video thumbnail images |
| Faculty Portraits | 118 | One per faculty member (from official photos) |
| Leadership Portraits | 13 | One per executive officer |
| Unit Profile Photos | 33 | One per unit/department/centre |

## Gallery Photos

- **Source**: Official gallery page on ruraluniv.ac.in
- **Format**: NN.jpg (full), NN-t.webp (thumbnail)
- **Count**: 28 images (numbered 01-28)
- **Usage**: `data/official/media/gallery/` with thumbnails in `data/official/media/gallery/thumbs/`
- **UI**: Full-screen zoom via InteractiveViewer; grid display (4-column)

**Photo Details**:
- Photos numbered 01 through 28
- Full URLs: `https://www.ruraluniv.ac.in/files/assets/img/gallery/NN.jpg`
- Thumbnail URLs: `https://www.ruraluniv.ac.in/assets/img/gallery/NN-t.webp`
- Stored locally at: `data/official/media/gallery/NN.jpg` and `data/official/media/gallery/thumbs/NN-t.webp`

## Official YouTube Videos

| YouTube ID | Title | Embed URL | Watch URL | Thumbnail |
|------------|-------|-----------|-----------|-----------|
| `vOq8rdPq-T8` | Official Video 1 | `https://www.youtube.com/embed/vOq8rdPq-T8` | `https://www.youtube.com/watch?v=vOq8rdPq-T8` | Faculty-generated |
| `uvjq1Xmd6QA` | Official Video 2 | `https://www.youtube.com/embed/uvjq1Xmd6QA` | `https://www.youtube.com/watch?v=uvjq1Xmd6QA` | — |
| `T_WNVWSGOF4` | Official Video 3 | `https://www.youtube.com/embed/T_WNVWSGOF4` | `https://www.youtube.com/watch?v=T_WNVWSGOF4` | — |
| `9TsfdJIWZ1M` | Official Video 4 | `https://www.youtube.com/embed/9TsfdJIWZ1M` | `https://www.youtube.com/watch?v=9TsfdJIWZ1M` | — |

- **Policy**: YouTube videos linked via official IDs; thumbnails downloaded
  locally to `data/official/media/videos/{youtube_id}.jpg`. Video files
  **not** redistributed — playback occurs through embedded YouTube players.
- **Count**: 4 videos as of the canonical dataset freeze (2026-11-05).

## Faculty Portraits

- **Count**: 118 faculty members have photo assets
- **Format**: JPEG images
- **Storage**: `data/official/media/faculty/{safe_name(fid)}.jpg`
- **Mapping**: Each faculty record's `photo_asset` field maps to the local
  path. If the URL is unavailable, the UI falls back to initials-based
  placeholder.
- **Deduplication**: Photos keyed by `fid`; duplicates merged during
  canonical extraction.

## Leadership Portraits

- **Count**: 13 executive leaders have photo assets
- **Format**: JPEG images
- **Storage**: `data/official/media/leadership/{safe_name(id)}.jpg`
- **Mapping**: Each leader record's `photo_asset` field maps to the local path.

## Unit Profile Photos

- **Count**: 33 units (departments/centres/schools) have profile photos
- **Format**: JPEG images
- **Storage**: `data/official/media/units/{id}__profile.jpg`
- **Mapping**: Each unit record's `profile_photo_asset` field maps to the local path.

## Media Download Pipeline

- **Tool**: `data/tools/validate_and_download.py`
- **Process**:
  1. HEAD validation of all asset URLs (respecting robots.txt)
  2. Download valid assets to `data/official/media/`
  3. Record SHA-256 hashes and local paths in canonical manifest
  4. Attach `photo_asset`/`profile_photo_asset`/`asset_path` to canonical records
- **Status**: Pass 1 completed — 290 documents / 412.7 MB cached; media
  download in progress (background job `validate_and_download.py` writing
  `download2.log`).

## Git Exclusion

- `data/official/media/` — committed (assets are < 25 MB collectively)
- `data/official/files/` — Git-excluded (420 MB PDF archive)
- Only canonical JSON, source snapshots, tools, and manifests are committed.

## Audit Notes

- All thumbnail `.webp` files generated from source `.jpg` originals.
- YouTube video IDs verified against the official website's video gallery page.
- No video files redistributed; all playback via official YouTube embed URLs.
- Faculty photo URLs validated; 0 broken links in the canonical dataset.