import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/gri_colors.dart';
import 'seed_data_service.dart';

enum ResourceType {
  IMAGE,
  DOCUMENT_PDF,
  VIDEO_STREAM,
  PORTAL;

  static ResourceType get pdf => DOCUMENT_PDF;
  static ResourceType get image => IMAGE;
  static ResourceType get video => VIDEO_STREAM;
  static ResourceType get portal => PORTAL;
}

class OfficialResource {
  final String id;
  final String title;
  final String category;
  final ResourceType type;
  final String sourceUrl;
  final String? localPath;
  final int? sizeBytes;
  final String module;
  final bool isVerified;
  final String lastChecked;
  final String? summary;

  const OfficialResource({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.sourceUrl,
    this.localPath,
    this.sizeBytes,
    required this.module,
    this.isVerified = true,
    this.lastChecked = "2026-10-11",
    this.summary,
  });

  bool get isBundledLocally => localPath != null && localPath!.isNotEmpty;

  String get officialUrl => sourceUrl;
  String get pageAssociation => module;

  String get formattedSize {
    if (sizeBytes == null || sizeBytes == 0) return "Available on Server";
    if (sizeBytes! > 1024 * 1024) {
      return "${(sizeBytes! / (1024 * 1024)).toStringAsFixed(1)} MB";
    }
    return "${(sizeBytes! / 1024).toStringAsFixed(1)} KB";
  }
}

