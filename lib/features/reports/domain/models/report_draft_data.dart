import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';

final class ReportDraftData {
  const ReportDraftData({
    this.customerId,
    this.reportType = ReportType.service,
    this.title = '',
    this.siteAddress,
    this.equipmentName,
    this.equipmentManufacturer,
    this.equipmentModel,
    this.equipmentSerial,
    this.issueReported,
    this.diagnosis,
    this.workPerformed = '',
    this.recommendations,
    this.internalNotes,
    this.startedAt,
    this.completedAt,
    this.pdfTemplateId = 'classic',
  });

  final String? customerId;
  final ReportType reportType;
  final String title;
  final String? siteAddress;
  final String? equipmentName;
  final String? equipmentManufacturer;
  final String? equipmentModel;
  final String? equipmentSerial;
  final String? issueReported;
  final String? diagnosis;
  final String workPerformed;
  final String? recommendations;
  final String? internalNotes;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String pdfTemplateId;

  ReportDraftData normalized() {
    final template = pdfTemplateId.trim();
    return ReportDraftData(
      customerId: optional(customerId),
      reportType: reportType,
      title: title.trim(),
      siteAddress: optional(siteAddress),
      equipmentName: optional(equipmentName),
      equipmentManufacturer: optional(equipmentManufacturer),
      equipmentModel: optional(equipmentModel),
      equipmentSerial: optional(equipmentSerial),
      issueReported: optional(issueReported),
      diagnosis: optional(diagnosis),
      workPerformed: workPerformed.trim(),
      recommendations: optional(recommendations),
      internalNotes: optional(internalNotes),
      startedAt: startedAt?.toUtc(),
      completedAt: completedAt?.toUtc(),
      pdfTemplateId: template.isEmpty ? 'classic' : template,
    );
  }

  static String? optional(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
