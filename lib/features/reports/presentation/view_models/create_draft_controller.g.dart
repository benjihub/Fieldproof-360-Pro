// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_draft_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateDraftController)
final createDraftControllerProvider = CreateDraftControllerProvider._();

final class CreateDraftControllerProvider
    extends $AsyncNotifierProvider<CreateDraftController, void> {
  CreateDraftControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createDraftControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createDraftControllerHash();

  @$internal
  @override
  CreateDraftController create() => CreateDraftController();
}

String _$createDraftControllerHash() =>
    r'c46f12c1da842ddf7303fb782c03bb94bc04541a';

abstract class _$CreateDraftController extends $AsyncNotifier<void> {
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
