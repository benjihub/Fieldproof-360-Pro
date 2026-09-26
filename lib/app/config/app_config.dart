import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

enum AppEnvironment { development, production }

final class AppConfig {
  const AppConfig({
    required this.environment,
    this.revenueCatAppleKey = '',
    this.revenueCatGoogleKey = '',
  });

  factory AppConfig.fromEnvironment() {
    const environmentName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );

    return AppConfig(
      environment: environmentName == 'production'
          ? AppEnvironment.production
          : AppEnvironment.development,
      revenueCatAppleKey: const String.fromEnvironment('REVENUECAT_APPLE_KEY'),
      revenueCatGoogleKey: const String.fromEnvironment(
        'REVENUECAT_GOOGLE_KEY',
      ),
    );
  }

  final AppEnvironment environment;
  final String revenueCatAppleKey;
  final String revenueCatGoogleKey;

  bool get isProduction => environment == AppEnvironment.production;
}

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => AppConfig.fromEnvironment();
