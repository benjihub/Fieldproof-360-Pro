final class SubscriptionStatus {
  const SubscriptionStatus({
    required this.isConfigured,
    required this.isPro,
    this.productIdentifier,
    this.expirationDate,
    this.managementUrl,
  });

  const SubscriptionStatus.unconfigured()
    : isConfigured = false,
      isPro = false,
      productIdentifier = null,
      expirationDate = null,
      managementUrl = null;

  final bool isConfigured;
  final bool isPro;
  final String? productIdentifier;
  final DateTime? expirationDate;
  final String? managementUrl;

  bool get isFree => !isPro;
}
