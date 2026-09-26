enum AppThemePreference { system, light, dark }

final class AppSettings {
  const AppSettings({
    required this.id,
    required this.themeMode,
    required this.defaultReportType,
    required this.defaultPdfTemplate,
    required this.hasCompletedOnboarding,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final AppThemePreference themeMode;
  final String defaultReportType;
  final String defaultPdfTemplate;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;
  final DateTime updatedAt;
}
