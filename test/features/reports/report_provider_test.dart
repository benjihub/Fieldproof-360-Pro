import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';

void main() {
  test('report repository provider uses the shared database dependency', () {
    final database = createTestDatabase();
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);

    expect(
      container.read(reportRepositoryProvider),
      isA<DriftReportRepository>(),
    );
  });
}
