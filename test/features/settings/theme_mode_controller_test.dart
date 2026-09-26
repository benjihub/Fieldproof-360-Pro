import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/settings/presentation/view_models/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';

void main() {
  test(
    'theme defaults to system and survives a new provider container',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      final first = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      expect(
        await first.read(themeModeControllerProvider.future),
        ThemeMode.system,
      );
      await first
          .read(themeModeControllerProvider.notifier)
          .setThemeMode(ThemeMode.dark);
      expect(
        await first.read(themeModeControllerProvider.future),
        ThemeMode.dark,
      );
      first.dispose();

      final restored = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(restored.dispose);
      expect(
        await restored.read(themeModeControllerProvider.future),
        ThemeMode.dark,
      );
    },
  );
}
