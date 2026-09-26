import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/customers/presentation/view_models/archive_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerDetailProvider(customerId));
    final archiveState = ref.watch(archiveCustomerControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: customer.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _DetailError(
          onRetry: () => ref.invalidate(customerDetailProvider(customerId)),
        ),
        data: (value) => value == null
            ? const Center(child: Text('Customer not found.'))
            : _CustomerDetails(
                customer: value,
                isArchiving: archiveState.isLoading,
                onEdit: () => context.goNamed(
                  AppRoute.customerEdit.name,
                  pathParameters: {'customerId': customerId},
                ),
                onNewReport: () => context.goNamed(
                  AppRoute.reportNew.name,
                  queryParameters: {'customerId': customerId},
                ),
                onArchive: () => _confirmArchive(context, ref, value),
              ),
      ),
    );
  }

  Future<void> _confirmArchive(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive customer?'),
        content: const Text(
          'The customer will be hidden from your active customer list. '
          'Existing records will remain available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirmArchiveCustomer'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final archived = await ref
        .read(archiveCustomerControllerProvider.notifier)
        .archive(customer.id);
    if (!context.mounted) return;
    if (archived) {
      context.go(RoutePaths.customers);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not archive the customer.')),
      );
    }
  }
}

class _CustomerDetails extends StatelessWidget {
  const _CustomerDetails({
    required this.customer,
    required this.isArchiving,
    required this.onEdit,
    required this.onNewReport,
    required this.onArchive,
  });

  final Customer customer;
  final bool isArchiving;
  final VoidCallback onEdit;
  final VoidCallback onNewReport;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final fields = <({IconData icon, String label, String value})>[
      if (customer.companyName case final value?)
        (icon: Icons.business_outlined, label: 'Company', value: value),
      if (customer.phone case final value?)
        (icon: Icons.phone_outlined, label: 'Phone', value: value),
      if (customer.email case final value?)
        (icon: Icons.email_outlined, label: 'Email', value: value),
      if (customer.address case final value?)
        (icon: Icons.location_on_outlined, label: 'Address', value: value),
      if (customer.notes case final value?)
        (icon: Icons.notes_outlined, label: 'Notes', value: value),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.large),
        children: [
          Text(customer.name, style: Theme.of(context).textTheme.headlineSmall),
          if (fields.isEmpty) ...[
            const SizedBox(height: AppSpacing.small),
            Text(
              'No additional contact details.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.large),
          for (final field in fields)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(field.icon),
              title: Text(field.label),
              subtitle: Text(field.value),
            ),
          const SizedBox(height: AppSpacing.large),
          FilledButton.icon(
            key: const Key('newReportForCustomerAction'),
            onPressed: onNewReport,
            icon: const Icon(Icons.description_outlined),
            label: const Text('New Report'),
          ),
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton.icon(
            key: const Key('editCustomerAction'),
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Customer'),
          ),
          const SizedBox(height: AppSpacing.small),
          TextButton.icon(
            key: const Key('archiveCustomerAction'),
            onPressed: isArchiving ? null : onArchive,
            icon: isArchiving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.archive_outlined),
            label: const Text('Archive Customer'),
          ),
        ],
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.onRetry});

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
