final class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.companyName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.archivedAt,
  });

  final String id;
  final String name;
  final String? companyName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;
}
