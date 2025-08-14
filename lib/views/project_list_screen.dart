import 'package:flutter/material.dart';
import 'package:portfolio_admin/model/project.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:provider/provider.dart';
import 'project_form.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  @override
  void initState() {
    super.initState();
  }

  void goToEdit(Project project, String docId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectForm(
          // isEditing: true,
          project: project,
          docId: docId,
        ),
      ),
    );
  }

  void goToAddNew() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProjectForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context, listen: true);
    final error = provider.projectsError;
    final projects = provider.projects;
    final isLoading = provider.isLoading;
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (error.isNotEmpty) {
      return Text(error);
    } else if (projects.isEmpty) {
      return Text('no projects added');
    } else {
      return Column(
        children: [
          ...projects.map((project) {
            return buildCard(project);
          }),
        ],
      );

      // return ListView.builder(
      //   itemCount: projects.length,
      //   itemBuilder: (context, index) {
      //     final proj = projects[index];
      //     return
      //   },
      // );
    }
  }

  Widget buildCard(Project proj) {
    return Card(
      child: ListTile(
        title: Text(proj.title),
        subtitle: Text(proj.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => goToEdit(proj, proj.docId!),
            ),
            IconButton(icon: const Icon(Icons.delete), onPressed: null),
          ],
        ),
      ),
    );
  }
}
