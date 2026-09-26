import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_material.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_material_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportMaterialsScreen extends ConsumerWidget {
  const ReportMaterialsScreen({required this.reportId, super.key});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportDetailProvider(reportId));
    final materials = ref.watch(reportMaterialsProvider(reportId));
    final reportValue = switch (report) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final editable = reportValue?.isDraft ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Materials Used')),
      floatingActionButton: editable
          ? FloatingActionButton.extended(
              key: const Key('addReportMaterialAction'),
              onPressed: () => _showMaterialDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Material'),
            )
          : null,
      body: SafeArea(
        child: materials.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ErrorState(
            onRetry: () => ref.invalidate(reportMaterialsProvider(reportId)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _EmptyState(
                editable: editable,
                onAdd: editable
                    ? () => _showMaterialDialog(context, ref)
                    : null,
              );
            }
            return ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.medium,
                AppSpacing.medium,
                AppSpacing.medium,
                96,
              ),
              itemCount: items.length,
              buildDefaultDragHandles: false,
              onReorderItem: editable
                  ? (oldIndex, newIndex) =>
                        _reorder(context, ref, items, oldIndex, newIndex)
                  : (_, _) {},
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  key: ValueKey(item.id),
                  margin: const EdgeInsets.only(bottom: AppSpacing.small),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(_subtitle(item)),
                    leading: editable
                        ? ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          )
                        : const Icon(Icons.inventory_2_outlined),
                    trailing: editable
                        ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showMaterialDialog(
                                  context,
                                  ref,
                                  existing: item,
                                );
                              } else if (value == 'delete') {
                                _delete(context, ref, item);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          )
                        : null,
                    onTap: editable
                        ? () =>
                              _showMaterialDialog(context, ref, existing: item)
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _subtitle(ReportMaterial item) {
    final quantity = item.unit == null
        ? item.quantityLabel
        : '${item.quantityLabel} ${item.unit}';
    return item.notes == null ? quantity : '$quantity · ${item.notes}';
  }

  Future<void> _showMaterialDialog(
    BuildContext context,
    WidgetRef ref, {
    ReportMaterial? existing,
  }) async {
    var name = existing?.name ?? '';
    var quantity = existing?.quantityLabel ?? '1';
    var unit = existing?.unit ?? '';
    var notes = existing?.notes ?? '';
    String? validationError;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add material' : 'Edit material'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: const Key('materialNameField'),
                  initialValue: name,
                  autofocus: existing == null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Material'),
                  onChanged: (value) => name = value,
                ),
                const SizedBox(height: AppSpacing.medium),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('materialQuantityField'),
                        initialValue: quantity,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        onChanged: (value) => quantity = value,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: TextFormField(
                        initialValue: unit,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          hintText: 'm, pcs, L',
                        ),
                        onChanged: (value) => unit = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                TextFormField(
                  initialValue: notes,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Optional',
                  ),
                  onChanged: (value) => notes = value,
                ),
                if (validationError != null) ...[
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    validationError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('saveMaterialAction'),
              onPressed: () {
                final parsed = double.tryParse(quantity.trim());
                if (name.trim().isEmpty) {
                  setDialogState(
                    () => validationError = 'Material name is required.',
                  );
                  return;
                }
                if (parsed == null || parsed <= 0) {
                  setDialogState(
                    () =>
                        validationError = 'Enter a quantity greater than zero.',
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (result == true && context.mounted) {
      try {
        final repository = ref.read(reportMaterialRepositoryProvider);
        final parsed = double.parse(quantity.trim());
        if (existing == null) {
          await repository.addMaterial(
            reportId: reportId,
            name: name,
            quantity: parsed,
            unit: unit,
            notes: notes,
          );
        } else {
          await repository.updateMaterial(
            materialId: existing.id,
            name: name,
            quantity: parsed,
            unit: unit,
            notes: notes,
          );
        }
      } on AppException catch (error) {
        if (context.mounted) _showError(context, error.message);
      }
    }
  }

  Future<void> _reorder(
    BuildContext context,
    WidgetRef ref,
    List<ReportMaterial> current,
    int oldIndex,
    int newIndex,
  ) async {
    final reordered = [...current];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    try {
      await ref
          .read(reportMaterialRepositoryProvider)
          .reorderMaterials(
            reportId: reportId,
            orderedMaterialIds: reordered.map((item) => item.id).toList(),
          );
    } on AppException catch (error) {
      if (context.mounted) _showError(context, error.message);
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ReportMaterial item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete material?'),
        content: Text('Remove ${item.name} from this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(reportMaterialRepositoryProvider).deleteMaterial(item.id);
    } on AppException catch (error) {
      if (context.mounted) _showError(context, error.message);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.editable, required this.onAdd});

  final bool editable;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 48),
          const SizedBox(height: AppSpacing.medium),
          Text(
            'No materials yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            editable
                ? 'Add the parts or materials used for this work.'
                : 'No materials were recorded for this report.',
            textAlign: TextAlign.center,
          ),
          if (editable) ...[
            const SizedBox(height: AppSpacing.large),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Material'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Could not load materials.'),
        const SizedBox(height: AppSpacing.small),
        OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
