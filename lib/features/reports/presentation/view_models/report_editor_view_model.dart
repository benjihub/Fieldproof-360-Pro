import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_draft_data.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_repository.dart';

final class ReportEditorViewModel {
  const ReportEditorViewModel(this._repository);

  final ReportRepository _repository;

  Future<Report> saveDraft({
    required String reportId,
    required ReportDraftData data,
  }) => _repository.updateDraft(reportId, data);
}
