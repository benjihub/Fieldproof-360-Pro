enum ReportStatus {
  draft('draft', 'Draft'),
  finalized('finalized', 'Finalized'),
  archived('archived', 'Archived');

  const ReportStatus(this.databaseValue, this.displayLabel);

  final String databaseValue;
  final String displayLabel;

  static ReportStatus fromDatabase(String value) => switch (value) {
    'draft' => ReportStatus.draft,
    'finalized' => ReportStatus.finalized,
    'archived' => ReportStatus.archived,
    _ => throw FormatException('Unknown report status: $value'),
  };
}
