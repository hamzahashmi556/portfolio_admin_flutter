// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:portfolio_admin/widgets/input.dart';

// class AdminHome extends StatefulWidget {
//   const AdminHome({super.key});

//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }

// class _AdminHomeState extends State<AdminHome> {
//   final _formKey = GlobalKey<FormState>();

//   final titleController = TextEditingController();
//   final descController = TextEditingController();
//   final toolsController = TextEditingController();
//   final imageUrlController = TextEditingController();
//   final appLinkController = TextEditingController();

//   bool isLoading = false;
//   String message = '';

//   Future<void> _submitProject() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//       message = '';
//     });

//     try {
//       await FirebaseFirestore.instance.collection('projects').add({
//         'title': titleController.text.trim(),
//         'description': descController.text.trim(),
//         'tools': toolsController.text.split(',').map((e) => e.trim()).toList(),
//         'imageUrl': imageUrlController.text.trim(),
//         'appLink': appLinkController.text.trim(),
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       setState(() {
//         message = '✅ Project added successfully!';
//         titleController.clear();
//         descController.clear();
//         toolsController.clear();
//         imageUrlController.clear();
//         appLinkController.clear();
//       });
//     } catch (e) {
//       setState(() {
//         message = '❌ Error: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     descController.dispose();
//     toolsController.dispose();
//     imageUrlController.dispose();
//     appLinkController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Portfolio Admin Panel')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               CustomInput(controller: titleController, label: 'Project Title'),
//               CustomInput(controller: descController, label: 'Description'),
//               CustomInput(
//                 controller: toolsController,
//                 label: 'Tools (comma separated)',
//               ),
//               CustomInput(controller: imageUrlController, label: 'Image URL'),
//               CustomInput(
//                 controller: appLinkController,
//                 label: 'App Store Link',
//               ),
//               const SizedBox(height: 20),
//               isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton.icon(
//                       onPressed: _submitProject,
//                       icon: const Icon(Icons.cloud_upload),
//                       label: const Text("Upload Project"),
//                     ),
//               const SizedBox(height: 10),
//               Text(
//                 message,
//                 style: TextStyle(
//                   color: message.startsWith('✅') ? Colors.green : Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/basic_info/model/basic_info.dart';
import 'package:portfolio_admin/features/project_info/model/project.dart';
import 'package:portfolio_admin/services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BasicInfo? info;
  List<Project> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final basic = await FirestoreService.instance.getBasicInfo();
    final proj = await FirestoreService.instance.getAllProjects();
    setState(() {
      info = basic;
      projects = proj;
      isLoading = false;
    });
  }

  Widget buildInfoCard() {
    if (info == null) return const Text("No Info Found");

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  info!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    // Navigate to EditBasicInfo screen
                    final updated = await Navigator.pushNamed(
                      context,
                      '/editBasicInfo',
                      arguments: info,
                    );
                    if (updated == true) loadData(); // Refresh after save
                  },
                ),
              ],
            ),
            Text(
              info!.role,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(info!.email),
            const SizedBox(height: 10),
            Text("Experience: ${info!.experience} years"),
            const SizedBox(height: 10),
            Text("About:"),
            Text(info!.about),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: info!.skills
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(
              "Work History:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ...info!.experienceList.map(
              (exp) => ListTile(
                title: Text(exp.title),
                subtitle: Text("${exp.company} (${exp.period})"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProjectList() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Portfolio Overview"),
        actions: [
          IconButton(onPressed: loadData, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                children: [
                  buildInfoCard(),
                  const Divider(),
                  buildProjectList(),
                ],
              ),
            ),
    );
  }
}
