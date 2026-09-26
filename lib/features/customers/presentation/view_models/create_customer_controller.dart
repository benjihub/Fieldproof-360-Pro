import 'dart:async';

import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_customer_controller.g.dart';

@riverpod
class CreateCustomerController extends _$CreateCustomerController {
  @override
  FutureOr<void> build() {}

  Future<Customer?> create(CustomerFormData input) async {
    state = const AsyncLoading();
    Customer? created;
    state = await AsyncValue.guard(() async {
      created = await ref
          .read(customerRepositoryProvider)
          .createCustomer(input);
      ref.invalidate(customerListProvider);
    });
    return state.hasError ? null : created;
  }
}
