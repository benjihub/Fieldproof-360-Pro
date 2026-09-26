import 'dart:io';

import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/reports/data/mappers/report_mapper.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';

void main() {
  test('reports table exists and stores an incomplete draft', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final timestamp = DateTime.utc(2026, 9, 24, 9);

    final tables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'reports'",
        )
        .get();
    expect(tables.single.read<String>('name'), 'reports');

    final draft = Report.draft(id: 'report-1', createdAt: timestamp);
    await database.into(database.reports).insert(draft.toCompanion());
    final stored = (await database.select(database.reports).getSingle())
        .toDomain();

    expect(stored.reportNumber, isNull);
    expect(stored.customerId, isNull);
    expect(stored.workPerformed, isEmpty);
    expect(stored.finalizedSnapshotJson, isNull);
    expect(stored.isDraft, isTrue);
  });

  test(
    'report may reference a customer without altering the customer',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final timestamp = DateTime.utc(2026, 9, 24, 9);
      await database
          .into(database.customers)
          .insert(
            CustomersCompanion.insert(
              id: 'customer-1',
              name: 'Amina Okello',
              createdAt: timestamp,
              updatedAt: timestamp,
            ),
          );

      final report = Report.draft(
        id: 'report-1',
        customerId: 'customer-1',
        reportType: ReportType.maintenance,
        title: 'Pump maintenance',
        createdAt: timestamp,
      );
      await database.into(database.reports).insert(report.toCompanion());

      final storedReport = await database.select(database.reports).getSingle();
      final storedCustomer = await database
          .select(database.customers)
          .getSingle();
      expect(storedReport.customerId, 'customer-1');
      expect(storedCustomer.name, 'Amina Okello');
      expect(storedCustomer.archivedAt, isNull);
    },
  );

  test(
    'deleting a customer sets the reference to null without deleting report',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final timestamp = DateTime.utc(2026, 9, 24, 9);
      await database
          .into(database.customers)
          .insert(
            CustomersCompanion.insert(
              id: 'customer-1',
              name: 'Amina Okello',
              createdAt: timestamp,
              updatedAt: timestamp,
            ),
          );
      await database
          .into(database.reports)
          .insert(
            Report.draft(
              id: 'report-1',
              customerId: 'customer-1',
              createdAt: timestamp,
            ).toCompanion(),
          );

      await (database.delete(
        database.customers,
      )..where((customer) => customer.id.equals('customer-1'))).go();

      final reports = await database.select(database.reports).get();
      expect(reports, hasLength(1));
      expect(reports.single.customerId, isNull);
    },
  );

  test('report data persists after the database reopens', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fieldproof-reports-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/fieldproof.sqlite');
    final timestamp = DateTime.utc(2026, 9, 24, 9);

    final firstDatabase = AppDatabase(NativeDatabase(file));
    await firstDatabase
        .into(firstDatabase.reports)
        .insert(
          Report.draft(
            id: 'persistent-report',
            title: 'Persistent draft',
            workPerformed: 'Draft notes',
            createdAt: timestamp,
          ).toCompanion(),
        );
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final restored =
        (await reopenedDatabase.select(reopenedDatabase.reports).getSingle())
            .toDomain();

    expect(restored.id, 'persistent-report');
    expect(restored.title, 'Persistent draft');
    expect(restored.workPerformed, 'Draft notes');
  });
}
