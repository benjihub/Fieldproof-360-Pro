import 'package:drift/drift.dart';
import 'package:fieldproof_360/data/database/tables/customers.dart';

@TableIndex(name: 'reports_status_idx', columns: {#status})
@TableIndex(name: 'reports_customer_id_idx', columns: {#customerId})
@TableIndex(name: 'reports_updated_at_idx', columns: {#updatedAt})
@TableIndex(
  name: 'reports_report_number_idx',
  columns: {#reportNumber},
  unique: true,
)
@DataClassName('ReportEntity')
class Reports extends Table {
  TextColumn get id => text()();
  TextColumn get reportNumber => text().nullable()();
  TextColumn get customerId => text().nullable().references(
    Customers,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get reportType => text().withDefault(const Constant('service'))();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get siteAddress => text().nullable()();
  TextColumn get equipmentName => text().nullable()();
  TextColumn get equipmentManufacturer => text().nullable()();
  TextColumn get equipmentModel => text().nullable()();
  TextColumn get equipmentSerial => text().nullable()();
  TextColumn get issueReported => text().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get workPerformed => text().withDefault(const Constant(''))();
  TextColumn get recommendations => text().nullable()();
  TextColumn get internalNotes => text().nullable()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get finalizedAt => dateTime().nullable()();
  TextColumn get finalizedSnapshotJson => text().nullable()();
  TextColumn get pdfTemplateId =>
      text().withDefault(const Constant('classic'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
