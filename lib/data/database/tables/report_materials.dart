import 'package:drift/drift.dart';
import 'package:fieldproof_360/data/database/tables/reports.dart';

@TableIndex(name: 'report_materials_report_id_idx', columns: {#reportId})
@TableIndex(
  name: 'report_materials_report_order_idx',
  columns: {#reportId, #sortOrder},
)
@DataClassName('ReportMaterialEntity')
class ReportMaterials extends Table {
  TextColumn get id => text()();
  TextColumn get reportId =>
      text().references(Reports, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
