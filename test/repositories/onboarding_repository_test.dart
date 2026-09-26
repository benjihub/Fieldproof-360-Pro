import 'package:fieldproof_360/features/business/data/repositories/drift_business_repository.dart';
import 'package:fieldproof_360/features/onboarding/data/repositories/drift_onboarding_repository.dart';
import 'package:fieldproof_360/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  test('persists the profile before completing onboarding', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final business = DriftBusinessRepository(database);
    final settings = DriftSettingsRepository(database);
    final onboarding = DriftOnboardingRepository(database, business, settings);

    await onboarding.completeOnboarding(createTestProfile());

    expect(await business.hasBusinessProfile(), isTrue);
    expect((await settings.getSettings()).hasCompletedOnboarding, isTrue);
  });
}
