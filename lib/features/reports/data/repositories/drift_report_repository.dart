import 'dart:io';

import 'package:drift/drift.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/business/data/mappers/business_profile_mapper.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/reports/data/services/report_snapshot_file_store.dart';
import 'package:fieldproof_360/features/reports/data/services/report_photo_file_store.dart';
import 'package:fieldproof_360/features/reports/data/services/report_signature_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_access_policy.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';
import 'package:fieldproof_360/features/reports/domain/services/report_finalization_validator.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/tables/reports.dart';
import 'package:fieldproof_360/features/reports/data/mappers/report_mapper.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_draft_data.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_repository.dart';
import 'package:uuid/uuid.dart';

final class DriftReportRepository implements ReportRepository {
  DriftReportRepository(
    this._database, {
    DateTime Function()? now,
    ReportSnapshotFileStore? snapshotFileStore,
    ReportPhotoFileStore? photoFileStore,
    ReportSignatureFileStore? signatureFileStore,
    this._accessPolicy = const ReportAccessPolicy(),
  }) : _uuid = const Uuid(),
       _clock = now ?? DateTime.now,
       _snapshotFileStore = snapshotFileStore ?? ReportSnapshotFileStore(),
       _photoFileStore = photoFileStore ?? ReportPhotoFileStore(),
       _signatureFileStore = signatureFileStore ?? ReportSignatureFileStore();

  final AppDatabase _database;
  final Uuid _uuid;
  final DateTime Function() _clock;
  final ReportSnapshotFileStore _snapshotFileStore;
  final ReportPhotoFileStore _photoFileStore;
  final ReportSignatureFileStore _signatureFileStore;
  final ReportAccessPolicy _accessPolicy;

  @override
  Stream<List<Report>> watchReports() => _activeReportsQuery()
      .watch()
      .map((entities) => entities.map((entity) => entity.toDomain()).toList())
      .handleError(_reportStreamError('Could not watch reports.'));

  @override
  Stream<Report?> watchReport(String id) {
    final query = _database.select(_database.reports)
      ..where((report) => report.id.equals(id));
    return query
        .watchSingleOrNull()
        .map((entity) => entity?.toDomain())
        .handleError(_reportStreamError('Could not watch the report.'));
  }

  @override
  Future<Report?> getReport(String id) async {
    try {
      return await _findReport(id);
    } catch (error) {
      throw DatabaseException('Could not load the report.', cause: error);
    }
  }

  @override
  Future<Report> createDraft({
    String? customerId,
    ReportType reportType = ReportType.service,
    String? title,
  }) async {
    try {
      final data = ReportDraftData(
        customerId: customerId,
        reportType: reportType,
        title: title ?? '',
      ).normalized();
      await _ensureCustomerExists(data.customerId);
      final draft = Report.draft(
        id: _uuid.v4(),
        customerId: data.customerId,
        reportType: data.reportType,
        title: data.title,
        createdAt: _nowUtc(),
      );
      await _database.into(_database.reports).insert(draft.toCompanion());
      return draft;
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException(
        'Could not create the draft report.',
        cause: error,
      );
    }
  }

  @override
  Future<Report> updateDraft(String id, ReportDraftData data) async {
    try {
      final existing = await _findReport(id);
      if (existing == null) {
        throw const DatabaseException('Report not found.');
      }
      if (!existing.isDraft || existing.archivedAt != null) {
        throw const ValidationException('Only draft reports can be edited.');
      }

      final normalized = data.normalized();
      await _ensureCustomerExists(normalized.customerId);
      final updated = Report(
        id: existing.id,
        reportNumber: existing.reportNumber,
        customerId: normalized.customerId,
        reportType: normalized.reportType,
        status: existing.status,
        title: normalized.title,
        siteAddress: normalized.siteAddress,
        equipmentName: normalized.equipmentName,
        equipmentManufacturer: normalized.equipmentManufacturer,
        equipmentModel: normalized.equipmentModel,
        equipmentSerial: normalized.equipmentSerial,
        issueReported: normalized.issueReported,
        diagnosis: normalized.diagnosis,
        workPerformed: normalized.workPerformed,
        recommendations: normalized.recommendations,
        internalNotes: normalized.internalNotes,
        startedAt: normalized.startedAt,
        completedAt: normalized.completedAt,
        finalizedAt: existing.finalizedAt,
        finalizedSnapshotJson: existing.finalizedSnapshotJson,
        pdfTemplateId: normalized.pdfTemplateId,
        createdAt: existing.createdAt,
        updatedAt: _nowUtc(),
        archivedAt: existing.archivedAt,
      );
      final changed = await (_database.update(
        _database.reports,
      )..where((report) => report.id.equals(id))).write(updated.toCompanion());
      if (changed == 0) {
        throw const DatabaseException('Report not found.');
      }
      return updated;
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException(
        'Could not update the draft report.',
        cause: error,
      );
    }
  }

