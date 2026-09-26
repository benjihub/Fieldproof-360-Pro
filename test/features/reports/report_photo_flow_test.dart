import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/app/router/app_router.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/data/services/report_image_picker.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_photo_repository.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_photo_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';
import '../../helpers/widget_test_harness.dart';

void main() {
  testAppWidgets('draft editor opens photo manager and imports gallery image', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final report = await DriftReportRepository(
      database,
    ).createDraft(title: 'Pump service');
    final root = (await tester.runAsync(
      () => Directory.systemTemp.createTemp('fieldproof-photo-widget-'),
    ))!;
    addTearDown(() => tester.runAsync(() => root.delete(recursive: true)));
    final source = (await tester.runAsync(
      () => _createPng(root, 'picked.png'),
    ))!;
    final photoRepository = _FakeReportPhotoRepository();
    addTearDown(photoRepository.dispose);
    final router = createAppRouter(
      gate: AppGate.home,
      initialLocation: '/reports/${report.id}/edit',
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          appRouterProvider.overrideWithValue(router),
          reportPhotoRepositoryProvider.overrideWithValue(photoRepository),
          reportImagePickerProvider.overrideWithValue(
            _FakeImagePicker([source.path]),
          ),
        ],
        child: const FieldProofApp(),
      ),
    );
    await pumpUntilFound(tester, find.byKey(const Key('reportEditorList')));

    final managePhotos = find.byKey(const Key('manageReportPhotosAction'));
    await scrollUntilBuilt(
      tester,
      target: managePhotos,
      scrollView: find.byKey(const Key('reportEditorList')),
    );
    await tester.tap(managePhotos);
    await pumpUntilFound(tester, find.text('Report Photos'));
    expect(find.text('Report Photos'), findsOneWidget);
    expect(find.text('No before photos yet'), findsOneWidget);

    await tester.tap(find.byKey(const Key('chooseReportPhotosAction')));
    await pumpUntilFound(tester, find.text('No caption'));

    expect(find.text('No caption'), findsOneWidget);
    expect(photoRepository.photos, hasLength(1));
    expect(photoRepository.photos.single.category, ReportPhotoCategory.before);
    expect(photoRepository.photos.single.filePath, source.path);
  });
}

final class _FakeImagePicker implements ReportImagePicker {
  _FakeImagePicker(this.galleryPaths);

  final List<String> galleryPaths;

  @override
  Future<List<String>> pickFromCamera() async => const [];

  @override
  Future<List<String>> pickFromGallery() async => galleryPaths;

  @override
  Future<List<String>> recoverLostImages() async => const [];
}

final class _FakeReportPhotoRepository implements ReportPhotoRepository {
  final _changes = StreamController<void>.broadcast();
  final photos = <ReportPhoto>[];

  @override
  Stream<List<ReportPhoto>> watchPhotos(String reportId) async* {
    yield _photosFor(reportId);
    await for (final _ in _changes.stream) {
      yield _photosFor(reportId);
    }
  }

  @override
  Future<List<ReportPhoto>> getPhotos(String reportId) async =>
      _photosFor(reportId);

  @override
  Future<ReportPhoto> importPhoto({
    required String reportId,
    required String sourcePath,
    required ReportPhotoCategory category,
    String? caption,
  }) async {
    final photo = ReportPhoto(
      id: 'photo-${photos.length + 1}',
      reportId: reportId,
      filePath: sourcePath,
      category: category,
      caption: caption,
      sortOrder: photos.length,
      createdAt: DateTime.utc(2026, 9, 25),
    );
    photos.add(photo);
    _changes.add(null);
    return photo;
  }

  @override
  Future<ReportPhoto> updatePhoto({
    required String photoId,
    required ReportPhotoCategory category,
    String? caption,
  }) => throw UnimplementedError();

  @override
  Future<void> reorderPhotos({
    required String reportId,
    required ReportPhotoCategory category,
    required List<String> orderedPhotoIds,
  }) => throw UnimplementedError();

  @override
  Future<void> deletePhoto(String photoId) => throw UnimplementedError();

  Future<void> dispose() => _changes.close();

  List<ReportPhoto> _photosFor(String reportId) =>
      photos.where((photo) => photo.reportId == reportId).toList();
}

Future<File> _createPng(Directory root, String name) async {
  const encoded =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';
  final file = File('${root.path}/$name');
  await file.writeAsBytes(base64Decode(encoded), flush: true);
  return file;
}
