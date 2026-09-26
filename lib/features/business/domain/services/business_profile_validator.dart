import 'package:fieldproof_360/features/business/domain/models/business_profile_form_data.dart';

abstract final class BusinessProfileValidator {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _prefixPattern = RegExp(r'^[A-Z0-9]+$');

  static Map<String, String> validate(BusinessProfileFormData input) {
    final errors = <String, String>{};

    if (input.businessName.trim().isEmpty) {
      errors['businessName'] = 'Enter your business or trading name.';
    }
    if (input.technicianName.trim().isEmpty) {
      errors['technicianName'] = 'Enter your name.';
    }

    final countryCode = normalizeCountryCode(input.countryCode);
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(countryCode)) {
      errors['countryCode'] = 'Enter a two-letter ISO country code.';
    }

    final currencyCode = normalizeCurrencyCode(input.currencyCode);
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currencyCode)) {
      errors['currencyCode'] = 'Enter a three-letter currency code.';
    }

    final email = input.email.trim();
    if (email.isNotEmpty && !_emailPattern.hasMatch(email)) {
      errors['email'] = 'Enter a valid email address.';
    }

    final prefix = normalizeReportPrefix(input.reportPrefix);
    if (prefix.isEmpty) {
      errors['reportPrefix'] = 'Enter a report prefix.';
    } else if (prefix.length > 8) {
      errors['reportPrefix'] = 'Use no more than 8 characters.';
    } else if (!_prefixPattern.hasMatch(prefix)) {
      errors['reportPrefix'] = 'Use letters and numbers only.';
    }

    return errors;
  }

  static String normalizeCountryCode(String value) =>
      value.trim().toUpperCase();

  static String normalizeCurrencyCode(String value) =>
      value.trim().toUpperCase();

  static String normalizeReportPrefix(String value) =>
      value.trim().toUpperCase();
}
