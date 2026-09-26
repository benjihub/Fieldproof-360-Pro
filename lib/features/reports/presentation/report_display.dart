import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:intl/intl.dart';

abstract final class ReportDisplay {
  static String title(Report report) =>
      report.title.isEmpty ? 'Untitled Report' : report.title;

  static String updated(DateTime value) =>
      DateFormat.yMMMd().add_jm().format(value.toLocal());
}
