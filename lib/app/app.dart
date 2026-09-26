import 'package:fieldproof_360/app/branding/brand.dart';
import 'package:fieldproof_360/app/router/app_router.dart';
import 'package:fieldproof_360/app/theme/app_theme.dart';
import 'package:fieldproof_360/features/settings/presentation/view_models/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldProofApp extends ConsumerWidget {
  const FieldProofApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = switch (ref.watch(themeModeControllerProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };

    return MaterialApp.router(
      title: Brand.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
