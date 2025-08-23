import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../project/model/project.dart';

class ProjectDetailsDialog extends StatelessWidget {
  final Project project;
  const ProjectDetailsDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 900;
          final left = Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    project.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (project.subtitle != null && project.subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      project.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 8),
                // Cover
                if (project.coverImageUrl != null &&
                    project.coverImageUrl!.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      project.coverImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 12),
                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(project.description),
                ),
                const SizedBox(height: 12),
                // Links
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    children: [
                      if (project.liveUrl != null)
                        TextButton.icon(
                          onPressed: () => _open(project.liveUrl!),
                          icon: const Icon(Icons.public),
                          label: const Text('Live'),
                        ),
                      if (project.repoUrl != null)
                        TextButton.icon(
                          onPressed: () => _open(project.repoUrl!),
                          icon: const Icon(Icons.code),
                          label: const Text('Repo'),
                        ),
                      if (project.videoUrl != null)
                        TextButton.icon(
                          onPressed: () => _open(project.videoUrl!),
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Video'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: -8,
                    children: [
                      ...project.tech.map(
                        (t) => Chip(
                          label: Text(t),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      ...project.tags.map(
                        (t) => Chip(
                          label: Text('#$t'),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );

          final right = Expanded(
            flex: 2,
            child: project.galleryUrls.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: project.galleryUrls.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemBuilder: (context, i) {
                        final u = project.galleryUrls[i];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(u, fit: BoxFit.cover),
                        );
                      },
                    ),
                  ),
          );

          return SizedBox(
            width: wide ? 1100 : 720,
            height: 640,
            child: Column(
              children: [
                // Close bar
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Expanded(
                  child: wide
                      ? Row(
                          children: [
                            left,
                            const VerticalDivider(width: 1),
                            right,
                          ],
                        )
                      : ListView(
                          children: [
                            left,
                            if (project.galleryUrls.isNotEmpty) const Divider(),
                            if (project.galleryUrls.isNotEmpty)
                              SizedBox(
                                height: 320,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, i) => ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        project.galleryUrls[i],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemCount: project.galleryUrls.length,
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
