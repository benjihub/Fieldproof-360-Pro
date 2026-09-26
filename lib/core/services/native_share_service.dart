import 'dart:ui' show Rect;

import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:share_plus/share_plus.dart';

enum NativeShareOutcome { success, dismissed, unavailable }

abstract interface class NativeShareService {
  Future<NativeShareOutcome> shareFile({
    required String path,
    required String mimeType,
    required String title,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  });
}

final class SharePlusNativeShareService implements NativeShareService {
  const SharePlusNativeShareService();

  @override
  Future<NativeShareOutcome> shareFile({
    required String path,
    required String mimeType,
    required String title,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path, mimeType: mimeType)],
          title: title,
          subject: subject,
          text: text,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
      return switch (result.status) {
        ShareResultStatus.success => NativeShareOutcome.success,
        ShareResultStatus.dismissed => NativeShareOutcome.dismissed,
        ShareResultStatus.unavailable => NativeShareOutcome.unavailable,
      };
    } catch (error) {
      throw AppException('Could not open the share sheet.', cause: error);
    }
  }
}
