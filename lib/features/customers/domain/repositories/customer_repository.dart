import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';

abstract interface class CustomerRepository {
  Stream<List<Customer>> watchCustomers({String search = ''});

  Stream<Customer?> watchCustomer(String id);

  Future<List<Customer>> getCustomers({String search = ''});

  Future<Customer?> getCustomer(String id);

  Future<Customer> createCustomer(CustomerFormData input);

  Future<Customer> updateCustomer(String id, CustomerFormData input);

  Future<void> archiveCustomer(String id);

  Future<void> restoreCustomer(String id);
}
