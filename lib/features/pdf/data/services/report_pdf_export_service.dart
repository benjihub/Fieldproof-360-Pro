import 'dart:io';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/pdf/domain/services/report_pdf_service.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

typedef PdfExportSupportDirectoryResolver = Future<Directory> Function();

final class ReportPdfExportService {
  ReportPdfExportService({
    ReportPdfService? pdfService,
    PdfExportSupportDirectoryResolver? supportDirectory,
  }) : _pdfService = pdfService ?? const ReportPdfService(),
       _supportDirectory = supportDirectory ?? getApplicationSupportDirectory;

  final ReportPdfService _pdfService;
  final PdfExportSupportDirectoryResolver _supportDirectory;

  Future<File> export({
    required String reportId,
    required ReportSnapshot snapshot,
    bool showFieldProofBranding = true,
  }) async {
    if (reportId.trim().isEmpty) {
      throw const ValidationException(
        'A report ID is required to export a PDF.',
      );
    }

    final fileName = ReportPdfService.fileNameFor(snapshot);
    File? tempFile;
    try {
      final root = await _supportDirectory();
      final directory = Directory(
        p.join(root.path, 'fieldproof', 'reports', reportId, 'exports'),
      );
      await directory.create(recursive: true);

      final destination = File(p.join(directory.path, fileName));
      tempFile = File('${destination.path}.tmp');
      final bytes = await _pdfService.generate(
        snapshot: snapshot,
        showFieldProofBranding: showFieldProofBranding,
      );
      await tempFile.writeAsBytes(bytes, flush: true);

      if (await destination.exists()) {
        await destination.delete();
      }
      final exported = await tempFile.rename(destination.path);
      tempFile = null;
      await _removeStaleExports(directory, keepPath: exported.path);
      return exported;
    } on AppException {
      rethrow;
    } on FileSystemException catch (error) {
      throw FileStorageException(
        'Could not export the report PDF.',
        cause: error,
      );
    } catch (error) {
      throw AppException('Could not generate the report PDF.', cause: error);
    } finally {
      if (tempFile != null) {
        try {
          if (await tempFile.exists()) await tempFile.delete();
        } on FileSystemException {
          // Best-effort cleanup only.
        }
      }
    }
  }

  Future<void> _removeStaleExports(
    Directory directory, {
    required String keepPath,
  }) async {
    try {
      await for (final entity in directory.list()) {
        if (entity is! File || entity.path == keepPath) continue;
        if (p.extension(entity.path).toLowerCase() != '.pdf') continue;
        await entity.delete();
      }
    } on FileSystemException {
      // Export succeeded; stale-file cleanup is intentionally best effort.
    }
  }
}
