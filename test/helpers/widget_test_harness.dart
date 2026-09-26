import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void testAppWidgets(String description, WidgetTesterCallback body) {
  testWidgets(description, (tester) async {
    try {
      await body(tester);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    }
  });
}

Future<void> scrollUntilBuilt(
  WidgetTester tester, {
  required Finder target,
  required Finder scrollView,
  int attempts = 12,
}) async {
  for (
    var attempt = 0;
    attempt < attempts && target.evaluate().isEmpty;
    attempt++
  ) {
    await tester.drag(scrollView, const Offset(0, -400));
    await tester.pump();
  }
  if (target.evaluate().isEmpty) {
    throw TestFailure('Timed out scrolling to $target.');
  }
  await tester.ensureVisible(target);
  await tester.pump();
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int attempts = 40,
}) async {
  for (var attempt = 0; attempt < attempts; attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out waiting for $finder.');
}