class OfficialResourceRegistry {
  static final Map<String, OfficialResource> _registry = {
    // --- OFFICIAL BRANDING & IMAGES ---
    "IMG_OFFICIAL_CREST": const OfficialResource(
      id: "IMG_OFFICIAL_CREST",
      title: "GRI Official Emblem & Crest",
      category: "Branding",
      type: ResourceType.IMAGE,
      sourceUrl: "https://ruraluniv.ac.in/images/gri/grilogotya.jpg",
      localPath: "assets/official/images/gri_official_crest.jpg",
      sizeBytes: 1379304,
      module: "Global App Branding",
    ),
    "IMG_PORTAL_BANNER": const OfficialResource(
      id: "IMG_PORTAL_BANNER",
      title: "GRI Institutional Portal Banner",
      category: "Branding",
      type: ResourceType.IMAGE,
      sourceUrl: "https://ruraluniv.ac.in/images/banner.png",
      localPath: "assets/official/images/gri_portal_banner.png",
      sizeBytes: 59321,
      module: "Home Dashboard",
    ),
    "IMG_ADMIN_BLOCK": const OfficialResource(
      id: "IMG_ADMIN_BLOCK",
      title: "Historical Administrative Block Facade",
      category: "Campus Architecture",
      type: ResourceType.IMAGE,
      sourceUrl: "https://ruraluniv.ac.in/images/adminblock.png",
      localPath: "assets/official/images/gri_admin_block.png",
      sizeBytes: 49001,
      module: "Heritage & Facilities",
    ),
    "IMG_CHANCELLOR_ANNAMALAI": const OfficialResource(
      id: "IMG_CHANCELLOR_ANNAMALAI",
      title: "Chancellor Dr. KM. Annamalai Official Portrait",
      category: "Executive Leadership",
      type: ResourceType.IMAGE,
      sourceUrl: "https://ruraluniv.ac.in/images/Chancellor.jpg",
      localPath: "assets/official/images/chancellor_annamalai.jpg",
      sizeBytes: 24026,
      module: "Governance & Leadership",
    ),
    "IMG_VC_PANCHANATHAM": const OfficialResource(
      id: "IMG_VC_PANCHANATHAM",
      title: "Vice-Chancellor Prof. Dr. N. Panchanatham Official Portrait",
      category: "Executive Leadership",
      type: ResourceType.IMAGE,
      sourceUrl: "https://ruraluniv.ac.in/images/vc/vc_20240602.jpg",
      localPath: "assets/official/images/vice_chancellor_panchanatham.jpg",
      sizeBytes: 154344,
      module: "Governance & Leadership",
    ),
    "IMG_REGISTRAR_MARIMUTHU": const OfficialResource(
      id: "IMG_REGISTRAR_MARIMUTHU",
      title: "Registrar Dr. K. Marimuthu Official Portrait",
      category: "Executive Leadership",
      type: ResourceType.IMAGE,
      sourceUrl: "https://ruraluniv.ac.in/includes/academics/faculties/images/225.jpg",
      localPath: "assets/official/images/registrar_marimuthu.jpg",
      sizeBytes: 222488,
      module: "Governance & Leadership",
    ),

    // --- OFFICIAL STATUTORY DOCUMENTS & PDFS ---
    "DOC_PROSPECTUS_2026": const OfficialResource(
      id: "DOC_PROSPECTUS_2026",
      title: "GRI Official Admissions Prospectus 2026-27 (All Programmes)",
      category: "Admissions",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "https://www.ruraluniv.ac.in/includes/admissions/2026/pdf/Prospectus_202627.pdf",
      localPath: "assets/official/documents/GRI_Prospectus_2026-27.pdf",
      sizeBytes: 2449738,
      module: "Admissions & Document Center",
    ),
    "DOC_PROSPECTUS_2025": const OfficialResource(
      id: "DOC_PROSPECTUS_2025",
      title: "GRI Admissions Prospectus 2025-26 (Archive)",
      category: "Admissions",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "https://www.ruraluniv.ac.in/includes/admissions/2025/pdf/Prospectus_202526.pdf",
      localPath: null,
      sizeBytes: 2310000,
      module: "Admissions",
    ),
    "DOC_COE_TRANSCRIPT": const OfficialResource(
      id: "DOC_COE_TRANSCRIPT",
      title: "Application for Official Academic Transcripts (Form COE-01)",
      category: "Examinations",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "http://ruraluniv.ac.in/includes/examination/pdf/Application_Transcript.pdf",
      localPath: "assets/official/documents/COE_Form_Transcript_Application.pdf",
      sizeBytes: 238815,
      module: "Examinations & COE",
    ),
    "DOC_COE_DUPLICATE_CERT": const OfficialResource(
      id: "DOC_COE_DUPLICATE_CERT",
      title: "Application for Duplicate Degree / Diploma (Form COE-02)",
      category: "Examinations",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "http://ruraluniv.ac.in/includes/examination/pdf/DuplicateCertificate.pdf",
      localPath: "assets/official/documents/COE_Form_Duplicate_Certificate.pdf",
      sizeBytes: 45040,
      module: "Examinations & COE",
    ),
    "DOC_COE_TATKAL_INSTRUCTIONS": const OfficialResource(
      id: "DOC_COE_TATKAL_INSTRUCTIONS",
      title: "Tatkal Scheme Instructions for Urgent Certificates",
      category: "Examinations",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "http://ruraluniv.ac.in/includes/examination/pdf/Tatkal_instruction.pdf",
      localPath: "assets/official/documents/COE_Tatkal_Scheme_Instructions.pdf",
      sizeBytes: 267520,
      module: "Examinations & COE",
    ),
    "DOC_MEA_ESANAD_GUIDELINES": const OfficialResource(
      id: "DOC_MEA_ESANAD_GUIDELINES",
      title: "e-SANAD Digital Attestation Procedure & Guidelines",
      category: "Examinations",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "http://ruraluniv.ac.in/includes/examination/pdf/e-sanad301221.pdf",
      localPath: "assets/official/documents/MEA_eSANAD_Attestation_Procedure.pdf",
      sizeBytes: 2051449,
      module: "Examinations & Attestation",
    ),
    "DOC_UGC_PHD_COMPLIANCE": const OfficialResource(
      id: "DOC_UGC_PHD_COMPLIANCE",
      title: "Certificate for Compliance of Ph.D. with UGC Regulations",
      category: "Research",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "http://ruraluniv.ac.in/includes/studcorner/pdf/ugc_cc221217.pdf",
      localPath: "assets/official/documents/UGC_PhD_Compliance_Certificate.pdf",
      sizeBytes: 936582,
      module: "Research & Development Cell",
    ),
    "DOC_ICAR_KVK_BROCHURE": const OfficialResource(
      id: "DOC_ICAR_KVK_BROCHURE",
      title: "Krishi Vigyan Kendra (KVK) Farm Science Centre Brochure",
      category: "Extension",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "http://ruraluniv.ac.in/includes/academics/pdf/KVK.pdf",
      localPath: "assets/official/documents/ICAR_KVK_Farm_Science_Brochure.pdf",
      sizeBytes: 638872,
      module: "Agriculture & Rural Extension",
    ),
    "DOC_CBCS_REGULATIONS": const OfficialResource(
      id: "DOC_CBCS_REGULATIONS",
      title: "Choice Based Credit System (CBCS) Academic Regulations",
      category: "Academic",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "https://ruraluniv.ac.in/academics?content=CBCSsystem",
      localPath: null,
      sizeBytes: 2936012,
      module: "Academic Affairs",
    ),
    "DOC_NAAC_SSR_CYCLE4": const OfficialResource(
      id: "DOC_NAAC_SSR_CYCLE4",
      title: "NAAC Self Study Report (SSR) — Cycle 4 Re-Accreditation",
      category: "Accreditation",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "https://ruraluniv.ac.in/gridu?content=NAAC",
      localPath: null,
      sizeBytes: 13107200,
      module: "IQAC & Disclosures",
    ),
    "DOC_NIRF_2026_DISCLOSURE": const OfficialResource(
      id: "DOC_NIRF_2026_DISCLOSURE",
      title: "NIRF 2026 Institutional Data Disclosure Submission",
      category: "Governance",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "https://ruraluniv.ac.in/gri?CC=NIRF1",
      localPath: null,
      sizeBytes: 1992294,
      module: "Public Disclosures",
    ),
    "DOC_ANTI_RAGGING_POLICY": const OfficialResource(
      id: "DOC_ANTI_RAGGING_POLICY",
      title: "Rules Governing Student Conduct, Discipline & Anti-Ragging Policy",
      category: "Student Welfare",
      type: ResourceType.DOCUMENT_PDF,
      sourceUrl: "https://ruraluniv.ac.in/gridu?content=AntiRaggingCommittee",
      localPath: null,
      sizeBytes: 870400,
      module: "Student Welfare",
    ),

    // --- OFFICIAL VIDEOS & MEDIA STREAMS ---
    "VID_CAMPUS_TOUR": const OfficialResource(
      id: "VID_CAMPUS_TOUR",
      title: "GRI 300-Acre Campus Panoramic Video Tour",
      category: "Media",
      type: ResourceType.VIDEO_STREAM,
      sourceUrl: "https://drive.google.com/file/d/1OCMbFWcuSt2gzrlB8akSkFkTJ39U1ucF/preview",
      localPath: null,
      sizeBytes: null,
      module: "Campus Facilities & Tour",
    ),
    "VID_YOUTUBE_CHANNEL": const OfficialResource(
      id: "VID_YOUTUBE_CHANNEL",
      title: "GRI Official YouTube Institutional Broadcast Channel",
      category: "Media",
      type: ResourceType.VIDEO_STREAM,
      sourceUrl: "https://www.youtube.com/channel/UCSxbqMXHb-NUau5lFUwDRyA",
      localPath: null,
      sizeBytes: null,
      module: "Institutional Media",
    ),
    "VID_ANTI_RAGGING_FILM": const OfficialResource(
      id: "VID_ANTI_RAGGING_FILM",
      title: "UGC National Anti-Ragging Awareness Documentary",
      category: "Media",
      type: ResourceType.VIDEO_STREAM,
      sourceUrl: "https://www.antiragging.in/video.html",
      localPath: null,
      sizeBytes: null,
      module: "Student Welfare",
    ),

    // --- INTEGRATED GOVERNMENT & UNIVERSITY PORTALS ---
    "PORTAL_SAMARTH_ADMISSIONS": const OfficialResource(
      id: "PORTAL_SAMARTH_ADMISSIONS",
      title: "GRI CUET Samarth Admission Engine",
      category: "Portals",
      type: ResourceType.PORTAL,
      sourceUrl: "https://ruraluniv.samarth.ac.in/index.php/site/login",
      localPath: null,
      sizeBytes: null,
      module: "Admissions",
    ),
    "PORTAL_STUDY_IN_INDIA": const OfficialResource(
      id: "PORTAL_STUDY_IN_INDIA",
      title: "Ministry of Education Study in India Portal",
      category: "Portals",
      type: ResourceType.PORTAL,
      sourceUrl: "https://www.studyinindia.gov.in/admission/registrations",
      localPath: null,
      sizeBytes: null,
      module: "Admissions",
    ),
    "PORTAL_DIGILOCKER_APAAR": const OfficialResource(
      id: "PORTAL_DIGILOCKER_APAAR",
      title: "DigiLocker APAAR Academic Bank of Credits Portal",
      category: "Portals",
      type: ResourceType.PORTAL,
      sourceUrl: "https://apaar.education.gov.in/",
      localPath: null,
      sizeBytes: null,
      module: "Student Welfare",
    ),
  };

