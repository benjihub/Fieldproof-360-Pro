import 'package:drift/drift.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_status.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';

extension ReportEntityMapper on ReportEntity {
  Report toDomain() => Report(
    id: id,
    reportNumber: reportNumber,
    customerId: customerId,
    reportType: ReportType.fromDatabase(reportType),
    status: ReportStatus.fromDatabase(status),
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
    startedAt: startedAt?.toUtc(),
    completedAt: completedAt?.toUtc(),
    finalizedAt: finalizedAt?.toUtc(),
    finalizedSnapshotJson: finalizedSnapshotJson,
    pdfTemplateId: pdfTemplateId,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
    archivedAt: archivedAt?.toUtc(),
  );
}

extension ReportDomainMapper on Report {
  ReportsCompanion toCompanion() => ReportsCompanion(
    id: Value(id),
    reportNumber: Value(reportNumber),
    customerId: Value(customerId),
    reportType: Value(reportType.databaseValue),
    status: Value(status.databaseValue),
    title: Value(title),
    siteAddress: Value(siteAddress),
    equipmentName: Value(equipmentName),
    equipmentManufacturer: Value(equipmentManufacturer),
    equipmentModel: Value(equipmentModel),
    equipmentSerial: Value(equipmentSerial),
    issueReported: Value(issueReported),
    diagnosis: Value(diagnosis),
    workPerformed: Value(workPerformed),
    recommendations: Value(recommendations),
    internalNotes: Value(internalNotes),
    startedAt: Value(startedAt?.toUtc()),
    completedAt: Value(completedAt?.toUtc()),
    finalizedAt: Value(finalizedAt?.toUtc()),
    finalizedSnapshotJson: Value(finalizedSnapshotJson),
    pdfTemplateId: Value(pdfTemplateId),
    createdAt: Value(createdAt.toUtc()),
    updatedAt: Value(updatedAt.toUtc()),
    archivedAt: Value(archivedAt?.toUtc()),
  );
}
