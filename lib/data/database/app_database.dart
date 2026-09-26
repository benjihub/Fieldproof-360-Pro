import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:fieldproof_360/data/database/tables/app_settings_entries.dart';
import 'package:fieldproof_360/data/database/tables/business_profiles.dart';
import 'package:fieldproof_360/data/database/tables/customers.dart';
import 'package:fieldproof_360/data/database/tables/database_metadata.dart';
import 'package:fieldproof_360/data/database/tables/reports.dart';
import 'package:fieldproof_360/data/database/tables/report_photos.dart';
import 'package:fieldproof_360/data/database/tables/report_materials.dart';
import 'package:fieldproof_360/data/database/tables/report_signatures.dart';
import 'package:fieldproof_360/data/database/tables/usage_counters.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DatabaseMetadata,
    BusinessProfiles,
    AppSettingsEntries,
    Customers,
    Reports,
    ReportPhotos,
    ReportMaterials,
    ReportSignatures,
    UsageCounters,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'fieldproof'));

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: _runMigrations,
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<bool> verifyConnection() async {
    final row = await customSelect('SELECT 1 AS result').getSingle();
    return row.read<int>('result') == 1;
  }

  Future<void> _runMigrations(
    Migrator migrator,
    int fromVersion,
    int toVersion,
  ) async {
    if (fromVersion > toVersion) {
      throw StateError('Database downgrades are not supported.');
    }

    var migratedVersion = fromVersion;
    if (migratedVersion == 1 && toVersion >= 2) {
      await migrator.createTable(businessProfiles);
      await migrator.createTable(appSettingsEntries);
      migratedVersion = 2;
    }

    if (migratedVersion == 2 && toVersion >= 3) {
      await migrator.createTable(customers);
      migratedVersion = 3;
    }

    if (migratedVersion == 3 && toVersion >= 4) {
      await migrator.createTable(reports);
      await migrator.createIndex(reportsStatusIdx);
      await migrator.createIndex(reportsCustomerIdIdx);
      await migrator.createIndex(reportsUpdatedAtIdx);
      await migrator.createIndex(reportsReportNumberIdx);
      migratedVersion = 4;
    }

    if (migratedVersion == 4 && toVersion >= 5) {
      await migrator.createTable(reportPhotos);
      await migrator.createIndex(reportPhotosReportIdIdx);
      await migrator.createIndex(reportPhotosReportCategoryOrderIdx);
      migratedVersion = 5;
    }

    if (migratedVersion == 5 && toVersion >= 6) {
      await migrator.createTable(reportMaterials);
      await migrator.createIndex(reportMaterialsReportIdIdx);
      await migrator.createIndex(reportMaterialsReportOrderIdx);
      await migrator.createTable(reportSignatures);
      await migrator.createIndex(reportSignaturesReportIdIdx);
      await migrator.createIndex(reportSignaturesReportTypeIdx);
      migratedVersion = 6;
    }

    if (migratedVersion == 6 && toVersion >= 7) {
      await migrator.createTable(usageCounters);
      await migrator.createIndex(usageCountersYearMonthIdx);
      migratedVersion = 7;
    }

    if (migratedVersion != toVersion) {
      throw StateError(
        'Missing migration from schema $migratedVersion to $toVersion.',
      );
    }
  }
}
