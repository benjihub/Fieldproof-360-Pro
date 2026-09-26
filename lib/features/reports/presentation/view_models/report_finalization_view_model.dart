import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_repository.dart';
import 'package:fieldproof_360/features/reports/domain/services/report_finalization_validator.dart';

final class ReportFinalizationViewModel {
  const ReportFinalizationViewModel(this._repository);

  final ReportRepository _repository;

  Future<ReportFinalizationValidation> validate(String reportId) =>
      _repository.validateFinalization(reportId);

  Future<Report> finalize(String reportId) =>
      _repository.finalizeReport(reportId);

  Future<Report> duplicateAsDraft(String reportId) =>
      _repository.duplicateAsDraft(reportId);
}
