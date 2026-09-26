import 'dart:async';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_plan.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_status.dart';
import 'package:fieldproof_360/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final class RevenueCatSubscriptionRepository implements SubscriptionRepository {
  RevenueCatSubscriptionRepository({
    required String apiKey,
    this.entitlementIdentifier = 'pro',
  }) : _apiKey = apiKey.trim();

  final String _apiKey;
  final String entitlementIdentifier;
  final StreamController<SubscriptionStatus> _statusController =
      StreamController<SubscriptionStatus>.broadcast();

  SubscriptionStatus _latest = const SubscriptionStatus.unconfigured();
  Future<void>? _initialization;
  CustomerInfoUpdateListener? _customerInfoListener;
  bool _disposed = false;

  bool get _hasConfiguration => _apiKey.isNotEmpty;

  @override
  Stream<SubscriptionStatus> watchStatus() async* {
    await _ensureInitialized();
    yield _latest;
    yield* _statusController.stream;
  }

  @override
  Future<SubscriptionStatus> getStatus() async {
    await _ensureInitialized();
    if (!_hasConfiguration) return _latest;

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return _updateStatus(customerInfo);
    } on PlatformException catch (error) {
      throw SubscriptionException(
        'Could not check your subscription right now.',
        cause: error,
      );
    }
  }

  @override
  Future<List<SubscriptionPlan>> getPlans() async {
    await _ensureInitialized();
    if (!_hasConfiguration) return const [];

    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      if (offering == null) return const [];

      final packages = <Package>[
        if (offering.monthly != null) offering.monthly!,
        if (offering.annual != null) offering.annual!,
        ...offering.availablePackages.where(
          (package) =>
              package.identifier != offering.monthly?.identifier &&
              package.identifier != offering.annual?.identifier,
        ),
      ];

      return packages.map(_mapPackage).toList(growable: false);
    } on PlatformException catch (error) {
      throw SubscriptionException(
        'Could not load subscription options.',
        cause: error,
      );
    }
  }

  @override
  Future<SubscriptionStatus> purchase(String packageIdentifier) async {
    await _ensureInitialized();
    if (!_hasConfiguration) {
      throw const SubscriptionException(
        'Subscriptions are not configured for this build.',
      );
    }

    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      if (offering == null) {
        throw const SubscriptionException(
          'No subscription offering is currently available.',
        );
      }
      Package? package;
      for (final candidate in offering.availablePackages) {
        if (candidate.identifier == packageIdentifier ||
            candidate.storeProduct.identifier == packageIdentifier) {
          package = candidate;
          break;
        }
      }
      if (package == null) {
        throw const SubscriptionException(
          'That subscription option is no longer available.',
        );
      }

      final result = await Purchases.purchase(PurchaseParams.package(package));
      return _updateStatus(result.customerInfo);
    } on PurchaseCancelledException {
      rethrow;
    } on SubscriptionException {
      rethrow;
    } on PlatformException catch (error) {
      final code = PurchasesErrorHelper.getErrorCode(error);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        throw const PurchaseCancelledException();
      }
      throw SubscriptionException(
        error.message ?? 'The purchase could not be completed.',
        cause: error,
      );
    }
  }

  @override
  Future<SubscriptionStatus> restorePurchases() async {
    await _ensureInitialized();
    if (!_hasConfiguration) {
      throw const SubscriptionException(
        'Subscriptions are not configured for this build.',
      );
    }

    try {
      final customerInfo = await Purchases.restorePurchases();
      return _updateStatus(customerInfo);
    } on PlatformException catch (error) {
      throw SubscriptionException(
        error.message ?? 'Could not restore purchases.',
        cause: error,
      );
    }
  }

  @override
  Future<void> refresh() async {
    await getStatus();
  }

  Future<void> _ensureInitialized() async {
    final existing = _initialization;
    if (existing != null) {
      await existing;
      return;
    }

    final initialization = _initialize();
    _initialization = initialization;
    try {
      await initialization;
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }

  Future<void> _initialize() async {
    if (!_hasConfiguration) {
      _latest = const SubscriptionStatus.unconfigured();
      return;
    }

    try {
      if (!await Purchases.isConfigured) {
        await Purchases.configure(PurchasesConfiguration(_apiKey));
      }

      if (_customerInfoListener == null) {
        _customerInfoListener = (customerInfo) {
          if (_disposed) return;
          _updateStatus(customerInfo);
        };
        Purchases.addCustomerInfoUpdateListener(_customerInfoListener!);
      }

      final customerInfo = await Purchases.getCustomerInfo();
      _updateStatus(customerInfo);
    } on PlatformException catch (error) {
      throw SubscriptionException(
        'Could not initialize subscriptions.',
        cause: error,
      );
    }
  }

  SubscriptionStatus _updateStatus(CustomerInfo customerInfo) {
    final entitlement = customerInfo.entitlements.all[entitlementIdentifier];
    final status = SubscriptionStatus(
      isConfigured: true,
      isPro: entitlement?.isActive ?? false,
      productIdentifier: entitlement?.productIdentifier,
      expirationDate: _parseDate(entitlement?.expirationDate),
      managementUrl: customerInfo.managementURL,
    );
    _latest = status;
    if (!_disposed) _statusController.add(status);
    return status;
  }

  SubscriptionPlan _mapPackage(Package package) {
    final period = switch (package.packageType) {
      PackageType.monthly => SubscriptionPeriod.monthly,
      PackageType.annual => SubscriptionPeriod.yearly,
      _ => SubscriptionPeriod.other,
    };
    final title = switch (period) {
      SubscriptionPeriod.monthly => 'FieldProof 360 Pro Monthly',
      SubscriptionPeriod.yearly => 'FieldProof 360 Pro Yearly',
      SubscriptionPeriod.other => package.storeProduct.title,
    };
    return SubscriptionPlan(
      packageIdentifier: package.identifier,
      productIdentifier: package.storeProduct.identifier,
      title: title,
      description: package.storeProduct.description,
      price: package.storeProduct.priceString,
      period: period,
    );
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toUtc();
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    if (_customerInfoListener != null) {
      Purchases.removeCustomerInfoUpdateListener(_customerInfoListener!);
    }
    await _statusController.close();
  }
}
