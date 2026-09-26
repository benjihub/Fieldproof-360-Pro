import 'package:fieldproof_360/core/services/native_share_service.dart';
import 'package:flutter/material.dart';

Rect? sharePositionOriginFor(BuildContext context) {
  final renderObject = context.findRenderObject();
  if (renderObject is! RenderBox || !renderObject.hasSize) return null;
  final topLeft = renderObject.localToGlobal(Offset.zero);
  final rect = topLeft & renderObject.size;
  return rect.width > 0 && rect.height > 0 ? rect : null;
}

String? shareOutcomeMessage(NativeShareOutcome outcome) => switch (outcome) {
  NativeShareOutcome.success => 'Report shared.',
  NativeShareOutcome.dismissed => null,
  NativeShareOutcome.unavailable => 'Sharing is unavailable on this device.',
};
