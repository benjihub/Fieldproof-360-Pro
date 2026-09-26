import 'dart:io';

import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/customers/data/repositories/drift_customer_repository.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  test('creates, reads, updates, archives, and restores a customer', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final repository = DriftCustomerRepository(database);

    final created = await repository.createCustomer(
      const CustomerFormData(
        name: '  Amina Okello  ',
        companyName: '  Field Services  ',
        phone: '   ',
      ),
    );
    expect(created.name, 'Amina Okello');
    expect(created.companyName, 'Field Services');
    expect(created.phone, isNull);
    expect((await repository.getCustomer(created.id))?.name, 'Amina Okello');

    final updated = await repository.updateCustomer(
      created.id,
      const CustomerFormData(
        name: 'Amina N. Okello',
        email: 'amina@example.com',
      ),
    );
    expect(updated.id, created.id);
    expect(updated.createdAt, created.createdAt);
    expect(updated.email, 'amina@example.com');

    await repository.archiveCustomer(created.id);
    expect(await repository.getCustomers(), isEmpty);
    expect((await repository.getCustomer(created.id))?.isArchived, isTrue);

    await repository.restoreCustomer(created.id);
    expect((await repository.getCustomers()).single.id, created.id);
    expect((await repository.getCustomer(created.id))?.isArchived, isFalse);
  });

  test(
    'lists alphabetically, searches in SQL, and excludes archived rows',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final repository = DriftCustomerRepository(database);

      final zuri = await repository.createCustomer(
        const CustomerFormData(
          name: 'Zuri N.',
          companyName: 'Lake Solar',
          phone: '+256 700 100 100',
        ),
      );
      await repository.createCustomer(
        const CustomerFormData(
          name: 'amina okello',
          companyName: 'Kampala Clinic',
        ),
      );

      expect(
        (await repository.getCustomers()).map((customer) => customer.name),
        ['amina okello', 'Zuri N.'],
      );
      expect(
        (await repository.getCustomers(search: 'LAKE')).single.id,
        zuri.id,
      );
      expect(
        (await repository.getCustomers(search: '700 100')).single.id,
        zuri.id,
      );

      await repository.archiveCustomer(zuri.id);
      expect(await repository.getCustomers(search: 'Lake'), isEmpty);
    },
  );

  test(
    'watch streams emit create, edit, archive, and restore changes',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final repository = DriftCustomerRepository(database);
      final emissions = <List<String>>[];
      final subscription = repository
          .watchCustomers()
          .map((items) => items.map((customer) => customer.name).toList())
          .listen(emissions.add);
      addTearDown(subscription.cancel);

      await Future<void>.delayed(Duration.zero);
      final created = await repository.createCustomer(
        const CustomerFormData(name: 'Original Name'),
      );
      await repository.updateCustomer(
        created.id,
        const CustomerFormData(name: 'Updated Name'),
      );
      await repository.archiveCustomer(created.id);
      await repository.restoreCustomer(created.id);
      await Future<void>.delayed(Duration.zero);

      expect(emissions, contains(equals(['Original Name'])));
      expect(emissions, contains(equals(['Updated Name'])));
      expect(emissions, contains(isEmpty));
      expect(
        (await repository.watchCustomer(created.id).first)?.name,
        'Updated Name',
      );
    },
  );

  test('customer data survives closing and reopening the database', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fieldproof-customers-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/fieldproof.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final created = await DriftCustomerRepository(
      firstDatabase,
    ).createCustomer(const CustomerFormData(name: 'Persistent Customer'));
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final restored = await DriftCustomerRepository(
      reopenedDatabase,
    ).getCustomer(created.id);

    expect(restored?.name, 'Persistent Customer');
  });
}
