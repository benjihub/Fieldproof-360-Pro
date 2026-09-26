enum ReportSignatureType {
  technician('technician', 'Technician'),
  customer('customer', 'Customer');

  const ReportSignatureType(this.databaseValue, this.displayLabel);

  final String databaseValue;
  final String displayLabel;

  static ReportSignatureType fromDatabase(String value) => switch (value) {
    'technician' => ReportSignatureType.technician,
    'customer' => ReportSignatureType.customer,
    _ => throw ArgumentError.value(value, 'value', 'Unknown signature type'),
  };
}
