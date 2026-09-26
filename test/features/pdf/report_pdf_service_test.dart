import 'dart:convert';
import 'dart:io';

import 'package:fieldproof_360/features/pdf/domain/services/report_pdf_service.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates an A4 PDF from a finalized snapshot', () async {
    final directory = await Directory.systemTemp.createTemp('fieldproof_pdf_');
    addTearDown(() => directory.delete(recursive: true));
    final image = File('${directory.path}/pixel.png');
    await image.writeAsBytes(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9Z1ZkAAAAASUVORK5CYII=',
      ),
    );
    final snapshot = _snapshot(
      photoPath: image.path,
      signaturePath: image.path,
    );

    final bytes = await const ReportPdfService().generate(snapshot: snapshot);

    expect(bytes.length, greaterThan(100));
    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
  });

  test('missing media files do not prevent PDF generation', () async {
    final snapshot = _snapshot(
      photoPath: '/definitely/missing/photo.jpg',
      signaturePath: '/definitely/missing/signature.png',
    );

    final bytes = await const ReportPdfService().generate(snapshot: snapshot);

    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
  });

  test('creates a sanitized deterministic PDF filename', () {
    final snapshot = _snapshot(
      title: 'Kitchen / socket: repair?',
      photoPath: '/missing.jpg',
      signaturePath: '/missing.png',
    );

    expect(
      ReportPdfService.fileNameFor(snapshot),
      'FieldProof_360_Pro_BEN-2026-0001_Kitchen-socket-repair.pdf',
    );
  });
}

ReportSnapshot _snapshot({
  String title = 'Generator service',
  required String photoPath,
  required String signaturePath,
}) {
  final finalizedAt = DateTime.utc(2026, 9, 24, 14, 30);
  return ReportSnapshot(
    schemaVersion: ReportSnapshot.currentSchemaVersion,
    finalizedAt: finalizedAt,
    report: ReportSnapshotReport(
      number: 'BEN-2026-0001',
      type: ReportType.service,
      title: title,
      siteAddress: 'Kampala',
      issueReported: 'Generator shuts down after five minutes.',
      diagnosis: 'Restricted fuel supply.',
      workPerformed: 'Replaced the filter and tested the generator.',
      recommendations: 'Service again in three months.',
      internalNotes: 'This must never appear in the customer PDF.',
      completedAt: finalizedAt,
      createdAt: finalizedAt.subtract(const Duration(days: 1)),
      updatedAt: finalizedAt,
      finalizedAt: finalizedAt,
    ),
    business: const ReportSnapshotBusiness(
      businessName: 'Ben Engineering Services',
      technicianName: 'Benjamin',
      email: 'service@example.com',
      phone: '+256 700 000000',
      address: 'Kampala, Uganda',
      countryCode: 'UG',
      currencyCode: 'UGX',
      localeCode: 'en_UG',
      taxLabel: 'TIN',
      taxNumber: '12345',
      reportPrefix: 'BEN',
      defaultTerms: 'Thank you for your business.',
    ),
    customer: const ReportSnapshotCustomer(
      name: 'Amina Okello',
      companyName: 'Lake Services',
      phone: '+256 700 111111',
      address: 'Ntinda, Kampala',
    ),
    equipment: const ReportSnapshotEquipment(
      name: 'Generator',
      manufacturer: 'Firman',
      model: 'FPG7800E2',
      serial: 'GEN-123',
    ),
    materials: const [
      ReportSnapshotMaterial(
        name: 'Fuel filter',
        quantity: 1,
        unit: 'pc',
        notes: 'Replacement part',
        sortOrder: 0,
      ),
    ],
    photos: [
      ReportSnapshotPhoto(
        filePath: photoPath,
        category: ReportPhotoCategory.before,
        caption: 'Before repair',
        sortOrder: 0,
        createdAt: finalizedAt,
      ),
    ],
    signatures: [
      ReportSnapshotSignature(
        type: ReportSignatureType.technician,
        signerName: 'Benjamin',
        filePath: signaturePath,
        signedAt: finalizedAt,
      ),
      ReportSnapshotSignature(
        type: ReportSignatureType.customer,
        signerName: 'Amina Okello',
        filePath: signaturePath,
        signedAt: finalizedAt,
      ),
    ],
    templateId: 'classic',
  );
}
