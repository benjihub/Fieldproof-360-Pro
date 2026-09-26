import 'package:fieldproof_360/features/business/domain/models/business_profile_form_data.dart';
import 'package:fieldproof_360/features/business/domain/services/business_profile_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const valid = BusinessProfileFormData(
    businessName: 'Ben Electrical Services',
    technicianName: 'Benjamin',
    countryCode: 'ug',
    currencyCode: 'ugx',
    localeCode: 'en_UG',
  );

  test('accepts and normalizes a valid profile', () {
    expect(BusinessProfileValidator.validate(valid), isEmpty);
    expect(BusinessProfileValidator.normalizeCountryCode(' ug '), 'UG');
    expect(BusinessProfileValidator.normalizeCurrencyCode(' ugx '), 'UGX');
  });

  test('rejects missing required fields and malformed optional email', () {
    const invalid = BusinessProfileFormData(
      businessName: '   ',
      technicianName: '',
      countryCode: 'UGA',
      currencyCode: 'U',
      localeCode: 'en',
      email: 'invalid',
    );

    final errors = BusinessProfileValidator.validate(invalid);

    expect(
      errors.keys,
      containsAll([
        'businessName',
        'technicianName',
        'countryCode',
        'currencyCode',
        'email',
      ]),
    );
  });

  test('normalizes and validates report prefixes', () {
    expect(BusinessProfileValidator.normalizeReportPrefix(' ben '), 'BEN');

    expect(
      BusinessProfileValidator.validate(
        const BusinessProfileFormData(
          businessName: 'Business',
          technicianName: 'Tech',
          countryCode: 'UG',
          currencyCode: 'UGX',
          localeCode: 'en_UG',
          reportPrefix: 'BAD PREFIX!',
        ),
      )['reportPrefix'],
      isNotNull,
    );
  });
}
