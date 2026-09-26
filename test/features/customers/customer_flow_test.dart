import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/app/router/app_router.dart';
import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/customers/data/repositories/drift_customer_repository.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/test_data.dart';

void main() {
  testWidgets('empty state and Add Customer flow validate and persist', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final router = await _pumpCustomersApp(tester, database);

    expect(find.text('No customers yet'), findsOneWidget);
    await tester.tap(find.byKey(const Key('addCustomerAction')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('customerSubmit')));
    await tester.tap(find.byKey(const Key('customerSubmit')));
    await tester.pump();
    expect(find.text('Enter the customer name.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('customerNameField')),
      'Amina Okello',
    );
    await tester.enterText(
      find.byKey(const Key('customerCompanyField')),
      'Kampala Clinic',
    );
    await tester.enterText(
      find.byKey(const Key('customerPhoneField')),
      '+256 700 123456',
    );
    await tester.ensureVisible(find.byKey(const Key('customerSubmit')));
    await tester.tap(find.byKey(const Key('customerSubmit')));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, startsWith('/customers/'));
    expect(find.text('Amina Okello'), findsOneWidget);
    expect(find.text('Kampala Clinic'), findsOneWidget);

    router.go(RoutePaths.customers);
    await tester.pumpAndSettle();
    expect(find.text('Amina Okello'), findsOneWidget);
  });

  testWidgets('search displays matches and a clearable no-results state', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final repository = DriftCustomerRepository(database);
    await repository.createCustomer(
      const CustomerFormData(name: 'Amina Okello', companyName: 'Lake Solar'),
    );
    await repository.createCustomer(
      const CustomerFormData(name: 'Brian Kato', phone: '+256 701 999999'),
    );
    await _pumpCustomersApp(tester, database);

    await tester.enterText(
      find.byKey(const Key('customerSearchField')),
      'lake',
    );
    await tester.pumpAndSettle();
    expect(find.text('Amina Okello'), findsOneWidget);
    expect(find.text('Brian Kato'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('customerSearchField')),
      'missing',
    );
    await tester.pumpAndSettle();
    expect(find.text('No matching customers'), findsOneWidget);

    await tester.tap(find.byKey(const Key('clearCustomerSearch')));
    await tester.pumpAndSettle();
    expect(find.text('Amina Okello'), findsOneWidget);
    expect(find.text('Brian Kato'), findsOneWidget);
  });

  testWidgets('details support editing and archive confirmation', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final repository = DriftCustomerRepository(database);
    await repository.createCustomer(
      const CustomerFormData(
        name: 'Amina Okello',
        email: 'amina@example.com',
        address: 'Kampala',
        notes: 'Site contact',
      ),
    );
    await _pumpCustomersApp(tester, database);

    await tester.tap(find.text('Amina Okello'));
    await tester.pumpAndSettle();
    expect(find.text('amina@example.com'), findsOneWidget);
    expect(find.text('Kampala'), findsOneWidget);
    expect(find.text('Site contact'), findsOneWidget);
    expect(find.byKey(const Key('newReportForCustomerAction')), findsOneWidget);

    await tester.tap(find.byKey(const Key('editCustomerAction')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('customerNameField')),
      'Amina N. Okello',
    );
    await tester.ensureVisible(find.byKey(const Key('customerSubmit')));
    await tester.tap(find.byKey(const Key('customerSubmit')));
    await tester.pumpAndSettle();
    expect(find.text('Amina N. Okello'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('archiveCustomerAction')));
    await tester.drag(find.byType(ListView).last, const Offset(0, -80));
    await tester.pump();
    await tester.tap(find.byKey(const Key('archiveCustomerAction')));
    await tester.pumpAndSettle();
    expect(find.text('Archive customer?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('confirmArchiveCustomer')));
    await tester.pumpAndSettle();

    expect(find.text('No customers yet'), findsOneWidget);
    expect(await repository.getCustomers(), isEmpty);
  });
}

Future<GoRouter> _pumpCustomersApp(
  WidgetTester tester,
  AppDatabase database,
) async {
  await seedOnboardedUser(database);
  final router = createAppRouter(
    gate: AppGate.home,
    initialLocation: RoutePaths.customers,
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        appRouterProvider.overrideWithValue(router),
      ],
      child: const FieldProofApp(),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}
