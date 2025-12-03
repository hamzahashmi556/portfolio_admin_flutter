import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/basic_info/model/basic_info.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:portfolio_admin/widgets/input.dart';
import 'package:provider/provider.dart';

class EditBio extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController headlineController;
  final TextEditingController imageURLController;
  final TextEditingController aboutController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController companyController;
  final TextEditingController experienceController;
  final BasicInfo? bio;
  // final String about;
  // final List<String> skills;

  EditBio(BasicInfo? info, {super.key})
    : nameController = TextEditingController(text: info?.name),
      headlineController = TextEditingController(text: info?.headline),
      imageURLController = TextEditingController(text: info?.imageURL),
      phoneController = TextEditingController(text: info?.phoneNumber),
      emailController = TextEditingController(text: info?.email),
      companyController = TextEditingController(text: info?.companyLink),
      experienceController = TextEditingController(
        text: info?.experience.toString(),
      ),
      // skills = info?.skills ?? [],
      bio = info,
      aboutController = TextEditingController(text: info?.about);

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final skillController = TextEditingController();
  late Map<String, List<String>> categorizedSkills;
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    categorizedSkills = Map.from(widget.bio?.newSkills ?? {});
    if (categorizedSkills.keys.isNotEmpty) {
      selectedCategory = categorizedSkills.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Basic Info'),
      content: Column(
        spacing: 25,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [textFields(), skillSection(), skillsWrap()],
              ),
            ),
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [cancelButton(), saveButton()],
          ),
        ],
      ),
    );
  }

  Widget skillSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          children: [
            Expanded(child: categoryDropdown()),
            addCategoryButton(),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CustomInput(
                controller: skillController,
                label: "Add Skill",
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: addSkillToCategory,
            ),
          ],
        ),
        skillsWrap(),
      ],
    );
  }

  Widget skillsWrap() {
    return Wrap(
      spacing: 8,
      children: categorizedSkills[selectedCategory]!
          .map(
            (s) => Chip(
              label: Text(s),
              onDeleted: () => {
                setState(() {
                  categorizedSkills[selectedCategory]!.remove(s);
                }),
              },
            ),
          )
          .toList(),
    );
  }

  Widget categoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory.isEmpty ? null : selectedCategory,
      items: categorizedSkills.keys
          .map((key) => DropdownMenuItem(value: key, child: Text(key)))
          .toList(),
      onChanged: (val) {
        setState(() {
          selectedCategory = val ?? "";
        });
      },
      decoration: const InputDecoration(labelText: "Category"),
    );
  }

  final categoryController = TextEditingController();

  Widget addCategoryButton() {
    return IconButton(
      icon: const Icon(Icons.create_new_folder),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("New Category"),
              content: CustomInput(
                controller: categoryController,
                label: "Category Name",
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("Add"),
                  onPressed: () {
                    final name = categoryController.text.trim();
                    if (name.isNotEmpty &&
                        !categorizedSkills.containsKey(name)) {
                      setState(() {
                        categorizedSkills[name] = [];
                        selectedCategory = name;
                      });
                    }
                    categoryController.clear();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget addSkillField() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: CustomInput(controller: skillController, label: "Add Skill"),
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.add),
  //         onPressed: () {
  //           setState(() {
  //             if (skillController.text.trim().isNotEmpty) {
  //               widget.skills.add(skillController.text.trim());
  //               skillController.clear();
  //             }
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget textFields() {
    return Column(
      children: [
        CustomInput(controller: widget.nameController, label: 'name'),
        CustomInput(controller: widget.headlineController, label: 'headline'),
        CustomInput(controller: widget.imageURLController, label: 'image url'),
        CustomInput(controller: widget.aboutController, label: 'about'),
        CustomInput(controller: widget.phoneController, label: 'phone'),
        CustomInput(controller: widget.emailController, label: 'email'),
        CustomInput(controller: widget.companyController, label: 'company'),
        CustomInput(
          controller: widget.experienceController,
          label: 'experience',
        ),
      ],
    );
  }

  Widget cancelButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
        // style: ButtonStyle(maximumSize: Size.),
      ),
    );
  }

  Widget saveButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          final updatedInfo = BasicInfo(
            name: widget.nameController.text.trim(),
            imageURL: widget.imageURLController.text.trim(),
            headline: widget.headlineController.text.trim(),
            phoneNumber: widget.phoneController.text.trim(),
            email: widget.emailController.text.trim(),
            companyLink: widget.companyController.text.trim(),
            experience:
                int.tryParse(widget.experienceController.text.trim()) ?? 0,
            about: widget.aboutController.text.trim(), // keeping same for now
            newSkills: categorizedSkills,
          );

          await Provider.of<InfoProvider>(
            context,
            listen: false,
          ).setBio(updatedInfo);

          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Basic Info Updated!")),
            );
          }
        },
        child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void addSkillToCategory() {
    if (selectedCategory.isEmpty) return;

    final skill = skillController.text.trim();
    if (skill.isEmpty) return;

    setState(() {
      categorizedSkills[selectedCategory]!.add(skill);
      skillController.clear();
    });
  }
}
