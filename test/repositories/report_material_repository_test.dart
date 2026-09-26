import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_material_repository.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  test('adds, normalizes, updates, reorders and deletes materials', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    var now = DateTime.utc(2026, 9, 24, 12);
    final reports = DriftReportRepository(database, now: () => now);
    final report = await reports.createDraft(title: 'Solar service');
    final materials = DriftReportMaterialRepository(database, now: () => now);

    final cable = await materials.addMaterial(
      reportId: report.id,
      name: '  Cable  ',
      quantity: 20,
      unit: ' m ',
      notes: '  2.5mm  ',
    );
    final breaker = await materials.addMaterial(
      reportId: report.id,
      name: 'Breaker',
      quantity: 1,
      unit: 'pc',
    );

    expect(cable.name, 'Cable');
    expect(cable.unit, 'm');
    expect(cable.notes, '2.5mm');
    expect((await materials.getMaterials(report.id)).map((item) => item.id), [
      cable.id,
      breaker.id,
    ]);

    now = DateTime.utc(2026, 9, 24, 13);
    final updated = await materials.updateMaterial(
      materialId: cable.id,
      name: 'Copper cable',
      quantity: 25.5,
      unit: 'm',
    );
    expect(updated.name, 'Copper cable');
    expect(updated.quantity, 25.5);
    expect((await reports.getReport(report.id))?.updatedAt, now);

    await materials.reorderMaterials(
      reportId: report.id,
      orderedMaterialIds: [breaker.id, cable.id],
    );
    expect((await materials.getMaterials(report.id)).map((item) => item.id), [
      breaker.id,
      cable.id,
    ]);

    await materials.deleteMaterial(breaker.id);
    expect((await materials.getMaterials(report.id)).single.id, cable.id);
  });

  test(
    'rejects invalid quantity and material edits on archived reports',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final reports = DriftReportRepository(database);
      final report = await reports.createDraft();
      final materials = DriftReportMaterialRepository(database);

      await expectLater(
        materials.addMaterial(reportId: report.id, name: 'Cable', quantity: 0),
        throwsA(isA<ValidationException>()),
      );

      await reports.archiveReport(report.id);
      await expectLater(
        materials.addMaterial(reportId: report.id, name: 'Cable', quantity: 1),
        throwsA(isA<ValidationException>()),
      );
    },
  );

  test('material stream reacts to additions', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final report = await DriftReportRepository(database).createDraft();
    final repository = DriftReportMaterialRepository(database);
    final emission = repository
        .watchMaterials(report.id)
        .firstWhere((items) => items.length == 1);

    await repository.addMaterial(
      reportId: report.id,
      name: 'Filter',
      quantity: 1,
    );

    expect((await emission).single.name, 'Filter');
  });
}
