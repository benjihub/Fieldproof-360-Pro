import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/business/presentation/providers/business_providers.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_signature_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportSignaturesScreen extends ConsumerWidget {
  const ReportSignaturesScreen({required this.reportId, super.key});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportDetailProvider(reportId));
    final signatures = ref.watch(reportSignaturesProvider(reportId));
    final reportValue = switch (report) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final editable = reportValue?.isDraft ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Signatures')),
      body: SafeArea(
        child: signatures.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: OutlinedButton(
              onPressed: () =>
                  ref.invalidate(reportSignaturesProvider(reportId)),
              child: const Text('Retry loading signatures'),
            ),
          ),
          data: (items) {
            final byType = {for (final item in items) item.signatureType: item};
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.large),
              children: [
                Text(
                  'Capture the people who signed off this work.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.large),
                _SignatureCard(
                  type: ReportSignatureType.technician,
                  signature: byType[ReportSignatureType.technician],
                  editable: editable,
                  onCapture: () => _capture(
                    context,
                    ref,
                    reportValue,
                    ReportSignatureType.technician,
                  ),
                  onDelete: () =>
                      _delete(context, ref, ReportSignatureType.technician),
                ),
                const SizedBox(height: AppSpacing.medium),
                _SignatureCard(
                  type: ReportSignatureType.customer,
                  signature: byType[ReportSignatureType.customer],
                  editable: editable,
                  onCapture: () => _capture(
                    context,
                    ref,
                    reportValue,
                    ReportSignatureType.customer,
                  ),
                  onDelete: () =>
                      _delete(context, ref, ReportSignatureType.customer),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _capture(
    BuildContext context,
    WidgetRef ref,
    Report? report,
    ReportSignatureType type,
  ) async {
    if (report == null) return;
    String suggestedName = '';
    if (type == ReportSignatureType.technician) {
      suggestedName =
          (await ref.read(businessProfileProvider.future))?.technicianName ??
          '';
    } else if (report.customerId != null) {
      suggestedName =
          (await ref.read(
            customerDetailProvider(report.customerId!).future,
          ))?.name ??
          '';
    }
    if (!context.mounted) return;
    final capture = await showDialog<_CapturedSignature>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _SignatureCaptureDialog(type: type, initialName: suggestedName),
    );
    if (capture == null) return;
    try {
      await ref
          .read(reportSignatureRepositoryProvider)
          .saveSignature(
            reportId: reportId,
            type: type,
            signerName: capture.signerName,
            pngBytes: capture.pngBytes,
          );
    } on AppException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ReportSignatureType type,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Remove ${type.displayLabel.toLowerCase()} signature?'),
        content: const Text('The signature can be captured again later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(reportSignatureRepositoryProvider)
          .deleteSignature(reportId: reportId, type: type);
    } on AppException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
}

class _SignatureCard extends StatelessWidget {
  const _SignatureCard({
    required this.type,
    required this.signature,
    required this.editable,
    required this.onCapture,
    required this.onDelete,
  });

  final ReportSignatureType type;
  final ReportSignature? signature;
  final bool editable;
  final VoidCallback onCapture;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${type.displayLabel} signature',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.medium),
          if (signature == null)
            const Text('Not signed yet.')
          else ...[
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Image.file(
                File(signature!.filePath),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(signature!.signerName),
            Text(
              'Signed ${MaterialLocalizations.of(context).formatMediumDate(signature!.signedAt.toLocal())}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (editable) ...[
            const SizedBox(height: AppSpacing.medium),
            Row(
              children: [
                FilledButton.icon(
                  key: Key('capture${type.name}SignatureAction'),
                  onPressed: onCapture,
                  icon: const Icon(Icons.draw_outlined),
                  label: Text(signature == null ? 'Capture' : 'Replace'),
                ),
                if (signature != null) ...[
                  const SizedBox(width: AppSpacing.small),
                  TextButton(onPressed: onDelete, child: const Text('Remove')),
                ],
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

final class _CapturedSignature {
  const _CapturedSignature({required this.signerName, required this.pngBytes});

  final String signerName;
  final Uint8List pngBytes;
}

class _SignatureCaptureDialog extends StatefulWidget {
  const _SignatureCaptureDialog({
    required this.type,
    required this.initialName,
  });

  final ReportSignatureType type;
  final String initialName;

  @override
  State<_SignatureCaptureDialog> createState() =>
      _SignatureCaptureDialogState();
}

class _SignatureCaptureDialogState extends State<_SignatureCaptureDialog> {
  final GlobalKey _boundaryKey = GlobalKey();
  final List<List<Offset>> _strokes = [];
  final List<List<Offset>> _redo = [];
  late final TextEditingController _name;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('${widget.type.displayLabel} signature'),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('signatureSignerNameField'),
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Signer name'),
            ),
            const SizedBox(height: AppSpacing.medium),
            RepaintBoundary(
              key: _boundaryKey,
              child: Container(
                height: 220,
                width: double.infinity,
                color: Colors.white,
                child: GestureDetector(
                  key: const Key('signaturePad'),
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) {
                    setState(() {
                      _strokes.add([details.localPosition]);
                      _redo.clear();
                      _error = null;
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() => _strokes.last.add(details.localPosition));
                  },
                  child: CustomPaint(
                    painter: _SignaturePainter(_strokes),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _strokes.isEmpty
                      ? null
                      : () => setState(() => _redo.add(_strokes.removeLast())),
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
                TextButton.icon(
                  onPressed: _redo.isEmpty
                      ? null
                      : () => setState(() => _strokes.add(_redo.removeLast())),
                  icon: const Icon(Icons.redo),
                  label: const Text('Redo'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _strokes.isEmpty
                      ? null
                      : () => setState(() {
                          _strokes.clear();
                          _redo.clear();
                        }),
                  child: const Text('Clear'),
                ),
              ],
            ),
            if (_error != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(
        key: const Key('saveSignatureAction'),
        onPressed: _saving ? null : _save,
        child: _saving
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Save Signature'),
      ),
    ],
  );

  Future<void> _save() async {
    final signer = _name.text.trim();
    if (signer.isEmpty) {
      setState(() => _error = 'Signer name is required.');
      return;
    }
    if (_strokes.isEmpty) {
      setState(() => _error = 'Draw a signature before saving.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw StateError('Signature canvas is unavailable.');
      }
      final image = await boundary.toImage(pixelRatio: 2.0);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) throw StateError('Could not encode signature.');
      if (mounted) {
        Navigator.of(context).pop(
          _CapturedSignature(
            signerName: signer,
            pngBytes: bytes.buffer.asUint8List(),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not capture the signature. Try again.';
        });
      }
    }
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter(this.strokes);

  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        canvas.drawCircle(
          stroke.first,
          1.25,
          paint..style = PaintingStyle.fill,
        );
        paint.style = PaintingStyle.stroke;
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final point in stroke.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
