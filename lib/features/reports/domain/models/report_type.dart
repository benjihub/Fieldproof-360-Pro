enum ReportType {
  service('service', 'Service'),
  maintenance('maintenance', 'Maintenance'),
  inspection('inspection', 'Inspection'),
  workCompletion('workCompletion', 'Work Completion'),
  siteVisit('siteVisit', 'Site Visit'),
  general('general', 'General');

  const ReportType(this.databaseValue, this.displayLabel);

  final String databaseValue;
  final String displayLabel;

  static ReportType fromDatabase(String value) => switch (value) {
    'service' => ReportType.service,
    'maintenance' => ReportType.maintenance,
    'inspection' => ReportType.inspection,
    'workCompletion' => ReportType.workCompletion,
    'siteVisit' => ReportType.siteVisit,
    'general' => ReportType.general,
    _ => throw FormatException('Unknown report type: $value'),
  };
}
