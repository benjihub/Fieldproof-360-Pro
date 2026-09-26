import 'package:drift/drift.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/settings/data/mappers/app_settings_mapper.dart';
import 'package:fieldproof_360/features/settings/domain/models/app_settings.dart';
import 'package:fieldproof_360/features/settings/domain/repositories/settings_repository.dart';

final class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._database);

  static const settingsId = '00000000-0000-4000-8000-000000000001';

  final AppDatabase _database;

  @override
  Stream<AppSettings> watchSettings() async* {
    await _ensureSettings();
    yield* (_database.select(_database.appSettingsEntries)
          ..where((row) => row.id.equals(settingsId)))
        .watchSingle()
        .map((entity) => entity.toDomain());
  }

  @override
  Future<AppSettings> getSettings() async {
    try {
      await _ensureSettings();
      final entity = await (_database.select(
        _database.appSettingsEntries,
      )..where((row) => row.id.equals(settingsId))).getSingle();
      return entity.toDomain();
    } catch (error) {
      throw DatabaseException(
        'Could not load application settings.',
        cause: error,
      );
    }
  }

  @override
  Future<void> setThemeMode(AppThemePreference mode) async {
    await _update(
      AppSettingsEntriesCompanion(themeMode: Value(mode.name)),
      'Could not save the theme preference.',
    );
  }

  @override
  Future<void> setOnboardingCompleted(bool value) async {
    await _update(
      AppSettingsEntriesCompanion(hasCompletedOnboarding: Value(value)),
      'Could not save onboarding progress.',
    );
  }

  Future<void> _ensureSettings() async {
    final now = DateTime.now().toUtc();
    await _database
        .into(_database.appSettingsEntries)
        .insert(
          AppSettingsEntriesCompanion.insert(
            id: settingsId,
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> _update(
    AppSettingsEntriesCompanion values,
    String errorMessage,
  ) async {
    try {
      await _ensureSettings();
      await (_database.update(_database.appSettingsEntries)
            ..where((row) => row.id.equals(settingsId)))
          .write(values.copyWith(updatedAt: Value(DateTime.now().toUtc())));
    } catch (error) {
      throw DatabaseException(errorMessage, cause: error);
    }
  }
}
