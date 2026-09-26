import 'dart:async';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile_form_data.dart';
import 'package:fieldproof_360/features/business/domain/services/business_profile_validator.dart';
import 'package:fieldproof_360/features/business/presentation/providers/business_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_profile_editor_controller.g.dart';

@riverpod
class BusinessProfileEditorController
    extends _$BusinessProfileEditorController {
  @override
  FutureOr<void> build() {}

  Future<bool> save(
    BusinessProfile current,
    BusinessProfileFormData input,
  ) async {
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
      final updated = BusinessProfile(
        id: current.id,
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
        logoPath: current.logoPath,
        taxLabel: input.taxLabel,
        taxNumber: input.taxNumber,
        reportPrefix: BusinessProfileValidator.normalizeReportPrefix(
          input.reportPrefix,
        ),
        defaultTerms: input.defaultTerms,
        createdAt: current.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
      await ref.read(businessRepositoryProvider).saveBusinessProfile(updated);
      ref.invalidate(businessProfileProvider);
    });
    return !state.hasError;
  }
}
