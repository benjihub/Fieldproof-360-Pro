import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_plan.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_status.dart';
import 'package:fieldproof_360/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:url_launcher/url_launcher.dart';

final class SubscriptionViewModel {
  const SubscriptionViewModel(this._repository);

  final SubscriptionRepository _repository;

  Future<SubscriptionStatus> purchase(SubscriptionPlan plan) =>
      _repository.purchase(plan.packageIdentifier);

  Future<SubscriptionStatus> restore() => _repository.restorePurchases();

  Future<void> refresh() => _repository.refresh();

  Future<void> manage(SubscriptionStatus status) async {
    final rawUrl = status.managementUrl;
    if (rawUrl == null || rawUrl.isEmpty) {
      throw const SubscriptionException(
        'Subscription management is not available yet.',
      );
    }
    final uri = Uri.tryParse(rawUrl);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const SubscriptionException(
        'Could not open subscription management.',
      );
    }
  }
}
