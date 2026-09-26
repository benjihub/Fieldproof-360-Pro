import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_material.dart';

extension ReportMaterialEntityMapper on ReportMaterialEntity {
  ReportMaterial toDomain() => ReportMaterial(
    id: id,
    reportId: reportId,
    name: name,
    quantity: quantity,
    unit: unit,
    notes: notes,
    sortOrder: sortOrder,
  );
}
