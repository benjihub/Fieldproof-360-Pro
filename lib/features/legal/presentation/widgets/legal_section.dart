import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.large),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.small),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}
