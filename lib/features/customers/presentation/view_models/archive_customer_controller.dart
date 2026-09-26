import 'dart:async';

import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archive_customer_controller.g.dart';

@riverpod
class ArchiveCustomerController extends _$ArchiveCustomerController {
  @override
  FutureOr<void> build() {}

  Future<bool> archive(String customerId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(customerRepositoryProvider).archiveCustomer(customerId);
      ref.invalidate(customerListProvider);
      ref.invalidate(customerDetailProvider(customerId));
    });
    return !state.hasError;
  }
}
