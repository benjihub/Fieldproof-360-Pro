import 'dart:io';
import 'dart:typed_data';

import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_signature_type.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_snapshot.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Generates the immutable, customer-facing PDF representation of a finalized
/// FieldProof report.
///
/// The service deliberately accepts a [ReportSnapshot] rather than live
/// repositories. This keeps historical PDFs reproducible after business,
/// customer, or report records change.
final class ReportPdfService {
  const ReportPdfService();

  Future<Uint8List> generate({
    required ReportSnapshot snapshot,
    PdfPageFormat pageFormat = PdfPageFormat.a4,
    bool showFieldProofBranding = true,
  }) async {
    final assets = await _loadAssets(snapshot);
    final document = pw.Document();
    final palette = _PdfPalette();

    document.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.fromLTRB(38, 34, 38, 44),
        theme: pw.ThemeData.base(),
        header: (context) => _pageHeader(context, snapshot, palette),
        footer: (context) => _pageFooter(
          context,
          snapshot,
          palette,
          showFieldProofBranding: showFieldProofBranding,
        ),
        build: (context) => [
          _documentHeader(snapshot, assets.logo, palette),
          pw.SizedBox(height: 16),
          _summaryGrid(snapshot, palette),
          ..._customerAndEquipment(snapshot, palette),
          ..._workSections(snapshot, palette),
          ..._materialSection(snapshot, palette),
          ..._photoSections(snapshot, assets, palette),
          ..._signatureSection(snapshot, assets, palette),
          ..._termsSection(snapshot, palette),
        ],
      ),
    );

    return document.save();
  }

  static String fileNameFor(ReportSnapshot snapshot) {
    final reportNumber = _safeFilePart(snapshot.report.number);
    final title = _safeFilePart(snapshot.report.title);
    return title.isEmpty
        ? 'FieldProof_360_Pro_$reportNumber.pdf'
        : 'FieldProof_360_Pro_${reportNumber}_$title.pdf';
  }

  Future<_PdfAssets> _loadAssets(ReportSnapshot snapshot) async {
    final logo = await _loadImage(snapshot.business.logoPath);
    final photos = <String, pw.MemoryImage>{};
    for (final photo in snapshot.photos) {
      final image = await _loadImage(photo.filePath);
      if (image != null) photos[photo.filePath] = image;
    }
    final signatures = <String, pw.MemoryImage>{};
    for (final signature in snapshot.signatures) {
      final image = await _loadImage(signature.filePath);
      if (image != null) signatures[signature.filePath] = image;
    }
    return _PdfAssets(logo: logo, photos: photos, signatures: signatures);
  }

  Future<pw.MemoryImage?> _loadImage(String? path) async {
    if (path == null || path.trim().isEmpty) return null;
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;
      try {
        if (img.decodeImage(bytes) == null) return null;
      } catch (_) {
        return null;
      }
      return pw.MemoryImage(bytes);
    } on FileSystemException {
      return null;
    }
  }

  pw.Widget _pageHeader(
    pw.Context context,
    ReportSnapshot snapshot,
    _PdfPalette palette,
  ) {
    if (context.pageNumber == 1) return pw.SizedBox();
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      margin: const pw.EdgeInsets.only(bottom: 12),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: palette.line, width: 0.7),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            snapshot.business.businessName,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: palette.muted,
            ),
          ),
          pw.Text(
            snapshot.report.number,
            style: pw.TextStyle(fontSize: 9, color: palette.muted),
          ),
        ],
      ),
    );
  }

  pw.Widget _pageFooter(
    pw.Context context,
    ReportSnapshot snapshot,
    _PdfPalette palette, {
    required bool showFieldProofBranding,
  }) => pw.Container(
    padding: const pw.EdgeInsets.only(top: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(top: pw.BorderSide(color: palette.line, width: 0.7)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          showFieldProofBranding
              ? 'Created with FieldProof 360 Pro'
              : snapshot.business.businessName,
          style: pw.TextStyle(fontSize: 8, color: palette.muted),
        ),
        pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: pw.TextStyle(fontSize: 8, color: palette.muted),
        ),
      ],
    ),
  );

  pw.Widget _documentHeader(
    ReportSnapshot snapshot,
    pw.MemoryImage? logo,
    _PdfPalette palette,
  ) => pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      if (logo != null) ...[
        pw.Container(
          width: 70,
          height: 54,
          padding: const pw.EdgeInsets.all(3),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: palette.line),
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Image(logo, fit: pw.BoxFit.contain),
        ),
        pw.SizedBox(width: 14),
      ],
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              snapshot.business.businessName,
              style: pw.TextStyle(
                fontSize: 19,
                fontWeight: pw.FontWeight.bold,
                color: palette.primary,
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              snapshot.business.technicianName,
              style: pw.TextStyle(fontSize: 10, color: palette.muted),
            ),
            if (_businessContact(snapshot).isNotEmpty) ...[
              pw.SizedBox(height: 3),
              pw.Text(
                _businessContact(snapshot),
                style: pw.TextStyle(fontSize: 8.5, color: palette.muted),
              ),
            ],
          ],
        ),
      ),
      pw.SizedBox(width: 14),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            '${snapshot.report.type.displayLabel.toUpperCase()} REPORT',
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              color: palette.primary,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            snapshot.report.number,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            _date(snapshot.report.finalizedAt),
            style: pw.TextStyle(fontSize: 9, color: palette.muted),
          ),
        ],
      ),
    ],
  );

  pw.Widget _summaryGrid(ReportSnapshot snapshot, _PdfPalette palette) =>
      pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: palette.soft,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: _labelValue(
                'REPORT TITLE',
                snapshot.report.title,
                palette,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _labelValue(
                'COMPLETED',
                _date(snapshot.report.completedAt ?? snapshot.finalizedAt),
                palette,
              ),
            ),
          ],
        ),
      );

  List<pw.Widget> _customerAndEquipment(
    ReportSnapshot snapshot,
    _PdfPalette palette,
  ) {
    final customer = snapshot.customer;
    final equipmentLines = <String>[
      ?snapshot.equipment.name,
      ?snapshot.equipment.manufacturer,
      if (snapshot.equipment.model case final value?) 'Model: $value',
      if (snapshot.equipment.serial case final value?) 'Serial: $value',
    ];
    if (customer == null &&
        equipmentLines.isEmpty &&
        snapshot.report.siteAddress == null) {
      return const [];
    }

    return [
      pw.SizedBox(height: 16),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (customer != null)
            pw.Expanded(
              child: _infoCard(
                title: 'Customer',
                lines: [
                  customer.name,
                  ?customer.companyName,
                  ?customer.phone,
                  ?customer.email,
                  ?customer.address,
                ],
                palette: palette,
              ),
            ),
          if (customer != null &&
              (equipmentLines.isNotEmpty ||
                  snapshot.report.siteAddress != null))
            pw.SizedBox(width: 12),
          if (equipmentLines.isNotEmpty || snapshot.report.siteAddress != null)
            pw.Expanded(
              child: _infoCard(
                title: 'Site & Equipment',
                lines: [?snapshot.report.siteAddress, ...equipmentLines],
                palette: palette,
              ),
            ),
        ],
      ),
    ];
  }

  List<pw.Widget> _workSections(ReportSnapshot snapshot, _PdfPalette palette) {
    final items = <({String title, String value})>[
      if (snapshot.report.issueReported case final value?)
        (title: 'Reported Issue', value: value),
      if (snapshot.report.diagnosis case final value?)
        (title: 'Diagnosis', value: value),
      (title: 'Work Performed', value: snapshot.report.workPerformed),
      if (snapshot.report.recommendations case final value?)
        (title: 'Recommendations', value: value),
    ];

    return [
      for (final item in items) ...[
        pw.SizedBox(height: 16),
        _sectionTitle(item.title, palette),
        pw.SizedBox(height: 6),
        pw.Text(
          item.value,
          style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 2),
        ),
      ],
    ];
  }

  List<pw.Widget> _materialSection(
    ReportSnapshot snapshot,
    _PdfPalette palette,
  ) {
    if (snapshot.materials.isEmpty) return const [];
    final materials = [...snapshot.materials]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return [
      pw.SizedBox(height: 18),
      _sectionTitle('Materials Used', palette),
      pw.SizedBox(height: 7),
      pw.Table(
        border: pw.TableBorder.all(color: palette.line, width: 0.6),
        columnWidths: const {
          0: pw.FlexColumnWidth(3.2),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1.2),
          3: pw.FlexColumnWidth(3),
        },
        children: [
          pw.TableRow(
            decoration: pw.BoxDecoration(color: palette.soft),
            children: [
              _tableCell('Material', bold: true),
              _tableCell('Qty', bold: true),
              _tableCell('Unit', bold: true),
              _tableCell('Notes', bold: true),
            ],
          ),
          for (final material in materials)
            pw.TableRow(
              children: [
                _tableCell(material.name),
                _tableCell(_quantity(material.quantity)),
                _tableCell(material.unit ?? '-'),
                _tableCell(material.notes ?? '-'),
              ],
            ),
        ],
      ),
    ];
  }

  List<pw.Widget> _photoSections(
    ReportSnapshot snapshot,
    _PdfAssets assets,
    _PdfPalette palette,
  ) {
    if (snapshot.photos.isEmpty) return const [];
    final widgets = <pw.Widget>[];
    for (final category in ReportPhotoCategory.values) {
      final photos =
          snapshot.photos
              .where((item) => item.category == category)
              .toList(growable: false)
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      if (photos.isEmpty) continue;
      widgets
        ..add(pw.SizedBox(height: 18))
        ..add(_sectionTitle('${category.displayLabel} Photos', palette))
        ..add(pw.SizedBox(height: 7));
      for (final photo in photos) {
        final image = assets.photos[photo.filePath];
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 12),
            padding: const pw.EdgeInsets.all(7),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: palette.line, width: 0.7),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (image != null)
                  pw.Container(
                    height: 205,
                    alignment: pw.Alignment.center,
                    child: pw.Image(image, fit: pw.BoxFit.contain),
                  )
                else
                  _missingMedia('Photo unavailable', palette, height: 75),
                if (photo.caption != null && photo.caption!.isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  pw.Text(
                    photo.caption!,
                    style: pw.TextStyle(fontSize: 9, color: palette.muted),
                  ),
                ],
              ],
            ),
          ),
        );
      }
    }
    return widgets;
  }

  List<pw.Widget> _signatureSection(
    ReportSnapshot snapshot,
    _PdfAssets assets,
    _PdfPalette palette,
  ) {
    if (snapshot.signatures.isEmpty) return const [];
    final byType = {
      for (final signature in snapshot.signatures) signature.type: signature,
    };
    return [
      pw.SizedBox(height: 18),
      _sectionTitle('Signatures', palette),
      pw.SizedBox(height: 8),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < ReportSignatureType.values.length; i++) ...[
            if (i > 0) pw.SizedBox(width: 12),
            pw.Expanded(
              child: _signatureCard(
                byType[ReportSignatureType.values[i]],
                assets,
                palette,
              ),
            ),
          ],
        ],
      ),
    ];
  }

  List<pw.Widget> _termsSection(ReportSnapshot snapshot, _PdfPalette palette) {
    final terms = snapshot.business.defaultTerms;
    if (terms == null || terms.trim().isEmpty) return const [];
    return [
      pw.SizedBox(height: 18),
      _sectionTitle('Terms', palette),
      pw.SizedBox(height: 6),
      pw.Text(terms, style: pw.TextStyle(fontSize: 8.5, color: palette.muted)),
    ];
  }

  pw.Widget _signatureCard(
    ReportSnapshotSignature? signature,
    _PdfAssets assets,
    _PdfPalette palette,
  ) {
    if (signature == null) {
      return _missingMedia('Not signed', palette, height: 92);
    }
    final image = assets.signatures[signature.filePath];
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: palette.line, width: 0.7),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            signature.type.displayLabel,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: palette.primary,
            ),
          ),
          pw.SizedBox(height: 5),
          if (image != null)
            pw.Container(
              height: 62,
              alignment: pw.Alignment.centerLeft,
              child: pw.Image(image, fit: pw.BoxFit.contain),
            )
          else
            _missingMedia('Signature image unavailable', palette, height: 62),
          pw.SizedBox(height: 5),
          pw.Text(signature.signerName, style: const pw.TextStyle(fontSize: 9)),
          pw.Text(
            _dateTime(signature.signedAt),
            style: pw.TextStyle(fontSize: 7.5, color: palette.muted),
          ),
        ],
      ),
    );
  }

  pw.Widget _infoCard({
    required String title,
    required List<String> lines,
    required _PdfPalette palette,
  }) => pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: palette.line, width: 0.7),
      borderRadius: pw.BorderRadius.circular(5),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 9.5,
            fontWeight: pw.FontWeight.bold,
            color: palette.primary,
          ),
        ),
        pw.SizedBox(height: 5),
        for (final line in lines)
          if (line.trim().isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text(line, style: const pw.TextStyle(fontSize: 9)),
            ),
      ],
    ),
  );

  pw.Widget _labelValue(String label, String value, _PdfPalette palette) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 7.5,
              fontWeight: pw.FontWeight.bold,
              color: palette.muted,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            value.isEmpty ? 'Untitled Report' : value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      );

  pw.Widget _sectionTitle(String title, _PdfPalette palette) => pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 5),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: palette.line, width: 0.7)),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 11.5,
        fontWeight: pw.FontWeight.bold,
        color: palette.primary,
      ),
    ),
  );

  pw.Widget _tableCell(String value, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    child: pw.Text(
      value,
      style: pw.TextStyle(
        fontSize: 8.5,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );

  pw.Widget _missingMedia(
    String label,
    _PdfPalette palette, {
    required double height,
  }) => pw.Container(
    height: height,
    alignment: pw.Alignment.center,
    color: palette.soft,
    child: pw.Text(
      label,
      style: pw.TextStyle(fontSize: 8.5, color: palette.muted),
    ),
  );

  static String _businessContact(ReportSnapshot snapshot) => [
    snapshot.business.address,
    snapshot.business.phone,
    snapshot.business.email,
    if (snapshot.business.taxLabel != null &&
        snapshot.business.taxNumber != null)
      '${snapshot.business.taxLabel}: ${snapshot.business.taxNumber}',
  ].whereType<String>().where((item) => item.trim().isNotEmpty).join(' | ');

  static String _date(DateTime value) =>
      DateFormat('d MMM yyyy').format(value.toLocal());

  static String _dateTime(DateTime value) =>
      DateFormat('d MMM yyyy, HH:mm').format(value.toLocal());

  static String _quantity(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);

  static String _safeFilePart(String value) => value
      .trim()
      .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

final class _PdfAssets {
  const _PdfAssets({
    required this.logo,
    required this.photos,
    required this.signatures,
  });

  final pw.MemoryImage? logo;
  final Map<String, pw.MemoryImage> photos;
  final Map<String, pw.MemoryImage> signatures;
}

final class _PdfPalette {
  final primary = PdfColors.blueGrey900;
  final muted = PdfColors.blueGrey600;
  final line = PdfColors.blueGrey200;
  final soft = PdfColors.blueGrey50;
}
