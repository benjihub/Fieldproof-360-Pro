import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/business/data/repositories/drift_business_repository.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile.dart';
import 'package:fieldproof_360/features/business/domain/repositories/business_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_providers.g.dart';

@Riverpod(keepAlive: true)
BusinessRepository businessRepository(Ref ref) =>
    DriftBusinessRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
Future<BusinessProfile?> businessProfile(Ref ref) =>
    ref.watch(businessRepositoryProvider).getBusinessProfile();
