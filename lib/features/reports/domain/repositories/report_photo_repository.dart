import 'package:fieldproof_360/features/reports/domain/models/report_photo.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';

abstract interface class ReportPhotoRepository {
  Stream<List<ReportPhoto>> watchPhotos(String reportId);

  Future<List<ReportPhoto>> getPhotos(String reportId);

  Future<ReportPhoto> importPhoto({
    required String reportId,
    required String sourcePath,
    required ReportPhotoCategory category,
    String? caption,
  });

  Future<ReportPhoto> updatePhoto({
    required String photoId,
    required ReportPhotoCategory category,
    String? caption,
  });

  Future<void> reorderPhotos({
    required String reportId,
    required ReportPhotoCategory category,
    required List<String> orderedPhotoIds,
  });

  Future<void> deletePhoto(String photoId);
}
