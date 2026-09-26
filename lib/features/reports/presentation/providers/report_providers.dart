import 'package:fieldproof_360/data/database/database_provider.dart';
import 'package:fieldproof_360/features/reports/data/repositories/drift_report_repository.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_access_policy.dart';
import 'package:fieldproof_360/features/reports/domain/repositories/report_repository.dart';
import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/providers/subscription_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_providers.g.dart';

@Riverpod(keepAlive: true)
ReportAccessPolicy reportAccessPolicy(Ref ref) {
  final configured = ref.watch(subscriptionConfiguredProvider);
  final subscription = ref.watch(subscriptionStatusProvider);
  final isPro = subscription.asData?.value.isPro ?? false;
  return ReportAccessPolicy(isPro: isPro, enforceFreeLimit: configured);
}

@Riverpod(keepAlive: true)
ReportRepository reportRepository(Ref ref) => DriftReportRepository(
  ref.watch(appDatabaseProvider),
  accessPolicy: ref.watch(reportAccessPolicyProvider),
);

@riverpod
Stream<List<Report>> reportList(Ref ref) =>
    ref.watch(reportRepositoryProvider).watchReports();

@riverpod
Future<Report?> reportDetail(Ref ref, String reportId) =>
    ref.watch(reportRepositoryProvider).getReport(reportId);

@riverpod
Future<UsageCounter> currentReportUsage(Ref ref) =>
    ref.watch(reportRepositoryProvider).getUsageCounter();
