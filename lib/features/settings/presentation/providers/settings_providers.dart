import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:fieldproof_360/features/settings/domain/models/app_settings.dart';
import 'package:fieldproof_360/features/settings/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    DriftSettingsRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
Future<AppSettings> appSettings(Ref ref) =>
    ref.watch(settingsRepositoryProvider).getSettings();
