// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_customer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ArchiveCustomerController)
final archiveCustomerControllerProvider = ArchiveCustomerControllerProvider._();

final class ArchiveCustomerControllerProvider
    extends $AsyncNotifierProvider<ArchiveCustomerController, void> {
  ArchiveCustomerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveCustomerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveCustomerControllerHash();

  @$internal
  @override
  ArchiveCustomerController create() => ArchiveCustomerController();
}

String _$archiveCustomerControllerHash() =>
    r'713fed8deab719adc0e7de68067e51e0a6062499';

abstract class _$ArchiveCustomerController extends $AsyncNotifier<void> {
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
