import 'dart:io';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/data/services/report_photo_file_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test(
    'imports an image into report-owned storage and creates thumbnail',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'fieldproof-photo-store-',
      );
      addTearDown(() => root.delete(recursive: true));
      final source = File('${root.path}/source.png');
      await source.writeAsBytes(
        img.encodePng(img.Image(width: 120, height: 60)),
      );
      final store = ReportPhotoFileStore(supportDirectory: () async => root);

      final result = await store.importPhoto(
        reportId: 'report-1',
        photoId: 'photo-1',
        sourcePath: source.path,
      );

      expect(
        result.filePath,
        contains('fieldproof/reports/report-1/photos/original'),
      );
      expect(result.thumbnailPath, isNotNull);
      expect(await File(result.filePath).exists(), isTrue);
      expect(await File(result.thumbnailPath!).exists(), isTrue);
      expect(result.filePath, endsWith('photo-1.jpg'));
    },
  );

  test('deletes owned original and thumbnail files', () async {
    final root = await Directory.systemTemp.createTemp(
      'fieldproof-photo-delete-',
    );
    addTearDown(() => root.delete(recursive: true));
    final source = File('${root.path}/source.png');
    await source.writeAsBytes(img.encodePng(img.Image(width: 40, height: 40)));
    final store = ReportPhotoFileStore(supportDirectory: () async => root);
    final result = await store.importPhoto(
      reportId: 'report-1',
      photoId: 'photo-1',
      sourcePath: source.path,
    );

    await store.deleteFiles(
      filePath: result.filePath,
      thumbnailPath: result.thumbnailPath,
    );

    expect(await File(result.filePath).exists(), isFalse);
    expect(await File(result.thumbnailPath!).exists(), isFalse);
  });

  test('rejects a missing selected image', () async {
    final root = await Directory.systemTemp.createTemp(
      'fieldproof-photo-missing-',
    );
    addTearDown(() => root.delete(recursive: true));
    final store = ReportPhotoFileStore(supportDirectory: () async => root);

    await expectLater(
      store.importPhoto(
        reportId: 'report-1',
        photoId: 'photo-1',
        sourcePath: '${root.path}/missing.jpg',
      ),
      throwsA(isA<FileStorageException>()),
    );
  });
}
