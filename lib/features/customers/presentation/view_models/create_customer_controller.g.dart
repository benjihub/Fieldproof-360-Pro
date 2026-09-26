// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_customer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateCustomerController)
final createCustomerControllerProvider = CreateCustomerControllerProvider._();

final class CreateCustomerControllerProvider
    extends $AsyncNotifierProvider<CreateCustomerController, void> {
  CreateCustomerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCustomerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCustomerControllerHash();

  @$internal
  @override
  CreateCustomerController create() => CreateCustomerController();
}

String _$createCustomerControllerHash() =>
    r'cb0bffb4c216a87e9cf6d9c18d1548f61a86af24';

abstract class _$CreateCustomerController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
