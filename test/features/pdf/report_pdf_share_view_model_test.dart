import 'dart:io';
import 'dart:ui' show Rect;

import 'package:fieldproof_360/core/services/native_share_service.dart';
import 'package:fieldproof_360/features/pdf/data/services/report_pdf_export_service.dart';
import 'package:fieldproof_360/features/pdf/presentation/view_models/report_pdf_share_view_model.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports PDF before invoking native share sheet', () async {
    final root = await Directory.systemTemp.createTemp('fieldproof_share_');
    addTearDown(() => root.delete(recursive: true));
    final share = _FakeShareService();
    final viewModel = ReportPdfShareViewModel(
      ReportPdfExportService(supportDirectory: () async => root),
      share,
    );
    const origin = Rect.fromLTWH(10, 20, 30, 40);

    final result = await viewModel.share(
      reportId: 'report-1',
      snapshot: _snapshot(),
      sharePositionOrigin: origin,
    );

    expect(result.outcome, NativeShareOutcome.success);
    expect(await result.file.exists(), isTrue);
    expect(share.path, result.file.path);
    expect(share.mimeType, 'application/pdf');
    expect(share.title, 'Share BEN-2026-0001');
    expect(share.subject, 'Service report BEN-2026-0001');
    expect(share.text, 'Ben Engineering Services — BEN-2026-0001');
    expect(share.origin, origin);
  });
}

final class _FakeShareService implements NativeShareService {
  String? path;
  String? mimeType;
  String? title;
  String? subject;
  String? text;
  Rect? origin;

  @override
  Future<NativeShareOutcome> shareFile({
    required String path,
    required String mimeType,
    required String title,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    this.path = path;
    this.mimeType = mimeType;
    this.title = title;
    this.subject = subject;
    this.text = text;
    origin = sharePositionOrigin;
    return NativeShareOutcome.success;
  }
}

ReportSnapshot _snapshot() {
  final finalizedAt = DateTime.utc(2026, 9, 24, 16);
  return ReportSnapshot(
    schemaVersion: ReportSnapshot.currentSchemaVersion,
    finalizedAt: finalizedAt,
    report: ReportSnapshotReport(
      number: 'BEN-2026-0001',
      type: ReportType.service,
      title: 'Generator service',
      workPerformed: 'Completed service.',
      createdAt: finalizedAt,
      updatedAt: finalizedAt,
      finalizedAt: finalizedAt,
      completedAt: finalizedAt,
    ),
    business: const ReportSnapshotBusiness(
      businessName: 'Ben Engineering Services',
      technicianName: 'Benjamin',
      countryCode: 'UG',
      currencyCode: 'UGX',
      localeCode: 'en_UG',
      reportPrefix: 'BEN',
    ),
    equipment: const ReportSnapshotEquipment(),
    materials: const [],
    photos: const [],
    signatures: const [],
    templateId: 'classic',
  );
}
