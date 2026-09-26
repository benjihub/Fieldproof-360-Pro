import 'dart:io';
import 'dart:typed_data';

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final class StoredReportPhotoFiles {
  const StoredReportPhotoFiles({
    required this.filePath,
    required this.thumbnailPath,
  });

  final String filePath;
  final String? thumbnailPath;
}

typedef SupportDirectoryResolver = Future<Directory> Function();

final class ReportPhotoFileStore {
  ReportPhotoFileStore({SupportDirectoryResolver? supportDirectory})
    : _supportDirectory = supportDirectory ?? getApplicationSupportDirectory;

  static const _maxOriginalDimension = 2400;
  static const _thumbnailDimension = 512;

  final SupportDirectoryResolver _supportDirectory;

  Future<StoredReportPhotoFiles> importPhoto({
    required String reportId,
    required String photoId,
    required String sourcePath,
  }) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw const FileStorageException('Selected photo could not be found.');
    }

    final reportRoot = await _reportRoot(reportId);
    final originalDirectory = Directory(
      p.join(reportRoot.path, 'photos', 'original'),
    );
    final thumbnailDirectory = Directory(
      p.join(reportRoot.path, 'photos', 'thumbnails'),
    );

    try {
      await originalDirectory.create(recursive: true);
      await thumbnailDirectory.create(recursive: true);

      final bytes = await source.readAsBytes();
      final decoded = _tryDecodeImage(bytes);

      if (decoded != null) {
        final oriented = img.bakeOrientation(decoded);
        final normalized = _resizeToFit(oriented, _maxOriginalDimension);
        final thumbnail = _resizeToFit(oriented, _thumbnailDimension);
        final destination = File(
          p.join(originalDirectory.path, '$photoId.jpg'),
        );
        final thumbnailFile = File(
          p.join(thumbnailDirectory.path, '$photoId.jpg'),
        );

        await destination.writeAsBytes(
          Uint8List.fromList(img.encodeJpg(normalized, quality: 90)),
          flush: true,
        );
        await thumbnailFile.writeAsBytes(
          Uint8List.fromList(img.encodeJpg(thumbnail, quality: 78)),
          flush: true,
        );
        return StoredReportPhotoFiles(
          filePath: destination.path,
          thumbnailPath: thumbnailFile.path,
        );
      }

      // Some platform image formats (for example HEIC on certain devices) may
      // not be decodable by the pure-Dart image package. Keep the app-owned
      // original so the platform can still display it; PDF processing can
      // handle/convert unsupported formats in a later phase.
      final extension = _safeExtension(sourcePath);
      final destination = File(
        p.join(originalDirectory.path, '$photoId$extension'),
      );
      await source.copy(destination.path);
      return StoredReportPhotoFiles(
        filePath: destination.path,
        thumbnailPath: null,
      );
    } on AppException {
      rethrow;
    } catch (error) {
      throw FileStorageException(
        'Could not store the selected photo.',
        cause: error,
      );
    }
  }

  Future<void> deleteFiles({
    required String filePath,
    String? thumbnailPath,
  }) async {
    for (final path in {filePath, ?thumbnailPath}) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } on FileSystemException {
        // Best-effort cleanup. Database state remains the source of truth.
      }
    }
  }

  Future<Directory> _reportRoot(String reportId) async {
    final root = await _supportDirectory();
    return Directory(p.join(root.path, 'fieldproof', 'reports', reportId));
  }

  img.Image _resizeToFit(img.Image source, int maxDimension) {
    if (source.width <= maxDimension && source.height <= maxDimension) {
      return img.Image.from(source);
    }
    if (source.width >= source.height) {
      return img.copyResize(source, width: maxDimension);
    }
    return img.copyResize(source, height: maxDimension);
  }

  img.Image? _tryDecodeImage(Uint8List bytes) {
    try {
      return img.decodeImage(bytes);
    } catch (_) {
      return null;
    }
  }

  String _safeExtension(String sourcePath) {
    final extension = p.extension(sourcePath).toLowerCase();
    const allowed = {'.jpg', '.jpeg', '.png', '.webp', '.heic', '.heif'};
    return allowed.contains(extension) ? extension : '.image';
  }
}
