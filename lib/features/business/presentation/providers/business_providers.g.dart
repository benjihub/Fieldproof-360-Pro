// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(businessRepository)
final businessRepositoryProvider = BusinessRepositoryProvider._();

final class BusinessRepositoryProvider
    extends
        $FunctionalProvider<
          BusinessRepository,
          BusinessRepository,
          BusinessRepository
        >
    with $Provider<BusinessRepository> {
  BusinessRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessRepositoryHash();

  @$internal
  @override
  $ProviderElement<BusinessRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BusinessRepository create(Ref ref) {
    return businessRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BusinessRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BusinessRepository>(value),
    );
  }
}

String _$businessRepositoryHash() =>
    r'afb27801073e3a638a5082138d230dd9a3b0b5e8';

@ProviderFor(businessProfile)
final businessProfileProvider = BusinessProfileProvider._();

final class BusinessProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<BusinessProfile?>,
          BusinessProfile?,
          FutureOr<BusinessProfile?>
        >
    with $FutureModifier<BusinessProfile?>, $FutureProvider<BusinessProfile?> {
  BusinessProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessProfileHash();

  @$internal
  @override
  $FutureProviderElement<BusinessProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BusinessProfile?> create(Ref ref) {
    return businessProfile(ref);
  }
}

String _$businessProfileHash() => r'e843d385c518ff746d72839b60e10b2916b9e917';
