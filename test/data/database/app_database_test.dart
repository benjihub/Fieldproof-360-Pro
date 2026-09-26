import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('opens schema version 7 and executes a SQLite query', () async {
    expect(database.schemaVersion, 7);
    expect(await database.verifyConnection(), isTrue);
  });

  test('persists and reads typed database metadata', () async {
    await database
        .into(database.databaseMetadata)
        .insert(
          DatabaseMetadataCompanion.insert(
            key: 'foundation_version',
            value: const Value('1'),
          ),
        );

    final metadata = await database
        .select(database.databaseMetadata)
        .getSingle();

    expect(metadata.key, 'foundation_version');
    expect(metadata.value, '1');
  });

  test('enables SQLite foreign key enforcement', () async {
    await database.verifyConnection();
    final row = await database.customSelect('PRAGMA foreign_keys').getSingle();

    expect(row.read<int>('foreign_keys'), 1);
  });
}
