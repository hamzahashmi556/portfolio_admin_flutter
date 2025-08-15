import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/project/model/project.dart';
import 'package:portfolio_admin/features/project/services/project_service.dart';
import 'package:portfolio_admin/widgets/input.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Projects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => _ProjectDialog(),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<List<Project>>(
              stream: ProjectService.instance.stream(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: ${snap.error}'),
                  );
                }
                final items = snap.data ?? [];
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No projects yet.'),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return ListTile(
                      leading: p.coverUrl == null || p.coverUrl!.isEmpty
                          ? const CircleAvatar(child: Icon(Icons.apps))
                          : CircleAvatar(
                              backgroundImage: NetworkImage(p.coverUrl!),
                            ),
                      title: Text(p.name),
                      subtitle: Text(
                        '${p.role} • ${p.featured ? "Featured" : "Regular"}',
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => _ProjectDialog(editing: p),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete project?'),
                                  content: const Text('This cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                await ProjectService.instance.delete(p.id);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectDialog extends StatefulWidget {
  final Project? editing;
  const _ProjectDialog({this.editing});

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  final _name = TextEditingController();
  final _summary = TextEditingController();
  final _role = TextEditingController();
  final _tech = TextEditingController(); // CSV
  final _github = TextEditingController();
  final _liveUrl = TextEditingController();
  final _coverUrl = TextEditingController();
  final _sortOrder = TextEditingController(text: '0');
  DateTime? _startDate;
  DateTime? _endDate;
  bool _featured = false;

  @override
  void initState() {
    super.initState();
    final p = widget.editing;
    if (p != null) {
      _name.text = p.name;
      _summary.text = p.summary;
      _role.text = p.role;
      _tech.text = p.tech.join(', ');
      _github.text = p.github ?? '';
      _liveUrl.text = p.liveUrl ?? '';
      _coverUrl.text = p.coverUrl ?? '';
      _featured = p.featured;
      _sortOrder.text = p.sortOrder.toString();
      _startDate = p.startDate;
      _endDate = p.endDate;
    }
  }

  Future<void> _pickDate(bool start) async {
    final now = DateTime.now();
    final first = DateTime(now.year - 20, 1, 1);
    final initial = start ? (_startDate ?? now) : (_endDate ?? now);
    final picked = await showDatePicker(
      context: context,
      firstDate: first,
      lastDate: DateTime(now.year + 5),
      initialDate: initial,
    );
    if (picked != null) {
      setState(() {
        if (start)
          _startDate = picked;
        else
          _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editing == null ? 'Add Project' : 'Edit Project'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width > 520 ? 560 : double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomInput(controller: _name, label: 'Name'),
              CustomInput(controller: _summary, label: 'Summary', maxLines: 3),
              CustomInput(controller: _role, label: 'Role'),
              CustomInput(
                controller: _tech,
                label: 'Tech (comma-separated)',
                hint: 'Flutter, Firebase, Node.js',
              ),
              CustomInput(
                controller: _github,
                label: 'GitHub URL',
                keyboardType: TextInputType.url,
              ),
              CustomInput(
                controller: _liveUrl,
                label: 'Live URL',
                keyboardType: TextInputType.url,
              ),
              CustomInput(
                controller: _coverUrl,
                label: 'Cover Image URL (optional)',
                keyboardType: TextInputType.url,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _startDate == null
                            ? 'Start Date'
                            : 'Start: ${_startDate!.year}-${_startDate!.month.toString().padLeft(2, "0")}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () => _pickDate(true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _endDate == null
                            ? 'End Date'
                            : 'End: ${_endDate!.year}-${_endDate!.month.toString().padLeft(2, "0")}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () => _pickDate(false),
                      ),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Featured'),
                value: _featured,
                onChanged: (v) => setState(() => _featured = v),
              ),
              TextField(
                controller: _sortOrder,
                decoration: const InputDecoration(
                  labelText: 'Sort Order (0..n)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              // If you want to support uploading to Firebase Storage later, you can
              // add a small "Upload" button here using file_picker + firebase_storage.
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (_name.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Name is required.')),
              );
              return;
            }
            final project = Project(
              id: widget.editing?.id ?? '',
              name: _name.text.trim(),
              summary: _summary.text.trim(),
              role: _role.text.trim(),
              tech: _splitCsv(_tech.text),
              github: _github.text.trim().isEmpty ? null : _github.text.trim(),
              liveUrl: _liveUrl.text.trim().isEmpty
                  ? null
                  : _liveUrl.text.trim(),
              coverUrl: _coverUrl.text.trim().isEmpty
                  ? null
                  : _coverUrl.text.trim(),
              featured: _featured,
              sortOrder: int.tryParse(_sortOrder.text.trim()) ?? 0,
              startDate: _startDate,
              endDate: _endDate,
            );
            if (widget.editing == null) {
              await ProjectService.instance.add(project);
            } else {
              await ProjectService.instance.update(project);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  List<String> _splitCsv(String s) =>
      s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}
