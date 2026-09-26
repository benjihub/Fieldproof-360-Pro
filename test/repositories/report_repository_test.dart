import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/business/data/repositories/drift_business_repository.dart';
import 'package:fieldproof_360/features/reports/data/services/report_photo_file_store.dart';
import 'package:fieldproof_360/features/reports/data/services/report_signature_file_store.dart';
import 'package:fieldproof_360/features/reports/data/mappers/report_mapper.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_draft_data.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  test('creates and loads an incomplete draft with stable defaults', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final now = DateTime.utc(2026, 9, 24, 9);
    final repository = DriftReportRepository(database, now: () => now);

    final created = await repository.createDraft();
    final loaded = await repository.getReport(created.id);

    expect(created.reportType, ReportType.service);
    expect(created.pdfTemplateId, 'classic');
    expect(created.reportNumber, isNull);
    expect(created.customerId, isNull);
    expect(created.workPerformed, isEmpty);
    expect(created.finalizedAt, isNull);
    expect(created.finalizedSnapshotJson, isNull);
    expect(created.createdAt, now);
    expect(loaded?.id, created.id);
    expect(await repository.getReport('missing'), isNull);
  });

  test('creates with a customer and can change or clear association', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final timestamp = DateTime.utc(2026, 9, 24, 9);
    await _insertCustomer(database, 'customer-1', 'Amina');
    await _insertCustomer(database, 'customer-2', 'Brian');
    final repository = DriftReportRepository(database, now: () => timestamp);

    final created = await repository.createDraft(
      customerId: ' customer-1 ',
      reportType: ReportType.inspection,
      title: ' Site inspection ',
    );
    expect(created.customerId, 'customer-1');
    expect(created.reportType, ReportType.inspection);
    expect(created.title, 'Site inspection');

    final changed = await repository.updateDraft(
      created.id,
      const ReportDraftData(customerId: 'customer-2', title: 'Changed'),
    );
    expect(changed.customerId, 'customer-2');

    final cleared = await repository.updateDraft(
      created.id,
      const ReportDraftData(title: 'No customer'),
    );
    expect(cleared.customerId, isNull);
  });

  test('rejects a customer association that does not exist', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final repository = DriftReportRepository(database);

    await expectLater(
      repository.createDraft(customerId: 'missing-customer'),
      throwsA(isA<ValidationException>()),
    );
  });

  test('updates and normalizes every editable draft field', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    var now = DateTime.utc(2026, 9, 24, 9);
    final repository = DriftReportRepository(database, now: () => now);
    final created = await repository.createDraft(title: 'Initial');
    now = DateTime.utc(2026, 9, 24, 10);

    final updated = await repository.updateDraft(
      created.id,
      ReportDraftData(
        reportType: ReportType.maintenance,
        title: '  Pump repair  ',
        siteAddress: '  Kampala Road  ',
        equipmentName: '  Water pump  ',
        equipmentManufacturer: '  Acme  ',
        equipmentModel: '  P100  ',
        equipmentSerial: '  SN-1  ',
        issueReported: '  No pressure  ',
        diagnosis: '  Failed valve  ',
        workPerformed: '  Replaced valve  ',
        recommendations: '  Inspect monthly  ',
        internalNotes: '  Warranty checked  ',
        startedAt: DateTime(2026, 9, 24, 8),
        completedAt: DateTime(2026, 9, 24, 9),
        pdfTemplateId: '  field  ',
      ),
    );

    expect(updated.reportType, ReportType.maintenance);
    expect(updated.title, 'Pump repair');
    expect(updated.siteAddress, 'Kampala Road');
    expect(updated.equipmentName, 'Water pump');
    expect(updated.equipmentManufacturer, 'Acme');
    expect(updated.equipmentModel, 'P100');
    expect(updated.equipmentSerial, 'SN-1');
    expect(updated.issueReported, 'No pressure');
    expect(updated.diagnosis, 'Failed valve');
    expect(updated.workPerformed, 'Replaced valve');
    expect(updated.recommendations, 'Inspect monthly');
    expect(updated.internalNotes, 'Warranty checked');
    expect(updated.startedAt?.isUtc, isTrue);
    expect(updated.completedAt?.isUtc, isTrue);
    expect(updated.pdfTemplateId, 'field');
    expect(updated.createdAt, created.createdAt);
    expect(updated.updatedAt, now);
    expect(updated.updatedAt.isAfter(created.updatedAt), isTrue);
    expect(updated.reportNumber, created.reportNumber);
    expect(updated.finalizedAt, created.finalizedAt);

    now = DateTime.utc(2026, 9, 24, 11);
    final cleared = await repository.updateDraft(
      created.id,
      const ReportDraftData(
        title: '  ',
        siteAddress: '  ',
        workPerformed: '  ',
        pdfTemplateId: '  ',
      ),
    );
    expect(cleared.title, isEmpty);
    expect(cleared.siteAddress, isNull);
    expect(cleared.workPerformed, isEmpty);
    expect(cleared.pdfTemplateId, 'classic');
  });

  test('watchReport emits missing, created, and updated values', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    var now = DateTime.utc(2026, 9, 24, 9);
    final repository = DriftReportRepository(database, now: () => now);
    expect(await repository.watchReport('missing').first, isNull);

    final created = await repository.createDraft(title: 'Original');
    final updatedEmission = repository
        .watchReport(created.id)
        .firstWhere((report) => report?.title == 'Updated');
    now = DateTime.utc(2026, 9, 24, 10);
    await repository.updateDraft(
      created.id,
      const ReportDraftData(title: 'Updated'),
    );

    expect((await updatedEmission)?.title, 'Updated');
  });

  test(
    'watchReports orders newest updates first and excludes archived',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      var now = DateTime.utc(2026, 9, 24, 9);
      final repository = DriftReportRepository(database, now: () => now);
      final older = await repository.createDraft(title: 'Older');
      now = DateTime.utc(2026, 9, 24, 10);
      final newer = await repository.createDraft(title: 'Newer');

      expect(
        (await repository.watchReports().first).map((report) => report.id),
        [newer.id, older.id],
      );

      now = DateTime.utc(2026, 9, 24, 11);
      await repository.archiveReport(newer.id);
      final active = await repository.watchReports().first;
      final archived = await repository.getReport(newer.id);
      expect(active.map((report) => report.id), [older.id]);
      expect(archived?.status, ReportStatus.archived);
      expect(archived?.archivedAt, now);
      expect(archived?.updatedAt, now);
    },
  );

  test('draft updates reject finalized and archived reports', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final timestamp = DateTime.utc(2026, 9, 24, 9);
    final repository = DriftReportRepository(database, now: () => timestamp);
    await database
        .into(database.reports)
        .insert(
          Report(
            id: 'finalized-report',
            reportNumber: 'FP-2026-0001',
            reportType: ReportType.service,
            status: ReportStatus.finalized,
            title: 'Finalized',
            workPerformed: 'Complete',
            finalizedAt: timestamp,
            finalizedSnapshotJson: '{}',
            pdfTemplateId: 'classic',
            createdAt: timestamp,
            updatedAt: timestamp,
          ).toCompanion(),
        );
    final archived = await repository.createDraft(title: 'Archived');
    await repository.archiveReport(archived.id);

    await expectLater(
      repository.updateDraft(
        'finalized-report',
        const ReportDraftData(title: 'Changed'),
      ),
      throwsA(isA<ValidationException>()),
    );
    await expectLater(
      repository.updateDraft(
        archived.id,
        const ReportDraftData(title: 'Changed'),
      ),
      throwsA(isA<ValidationException>()),
    );
    expect(
      (await repository.getReport('finalized-report'))?.title,
      'Finalized',
    );
  });

  test('duplicates a historical report as a clean new draft', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await _insertCustomer(database, 'customer-1', 'Amina');
    final historicalTime = DateTime.utc(2026, 8, 1, 9);
    final duplicateTime = DateTime.utc(2026, 9, 24, 9);
    final repository = DriftReportRepository(
      database,
      now: () => duplicateTime,
    );
    const sourceId = 'archived-report';
    await database
        .into(database.reports)
        .insert(
          Report(
            id: sourceId,
            reportNumber: 'FP-2026-0001',
            customerId: 'customer-1',
            reportType: ReportType.maintenance,
            status: ReportStatus.archived,
            title: 'Pump repair',
            siteAddress: 'Kampala Road',
            equipmentName: 'Water pump',
            diagnosis: 'Failed valve',
            workPerformed: 'Replaced valve',
            recommendations: 'Inspect monthly',
            internalNotes: 'Warranty checked',
            startedAt: historicalTime,
            completedAt: historicalTime.add(const Duration(hours: 1)),
            finalizedAt: historicalTime,
            finalizedSnapshotJson: '{"version":1}',
            pdfTemplateId: 'field',
            createdAt: historicalTime,
            updatedAt: historicalTime,
            archivedAt: historicalTime,
          ).toCompanion(),
        );

    final duplicate = await repository.duplicateAsDraft(sourceId);

    expect(duplicate.id, isNot(sourceId));
    expect(duplicate.reportNumber, isNull);
    expect(duplicate.status, ReportStatus.draft);
    expect(duplicate.finalizedAt, isNull);
    expect(duplicate.finalizedSnapshotJson, isNull);
    expect(duplicate.archivedAt, isNull);
    expect(duplicate.customerId, 'customer-1');
    expect(duplicate.reportType, ReportType.maintenance);
    expect(duplicate.title, 'Pump repair');
    expect(duplicate.equipmentName, 'Water pump');
    expect(duplicate.workPerformed, 'Replaced valve');
    expect(duplicate.pdfTemplateId, 'field');
    expect(duplicate.createdAt, duplicateTime);
    expect(duplicate.updatedAt, duplicateTime);
  });

  test('customer deletion clears association and preserves report', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await _insertCustomer(database, 'customer-1', 'Amina');
    final repository = DriftReportRepository(database);
    final report = await repository.createDraft(customerId: 'customer-1');

    await (database.delete(
      database.customers,
    )..where((customer) => customer.id.equals('customer-1'))).go();

    final preserved = await repository.getReport(report.id);
    expect(preserved, isNotNull);
    expect(preserved?.customerId, isNull);
  });

  test('created and updated reports persist after database reopen', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fieldproof-report-repository-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/fieldproof.sqlite');
    var now = DateTime.utc(2026, 9, 24, 9);

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final firstRepository = DriftReportRepository(
      firstDatabase,
      now: () => now,
    );
    final created = await firstRepository.createDraft(title: 'Initial');
    now = DateTime.utc(2026, 9, 24, 10);
    await firstRepository.updateDraft(
      created.id,
      const ReportDraftData(
        title: 'Persisted report',
        workPerformed: 'Persisted work',
      ),
    );
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final restored = await DriftReportRepository(
      reopenedDatabase,
    ).getReport(created.id);
    expect(restored?.title, 'Persisted report');
    expect(restored?.workPerformed, 'Persisted work');
    expect(restored?.updatedAt, now);
  });
  test('finalization validates required report content', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final repository = DriftReportRepository(database);
    final report = await repository.createDraft();

    final validation = await repository.validateFinalization(report.id);

    expect(validation.isValid, isFalse);
    expect(validation.errors, contains('Report title is required.'));
    expect(validation.errors, contains('Work performed is required.'));
    await expectLater(
      repository.finalizeReport(report.id),
      throwsA(isA<ValidationException>()),
    );
  });

  test(
    'finalization assigns numbers, snapshots data, and increments usage',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      await seedOnboardedUser(database);
      await _insertCustomer(database, 'customer-final', 'Original Customer');
      final now = DateTime.utc(2026, 9, 24, 14, 30);
      final repository = DriftReportRepository(database, now: () => now);
      final draft = await repository.createDraft(
        customerId: 'customer-final',
        title: 'Solar inverter service',
      );
      await repository.updateDraft(
        draft.id,
        const ReportDraftData(
          customerId: 'customer-final',
          title: 'Solar inverter service',
          equipmentName: '5kVA inverter',
          workPerformed: 'Replaced the damaged cooling fan.',
          recommendations: 'Inspect ventilation every three months.',
        ),
      );
      await database
          .into(database.reportMaterials)
          .insert(
            ReportMaterialsCompanion.insert(
              id: 'material-final',
              reportId: draft.id,
              name: 'Cooling fan',
              quantity: 1,
              unit: const Value('pc'),
              sortOrder: 0,
            ),
          );
      await database
          .into(database.reportPhotos)
          .insert(
            ReportPhotosCompanion.insert(
              id: 'photo-final',
              reportId: draft.id,
              filePath: '/app-owned/before.jpg',
              category: ReportPhotoCategory.before.databaseValue,
              caption: const Value('Before repair'),
              sortOrder: 0,
              createdAt: now,
            ),
          );
      await database
          .into(database.reportSignatures)
          .insert(
            ReportSignaturesCompanion.insert(
              id: 'signature-final',
              reportId: draft.id,
              signatureType: 'technician',
              signerName: 'Benjamin',
              filePath: '/app-owned/signature.png',
              signedAt: now,
            ),
          );

      final finalized = await repository.finalizeReport(draft.id);

      expect(finalized.reportNumber, 'BEN-2026-0001');
      expect(finalized.status, ReportStatus.finalized);
      expect(finalized.finalizedAt, now);
      expect(finalized.completedAt, now);
      final snapshot = finalized.snapshot;
      expect(snapshot, isNotNull);
      expect(snapshot!.report.number, 'BEN-2026-0001');
      expect(snapshot.report.title, 'Solar inverter service');
      expect(snapshot.business.businessName, 'Ben Electrical Services');
      expect(snapshot.customer?.name, 'Original Customer');
      expect(snapshot.equipment.name, '5kVA inverter');
      expect(snapshot.materials.single.name, 'Cooling fan');
      expect(snapshot.photos.single.caption, 'Before repair');
      expect(snapshot.signatures.single.signerName, 'Benjamin');
      expect((await repository.getUsageCounter()).finalizedReportCount, 1);

      await DriftBusinessRepository(database).saveBusinessProfile(
        createTestProfile(businessName: 'Renamed Business'),
      );
      await (database.update(database.customers)
            ..where((customer) => customer.id.equals('customer-final')))
          .write(const CustomersCompanion(name: Value('Renamed Customer')));

      final reloaded = await repository.getReport(draft.id);
      expect(
        reloaded?.snapshot?.business.businessName,
        'Ben Electrical Services',
      );
      expect(reloaded?.snapshot?.customer?.name, 'Original Customer');
      await expectLater(
        repository.updateDraft(
          draft.id,
          const ReportDraftData(title: 'Should fail'),
        ),
        throwsA(isA<ValidationException>()),
      );
    },
  );

  test('report numbering is sequential and prefix/year scoped', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final now = DateTime.utc(2026, 9, 24, 15);
    final repository = DriftReportRepository(database, now: () => now);

    for (var i = 1; i <= 2; i++) {
      final draft = await repository.createDraft(title: 'Report $i');
      await repository.updateDraft(
        draft.id,
        ReportDraftData(title: 'Report $i', workPerformed: 'Completed work $i'),
      );
      final finalized = await repository.finalizeReport(draft.id);
      expect(
        finalized.reportNumber,
        'BEN-2026-${i.toString().padLeft(4, '0')}',
      );
    }

    expect((await repository.getUsageCounter()).finalizedReportCount, 2);
  });

  test(
    'duplicate as draft copies report-owned materials, photos, and signatures',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final directory = await Directory.systemTemp.createTemp(
        'fieldproof-duplicate-assets-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final sourcePhoto = File('${directory.path}/source.jpg');
      final sourceSignature = File('${directory.path}/source-signature.png');
      await sourcePhoto.writeAsBytes([1, 2, 3, 4]);
      await sourceSignature.writeAsBytes([137, 80, 78, 71]);
      final repository = DriftReportRepository(
        database,
        photoFileStore: ReportPhotoFileStore(
          supportDirectory: () async => directory,
        ),
        signatureFileStore: ReportSignatureFileStore(
          supportDirectory: () async => directory,
        ),
      );
      final source = await repository.createDraft(title: 'Asset report');
      await database
          .into(database.reportMaterials)
          .insert(
            ReportMaterialsCompanion.insert(
              id: 'copy-material',
              reportId: source.id,
              name: 'Fuse',
              quantity: 2,
              sortOrder: 0,
            ),
          );
      await database
          .into(database.reportPhotos)
          .insert(
            ReportPhotosCompanion.insert(
              id: 'copy-photo',
              reportId: source.id,
              filePath: sourcePhoto.path,
              category: 'before',
              sortOrder: 0,
              createdAt: DateTime.utc(2026, 9, 24),
            ),
          );
      await database
          .into(database.reportSignatures)
          .insert(
            ReportSignaturesCompanion.insert(
              id: 'copy-signature',
              reportId: source.id,
              signatureType: 'technician',
              signerName: 'Benjamin',
              filePath: sourceSignature.path,
              signedAt: DateTime.utc(2026, 9, 24),
            ),
          );

      final duplicate = await repository.duplicateAsDraft(source.id);
      final materials = await (database.select(
        database.reportMaterials,
      )..where((item) => item.reportId.equals(duplicate.id))).get();
      final photos = await (database.select(
        database.reportPhotos,
      )..where((item) => item.reportId.equals(duplicate.id))).get();
      final signatures = await (database.select(
        database.reportSignatures,
      )..where((item) => item.reportId.equals(duplicate.id))).get();

      expect(materials.single.name, 'Fuse');
      expect(photos, hasLength(1));
      expect(await File(photos.single.filePath).exists(), isTrue);
      expect(signatures, hasLength(1));
      expect(await File(signatures.single.filePath).exists(), isTrue);
      expect(duplicate.reportNumber, isNull);
      expect(duplicate.finalizedSnapshotJson, isNull);
    },
  );
}

Future<void> _insertCustomer(
  AppDatabase database,
  String id,
  String name,
) async {
  final timestamp = DateTime.utc(2026, 9, 24, 8);
  await database
      .into(database.customers)
      .insert(
        CustomersCompanion.insert(
          id: id,
          name: name,
          createdAt: timestamp,
          updatedAt: timestamp,
        ),
      );
}
