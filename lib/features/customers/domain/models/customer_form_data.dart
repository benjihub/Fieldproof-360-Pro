final class CustomerFormData {
  const CustomerFormData({
    required this.name,
    this.companyName = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.notes = '',
  });

  final String name;
  final String companyName;
  final String phone;
  final String email;
  final String address;
  final String notes;
}
