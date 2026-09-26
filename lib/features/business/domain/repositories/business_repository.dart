import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';

abstract interface class BusinessRepository {
  Stream<BusinessProfile?> watchBusinessProfile();

  Future<BusinessProfile?> getBusinessProfile();

  Future<BusinessProfile> saveBusinessProfile(BusinessProfile profile);

  Future<bool> hasBusinessProfile();
}
