import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_material_repository.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_material.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_material_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportMaterialRepositoryProvider = Provider<ReportMaterialRepository>(
  (ref) => DriftReportMaterialRepository(ref.watch(appDatabaseProvider)),
);

final reportMaterialsProvider =
    StreamProvider.family<List<ReportMaterial>, String>(
      (ref, reportId) =>
          ref.watch(reportMaterialRepositoryProvider).watchMaterials(reportId),
    );
