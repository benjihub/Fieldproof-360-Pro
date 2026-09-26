import 'package:fieldproof_360/core/services/native_share_service.dart';
import 'package:fieldproof_360/features/pdf/data/services/report_pdf_export_service.dart';
import 'package:fieldproof_360/features/pdf/domain/services/report_pdf_service.dart';
import 'package:fieldproof_360/features/pdf/presentation/view_models/report_pdf_share_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportPdfServiceProvider = Provider<ReportPdfService>(
  (ref) => const ReportPdfService(),
);

final reportPdfExportServiceProvider = Provider<ReportPdfExportService>(
  (ref) =>
      ReportPdfExportService(pdfService: ref.watch(reportPdfServiceProvider)),
);

final nativeShareServiceProvider = Provider<NativeShareService>(
  (ref) => const SharePlusNativeShareService(),
);

final reportPdfShareViewModelProvider = Provider<ReportPdfShareViewModel>(
  (ref) => ReportPdfShareViewModel(
    ref.watch(reportPdfExportServiceProvider),
    ref.watch(nativeShareServiceProvider),
  ),
);
