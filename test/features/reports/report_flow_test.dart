import 'dart:async';

import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/app/router/app_router.dart';
import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/customers/data/repositories/drift_customer_repository.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_draft_data.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';
import 'package:fieldproof_360/features/reports/domain/services/report_finalization_validator.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_repository.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/new_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/test_data.dart';

void main() {
  _testWidgets('Reports shows an empty state and opens New Report', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: RoutePaths.reports,
    );

    expect(find.text('No reports yet'), findsOneWidget);
    expect(
      find.text(
        'Create your first service report to start documenting your work.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('emptyNewReportAction')));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, RoutePaths.reportNew);
  });

  _testWidgets('report list shows fallback, type, status, and customer name', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final customer = await DriftCustomerRepository(
      database,
    ).createCustomer(const CustomerFormData(name: 'Amina Okello'));
    final report = await DriftReportRepository(
      database,
    ).createDraft(customerId: customer.id, reportType: ReportType.maintenance);
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: RoutePaths.reports,
    );

    expect(find.text('Untitled Report'), findsOneWidget);
    expect(
      find.text('Amina Okello\nMaintenance · Draft\n', findRichText: true),
      findsNothing,
    );
    expect(find.textContaining('Amina Okello'), findsOneWidget);
    expect(find.textContaining('Maintenance · Draft'), findsOneWidget);

    await tester.tap(find.text('Untitled Report'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/reports/${report.id}');
    expect(find.text('Report Details'), findsOneWidget);
    expect(find.text('Untitled Report'), findsOneWidget);
  });

  _testWidgets('creates a default untitled draft without a customer', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: RoutePaths.reportNew,
    );

    expect(find.text('Service'), findsOneWidget);
    expect(find.text('No customer'), findsOneWidget);
    await tester.tap(find.byKey(const Key('createDraftAction')));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, startsWith('/reports/'));
    expect(router.state.uri.path, isNot(RoutePaths.reportNew));
    expect(router.state.uri.path, endsWith('/edit'));
    expect(find.text('Edit Report'), findsOneWidget);
    final reportId = router.state.pathParameters['reportId']!;
    final report = await DriftReportRepository(database).getReport(reportId);
    expect(report?.customerId, isNull);
    expect(report?.reportType, ReportType.service);
    expect(report?.title, isEmpty);
  });

  _testWidgets('stores selected customer, report type, and title', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final customer = await DriftCustomerRepository(database).createCustomer(
      const CustomerFormData(name: 'Amina Okello', companyName: 'Lake Solar'),
    );
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: RoutePaths.reportNew,
    );

    await tester.tap(find.byKey(const Key('reportCustomerField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Amina Okello — Lake Solar').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reportTypeField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inspection').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('reportTitleField')),
      'Kitchen socket repair',
    );
    await tester.tap(find.byKey(const Key('createDraftAction')));
    await tester.pumpAndSettle();

    final reportId = router.state.pathParameters['reportId']!;
    final report = await DriftReportRepository(database).getReport(reportId);
    expect(report?.customerId, customer.id);
    expect(report?.reportType, ReportType.inspection);
    expect(report?.title, 'Kitchen socket repair');
    expect(find.text('Kitchen socket repair'), findsWidgets);
    expect(find.textContaining('Amina Okello'), findsWidgets);
  });

  _testWidgets('Home and Customer Detail open report creation', (tester) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final customer = await DriftCustomerRepository(
      database,
    ).createCustomer(const CustomerFormData(name: 'Amina Okello'));
    final router = await _pumpApp(tester, database);

    await tester.tap(find.byKey(const Key('homeNewReportAction')));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, RoutePaths.reportNew);

    router.go('/customers/${customer.id}');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('newReportForCustomerAction')));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, RoutePaths.reportNew);
    expect(router.state.uri.queryParameters['customerId'], customer.id);
    expect(find.text('Amina Okello'), findsOneWidget);
  });

  _testWidgets('detail handles missing reports and omits absent sections', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final repository = DriftReportRepository(database);
    final report = await repository.createDraft(title: 'Simple visit');
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: '/reports/${report.id}',
    );

    expect(find.text('Simple visit'), findsOneWidget);
    expect(find.text('Report type'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Site address'), findsNothing);
    expect(find.text('Equipment'), findsNothing);
    expect(find.text('Issue reported'), findsNothing);
    expect(find.text('Work performed'), findsNothing);
    expect(find.text('Edit Report'), findsOneWidget);

    router.go('/reports/missing');
    await tester.pumpAndSettle();
    expect(find.text('Report not found.'), findsOneWidget);
  });

  _testWidgets('draft editor autosaves report changes', (tester) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final repository = DriftReportRepository(database);
    final report = await repository.createDraft(title: 'Initial title');
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: '/reports/${report.id}',
    );

    await tester.tap(find.byKey(const Key('editReportAction')));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/reports/${report.id}/edit');

    await tester.enterText(
      find.byKey(const Key('editorTitleField')),
      'Updated service visit',
    );
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    final saved = await repository.getReport(report.id);
    expect(saved?.title, 'Updated service visit');
    expect(find.text('Saved'), findsOneWidget);
  });

  _testWidgets('leaving editor flushes pending changes before returning', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final repository = DriftReportRepository(database);
    final report = await repository.createDraft(title: 'Initial title');
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: '/reports/${report.id}/edit',
    );

    await tester.enterText(
      find.byKey(const Key('editorTitleField')),
      'Saved on exit',
    );
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/reports/${report.id}');
    expect((await repository.getReport(report.id))?.title, 'Saved on exit');
    expect(find.text('Saved on exit'), findsOneWidget);
  });

  _testWidgets('draft editor opens the photo manager', (tester) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final report = await DriftReportRepository(
      database,
    ).createDraft(title: 'Photo visit');
    final router = await _pumpApp(
      tester,
      database,
      initialLocation: '/reports/${report.id}/edit',
    );

    final managePhotos = find.byKey(const Key('manageReportPhotosAction'));
    await _scrollUntilBuilt(
      tester,
      managePhotos,
      find.byKey(const Key('reportEditorList')),
    );
    await tester.tap(managePhotos);
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/reports/${report.id}/photos');
    expect(find.text('Report Photos'), findsOneWidget);
    expect(find.text('No before photos yet'), findsOneWidget);
    expect(find.byKey(const Key('takeReportPhotoAction')), findsOneWidget);
    expect(find.byKey(const Key('chooseReportPhotosAction')), findsOneWidget);
  });

  _testWidgets('valid draft can be finalized and becomes read-only', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final repository = DriftReportRepository(database);
    final draft = await repository.createDraft(title: 'Completed service');
    await repository.updateDraft(
      draft.id,
      const ReportDraftData(
        title: 'Completed service',
        workPerformed: 'Replaced damaged socket and tested supply.',
      ),
    );
    await _pumpApp(tester, database, initialLocation: '/reports/${draft.id}');

    await tester.tap(find.byKey(const Key('finalizeReportAction')));
    await _pumpUntilFound(tester, find.text('Finalize report?'));
    expect(find.text('Finalize report?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Finalize'));
    await _pumpUntilFound(tester, find.text('BEN-2026-0001'));

    expect(find.text('BEN-2026-0001'), findsOneWidget);
    expect(find.text('Finalized'), findsWidgets);
    expect(find.byKey(const Key('editReportAction')), findsNothing);
    await _scrollUntilBuilt(
      tester,
      find.byKey(const Key('previewReportPdfAction')),
      find.byKey(const Key('reportDetailList')),
    );
    expect(find.byKey(const Key('previewReportPdfAction')), findsOneWidget);
    expect(find.byKey(const Key('shareReportPdfAction')), findsOneWidget);
    expect(find.byKey(const Key('duplicateReportAction')), findsOneWidget);
    final saved = await repository.getReport(draft.id);
    expect(saved?.isFinalized, isTrue);
    expect(saved?.finalizedSnapshotJson, isNotNull);
  });

  _testWidgets('invalid draft shows finalization validation errors', (
    tester,
  ) async {
    final database = createTestDatabase();
    addTearDown(database.close);
    await seedOnboardedUser(database);
    final draft = await DriftReportRepository(database).createDraft();
    await _pumpApp(tester, database, initialLocation: '/reports/${draft.id}');

    await tester.tap(find.byKey(const Key('finalizeReportAction')));
    await _pumpUntilFound(tester, find.text('Report is not ready'));

    expect(find.text('Report is not ready'), findsOneWidget);
    expect(find.textContaining('Report title is required.'), findsOneWidget);
    expect(find.textContaining('Work performed is required.'), findsOneWidget);
  });

  _testWidgets(
    'saving disables repeat submission and presents repository error',
    (tester) async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final repository = _DelayedFailingReportRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            reportRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(home: NewReportScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('createDraftAction')));
      await tester.pump();
      expect(repository.createCalls, 1);
      final button = tester.widget<FilledButton>(
        find.byKey(const Key('createDraftAction')),
      );
      expect(button.onPressed, isNull);

      await tester.tap(
        find.byKey(const Key('createDraftAction')),
        warnIfMissed: false,
      );
      expect(repository.createCalls, 1);
      repository.completeWithError();
      await tester.pumpAndSettle();
      expect(find.text('Draft creation failed.'), findsOneWidget);
    },
  );
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

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int attempts = 30,
}) async {
  for (var attempt = 0; attempt < attempts; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out waiting for $finder.');
}

Future<void> _scrollUntilBuilt(
  WidgetTester tester,
  Finder target,
  Finder scrollView, {
  int attempts = 12,
}) async {
  for (
    var attempt = 0;
    attempt < attempts && target.evaluate().isEmpty;
    attempt++
  ) {
    await tester.drag(scrollView, const Offset(0, -400));
    await tester.pump();
  }
  if (target.evaluate().isEmpty) {
    throw TestFailure('Timed out scrolling to $target.');
  }
  await tester.ensureVisible(target);
  await tester.pump();
}

Future<GoRouter> _pumpApp(
  WidgetTester tester,
  AppDatabase database, {
  String initialLocation = RoutePaths.home,
}) async {
  await seedOnboardedUser(database);
  final router = createAppRouter(
    gate: AppGate.home,
    initialLocation: initialLocation,
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

final class _DelayedFailingReportRepository implements ReportRepository {
  final _createCompleter = Completer<Report>();
  int createCalls = 0;

  void completeWithError() {
    _createCompleter.completeError(
      const DatabaseException('Draft creation failed.'),
    );
  }

  @override
  Future<Report> createDraft({
    String? customerId,
    ReportType reportType = ReportType.service,
    String? title,
  }) {
    createCalls++;
    return _createCompleter.future;
  }

  @override
  Stream<List<Report>> watchReports() => const Stream.empty();

  @override
  Stream<Report?> watchReport(String id) => const Stream.empty();

  @override
  Future<Report?> getReport(String id) async => null;

  @override
  Future<Report> updateDraft(String id, ReportDraftData data) =>
      throw UnimplementedError();

  @override
  Future<ReportFinalizationValidation> validateFinalization(String id) =>
      throw UnimplementedError();

  @override
  Future<Report> finalizeReport(String id) => throw UnimplementedError();

  @override
  Future<UsageCounter> getUsageCounter({DateTime? forMonth}) =>
      throw UnimplementedError();

  @override
  Future<void> archiveReport(String id) => throw UnimplementedError();

  @override
  Future<Report> duplicateAsDraft(String id) => throw UnimplementedError();
}
