import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/customers/domain/services/customer_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts a name and optional international phone', () {
    const input = CustomerFormData(
      name: 'Amina Okello',
      phone: '+256 (0) 700 123 456 ext 2',
    );

    expect(CustomerValidator.validate(input), isEmpty);
  });

  test('rejects a blank name', () {
    const input = CustomerFormData(name: '   ');

    expect(CustomerValidator.validate(input)['name'], isNotNull);
  });

  test('accepts valid optional email and rejects invalid email', () {
    expect(
      CustomerValidator.validate(
        const CustomerFormData(name: 'Amina', email: 'amina@example.com'),
      ),
      isEmpty,
    );
    expect(
      CustomerValidator.validate(
        const CustomerFormData(name: 'Amina', email: 'not-an-email'),
      )['email'],
      isNotNull,
    );
  });

  test('trims fields and normalizes empty optional values', () {
    final normalized = CustomerValidator.normalize(
      const CustomerFormData(
        name: '  Amina Okello  ',
        companyName: '  Field Services  ',
        phone: '   ',
        email: ' amina@example.com ',
      ),
    );

    expect(normalized.name, 'Amina Okello');
    expect(normalized.companyName, 'Field Services');
    expect(normalized.email, 'amina@example.com');
    expect(CustomerValidator.optional(normalized.phone), isNull);
  });
}
