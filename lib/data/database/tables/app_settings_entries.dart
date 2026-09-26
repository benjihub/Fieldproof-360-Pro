import 'package:drift/drift.dart';

@DataClassName('AppSettingsEntity')
class AppSettingsEntries extends Table {
  TextColumn get id => text()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  TextColumn get defaultReportType =>
      text().withDefault(const Constant('service'))();
  TextColumn get defaultPdfTemplate =>
      text().withDefault(const Constant('classic'))();
  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
