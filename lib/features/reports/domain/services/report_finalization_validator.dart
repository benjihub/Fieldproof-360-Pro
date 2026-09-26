import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';

final class ReportFinalizationValidation {
  const ReportFinalizationValidation(this.errors);

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}

abstract final class ReportFinalizationValidator {
  static ReportFinalizationValidation validate({
    required Report report,
    required BusinessProfile business,
  }) {
    final errors = <String>[];
    if (!report.isDraft || report.archivedAt != null) {
      errors.add('Only an active draft report can be finalized.');
    }
    if (business.businessName.trim().isEmpty) {
      errors.add('Business name is required.');
    }
    if (business.technicianName.trim().isEmpty) {
      errors.add('Technician name is required.');
    }
    if (report.title.trim().isEmpty) {
      errors.add('Report title is required.');
    }
    if (report.workPerformed.trim().isEmpty) {
      errors.add('Work performed is required.');
    }
    if (business.reportPrefix.trim().isEmpty) {
      errors.add('Report prefix is required.');
    }
    return ReportFinalizationValidation(List.unmodifiable(errors));
  }
}
