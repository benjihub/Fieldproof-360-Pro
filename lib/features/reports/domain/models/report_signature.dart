import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';

final class ReportSignature {
  const ReportSignature({
    required this.id,
    required this.reportId,
    required this.signatureType,
    required this.signerName,
    required this.filePath,
    required this.signedAt,
  });

  final String id;
  final String reportId;
  final ReportSignatureType signatureType;
  final String signerName;
  final String filePath;
  final DateTime signedAt;
}
