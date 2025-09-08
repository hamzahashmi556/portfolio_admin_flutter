import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/basic_info/model/basic_info.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:portfolio_admin/widgets/input.dart';
import 'package:provider/provider.dart';

class EditBio extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController headlineController;
  final TextEditingController aboutController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController companyController;
  final TextEditingController experienceController;
  // final String about;
  final List<String> skills;

  EditBio(BasicInfo? info, {super.key})
    : nameController = TextEditingController(text: info?.name),
      headlineController = TextEditingController(text: info?.headline),
      phoneController = TextEditingController(text: info?.phoneNumber),
      emailController = TextEditingController(text: info?.email),
      companyController = TextEditingController(text: info?.companyLink),
      experienceController = TextEditingController(
        text: info?.experience.toString(),
      ),
      skills = info?.skills ?? [],
      aboutController = TextEditingController(text: info?.about);

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final skillController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Basic Info'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(controller: widget.nameController, label: 'name'),
            CustomInput(
              controller: widget.headlineController,
              label: 'headline',
            ),
            CustomInput(controller: widget.aboutController, label: 'about'),
            CustomInput(controller: widget.phoneController, label: 'phone'),
            CustomInput(controller: widget.emailController, label: 'email'),
            CustomInput(controller: widget.companyController, label: 'company'),
            CustomInput(
              controller: widget.experienceController,
              label: 'experience',
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
                  onPressed: () {
                    setState(() {
                      if (skillController.text.trim().isNotEmpty) {
                        widget.skills.add(skillController.text.trim());
                        skillController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: widget.skills
                  .map(
                    (s) => Chip(
                      label: Text(s),
                      onDeleted: () => {
                        setState(() {
                          widget.skills.remove(s);
                        }),
                      },
                    ),
                  )
                  .toList(),
            ),
            // SkillsList(
            //   skills: skills,
            //   onDeleted: (s) {
            //     setState(() {
            //       skills.remove(s);
            //     });
            //   },
            // ),
            // TextField(
            //   controller: nameController,
            //   decoration: InputDecoration(labelText: "name"),
            // ),
            Spacer(),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // style: ButtonStyle(maximumSize: Size.),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedInfo = BasicInfo(
                        name: widget.nameController.text.trim(),
                        headline: widget.headlineController.text.trim(),
                        phoneNumber: widget.phoneController.text.trim(),
                        email: widget.emailController.text.trim(),
                        companyLink: widget.companyController.text.trim(),
                        experience:
                            int.tryParse(
                              widget.experienceController.text.trim(),
                            ) ??
                            0,
                        about: widget.aboutController.text
                            .trim(), // keeping same for now
                        skills: widget.skills,
                      );

                      await Provider.of<InfoProvider>(
                        context,
                        listen: false,
                      ).setBio(updatedInfo);

                      if (!context.mounted) {
                        return; // ✅ Prevents using context if widget is disposed
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Basic Info Updated!")),
                      );
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
