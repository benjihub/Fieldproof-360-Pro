import 'dart:math' as math;

import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/widgets/app_state_views.dart';
import 'package:fieldproof_360/core/widgets/responsive_content.dart';
import 'package:fieldproof_360/features/business/presentation/providers/business_providers.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/report_display.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_status.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/providers/subscription_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider);
    final reports = ref.watch(reportListProvider);
    final customers = ref.watch(customerListProvider(''));
    final subscription = ref.watch(subscriptionStatusProvider);
    final usage = ref.watch(currentReportUsageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: profile.when(
        loading: () => const AppLoadingView(label: 'Loading your workspace…'),
        error: (error, stackTrace) => AppErrorState(
          title: 'Workspace unavailable',
          message: 'Your business profile could not be loaded.',
          onRetry: () => ref.invalidate(businessProfileProvider),
        ),
        data: (value) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(businessProfileProvider);
            ref.invalidate(reportListProvider);
            ref.invalidate(customerListProvider(''));
            ref.invalidate(currentReportUsageProvider);
            ref.invalidate(subscriptionStatusProvider);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ResponsiveContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(
                      value?.technicianName ?? 'Field professional',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (value != null) ...[
                      const SizedBox(height: AppSpacing.xSmall),
                      Text(
                        value.businessName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.large),
                    _QuickActions(
                      onNewReport: () =>
                          context.goNamed(AppRoute.reportNew.name),
                      onAddCustomer: () =>
                          context.goNamed(AppRoute.customerNew.name),
                    ),
                    const SizedBox(height: AppSpacing.xLarge),
                    const AppSectionHeader(
                      title: 'Overview',
                      subtitle:
                          'A quick look at your FieldProof 360 Pro workspace.',
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 620;
                        final cards = <Widget>[
                          _MetricCard(
                            icon: Icons.description_outlined,
                            label: 'Active reports',
                            value:
                                reports.asData?.value.length.toString() ?? '—',
                          ),
                          _MetricCard(
                            icon: Icons.people_outline,
                            label: 'Customers',
                            value:
                                customers.asData?.value.length.toString() ??
                                '—',
                          ),
                          _PlanMetricCard(
                            subscription: subscription,
                            usage: usage,
                          ),
                        ];
                        if (!wide) {
                          return Column(
                            children: [
                              for (var i = 0; i < cards.length; i++) ...[
                                if (i > 0)
                                  const SizedBox(height: AppSpacing.small),
                                cards[i],
                              ],
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < cards.length; i++) ...[
                              if (i > 0)
                                const SizedBox(width: AppSpacing.small),
                              Expanded(child: cards[i]),
                            ],
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xLarge),
                    Row(
                      children: [
                        const Expanded(
                          child: AppSectionHeader(title: 'Recent reports'),
                        ),
                        TextButton(
                          onPressed: () => context.go(RoutePaths.reports),
                          child: const Text('View all'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
                    _RecentReports(reports: reports),
                    const SizedBox(height: AppSpacing.large),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onNewReport, required this.onAddCustomer});

  final VoidCallback onNewReport;
  final VoidCallback onAddCustomer;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked = constraints.maxWidth < 520;
      final report = FilledButton.icon(
        key: const Key('homeNewReportAction'),
        onPressed: onNewReport,
        icon: const Icon(Icons.add),
        label: const Text('New Report'),
      );
      final customer = OutlinedButton.icon(
        onPressed: onAddCustomer,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Customer'),
      );
      if (stacked) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            report,
            const SizedBox(height: AppSpacing.small),
            customer,
          ],
        );
      }
      return Row(
        children: [
          Expanded(child: report),
          const SizedBox(width: AppSpacing.small),
          Expanded(child: customer),
        ],
      );
    },
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.helper,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Icon(icon, color: colors.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xSmall),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (helper != null) ...[
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(
                      helper!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanMetricCard extends StatelessWidget {
  const _PlanMetricCard({required this.subscription, required this.usage});

  final AsyncValue<SubscriptionStatus> subscription;
  final AsyncValue<UsageCounter> usage;

  @override
  Widget build(BuildContext context) {
    final status = subscription.asData?.value;
    final counter = usage.asData?.value;
    if (status?.isPro == true) {
      return const _MetricCard(
        icon: Icons.workspace_premium_outlined,
        label: 'Plan',
        value: 'Pro',
        helper: 'Unlimited finalized reports',
      );
    }
    if (status?.isConfigured == true && counter != null) {
      final remaining = math.max(0, 3 - counter.finalizedReportCount);
      return _MetricCard(
        icon: Icons.workspace_premium_outlined,
        label: 'Free reports left',
        value: '$remaining',
        helper: 'Resets monthly',
      );
    }
    return const _MetricCard(
      icon: Icons.workspace_premium_outlined,
      label: 'Plan',
      value: 'Free',
      helper: 'Subscriptions not configured',
    );
  }
}

class _RecentReports extends StatelessWidget {
  const _RecentReports({required this.reports});

  final AsyncValue<List<Report>> reports;

  @override
  Widget build(BuildContext context) => reports.when(
    loading: () => const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.large),
        child: LinearProgressIndicator(),
      ),
    ),
    error: (error, stackTrace) => const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.large),
        child: Text('Recent reports are temporarily unavailable.'),
      ),
    ),
    data: (items) {
      if (items.isEmpty) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Text(
              'Your newest reports will appear here.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }
      return Card(
        child: Column(
          children: [
            for (var i = 0; i < math.min(3, items.length); i++) ...[
              _RecentReportTile(report: items[i]),
              if (i < math.min(3, items.length) - 1) const Divider(height: 1),
            ],
          ],
        ),
      );
    },
  );
}

class _RecentReportTile extends StatelessWidget {
  const _RecentReportTile({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(
      report.isFinalized ? Icons.verified_outlined : Icons.edit_note_outlined,
    ),
    title: Text(
      ReportDisplay.title(report),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      '${report.reportType.displayLabel} · ${ReportDisplay.updated(report.updatedAt)}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => context.goNamed(
      AppRoute.reportDetail.name,
      pathParameters: {'reportId': report.id},
    ),
  );
}
