import 'dart:convert';

import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';

final class ReportSnapshot {
  const ReportSnapshot({
    required this.schemaVersion,
    required this.finalizedAt,
    required this.report,
    required this.business,
    required this.equipment,
    required this.materials,
    required this.photos,
    required this.signatures,
    required this.templateId,
    this.customer,
  });

  static const currentSchemaVersion = 1;

  final int schemaVersion;
  final DateTime finalizedAt;
  final ReportSnapshotReport report;
  final ReportSnapshotBusiness business;
  final ReportSnapshotCustomer? customer;
  final ReportSnapshotEquipment equipment;
  final List<ReportSnapshotMaterial> materials;
  final List<ReportSnapshotPhoto> photos;
  final List<ReportSnapshotSignature> signatures;
  final String templateId;

  String toJsonString() => jsonEncode(toJson());

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'finalizedAt': finalizedAt.toUtc().toIso8601String(),
    'report': report.toJson(),
    'business': business.toJson(),
    'customer': customer?.toJson(),
    'equipment': equipment.toJson(),
    'materials': materials.map((item) => item.toJson()).toList(),
    'photos': photos.map((item) => item.toJson()).toList(),
    'signatures': signatures.map((item) => item.toJson()).toList(),
    'templateId': templateId,
  };

  factory ReportSnapshot.fromJsonString(String source) =>
      ReportSnapshot.fromJson(jsonDecode(source) as Map<String, dynamic>);

  factory ReportSnapshot.fromJson(Map<String, dynamic> json) => ReportSnapshot(
    schemaVersion: json['schemaVersion'] as int,
    finalizedAt: DateTime.parse(json['finalizedAt'] as String).toUtc(),
    report: ReportSnapshotReport.fromJson(
      json['report'] as Map<String, dynamic>,
    ),
    business: ReportSnapshotBusiness.fromJson(
      json['business'] as Map<String, dynamic>,
    ),
    customer: json['customer'] == null
        ? null
        : ReportSnapshotCustomer.fromJson(
            json['customer'] as Map<String, dynamic>,
          ),
    equipment: ReportSnapshotEquipment.fromJson(
      json['equipment'] as Map<String, dynamic>,
    ),
    materials: (json['materials'] as List<dynamic>)
        .map(
          (item) =>
              ReportSnapshotMaterial.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false),
    photos: (json['photos'] as List<dynamic>)
        .map(
          (item) => ReportSnapshotPhoto.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false),
    signatures: (json['signatures'] as List<dynamic>)
        .map(
          (item) =>
              ReportSnapshotSignature.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false),
    templateId: json['templateId'] as String,
  );
}

final class ReportSnapshotReport {
  const ReportSnapshotReport({
    required this.number,
    required this.type,
    required this.title,
    required this.workPerformed,
    required this.createdAt,
    required this.updatedAt,
    required this.finalizedAt,
    this.siteAddress,
    this.issueReported,
    this.diagnosis,
    this.recommendations,
    this.internalNotes,
    this.startedAt,
    this.completedAt,
  });

  final String number;
  final ReportType type;
  final String title;
  final String? siteAddress;
  final String? issueReported;
  final String? diagnosis;
  final String workPerformed;
  final String? recommendations;
  final String? internalNotes;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime finalizedAt;

  Map<String, Object?> toJson() => {
    'number': number,
    'type': type.databaseValue,
    'title': title,
    'siteAddress': siteAddress,
    'issueReported': issueReported,
    'diagnosis': diagnosis,
    'workPerformed': workPerformed,
    'recommendations': recommendations,
    'internalNotes': internalNotes,
    'startedAt': startedAt?.toUtc().toIso8601String(),
    'completedAt': completedAt?.toUtc().toIso8601String(),
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'finalizedAt': finalizedAt.toUtc().toIso8601String(),
  };

  factory ReportSnapshotReport.fromJson(Map<String, dynamic> json) =>
      ReportSnapshotReport(
        number: json['number'] as String,
        type: ReportType.fromDatabase(json['type'] as String),
        title: json['title'] as String,
        siteAddress: json['siteAddress'] as String?,
        issueReported: json['issueReported'] as String?,
        diagnosis: json['diagnosis'] as String?,
        workPerformed: json['workPerformed'] as String,
        recommendations: json['recommendations'] as String?,
        internalNotes: json['internalNotes'] as String?,
        startedAt: _date(json['startedAt']),
        completedAt: _date(json['completedAt']),
        createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
        updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
        finalizedAt: DateTime.parse(json['finalizedAt'] as String).toUtc(),
      );
}

final class ReportSnapshotBusiness {
  const ReportSnapshotBusiness({
    required this.businessName,
    required this.technicianName,
    required this.countryCode,
    required this.currencyCode,
    required this.localeCode,
    required this.reportPrefix,
    this.email,
    this.phone,
    this.address,
    this.logoPath,
    this.taxLabel,
    this.taxNumber,
    this.defaultTerms,
  });

