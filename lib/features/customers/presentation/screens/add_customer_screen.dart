import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/customers/presentation/view_models/create_customer_controller.dart';
import 'package:fieldproof_360/features/customers/presentation/widgets/customer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddCustomerScreen extends ConsumerWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createCustomerControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Customer')),
      body: CustomerForm(
        initialData: const CustomerFormData(name: ''),
        submitLabel: 'Save Customer',
        isSubmitting: state.isLoading,
        error: state.error,
        onSubmit: (input) => _create(context, ref, input),
      ),
    );
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref,
    CustomerFormData input,
  ) async {
    final customer = await ref
        .read(createCustomerControllerProvider.notifier)
        .create(input);
    if (customer != null && context.mounted) {
      context.goNamed(
        AppRoute.customerDetail.name,
        pathParameters: {'customerId': customer.id},
      );
    }
  }
}
