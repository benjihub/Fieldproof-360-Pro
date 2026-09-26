import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';

abstract interface class OnboardingRepository {
  Future<BusinessProfile> completeOnboarding(BusinessProfile profile);
}
