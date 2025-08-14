import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/experience/model/experience.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:provider/provider.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context);
    final experienceList = provider.experiences;
    final error = provider.experienceError;

    if (error.isNotEmpty) {
      return Text(error);
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text("Experience"),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showExperienceForm(context);
              },
            ),
          ),
          if (experienceList.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No Experience Added'),
            )
          else
            ...experienceList.map((exp) {
              return ListTile(
                title: Text("${exp.title} at ${exp.company}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_formatDate(exp.startDate)} - ${exp.endDate != null ? _formatDate(exp.endDate!) : 'Present'}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(exp.about),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showExperienceForm(context, experience: exp);
                  },
                ),
              );
            }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.year}";
  }

  void _showExperienceForm(BuildContext context, {Experience? experience}) {
    final titleController = TextEditingController(
      text: experience?.title ?? "",
    );
    final companyController = TextEditingController(
      text: experience?.company ?? "",
    );
    final companyLinkController = TextEditingController(
      text: experience?.companyLink ?? "",
    );
    final aboutController = TextEditingController(
      text: experience?.about ?? "",
    );
    DateTime? startDate = experience?.startDate;
    DateTime? endDate = experience?.endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Job Title"),
                ),
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: "Company"),
                ),
                TextField(
                  controller: companyLinkController,
                  decoration: const InputDecoration(labelText: "Company Link"),
                ),
                TextField(
                  controller: aboutController,
                  decoration: const InputDecoration(labelText: "About"),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) startDate = picked;
                        },
                        child: Text(
                          startDate == null
                              ? "Select Start Date"
                              : _formatDate(startDate!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) endDate = picked;
                        },
                        child: Text(
                          endDate == null
                              ? "Select End Date"
                              : _formatDate(endDate!),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        companyController.text.isEmpty ||
                        aboutController.text.isEmpty ||
                        startDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill required fields"),
                        ),
                      );
                      return;
                    }

                    final newExp = Experience(
                      docId: experience?.docId,
                      title: titleController.text,
                      company: companyController.text,
                      companyLink: companyLinkController.text,
                      about: aboutController.text,
                      startDate: startDate!,
                      endDate: endDate,
                    );

                    if (experience == null) {
                      Provider.of<InfoProvider>(
                        context,
                        listen: false,
                      ).addExperience(newExp);
                    } else {
                      Provider.of<InfoProvider>(
                        context,
                        listen: false,
                      ).updateExperience(newExp);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(experience == null ? "Add Experience" : "Update"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
