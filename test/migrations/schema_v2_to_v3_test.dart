import 'dart:io';

import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'migrates schema 2 through 7 and preserves all existing tables',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'fieldproof-v2-migration-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/fieldproof.sqlite');
      _createVersionTwoDatabase(file);

      final database = AppDatabase(NativeDatabase(file));
      addTearDown(database.close);

      expect(await database.verifyConnection(), isTrue);
      final version = await database
          .customSelect('PRAGMA user_version')
          .getSingle();
      expect(version.read<int>('user_version'), 7);

      expect(
        (await database.select(database.databaseMetadata).getSingle()).value,
        '2',
      );
      expect(
        (await database.select(database.businessProfiles).getSingle())
            .businessName,
        'Legacy Field Services',
      );
      expect(
        (await database.select(database.appSettingsEntries).getSingle())
            .hasCompletedOnboarding,
        isTrue,
      );

      final now = DateTime.utc(2026, 9, 24);
      await database
          .into(database.customers)
          .insert(
            CustomersCompanion.insert(
              id: 'customer-after-migration',
              name: 'Migrated Customer',
              createdAt: now,
              updatedAt: now,
            ),
          );
      expect(
        (await database.select(database.customers).getSingle()).name,
        'Migrated Customer',
      );
    },
  );
}

void _createVersionTwoDatabase(File file) {
  final legacy = sqlite3.open(file.path);
  legacy.execute('''
    CREATE TABLE database_metadata (
      "key" TEXT NOT NULL PRIMARY KEY,
      value TEXT NULL,
      updated_at INTEGER NOT NULL
    );
    CREATE TABLE business_profiles (
      id TEXT NOT NULL PRIMARY KEY,
      business_name TEXT NOT NULL,
      technician_name TEXT NOT NULL,
      email TEXT NULL,
      phone TEXT NULL,
      address TEXT NULL,
      country_code TEXT NOT NULL,
      currency_code TEXT NOT NULL,
      locale_code TEXT NOT NULL,
      logo_path TEXT NULL,
      tax_label TEXT NULL,
      tax_number TEXT NULL,
      report_prefix TEXT NOT NULL DEFAULT 'FP',
      default_terms TEXT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    );
    CREATE TABLE app_settings_entries (
      id TEXT NOT NULL PRIMARY KEY,
      theme_mode TEXT NOT NULL DEFAULT 'system',
      default_report_type TEXT NOT NULL DEFAULT 'service',
      default_pdf_template TEXT NOT NULL DEFAULT 'classic',
      has_completed_onboarding INTEGER NOT NULL DEFAULT 0 CHECK (
        has_completed_onboarding IN (0, 1)
      ),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    );
  ''');
  legacy.execute(
    "INSERT INTO database_metadata (\"key\", value, updated_at) "
    "VALUES ('foundation_version', '2', 0);",
  );
  legacy.execute('''
    INSERT INTO business_profiles (
      id, business_name, technician_name, country_code, currency_code,
      locale_code, report_prefix, created_at, updated_at
    ) VALUES (
      'profile-1', 'Legacy Field Services', 'Benjamin', 'UG', 'UGX',
      'en_UG', 'FP', 0, 0
    );
  ''');
  legacy.execute('''
    INSERT INTO app_settings_entries (
      id, theme_mode, default_report_type, default_pdf_template,
      has_completed_onboarding, created_at, updated_at
    ) VALUES ('settings', 'system', 'service', 'classic', 1, 0, 0);
  ''');
  legacy.execute('PRAGMA user_version = 2;');
  legacy.close();
}
