import 'dart:typed_data';

import 'package:fieldproof_360/features/reports/domain/models/report_signature.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';

abstract interface class ReportSignatureRepository {
  Stream<List<ReportSignature>> watchSignatures(String reportId);

  Future<List<ReportSignature>> getSignatures(String reportId);

  Future<ReportSignature?> getSignature(
    String reportId,
    ReportSignatureType type,
  );

  Future<ReportSignature> saveSignature({
    required String reportId,
    required ReportSignatureType type,
    required String signerName,
    required Uint8List pngBytes,
  });

  Future<void> deleteSignature({
    required String reportId,
    required ReportSignatureType type,
  });
}
