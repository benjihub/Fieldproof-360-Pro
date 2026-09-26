import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/settings/domain/models/app_settings.dart';

extension AppSettingsEntityMapper on AppSettingsEntity {
  AppSettings toDomain() => AppSettings(
    id: id,
    themeMode: AppThemePreference.values.firstWhere(
      (mode) => mode.name == themeMode,
      orElse: () => AppThemePreference.system,
    ),
    defaultReportType: defaultReportType,
    defaultPdfTemplate: defaultPdfTemplate,
    hasCompletedOnboarding: hasCompletedOnboarding,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}
