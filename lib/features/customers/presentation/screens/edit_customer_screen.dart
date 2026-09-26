import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/customers/presentation/view_models/edit_customer_controller.dart';
import 'package:fieldproof_360/features/customers/presentation/widgets/customer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditCustomerScreen extends ConsumerWidget {
  const EditCustomerScreen({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerDetailProvider(customerId));
    final editor = ref.watch(editCustomerControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Customer')),
      body: customer.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _LoadError(
          onRetry: () => ref.invalidate(customerDetailProvider(customerId)),
        ),
        data: (value) => value == null
            ? const Center(child: Text('Customer not found.'))
            : CustomerForm(
                initialData: _formData(value),
                submitLabel: 'Save Changes',
                isSubmitting: editor.isLoading,
                error: editor.error,
                onSubmit: (input) => _save(context, ref, input),
              ),
      ),
    );
  }

  CustomerFormData _formData(Customer customer) => CustomerFormData(
    name: customer.name,
    companyName: customer.companyName ?? '',
    phone: customer.phone ?? '',
    email: customer.email ?? '',
    address: customer.address ?? '',
    notes: customer.notes ?? '',
  );

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    CustomerFormData input,
  ) async {
    final updated = await ref
        .read(editCustomerControllerProvider.notifier)
        .save(customerId, input);
    if (updated != null && context.mounted) {
      context.pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Customer updated.')));
    }
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Could not load the customer.'),
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
