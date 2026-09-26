import 'package:drift/drift.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/tables/report_materials.dart';
import 'package:fieldproof_360/features/reports/data/mappers/report_material_mapper.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_material.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_material_repository.dart';
import 'package:uuid/uuid.dart';

final class DriftReportMaterialRepository implements ReportMaterialRepository {
  DriftReportMaterialRepository(
    this._database, {
    DateTime Function()? now,
    this._uuid = const Uuid(),
  }) : _clock = now ?? DateTime.now;

  final AppDatabase _database;
  final DateTime Function() _clock;
  final Uuid _uuid;

  @override
  Stream<List<ReportMaterial>> watchMaterials(String reportId) =>
      _query(reportId).watch().map(
        (rows) => rows.map((row) => row.toDomain()).toList(growable: false),
      );

  @override
  Future<List<ReportMaterial>> getMaterials(String reportId) async {
    try {
      return (await _query(
        reportId,
      ).get()).map((row) => row.toDomain()).toList(growable: false);
    } catch (error) {
      throw DatabaseException('Could not load report materials.', cause: error);
    }
  }

  @override
  Future<ReportMaterial> addMaterial({
    required String reportId,
    required String name,
    required double quantity,
    String? unit,
    String? notes,
  }) async {
    final normalizedName = _requiredName(name);
    _validateQuantity(quantity);
    try {
      return await _database.transaction(() async {
        await _ensureDraftReport(reportId);
        final material = ReportMaterial(
          id: _uuid.v4(),
          reportId: reportId,
          name: normalizedName,
          quantity: quantity,
          unit: _optional(unit),
          notes: _optional(notes),
          sortOrder: await _nextSortOrder(reportId),
        );
        await _database
            .into(_database.reportMaterials)
            .insert(
              ReportMaterialsCompanion.insert(
                id: material.id,
                reportId: material.reportId,
                name: material.name,
                quantity: material.quantity,
                unit: Value(material.unit),
                notes: Value(material.notes),
                sortOrder: material.sortOrder,
              ),
            );
        await _touchReport(reportId);
        return material;
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not add the material.', cause: error);
    }
  }

  @override
  Future<ReportMaterial> updateMaterial({
    required String materialId,
    required String name,
    required double quantity,
    String? unit,
    String? notes,
  }) async {
    final normalizedName = _requiredName(name);
    _validateQuantity(quantity);
    try {
      return await _database.transaction(() async {
        final existing = await _find(materialId);
        if (existing == null) {
          throw const DatabaseException('Material not found.');
        }
        await _ensureDraftReport(existing.reportId);
        final updated = ReportMaterial(
          id: existing.id,
          reportId: existing.reportId,
          name: normalizedName,
          quantity: quantity,
          unit: _optional(unit),
          notes: _optional(notes),
          sortOrder: existing.sortOrder,
        );
        final changed =
            await (_database.update(
              _database.reportMaterials,
            )..where((material) => material.id.equals(materialId))).write(
              ReportMaterialsCompanion(
                name: Value(updated.name),
                quantity: Value(updated.quantity),
                unit: Value(updated.unit),
                notes: Value(updated.notes),
              ),
            );
        if (changed == 0) {
          throw const DatabaseException('Material not found.');
        }
        await _touchReport(existing.reportId);
        return updated;
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not update the material.', cause: error);
    }
  }

  @override
  Future<void> reorderMaterials({
    required String reportId,
    required List<String> orderedMaterialIds,
  }) async {
    try {
      await _database.transaction(() async {
        await _ensureDraftReport(reportId);
        final existing = await getMaterials(reportId);
        final existingIds = existing.map((item) => item.id).toSet();
        if (existingIds.length != orderedMaterialIds.length ||
            orderedMaterialIds.toSet().length != orderedMaterialIds.length ||
            !existingIds.containsAll(orderedMaterialIds)) {
          throw const ValidationException(
            'Material order no longer matches this report.',
          );
        }
        for (var index = 0; index < orderedMaterialIds.length; index++) {
          await (_database.update(_database.reportMaterials)
                ..where((item) => item.id.equals(orderedMaterialIds[index])))
              .write(ReportMaterialsCompanion(sortOrder: Value(index)));
        }
        await _touchReport(reportId);
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not reorder materials.', cause: error);
    }
  }

  @override
  Future<void> deleteMaterial(String materialId) async {
    try {
      await _database.transaction(() async {
        final existing = await _find(materialId);
        if (existing == null) {
          throw const DatabaseException('Material not found.');
        }
        await _ensureDraftReport(existing.reportId);
        final changed = await (_database.delete(
          _database.reportMaterials,
        )..where((item) => item.id.equals(materialId))).go();
        if (changed == 0) {
          throw const DatabaseException('Material not found.');
        }
        await _normalizeSortOrders(existing.reportId);
        await _touchReport(existing.reportId);
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not remove the material.', cause: error);
    }
  }

  SimpleSelectStatement<ReportMaterials, ReportMaterialEntity> _query(
    String reportId,
  ) => _database.select(_database.reportMaterials)
    ..where((item) => item.reportId.equals(reportId))
    ..orderBy([(item) => OrderingTerm.asc(item.sortOrder)]);

  Future<ReportMaterial?> _find(String materialId) async {
    final query = _database.select(_database.reportMaterials)
      ..where((item) => item.id.equals(materialId));
    return (await query.getSingleOrNull())?.toDomain();
  }

  Future<int> _nextSortOrder(String reportId) async {
    final items = await getMaterials(reportId);
    if (items.isEmpty) return 0;
    return items.map((item) => item.sortOrder).reduce((a, b) => a > b ? a : b) +
        1;
  }

  Future<void> _normalizeSortOrders(String reportId) async {
    final items = await getMaterials(reportId);
    for (var index = 0; index < items.length; index++) {
      if (items[index].sortOrder == index) continue;
      await (_database.update(_database.reportMaterials)
            ..where((item) => item.id.equals(items[index].id)))
          .write(ReportMaterialsCompanion(sortOrder: Value(index)));
    }
  }

  Future<void> _ensureDraftReport(String reportId) async {
    final query = _database.select(_database.reports)
      ..where((report) => report.id.equals(reportId));
    final report = await query.getSingleOrNull();
    if (report == null) throw const DatabaseException('Report not found.');
    if (report.status != ReportStatus.draft.databaseValue ||
        report.archivedAt != null) {
      throw const ValidationException(
        'Materials can only be changed on draft reports.',
      );
    }
  }

  Future<void> _touchReport(String reportId) async {
    await (_database.update(_database.reports)
          ..where((report) => report.id.equals(reportId)))
        .write(ReportsCompanion(updatedAt: Value(_nowUtc())));
  }

  String _requiredName(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const ValidationException('Material name is required.');
    }
    return normalized;
  }

  void _validateQuantity(double value) {
    if (!value.isFinite || value <= 0) {
      throw const ValidationException('Quantity must be greater than zero.');
    }
  }

  String? _optional(String? value) {
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
