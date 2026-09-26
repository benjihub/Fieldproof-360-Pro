import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/customers/data/repositories/drift_customer_repository.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/domain/repositories/customer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_providers.g.dart';

@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) =>
    DriftCustomerRepository(ref.watch(appDatabaseProvider));

@riverpod
Future<List<Customer>> customerList(Ref ref, String search) =>
    ref.watch(customerRepositoryProvider).getCustomers(search: search);

@riverpod
Future<Customer?> customerDetail(Ref ref, String customerId) =>
    ref.watch(customerRepositoryProvider).getCustomer(customerId);