  @override
  Future<ReportFinalizationValidation> validateFinalization(String id) async {
    try {
      final report = await _findReport(id);
      if (report == null) {
        return const ReportFinalizationValidation(['Report not found.']);
      }
      final business = await _loadBusinessProfile();
      if (business == null) {
        return const ReportFinalizationValidation([
          'Business profile is required before finalizing a report.',
        ]);
      }
      final base = ReportFinalizationValidator.validate(
        report: report,
        business: business,
      );
      final usage = await getUsageCounter(forMonth: _nowUtc());
      if (!_accessPolicy.canFinalize(usage)) {
        return ReportFinalizationValidation([
          ...base.errors,
          'Monthly free report limit reached.',
        ]);
      }
      return base;
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException(
        'Could not validate the report for finalization.',
        cause: error,
      );
    }
  }

  @override
  Future<Report> finalizeReport(String id) async {
    String? snapshotLogoPath;
    try {
      final initialReport = await _findReport(id);
      if (initialReport == null) {
        throw const DatabaseException('Report not found.');
      }
      final initialBusiness = await _loadBusinessProfile();
      if (initialBusiness == null) {
        throw const ValidationException(
          'Business profile is required before finalizing a report.',
        );
      }
      final initialValidation = ReportFinalizationValidator.validate(
        report: initialReport,
        business: initialBusiness,
      );
      if (!initialValidation.isValid) {
        throw ValidationException(initialValidation.errors.join('\n'));
      }

      snapshotLogoPath = await _snapshotFileStore.copyBusinessLogo(
        reportId: id,
        sourcePath: initialBusiness.logoPath,
      );
      final finalizedAt = _nowUtc();

      return await _database.transaction(() async {
        final report = await _findReport(id);
        if (report == null) {
          throw const DatabaseException('Report not found.');
        }
        final business = await _loadBusinessProfile();
        if (business == null) {
          throw const ValidationException(
            'Business profile is required before finalizing a report.',
          );
        }
        final validation = ReportFinalizationValidator.validate(
          report: report,
          business: business,
        );
        if (!validation.isValid) {
          throw ValidationException(validation.errors.join('\n'));
        }

        final usage = await _usageFor(finalizedAt);
        if (!_accessPolicy.canFinalize(usage)) {
          throw const ValidationException('Monthly free report limit reached.');
        }

        final reportNumber = await _nextReportNumber(
          prefix: business.reportPrefix,
          year: finalizedAt.year,
          now: finalizedAt,
        );
        final customer = await _customerEntity(report.customerId);
        final materials =
            await (_database.select(_database.reportMaterials)
                  ..where((item) => item.reportId.equals(id))
                  ..orderBy([(item) => OrderingTerm.asc(item.sortOrder)]))
                .get();
        final photos = await (_database.select(
          _database.reportPhotos,
        )..where((item) => item.reportId.equals(id))).get();
        photos.sort((left, right) {
          final categoryOrder = ReportPhotoCategory.fromDatabase(left.category)
              .index
              .compareTo(
                ReportPhotoCategory.fromDatabase(right.category).index,
              );
          return categoryOrder != 0
              ? categoryOrder
              : left.sortOrder.compareTo(right.sortOrder);
        });
        final signatures =
            await (_database.select(_database.reportSignatures)
                  ..where((item) => item.reportId.equals(id))
                  ..orderBy([(item) => OrderingTerm.asc(item.signatureType)]))
                .get();
        final completedAt = report.completedAt ?? finalizedAt;
        final snapshot = ReportSnapshot(
          schemaVersion: ReportSnapshot.currentSchemaVersion,
          finalizedAt: finalizedAt,
          report: ReportSnapshotReport(
            number: reportNumber,
            type: report.reportType,
            title: report.title,
            siteAddress: report.siteAddress,
            issueReported: report.issueReported,
            diagnosis: report.diagnosis,
            workPerformed: report.workPerformed,
            recommendations: report.recommendations,
            internalNotes: report.internalNotes,
            startedAt: report.startedAt,
            completedAt: completedAt,
            createdAt: report.createdAt,
            updatedAt: finalizedAt,
            finalizedAt: finalizedAt,
          ),
          business: ReportSnapshotBusiness(
            businessName: business.businessName,
            technicianName: business.technicianName,
            email: business.email,
            phone: business.phone,
            address: business.address,
            countryCode: business.countryCode,
            currencyCode: business.currencyCode,
            localeCode: business.localeCode,
            logoPath: snapshotLogoPath,
            taxLabel: business.taxLabel,
            taxNumber: business.taxNumber,
            reportPrefix: business.reportPrefix,
            defaultTerms: business.defaultTerms,
          ),
          customer: customer == null
              ? null
              : ReportSnapshotCustomer(
                  name: customer.name,
                  companyName: customer.companyName,
                  phone: customer.phone,
                  email: customer.email,
                  address: customer.address,
                ),
          equipment: ReportSnapshotEquipment(
            name: report.equipmentName,
            manufacturer: report.equipmentManufacturer,
            model: report.equipmentModel,
            serial: report.equipmentSerial,
          ),
          materials: materials
              .map(
                (item) => ReportSnapshotMaterial(
                  name: item.name,
                  quantity: item.quantity,
                  unit: item.unit,
                  notes: item.notes,
                  sortOrder: item.sortOrder,
                ),
              )
              .toList(growable: false),
          photos: photos
              .map(
                (item) => ReportSnapshotPhoto(
                  filePath: item.filePath,
                  thumbnailPath: item.thumbnailPath,
                  category: ReportPhotoCategory.fromDatabase(item.category),
                  caption: item.caption,
                  sortOrder: item.sortOrder,
                  createdAt: item.createdAt,
                ),
              )
              .toList(growable: false),
          signatures: signatures
              .map(
                (item) => ReportSnapshotSignature(
                  type: ReportSignatureType.fromDatabase(item.signatureType),
                  signerName: item.signerName,
                  filePath: item.filePath,
                  signedAt: item.signedAt,
                ),
              )
              .toList(growable: false),
          templateId: report.pdfTemplateId,
        );

        final changed =
            await (_database.update(
              _database.reports,
            )..where((item) => item.id.equals(id))).write(
              ReportsCompanion(
                reportNumber: Value(reportNumber),
                status: Value(ReportStatus.finalized.databaseValue),
                completedAt: Value(completedAt),
                finalizedAt: Value(finalizedAt),
                finalizedSnapshotJson: Value(snapshot.toJsonString()),
                updatedAt: Value(finalizedAt),
              ),
            );
        if (changed == 0) {
          throw const DatabaseException('Report not found.');
        }
        await _incrementUsage(finalizedAt);
        final finalized = await _findReport(id);
        if (finalized == null) {
          throw const DatabaseException(
            'Finalized report could not be loaded.',
          );
        }
        return finalized;
      });
    } on AppException {
      await _snapshotFileStore.deleteSnapshotFile(snapshotLogoPath);
      rethrow;
    } catch (error) {
      await _snapshotFileStore.deleteSnapshotFile(snapshotLogoPath);
      throw DatabaseException('Could not finalize the report.', cause: error);
    }
  }

