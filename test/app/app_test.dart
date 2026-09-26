import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';
import '../helpers/widget_test_harness.dart';

void main() {
  testAppWidgets('fresh application boots into onboarding', (tester) async {
    final database = createTestDatabase();
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const FieldProofApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('FieldProof 360 Pro'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('No account required'), findsOneWidget);
  });

  testAppWidgets('existing user bypasses onboarding', (tester) async {
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

    expect(find.text('Benjamin'), findsOneWidget);
    expect(find.text('Ben Electrical Services'), findsOneWidget);
    expect(find.text('Get Started'), findsNothing);
  });
}
