import 'package:fieldproof_360/features/reports/domain/models/report_material.dart';

abstract interface class ReportMaterialRepository {
  Stream<List<ReportMaterial>> watchMaterials(String reportId);

  Future<List<ReportMaterial>> getMaterials(String reportId);

  Future<ReportMaterial> addMaterial({
    required String reportId,
    required String name,
    required double quantity,
    String? unit,
    String? notes,
  });

  Future<ReportMaterial> updateMaterial({
    required String materialId,
    required String name,
    required double quantity,
    String? unit,
    String? notes,
  });

  Future<void> reorderMaterials({
    required String reportId,
    required List<String> orderedMaterialIds,
  });

  Future<void> deleteMaterial(String materialId);
}
