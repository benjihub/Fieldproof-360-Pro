import 'dart:async';

import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/presentation/providers/customer_providers.dart';
import 'package:fieldproof_360/features/reports/domain/models/report.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_draft_data.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_type.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_photo_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_material_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_signature_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/view_models/report_editor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportEditorScreen extends ConsumerStatefulWidget {
  const ReportEditorScreen({required this.reportId, super.key});

  final String reportId;

  @override
  ConsumerState<ReportEditorScreen> createState() => _ReportEditorScreenState();
}

class _ReportEditorScreenState extends ConsumerState<ReportEditorScreen>
    with WidgetsBindingObserver {
  static const _autosaveDelay = Duration(milliseconds: 700);
  static const _noCustomer = '';

  final _title = TextEditingController();
  final _siteAddress = TextEditingController();
  final _equipmentName = TextEditingController();
  final _equipmentManufacturer = TextEditingController();
  final _equipmentModel = TextEditingController();
  final _equipmentSerial = TextEditingController();
  final _issueReported = TextEditingController();
  final _diagnosis = TextEditingController();
  final _workPerformed = TextEditingController();
  final _recommendations = TextEditingController();
  final _internalNotes = TextEditingController();

  late final ReportEditorViewModel _viewModel;
  Timer? _autosaveTimer;
  bool _initialized = false;
  bool _dirty = false;
  bool _saving = false;
  bool _saveAgain = false;
  Future<bool>? _activeSave;
  bool _allowPop = false;
  String? _customerId;
  ReportType _reportType = ReportType.service;
  DateTime? _startedAt;
  DateTime? _completedAt;
  String _pdfTemplateId = 'classic';
  String? _saveError;
  DateTime? _lastSavedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = ReportEditorViewModel(ref.read(reportRepositoryProvider));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(_saveNow());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autosaveTimer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _controllers => [
    _title,
    _siteAddress,
    _equipmentName,
    _equipmentManufacturer,
    _equipmentModel,
    _equipmentSerial,
    _issueReported,
    _diagnosis,
    _workPerformed,
    _recommendations,
    _internalNotes,
  ];

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(reportDetailProvider(widget.reportId));
    final customers = ref.watch(customerListProvider(''));
    final selectedCustomer = _customerId == null
        ? null
        : ref.watch(customerDetailProvider(_customerId!));
    final selectedCustomerValue = switch (selectedCustomer) {
      AsyncData(:final value) => value,
      _ => null,
    };

    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) unawaited(_saveAndExit());
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: _saveAndExit,
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Edit Report'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: Center(
                child: _SaveStatus(
                  saving: _saving,
                  error: _saveError,
                  lastSavedAt: _lastSavedAt,
                ),
              ),
            ),
          ],
        ),
        body: report.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _EditorLoadError(
            onRetry: () =>
                ref.invalidate(reportDetailProvider(widget.reportId)),
          ),
          data: (value) {
            if (value == null) {
              return const Center(child: Text('Report not found.'));
            }
            if (!value.isDraft) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.large),
                  child: Text('Only draft reports can be edited.'),
                ),
              );
            }
            _initializeIfNeeded(value);
            return customers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => _ReportEditorForm(
                reportId: widget.reportId,
                customerItems: const [],
                customerLoadFailed: true,
                selectedCustomerId: _customerId,
                selectedCustomer: selectedCustomerValue,
                selectedType: _reportType,
                controllers: _fieldControllers,
                onCustomerChanged: _onCustomerChanged,
                onTypeChanged: _onTypeChanged,
                onChanged: _markDirty,
                onRetryCustomers: () =>
                    ref.invalidate(customerListProvider('')),
              ),
              data: (items) {
                return _ReportEditorForm(
                  reportId: widget.reportId,
                  customerItems: items,
                  customerLoadFailed: false,
                  selectedCustomerId: _customerId,
                  selectedCustomer: selectedCustomerValue,
                  selectedType: _reportType,
                  controllers: _fieldControllers,
                  onCustomerChanged: _onCustomerChanged,
                  onTypeChanged: _onTypeChanged,
                  onChanged: _markDirty,
                  onRetryCustomers: null,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<_ReportField, TextEditingController> get _fieldControllers => {
    _ReportField.title: _title,
    _ReportField.siteAddress: _siteAddress,
    _ReportField.equipmentName: _equipmentName,
    _ReportField.equipmentManufacturer: _equipmentManufacturer,
    _ReportField.equipmentModel: _equipmentModel,
    _ReportField.equipmentSerial: _equipmentSerial,
    _ReportField.issueReported: _issueReported,
    _ReportField.diagnosis: _diagnosis,
    _ReportField.workPerformed: _workPerformed,
    _ReportField.recommendations: _recommendations,
    _ReportField.internalNotes: _internalNotes,
  };

  void _initializeIfNeeded(Report report) {
    if (_initialized) return;
    _customerId = report.customerId;
    _reportType = report.reportType;
    _startedAt = report.startedAt;
    _completedAt = report.completedAt;
    _pdfTemplateId = report.pdfTemplateId;
    _title.text = report.title;
    _siteAddress.text = report.siteAddress ?? '';
    _equipmentName.text = report.equipmentName ?? '';
    _equipmentManufacturer.text = report.equipmentManufacturer ?? '';
    _equipmentModel.text = report.equipmentModel ?? '';
    _equipmentSerial.text = report.equipmentSerial ?? '';
    _issueReported.text = report.issueReported ?? '';
    _diagnosis.text = report.diagnosis ?? '';
    _workPerformed.text = report.workPerformed;
    _recommendations.text = report.recommendations ?? '';
    _internalNotes.text = report.internalNotes ?? '';
    _initialized = true;
  }

  void _onCustomerChanged(String? value) {
    setState(() => _customerId = value == _noCustomer ? null : value);
    _markDirty();
  }

  void _onTypeChanged(ReportType value) {
    setState(() => _reportType = value);
    _markDirty();
  }

  void _markDirty([String? _]) {
    _dirty = true;
    _saveError = null;
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(_autosaveDelay, () => unawaited(_saveNow()));
    if (mounted) setState(() {});
  }

  ReportDraftData _draftData() => ReportDraftData(
    customerId: _customerId,
    reportType: _reportType,
    title: _title.text,
    siteAddress: _siteAddress.text,
    equipmentName: _equipmentName.text,
    equipmentManufacturer: _equipmentManufacturer.text,
    equipmentModel: _equipmentModel.text,
    equipmentSerial: _equipmentSerial.text,
    issueReported: _issueReported.text,
    diagnosis: _diagnosis.text,
    workPerformed: _workPerformed.text,
    recommendations: _recommendations.text,
    internalNotes: _internalNotes.text,
    startedAt: _startedAt,
    completedAt: _completedAt,
    pdfTemplateId: _pdfTemplateId,
  );

  Future<bool> _saveNow() {
    final activeSave = _activeSave;
    if (activeSave != null) {
      if (_dirty) _saveAgain = true;
      return activeSave;
    }
    if (!_initialized || !_dirty) return Future.value(true);

    final operation = _runSaveLoop();
    _activeSave = operation;
    unawaited(
      operation.then<void>(
        (_) {
          if (identical(_activeSave, operation)) _activeSave = null;
        },
        onError: (Object _, StackTrace _) {
          if (identical(_activeSave, operation)) _activeSave = null;
        },
      ),
    );
    return operation;
  }

  Future<bool> _runSaveLoop() async {
    _autosaveTimer?.cancel();
    _saving = true;
    if (mounted) setState(() {});
    var success = true;

    do {
      _saveAgain = false;
      _dirty = false;
      final data = _draftData();
      try {
        await _viewModel.saveDraft(reportId: widget.reportId, data: data);
        _lastSavedAt = DateTime.now();
        _saveError = null;
        ref.invalidate(reportDetailProvider(widget.reportId));
        ref.invalidate(reportListProvider);
      } on AppException catch (error) {
        success = false;
        _dirty = true;
        _saveError = error.message;
      } catch (_) {
        success = false;
        _dirty = true;
        _saveError = 'Could not save this draft.';
      }
    } while (_saveAgain && success);

    _saving = false;
    if (mounted) setState(() {});
    return success;
  }

  Future<void> _saveAndExit() async {
    if (_allowPop) return;
    final saved = await _saveNow();
    if (!mounted) return;
    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the latest changes.')),
      );
      return;
    }
    setState(() => _allowPop = true);
    context.pop();
  }
}

