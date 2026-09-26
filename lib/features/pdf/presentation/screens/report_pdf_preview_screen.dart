import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/pdf/domain/services/report_pdf_service.dart';
import 'package:fieldproof_360/features/pdf/presentation/providers/report_pdf_providers.dart';
import 'package:fieldproof_360/features/pdf/presentation/report_share_ui.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ReportPdfPreviewScreen extends ConsumerStatefulWidget {
  const ReportPdfPreviewScreen({required this.reportId, super.key});

  final String reportId;

  @override
  ConsumerState<ReportPdfPreviewScreen> createState() =>
      _ReportPdfPreviewScreenState();
}

class _ReportPdfPreviewScreenState
    extends ConsumerState<ReportPdfPreviewScreen> {
  bool _sharing = false;

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(reportDetailProvider(widget.reportId));
    final accessPolicy = ref.watch(reportAccessPolicyProvider);
    final loadedReport = report.asData?.value;
    final snapshot = loadedReport?.snapshot;
    final canShare = loadedReport?.isFinalized == true && snapshot != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
        actions: [
          Builder(
            builder: (buttonContext) => IconButton(
              key: const Key('sharePdfFromPreviewAction'),
              tooltip: 'Share PDF',
              onPressed: canShare && !_sharing
                  ? () => _share(snapshot, buttonContext)
                  : null,
              icon: _sharing
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.ios_share_outlined),
            ),
          ),
        ],
      ),
      body: report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _PreviewMessage(
          message: 'Could not load this report.',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(reportDetailProvider(widget.reportId)),
        ),
        data: (value) {
          if (value == null) {
            return const _PreviewMessage(message: 'Report not found.');
          }
          final snapshot = value.snapshot;
          if (!value.isFinalized || snapshot == null) {
            return const _PreviewMessage(
              message:
                  'Finalize the report before generating its official PDF.',
            );
          }
          final service = ref.watch(reportPdfServiceProvider);
          return PdfPreview(
            initialPageFormat: PdfPageFormat.a4,
            pdfFileName: ReportPdfService.fileNameFor(snapshot),
            allowPrinting: false,
            allowSharing: false,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            build: (format) => service.generate(
              snapshot: snapshot,
              pageFormat: PdfPageFormat.a4,
              showFieldProofBranding: !accessPolicy.isPro,
            ),
          );
        },
      ),
    );
  }

  Future<void> _share(
    ReportSnapshot snapshot,
    BuildContext buttonContext,
  ) async {
    setState(() => _sharing = true);
    try {
      final result = await ref
          .read(reportPdfShareViewModelProvider)
          .share(
            reportId: widget.reportId,
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
      if (mounted) setState(() => _sharing = false);
    }
  }
}

class _PreviewMessage extends StatelessWidget {
  const _PreviewMessage({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.picture_as_pdf_outlined, size: 48),
          const SizedBox(height: AppSpacing.medium),
          Text(message, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.medium),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    ),
  );
}