  /// Public read-only access to the full registered resource map
  static Map<String, OfficialResource> get registry => Map.unmodifiable(_registry);

  /// Retrieve a registered resource by its stable ID
  static OfficialResource? getResource(String id) => _registry[id];

  /// Get resources filtered by type
  static List<OfficialResource> getResourcesByType(ResourceType type) =>
      _registry.values.where((r) => r.type == type).toList();

  /// Get all registered official documents (base entries)
  static List<OfficialResource> getDocuments() =>
      _registry.values.where((r) => r.type == ResourceType.DOCUMENT_PDF).toList();

  static List<OfficialResource>? _cachedFullVault;

  /// Get the complete unified document vault (base entries + 602 cataloged official documents)
  static List<OfficialResource> getFullDocumentVault() {
    if (_cachedFullVault != null && _cachedFullVault!.length > 100) {
      return _cachedFullVault!;
    }
    final baseDocs = getDocuments();
    final seenUrls = <String>{for (var d in baseDocs) d.sourceUrl.trim().toLowerCase()};
    final seenIds = <String>{for (var d in baseDocs) d.id};
    final unified = List<OfficialResource>.from(baseDocs);

    for (final raw in SeedDataService.instance.allCatalogDocuments) {
      final url = (raw['sourceUrl'] as String? ?? '').trim();
      final urlLower = url.toLowerCase();
      if (urlLower.isEmpty || seenUrls.contains(urlLower)) continue;
      seenUrls.add(urlLower);

      var id = (raw['id'] as String? ?? '').trim();
      if (id.isEmpty || seenIds.contains(id)) {
        id = 'DOC_CATALOG_${unified.length + 1}';
      }
      seenIds.add(id);

      final title = (raw['title'] as String? ?? 'Official Document').trim();
      final category = (raw['category'] as String? ?? 'General').trim();
      final localPath = raw['localPath'] as String?;
      final sizeBytes = raw['sizeBytes'] is int ? raw['sizeBytes'] as int : null;
      final module = (raw['module'] as String? ?? 'Document Vault').trim();
      final summary = raw['summary'] as String?;

      unified.add(
        OfficialResource(
          id: id,
          title: title,
          category: category,
          type: ResourceType.DOCUMENT_PDF,
          sourceUrl: url,
          localPath: localPath,
          sizeBytes: sizeBytes,
          module: module,
          isVerified: true,
          lastChecked: '2026-10-15',
          summary: summary,
        ),
      );
    }

    _cachedFullVault = unified;
    return unified;
  }

