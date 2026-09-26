import 'dart:io';
import 'dart:ui' show Rect;

import 'package:fieldproof_360/core/services/native_share_service.dart';
import 'package:fieldproof_360/features/pdf/data/services/report_pdf_export_service.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';

final class ReportPdfShareResult {
  const ReportPdfShareResult({required this.file, required this.outcome});

  final File file;
  final NativeShareOutcome outcome;
}

final class ReportPdfShareViewModel {
  const ReportPdfShareViewModel(this._exportService, this._shareService);

  final ReportPdfExportService _exportService;
  final NativeShareService _shareService;

  Future<ReportPdfShareResult> share({
    required String reportId,
    required ReportSnapshot snapshot,
    Rect? sharePositionOrigin,
    bool showFieldProofBranding = true,
  }) async {
    final file = await _exportService.export(
      reportId: reportId,
      snapshot: snapshot,
      showFieldProofBranding: showFieldProofBranding,
    );
    final outcome = await _shareService.shareFile(
      path: file.path,
      mimeType: 'application/pdf',
      title: 'Share ${snapshot.report.number}',
      subject: 'Service report ${snapshot.report.number}',
      text: '${snapshot.business.businessName} — ${snapshot.report.number}',
      sharePositionOrigin: sharePositionOrigin,
    );
    return ReportPdfShareResult(file: file, outcome: outcome);
  }
}
