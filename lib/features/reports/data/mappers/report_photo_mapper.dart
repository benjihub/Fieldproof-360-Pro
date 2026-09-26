import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';

extension ReportPhotoEntityMapper on ReportPhotoEntity {
  ReportPhoto toDomain() => ReportPhoto(
    id: id,
    reportId: reportId,
    filePath: filePath,
    thumbnailPath: thumbnailPath,
    category: ReportPhotoCategory.fromDatabase(category),
    caption: caption,
    sortOrder: sortOrder,
    createdAt: createdAt.toUtc(),
  );
}
