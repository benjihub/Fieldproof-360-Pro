final class ReportMaterial {
  const ReportMaterial({
    required this.id,
    required this.reportId,
    required this.name,
    required this.quantity,
    required this.sortOrder,
    this.unit,
    this.notes,
  });

  final String id;
  final String reportId;
  final String name;
  final double quantity;
  final String? unit;
  final String? notes;
  final int sortOrder;

  String get quantityLabel {
    final whole = quantity.truncateToDouble() == quantity;
    return whole ? quantity.toInt().toString() : quantity.toString();
  }
}