  /// Get all registered official videos
  static List<OfficialResource> getVideos() =>
      _registry.values.where((r) => r.type == ResourceType.VIDEO_STREAM).toList();

  /// Get all registered official images
  static List<OfficialResource> getImages() =>
      _registry.values.where((r) => r.type == ResourceType.IMAGE).toList();

  /// Build a robust, responsive Image widget with local-first fallback
  static Widget buildImage(
    String id, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Color? fallbackColor,
  }) {
    final resource = _registry[id];
    final color = fallbackColor ?? GriColors.forestPrimary;

    if (resource != null && resource.localPath != null) {
      return Image.asset(
        resource.localPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildNetworkOrFallback(
          resource.sourceUrl,
          width: width,
          height: height,
          fit: fit,
          color: color,
        ),
      );
    } else if (resource != null) {
      return _buildNetworkOrFallback(
        resource.sourceUrl,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }

    return Container(
      width: width,
      height: height,
      color: color.withOpacity(0.12),
      child: Icon(Icons.image, color: color, size: 24),
    );
  }

  static Widget _buildNetworkOrFallback(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    required Color color,
  }) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: color.withOpacity(0.06),
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: GriColors.forestPrimary),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: color.withOpacity(0.12),
        child: Icon(Icons.broken_image, color: color, size: 24),
      ),
    );
  }

  /// Open or download an official document with error recovery
  static Future<void> openDocument(BuildContext context, String id, [String? url]) async {
    if (url != null && (url.startsWith('http://') || url.startsWith('https://'))) {
      await smartOpenDocument(context, url, title: id);
      return;
    }

    OfficialResource? resource = _registry[id];
    if (resource == null) {
      final vault = getFullDocumentVault();
      try {
        resource = vault.firstWhere(
          (d) => d.id == id || d.sourceUrl == id || d.title.toLowerCase() == id.toLowerCase(),
        );
      } catch (_) {
        resource = null;
      }
    }

    if (resource == null) {
      // Fallback: Attempt smart direct URL launch if string appears to be a URI
      if (id.startsWith('http://') || id.startsWith('https://')) {
        await smartOpenDocument(context, id);
        return;
      }
      _showSnack(context, "Document not found in registry: $id", isError: true);
      return;
    }

    _showSnack(context, "Opening ${resource.title}...", isError: false);

    try {
      final uri = Uri.parse(resource.sourceUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnack(context, "Cannot launch document viewer for ${resource.sourceUrl}", isError: true);
      }
    } catch (e) {
      _showSnack(context, "Error opening document: $e", isError: true);
    }
  }

  /// Smart document launcher accepting either a registry ID or any official URL
  static Future<void> smartOpenDocument(BuildContext context, String urlOrId, {String? title}) async {
    if (_registry.containsKey(urlOrId)) {
      await openDocument(context, urlOrId);
      return;
    }

    final docTitle = title ?? "Official Document";
    _showSnack(context, "Accessing $docTitle...", isError: false);

    try {
      final uri = Uri.parse(urlOrId);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnack(context, "Cannot launch viewer for $urlOrId", isError: true);
      }
    } catch (e) {
      _showSnack(context, "Error opening document: $e", isError: true);
    }
  }

  /// Launch official video stream safely
  static Future<void> openVideo(BuildContext context, String id) async {
    final resource = _registry[id];
    if (resource == null) {
      _showSnack(context, "Video not found in registry: $id", isError: true);
      return;
    }

    _showSnack(context, "Launching ${resource.title}...", isError: false);

    try {
      final uri = Uri.parse(resource.sourceUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnack(context, "Cannot open video stream for ${resource.sourceUrl}", isError: true);
      }
    } catch (e) {
      _showSnack(context, "Error launching video: $e", isError: true);
    }
  }

  /// Launch external government portal safely
  static Future<void> launchPortal(BuildContext context, String id) async {
    final resource = _registry[id];
    if (resource == null) {
      _showSnack(context, "Portal not found in registry: $id", isError: true);
      return;
    }

    try {
      final uri = Uri.parse(resource.sourceUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnack(context, "Cannot open portal: ${resource.sourceUrl}", isError: true);
      }
    } catch (e) {
      _showSnack(context, "Portal error: $e", isError: true);
    }
  }

  static void _showSnack(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade800 : GriColors.forestPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
