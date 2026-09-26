import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/business/data/repositories/drift_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';
import '../../helpers/widget_test_harness.dart';

void main() {
  testAppWidgets('settings displays and persists business profile edits', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    await _pumpApp(tester, database);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Ben Electrical Services\nBenjamin'), findsOneWidget);

    await tester.tap(find.text('Business Profile'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('businessNameField')),
      'BenatTech Services',
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('businessProfileSubmit')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('businessProfileSubmit')));
    await tester.pumpAndSettle();

    expect(find.text('Business profile saved.'), findsOneWidget);
    expect(
      (await DriftBusinessRepository(
        database,
      ).getBusinessProfile())?.businessName,
      'BenatTech Services',
    );
  });

  testAppWidgets('theme selection updates the application theme', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    await _pumpApp(tester, database);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });
}

Future<void> _pumpApp(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
      child: const FieldProofApp(),
    ),
  );
  await tester.pumpAndSettle();
}
