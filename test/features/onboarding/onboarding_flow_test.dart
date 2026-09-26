import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/business/data/repositories/drift_business_repository.dart';
import 'package:fieldproof_360/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';
import '../../helpers/widget_test_harness.dart';

void main() {
  testAppWidgets('required validation prevents incomplete onboarding', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await _pumpFreshApp(tester, database);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('businessProfileSubmit')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('businessProfileSubmit')));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.byKey(const Key('businessNameField')),
      -300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Enter your business or trading name.'), findsOneWidget);
    expect(find.text('Enter your name.'), findsOneWidget);
    expect(
      (await DriftSettingsRepository(
        database,
      ).getSettings()).hasCompletedOnboarding,
      isFalse,
    );
  });

  testAppWidgets('valid onboarding persists profile and opens Home', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await _pumpFreshApp(tester, database);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('businessNameField')),
      'Kampala Field Services',
    );
    await tester.enterText(
      find.byKey(const Key('technicianNameField')),
      'Benjamin',
    );
    await tester.tap(find.byKey(const Key('countryField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Uganda').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('businessProfileSubmit')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('businessProfileSubmit')));
    await pumpUntilFound(tester, find.text('Kampala Field Services'));

    expect(find.text('Kampala Field Services'), findsOneWidget);
    final profile = await DriftBusinessRepository(
      database,
    ).getBusinessProfile();
    expect(profile?.countryCode, 'UG');
    expect(profile?.currencyCode, 'UGX');
    expect(profile?.localeCode, 'en_UG');
    expect(
      (await DriftSettingsRepository(
        database,
      ).getSettings()).hasCompletedOnboarding,
      isTrue,
    );
  });
}

Future<void> _pumpFreshApp(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
      child: const FieldProofApp(),
    ),
  );
  await tester.pumpAndSettle();
}
