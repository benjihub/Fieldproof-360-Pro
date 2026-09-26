import 'package:drift/drift.dart';
import 'package:fieldproof_360/data/database/tables/reports.dart';

@TableIndex(name: 'report_signatures_report_id_idx', columns: {#reportId})
@TableIndex(
  name: 'report_signatures_report_type_idx',
  columns: {#reportId, #signatureType},
  unique: true,
)
@DataClassName('ReportSignatureEntity')
class ReportSignatures extends Table {
  TextColumn get id => text()();
  TextColumn get reportId =>
      text().references(Reports, #id, onDelete: KeyAction.cascade)();
  TextColumn get signatureType => text()();
  TextColumn get signerName => text()();
  TextColumn get filePath => text()();
  DateTimeColumn get signedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
