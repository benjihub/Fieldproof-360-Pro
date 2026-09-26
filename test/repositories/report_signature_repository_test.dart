import 'dart:io';
import 'dart:typed_data';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_signature_repository.dart';
import 'package:fieldproof_360/features/reports/data/services/report_signature_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  test(
    'saves, replaces and removes a signature with app-owned files',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final root = await Directory.systemTemp.createTemp(
        'fieldproof-signature-repo-',
      );
      addTearDown(() => root.delete(recursive: true));
      var now = DateTime.utc(2026, 9, 24, 12);
      final reports = DriftReportRepository(database, now: () => now);
      final report = await reports.createDraft();
      final repository = DriftReportSignatureRepository(
        database,
        ReportSignatureFileStore(supportDirectory: () async => root),
        now: () => now,
      );

      final first = await repository.saveSignature(
        reportId: report.id,
        type: ReportSignatureType.technician,
        signerName: ' Benjamin ',
        pngBytes: Uint8List.fromList([1, 2, 3]),
      );
      expect(first.signerName, 'Benjamin');
      expect(await File(first.filePath).exists(), isTrue);

      now = DateTime.utc(2026, 9, 24, 13);
      final replacement = await repository.saveSignature(
        reportId: report.id,
        type: ReportSignatureType.technician,
        signerName: 'Ben W',
        pngBytes: Uint8List.fromList([4, 5, 6]),
      );
      expect(replacement.id, first.id);
      expect(replacement.filePath, isNot(first.filePath));
      expect(await File(first.filePath).exists(), isFalse);
      expect(await File(replacement.filePath).exists(), isTrue);
      expect((await reports.getReport(report.id))?.updatedAt, now);

      await repository.deleteSignature(
        reportId: report.id,
        type: ReportSignatureType.technician,
      );
      expect(
        await repository.getSignature(
          report.id,
          ReportSignatureType.technician,
        ),
        isNull,
      );
      expect(await File(replacement.filePath).exists(), isFalse);
    },
  );

  test('supports one signature per type and persists both types', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final root = await Directory.systemTemp.createTemp(
      'fieldproof-signature-types-',
    );
    addTearDown(() => root.delete(recursive: true));
    final report = await DriftReportRepository(database).createDraft();
    final repository = DriftReportSignatureRepository(
      database,
      ReportSignatureFileStore(supportDirectory: () async => root),
    );

    for (final type in ReportSignatureType.values) {
      await repository.saveSignature(
        reportId: report.id,
        type: type,
        signerName: type.displayLabel,
        pngBytes: Uint8List.fromList([1]),
      );
    }

    final signatures = await repository.getSignatures(report.id);
    expect(signatures, hasLength(2));
    expect(
      signatures.map((item) => item.signatureType).toSet(),
      ReportSignatureType.values.toSet(),
    );
  });

  test('signature changes are blocked after archive', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final root = await Directory.systemTemp.createTemp(
      'fieldproof-signature-lock-',
    );
    addTearDown(() => root.delete(recursive: true));
    final reports = DriftReportRepository(database);
    final report = await reports.createDraft();
    await reports.archiveReport(report.id);
    final repository = DriftReportSignatureRepository(
      database,
      ReportSignatureFileStore(supportDirectory: () async => root),
    );

    await expectLater(
      repository.saveSignature(
        reportId: report.id,
        type: ReportSignatureType.customer,
        signerName: 'Customer',
        pngBytes: Uint8List.fromList([1]),
      ),
      throwsA(isA<ValidationException>()),
    );
  });
}
