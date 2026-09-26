import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_photo_repository.dart';
import 'package:fieldproof_360/features/reports/data/services/report_image_picker.dart';
import 'package:fieldproof_360/features/reports/data/services/report_photo_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_photo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportPhotoFileStoreProvider = Provider<ReportPhotoFileStore>(
  (ref) => ReportPhotoFileStore(),
);

final reportPhotoRepositoryProvider = Provider<ReportPhotoRepository>(
  (ref) => DriftReportPhotoRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(reportPhotoFileStoreProvider),
  ),
);

final reportImagePickerProvider = Provider<ReportImagePicker>(
  (ref) => ImagePickerReportImagePicker(),
);

final reportPhotosProvider = StreamProvider.family<List<ReportPhoto>, String>(
  (ref, reportId) =>
      ref.watch(reportPhotoRepositoryProvider).watchPhotos(reportId),
);
