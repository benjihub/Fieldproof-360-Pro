import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';
import '../helpers/widget_test_harness.dart';

void main() {
  testAppWidgets('compact layout uses bottom navigation', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 840));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const FieldProofApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testAppWidgets('wide layout uses navigation rail', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const FieldProofApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testAppWidgets('welcome screen communicates the core workflow', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const FieldProofApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Professional service reports from your phone.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('before, during and after photos'),
      findsOneWidget,
    );
    expect(find.textContaining('professional PDF'), findsOneWidget);
    expect(find.text('No account required'), findsOneWidget);
  });
}
