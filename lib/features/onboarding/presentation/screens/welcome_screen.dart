import 'package:fieldproof_360/app/branding/app_logo.dart';
import 'package:fieldproof_360/app/branding/brand.dart';
import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const AppLogoIcon(size: 120),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Text(
                    Brand.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    Brand.tagline,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'Professional service reports from your phone.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.large),
                  const _Benefit(
                    icon: Icons.photo_camera_outlined,
                    text:
                        'Capture work evidence with before, during and after photos.',
                  ),
                  const _Benefit(
                    icon: Icons.draw_outlined,
                    text: 'Collect technician and customer signatures on-site.',
                  ),
                  const _Benefit(
                    icon: Icons.picture_as_pdf_outlined,
                    text: 'Create a professional PDF and share it in seconds.',
                  ),
                  const SizedBox(height: AppSpacing.xLarge),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.go(RoutePaths.businessSetup),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Get Started'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xSmall),
                      Text(
                        'No account required',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.medium),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.medium),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
