final class CountryOption {
  const CountryOption({
    required this.name,
    required this.countryCode,
    required this.currencyCode,
    required this.localeCode,
  });

  final String name;
  final String countryCode;
  final String currencyCode;
  final String localeCode;
}

abstract final class CountryCatalog {
  static const supported = [
    CountryOption(
      name: 'United Kingdom',
      countryCode: 'GB',
      currencyCode: 'GBP',
      localeCode: 'en_GB',
    ),
    CountryOption(
      name: 'Australia',
      countryCode: 'AU',
      currencyCode: 'AUD',
      localeCode: 'en_AU',
    ),
    CountryOption(
      name: 'South Africa',
      countryCode: 'ZA',
      currencyCode: 'ZAR',
      localeCode: 'en_ZA',
    ),
    CountryOption(
      name: 'Uganda',
      countryCode: 'UG',
      currencyCode: 'UGX',
      localeCode: 'en_UG',
    ),
    CountryOption(
      name: 'Kenya',
      countryCode: 'KE',
      currencyCode: 'KES',
      localeCode: 'en_KE',
    ),
    CountryOption(
      name: 'Nigeria',
      countryCode: 'NG',
      currencyCode: 'NGN',
      localeCode: 'en_NG',
    ),
    CountryOption(
      name: 'United States',
      countryCode: 'US',
      currencyCode: 'USD',
      localeCode: 'en_US',
    ),
    CountryOption(
      name: 'Canada',
      countryCode: 'CA',
      currencyCode: 'CAD',
      localeCode: 'en_CA',
    ),
    CountryOption(
      name: 'New Zealand',
      countryCode: 'NZ',
      currencyCode: 'NZD',
      localeCode: 'en_NZ',
    ),
    CountryOption(
      name: 'Ireland',
      countryCode: 'IE',
      currencyCode: 'EUR',
      localeCode: 'en_IE',
    ),
  ];

  static CountryOption? findByCountryCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final country in supported) {
      if (country.countryCode == normalized) return country;
    }
    return null;
  }

  static String? suggestedCurrency(String countryCode) =>
      findByCountryCode(countryCode)?.currencyCode;

  static String suggestedLocale(String countryCode) =>
      findByCountryCode(countryCode)?.localeCode ?? 'en';
}
