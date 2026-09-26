import 'package:fieldproof_360/features/reports/domain/models/report_access_policy.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('report snapshot JSON round-trips all frozen report sections', () {
    final finalizedAt = DateTime.utc(2026, 9, 24, 16);
    final snapshot = ReportSnapshot(
      schemaVersion: ReportSnapshot.currentSchemaVersion,
      finalizedAt: finalizedAt,
      report: ReportSnapshotReport(
        number: 'FP-2026-0001',
        type: ReportType.maintenance,
        title: 'Generator service',
        siteAddress: 'Kampala',
        issueReported: 'Shuts down',
        diagnosis: 'Blocked filter',
        workPerformed: 'Replaced filter',
        recommendations: 'Service quarterly',
        internalNotes: 'Internal only',
        startedAt: finalizedAt.subtract(const Duration(hours: 2)),
        completedAt: finalizedAt,
        createdAt: finalizedAt.subtract(const Duration(days: 1)),
        updatedAt: finalizedAt,
        finalizedAt: finalizedAt,
      ),
      business: const ReportSnapshotBusiness(
        businessName: 'Field Services',
        technicianName: 'Benjamin',
        countryCode: 'UG',
        currencyCode: 'UGX',
        localeCode: 'en_UG',
        reportPrefix: 'FP',
      ),
      customer: const ReportSnapshotCustomer(name: 'Amina'),
      equipment: const ReportSnapshotEquipment(name: 'Generator'),
      materials: const [
        ReportSnapshotMaterial(name: 'Fuel filter', quantity: 1, sortOrder: 0),
      ],
      photos: [
        ReportSnapshotPhoto(
          filePath: '/report/before.jpg',
          category: ReportPhotoCategory.before,
          sortOrder: 0,
          createdAt: finalizedAt,
        ),
      ],
      signatures: [
        ReportSnapshotSignature(
          type: ReportSignatureType.technician,
          signerName: 'Benjamin',
          filePath: '/report/signature.png',
          signedAt: finalizedAt,
        ),
      ],
      templateId: 'classic',
    );

    final restored = ReportSnapshot.fromJsonString(snapshot.toJsonString());

    expect(restored.schemaVersion, 1);
    expect(restored.report.number, 'FP-2026-0001');
    expect(restored.report.type, ReportType.maintenance);
    expect(restored.business.businessName, 'Field Services');
    expect(restored.customer?.name, 'Amina');
    expect(restored.materials.single.name, 'Fuel filter');
    expect(restored.photos.single.category, ReportPhotoCategory.before);
    expect(restored.signatures.single.type, ReportSignatureType.technician);
    expect(restored.finalizedAt, finalizedAt);
  });

  test('access policy foundation can defer or enforce the free quota', () {
    const usage = UsageCounter(year: 2026, month: 9, finalizedReportCount: 3);

    expect(const ReportAccessPolicy().canFinalize(usage), isTrue);
    expect(
      const ReportAccessPolicy(enforceFreeLimit: true).canFinalize(usage),
      isFalse,
    );
    expect(
      const ReportAccessPolicy(
        isPro: true,
        enforceFreeLimit: true,
      ).canFinalize(usage),
      isTrue,
    );
    expect(const ReportAccessPolicy().remainingFreeReports(usage), 0);
  });
}
