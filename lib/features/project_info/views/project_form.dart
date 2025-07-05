import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/project_info/model/project.dart';
import 'package:portfolio_admin/services/firebase_service.dart';

class ProjectForm extends StatefulWidget {
  final Project? project;
  final String? docId;
  const ProjectForm({super.key, this.project, this.docId});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController imageUrlController;
  late TextEditingController imageUrlsController;
  late TextEditingController altTextsController;
  late TextEditingController appLinkController;
  late TextEditingController toolsController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    titleController = TextEditingController(text: project?.title);
    descController = TextEditingController(text: project?.description);
    imageUrlController = TextEditingController(text: project?.imageUrl);
    imageUrlsController = TextEditingController(
      text: project?.imageUrls.join(", "),
    );
    altTextsController = TextEditingController(
      text: project?.altTexts.join(", "),
    );
    appLinkController = TextEditingController(text: project?.appLink);
    toolsController = TextEditingController(text: project?.tools.join(", "));
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    imageUrlController.dispose();
    imageUrlsController.dispose();
    altTextsController.dispose();
    appLinkController.dispose();
    toolsController.dispose();
    super.dispose();
  }

  Future<void> saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final project = Project(
      title: titleController.text,
      description: descController.text,
      imageUrl: imageUrlController.text,
      imageUrls: imageUrlsController.text
          .split(',')
          .map((e) => e.trim())
          .toList(),
      altTexts: altTextsController.text
          .split(',')
          .map((e) => e.trim())
          .toList(),
      appLink: appLinkController.text,
      tools: toolsController.text.split(',').map((e) => e.trim()).toList(),
    );

    if (widget.docId != null) {
      await FirestoreService.instance.updateProject(widget.docId!, project);
    } else {
      await FirestoreService.instance.addProject(project);
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docId == null ? 'Add Project' : 'Edit Project'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                    ),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Primary Image URL',
                      ),
                    ),
                    TextFormField(
                      controller: imageUrlsController,
                      decoration: const InputDecoration(
                        labelText: 'Image URLs (comma-separated)',
                      ),
                    ),
                    TextFormField(
                      controller: altTextsController,
                      decoration: const InputDecoration(
                        labelText: 'Alt Texts (comma-separated)',
                      ),
                    ),
                    TextFormField(
                      controller: appLinkController,
                      decoration: const InputDecoration(labelText: 'App Link'),
                    ),
                    TextFormField(
                      controller: toolsController,
                      decoration: const InputDecoration(
                        labelText: 'Tools (comma-separated)',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveProject,
                      child: Text(widget.docId == null ? 'Add' : 'Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
