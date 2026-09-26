import 'dart:async';

import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_customer_controller.g.dart';

@riverpod
class EditCustomerController extends _$EditCustomerController {
  @override
  FutureOr<void> build() {}

  Future<Customer?> save(String customerId, CustomerFormData input) async {
    state = const AsyncLoading();
    Customer? updated;
    state = await AsyncValue.guard(() async {
      updated = await ref
          .read(customerRepositoryProvider)
          .updateCustomer(customerId, input);
      ref.invalidate(customerListProvider);
      ref.invalidate(customerDetailProvider(customerId));
    });
    return state.hasError ? null : updated;
  }
}
