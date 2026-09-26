import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ReportStatus uses stable database strings and round-trips', () {
    for (final status in ReportStatus.values) {
      expect(ReportStatus.fromDatabase(status.databaseValue), status);
    }
    expect(ReportStatus.draft.databaseValue, 'draft');
    expect(ReportStatus.draft.displayLabel, 'Draft');
    expect(ReportStatus.finalized.databaseValue, 'finalized');
    expect(ReportStatus.finalized.displayLabel, 'Finalized');
    expect(ReportStatus.archived.databaseValue, 'archived');
    expect(ReportStatus.archived.displayLabel, 'Archived');
  });

  test('ReportType uses stable strings, labels, and round-trips', () {
    const expected = {
      ReportType.service: ('service', 'Service'),
      ReportType.maintenance: ('maintenance', 'Maintenance'),
      ReportType.inspection: ('inspection', 'Inspection'),
      ReportType.workCompletion: ('workCompletion', 'Work Completion'),
      ReportType.siteVisit: ('siteVisit', 'Site Visit'),
      ReportType.general: ('general', 'General'),
    };

    for (final entry in expected.entries) {
      expect(entry.key.databaseValue, entry.value.$1);
      expect(entry.key.displayLabel, entry.value.$2);
      expect(ReportType.fromDatabase(entry.value.$1), entry.key);
    }
  });

  test('unknown database enum values fail explicitly', () {
    expect(() => ReportStatus.fromDatabase('unknown'), throwsFormatException);
    expect(() => ReportType.fromDatabase('unknown'), throwsFormatException);
  });
}
