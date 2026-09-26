import 'package:drift/drift.dart';

@TableIndex(
  name: 'usage_counters_year_month_idx',
  columns: {#year, #month},
  unique: true,
)
@DataClassName('UsageCounterEntity')
class UsageCounters extends Table {
  TextColumn get id => text()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get finalizedReportCount =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
