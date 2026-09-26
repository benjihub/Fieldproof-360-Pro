import 'dart:io';

import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migrates schema 4 through 7 without losing reports', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fieldproof-v4-migration-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/fieldproof.sqlite');
    _createVersionFourDatabase(file);

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

    final objects = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE name IN ("
          "'report_photos', 'report_photos_report_id_idx', "
          "'report_photos_report_category_order_idx') ORDER BY name",
        )
        .get();
    expect(objects.map((row) => row.read<String>('name')), [
      'report_photos',
      'report_photos_report_category_order_idx',
      'report_photos_report_id_idx',
    ]);
  });
}

void _createVersionFourDatabase(File file) {
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
    CREATE INDEX reports_status_idx ON reports(status);
    CREATE INDEX reports_customer_id_idx ON reports(customer_id);
    CREATE INDEX reports_updated_at_idx ON reports(updated_at);
    CREATE UNIQUE INDEX reports_report_number_idx ON reports(report_number);
    INSERT INTO database_metadata ("key", value, updated_at) VALUES ('foundation_version', '4', 0);
    INSERT INTO reports (
      id, report_type, status, title, work_performed, pdf_template_id, created_at, updated_at
    ) VALUES ('report-1', 'service', 'draft', 'Existing report', '', 'classic', 0, 0);
    PRAGMA user_version = 4;
  ''');
  db.close();
}
