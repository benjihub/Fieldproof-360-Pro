import 'package:fieldproof_360/app/branding/app_logo.dart';
import 'package:fieldproof_360/app/branding/brand.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({this.hasError = false, super.key});

  final bool hasError;

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return Scaffold(
        backgroundColor: Brand.launchBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  AppLogoIcon(size: 96),
                  SizedBox(height: AppSpacing.large),
                  Text(
                    Brand.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.medium),
                  Icon(Icons.error_outline, color: Colors.white, size: 44),
                  SizedBox(height: AppSpacing.medium),
                  Text(
                    'FieldProof 360 Pro could not load your local settings. Please restart the app and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Brand.launchBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                final iconScale = 0.96 + (0.04 * (0.5 - (t - 0.5).abs()) * 2);
                final ringScale = 1.0 + (t * 0.18);
                final ringOpacity = 0.24 * (1 - t);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 212,
                      height: 212,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: ringScale,
                            child: Opacity(
                              opacity: ringOpacity,
                              child: Container(
                                width: 196,
                                height: 196,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 176,
                            height: 176,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.10),
                            ),
                          ),
                          Transform.scale(
                            scale: iconScale,
                            child: const AppLogoIcon(size: 148),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    const Text(
                      Brand.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      Brand.tagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xLarge),
                    SizedBox(
                      width: 220,
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(999),
                        backgroundColor: Colors.white.withValues(alpha: 0.16),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        value: 0.18 + (0.64 * t),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      'Preparing your workspace…',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 15,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
