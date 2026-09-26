import 'package:drift/drift.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/tables/report_photos.dart';
import 'package:fieldproof_360/features/reports/data/mappers/report_photo_mapper.dart';
import 'package:fieldproof_360/features/reports/data/services/report_photo_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_photo_repository.dart';
import 'package:uuid/uuid.dart';

final class DriftReportPhotoRepository implements ReportPhotoRepository {
  DriftReportPhotoRepository(
    this._database,
    this._fileStore, {
    DateTime Function()? now,
    this._uuid = const Uuid(),
  }) : _clock = now ?? DateTime.now;

  final AppDatabase _database;
  final ReportPhotoFileStore _fileStore;
  final DateTime Function() _clock;
  final Uuid _uuid;

  @override
  Stream<List<ReportPhoto>> watchPhotos(String reportId) =>
      _photosForReportQuery(reportId).watch().map(_toSortedDomain);

  @override
  Future<List<ReportPhoto>> getPhotos(String reportId) async {
    try {
      return _toSortedDomain(await _photosForReportQuery(reportId).get());
    } catch (error) {
      throw DatabaseException('Could not load report photos.', cause: error);
    }
  }

  @override
  Future<ReportPhoto> importPhoto({
    required String reportId,
    required String sourcePath,
    required ReportPhotoCategory category,
    String? caption,
  }) async {
    await _ensureDraftReport(reportId);
    final id = _uuid.v4();
    final files = await _fileStore.importPhoto(
      reportId: reportId,
      photoId: id,
      sourcePath: sourcePath,
    );

    try {
      return await _database.transaction(() async {
        await _ensureDraftReport(reportId);
        final photo = ReportPhoto(
          id: id,
          reportId: reportId,
          filePath: files.filePath,
          thumbnailPath: files.thumbnailPath,
          category: category,
          caption: _normalizeOptional(caption),
          sortOrder: await _nextSortOrder(reportId, category),
          createdAt: _nowUtc(),
        );
        await _database
            .into(_database.reportPhotos)
            .insert(
              ReportPhotosCompanion.insert(
                id: photo.id,
                reportId: photo.reportId,
                filePath: photo.filePath,
                thumbnailPath: Value(photo.thumbnailPath),
                category: photo.category.databaseValue,
                caption: Value(photo.caption),
                sortOrder: photo.sortOrder,
                createdAt: photo.createdAt,
              ),
            );
        await _touchReport(reportId);
        return photo;
      });
    } on AppException {
      await _fileStore.deleteFiles(
        filePath: files.filePath,
        thumbnailPath: files.thumbnailPath,
      );
      rethrow;
    } catch (error) {
      await _fileStore.deleteFiles(
        filePath: files.filePath,
        thumbnailPath: files.thumbnailPath,
      );
      throw DatabaseException('Could not add the report photo.', cause: error);
    }
  }

