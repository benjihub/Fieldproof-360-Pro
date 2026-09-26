// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_editor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BusinessProfileEditorController)
final businessProfileEditorControllerProvider =
    BusinessProfileEditorControllerProvider._();

final class BusinessProfileEditorControllerProvider
    extends $AsyncNotifierProvider<BusinessProfileEditorController, void> {
  BusinessProfileEditorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessProfileEditorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessProfileEditorControllerHash();

  @$internal
  @override
  BusinessProfileEditorController create() => BusinessProfileEditorController();
}

String _$businessProfileEditorControllerHash() =>
    r'9dff89937100297826002d7a18cb5180751534bd';

abstract class _$BusinessProfileEditorController extends $AsyncNotifier<void> {
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
