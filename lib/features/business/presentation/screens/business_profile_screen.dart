import 'package:fieldproof_360/core/widgets/feature_placeholder.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile_form_data.dart';
import 'package:fieldproof_360/features/business/presentation/providers/business_providers.dart';
import 'package:fieldproof_360/features/business/presentation/view_models/business_profile_editor_controller.dart';
import 'package:fieldproof_360/features/business/presentation/widgets/business_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessProfileScreen extends ConsumerWidget {
  const BusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider);
    final editor = ref.watch(businessProfileEditorControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Business Profile')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const FeaturePlaceholder(
          icon: Icons.error_outline,
          title: 'Could not load your profile',
          message: 'Please go back and try again.',
        ),
        data: (value) => value == null
            ? const FeaturePlaceholder(
                icon: Icons.business_outlined,
                title: 'No business profile',
                message: 'Complete onboarding to create your profile.',
              )
            : BusinessProfileForm(
                initialData: _formData(value),
                submitLabel: 'Save Changes',
                showAdvancedFields: true,
                isSubmitting: editor.isLoading,
                error: editor.error,
                onSubmit: (data) => _save(context, ref, value, data),
              ),
      ),
    );
  }

  BusinessProfileFormData _formData(BusinessProfile profile) =>
      BusinessProfileFormData(
        businessName: profile.businessName,
        technicianName: profile.technicianName,
        email: profile.email ?? '',
        phone: profile.phone ?? '',
        address: profile.address ?? '',
        countryCode: profile.countryCode,
        currencyCode: profile.currencyCode,
        localeCode: profile.localeCode,
        reportPrefix: profile.reportPrefix,
        taxLabel: profile.taxLabel ?? '',
        taxNumber: profile.taxNumber ?? '',
        defaultTerms: profile.defaultTerms ?? '',
      );

  Future<bool> _save(
    BuildContext context,
    WidgetRef ref,
    BusinessProfile profile,
    BusinessProfileFormData data,
  ) async {
    final saved = await ref
        .read(businessProfileEditorControllerProvider.notifier)
        .save(profile, data);
    if (saved && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Business profile saved.')));
    }
    return saved;
  }
}
