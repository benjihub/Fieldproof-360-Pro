enum SubscriptionPeriod { monthly, yearly, other }

final class SubscriptionPlan {
  const SubscriptionPlan({
    required this.packageIdentifier,
    required this.productIdentifier,
    required this.title,
    required this.price,
    required this.period,
    this.description,
  });

  final String packageIdentifier;
  final String productIdentifier;
  final String title;
  final String price;
  final SubscriptionPeriod period;
  final String? description;

  String get periodLabel => switch (period) {
    SubscriptionPeriod.monthly => 'Monthly',
    SubscriptionPeriod.yearly => 'Yearly',
    SubscriptionPeriod.other => 'Subscription',
  };
}
