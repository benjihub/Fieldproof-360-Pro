import 'dart:convert';
import 'dart:io';

import 'package:fieldproof_360/features/pdf/data/services/report_pdf_export_service.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports generated PDF into report-owned exports directory', () async {
    final root = await Directory.systemTemp.createTemp('fieldproof_export_');
    addTearDown(() => root.delete(recursive: true));
    final service = ReportPdfExportService(supportDirectory: () async => root);

    final file = await service.export(
      reportId: 'report-123',
      snapshot: _snapshot(),
    );

    expect(await file.exists(), isTrue);
    expect(file.path, contains('fieldproof/reports/report-123/exports'));
    expect(
      file.path,
      endsWith('FieldProof_360_Pro_BEN-2026-0001_Generator-service.pdf'),
    );
    final bytes = await file.readAsBytes();
    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
  });

  test(
    're-export replaces the same file and removes stale PDF exports',
    () async {
      final root = await Directory.systemTemp.createTemp('fieldproof_export_');
      addTearDown(() => root.delete(recursive: true));
      final service = ReportPdfExportService(
        supportDirectory: () async => root,
      );

      final first = await service.export(
        reportId: 'report-123',
        snapshot: _snapshot(),
      );
      final stale = File('${first.parent.path}/old-report.pdf');
      await stale.writeAsString('stale');

      final second = await service.export(
        reportId: 'report-123',
        snapshot: _snapshot(),
      );

      expect(second.path, first.path);
      expect(await second.exists(), isTrue);
      expect(await stale.exists(), isFalse);
    },
  );
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
      workPerformed: 'Replaced the fuel filter and tested the generator.',
      createdAt: finalizedAt.subtract(const Duration(days: 1)),
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
    equipment: const ReportSnapshotEquipment(name: 'Generator'),
    materials: const [],
    photos: const [],
    signatures: const [],
    templateId: 'classic',
  );
}
