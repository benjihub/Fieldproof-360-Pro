import 'dart:async';

import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_draft_controller.g.dart';

@riverpod
class CreateDraftController extends _$CreateDraftController {
  @override
  FutureOr<void> build() {}

  Future<Report?> create({
    String? customerId,
    ReportType reportType = ReportType.service,
    String? title,
  }) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    Report? created;
    state = await AsyncValue.guard(() async {
      created = await ref
          .read(reportRepositoryProvider)
          .createDraft(
            customerId: customerId,
            reportType: reportType,
            title: title,
          );
    });
    return state.hasError ? null : created;
  }
}
