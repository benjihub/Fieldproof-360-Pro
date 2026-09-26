import 'package:fieldproof_360/app/branding/brand.dart';
import 'package:fieldproof_360/app/config/legal_links.dart';
import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/widgets/app_state_views.dart';
import 'package:fieldproof_360/core/widgets/responsive_content.dart';
import 'package:fieldproof_360/features/business/presentation/providers/business_providers.dart';
import 'package:fieldproof_360/features/settings/presentation/view_models/theme_mode_controller.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/providers/subscription_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider);
    final themeState = ref.watch(themeModeControllerProvider);
    final subscription = ref.watch(subscriptionStatusProvider);
    final themeMode = switch (themeState) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ResponsiveContent(
            maxWidth: 820,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSectionHeader(
                  title: 'Business',
                  subtitle: 'Details used on your professional reports.',
                ),
                const SizedBox(height: AppSpacing.small),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.business_outlined),
                    title: const Text('Business Profile'),
                    subtitle: profile.when(
                      loading: () => const Text('Loading…'),
                      error: (error, stackTrace) =>
                          const Text('Could not load profile'),
                      data: (value) => Text(
                        value == null
                            ? 'Not configured'
                            : '${value.businessName}\n${value.technicianName}',
                      ),
                    ),
                    isThreeLine: switch (profile) {
                      AsyncData(value: final value) => value != null,
                      _ => false,
                    },
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go(RoutePaths.businessProfile),
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                const AppSectionHeader(
                  title: 'Subscription',
                  subtitle: 'Manage FieldProof 360 Free and Pro access.',
                ),
                const SizedBox(height: AppSpacing.small),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.workspace_premium_outlined),
                    title: const Text('FieldProof 360 Pro'),
                    subtitle: Text(switch (subscription) {
                      AsyncData(:final value) =>
                        value.isPro
                            ? 'Pro active — unlimited reports'
                            : value.isConfigured
                            ? 'Free — 3 finalized reports per month'
                            : 'Subscriptions not configured',
                      AsyncError() => 'Could not check subscription',
                      _ => 'Checking subscription…',
                    }),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go(RoutePaths.subscription),
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                const AppSectionHeader(
                  title: 'Appearance',
                  subtitle: 'Choose how FieldProof 360 looks on this device.',
                ),
                const SizedBox(height: AppSpacing.small),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<ThemeMode>(
                            showSelectedIcon: false,
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.system,
                                icon: Icon(Icons.brightness_auto_outlined),
                                label: Text('System'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                icon: Icon(Icons.light_mode_outlined),
                                label: Text('Light'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                icon: Icon(Icons.dark_mode_outlined),
                                label: Text('Dark'),
                              ),
                            ],
                            selected: {themeMode},
                            onSelectionChanged: themeState.isLoading
                                ? null
                                : (selection) => ref
                                      .read(
                                        themeModeControllerProvider.notifier,
                                      )
                                      .setThemeMode(selection.single),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                const AppSectionHeader(
                  title: 'Help',
                  subtitle: 'Learn the report workflow and get support.',
                ),
                const SizedBox(height: AppSpacing.small),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('How FieldProof 360 Pro works'),
                        subtitle: const Text(
                          'A quick guide to the report workflow',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showHelp(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                const AppSectionHeader(
                  title: 'Legal',
                  subtitle:
                      'Read how FieldProof 360 Pro handles your data and subscriptions.',
                ),
                const SizedBox(height: AppSpacing.small),
                Card(
                  child: Column(
                    children: [
                      Link(
                        uri: LegalLinks.privacyPolicy,
                        builder: (context, followLink) => ListTile(
                          key: const Key('privacyPolicySettingsAction'),
                          leading: const Icon(Icons.privacy_tip_outlined),
                          title: const Text('Privacy Policy'),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: followLink,
                        ),
                      ),
                      const Divider(height: 1),
                      Link(
                        uri: LegalLinks.termsOfUse,
                        builder: (context, followLink) => ListTile(
                          key: const Key('termsOfUseSettingsAction'),
                          leading: const Icon(Icons.description_outlined),
                          title: const Text('Terms of Use'),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: followLink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                const AppSectionHeader(
                  title: 'Support',
                  subtitle: 'Get help with FieldProof 360 Pro.',
                ),
                const SizedBox(height: AppSpacing.small),
                Card(
                  child: Column(
                    children: [
                      Link(
                        uri: LegalLinks.support,
                        builder: (context, followLink) => ListTile(
                          leading: const Icon(Icons.support_agent_outlined),
                          title: const Text('Support center'),
                          subtitle: const Text(
                            'benattech.me/fieldproof360/support',
                          ),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: followLink,
                        ),
                      ),
                      const Divider(height: 1),
                      Link(
                        uri: LegalLinks.supportEmail,
                        builder: (context, followLink) => ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: const Text('Email support'),
                          subtitle: const Text('wamono.benjamin@gmail.com'),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: followLink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                const AppSectionHeader(title: 'About'),
                const SizedBox(height: AppSpacing.small),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(Brand.appName),
                    subtitle: Text(
                      'Version ${Brand.version}\n${Brand.tagline}',
                    ),
                    isThreeLine: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.large,
            0,
            AppSpacing.large,
            AppSpacing.large,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How FieldProof 360 Pro works',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: AppSpacing.medium),
              _HelpStep(
                icon: Icons.person_outline,
                title: '1. Choose a customer',
                text:
                    'Use an existing customer or create a report without one.',
              ),
              _HelpStep(
                icon: Icons.edit_note_outlined,
                title: '2. Record the work',
                text:
                    'Add the issue, diagnosis, work performed and equipment details.',
              ),
              _HelpStep(
                icon: Icons.photo_camera_outlined,
                title: '3. Add evidence',
                text:
                    'Attach before, during and after photos, materials and signatures.',
              ),
              _HelpStep(
                icon: Icons.lock_outline,
                title: '4. Finalize',
                text:
                    'FieldProof 360 Pro freezes the report and assigns a permanent number.',
              ),
              _HelpStep(
                icon: Icons.picture_as_pdf_outlined,
                title: '5. Share the PDF',
                text:
                    'Preview and share the finished report through your phone share sheet.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpStep extends StatelessWidget {
  const _HelpStep({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.medium),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xSmall),
              Text(text),
            ],
          ),
        ),
      ],
    ),
  );
}
