import 'package:fieldproof_360/app/branding/brand.dart';
import 'package:fieldproof_360/app/config/legal_links.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/widgets/responsive_content.dart';
import 'package:fieldproof_360/features/legal/presentation/widgets/legal_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Privacy Policy')),
    body: ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.large),
      children: [
        ResponsiveContent(
          maxWidth: 820,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                'Effective 25 September 2026',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.large),
              const LegalSection(
                title: 'Overview',
                body:
                    '${Brand.appName} is designed to help you create professional service reports. This policy explains what the app handles in version 1 (V1). No account is required to use the app in V1.',
              ),
              const LegalSection(
                title: 'Your report data stays on your device',
                body:
                    'Reports, customer details, report photos, and signatures are stored locally on your device. Cloud sync is not enabled in V1. We do not sell your personal information or your report data.',
              ),
              const LegalSection(
                title: 'Subscriptions and payments',
                body:
                    'RevenueCat helps manage subscription status. Apple or Google processes payments through its app store, depending on your device. FieldProof 360 Pro does not receive or store your payment card details.',
              ),
              const LegalSection(
                title: 'Device permissions',
                body:
                    'Camera and photo-library access are used only when you choose to add photos to a report. The app does not track your location and does not access your contacts, SMS messages, or call logs.',
              ),
              const LegalSection(
                title: 'Keeping your data',
                body:
                    'Because data is stored locally, uninstalling the app may remove reports and other locally stored data unless your operating system or device backup preserves it. Keep copies of important finalized reports.',
              ),
              const LegalSection(
                title: 'Changes to this policy',
                body:
                    'We may update this policy in a future version of the app. The current version will always be available from Settings.',
              ),
              const LegalSection(
                title: 'Contact',
                body:
                    'For help or questions about this policy, visit our support center or email wamono.benjamin@gmail.com.',
              ),
              Wrap(
                spacing: AppSpacing.small,
                children: [
                  Link(
                    uri: LegalLinks.privacyPolicy,
                    builder: (context, followLink) => TextButton(
                      onPressed: followLink,
                      child: const Text('View online Privacy Policy'),
                    ),
                  ),
                  Link(
                    uri: LegalLinks.support,
                    builder: (context, followLink) => TextButton(
                      onPressed: followLink,
                      child: const Text('Open Support'),
                    ),
                  ),
                  Link(
                    uri: LegalLinks.supportEmail,
                    builder: (context, followLink) => TextButton(
                      onPressed: followLink,
                      child: const Text('Email Support'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
