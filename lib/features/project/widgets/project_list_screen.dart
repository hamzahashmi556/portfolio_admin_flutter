import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/project/services/project_service.dart';
import 'package:portfolio_admin/features/project/widgets/project_card.dart';
import 'package:portfolio_admin/provider/project_provider.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProjectsProvider(service: ProjectService())..bind(),
      child: const _ProjectListBody(),
    );
  }
}

class _ProjectListBody extends StatefulWidget {
  const _ProjectListBody();

  @override
  State<_ProjectListBody> createState() => _ProjectListBodyState();
}

class _ProjectListBodyState extends State<_ProjectListBody> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectsProvider>();
    var items = provider.projects;

    return LayoutBuilder(
      builder: (context, c) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Projects',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _search,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search by title, tech, tags...',
                      ),
                      onChanged: (v) =>
                          context.read<ProjectsProvider>().query = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilterChip(
                    label: const Text('Featured only'),
                    selected: provider.onlyFeatured,
                    onSelected: (v) => provider.onlyFeatured = v,
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () => provider.addNew(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Project'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      final json = provider.exportJson();
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: SingleChildScrollView(
                            child: SelectableText(json),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text('Export JSON'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Center(child: Text('No projects yet'))
              else
                Column(
                  spacing: 30,
                  children: [
                    for (final p in items)
                      ProjectCard(
                        project: p,
                        // onTap: () => showDialog(
                        //   context: context,
                        //   barrierDismissible: true,
                        //   builder: (_) => ProjectDetailsDialog(project: p),
                        // ),
                        onEdit: () =>
                            context.read<ProjectsProvider>().edit(context, p),
                        onDelete: () =>
                            context.read<ProjectsProvider>().delete(p),
                        onToggleFeatured: () =>
                            context.read<ProjectsProvider>().toggleFeatured(p),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
