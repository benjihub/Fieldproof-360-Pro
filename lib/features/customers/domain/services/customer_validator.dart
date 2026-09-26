import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';

abstract final class CustomerValidator {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static Map<String, String> validate(CustomerFormData input) {
    final errors = <String, String>{};
    if (input.name.trim().isEmpty) {
      errors['name'] = 'Enter the customer name.';
    }

    final email = input.email.trim();
    if (email.isNotEmpty && !_emailPattern.hasMatch(email)) {
      errors['email'] = 'Enter a valid email address.';
    }
    return errors;
  }

  static CustomerFormData normalize(CustomerFormData input) => CustomerFormData(
    name: input.name.trim(),
    companyName: input.companyName.trim(),
    phone: input.phone.trim(),
    email: input.email.trim(),
    address: input.address.trim(),
    notes: input.notes.trim(),
  );

  static String? optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
