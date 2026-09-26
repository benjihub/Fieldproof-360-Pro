import 'package:drift/drift.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/tables/report_signatures.dart';
import 'package:fieldproof_360/features/reports/data/mappers/report_signature_mapper.dart';
import 'package:fieldproof_360/features/reports/data/services/report_signature_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_signature_repository.dart';
import 'package:uuid/uuid.dart';

final class DriftReportSignatureRepository
    implements ReportSignatureRepository {
  DriftReportSignatureRepository(
    this._database,
    this._fileStore, {
    DateTime Function()? now,
    this._uuid = const Uuid(),
  }) : _clock = now ?? DateTime.now;

  final AppDatabase _database;
  final ReportSignatureFileStore _fileStore;
  final DateTime Function() _clock;
  final Uuid _uuid;

  @override
  Stream<List<ReportSignature>> watchSignatures(String reportId) =>
      _query(reportId).watch().map(
        (rows) => rows.map((row) => row.toDomain()).toList(growable: false),
      );

  @override
  Future<List<ReportSignature>> getSignatures(String reportId) async {
    try {
      return (await _query(
        reportId,
      ).get()).map((row) => row.toDomain()).toList(growable: false);
    } catch (error) {
      throw DatabaseException(
        'Could not load report signatures.',
        cause: error,
      );
    }
  }

  @override
  Future<ReportSignature?> getSignature(
    String reportId,
    ReportSignatureType type,
  ) async {
    try {
      final query = _database.select(_database.reportSignatures)
        ..where(
          (item) =>
              item.reportId.equals(reportId) &
              item.signatureType.equals(type.databaseValue),
        );
      return (await query.getSingleOrNull())?.toDomain();
    } catch (error) {
      throw DatabaseException('Could not load the signature.', cause: error);
    }
  }

  @override
  Future<ReportSignature> saveSignature({
    required String reportId,
    required ReportSignatureType type,
    required String signerName,
    required Uint8List pngBytes,
  }) async {
    final normalizedName = signerName.trim();
    if (normalizedName.isEmpty) {
      throw const ValidationException('Signer name is required.');
    }
    await _ensureDraftReport(reportId);
    final previous = await getSignature(reportId, type);
    final filePath = await _fileStore.writeSignature(
      reportId: reportId,
      type: type,
      fileKey: _uuid.v4(),
      pngBytes: pngBytes,
    );
    final signedAt = _nowUtc();
    final signature = ReportSignature(
      id: previous?.id ?? _uuid.v4(),
      reportId: reportId,
      signatureType: type,
      signerName: normalizedName,
      filePath: filePath,
      signedAt: signedAt,
    );

    try {
      await _database.transaction(() async {
        await _ensureDraftReport(reportId);
        if (previous == null) {
          await _database
              .into(_database.reportSignatures)
              .insert(
                ReportSignaturesCompanion.insert(
                  id: signature.id,
                  reportId: reportId,
                  signatureType: type.databaseValue,
                  signerName: normalizedName,
                  filePath: filePath,
                  signedAt: signedAt,
                ),
              );
        } else {
          final changed =
              await (_database.update(
                _database.reportSignatures,
              )..where((item) => item.id.equals(previous.id))).write(
                ReportSignaturesCompanion(
                  signerName: Value(normalizedName),
                  filePath: Value(filePath),
                  signedAt: Value(signedAt),
                ),
              );
          if (changed == 0) {
            throw const DatabaseException('Signature not found.');
          }
        }
        await _touchReport(reportId);
      });
      if (previous != null && previous.filePath != filePath) {
        await _fileStore.deleteSignature(previous.filePath);
      }
      return signature;
    } on AppException {
      await _fileStore.deleteSignature(filePath);
      rethrow;
    } catch (error) {
      await _fileStore.deleteSignature(filePath);
      throw DatabaseException('Could not save the signature.', cause: error);
    }
  }

  @override
  Future<void> deleteSignature({
    required String reportId,
    required ReportSignatureType type,
  }) async {
    ReportSignature? removed;
    try {
      await _database.transaction(() async {
        await _ensureDraftReport(reportId);
        removed = await getSignature(reportId, type);
        if (removed == null) return;
        await (_database.delete(
          _database.reportSignatures,
        )..where((item) => item.id.equals(removed!.id))).go();
        await _touchReport(reportId);
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not remove the signature.', cause: error);
    }
    if (removed != null) {
      await _fileStore.deleteSignature(removed!.filePath);
    }
  }

  SimpleSelectStatement<ReportSignatures, ReportSignatureEntity> _query(
    String reportId,
  ) => _database.select(_database.reportSignatures)
    ..where((item) => item.reportId.equals(reportId))
    ..orderBy([(item) => OrderingTerm.asc(item.signatureType)]);

  Future<void> _ensureDraftReport(String reportId) async {
    final query = _database.select(_database.reports)
      ..where((report) => report.id.equals(reportId));
    final report = await query.getSingleOrNull();
    if (report == null) throw const DatabaseException('Report not found.');
    if (report.status != ReportStatus.draft.databaseValue ||
        report.archivedAt != null) {
      throw const ValidationException(
        'Signatures can only be changed on draft reports.',
      );
    }
  }

  Future<void> _touchReport(String reportId) async {
    await (_database.update(_database.reports)
          ..where((report) => report.id.equals(reportId)))
        .write(ReportsCompanion(updatedAt: Value(_nowUtc())));
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
