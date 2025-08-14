import 'package:flutter/material.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:provider/provider.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context, listen: true);
    final experienceList = provider.experiences;
    final error = provider.experienceError;
    if (error.isNotEmpty) {
      return Text(error);
    } else if (experienceList.isEmpty) {
      return Text('No Experience Added');
    } else {
      return Card(
        child: Column(
          children: [
            ...experienceList.map((experience) {
              return ListTile(
                title: Text(experience.title),
                subtitle: Text(experience.company),
              );
            }),
          ],
        ),
      );
    }
  }
}
