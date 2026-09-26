import 'dart:async';

import 'package:fieldproof_360/app/config/app_config.dart';
import 'package:fieldproof_360/features/subscriptions/data/repositories/revenuecat_subscription_repository.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_plan.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_status.dart';
import 'package:fieldproof_360/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_providers.g.dart';

const fieldProofProEntitlement = 'pro';
const fieldProofMonthlyProduct = 'fieldproof_pro_monthly';
const fieldProofYearlyProduct = 'fieldproof_pro_yearly';

@Riverpod(keepAlive: true)
String revenueCatApiKey(Ref ref) {
  final config = ref.watch(appConfigProvider);
  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS => config.revenueCatAppleKey,
    TargetPlatform.android => config.revenueCatGoogleKey,
    _ => '',
  };
}

@Riverpod(keepAlive: true)
bool subscriptionConfigured(Ref ref) =>
    ref.watch(revenueCatApiKeyProvider).trim().isNotEmpty;

@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  final repository = RevenueCatSubscriptionRepository(
    apiKey: ref.watch(revenueCatApiKeyProvider),
    entitlementIdentifier: fieldProofProEntitlement,
  );
  ref.onDispose(() => unawaited(repository.dispose()));
  return repository;
}

@Riverpod(keepAlive: true)
Stream<SubscriptionStatus> subscriptionStatus(Ref ref) =>
    ref.watch(subscriptionRepositoryProvider).watchStatus();

@riverpod
Future<List<SubscriptionPlan>> subscriptionPlans(Ref ref) =>
    ref.watch(subscriptionRepositoryProvider).getPlans();
