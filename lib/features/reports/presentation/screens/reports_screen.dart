import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/widgets/app_state_views.dart';
import 'package:fieldproof_360/core/widgets/responsive_content.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/report_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);
    final customers = ref.watch(customerListProvider(''));
    final customerNames = switch (customers) {
      AsyncData(:final value) => <String, String>{
        for (final customer in value) customer.id: customer.name,
      },
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.small),
            child: FilledButton.tonalIcon(
              key: const Key('newReportAction'),
              onPressed: () => context.goNamed(AppRoute.reportNew.name),
              icon: const Icon(Icons.add),
              label: const Text('New Report'),
            ),
          ),
        ],
      ),
      body: reports.when(
        loading: () => const AppLoadingView(label: 'Loading reports…'),
        error: (error, stackTrace) => AppErrorState(
          title: 'Reports unavailable',
          message: 'FieldProof 360 Pro could not load your reports.',
          onRetry: () => ref.invalidate(reportListProvider),
        ),
        data: (items) => items.isEmpty
            ? AppEmptyState(
                icon: Icons.description_outlined,
                title: 'No reports yet',
                message:
                    'Create your first service report to start documenting your work.',
                actionLabel: 'New Report',
                actionKey: const Key('emptyNewReportAction'),
                onAction: () => context.goNamed(AppRoute.reportNew.name),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(reportListProvider);
                  ref.invalidate(customerListProvider(''));
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    ResponsiveContent(
                      maxWidth: 900,
                      child: _ReportList(
                        reports: items,
                        customerNames: customerNames,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ReportList extends StatelessWidget {
  const _ReportList({required this.reports, required this.customerNames});

  final List<Report> reports;
  final Map<String, String>? customerNames;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var index = 0; index < reports.length; index++) ...[
        _ReportCard(
          report: reports[index],
          customerName: switch (reports[index].customerId) {
            final customerId? when customerNames != null =>
              customerNames![customerId] ?? 'Customer unavailable',
            _ => null,
          },
        ),
        if (index < reports.length - 1)
          const SizedBox(height: AppSpacing.small),
      ],
    ],
  );
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report, required this.customerName});

  final Report report;
  final String? customerName;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      key: ValueKey(report.id),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.goNamed(
          AppRoute.reportDetail.name,
          pathParameters: {'reportId': report.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: report.isFinalized
                      ? colors.primaryContainer
                      : colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Icon(
                    report.isFinalized
                        ? Icons.verified_outlined
                        : Icons.edit_note_outlined,
                    color: report.isFinalized
                        ? colors.onPrimaryContainer
                        : colors.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ReportDisplay.title(report),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        _StatusChip(report: report),
                      ],
                    ),
                    if (customerName != null) ...[
                      const SizedBox(height: AppSpacing.small),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16),
                          const SizedBox(width: AppSpacing.xSmall),
                          Expanded(
                            child: Text(
                              customerName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      '${report.reportType.displayLabel} · ${report.status.displayLabel} · Updated ${ReportDisplay.updated(report.updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Status ${report.status.displayLabel}',
    child: Chip(
      visualDensity: VisualDensity.compact,
      label: Text(report.status.displayLabel),
      avatar: Icon(
        report.isFinalized ? Icons.lock_outline : Icons.edit_outlined,
        size: 16,
      ),
    ),
  );
}
