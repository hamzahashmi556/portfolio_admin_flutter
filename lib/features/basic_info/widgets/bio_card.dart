import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/basic_info/model/basic_info.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:portfolio_admin/features/basic_info/widgets/edit_bio.dart';
import 'package:provider/provider.dart';

class BioCard extends StatefulWidget {
  // BasicInfo? info;
  const BioCard({super.key});

  @override
  State<BioCard> createState() => _BioCardState();
}

class _BioCardState extends State<BioCard> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context, listen: true);
    final error = provider.bioError;
    final info = provider.info;
    if (error.isNotEmpty) {
      return Text(error);
    }
    //  else if (info != null) {
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
                  info?.name ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    showEditBasicInfoDialog(info);
                  },
                ),
              ],
            ),
            boldText('Email Address:'),
            Text(info?.email ?? ""),

            boldText('HeadLine'),
            Text(info?.headline ?? ""),

            boldText('Experience:'),
            Text("${info?.experience} years"),

            boldText('About'),
            Text(info?.about ?? ""),

            boldText('Skills'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (info?.newSkills ?? {}).entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: entry.value
                            .map((skill) => Chip(label: Text(skill)))
                            .toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
    // } else {
    //   return const Text("No Info Found");
    // }
  }

  Widget boldText(String title) {
    // Text(title)
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text.rich(
        TextSpan(
          text: title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void showEditBasicInfoDialog(BasicInfo? info) {
    showDialog(
      context: context,
      animationStyle: AnimationStyle(
        curve: Curves.ease,
        reverseCurve: Curves.easeOut,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
      ),
      builder: (context) {
        return EditBio(info);
      },
    );
  }
}
