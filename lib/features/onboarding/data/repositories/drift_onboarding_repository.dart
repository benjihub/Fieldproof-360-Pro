import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/business/domain/repositories/business_repository.dart';
import 'package:fieldproof_360/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fieldproof_360/features/settings/domain/repositories/settings_repository.dart';

final class DriftOnboardingRepository implements OnboardingRepository {
  const DriftOnboardingRepository(
    this._database,
    this._businessRepository,
    this._settingsRepository,
  );

  final AppDatabase _database;
  final BusinessRepository _businessRepository;
  final SettingsRepository _settingsRepository;

  @override
  Future<BusinessProfile> completeOnboarding(BusinessProfile profile) async {
    try {
      return await _database.transaction(() async {
        final savedProfile = await _businessRepository.saveBusinessProfile(
          profile,
        );
        await _settingsRepository.setOnboardingCompleted(true);
        return savedProfile;
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException('Could not complete setup.', cause: error);
    }
  }
}
