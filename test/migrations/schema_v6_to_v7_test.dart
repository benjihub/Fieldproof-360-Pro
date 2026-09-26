import 'dart:io';

import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migrates schema 6 to 7 and preserves existing data', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fieldproof-v6-migration-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/fieldproof.sqlite');
    _createVersionSixDatabase(file);

    final database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);

    expect(await database.verifyConnection(), isTrue);
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.read<int>('user_version'), 7);
    expect(
      (await database.select(database.reports).getSingle()).title,
      'Existing report',
    );
    expect(
      (await database.select(database.reportMaterials).getSingle()).name,
      'Cable',
    );

    final objects = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE name IN ("
          "'usage_counters', 'usage_counters_year_month_idx') ORDER BY name",
        )
        .get();
    expect(objects.map((row) => row.read<String>('name')), [
      'usage_counters',
      'usage_counters_year_month_idx',
    ]);
  });
}

void _createVersionSixDatabase(File file) {
  final db = sqlite3.open(file.path);
  db.execute('''
    PRAGMA foreign_keys = ON;
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
      has_completed_onboarding INTEGER NOT NULL DEFAULT 0 CHECK (has_completed_onboarding IN (0, 1)),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    );
    CREATE TABLE customers (
      id TEXT NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      company_name TEXT NULL,
      phone TEXT NULL,
      email TEXT NULL,
      address TEXT NULL,
      notes TEXT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      archived_at INTEGER NULL
    );
    CREATE TABLE reports (
      id TEXT NOT NULL PRIMARY KEY,
      report_number TEXT NULL,
      customer_id TEXT NULL REFERENCES customers(id) ON DELETE SET NULL,
      report_type TEXT NOT NULL DEFAULT 'service',
      status TEXT NOT NULL DEFAULT 'draft',
      title TEXT NOT NULL DEFAULT '',
      site_address TEXT NULL,
      equipment_name TEXT NULL,
      equipment_manufacturer TEXT NULL,
      equipment_model TEXT NULL,
      equipment_serial TEXT NULL,
      issue_reported TEXT NULL,
      diagnosis TEXT NULL,
      work_performed TEXT NOT NULL DEFAULT '',
      recommendations TEXT NULL,
      internal_notes TEXT NULL,
      started_at INTEGER NULL,
      completed_at INTEGER NULL,
      finalized_at INTEGER NULL,
      finalized_snapshot_json TEXT NULL,
      pdf_template_id TEXT NOT NULL DEFAULT 'classic',
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      archived_at INTEGER NULL
    );
    CREATE TABLE report_photos (
      id TEXT NOT NULL PRIMARY KEY,
      report_id TEXT NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
      file_path TEXT NOT NULL,
      thumbnail_path TEXT NULL,
      category TEXT NOT NULL,
      caption TEXT NULL,
      sort_order INTEGER NOT NULL,
      created_at INTEGER NOT NULL
    );
    CREATE TABLE report_materials (
      id TEXT NOT NULL PRIMARY KEY,
      report_id TEXT NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
      name TEXT NOT NULL,
      quantity REAL NOT NULL,
      unit TEXT NULL,
      notes TEXT NULL,
      sort_order INTEGER NOT NULL
    );
    CREATE TABLE report_signatures (
      id TEXT NOT NULL PRIMARY KEY,
      report_id TEXT NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
      signature_type TEXT NOT NULL,
      signer_name TEXT NOT NULL,
      file_path TEXT NOT NULL,
      signed_at INTEGER NOT NULL
    );
    CREATE UNIQUE INDEX reports_report_number_idx ON reports(report_number);
    CREATE UNIQUE INDEX report_signatures_report_type_idx
      ON report_signatures(report_id, signature_type);
    INSERT INTO reports (
      id, report_type, status, title, work_performed, pdf_template_id,
      created_at, updated_at
    ) VALUES (
      'report-1', 'service', 'draft', 'Existing report', 'Existing work',
      'classic', 0, 0
    );
    INSERT INTO report_materials (
      id, report_id, name, quantity, sort_order
    ) VALUES ('material-1', 'report-1', 'Cable', 2, 0);
    PRAGMA user_version = 6;
  ''');
  db.close();
}
