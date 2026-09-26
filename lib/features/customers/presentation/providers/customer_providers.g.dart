// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerRepository)
final customerRepositoryProvider = CustomerRepositoryProvider._();

final class CustomerRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerRepository,
          CustomerRepository,
          CustomerRepository
        >
    with $Provider<CustomerRepository> {
  CustomerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'a6a735b473f5fa03b4a1793b2e61c11945dbfe88';

@ProviderFor(customerList)
final customerListProvider = CustomerListFamily._();

final class CustomerListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Customer>>,
          List<Customer>,
          FutureOr<List<Customer>>
        >
    with $FutureModifier<List<Customer>>, $FutureProvider<List<Customer>> {
  CustomerListProvider._({
    required CustomerListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerListHash();

  @override
  String toString() {
    return r'customerListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Customer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Customer>> create(Ref ref) {
    final argument = this.argument as String;
    return customerList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerListHash() => r'e46158d89d4c2a7d71cc1f9038a08025dd7a81e8';

final class CustomerListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Customer>>, String> {
  CustomerListFamily._()
    : super(
        retry: null,
        name: r'customerListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerListProvider call(String search) =>
      CustomerListProvider._(argument: search, from: this);

  @override
  String toString() => r'customerListProvider';
}

@ProviderFor(customerDetail)
final customerDetailProvider = CustomerDetailFamily._();

final class CustomerDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Customer?>,
          Customer?,
          FutureOr<Customer?>
        >
    with $FutureModifier<Customer?>, $FutureProvider<Customer?> {
  CustomerDetailProvider._({
    required CustomerDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerDetailHash();

  @override
  String toString() {
    return r'customerDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Customer?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Customer?> create(Ref ref) {
    final argument = this.argument as String;
    return customerDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerDetailHash() => r'823e9a6d6afcd9c97cf2b5ad5731339cb3de8f1b';

final class CustomerDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Customer?>, String> {
  CustomerDetailFamily._()
    : super(
        retry: null,
        name: r'customerDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerDetailProvider call(String customerId) =>
      CustomerDetailProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerDetailProvider';
}
