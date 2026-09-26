import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_draft_data.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';

final class Report {
  const Report({
    required this.id,
    required this.reportType,
    required this.status,
    required this.title,
    required this.workPerformed,
    required this.pdfTemplateId,
    required this.createdAt,
    required this.updatedAt,
    this.reportNumber,
    this.customerId,
    this.siteAddress,
    this.equipmentName,
    this.equipmentManufacturer,
    this.equipmentModel,
    this.equipmentSerial,
    this.issueReported,
    this.diagnosis,
    this.recommendations,
    this.internalNotes,
    this.startedAt,
    this.completedAt,
    this.finalizedAt,
    this.finalizedSnapshotJson,
    this.archivedAt,
  });

  factory Report.draft({
    required String id,
    String? customerId,
    ReportType reportType = ReportType.service,
    String title = '',
    String? siteAddress,
    String? equipmentName,
    String? equipmentManufacturer,
    String? equipmentModel,
    String? equipmentSerial,
    String? issueReported,
    String? diagnosis,
    String workPerformed = '',
    String? recommendations,
    String? internalNotes,
    DateTime? startedAt,
    DateTime? completedAt,
    String pdfTemplateId = 'classic',
    DateTime? createdAt,
  }) {
    final timestamp = (createdAt ?? DateTime.now()).toUtc();
    final data = ReportDraftData(
      customerId: customerId,
      reportType: reportType,
      title: title,
      siteAddress: siteAddress,
      equipmentName: equipmentName,
      equipmentManufacturer: equipmentManufacturer,
      equipmentModel: equipmentModel,
      equipmentSerial: equipmentSerial,
      issueReported: issueReported,
      diagnosis: diagnosis,
      workPerformed: workPerformed,
      recommendations: recommendations,
      internalNotes: internalNotes,
      startedAt: startedAt,
      completedAt: completedAt,
      pdfTemplateId: pdfTemplateId,
    ).normalized();
    return Report(
      id: id,
      customerId: data.customerId,
      reportType: data.reportType,
      status: ReportStatus.draft,
      title: data.title,
      siteAddress: data.siteAddress,
      equipmentName: data.equipmentName,
      equipmentManufacturer: data.equipmentManufacturer,
      equipmentModel: data.equipmentModel,
      equipmentSerial: data.equipmentSerial,
      issueReported: data.issueReported,
      diagnosis: data.diagnosis,
      workPerformed: data.workPerformed,
      recommendations: data.recommendations,
      internalNotes: data.internalNotes,
      startedAt: data.startedAt,
      completedAt: data.completedAt,
      pdfTemplateId: data.pdfTemplateId,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  final String id;
  final String? reportNumber;
  final String? customerId;
  final ReportType reportType;
  final ReportStatus status;
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
  final DateTime? finalizedAt;
  final String? finalizedSnapshotJson;
  final String pdfTemplateId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  bool get isDraft => status == ReportStatus.draft;
  bool get isFinalized => status == ReportStatus.finalized;
  bool get isArchived => status == ReportStatus.archived;

  ReportSnapshot? get snapshot {
    final source = finalizedSnapshotJson;
    if (source == null || source.isEmpty) return null;
    try {
      return ReportSnapshot.fromJsonString(source);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
