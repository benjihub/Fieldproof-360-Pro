import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/presentation/view_models/create_draft_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewReportScreen extends ConsumerStatefulWidget {
  const NewReportScreen({this.initialCustomerId, super.key});

  final String? initialCustomerId;

  @override
  ConsumerState<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends ConsumerState<NewReportScreen> {
  final _title = TextEditingController();
  String? _customerId;
  ReportType _reportType = ReportType.service;

  @override
  void initState() {
    super.initState();
    _customerId = widget.initialCustomerId;
  }

  @override
  void didUpdateWidget(covariant NewReportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCustomerId != widget.initialCustomerId) {
      _customerId = widget.initialCustomerId;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerListProvider(''));
    final createState = ref.watch(createDraftControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('New Report')),
      body: customers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _CreateReportForm(
          customers: const [],
          selectedCustomerId: null,
          selectedType: _reportType,
          titleController: _title,
          isSaving: createState.isLoading,
          error: createState.error,
          customerLoadFailed: true,
          onCustomerChanged: _selectCustomer,
          onTypeChanged: _selectType,
          onSubmit: () => _create(context, null),
          onRetryCustomers: () => ref.invalidate(customerListProvider('')),
        ),
        data: (items) {
          final selectedCustomerId =
              items.any((customer) => customer.id == _customerId)
              ? _customerId
              : null;
          return _CreateReportForm(
            customers: items,
            selectedCustomerId: selectedCustomerId,
            selectedType: _reportType,
            titleController: _title,
            isSaving: createState.isLoading,
            error: createState.error,
            customerLoadFailed: false,
            onCustomerChanged: _selectCustomer,
            onTypeChanged: _selectType,
            onSubmit: () => _create(context, selectedCustomerId),
            onRetryCustomers: null,
          );
        },
      ),
    );
  }

  void _selectCustomer(String? customerId) {
    setState(() => _customerId = customerId);
  }

  void _selectType(ReportType type) {
    setState(() => _reportType = type);
  }

  Future<void> _create(BuildContext context, String? selectedCustomerId) async {
    final report = await ref
        .read(createDraftControllerProvider.notifier)
        .create(
          customerId: selectedCustomerId,
          reportType: _reportType,
          title: _title.text,
        );
    if (report != null && context.mounted) {
      context.goNamed(
        AppRoute.reportEdit.name,
        pathParameters: {'reportId': report.id},
      );
    }
  }
}

class _CreateReportForm extends StatelessWidget {
  const _CreateReportForm({
    required this.customers,
    required this.selectedCustomerId,
    required this.selectedType,
    required this.titleController,
    required this.isSaving,
    required this.error,
    required this.customerLoadFailed,
    required this.onCustomerChanged,
    required this.onTypeChanged,
    required this.onSubmit,
    required this.onRetryCustomers,
  });

  static const _noCustomer = '';

  final List<Customer> customers;
  final String? selectedCustomerId;
  final ReportType selectedType;
  final TextEditingController titleController;
  final bool isSaving;
  final Object? error;
  final bool customerLoadFailed;
  final ValueChanged<String?> onCustomerChanged;
  final ValueChanged<ReportType> onTypeChanged;
  final VoidCallback onSubmit;
  final VoidCallback? onRetryCustomers;

  @override
  Widget build(BuildContext context) {
    final errorMessage = switch (error) {
      AppException(:final message) => message,
      != null => 'Could not create the draft. Please try again.',
      _ => null,
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  key: const Key('reportCustomerField'),
                  initialValue: selectedCustomerId ?? _noCustomer,
                  decoration: const InputDecoration(labelText: 'Customer'),
                  items: [
                    const DropdownMenuItem(
                      value: _noCustomer,
                      child: Text('No customer'),
                    ),
                    for (final customer in customers)
                      DropdownMenuItem(
                        value: customer.id,
                        child: Text(_customerLabel(customer)),
                      ),
                  ],
                  onChanged: isSaving || customerLoadFailed
                      ? null
                      : (value) => onCustomerChanged(
                          value == _noCustomer ? null : value,
                        ),
                ),
                if (customerLoadFailed) ...[
                  const SizedBox(height: AppSpacing.small),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Customers could not be loaded. You can continue '
                          'without one.',
                        ),
                      ),
                      TextButton(
                        onPressed: onRetryCustomers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.medium),
                DropdownButtonFormField<ReportType>(
                  key: const Key('reportTypeField'),
                  initialValue: selectedType,
                  decoration: const InputDecoration(labelText: 'Report Type'),
                  items: [
                    for (final type in ReportType.values)
                      DropdownMenuItem(
                        value: type,
                        child: Text(type.displayLabel),
                      ),
                  ],
                  onChanged: isSaving
                      ? null
                      : (value) {
                          if (value != null) onTypeChanged(value);
                        },
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  key: const Key('reportTitleField'),
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  enabled: !isSaving,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Boiler maintenance',
                    helperText: 'Optional',
                  ),
                  onSubmitted: isSaving ? null : (value) => onSubmit(),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    errorMessage,
                    key: const Key('createDraftError'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.large),
                FilledButton(
                  key: const Key('createDraftAction'),
                  onPressed: isSaving ? null : onSubmit,
                  child: isSaving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Draft'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _customerLabel(Customer customer) =>
      customer.companyName == null
      ? customer.name
      : '${customer.name} — ${customer.companyName}';
}