enum _ReportField {
  title,
  siteAddress,
  equipmentName,
  equipmentManufacturer,
  equipmentModel,
  equipmentSerial,
  issueReported,
  diagnosis,
  workPerformed,
  recommendations,
  internalNotes,
}

class _ReportEditorForm extends StatelessWidget {
  const _ReportEditorForm({
    required this.reportId,
    required this.customerItems,
    required this.customerLoadFailed,
    required this.selectedCustomerId,
    required this.selectedCustomer,
    required this.selectedType,
    required this.controllers,
    required this.onCustomerChanged,
    required this.onTypeChanged,
    required this.onChanged,
    required this.onRetryCustomers,
  });

  static const _noCustomer = '';

  final String reportId;
  final List<Customer> customerItems;
  final bool customerLoadFailed;
  final String? selectedCustomerId;
  final Customer? selectedCustomer;
  final ReportType selectedType;
  final Map<_ReportField, TextEditingController> controllers;
  final ValueChanged<String?> onCustomerChanged;
  final ValueChanged<ReportType> onTypeChanged;
  final ValueChanged<String> onChanged;
  final VoidCallback? onRetryCustomers;

  TextEditingController _controller(_ReportField field) => controllers[field]!;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      key: const Key('reportEditorList'),
      padding: const EdgeInsets.all(AppSpacing.large),
      children: [
        _SectionHeading(
          icon: Icons.person_pin_circle_outlined,
          title: 'Customer & Site',
          subtitle: 'Who the work is for and where it took place.',
        ),
        const SizedBox(height: AppSpacing.medium),
        DropdownButtonFormField<String>(
          key: const Key('editorCustomerField'),
          initialValue: selectedCustomerId ?? _noCustomer,
          decoration: const InputDecoration(labelText: 'Customer'),
          items: [
            const DropdownMenuItem(
              value: _noCustomer,
              child: Text('No customer'),
            ),
            if (selectedCustomerId != null &&
                !customerItems.any(
                  (customer) => customer.id == selectedCustomerId,
                ))
              DropdownMenuItem(
                value: selectedCustomerId,
                child: Text(
                  selectedCustomer == null
                      ? 'Current customer'
                      : '${_customerLabel(selectedCustomer!)}${selectedCustomer!.isArchived ? ' (archived)' : ''}',
                ),
              ),
            for (final customer in customerItems)
              DropdownMenuItem(
                value: customer.id,
                child: Text(_customerLabel(customer)),
              ),
          ],
          onChanged: customerLoadFailed
              ? null
              : (value) =>
                    onCustomerChanged(value == _noCustomer ? null : value),
        ),
        if (customerLoadFailed) ...[
          const SizedBox(height: AppSpacing.small),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Customers could not be loaded. Your current draft can still be edited.',
                ),
              ),
              TextButton(
                onPressed: onRetryCustomers,
                child: const Text('Retry'),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.medium),
        DropdownButtonFormField<ReportType>(
          key: const Key('editorReportTypeField'),
          initialValue: selectedType,
          decoration: const InputDecoration(labelText: 'Report Type'),
          items: [
            for (final type in ReportType.values)
              DropdownMenuItem(value: type, child: Text(type.displayLabel)),
          ],
          onChanged: (value) {
            if (value != null) onTypeChanged(value);
          },
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorTitleField'),
          controller: _controller(_ReportField.title),
          label: 'Title',
          hint: 'Kitchen socket repair',
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorSiteAddressField'),
          controller: _controller(_ReportField.siteAddress),
          label: 'Site Address',
          minLines: 2,
          maxLines: 3,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        _SectionHeading(
          icon: Icons.build_outlined,
          title: 'Equipment',
          subtitle: 'Optional equipment details for this visit.',
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorEquipmentNameField'),
          controller: _controller(_ReportField.equipmentName),
          label: 'Equipment Name',
          hint: 'Water pump',
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.medium),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TextField(
                fieldKey: const Key('editorEquipmentManufacturerField'),
                controller: _controller(_ReportField.equipmentManufacturer),
                label: 'Manufacturer',
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: _TextField(
                fieldKey: const Key('editorEquipmentModelField'),
                controller: _controller(_ReportField.equipmentModel),
                label: 'Model',
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorEquipmentSerialField'),
          controller: _controller(_ReportField.equipmentSerial),
          label: 'Serial Number',
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        _SectionHeading(
          icon: Icons.assignment_outlined,
          title: 'Job Details',
          subtitle: 'Record the problem, diagnosis and work completed.',
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorIssueReportedField'),
          controller: _controller(_ReportField.issueReported),
          label: 'Problem / Fault Reported',
          minLines: 2,
          maxLines: 4,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorDiagnosisField'),
          controller: _controller(_ReportField.diagnosis),
          label: 'Diagnosis',
          minLines: 2,
          maxLines: 5,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorWorkPerformedField'),
          controller: _controller(_ReportField.workPerformed),
          label: 'Work Performed',
          hint: 'Describe what you repaired, installed or inspected.',
          minLines: 4,
          maxLines: 8,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.medium),
        _TextField(
          fieldKey: const Key('editorRecommendationsField'),
          controller: _controller(_ReportField.recommendations),
          label: 'Recommendations',
          minLines: 2,
          maxLines: 5,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        _SectionHeading(
          icon: Icons.photo_library_outlined,
          title: 'Photos',
          subtitle: 'Document the work with before, during and after evidence.',
        ),
        const SizedBox(height: AppSpacing.medium),
        _ReportPhotosAction(reportId: reportId),
        const SizedBox(height: AppSpacing.xLarge),
        _SectionHeading(
          icon: Icons.inventory_2_outlined,
          title: 'Materials',
          subtitle: 'Record the parts and materials used for this work.',
        ),
        const SizedBox(height: AppSpacing.medium),
        _ReportMaterialsAction(reportId: reportId),
        const SizedBox(height: AppSpacing.xLarge),
        _SectionHeading(
          icon: Icons.draw_outlined,
          title: 'Signatures',
          subtitle: 'Capture technician and customer sign-off.',
        ),
        const SizedBox(height: AppSpacing.medium),
        _ReportSignaturesAction(reportId: reportId),
        const SizedBox(height: AppSpacing.xLarge),
        _TextField(
          fieldKey: const Key('editorInternalNotesField'),
          controller: _controller(_ReportField.internalNotes),
          label: 'Internal Notes',
          helper: 'Not intended for the final customer-facing report.',
          minLines: 2,
          maxLines: 5,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        Text(
          'Changes are saved automatically.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xLarge),
      ],
    ),
  );

  static String _customerLabel(Customer customer) =>
      customer.companyName == null
      ? customer.name
      : '${customer.name} — ${customer.companyName}';
}

class _ReportPhotosAction extends ConsumerWidget {
  const _ReportPhotosAction({required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(reportPhotosProvider(reportId));
    final count = switch (photos) {
      AsyncData(:final value) => value.length,
      _ => null,
    };
    return OutlinedButton.icon(
      key: const Key('manageReportPhotosAction'),
      onPressed: () => context.pushNamed(
        AppRoute.reportPhotos.name,
        pathParameters: {'reportId': reportId},
      ),
      icon: const Icon(Icons.add_a_photo_outlined),
      label: Text(count == null ? 'Manage Photos' : 'Manage Photos ($count)'),
    );
  }
}

class _ReportMaterialsAction extends ConsumerWidget {
  const _ReportMaterialsAction({required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materials = ref.watch(reportMaterialsProvider(reportId));
    final count = switch (materials) {
      AsyncData(:final value) => value.length,
      _ => null,
    };
    return OutlinedButton.icon(
      key: const Key('manageReportMaterialsAction'),
      onPressed: () => context.pushNamed(
        AppRoute.reportMaterials.name,
        pathParameters: {'reportId': reportId},
      ),
      icon: const Icon(Icons.inventory_2_outlined),
      label: Text(
        count == null ? 'Manage Materials' : 'Manage Materials ($count)',
      ),
    );
  }
}

class _ReportSignaturesAction extends ConsumerWidget {
  const _ReportSignaturesAction({required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signatures = ref.watch(reportSignaturesProvider(reportId));
    final count = switch (signatures) {
      AsyncData(:final value) => value.length,
      _ => null,
    };
    return OutlinedButton.icon(
      key: const Key('manageReportSignaturesAction'),
      onPressed: () => context.pushNamed(
        AppRoute.reportSignatures.name,
        pathParameters: {'reportId': reportId},
      ),
      icon: const Icon(Icons.draw_outlined),
      label: Text(
        count == null ? 'Manage Signatures' : 'Manage Signatures ($count/2)',
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.onChanged,
    this.hint,
    this.helper,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helper;
  final int minLines;
  final int maxLines;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    key: fieldKey,
    controller: controller,
    textCapitalization: TextCapitalization.sentences,
    minLines: minLines,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
    ),
    onChanged: onChanged,
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      const SizedBox(width: AppSpacing.small),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xSmall),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ],
  );
}

class _SaveStatus extends StatelessWidget {
  const _SaveStatus({
    required this.saving,
    required this.error,
    required this.lastSavedAt,
  });

  final bool saving;
  final String? error;
  final DateTime? lastSavedAt;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = saving
        ? (Icons.sync, 'Saving…')
        : error != null
        ? (Icons.error_outline, 'Not saved')
        : lastSavedAt != null
        ? (Icons.check_circle_outline, 'Saved')
        : (Icons.cloud_done_outlined, 'Autosave');
    final color = error == null
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xSmall),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _EditorLoadError extends StatelessWidget {
  const _EditorLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Could not load this report.'),
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
