import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('draft factory provides report foundation defaults', () {
    final createdAt = DateTime.utc(2026, 9, 24, 8);
    final report = Report.draft(id: 'report-1', createdAt: createdAt);

    expect(report.reportNumber, isNull);
    expect(report.customerId, isNull);
    expect(report.reportType, ReportType.service);
    expect(report.status, ReportStatus.draft);
    expect(report.title, isEmpty);
    expect(report.workPerformed, isEmpty);
    expect(report.pdfTemplateId, 'classic');
    expect(report.finalizedAt, isNull);
    expect(report.finalizedSnapshotJson, isNull);
    expect(report.archivedAt, isNull);
    expect(report.isDraft, isTrue);
    expect(report.isFinalized, isFalse);
    expect(report.isArchived, isFalse);
  });

  test('draft factory trims text and normalizes blank optionals', () {
    final report = Report.draft(
      id: 'report-1',
      customerId: '   ',
      title: '  Boiler service  ',
      siteAddress: '  Kampala Road  ',
      equipmentName: '   ',
      workPerformed: '  Replaced valve  ',
      diagnosis: '   ',
      pdfTemplateId: '   ',
      createdAt: DateTime.utc(2026, 9, 24),
    );

    expect(report.customerId, isNull);
    expect(report.title, 'Boiler service');
    expect(report.siteAddress, 'Kampala Road');
    expect(report.equipmentName, isNull);
    expect(report.workPerformed, 'Replaced valve');
    expect(report.diagnosis, isNull);
    expect(report.pdfTemplateId, 'classic');
  });

  test('derived state follows persisted report status', () {
    final timestamp = DateTime.utc(2026, 9, 24);
    final finalized = Report(
      id: 'finalized',
      reportType: ReportType.inspection,
      status: ReportStatus.finalized,
      title: 'Inspection',
      workPerformed: 'Inspected equipment',
      pdfTemplateId: 'classic',
      createdAt: timestamp,
      updatedAt: timestamp,
      finalizedAt: timestamp,
    );
    final archived = Report(
      id: 'archived',
      reportType: ReportType.general,
      status: ReportStatus.archived,
      title: '',
      workPerformed: '',
      pdfTemplateId: 'classic',
      createdAt: timestamp,
      updatedAt: timestamp,
      archivedAt: timestamp,
    );

    expect(finalized.isFinalized, isTrue);
    expect(finalized.isDraft, isFalse);
    expect(archived.isArchived, isTrue);
  });
}
