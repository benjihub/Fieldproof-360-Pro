// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(revenueCatApiKey)
final revenueCatApiKeyProvider = RevenueCatApiKeyProvider._();

final class RevenueCatApiKeyProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  RevenueCatApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueCatApiKeyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueCatApiKeyHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return revenueCatApiKey(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$revenueCatApiKeyHash() => r'f043b3a571bfb67987582e8cefff5b65bee8bd37';

@ProviderFor(subscriptionConfigured)
final subscriptionConfiguredProvider = SubscriptionConfiguredProvider._();

final class SubscriptionConfiguredProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  SubscriptionConfiguredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionConfiguredProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionConfiguredHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return subscriptionConfigured(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$subscriptionConfiguredHash() =>
    r'd46a6fb74e3cfe6714eb238b8f0e3f2078bda8cf';

@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider = SubscriptionRepositoryProvider._();

final class SubscriptionRepositoryProvider
    extends
        $FunctionalProvider<
          SubscriptionRepository,
          SubscriptionRepository,
          SubscriptionRepository
        >
    with $Provider<SubscriptionRepository> {
  SubscriptionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubscriptionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubscriptionRepository create(Ref ref) {
    return subscriptionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionRepository>(value),
    );
  }
}

String _$subscriptionRepositoryHash() =>
    r'74806fe8a3d05f3113d0ddee7d19bae3294086de';

@ProviderFor(subscriptionStatus)
final subscriptionStatusProvider = SubscriptionStatusProvider._();

final class SubscriptionStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubscriptionStatus>,
          SubscriptionStatus,
          Stream<SubscriptionStatus>
        >
    with
        $FutureModifier<SubscriptionStatus>,
        $StreamProvider<SubscriptionStatus> {
  SubscriptionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionStatusHash();

  @$internal
  @override
  $StreamProviderElement<SubscriptionStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SubscriptionStatus> create(Ref ref) {
    return subscriptionStatus(ref);
  }
}

String _$subscriptionStatusHash() =>
    r'efb216e3a05f0505744696a131b9b91935dc59d1';

@ProviderFor(subscriptionPlans)
final subscriptionPlansProvider = SubscriptionPlansProvider._();

final class SubscriptionPlansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SubscriptionPlan>>,
          List<SubscriptionPlan>,
          FutureOr<List<SubscriptionPlan>>
        >
    with
        $FutureModifier<List<SubscriptionPlan>>,
        $FutureProvider<List<SubscriptionPlan>> {
  SubscriptionPlansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionPlansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionPlansHash();

  @$internal
  @override
  $FutureProviderElement<List<SubscriptionPlan>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SubscriptionPlan>> create(Ref ref) {
    return subscriptionPlans(ref);
  }
}

String _$subscriptionPlansHash() => r'3dd222a85172a49e4a193af16b00d103fa92ba4e';
