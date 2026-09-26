import 'package:fieldproof_360/app/app.dart';
import 'package:fieldproof_360/app/config/app_config.dart';
import 'package:fieldproof_360/core/errors/app_error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void bootstrap({AppConfig? config}) {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppErrorReporter.report(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    AppErrorReporter.report(error, stackTrace);
    return true;
  };

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          config ?? AppConfig.fromEnvironment(),
        ),
      ],
      child: const FieldProofApp(),
    ),
  );
}
