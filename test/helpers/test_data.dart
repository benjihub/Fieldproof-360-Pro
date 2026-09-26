import 'package:drift/native.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/business/data/repositories/drift_business_repository.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/onboarding/data/repositories/drift_onboarding_repository.dart';
import 'package:fieldproof_360/features/settings/data/repositories/drift_settings_repository.dart';

AppDatabase createTestDatabase() => AppDatabase(NativeDatabase.memory());

BusinessProfile createTestProfile({
  String id = 'profile-1',
  String businessName = 'Ben Electrical Services',
  String technicianName = 'Benjamin',
  String countryCode = 'UG',
  String currencyCode = 'UGX',
  String localeCode = 'en_UG',
}) {
  final createdAt = DateTime.utc(2026, 9, 23, 10);
  return BusinessProfile(
    id: id,
    businessName: businessName,
    technicianName: technicianName,
    email: 'ben@example.com',
    phone: '+256 700 000000',
    address: 'Kampala',
    countryCode: countryCode,
    currencyCode: currencyCode,
    localeCode: localeCode,
    reportPrefix: 'BEN',
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

Future<void> seedOnboardedUser(
  AppDatabase database, {
  BusinessProfile? profile,
}) async {
  final business = DriftBusinessRepository(database);
  final settings = DriftSettingsRepository(database);
  await DriftOnboardingRepository(
    database,
    business,
    settings,
  ).completeOnboarding(profile ?? createTestProfile());
}
