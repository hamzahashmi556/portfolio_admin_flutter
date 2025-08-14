// import 'package:flutter/material.dart';
// import 'package:portfolio_admin/model/expreince.dart';
// import 'package:portfolio_admin/provider/info_provider.dart';
// import 'package:portfolio_admin/services/bio_service.dart';
// import 'package:provider/provider.dart';
// import '../model/basic_info.dart';

// class EditInfoScreen extends StatefulWidget {
//   // final BasicInfo info;

//   // const EditInfoScreen({required this.info});
//   const EditInfoScreen({Key? key}) : super(key: key);

//   @override
//   State<EditInfoScreen> createState() => _EditInfoScreenState();
// }

// class _EditInfoScreenState extends State<EditInfoScreen> {
//   final nameController = TextEditingController();
//   final roleController = TextEditingController();
//   final emailController = TextEditingController();
//   final aboutController = TextEditingController();
//   final experienceController = TextEditingController();
//   final skillController = TextEditingController();
//   final skills = <String>[];

//   final expTitleController = TextEditingController();
//   final expCompanyController = TextEditingController();
//   final expPeriodController = TextEditingController();
//   List<Experience> experienceList = [];

//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // loadBasicInfo();
//   }

//   void loadBasicInfo() {
//     final provider = Provider.of<InfoProvider>(context);
//     final info = provider.info;
//     if (info != null) {
//       nameController.text = info.name;
//       roleController.text = info.role;
//       emailController.text = info.email;
//       aboutController.text = info.about;
//       experienceController.text = info.experience.toString();
//       skills.addAll(info.skills);
//       experienceList = info.experienceList;
//     }
//   }

//   Future<void> saveInfo() async {
//     setState(() => isLoading = true);
//     final provider = Provider.of<InfoProvider>(context);
//     await provider.setInfo(
//       BasicInfo(
//         name: nameController.text,
//         role: roleController.text,
//         email: emailController.text,
//         about: aboutController.text,
//         skills: skills,
//         experience: int.tryParse(experienceController.text) ?? 0,
//         experienceList: experienceList,
//       ),
//     );
//     setState(() => isLoading = false);
//     if (context.mounted) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Saved!")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Basic Info")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 children: [
//                   buildTextField("Name", nameController),
//                   buildTextField("Role", roleController),
//                   buildTextField("Email", emailController),
//                   buildTextField("About", aboutController, maxLines: 4),
//                   buildTextField(
//                     "Experience (years)",
//                     experienceController,
//                     keyboardType: TextInputType.number,
//                   ),

//                   const SizedBox(height: 20),
//                   const Text(
//                     "Skills",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: buildTextField("Add Skill", skillController),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: () {
//                           setState(() {
//                             if (skillController.text.trim().isNotEmpty) {
//                               skills.add(skillController.text.trim());
//                               skillController.clear();
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   Wrap(
//                     spacing: 8,
//                     children: skills
//                         .map(
//                           (s) => Chip(
//                             label: Text(s),
//                             onDeleted: () => setState(() => skills.remove(s)),
//                           ),
//                         )
//                         .toList(),
//                   ),

//                   const SizedBox(height: 20),
//                   const Text(
//                     "Experience List",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   buildTextField("Title", expTitleController),
//                   buildTextField("Company", expCompanyController),
//                   buildTextField("Period", expPeriodController),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         experienceList.add(
//                           Experience(
//                             title: expTitleController.text,
//                             company: expCompanyController.text,
//                             period: expPeriodController.text,
//                           ),
//                         );
//                         expTitleController.clear();
//                         expCompanyController.clear();
//                         expPeriodController.clear();
//                       });
//                     },
//                     child: const Text("➕ Add Experience"),
//                   ),
//                   const SizedBox(height: 10),

//                   ListView.builder(
//                     itemCount: experienceList.length,
//                     itemBuilder: (context, index) {
//                       final exp = experienceList[index];
//                       // return SizedBox();
//                       return ListTile(
//                         title: Text(exp.title),
//                         subtitle: Text("${exp.company} • ${exp.period}"),
//                         trailing: Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               onPressed: () =>
//                                   showEditExperienceDialog(exp, index),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () =>
//                                   setState(() => experienceList.remove(exp)),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: saveInfo,
//                     child: const Text("💾 Save"),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget buildTextField(
//     String label,
//     TextEditingController controller, {
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   void showEditExperienceDialog(Experience exp, int index) {
//     final titleController = TextEditingController(text: exp.title);
//     final companyController = TextEditingController(text: exp.company);
//     final periodController = TextEditingController(text: exp.period);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Edit Experience"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: "Title"),
//             ),
//             TextField(
//               controller: companyController,
//               decoration: const InputDecoration(labelText: "Company"),
//             ),
//             TextField(
//               controller: periodController,
//               decoration: const InputDecoration(labelText: "Period"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), // Cancel
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 experienceList[index] = Experience(
//                   title: titleController.text,
//                   company: companyController.text,
//                   period: periodController.text,
//                 );
//               });
//               Navigator.pop(context);
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }
// }
