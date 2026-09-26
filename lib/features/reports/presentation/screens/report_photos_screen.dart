import 'dart:async';
import 'dart:io';

import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo.dart';
import 'package:fieldproof_360/features/reports/domain/models/report_photo_category.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_photo_providers.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportPhotosScreen extends ConsumerStatefulWidget {
  const ReportPhotosScreen({required this.reportId, super.key});

  final String reportId;

  @override
  ConsumerState<ReportPhotosScreen> createState() => _ReportPhotosScreenState();
}

class _ReportPhotosScreenState extends ConsumerState<ReportPhotosScreen> {
  ReportPhotoCategory _category = ReportPhotoCategory.before;
  bool _importing = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(_recoverLostImages()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(reportDetailProvider(widget.reportId));
    final photos = ref.watch(reportPhotosProvider(widget.reportId));
    final isEditable = switch (report) {
      AsyncData(:final value) => value?.isDraft ?? false,
      _ => false,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Report Photos')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.medium,
                AppSpacing.small,
                AppSpacing.medium,
                AppSpacing.small,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<ReportPhotoCategory>(
                  segments: ReportPhotoCategory.values
                      .map(
                        (category) => ButtonSegment(
                          value: category,
                          label: Text(category.displayLabel),
                        ),
                      )
                      .toList(growable: false),
                  selected: {_category},
                  onSelectionChanged: (selection) {
                    if (selection.isNotEmpty) {
                      setState(() => _category = selection.first);
                    }
                  },
                ),
              ),
            ),
            if (isEditable)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        key: const Key('takeReportPhotoAction'),
                        onPressed: _importing
                            ? null
                            : () => _pick(camera: true),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Expanded(
                      child: FilledButton.icon(
                        key: const Key('chooseReportPhotosAction'),
                        onPressed: _importing
                            ? null
                            : () => _pick(camera: false),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
              ),
            if (_importing)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.small),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: AppSpacing.small),
            Expanded(
              child: photos.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _PhotosError(
                  onRetry: () =>
                      ref.invalidate(reportPhotosProvider(widget.reportId)),
                ),
                data: (items) {
                  final filtered = items
                      .where((photo) => photo.category == _category)
                      .toList(growable: false);
                  if (filtered.isEmpty) {
                    return _PhotoEmptyState(
                      category: _category,
                      editable: isEditable,
                    );
                  }
                  return ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.medium,
                      AppSpacing.small,
                      AppSpacing.medium,
                      AppSpacing.large,
                    ),
                    itemCount: filtered.length,
                    onReorderItem: isEditable
                        ? (oldIndex, newIndex) =>
                              _reorder(filtered, oldIndex, newIndex)
                        : (_, _) {},
                    buildDefaultDragHandles: false,
                    itemBuilder: (context, index) {
                      final photo = filtered[index];
                      return _PhotoTile(
                        key: ValueKey(photo.id),
                        index: index,
                        photo: photo,
                        editable: isEditable,
                        onEdit: () => _editPhoto(photo),
                        onDelete: () => _deletePhoto(photo),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pick({required bool camera}) async {
    final picker = ref.read(reportImagePickerProvider);
    try {
      final paths = camera
          ? await picker.pickFromCamera()
          : await picker.pickFromGallery();
      await _importPaths(paths);
    } on AppException catch (error) {
      _showError(error.message);
    }
  }

  Future<void> _recoverLostImages() async {
    try {
      final paths = await ref
          .read(reportImagePickerProvider)
          .recoverLostImages();
      if (paths.isNotEmpty) {
        await _importPaths(
          paths,
          categoryOverride: ReportPhotoCategory.general,
        );
      }
    } on AppException catch (error) {
      _showError(error.message);
    }
  }

  Future<void> _importPaths(
    List<String> paths, {
    ReportPhotoCategory? categoryOverride,
  }) async {
    if (paths.isEmpty || _importing) return;
    setState(() => _importing = true);
    try {
      final repository = ref.read(reportPhotoRepositoryProvider);
      final category = categoryOverride ?? _category;
      for (final path in paths) {
        await repository.importPhoto(
          reportId: widget.reportId,
          sourcePath: path,
          category: category,
        );
      }
    } on AppException catch (error) {
      _showError(error.message);
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _reorder(
    List<ReportPhoto> current,
    int oldIndex,
    int newIndex,
  ) async {
    final reordered = [...current];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    try {
      await ref
          .read(reportPhotoRepositoryProvider)
          .reorderPhotos(
            reportId: widget.reportId,
            category: _category,
            orderedPhotoIds: reordered
                .map((photo) => photo.id)
                .toList(growable: false),
          );
    } on AppException catch (error) {
      _showError(error.message);
    }
  }

  Future<void> _editPhoto(ReportPhoto photo) async {
    final caption = TextEditingController(text: photo.caption ?? '');
    var category = photo.category;
    final result =
        await showDialog<({String caption, ReportPhotoCategory category})>(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: const Text('Photo details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<ReportPhotoCategory>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: ReportPhotoCategory.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.displayLabel),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => category = value);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    TextField(
                      controller: caption,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Caption',
                        hintText: 'Optional note about this photo',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop((caption: caption.text, category: category)),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
    caption.dispose();
    if (result == null) return;
    try {
      await ref
          .read(reportPhotoRepositoryProvider)
          .updatePhoto(
            photoId: photo.id,
            category: result.category,
            caption: result.caption,
          );
      if (mounted && result.category != _category) {
        setState(() => _category = result.category);
      }
    } on AppException catch (error) {
      _showError(error.message);
    }
  }

  Future<void> _deletePhoto(ReportPhoto photo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete photo?'),
        content: const Text('This removes the photo from this draft report.'),
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
      await ref.read(reportPhotoRepositoryProvider).deletePhoto(photo.id);
    } on AppException catch (error) {
      _showError(error.message);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.index,
    required this.photo,
    required this.editable,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final int index;
  final ReportPhoto photo;
  final bool editable;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final path = photo.thumbnailPath ?? photo.filePath;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.small),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(path),
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 88,
                  height: 88,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.caption ?? 'No caption',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  Text(
                    photo.category.displayLabel,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            if (editable) ...[
              IconButton(
                tooltip: 'Edit photo',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete photo',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.small),
                  child: Icon(Icons.drag_handle),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PhotoEmptyState extends StatelessWidget {
  const _PhotoEmptyState({required this.category, required this.editable});

  final ReportPhotoCategory category;
  final bool editable;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo_library_outlined, size: 48),
          const SizedBox(height: AppSpacing.medium),
          Text(
            'No ${category.displayLabel.toLowerCase()} photos yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            editable
                ? 'Use the camera or gallery buttons above to document the work.'
                : 'No photos were added in this category.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _PhotosError extends StatelessWidget {
  const _PhotosError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Could not load report photos.'),
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
