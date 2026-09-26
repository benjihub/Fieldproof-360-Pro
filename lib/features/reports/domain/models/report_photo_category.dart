enum ReportPhotoCategory {
  before('before', 'Before'),
  during('during', 'During'),
  after('after', 'After'),
  issue('issue', 'Issue'),
  general('general', 'General');

  const ReportPhotoCategory(this.databaseValue, this.displayLabel);

  final String databaseValue;
  final String displayLabel;

  static ReportPhotoCategory fromDatabase(String value) => values.firstWhere(
    (item) => item.databaseValue == value,
    orElse: () => ReportPhotoCategory.general,
  );
}