  final String businessName;
  final String technicianName;
  final String? email;
  final String? phone;
  final String? address;
  final String countryCode;
  final String currencyCode;
  final String localeCode;
  final String? logoPath;
  final String? taxLabel;
  final String? taxNumber;
  final String reportPrefix;
  final String? defaultTerms;

  Map<String, Object?> toJson() => {
    'businessName': businessName,
    'technicianName': technicianName,
    'email': email,
    'phone': phone,
    'address': address,
    'countryCode': countryCode,
    'currencyCode': currencyCode,
    'localeCode': localeCode,
    'logoPath': logoPath,
    'taxLabel': taxLabel,
    'taxNumber': taxNumber,
    'reportPrefix': reportPrefix,
    'defaultTerms': defaultTerms,
  };

  factory ReportSnapshotBusiness.fromJson(Map<String, dynamic> json) =>
      ReportSnapshotBusiness(
        businessName: json['businessName'] as String,
        technicianName: json['technicianName'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        countryCode: json['countryCode'] as String,
        currencyCode: json['currencyCode'] as String,
        localeCode: json['localeCode'] as String,
        logoPath: json['logoPath'] as String?,
        taxLabel: json['taxLabel'] as String?,
        taxNumber: json['taxNumber'] as String?,
        reportPrefix: json['reportPrefix'] as String,
        defaultTerms: json['defaultTerms'] as String?,
      );
}

final class ReportSnapshotCustomer {
  const ReportSnapshotCustomer({
    required this.name,
    this.companyName,
    this.phone,
    this.email,
    this.address,
  });

  final String name;
  final String? companyName;
  final String? phone;
  final String? email;
  final String? address;

  Map<String, Object?> toJson() => {
    'name': name,
    'companyName': companyName,
    'phone': phone,
    'email': email,
    'address': address,
  };

  factory ReportSnapshotCustomer.fromJson(Map<String, dynamic> json) =>
      ReportSnapshotCustomer(
        name: json['name'] as String,
        companyName: json['companyName'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
      );
}

final class ReportSnapshotEquipment {
  const ReportSnapshotEquipment({
    this.name,
    this.manufacturer,
    this.model,
    this.serial,
  });

  final String? name;
  final String? manufacturer;
  final String? model;
  final String? serial;

  Map<String, Object?> toJson() => {
    'name': name,
    'manufacturer': manufacturer,
    'model': model,
    'serial': serial,
  };

  factory ReportSnapshotEquipment.fromJson(Map<String, dynamic> json) =>
      ReportSnapshotEquipment(
        name: json['name'] as String?,
        manufacturer: json['manufacturer'] as String?,
        model: json['model'] as String?,
        serial: json['serial'] as String?,
      );
}

final class ReportSnapshotMaterial {
  const ReportSnapshotMaterial({
    required this.name,
    required this.quantity,
    required this.sortOrder,
    this.unit,
    this.notes,
  });

  final String name;
  final double quantity;
  final String? unit;
  final String? notes;
  final int sortOrder;

  Map<String, Object?> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'notes': notes,
    'sortOrder': sortOrder,
  };

  factory ReportSnapshotMaterial.fromJson(Map<String, dynamic> json) =>
      ReportSnapshotMaterial(
        name: json['name'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] as String?,
        notes: json['notes'] as String?,
        sortOrder: json['sortOrder'] as int,
      );
}

final class ReportSnapshotPhoto {
  const ReportSnapshotPhoto({
    required this.filePath,
    required this.category,
    required this.sortOrder,
    required this.createdAt,
    this.thumbnailPath,
    this.caption,
  });

  final String filePath;
  final String? thumbnailPath;
  final ReportPhotoCategory category;
  final String? caption;
  final int sortOrder;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'filePath': filePath,
    'thumbnailPath': thumbnailPath,
    'category': category.databaseValue,
    'caption': caption,
    'sortOrder': sortOrder,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };

  factory ReportSnapshotPhoto.fromJson(Map<String, dynamic> json) =>
      ReportSnapshotPhoto(
        filePath: json['filePath'] as String,
        thumbnailPath: json['thumbnailPath'] as String?,
        category: ReportPhotoCategory.fromDatabase(json['category'] as String),
        caption: json['caption'] as String?,
        sortOrder: json['sortOrder'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      );
}

final class ReportSnapshotSignature {
  const ReportSnapshotSignature({
    required this.type,
    required this.signerName,
    required this.filePath,
    required this.signedAt,
  });

  final ReportSignatureType type;
  final String signerName;
  final String filePath;
  final DateTime signedAt;

  Map<String, Object?> toJson() => {
    'type': type.databaseValue,
    'signerName': signerName,
    'filePath': filePath,
    'signedAt': signedAt.toUtc().toIso8601String(),
  };

  factory ReportSnapshotSignature.fromJson(Map<String, dynamic> json) =>
      ReportSnapshotSignature(
        type: ReportSignatureType.fromDatabase(json['type'] as String),
        signerName: json['signerName'] as String,
        filePath: json['filePath'] as String,
        signedAt: DateTime.parse(json['signedAt'] as String).toUtc(),
      );
}

DateTime? _date(Object? value) =>
    value == null ? null : DateTime.parse(value as String).toUtc();
