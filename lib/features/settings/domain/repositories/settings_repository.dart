import 'package:fieldproof_360/features/settings/domain/models/app_settings.dart';

abstract interface class SettingsRepository {
  Stream<AppSettings> watchSettings();

  Future<AppSettings> getSettings();

  Future<void> setThemeMode(AppThemePreference mode);

  Future<void> setOnboardingCompleted(bool value);
}
