import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../project/model/project.dart';
import '../../project/services/project_service.dart';

class ProjectEditorDialog extends StatefulWidget {
  final Project? initial;
  final ProjectService service;

  const ProjectEditorDialog({super.key, required this.service, this.initial});

  @override
  State<ProjectEditorDialog> createState() => _ProjectEditorDialogState();
}

class _ProjectEditorDialogState extends State<ProjectEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _subtitle;
  late TextEditingController _description;
  late TextEditingController _tags;
  late TextEditingController _tech;
  late TextEditingController _repoUrl;
  late TextEditingController _liveUrl;
  late TextEditingController _videoUrl;

  // Image URLs instead of pickers
  late TextEditingController _coverUrl;
  final List<TextEditingController> _galleryCtrls = [];

  bool _featured = false;
  bool _inProgress = false;
  int _order = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _title = TextEditingController(text: p?.title ?? '');
    _subtitle = TextEditingController(text: p?.subtitle ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _tags = TextEditingController(text: (p?.tags ?? []).join(', '));
    _tech = TextEditingController(text: (p?.tech ?? []).join(', '));
    _repoUrl = TextEditingController(text: p?.repoUrl ?? '');
    _liveUrl = TextEditingController(text: p?.liveUrl ?? '');
    _videoUrl = TextEditingController(text: p?.videoUrl ?? '');

    _coverUrl = TextEditingController(text: p?.coverImageUrl ?? '');
    for (final u in p?.galleryUrls ?? const <String>[]) {
      _galleryCtrls.add(TextEditingController(text: u));
    }
    if (_galleryCtrls.isEmpty) {
      _galleryCtrls.add(TextEditingController());
    }

    _featured = p?.featured ?? false;
    _inProgress = p?.inProgress ?? false;
    _order = p?.order ?? 0;
    _startDate = p?.startDate;
    _endDate = p?.endDate;
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _description.dispose();
    _tags.dispose();
    _tech.dispose();
    _repoUrl.dispose();
    _liveUrl.dispose();
    _videoUrl.dispose();
    _coverUrl.dispose();
    for (final c in _galleryCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  bool _isUrl(String s) {
    if (s.trim().isEmpty) return false;
    final uri = Uri.tryParse(s.trim());
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final gallery = _galleryCtrls
        .map((c) => c.text.trim())
        .where((u) => _isUrl(u))
        .toList();

    final project = Project(
      id: widget.initial?.id,
      title: _title.text.trim(),
      subtitle: _subtitle.text.trim().isEmpty ? null : _subtitle.text.trim(),
      description: _description.text.trim(),
      tags: _tags.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      tech: _tech.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      featured: _featured,
      inProgress: _inProgress,
      order: _order,
      startDate: _startDate,
      endDate: _endDate,
      coverImageUrl: _isUrl(_coverUrl.text) ? _coverUrl.text.trim() : null,
      galleryUrls: gallery,
      repoUrl: _repoUrl.text.trim().isEmpty ? null : _repoUrl.text.trim(),
      liveUrl: _liveUrl.text.trim().isEmpty ? null : _liveUrl.text.trim(),
      videoUrl: _videoUrl.text.trim().isEmpty ? null : _videoUrl.text.trim(),
    );

    if (widget.initial == null) {
      await widget.service.create(project);
    } else {
      await widget.service.update(project);
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.initial == null ? 'Add Project' : 'Edit Project',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: 460,
                              child: TextFormField(
                                controller: _title,
                                decoration: const InputDecoration(
                                  labelText: 'Title *',
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: 460,
                              child: TextFormField(
                                controller: _subtitle,
                                decoration: const InputDecoration(
                                  labelText: 'Subtitle',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 460,
                              child: TextFormField(
                                controller: _tech,
                                decoration: const InputDecoration(
                                  labelText: 'Tech (comma-separated)',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 460,
                              child: TextFormField(
                                controller: _tags,
                                decoration: const InputDecoration(
                                  labelText: 'Tags (comma-separated)',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 460,
                              child: TextFormField(
                                controller: _repoUrl,
                                decoration: const InputDecoration(
                                  labelText: 'Repository URL',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 460,
                              child: TextFormField(
                                controller: _liveUrl,
                                decoration: const InputDecoration(
                                  labelText: 'Live URL',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 460,
                              child: TextFormField(
                                controller: _videoUrl,
                                decoration: const InputDecoration(
                                  labelText: 'Video/Demo URL',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 940,
                              child: TextFormField(
                                controller: _description,
                                decoration: const InputDecoration(
                                  labelText: 'Description *',
                                ),
                                minLines: 4,
                                maxLines: 8,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Image URL inputs + previews
                        Text(
                          'Images',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        // Cover URL
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _coverUrl,
                                decoration: const InputDecoration(
                                  labelText: 'Cover Image URL (https://...)',
                                  hintText: 'Paste a direct image URL',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (v) {
                                  if ((v ?? '').trim().isEmpty)
                                    return null; // optional
                                  return _isUrl(v!.trim())
                                      ? null
                                      : 'Invalid URL';
                                },
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _PreviewBox(url: _coverUrl.text),
                          ],
                        ),

                        const SizedBox(height: 12),
                        // Gallery URLs (dynamic rows)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Gallery URLs'),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () => setState(
                                    () => _galleryCtrls.add(
                                      TextEditingController(),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add URL'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ..._galleryCtrls.asMap().entries.map((e) {
                              final i = e.key;
                              final ctrl = e.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: ctrl,
                                        decoration: InputDecoration(
                                          labelText: 'Gallery URL ${i + 1}',
                                          suffixIcon: ctrl.text.isEmpty
                                              ? null
                                              : IconButton(
                                                  onPressed: () => setState(
                                                    () => ctrl.clear(),
                                                  ),
                                                  icon: const Icon(Icons.clear),
                                                ),
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (v) {
                                          if ((v ?? '').trim().isEmpty)
                                            return null; // optional row
                                          return _isUrl(v!.trim())
                                              ? null
                                              : 'Invalid URL';
                                        },
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _PreviewBox(url: ctrl.text),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: 'Remove row',
                                      onPressed: () => setState(
                                        () => _galleryCtrls.removeAt(i),
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Flags, order, dates
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Featured'),
                                Switch(
                                  value: _featured,
                                  onChanged: (v) =>
                                      setState(() => _featured = v),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('In Progress'),
                                Switch(
                                  value: _inProgress,
                                  onChanged: (v) =>
                                      setState(() => _inProgress = v),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                initialValue: '$_order',
                                decoration: const InputDecoration(
                                  labelText: 'Sort Order',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => _order = int.tryParse(v) ?? 0,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Start: ${_startDate != null ? df.format(_startDate!) : '-'}',
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () async {
                                    final now = DateTime.now();
                                    final picked = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(now.year + 5),
                                      initialDate: _startDate ?? now,
                                    );
                                    if (picked != null)
                                      setState(() => _startDate = picked);
                                  },
                                  child: const Text('Pick'),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'End: ${_endDate != null ? df.format(_endDate!) : '-'}',
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () async {
                                    final now = DateTime.now();
                                    final picked = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(now.year + 5),
                                      initialDate: _endDate ?? now,
                                    );
                                    if (picked != null)
                                      setState(() => _endDate = picked);
                                  },
                                  child: const Text('Pick'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Project'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    final valid =
        Uri.tryParse(url)?.hasAbsolutePath == true &&
        (url.startsWith('http://') || url.startsWith('https://'));
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 64,
        width: 114,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: valid
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.broken_image_outlined);
                },
              )
            : const Icon(Icons.image_outlined),
      ),
    );
  }
}
