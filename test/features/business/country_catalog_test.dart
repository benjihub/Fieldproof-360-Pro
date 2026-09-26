import 'package:fieldproof_360/features/business/domain/models/country_option.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps supported countries to suggested currencies', () {
    expect(CountryCatalog.suggestedCurrency('GB'), 'GBP');
    expect(CountryCatalog.suggestedCurrency('AU'), 'AUD');
    expect(CountryCatalog.suggestedCurrency('ZA'), 'ZAR');
    expect(CountryCatalog.suggestedCurrency('UG'), 'UGX');
    expect(CountryCatalog.suggestedCurrency('KE'), 'KES');
    expect(CountryCatalog.suggestedCurrency('NG'), 'NGN');
    expect(CountryCatalog.suggestedCurrency('US'), 'USD');
    expect(CountryCatalog.suggestedCurrency('CA'), 'CAD');
    expect(CountryCatalog.suggestedCurrency('NZ'), 'NZD');
    expect(CountryCatalog.suggestedCurrency('IE'), 'EUR');
  });

  test('maps supported countries to locales without limiting other values', () {
    expect(CountryCatalog.suggestedLocale('GB'), 'en_GB');
    expect(CountryCatalog.suggestedLocale('UG'), 'en_UG');
    expect(CountryCatalog.suggestedLocale('US'), 'en_US');
    expect(CountryCatalog.suggestedLocale('BR'), 'en');
  });
}
