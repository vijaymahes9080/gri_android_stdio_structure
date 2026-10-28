import '../models/academic_models.dart';

enum DocumentVerificationStatus { authentic, notOnRegister, checksumFailed, invalidFormat }

class DocumentVerificationResult {
  final DocumentVerificationStatus status;
  final String code;
  final String message;
  final CertificateRecord? record;

  const DocumentVerificationResult({
    required this.status,
    required this.code,
    required this.message,
    this.record,
  });

  bool get isAuthentic => status == DocumentVerificationStatus.authentic;
}

class CertificateRecord {
  final String code;
  final String holderName;
  final String programme;
  final String registerNumber;
  final String issuedBy;
  final String issuedOn;

  const CertificateRecord({
    required this.code,
    required this.holderName,
    required this.programme,
    required this.registerNumber,
    required this.issuedBy,
    required this.issuedOn,
  });

  factory CertificateRecord.fromMap(Map<String, dynamic> map) =>
      CertificateRecord(
        code: map['code']?.toString() ?? '',
        holderName: map['holder_name']?.toString() ?? '',
        programme: map['programme']?.toString() ?? '',
        registerNumber: map['register_number']?.toString() ?? '',
        issuedBy: map['issued_by']?.toString() ?? '',
        issuedOn: map['issued_on']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'holder_name': holderName,
        'programme': programme,
        'register_number': registerNumber,
        'issued_by': issuedBy,
        'issued_on': issuedOn,
      };
}

/// Authenticity verification for GRI certificates.
///
/// Verification is evidence-based: the identifier must (1) match the official
/// code structure issued by the Controller of Examinations, (2) pass its
/// trailing check-digit checksum, and (3) exist on the verification register
/// (local mirror of the Supabase `document_certificates` table). Unknown or
/// malformed identifiers are always reported honestly as unverified.
class DocumentCertificationService {
  static DocumentCertificationService? _instance;
  static DocumentCertificationService get instance =>
      _instance ??= DocumentCertificationService._();
  DocumentCertificationService._();

  static final RegExp _codePattern =
      RegExp(r'^GRI-(CERT|MARK|DEG|TRAN)-(\d{4})-(\d{4,6})$');

  /// Check digit: decimal remainder of the sum of character codes of the
  /// identifier body. Recomputed at verification time rather than trusted
  /// from user input, so altered codes are detected deterministically.
  static int checkDigitFor(String body) {
    var sum = 0;
    for (final unit in body.codeUnits) {
      sum += unit;
    }
    return sum % 10;
  }

  final Map<String, CertificateRecord> _register = Map.fromEntries(
    _baseRegister.map((r) => MapEntry(r.code.toUpperCase(), r)),
  );

  /// Records mirrored from the cloud `document_certificates` table
  /// (fetched during cloud sync). Cloud records take precedence over the
  /// built-in development register when codes collide.
  void mergeCloudRecords(List<Map<String, dynamic>> rows) {
    for (final row in rows) {
      final record = CertificateRecord.fromMap(row);
      if (record.code.isNotEmpty) {
        _register[record.code.toUpperCase()] = record;
      }
    }
  }

  int get registerSize => _register.length;

  List<CertificateRecord> get registerRecords =>
      List.unmodifiable(_register.values);

  DocumentVerificationResult verify(String rawCode) {
    final code = rawCode.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');

    if (!_codePattern.hasMatch(code)) {
      return const DocumentVerificationResult(
        status: DocumentVerificationStatus.invalidFormat,
        code: '',
        message:
            'INVALID FORMAT: The identifier does not match the official structure '
            'issued by the Controller of Examinations '
            '(expected GRI-<TYPE>-<YEAR>-<SERIAL><CHECK>, e.g. GRI-CERT-2023-015468). '
            'Please scan the QR code on the document or contact the Office of CoE.',
      );
    }

    final body = code.substring(0, code.length - 1);
    final givenCheck = int.parse(code.substring(code.length - 1));
    final expectedCheck = checkDigitFor(body);
    if (givenCheck != expectedCheck) {
      return DocumentVerificationResult(
        status: DocumentVerificationStatus.checksumFailed,
        code: code,
        message:
            'CHECKSUM FAILURE: The trailing check digit is invalid for this '
            'identifier. The code may have been altered or mis-typed. '
            'Verification was refused; no certificate was found to be authentic. '
            'Please contact the Controller of Examinations office.',
      );
    }

    final record = _register[code];
    if (record == null) {
      return DocumentVerificationResult(
        status: DocumentVerificationStatus.notOnRegister,
        code: code,
        message:
            'NOT ON REGISTER: The identifier is structurally valid, but no '
            'certificate with this code exists on the current verification '
            'register (e-SANAD repository mirror). If this document is recent, '
            'sync the cloud register from the services hub, then retry; otherwise '
            'contact the Controller of Examinations.',
      );
    }

    return DocumentVerificationResult(
      status: DocumentVerificationStatus.authentic,
      code: code,
      message:
          'AUTHENTIC: Verified against the institutional e-SANAD register. '
          'Issued by ${record.issuedBy} on ${record.issuedOn} to '
          '${record.holderName} (${record.registerNumber}), ${record.programme}.',
      record: record,
    );
  }
}

/// Development-mode register contents. These are clearly labelled sample
/// records used for demonstration and QA; in cloud deployments the
/// `document_certificates` Supabase table (see
/// supabase/migrations/20261028..._document_certificates.sql) is authoritative
/// and is merged over this list after the first successful sync.
const List<CertificateRecord> _baseRegister = [
  CertificateRecord(
    code: 'GRI-CERT-2023-015468',
    holderName: 'Preethi Ramasamy',
    programme: 'B.Sc. (Hons) Agriculture',
    registerNumber: '2020-BSC-AGR-0901',
    issuedBy: 'Office of the Controller of Examinations, GRI',
    issuedOn: '18 Aug 2023',
  ),
  CertificateRecord(
    code: 'GRI-MARK-2024-40118',
    holderName: 'Vijay Pradhap',
    programme: 'M.C.A. — Semester IV Statement of Marks (CBCS)',
    registerNumber: '2024-MS-4011',
    issuedBy: 'Office of the Controller of Examinations, GRI',
    issuedOn: '06 Oct 2026',
  ),
  CertificateRecord(
    code: 'GRI-DEG-2022-022775',
    holderName: 'Aravind Manoharan',
    programme: 'M.A. Rural Development — Degree Certificate',
    registerNumber: '2020-MA-RD-1180',
    issuedBy: 'Office of the Registrar (Academic), GRI',
    issuedOn: '21 Feb 2022',
  ),
  CertificateRecord(
    code: 'GRI-TRAN-2026-009821',
    holderName: 'Divya Bharathi',
    programme: 'Ph.D. Rural Future Studies — Course Transcript',
    registerNumber: '2023-PHD-RFS-0412',
    issuedBy: 'Office of the Controller of Examinations, GRI',
    issuedOn: '12 Sep 2026',
  ),
];

/// Convenience validator shared with exam eligibility checks.
bool hasMinimumAttendance(List<CourseModel> courses, {int minimum = 75}) {
  if (courses.isEmpty) return true;
  return courses.every((c) => c.attendancePercent >= minimum);
}
