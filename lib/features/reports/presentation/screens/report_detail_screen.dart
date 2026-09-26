import 'dart:io';

import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/pdf/presentation/providers/report_pdf_providers.dart';
import 'package:fieldproof_360/features/pdf/presentation/report_share_ui.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_access_policy.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_material_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_photo_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_signature_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/report_display.dart';
import 'package:fieldproof_360/features/reports/presentation/view_models/report_finalization_view_model.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/providers/subscription_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportDetailScreen extends ConsumerWidget {
  const ReportDetailScreen({required this.reportId, super.key});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportDetailProvider(reportId));
    return Scaffold(
      appBar: AppBar(title: const Text('Report Details')),
      body: report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _DetailError(
          onRetry: () => ref.invalidate(reportDetailProvider(reportId)),
        ),
        data: (value) => value == null
            ? const Center(child: Text('Report not found.'))
            : _ReportDetails(report: value),
      ),
    );
  }
}

class _ReportDetails extends ConsumerStatefulWidget {
  const _ReportDetails({required this.report});

  final Report report;

  @override
  ConsumerState<_ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends ConsumerState<_ReportDetails> {
  bool _actionRunning = false;
  bool _shareRunning = false;

  Report get report => widget.report;

  @override
  Widget build(BuildContext context) {
    final snapshot = report.snapshot;
    final liveCustomer = report.isFinalized || report.customerId == null
        ? null
        : ref.watch(customerDetailProvider(report.customerId!));
    final equipment = [
      report.equipmentName,
      report.equipmentManufacturer,
      report.equipmentModel,
      report.equipmentSerial,
    ].whereType<String>().join(' · ');
    final fields = <({String label, String value})>[
      if (report.reportNumber case final value?)
        (label: 'Report number', value: value),
      (label: 'Report type', value: report.reportType.displayLabel),
      (label: 'Status', value: report.status.displayLabel),
      if (report.finalizedAt case final value?)
        (label: 'Finalized', value: ReportDisplay.updated(value)),
      if (report.siteAddress case final value?)
        (label: 'Site address', value: value),
      if (equipment.isNotEmpty) (label: 'Equipment', value: equipment),
      if (report.issueReported case final value?)
        (label: 'Issue reported', value: value),
      if (report.diagnosis case final value?)
        (label: 'Diagnosis', value: value),
      if (report.workPerformed.isNotEmpty)
        (label: 'Work performed', value: report.workPerformed),
      if (report.recommendations case final value?)
        (label: 'Recommendations', value: value),
      if (report.internalNotes case final value?)
        (label: 'Internal notes', value: value),
      (label: 'Last updated', value: ReportDisplay.updated(report.updatedAt)),
    ];

    return SafeArea(
      child: ListView(
        key: const Key('reportDetailList'),
        padding: const EdgeInsets.all(AppSpacing.large),
        children: [
          Text(
            ReportDisplay.title(report),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (report.isFinalized && snapshot?.customer != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Text(snapshot!.customer!.name),
          ] else if (liveCustomer != null) ...[
            const SizedBox(height: AppSpacing.medium),
            liveCustomer.when(
              loading: () => const Text('Loading customer…'),
              error: (error, stackTrace) => const Text('Customer unavailable'),
              data: (value) => Text(value?.name ?? 'Customer unavailable'),
            ),
          ],
          const SizedBox(height: AppSpacing.large),
          for (final field in fields)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(field.label),
              subtitle: Text(field.value),
            ),
          const SizedBox(height: AppSpacing.large),
          _ReportPhotoPreview(reportId: report.id),
          const SizedBox(height: AppSpacing.large),
          _ReportMaterialsPreview(reportId: report.id),
          const SizedBox(height: AppSpacing.large),
          _ReportSignaturesPreview(reportId: report.id),
          const SizedBox(height: AppSpacing.large),
          if (report.isDraft) ...[
            FilledButton.icon(
              key: const Key('finalizeReportAction'),
              onPressed: _actionRunning ? null : _finalize,
              icon: _actionRunning
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock_outline),
              label: const Text('Finalize Report'),
            ),
            const SizedBox(height: AppSpacing.small),
            OutlinedButton.icon(
              key: const Key('editReportAction'),
              onPressed: _actionRunning
                  ? null
                  : () => context.goNamed(
                      AppRoute.reportEdit.name,
                      pathParameters: {'reportId': report.id},
                    ),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Report'),
            ),
          ] else if (report.isFinalized) ...[
            FilledButton.icon(
              key: const Key('previewReportPdfAction'),
              onPressed: report.snapshot == null
                  ? null
                  : () => context.pushNamed(
                      AppRoute.reportPdfPreview.name,
                      pathParameters: {'reportId': report.id},
                    ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Preview PDF'),
            ),
            const SizedBox(height: AppSpacing.small),
            Builder(
              builder: (buttonContext) => OutlinedButton.icon(
                key: const Key('shareReportPdfAction'),
                onPressed: report.snapshot == null || _shareRunning
                    ? null
                    : () => _sharePdf(report.snapshot!, buttonContext),
                icon: _shareRunning
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.ios_share_outlined),
                label: const Text('Share PDF'),
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            OutlinedButton.icon(
              key: const Key('duplicateReportAction'),
              onPressed: _actionRunning ? null : _duplicateAsDraft,
              icon: _actionRunning
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.copy_all_outlined),
              label: const Text('Duplicate as Draft'),
            ),
            const SizedBox(height: AppSpacing.small),
            const Text(
              'This report is finalized and read-only.',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _finalize() async {
    setState(() => _actionRunning = true);
    try {
      if (ref.read(subscriptionConfiguredProvider)) {
        final usage = await ref
            .read(reportRepositoryProvider)
            .getUsageCounter();
        if (usage.finalizedReportCount >= 3) {
          final status = await ref
              .read(subscriptionRepositoryProvider)
              .getStatus();
          final policy = ReportAccessPolicy(
            isPro: status.isPro,
            enforceFreeLimit: true,
          );
          if (!policy.canFinalize(usage)) {
            if (mounted) await context.push(RoutePaths.subscription);
            return;
          }
          ref.invalidate(reportAccessPolicyProvider);
          ref.invalidate(reportRepositoryProvider);
        }
      }

      final viewModel = ReportFinalizationViewModel(
        ref.read(reportRepositoryProvider),
      );
      final validation = await viewModel.validate(report.id);
      if (!mounted) return;
      if (!validation.isValid) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Report is not ready'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final error in validation.errors)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.small),
                    child: Text('• $error'),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Finalize report?'),
          content: const Text(
            'Finalizing assigns a permanent report number and locks this report. '
            'To make changes later, duplicate it as a new draft.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Finalize'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;

      final finalized = await viewModel.finalize(report.id);
      ref.invalidate(reportDetailProvider(report.id));
      ref.invalidate(reportListProvider);
      ref.invalidate(currentReportUsageProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${finalized.reportNumber} finalized.')),
      );
    } on AppException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _actionRunning = false);
    }
  }

  Future<void> _sharePdf(
    ReportSnapshot snapshot,
    BuildContext buttonContext,
  ) async {
    setState(() => _shareRunning = true);
    try {
      final result = await ref
          .read(reportPdfShareViewModelProvider)
          .share(
            reportId: report.id,
            snapshot: snapshot,
            sharePositionOrigin: sharePositionOriginFor(buttonContext),
            showFieldProofBranding: !ref.read(reportAccessPolicyProvider).isPro,
          );
      if (!mounted) return;
      final message = shareOutcomeMessage(result.outcome);
      if (message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } on AppException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _shareRunning = false);
    }
  }

  Future<void> _duplicateAsDraft() async {
    final viewModel = ReportFinalizationViewModel(
      ref.read(reportRepositoryProvider),
    );
    setState(() => _actionRunning = true);
    try {
      final duplicate = await viewModel.duplicateAsDraft(report.id);
      ref.invalidate(reportListProvider);
      if (!mounted) return;
      context.goNamed(
        AppRoute.reportEdit.name,
        pathParameters: {'reportId': duplicate.id},
      );
    } on AppException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _actionRunning = false);
    }
  }
}

class _ReportPhotoPreview extends ConsumerWidget {
  const _ReportPhotoPreview({required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(reportPhotosProvider(reportId));
    return photos.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Photos (${items.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.pushNamed(
                    AppRoute.reportPhotos.name,
                    pathParameters: {'reportId': reportId},
                  ),
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.small),
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.small),
                itemBuilder: (context, index) {
                  final photo = items[index];
                  final path = photo.thumbnailPath ?? photo.filePath;
                  return SizedBox(
                    width: 112,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(path),
                              width: 112,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 112,
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.broken_image_outlined),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        Text(
                          photo.category.displayLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReportMaterialsPreview extends ConsumerWidget {
  const _ReportMaterialsPreview({required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materials = ref.watch(reportMaterialsProvider(reportId));
    return materials.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Materials (${items.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.pushNamed(
                    AppRoute.reportMaterials.name,
                    pathParameters: {'reportId': reportId},
                  ),
                  child: const Text('View all'),
                ),
              ],
            ),
            for (final item in items.take(4))
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(item.name),
                trailing: Text(
                  item.unit == null
                      ? item.quantityLabel
                      : '${item.quantityLabel} ${item.unit}',
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ReportSignaturesPreview extends ConsumerWidget {
  const _ReportSignaturesPreview({required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signatures = ref.watch(reportSignaturesProvider(reportId));
    return signatures.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Signatures (${items.length}/2)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.pushNamed(
                    AppRoute.reportSignatures.name,
                    pathParameters: {'reportId': reportId},
                  ),
                  child: const Text('View'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.small),
            Wrap(
              spacing: AppSpacing.medium,
              runSpacing: AppSpacing.small,
              children: [
                for (final signature in items)
                  Chip(
                    avatar: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(
                      '${signature.signatureType.displayLabel}: ${signature.signerName}',
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Could not load the report.'),
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
