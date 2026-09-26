final class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.businessName,
    required this.technicianName,
    required this.countryCode,
    required this.currencyCode,
    required this.localeCode,
    required this.reportPrefix,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.phone,
    this.address,
    this.logoPath,
    this.taxLabel,
    this.taxNumber,
    this.defaultTerms,
  });

  final String id;
  final String businessName;
  final String technicianName;
  final String? email;
  final String? phone;
  final String? address;
  final String countryCode;
  final String currencyCode;
  final String localeCode;
  final String? logoPath;
  final String? taxLabel;
  final String? taxNumber;
  final String reportPrefix;
  final String? defaultTerms;
  final DateTime createdAt;
  final DateTime updatedAt;
}
