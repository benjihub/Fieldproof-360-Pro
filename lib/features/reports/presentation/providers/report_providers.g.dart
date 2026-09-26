// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportAccessPolicy)
final reportAccessPolicyProvider = ReportAccessPolicyProvider._();

final class ReportAccessPolicyProvider
    extends
        $FunctionalProvider<
          ReportAccessPolicy,
          ReportAccessPolicy,
          ReportAccessPolicy
        >
    with $Provider<ReportAccessPolicy> {
  ReportAccessPolicyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportAccessPolicyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportAccessPolicyHash();

  @$internal
  @override
  $ProviderElement<ReportAccessPolicy> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportAccessPolicy create(Ref ref) {
    return reportAccessPolicy(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportAccessPolicy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportAccessPolicy>(value),
    );
  }
}

String _$reportAccessPolicyHash() =>
    r'766e863b4bff5bee247b66777757ada5cd07da0e';

@ProviderFor(reportRepository)
final reportRepositoryProvider = ReportRepositoryProvider._();

final class ReportRepositoryProvider
    extends
        $FunctionalProvider<
          ReportRepository,
          ReportRepository,
          ReportRepository
        >
    with $Provider<ReportRepository> {
  ReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReportRepository create(Ref ref) {
    return reportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportRepository>(value),
    );
  }
}

String _$reportRepositoryHash() => r'6d4510bd51713c9f9219a06dbef569f83602c41f';

@ProviderFor(reportList)
final reportListProvider = ReportListProvider._();

final class ReportListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Report>>,
          List<Report>,
          Stream<List<Report>>
        >
    with $FutureModifier<List<Report>>, $StreamProvider<List<Report>> {
  ReportListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportListHash();

  @$internal
  @override
  $StreamProviderElement<List<Report>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Report>> create(Ref ref) {
    return reportList(ref);
  }
}

String _$reportListHash() => r'6a86a746b334868296fc2670e72f7d38f11fe174';

@ProviderFor(reportDetail)
final reportDetailProvider = ReportDetailFamily._();

final class ReportDetailProvider
    extends $FunctionalProvider<AsyncValue<Report?>, Report?, FutureOr<Report?>>
    with $FutureModifier<Report?>, $FutureProvider<Report?> {
  ReportDetailProvider._({
    required ReportDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reportDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportDetailHash();

  @override
  String toString() {
    return r'reportDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Report?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Report?> create(Ref ref) {
    final argument = this.argument as String;
    return reportDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportDetailHash() => r'a5fd8d1c4634dace392d18d8bc793515edb8dbff';

final class ReportDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Report?>, String> {
  ReportDetailFamily._()
    : super(
        retry: null,
        name: r'reportDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReportDetailProvider call(String reportId) =>
      ReportDetailProvider._(argument: reportId, from: this);

  @override
  String toString() => r'reportDetailProvider';
}

@ProviderFor(currentReportUsage)
final currentReportUsageProvider = CurrentReportUsageProvider._();

final class CurrentReportUsageProvider
    extends
        $FunctionalProvider<
          AsyncValue<UsageCounter>,
          UsageCounter,
          FutureOr<UsageCounter>
        >
    with $FutureModifier<UsageCounter>, $FutureProvider<UsageCounter> {
  CurrentReportUsageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentReportUsageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentReportUsageHash();

  @$internal
  @override
  $FutureProviderElement<UsageCounter> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UsageCounter> create(Ref ref) {
    return currentReportUsage(ref);
  }
}

String _$currentReportUsageHash() =>
    r'2df46c22dbae3f6fc3dd42170fce4fd1860790be';
