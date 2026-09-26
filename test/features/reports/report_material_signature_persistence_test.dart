import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_material_repository.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_signature_repository.dart';
import 'package:fieldproof_360/features/reports/data/services/report_signature_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('materials and signatures survive a database restart', () async {
    final root = await Directory.systemTemp.createTemp(
      'fieldproof-phase5-persist-',
    );
    addTearDown(() => root.delete(recursive: true));
    final databaseFile = File('${root.path}/fieldproof.sqlite');
    final fileStore = ReportSignatureFileStore(
      supportDirectory: () async => root,
    );

    var database = AppDatabase(NativeDatabase(databaseFile));
    final report = await DriftReportRepository(
      database,
    ).createDraft(title: 'Generator repair');
    await DriftReportMaterialRepository(database).addMaterial(
      reportId: report.id,
      name: 'Fuel filter',
      quantity: 1,
      unit: 'pc',
    );
    final savedSignature =
        await DriftReportSignatureRepository(database, fileStore).saveSignature(
          reportId: report.id,
          type: ReportSignatureType.technician,
          signerName: 'Benjamin',
          pngBytes: Uint8List.fromList([1, 2, 3, 4]),
        );
    await database.close();

    database = AppDatabase(NativeDatabase(databaseFile));
    addTearDown(database.close);
    final materials = await DriftReportMaterialRepository(
      database,
    ).getMaterials(report.id);
    final signature = await DriftReportSignatureRepository(
      database,
      fileStore,
    ).getSignature(report.id, ReportSignatureType.technician);

    expect(materials.single.name, 'Fuel filter');
    expect(signature?.signerName, 'Benjamin');
    expect(signature?.filePath, savedSignature.filePath);
    expect(await File(savedSignature.filePath).exists(), isTrue);
  });
}
