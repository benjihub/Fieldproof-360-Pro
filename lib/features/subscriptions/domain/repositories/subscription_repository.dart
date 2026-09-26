import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_plan.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_status.dart';

abstract interface class SubscriptionRepository {
  Stream<SubscriptionStatus> watchStatus();

  Future<SubscriptionStatus> getStatus();

  Future<List<SubscriptionPlan>> getPlans();

  Future<SubscriptionStatus> purchase(String packageIdentifier);

  Future<SubscriptionStatus> restorePurchases();

  Future<void> refresh();

  Future<void> dispose();
}
