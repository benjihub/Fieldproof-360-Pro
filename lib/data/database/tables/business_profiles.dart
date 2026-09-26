import 'package:drift/drift.dart';

@DataClassName('BusinessProfileEntity')
class BusinessProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get businessName => text()();
  TextColumn get technicianName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get countryCode => text()();
  TextColumn get currencyCode => text()();
  TextColumn get localeCode => text()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get taxLabel => text().nullable()();
  TextColumn get taxNumber => text().nullable()();
  TextColumn get reportPrefix => text().withDefault(const Constant('FP'))();
  TextColumn get defaultTerms => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