  @override
  Future<UsageCounter> getUsageCounter({DateTime? forMonth}) async {
    try {
      return await _usageFor((forMonth ?? _nowUtc()).toUtc());
    } catch (error) {
      throw DatabaseException('Could not load report usage.', cause: error);
    }
  }

  @override
  Future<void> archiveReport(String id) async {
    try {
      final existing = await _findReport(id);
      if (existing == null) {
        throw const DatabaseException('Report not found.');
      }
      final now = _nowUtc();
      final changed =
          await (_database.update(
            _database.reports,
          )..where((report) => report.id.equals(id))).write(
            ReportsCompanion(
              status: Value(ReportStatus.archived.databaseValue),
              archivedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      if (changed == 0) {
        throw const DatabaseException('Report not found.');
      }
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not archive the report.', cause: error);
    }
  }

  @override
  Future<Report> duplicateAsDraft(String id) async {
    final copiedPhotos = <({String filePath, String? thumbnailPath})>[];
    final copiedSignatures = <String>[];
    try {
      final source = await _findReport(id);
      if (source == null) {
        throw const DatabaseException('Report not found.');
      }
      final duplicateId = _uuid.v4();
      final createdAt = _nowUtc();
      final duplicate = Report.draft(
        id: duplicateId,
        customerId: source.customerId,
        reportType: source.reportType,
        title: source.title,
        siteAddress: source.siteAddress,
        equipmentName: source.equipmentName,
        equipmentManufacturer: source.equipmentManufacturer,
        equipmentModel: source.equipmentModel,
        equipmentSerial: source.equipmentSerial,
        issueReported: source.issueReported,
        diagnosis: source.diagnosis,
        workPerformed: source.workPerformed,
        recommendations: source.recommendations,
        internalNotes: source.internalNotes,
        startedAt: source.startedAt,
        completedAt: source.completedAt,
        pdfTemplateId: source.pdfTemplateId,
        createdAt: createdAt,
      );

      final materials =
          await (_database.select(_database.reportMaterials)
                ..where((item) => item.reportId.equals(id))
                ..orderBy([(item) => OrderingTerm.asc(item.sortOrder)]))
              .get();
      final photos =
          await (_database.select(_database.reportPhotos)
                ..where((item) => item.reportId.equals(id))
                ..orderBy([
                  (item) => OrderingTerm.asc(item.category),
                  (item) => OrderingTerm.asc(item.sortOrder),
                ]))
              .get();
      final signatures =
          await (_database.select(_database.reportSignatures)
                ..where((item) => item.reportId.equals(id))
                ..orderBy([(item) => OrderingTerm.asc(item.signatureType)]))
              .get();

      final photoCopies =
          <
            ({
              ReportPhotoEntity source,
              String id,
              StoredReportPhotoFiles files,
            })
          >[];
      for (final photo in photos) {
        final photoId = _uuid.v4();
        final files = await _photoFileStore.importPhoto(
          reportId: duplicateId,
          photoId: photoId,
          sourcePath: photo.filePath,
        );
        copiedPhotos.add((
          filePath: files.filePath,
          thumbnailPath: files.thumbnailPath,
        ));
        photoCopies.add((source: photo, id: photoId, files: files));
      }

      final signatureCopies =
          <({ReportSignatureEntity source, String id, String filePath})>[];
      for (final signature in signatures) {
        final sourceFile = File(signature.filePath);
        if (!await sourceFile.exists()) {
          throw const FileStorageException(
            'A signature file required for duplication could not be found.',
          );
        }
        final type = ReportSignatureType.fromDatabase(signature.signatureType);
        final filePath = await _signatureFileStore.writeSignature(
          reportId: duplicateId,
          type: type,
          fileKey: _uuid.v4(),
          pngBytes: await sourceFile.readAsBytes(),
        );
        copiedSignatures.add(filePath);
        signatureCopies.add((
          source: signature,
          id: _uuid.v4(),
          filePath: filePath,
        ));
      }

      return await _database.transaction(() async {
        await _database.into(_database.reports).insert(duplicate.toCompanion());
        for (final material in materials) {
          await _database
              .into(_database.reportMaterials)
              .insert(
                ReportMaterialsCompanion.insert(
                  id: _uuid.v4(),
                  reportId: duplicateId,
                  name: material.name,
                  quantity: material.quantity,
                  unit: Value(material.unit),
                  notes: Value(material.notes),
                  sortOrder: material.sortOrder,
                ),
              );
        }
        for (final copy in photoCopies) {
          await _database
              .into(_database.reportPhotos)
              .insert(
                ReportPhotosCompanion.insert(
                  id: copy.id,
                  reportId: duplicateId,
                  filePath: copy.files.filePath,
                  thumbnailPath: Value(copy.files.thumbnailPath),
                  category: copy.source.category,
                  caption: Value(copy.source.caption),
                  sortOrder: copy.source.sortOrder,
                  createdAt: createdAt,
                ),
              );
        }
        for (final copy in signatureCopies) {
          await _database
              .into(_database.reportSignatures)
              .insert(
                ReportSignaturesCompanion.insert(
                  id: copy.id,
                  reportId: duplicateId,
                  signatureType: copy.source.signatureType,
                  signerName: copy.source.signerName,
                  filePath: copy.filePath,
                  signedAt: createdAt,
                ),
              );
        }
        return duplicate;
      });
    } on AppException {
      for (final photo in copiedPhotos) {
        await _photoFileStore.deleteFiles(
          filePath: photo.filePath,
          thumbnailPath: photo.thumbnailPath,
        );
      }
      for (final path in copiedSignatures) {
        await _signatureFileStore.deleteSignature(path);
      }
      rethrow;
    } catch (error) {
      for (final photo in copiedPhotos) {
        await _photoFileStore.deleteFiles(
          filePath: photo.filePath,
          thumbnailPath: photo.thumbnailPath,
        );
      }
      for (final path in copiedSignatures) {
        await _signatureFileStore.deleteSignature(path);
      }
      throw DatabaseException('Could not duplicate the report.', cause: error);
    }
  }

  SimpleSelectStatement<Reports, ReportEntity> _activeReportsQuery() =>
      _database.select(_database.reports)
        ..where(
          (report) =>
              report.status.isNotValue(ReportStatus.archived.databaseValue) &
              report.archivedAt.isNull(),
        )
        ..orderBy([
          (report) => OrderingTerm.desc(report.updatedAt),
          (report) => OrderingTerm.desc(report.createdAt),
        ]);

  Future<Report?> _findReport(String id) async {
    final query = _database.select(_database.reports)
      ..where((report) => report.id.equals(id));
    return (await query.getSingleOrNull())?.toDomain();
  }

  Future<void> _ensureCustomerExists(String? customerId) async {
    if (customerId == null) return;
    final query = _database.select(_database.customers)
      ..where((customer) => customer.id.equals(customerId));
    if (await query.getSingleOrNull() == null) {
      throw const ValidationException('Selected customer was not found.');
    }
  }

  Future<BusinessProfile?> _loadBusinessProfile() async {
    final query = _database.select(_database.businessProfiles)..limit(1);
    return (await query.getSingleOrNull())?.toDomain();
  }

  Future<CustomerEntity?> _customerEntity(String? customerId) async {
    if (customerId == null) return null;
    final query = _database.select(_database.customers)
      ..where((customer) => customer.id.equals(customerId));
    return query.getSingleOrNull();
  }

  Future<UsageCounter> _usageFor(DateTime month) async {
    final utc = month.toUtc();
    final id = _usageId(utc.year, utc.month);
    final query = _database.select(_database.usageCounters)
      ..where((item) => item.id.equals(id));
    final entity = await query.getSingleOrNull();
    return UsageCounter(
      year: utc.year,
      month: utc.month,
      finalizedReportCount: entity?.finalizedReportCount ?? 0,
    );
  }

  Future<void> _incrementUsage(DateTime month) async {
    final utc = month.toUtc();
    final id = _usageId(utc.year, utc.month);
    final query = _database.select(_database.usageCounters)
      ..where((item) => item.id.equals(id));
    final entity = await query.getSingleOrNull();
    if (entity == null) {
      await _database
          .into(_database.usageCounters)
          .insert(
            UsageCountersCompanion.insert(
              id: id,
              year: utc.year,
              month: utc.month,
              finalizedReportCount: const Value(1),
            ),
          );
      return;
    }
    await (_database.update(
      _database.usageCounters,
    )..where((item) => item.id.equals(id))).write(
      UsageCountersCompanion(
        finalizedReportCount: Value(entity.finalizedReportCount + 1),
      ),
    );
  }

  Future<String> _nextReportNumber({
    required String prefix,
    required int year,
    required DateTime now,
  }) async {
    final normalizedPrefix = prefix.trim().toUpperCase();
    final key = 'report-sequence:$normalizedPrefix:$year';
    final query = _database.select(_database.databaseMetadata)
      ..where((item) => item.key.equals(key));
    final metadata = await query.getSingleOrNull();
    var current = int.tryParse(metadata?.value ?? '') ?? 0;

    if (metadata == null) {
      final existing = await _database.select(_database.reports).get();
      final numberPrefix = '$normalizedPrefix-$year-';
      for (final item in existing) {
        final number = item.reportNumber;
        if (number == null || !number.startsWith(numberPrefix)) continue;
        final suffix = int.tryParse(number.substring(numberPrefix.length));
        if (suffix != null && suffix > current) current = suffix;
      }
    }

    final next = current + 1;
    await _database
        .into(_database.databaseMetadata)
        .insertOnConflictUpdate(
          DatabaseMetadataCompanion.insert(
            key: key,
            value: Value(next.toString()),
            updatedAt: Value(now),
          ),
        );
    return '$normalizedPrefix-$year-${next.toString().padLeft(4, '0')}';
  }

  String _usageId(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';

  Function _reportStreamError(String message) =>
      (Object error, StackTrace stackTrace) {
        throw DatabaseException(message, cause: error);
      };

  DateTime _nowUtc() {
    final now = _clock().toUtc();
    return DateTime.fromMillisecondsSinceEpoch(
      (now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond) *
          Duration.millisecondsPerSecond,
      isUtc: true,
    );
  }
}