  @override
  Future<ReportPhoto> updatePhoto({
    required String photoId,
    required ReportPhotoCategory category,
    String? caption,
  }) async {
    try {
      return await _database.transaction(() async {
        final existing = await _findPhoto(photoId);
        if (existing == null) {
          throw const DatabaseException('Photo not found.');
        }
        await _ensureDraftReport(existing.reportId);

        final categoryChanged = category != existing.category;
        final sortOrder = categoryChanged
            ? await _nextSortOrder(existing.reportId, category)
            : existing.sortOrder;
        final updated = ReportPhoto(
          id: existing.id,
          reportId: existing.reportId,
          filePath: existing.filePath,
          thumbnailPath: existing.thumbnailPath,
          category: category,
          caption: _normalizeOptional(caption),
          sortOrder: sortOrder,
          createdAt: existing.createdAt,
        );
        final changed =
            await (_database.update(
              _database.reportPhotos,
            )..where((photo) => photo.id.equals(photoId))).write(
              ReportPhotosCompanion(
                category: Value(category.databaseValue),
                caption: Value(updated.caption),
                sortOrder: Value(sortOrder),
              ),
            );
        if (changed == 0) {
          throw const DatabaseException('Photo not found.');
        }
        if (categoryChanged) {
          await _normalizeSortOrders(existing.reportId, existing.category);
        }
        await _touchReport(existing.reportId);
        return updated;
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException(
        'Could not update the report photo.',
        cause: error,
      );
    }
  }

  @override
  Future<void> reorderPhotos({
    required String reportId,
    required ReportPhotoCategory category,
    required List<String> orderedPhotoIds,
  }) async {
    try {
      await _database.transaction(() async {
        await _ensureDraftReport(reportId);
        final existing = await _photosForCategory(reportId, category);
        final existingIds = existing.map((photo) => photo.id).toSet();
        if (existingIds.length != orderedPhotoIds.length ||
            orderedPhotoIds.toSet().length != orderedPhotoIds.length ||
            !existingIds.containsAll(orderedPhotoIds)) {
          throw const ValidationException(
            'Photo order no longer matches this report section.',
          );
        }
        for (var index = 0; index < orderedPhotoIds.length; index++) {
          await (_database.update(_database.reportPhotos)
                ..where((photo) => photo.id.equals(orderedPhotoIds[index])))
              .write(ReportPhotosCompanion(sortOrder: Value(index)));
        }
        await _touchReport(reportId);
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not reorder report photos.', cause: error);
    }
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    late ReportPhoto removed;
    try {
      removed = await _database.transaction(() async {
        final existing = await _findPhoto(photoId);
        if (existing == null) {
          throw const DatabaseException('Photo not found.');
        }
        await _ensureDraftReport(existing.reportId);
        final changed = await (_database.delete(
          _database.reportPhotos,
        )..where((photo) => photo.id.equals(photoId))).go();
        if (changed == 0) {
          throw const DatabaseException('Photo not found.');
        }
        await _normalizeSortOrders(existing.reportId, existing.category);
        await _touchReport(existing.reportId);
        return existing;
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException(
        'Could not remove the report photo.',
        cause: error,
      );
    }

    await _fileStore.deleteFiles(
      filePath: removed.filePath,
      thumbnailPath: removed.thumbnailPath,
    );
  }

  SimpleSelectStatement<ReportPhotos, ReportPhotoEntity> _photosForReportQuery(
    String reportId,
  ) => _database.select(_database.reportPhotos)
    ..where((photo) => photo.reportId.equals(reportId))
    ..orderBy([
      (photo) => OrderingTerm.asc(photo.category),
      (photo) => OrderingTerm.asc(photo.sortOrder),
      (photo) => OrderingTerm.asc(photo.createdAt),
    ]);

  List<ReportPhoto> _toSortedDomain(List<ReportPhotoEntity> rows) {
    final photos = rows.map((row) => row.toDomain()).toList();
    photos.sort((left, right) {
      final category = left.category.index.compareTo(right.category.index);
      if (category != 0) return category;
      final order = left.sortOrder.compareTo(right.sortOrder);
      if (order != 0) return order;
      return left.createdAt.compareTo(right.createdAt);
    });
    return photos;
  }

  Future<ReportPhoto?> _findPhoto(String id) async {
    final query = _database.select(_database.reportPhotos)
      ..where((photo) => photo.id.equals(id));
    return (await query.getSingleOrNull())?.toDomain();
  }

  Future<List<ReportPhoto>> _photosForCategory(
    String reportId,
    ReportPhotoCategory category,
  ) async {
    final query = _database.select(_database.reportPhotos)
      ..where(
        (photo) =>
            photo.reportId.equals(reportId) &
            photo.category.equals(category.databaseValue),
      )
      ..orderBy([
        (photo) => OrderingTerm.asc(photo.sortOrder),
        (photo) => OrderingTerm.asc(photo.createdAt),
      ]);
    return (await query.get()).map((row) => row.toDomain()).toList();
  }

  Future<int> _nextSortOrder(
    String reportId,
    ReportPhotoCategory category,
  ) async {
    final photos = await _photosForCategory(reportId, category);
    if (photos.isEmpty) return 0;
    return photos
            .map((photo) => photo.sortOrder)
            .reduce((left, right) => left > right ? left : right) +
        1;
  }

  Future<void> _normalizeSortOrders(
    String reportId,
    ReportPhotoCategory category,
  ) async {
    final photos = await _photosForCategory(reportId, category);
    for (var index = 0; index < photos.length; index++) {
      if (photos[index].sortOrder == index) continue;
      await (_database.update(_database.reportPhotos)
            ..where((photo) => photo.id.equals(photos[index].id)))
          .write(ReportPhotosCompanion(sortOrder: Value(index)));
    }
  }

  Future<void> _ensureDraftReport(String reportId) async {
    final query = _database.select(_database.reports)
      ..where((report) => report.id.equals(reportId));
    final report = await query.getSingleOrNull();
    if (report == null) {
      throw const DatabaseException('Report not found.');
    }
    if (report.status != ReportStatus.draft.databaseValue ||
        report.archivedAt != null) {
      throw const ValidationException(
        'Photos can only be changed on draft reports.',
      );
    }
  }

  Future<void> _touchReport(String reportId) async {
    await (_database.update(_database.reports)
          ..where((report) => report.id.equals(reportId)))
        .write(ReportsCompanion(updatedAt: Value(_nowUtc())));
  }

  String? _normalizeOptional(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  DateTime _nowUtc() {
    final now = _clock().toUtc();
    return DateTime.fromMillisecondsSinceEpoch(
      (now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond) *
          Duration.millisecondsPerSecond,
      isUtc: true,
    );
  }
}
