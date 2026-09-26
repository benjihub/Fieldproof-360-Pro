import 'dart:async';

import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_plan.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_status.dart';
import 'package:fieldproof_360/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/view_models/subscription_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('purchase delegates to repository package identifier', () async {
    final repository = _FakeSubscriptionRepository();
    final viewModel = SubscriptionViewModel(repository);
    const plan = SubscriptionPlan(
      packageIdentifier: r'$rc_monthly',
      productIdentifier: 'fieldproof_pro_monthly',
      title: 'FieldProof 360 Pro Monthly',
      price: r'$5.99',
      period: SubscriptionPeriod.monthly,
    );

    final result = await viewModel.purchase(plan);

    expect(repository.lastPurchasedPackage, r'$rc_monthly');
    expect(result.isPro, isTrue);
  });

  test('restore delegates and returns latest entitlement', () async {
    final repository = _FakeSubscriptionRepository();
    final viewModel = SubscriptionViewModel(repository);

    final result = await viewModel.restore();

    expect(repository.restoreCalls, 1);
    expect(result.isPro, isTrue);
  });

  test('subscription status exposes free and pro state', () {
    const free = SubscriptionStatus(isConfigured: true, isPro: false);
    const pro = SubscriptionStatus(
      isConfigured: true,
      isPro: true,
      productIdentifier: 'fieldproof_pro_yearly',
    );

    expect(free.isFree, isTrue);
    expect(pro.isFree, isFalse);
    expect(pro.productIdentifier, 'fieldproof_pro_yearly');
  });
}

final class _FakeSubscriptionRepository implements SubscriptionRepository {
  final _controller = StreamController<SubscriptionStatus>.broadcast();
  String? lastPurchasedPackage;
  int restoreCalls = 0;

  static const _pro = SubscriptionStatus(
    isConfigured: true,
    isPro: true,
    productIdentifier: 'fieldproof_pro_monthly',
  );

  @override
  Future<void> dispose() async => _controller.close();

  @override
  Future<List<SubscriptionPlan>> getPlans() async => const [];

  @override
  Future<SubscriptionStatus> getStatus() async => _pro;

  @override
  Future<SubscriptionStatus> purchase(String packageIdentifier) async {
    lastPurchasedPackage = packageIdentifier;
    _controller.add(_pro);
    return _pro;
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<SubscriptionStatus> restorePurchases() async {
    restoreCalls += 1;
    _controller.add(_pro);
    return _pro;
  }

  @override
  Stream<SubscriptionStatus> watchStatus() async* {
    yield _pro;
    yield* _controller.stream;
  }
}
