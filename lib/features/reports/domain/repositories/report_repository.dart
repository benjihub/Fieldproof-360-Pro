import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_draft_data.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';
import 'package:fieldproof_360/features/reports/domain/services/report_finalization_validator.dart';

abstract interface class ReportRepository {
  Stream<List<Report>> watchReports();

  Stream<Report?> watchReport(String id);

  Future<Report?> getReport(String id);

  Future<Report> createDraft({
    String? customerId,
    ReportType reportType = ReportType.service,
    String? title,
  });

  Future<Report> updateDraft(String id, ReportDraftData data);

  Future<ReportFinalizationValidation> validateFinalization(String id);

  Future<Report> finalizeReport(String id);

  Future<UsageCounter> getUsageCounter({DateTime? forMonth});

  Future<void> archiveReport(String id);

  Future<Report> duplicateAsDraft(String id);
}
