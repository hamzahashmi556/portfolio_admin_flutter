import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/project_info/model/project.dart';
import 'package:portfolio_admin/services/firebase_service.dart';
import 'project_form.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<Project> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    final data = await FirestoreService.instance.getAllProjects();
    setState(() {
      projects = data;
      isLoading = false;
    });
  }

  Future<void> deleteProject(String docId) async {
    await FirestoreService.instance.deleteProject(docId);
    fetchProjects(); // Refresh after deletion
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
    ).then((_) => fetchProjects());
  }

  void goToAddNew() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProjectForm()),
    ).then((_) => fetchProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
        actions: [
          IconButton(onPressed: goToAddNew, icon: const Icon(Icons.add)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final proj = projects[index];
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
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteProject(proj.docId!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
