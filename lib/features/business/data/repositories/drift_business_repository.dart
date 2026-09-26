import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/business/data/mappers/business_profile_mapper.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/business/domain/repositories/business_repository.dart';
import 'package:uuid/uuid.dart';

final class DriftBusinessRepository implements BusinessRepository {
  DriftBusinessRepository(this._database, [this._uuid = const Uuid()]);

  final AppDatabase _database;
  final Uuid _uuid;

  @override
  Stream<BusinessProfile?> watchBusinessProfile() {
    final query = _database.select(_database.businessProfiles)..limit(1);
    return query.watchSingleOrNull().map((entity) => entity?.toDomain());
  }

  @override
  Future<BusinessProfile?> getBusinessProfile() async {
    try {
      final query = _database.select(_database.businessProfiles)..limit(1);
      return (await query.getSingleOrNull())?.toDomain();
    } catch (error) {
      throw DatabaseException(
        'Could not load the business profile.',
        cause: error,
      );
    }
  }

  @override
  Future<bool> hasBusinessProfile() async => await getBusinessProfile() != null;

  @override
  Future<BusinessProfile> saveBusinessProfile(BusinessProfile profile) async {
    try {
      final existing = await getBusinessProfile();
      final now = DateTime.now().toUtc();
      final saved = BusinessProfile(
        id: existing?.id ?? (profile.id.isEmpty ? _uuid.v4() : profile.id),
        businessName: profile.businessName.trim(),
        technicianName: profile.technicianName.trim(),
        email: _optional(profile.email),
        phone: _optional(profile.phone),
        address: _optional(profile.address),
        countryCode: profile.countryCode.trim().toUpperCase(),
        currencyCode: profile.currencyCode.trim().toUpperCase(),
        localeCode: profile.localeCode.trim(),
        logoPath: _optional(profile.logoPath),
        taxLabel: _optional(profile.taxLabel),
        taxNumber: _optional(profile.taxNumber),
        reportPrefix: profile.reportPrefix.trim().toUpperCase(),
        defaultTerms: _optional(profile.defaultTerms),
        createdAt: existing?.createdAt ?? profile.createdAt.toUtc(),
        updatedAt: now,
      );

      await _database
          .into(_database.businessProfiles)
          .insertOnConflictUpdate(saved.toCompanion());
      return saved;
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException(
        'Could not save the business profile.',
        cause: error,
      );
    }
  }

  String? _optional(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
