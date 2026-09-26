import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/widgets/app_state_views.dart';
import 'package:fieldproof_360/core/widgets/responsive_content.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerListProvider(_search));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.small),
            child: FilledButton.tonalIcon(
              key: const Key('addCustomerAction'),
              onPressed: _addCustomer,
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Add Customer'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ResponsiveContent(
            maxWidth: 900,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.small,
              AppSpacing.large,
              AppSpacing.medium,
            ),
            child: SearchBar(
              key: const Key('customerSearchField'),
              controller: _searchController,
              hintText: 'Search by name, company or phone',
              leading: const Icon(Icons.search),
              trailing: [
                if (_search.isNotEmpty)
                  IconButton(
                    key: const Key('clearCustomerSearch'),
                    tooltip: 'Clear search',
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.close),
                  ),
              ],
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          Expanded(
            child: customers.when(
              loading: () => const AppLoadingView(label: 'Loading customers…'),
              error: (error, stackTrace) => AppErrorState(
                title: 'Customers unavailable',
                message:
                    'FieldProof 360 Pro could not load your customer list.',
                onRetry: () => ref.invalidate(customerListProvider(_search)),
              ),
              data: (items) => items.isEmpty
                  ? _search.trim().isEmpty
                        ? AppEmptyState(
                            icon: Icons.people_outline,
                            title: 'No customers yet',
                            message:
                                'Add your first customer to quickly reuse their details when creating service reports.',
                            actionLabel: 'Add Customer',
                            onAction: _addCustomer,
                          )
                        : AppEmptyState(
                            icon: Icons.search_off,
                            title: 'No matching customers',
                            message:
                                'Try another name, company or phone number.',
                            actionLabel: 'Clear search',
                            onAction: _clearSearch,
                          )
                  : ListView(
                      children: [
                        ResponsiveContent(
                          maxWidth: 900,
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.large,
                            0,
                            AppSpacing.large,
                            AppSpacing.large,
                          ),
                          child: _CustomerList(customers: items),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCustomer() => context.goNamed(AppRoute.customerNew.name);

  void _clearSearch() {
    _searchController.clear();
    setState(() => _search = '');
  }
}

class _CustomerList extends StatelessWidget {
  const _CustomerList({required this.customers});

  final List<Customer> customers;

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: [
        for (var index = 0; index < customers.length; index++) ...[
          _CustomerTile(customer: customers[index]),
          if (index < customers.length - 1) const Divider(height: 1),
        ],
      ],
    ),
  );
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (customer.companyName != null) customer.companyName!,
      if (customer.phone != null) customer.phone!,
    ].join(' · ');
    return ListTile(
      key: ValueKey(customer.id),
      leading: CircleAvatar(child: Text(_initial(customer.name))),
      title: Text(customer.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: details.isEmpty
          ? null
          : Text(details, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.goNamed(
        AppRoute.customerDetail.name,
        pathParameters: {'customerId': customer.id},
      ),
    );
  }

  String _initial(String name) =>
      name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase();
}
