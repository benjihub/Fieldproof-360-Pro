// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_customer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditCustomerController)
final editCustomerControllerProvider = EditCustomerControllerProvider._();

final class EditCustomerControllerProvider
    extends $AsyncNotifierProvider<EditCustomerController, void> {
  EditCustomerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editCustomerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editCustomerControllerHash();

  @$internal
  @override
  EditCustomerController create() => EditCustomerController();
}

String _$editCustomerControllerHash() =>
    r'6b095449100b3978ae8dca7bd05f9b87e82bdb6d';

abstract class _$EditCustomerController extends $AsyncNotifier<void> {
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
