import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/basic_info/model/expreince.dart';
import 'package:portfolio_admin/services/firebase_service.dart';
import '../model/basic_info.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final emailController = TextEditingController();
  final aboutController = TextEditingController();
  final experienceController = TextEditingController();
  final skillController = TextEditingController();
  final skills = <String>[];

  final expTitleController = TextEditingController();
  final expCompanyController = TextEditingController();
  final expPeriodController = TextEditingController();
  List<Map<String, dynamic>> experienceList = [];

  final service = FirestoreService.instance;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadBasicInfo();
  }

  Future<void> loadBasicInfo() async {
    setState(() => isLoading = true);
    final info = await service.getBasicInfo();
    if (info != null) {
      nameController.text = info.name;
      roleController.text = info.role;
      emailController.text = info.email;
      aboutController.text = info.about;
      experienceController.text = info.experience.toString();
      skills.addAll(info.skills);
      experienceList = info.experienceList.map((e) => e.toMap()).toList();
    }
    setState(() => isLoading = false);
  }

  Future<void> saveInfo() async {
    setState(() => isLoading = true);

    final parsedExperience = this.experienceList
        .map((e) => Experience.fromMap(e))
        .toList();

    final info = BasicInfo(
      name: nameController.text,
      role: roleController.text,
      email: emailController.text,
      about: aboutController.text,
      skills: skills,
      experience: int.tryParse(experienceController.text) ?? 0,
      experienceList: parsedExperience,
    );

    await service.setBasicInfo(info);
    setState(() => isLoading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Saved!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Basic Info")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  buildTextField("Name", nameController),
                  buildTextField("Role", roleController),
                  buildTextField("Email", emailController),
                  buildTextField("About", aboutController, maxLines: 4),
                  buildTextField(
                    "Experience (years)",
                    experienceController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Skills",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField("Add Skill", skillController),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (skillController.text.trim().isNotEmpty) {
                              skills.add(skillController.text.trim());
                              skillController.clear();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: skills
                        .map(
                          (s) => Chip(
                            label: Text(s),
                            onDeleted: () => setState(() => skills.remove(s)),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Experience List",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  buildTextField("Title", expTitleController),
                  buildTextField("Company", expCompanyController),
                  buildTextField("Period", expPeriodController),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        experienceList.add({
                          'title': expTitleController.text,
                          'company': expCompanyController.text,
                          'period': expPeriodController.text,
                        });
                        expTitleController.clear();
                        expCompanyController.clear();
                        expPeriodController.clear();
                      });
                    },
                    child: const Text("➕ Add Experience"),
                  ),
                  const SizedBox(height: 10),
                  ...experienceList.map(
                    (exp) => ListTile(
                      title: Text(exp['title'] ?? ''),
                      subtitle: Text("${exp['company']} • ${exp['period']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            setState(() => experienceList.remove(exp)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveInfo,
                    child: const Text("💾 Save"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
