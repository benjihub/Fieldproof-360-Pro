import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';

final class ReportAccessPolicy {
  const ReportAccessPolicy({
    this.isPro = false,
    this.freeMonthlyLimit = 3,
    this.enforceFreeLimit = false,
  });

  final bool isPro;
  final int freeMonthlyLimit;
  final bool enforceFreeLimit;

  bool canFinalize(UsageCounter usage) =>
      isPro ||
      !enforceFreeLimit ||
      usage.finalizedReportCount < freeMonthlyLimit;

  int remainingFreeReports(UsageCounter usage) =>
      (freeMonthlyLimit - usage.finalizedReportCount)
          .clamp(0, freeMonthlyLimit)
          .toInt();
}
