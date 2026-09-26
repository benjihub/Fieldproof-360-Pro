import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile_form_data.dart';
import 'package:fieldproof_360/features/business/presentation/widgets/business_profile_form.dart';
import 'package:fieldproof_360/features/onboarding/presentation/view_models/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSetupScreen extends ConsumerWidget {
  const BusinessSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Business setup')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.small,
              AppSpacing.large,
              0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  const Expanded(
                    child: Text(
                      'These details appear on your reports. You can change them later in Settings.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: BusinessProfileForm(
                  submitLabel: 'Finish Setup',
                  isSubmitting: state.isLoading,
                  error: state.error,
                  onSubmit: (BusinessProfileFormData data) => ref
                      .read(onboardingControllerProvider.notifier)
                      .complete(data),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
