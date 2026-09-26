import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/app/router/app_router.dart';
import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  _testWidgets('main routes resolve inside the persistent shell', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final router = createAppRouter(gate: AppGate.home);
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
    final routes = <String, String>{
      RoutePaths.home: 'Ben Electrical Services',
      RoutePaths.reports: 'No reports yet',
      RoutePaths.customers: 'No customers yet',
      RoutePaths.settings: 'Appearance',
      RoutePaths.subscription:
          'Subscriptions are not configured in this build.',
      RoutePaths.privacyPolicy: 'Your report data stays on your device',
      RoutePaths.termsOfUse: 'Free and Pro plans',
    };

    for (final route in routes.entries) {
      router.go(route.key);
      await tester.pumpAndSettle();
      expect(find.text(route.value), findsOneWidget);
    }
  });

  _testWidgets('bottom navigation changes branches', (tester) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final router = createAppRouter(gate: AppGate.home);
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
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, RoutePaths.reports);
  });
}

void _testWidgets(String description, WidgetTesterCallback body) {
  testWidgets(description, (tester) async {
    try {
      await body(tester);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    }
  });
}
