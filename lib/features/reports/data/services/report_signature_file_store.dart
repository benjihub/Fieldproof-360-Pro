import 'dart:io';
import 'dart:typed_data';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final class ReportSignatureFileStore {
  ReportSignatureFileStore({
    SignatureSupportDirectoryResolver? supportDirectory,
  }) : _supportDirectory = supportDirectory ?? getApplicationSupportDirectory;

  final SignatureSupportDirectoryResolver _supportDirectory;

  Future<String> writeSignature({
    required String reportId,
    required ReportSignatureType type,
    required String fileKey,
    required Uint8List pngBytes,
  }) async {
    if (pngBytes.isEmpty) {
      throw const FileStorageException('Signature image is empty.');
    }
    try {
      final root = await _supportDirectory();
      final directory = Directory(
        p.join(root.path, 'fieldproof', 'reports', reportId, 'signatures'),
      );
      await directory.create(recursive: true);
      final file = File(
        p.join(directory.path, '${type.databaseValue}-$fileKey.png'),
      );
      await file.writeAsBytes(pngBytes, flush: true);
      return file.path;
    } catch (error) {
      throw FileStorageException(
        'Could not store the signature.',
        cause: error,
      );
    }
  }

  Future<void> deleteSignature(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // Best-effort cleanup. Database state remains the source of truth.
    }
  }
}

typedef SignatureSupportDirectoryResolver = Future<Directory> Function();
