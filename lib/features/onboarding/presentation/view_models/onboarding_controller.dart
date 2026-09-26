import 'dart:async';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/app/router/app_router.dart';
import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile_form_data.dart';
import 'package:fieldproof_360/features/business/domain/services/business_profile_validator.dart';
import 'package:fieldproof_360/features/business/presentation/providers/business_providers.dart';
import 'package:fieldproof_360/features/onboarding/data/repositories/drift_onboarding_repository.dart';
import 'package:fieldproof_360/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fieldproof_360/features/settings/presentation/providers/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) => DriftOnboardingRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(businessRepositoryProvider),
  ref.watch(settingsRepositoryProvider),
);

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {}

  Future<bool> complete(BusinessProfileFormData input) async {
    final errors = BusinessProfileValidator.validate(input);
    if (errors.isNotEmpty) {
      state = AsyncError(
        const ValidationException('Check the highlighted fields.'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now().toUtc();
      final profile = BusinessProfile(
        id: '',
        businessName: input.businessName,
        technicianName: input.technicianName,
        email: input.email,
        phone: input.phone,
        address: input.address,
        countryCode: BusinessProfileValidator.normalizeCountryCode(
          input.countryCode,
        ),
        currencyCode: BusinessProfileValidator.normalizeCurrencyCode(
          input.currencyCode,
        ),
        localeCode: input.localeCode,
        reportPrefix: BusinessProfileValidator.normalizeReportPrefix(
          input.reportPrefix,
        ),
        createdAt: now,
        updatedAt: now,
      );
      await ref.read(onboardingRepositoryProvider).completeOnboarding(profile);
      ref.invalidate(businessProfileProvider);
      ref.invalidate(appSettingsProvider);
      ref.invalidate(appGateProvider);
    });
    return !state.hasError;
  }
}
