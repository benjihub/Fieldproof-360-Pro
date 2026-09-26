import 'dart:io';

import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migrates schema 1 through 7 without losing metadata', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fieldproof-migration-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/fieldproof.sqlite');

    final legacy = sqlite3.open(file.path);
    legacy.execute('''
      CREATE TABLE database_metadata (
        "key" TEXT NOT NULL PRIMARY KEY,
        "value" TEXT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');
    legacy.execute(
      "INSERT INTO database_metadata (\"key\", \"value\", updated_at) "
      "VALUES ('foundation_version', '1', 0);",
    );
    legacy.execute('PRAGMA user_version = 1;');
    legacy.close();

    final database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);

    expect(await database.verifyConnection(), isTrue);
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.read<int>('user_version'), 7);

    final metadata = await database
        .select(database.databaseMetadata)
        .getSingle();
    expect(metadata.value, '1');

    final tables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name IN ('business_profiles', 'app_settings_entries', "
          "'customers', 'reports', 'report_photos') "
          'ORDER BY name',
        )
        .get();
    expect(tables.map((row) => row.read<String>('name')), [
      'app_settings_entries',
      'business_profiles',
      'customers',
      'report_photos',
      'reports',
    ]);
  });
}
