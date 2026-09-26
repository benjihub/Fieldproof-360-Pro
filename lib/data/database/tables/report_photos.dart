import 'package:drift/drift.dart';
import 'package:fieldproof_360/data/database/tables/reports.dart';

@TableIndex(name: 'report_photos_report_id_idx', columns: {#reportId})
@TableIndex(
  name: 'report_photos_report_category_order_idx',
  columns: {#reportId, #category, #sortOrder},
)
@DataClassName('ReportPhotoEntity')
class ReportPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get reportId =>
      text().references(Reports, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get category => text()();
  TextColumn get caption => text().nullable()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
