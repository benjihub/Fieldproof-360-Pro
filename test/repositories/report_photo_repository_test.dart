import 'dart:io';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_photo_repository.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/data/services/report_photo_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import '../helpers/test_data.dart';

void main() {
  test(
    'imports, orders, updates, reorders, and deletes draft photos',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final root = await Directory.systemTemp.createTemp(
        'fieldproof-photo-repo-',
      );
      addTearDown(() => root.delete(recursive: true));
      final source = File('${root.path}/source.png');
      await source.writeAsBytes(
        img.encodePng(img.Image(width: 80, height: 60)),
      );

      var now = DateTime.utc(2026, 9, 24, 10);
      final reportRepository = DriftReportRepository(database, now: () => now);
      final report = await reportRepository.createDraft(title: 'Pump service');
      final photoRepository = DriftReportPhotoRepository(
        database,
        ReportPhotoFileStore(supportDirectory: () async => root),
        now: () => now,
      );

      now = DateTime.utc(2026, 9, 24, 11);
      final after = await photoRepository.importPhoto(
        reportId: report.id,
        sourcePath: source.path,
        category: ReportPhotoCategory.after,
        caption: '  Completed installation  ',
      );
      final beforeOne = await photoRepository.importPhoto(
        reportId: report.id,
        sourcePath: source.path,
        category: ReportPhotoCategory.before,
        caption: 'Original condition',
      );
      final beforeTwo = await photoRepository.importPhoto(
        reportId: report.id,
        sourcePath: source.path,
        category: ReportPhotoCategory.before,
      );

      final initial = await photoRepository.getPhotos(report.id);
      expect(initial.map((photo) => photo.id), [
        beforeOne.id,
        beforeTwo.id,
        after.id,
      ]);
      expect(after.caption, 'Completed installation');
      expect(await File(after.filePath).exists(), isTrue);
      expect((await reportRepository.getReport(report.id))?.updatedAt, now);

      await photoRepository.reorderPhotos(
        reportId: report.id,
        category: ReportPhotoCategory.before,
        orderedPhotoIds: [beforeTwo.id, beforeOne.id],
      );
      final reordered = await photoRepository.getPhotos(report.id);
      expect(
        reordered
            .where((photo) => photo.category == ReportPhotoCategory.before)
            .map((photo) => photo.id),
        [beforeTwo.id, beforeOne.id],
      );

      final updated = await photoRepository.updatePhoto(
        photoId: beforeOne.id,
        category: ReportPhotoCategory.issue,
        caption: '  Burn mark  ',
      );
      expect(updated.category, ReportPhotoCategory.issue);
      expect(updated.caption, 'Burn mark');

      final removedFile = beforeTwo.filePath;
      await photoRepository.deletePhoto(beforeTwo.id);
      expect(
        (await photoRepository.getPhotos(report.id)).map((photo) => photo.id),
        isNot(contains(beforeTwo.id)),
      );
      expect(await File(removedFile).exists(), isFalse);
    },
  );

  test('photo mutations are blocked after report archive', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final root = await Directory.systemTemp.createTemp(
      'fieldproof-photo-locked-',
    );
    addTearDown(() => root.delete(recursive: true));
    final source = File('${root.path}/source.png');
    await source.writeAsBytes(img.encodePng(img.Image(width: 20, height: 20)));
    final reportRepository = DriftReportRepository(database);
    final report = await reportRepository.createDraft();
    await reportRepository.archiveReport(report.id);
    final photoRepository = DriftReportPhotoRepository(
      database,
      ReportPhotoFileStore(supportDirectory: () async => root),
    );

    await expectLater(
      photoRepository.importPhoto(
        reportId: report.id,
        sourcePath: source.path,
        category: ReportPhotoCategory.before,
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('watchPhotos reacts to imported photos', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final root = await Directory.systemTemp.createTemp(
      'fieldproof-photo-watch-',
    );
    addTearDown(() => root.delete(recursive: true));
    final source = File('${root.path}/source.png');
    await source.writeAsBytes(img.encodePng(img.Image(width: 20, height: 20)));
    final report = await DriftReportRepository(database).createDraft();
    final repository = DriftReportPhotoRepository(
      database,
      ReportPhotoFileStore(supportDirectory: () async => root),
    );

    final emission = repository
        .watchPhotos(report.id)
        .firstWhere((items) => items.length == 1);
    await repository.importPhoto(
      reportId: report.id,
      sourcePath: source.path,
      category: ReportPhotoCategory.general,
    );

    expect((await emission).single.category, ReportPhotoCategory.general);
  });
}
