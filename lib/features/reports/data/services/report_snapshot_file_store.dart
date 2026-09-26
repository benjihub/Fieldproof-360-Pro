import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

typedef SnapshotSupportDirectoryResolver = Future<Directory> Function();

final class ReportSnapshotFileStore {
  ReportSnapshotFileStore({SnapshotSupportDirectoryResolver? supportDirectory})
    : _supportDirectory = supportDirectory ?? getApplicationSupportDirectory;

  final SnapshotSupportDirectoryResolver _supportDirectory;

  Future<String?> copyBusinessLogo({
    required String reportId,
    required String? sourcePath,
  }) async {
    if (sourcePath == null || sourcePath.trim().isEmpty) return null;
    final source = File(sourcePath);
    if (!await source.exists()) return null;
    final root = await _supportDirectory();
    final directory = Directory(
      p.join(root.path, 'fieldproof', 'reports', reportId, 'snapshot'),
    );
    await directory.create(recursive: true);
    final extension = p.extension(source.path).isEmpty
        ? '.image'
        : p.extension(source.path);
    final destination = File(p.join(directory.path, 'business-logo$extension'));
    await source.copy(destination.path);
    return destination.path;
  }

  Future<void> deleteSnapshotFile(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // Best-effort cleanup only.
    }
  }
}
