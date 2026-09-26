import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/app/router/app_router.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';
import '../../helpers/widget_test_harness.dart';

void main() {
  testAppWidgets('report editor opens materials and can add a material', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final report = await DriftReportRepository(
      database,
    ).createDraft(title: 'Pump service');
    final router = createAppRouter(
      gate: AppGate.home,
      initialLocation: '/reports/${report.id}/edit',
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

    await scrollUntilBuilt(
      tester,
      target: find.byKey(const Key('manageReportMaterialsAction')),
      scrollView: find.byKey(const Key('reportEditorList')),
    );
    await tester.tap(find.byKey(const Key('manageReportMaterialsAction')));
    await tester.pumpAndSettle();
    expect(find.text('Materials Used'), findsOneWidget);
    expect(find.text('No materials yet'), findsOneWidget);

    await tester.tap(find.byKey(const Key('addReportMaterialAction')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('materialNameField')),
      'Fuel filter',
    );
    await tester.enterText(find.byKey(const Key('materialQuantityField')), '2');
    await tester.tap(find.byKey(const Key('saveMaterialAction')));
    await tester.pumpAndSettle();

    expect(find.text('Fuel filter'), findsOneWidget);
    expect(await database.select(database.reportMaterials).get(), hasLength(1));
  });

  testAppWidgets('report editor opens signatures screen with both signers', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final report = await DriftReportRepository(
      database,
    ).createDraft(title: 'Inspection');
    final router = createAppRouter(
      gate: AppGate.home,
      initialLocation: '/reports/${report.id}/edit',
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

    await scrollUntilBuilt(
      tester,
      target: find.byKey(const Key('manageReportSignaturesAction')),
      scrollView: find.byKey(const Key('reportEditorList')),
    );
    await tester.tap(find.byKey(const Key('manageReportSignaturesAction')));
    await tester.pumpAndSettle();

    expect(find.text('Signatures'), findsOneWidget);
    expect(find.text('Technician signature'), findsOneWidget);
    expect(find.text('Customer signature'), findsOneWidget);
    expect(
      find.byKey(const Key('capturetechnicianSignatureAction')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('capturecustomerSignatureAction')),
      findsOneWidget,
    );
  });
}
