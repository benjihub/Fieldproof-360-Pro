import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';

extension ReportSignatureEntityMapper on ReportSignatureEntity {
  ReportSignature toDomain() => ReportSignature(
    id: id,
    reportId: reportId,
    signatureType: ReportSignatureType.fromDatabase(signatureType),
    signerName: signerName,
    filePath: filePath,
    signedAt: signedAt,
  );
}
