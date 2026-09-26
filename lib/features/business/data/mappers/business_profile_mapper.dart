import 'package:drift/drift.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';

extension BusinessProfileEntityMapper on BusinessProfileEntity {
  BusinessProfile toDomain() => BusinessProfile(
    id: id,
    businessName: businessName,
    technicianName: technicianName,
    email: email,
    phone: phone,
    address: address,
    countryCode: countryCode,
    currencyCode: currencyCode,
    localeCode: localeCode,
    logoPath: logoPath,
    taxLabel: taxLabel,
    taxNumber: taxNumber,
    reportPrefix: reportPrefix,
    defaultTerms: defaultTerms,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

extension BusinessProfileDomainMapper on BusinessProfile {
  BusinessProfilesCompanion toCompanion() => BusinessProfilesCompanion(
    id: Value(id),
    businessName: Value(businessName),
    technicianName: Value(technicianName),
    email: Value(email),
    phone: Value(phone),
    address: Value(address),
    countryCode: Value(countryCode),
    currencyCode: Value(currencyCode),
    localeCode: Value(localeCode),
    logoPath: Value(logoPath),
    taxLabel: Value(taxLabel),
    taxNumber: Value(taxNumber),
    reportPrefix: Value(reportPrefix),
    defaultTerms: Value(defaultTerms),
    createdAt: Value(createdAt.toUtc()),
    updatedAt: Value(updatedAt.toUtc()),
  );
}
