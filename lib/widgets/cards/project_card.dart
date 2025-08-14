import 'package:flutter/material.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:provider/provider.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context, listen: true);
    final error = provider.projectsError;
    final projects = provider.projects;

    if (error.isNotEmpty) {
      return Text(error);
    } else if (projects.isEmpty) {
      return Text('No Projects Added');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Projects",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...projects.map(
            (project) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                title: Text(project.title),
                subtitle: Text(project.description),
                trailing: IconButton(
                  icon: const Icon(Icons.link),
                  onPressed: () {
                    // Launch project link if needed
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
