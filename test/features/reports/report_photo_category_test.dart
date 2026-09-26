import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('photo categories persist stable string values', () {
    for (final category in ReportPhotoCategory.values) {
      expect(
        ReportPhotoCategory.fromDatabase(category.databaseValue),
        category,
      );
    }
    expect(ReportPhotoCategory.before.displayLabel, 'Before');
    expect(ReportPhotoCategory.during.displayLabel, 'During');
    expect(ReportPhotoCategory.after.displayLabel, 'After');
    expect(
      ReportPhotoCategory.fromDatabase('future-category'),
      ReportPhotoCategory.general,
    );
  });
}
