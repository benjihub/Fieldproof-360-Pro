final class BusinessProfileFormData {
  const BusinessProfileFormData({
    required this.businessName,
    required this.technicianName,
    required this.countryCode,
    required this.currencyCode,
    required this.localeCode,
    this.email = '',
    this.phone = '',
    this.address = '',
    this.reportPrefix = 'FP',
    this.taxLabel = '',
    this.taxNumber = '',
    this.defaultTerms = '',
  });

  final String businessName;
  final String technicianName;
  final String email;
  final String phone;
  final String address;
  final String countryCode;
  final String currencyCode;
  final String localeCode;
  final String reportPrefix;
  final String taxLabel;
  final String taxNumber;
  final String defaultTerms;
}
