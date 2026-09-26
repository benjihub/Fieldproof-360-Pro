import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_signature_repository.dart';
import 'package:fieldproof_360/features/reports/data/services/report_signature_file_store.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_signature_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportSignatureFileStoreProvider = Provider<ReportSignatureFileStore>(
  (ref) => ReportSignatureFileStore(),
);

final reportSignatureRepositoryProvider = Provider<ReportSignatureRepository>(
  (ref) => DriftReportSignatureRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(reportSignatureFileStoreProvider),
  ),
);

final reportSignaturesProvider =
    StreamProvider.family<List<ReportSignature>, String>(
      (ref, reportId) => ref
          .watch(reportSignatureRepositoryProvider)
          .watchSignatures(reportId),
    );
