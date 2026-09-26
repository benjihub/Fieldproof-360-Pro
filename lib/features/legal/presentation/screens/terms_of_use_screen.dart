import 'package:fieldproof_360/app/branding/brand.dart';
import 'package:fieldproof_360/app/config/legal_links.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/widgets/responsive_content.dart';
import 'package:fieldproof_360/features/legal/presentation/widgets/legal_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Terms of Use')),
    body: ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.large),
      children: [
        ResponsiveContent(
          maxWidth: 820,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Use',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                'Effective 25 September 2026',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.large),
              const LegalSection(
                title: 'Using FieldProof 360 Pro',
                body:
                    '${Brand.appName} is provided as-is to help you document work. You are responsible for checking the accuracy and completeness of every report you create.',
              ),
              const LegalSection(
                title: 'Permissions and consent',
                body:
                    'You are responsible for obtaining permission before collecting customer signatures or taking and attaching photos. Do not use the app for unlawful activity or to create misleading records.',
              ),
              const LegalSection(
                title: 'Not professional advice',
                body:
                    'FieldProof 360 Pro is a reporting tool. It does not provide professional, legal, or safety advice. Use your own judgment and follow the standards, laws, and safety requirements that apply to your work.',
              ),
              const LegalSection(
                title: 'Free and Pro plans',
                body:
                    'The Free plan allows up to 3 finalized reports per calendar month. FieldProof 360 Pro allows unlimited finalized reports and removes FieldProof 360 Pro branding from PDFs.',
              ),
              const LegalSection(
                title: 'Subscriptions, cancellation, and refunds',
                body:
                    'Pro subscriptions renew automatically unless you cancel through Apple or Google. Apple or Google store rules govern purchases and refunds. You can use Restore Purchases in the app to restore an eligible subscription.',
              ),
              const LegalSection(
                title: 'Limitation of liability',
                body:
                    'To the fullest extent allowed by law, FieldProof 360 Pro is not responsible for indirect losses, lost profits, lost data, or decisions made using reports created in the app. Keep copies of important reports and verify them before relying on them.',
              ),
              const LegalSection(
                title: 'Changes to these terms',
                body:
                    'We may update these terms in a future version of the app. Continued use after an update means you accept the updated terms.',
              ),
              const LegalSection(
                title: 'Contact',
                body:
                    'For help or questions about these terms, visit our support center or email wamono.benjamin@gmail.com.',
              ),
              Wrap(
                spacing: AppSpacing.small,
                children: [
                  Link(
                    uri: LegalLinks.termsOfUse,
                    builder: (context, followLink) => TextButton(
                      onPressed: followLink,
                      child: const Text('View online Terms of Use'),
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
