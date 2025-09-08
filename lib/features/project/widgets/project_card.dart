import 'package:flutter/material.dart';
import '../../project/model/project.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.onOpen, // open details dialog
    this.onEdit,
    this.onDelete,
    this.onToggleFeatured,
  });

  final Project project;
  final VoidCallback? onOpen;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFeatured;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 180, // compact height
          child: Row(
            children: [
              SizedBox(width: 8), // left padding
              // Thumbnail
              SizedBox(
                width: 160,
                child:
                    project.coverImageUrl != null &&
                        project.coverImageUrl!.isNotEmpty
                    ? Image.network(
                        project.coverImageUrl!,
                        fit: BoxFit.scaleDown,
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_outlined, size: 28),
                      ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (project.featured)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          if (project.inProgress)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.build_circle_outlined,
                                size: 16,
                              ),
                            ),
                          const SizedBox(width: 4),
                          _MoreMenu(
                            onEdit: onEdit,
                            onDelete: onDelete,
                            onToggleFeatured: onToggleFeatured,
                            isFeatured: project.featured,
                          ),
                        ],
                      ),
                      if ((project.subtitle ?? '').isNotEmpty)
                        Text(
                          project.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      // Description 2 lines max
                      Expanded(
                        child: Text(
                          project.description,
                          style: theme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (project.startDate != null && project.endDate != null)
                        Expanded(
                          child: Text(
                            project.startDate!.toString(),
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 6),
                      // Chips (very compact, ellipsized after a few)
                      _MiniChips(tech: project.tech, tags: project.tags),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({
    required this.isFeatured,
    this.onEdit,
    this.onDelete,
    this.onToggleFeatured,
  });

  final bool isFeatured;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFeatured;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      padding: EdgeInsets.zero,
      onSelected: (v) {
        switch (v) {
          case 'edit':
            onEdit?.call();
            break;
          case 'feature':
            onToggleFeatured?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          value: 'feature',
          child: ListTile(
            leading: Icon(isFeatured ? Icons.star_outline : Icons.star),
            title: Text(isFeatured ? 'Unfeature' : 'Feature'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(Icons.more_vert, size: 18),
      ),
    );
  }
}

class _MiniChips extends StatelessWidget {
  const _MiniChips({required this.tech, required this.tags});
  final List<String> tech;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    // cap how many to render for compactness
    final items = <String>[...tech.take(3), ...tags.take(2).map((t) => '#$t')];
    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: -8,
      children: items
          .map(
            (t) => Chip(
              label: Text(t, style: const TextStyle(fontSize: 11)),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
          .toList(),
    );
  }
}
