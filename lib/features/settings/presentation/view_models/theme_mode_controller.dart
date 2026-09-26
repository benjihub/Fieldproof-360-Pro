import 'dart:async';

import 'package:fieldproof_360/features/settings/domain/models/app_settings.dart';
import 'package:fieldproof_360/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  Future<ThemeMode> build() async {
    final settings = await ref.watch(settingsRepositoryProvider).getSettings();
    return settings.themeMode.flutterThemeMode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(settingsRepositoryProvider).setThemeMode(mode.preference);
      ref.invalidate(appSettingsProvider);
      return mode;
    });
  }
}

extension on AppThemePreference {
  ThemeMode get flutterThemeMode => switch (this) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
}

extension on ThemeMode {
  AppThemePreference get preference => switch (this) {
    ThemeMode.system => AppThemePreference.system,
    ThemeMode.light => AppThemePreference.light,
    ThemeMode.dark => AppThemePreference.dark,
  };
}
