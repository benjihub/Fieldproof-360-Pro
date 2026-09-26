import 'package:fieldproof_360/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:fieldproof_360/features/settings/domain/models/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  test(
    'initializes defaults and persists theme and onboarding state',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final repository = DriftSettingsRepository(database);

      final defaults = await repository.getSettings();
      expect(defaults.themeMode, AppThemePreference.system);
      expect(defaults.defaultReportType, 'service');
      expect(defaults.defaultPdfTemplate, 'classic');
      expect(defaults.hasCompletedOnboarding, isFalse);

      await repository.setThemeMode(AppThemePreference.dark);
      await repository.setOnboardingCompleted(true);

      final restored = await DriftSettingsRepository(database).getSettings();
      expect(restored.themeMode, AppThemePreference.dark);
      expect(restored.hasCompletedOnboarding, isTrue);
    },
  );
}
