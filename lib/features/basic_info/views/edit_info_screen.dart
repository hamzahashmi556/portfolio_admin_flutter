import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/basic_info/model/basic_info.dart';
import 'package:portfolio_admin/features/basic_info/model/expreince.dart';
import 'package:portfolio_admin/services/firebase_service.dart';

class EditBasicInfoScreen extends StatefulWidget {
  const EditBasicInfoScreen({super.key});

  @override
  State<EditBasicInfoScreen> createState() => _EditBasicInfoScreenState();
}

class _EditBasicInfoScreenState extends State<EditBasicInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController aboutController;
  late TextEditingController experienceController;

  List<String> skills = [];
  List<Experience> experienceList = [];

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final info = ModalRoute.of(context)!.settings.arguments as BasicInfo;
    nameController = TextEditingController(text: info.name);
    roleController = TextEditingController(text: info.role);
    emailController = TextEditingController(text: info.email);
    aboutController = TextEditingController(text: info.about);
    experienceController = TextEditingController(
      text: info.experience.toString(),
    );
    skills = List.from(info.skills);
    experienceList = List.from(info.experienceList);
  }

  Future<void> saveInfo() async {
    setState(() => isLoading = true);

    final updatedInfo = BasicInfo(
      name: nameController.text,
      role: roleController.text,
      email: emailController.text,
      about: aboutController.text,
      experience: int.tryParse(experienceController.text) ?? 0,
      skills: skills,
      experienceList: experienceList,
    );

    await FirestoreService.instance.setBasicInfo(updatedInfo);
    setState(() => isLoading = false);
    if (context.mounted) {
      Navigator.pop(context, true); // Return to HomeScreen with refresh flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Info")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: aboutController,
                    decoration: const InputDecoration(labelText: 'About'),
                  ),
                  TextField(
                    controller: experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Experience (years)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: saveInfo,
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                  ),
                ],
              ),
            ),
    );
  }
}
