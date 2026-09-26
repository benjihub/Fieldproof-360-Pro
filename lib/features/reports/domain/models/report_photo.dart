import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';

final class ReportPhoto {
  const ReportPhoto({
    required this.id,
    required this.reportId,
    required this.filePath,
    required this.category,
    required this.sortOrder,
    required this.createdAt,
    this.thumbnailPath,
    this.caption,
  });

  final String id;
  final String reportId;
  final String filePath;
  final String? thumbnailPath;
  final ReportPhotoCategory category;
  final String? caption;
  final int sortOrder;
  final DateTime createdAt;
}
