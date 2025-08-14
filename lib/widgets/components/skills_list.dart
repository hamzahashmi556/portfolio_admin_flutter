import 'package:flutter/material.dart';

class SkillsList extends StatelessWidget {
  List<String> skills;
  Function(String) onDeleted;
  SkillsList({super.key, required this.skills, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: skills
          .map((s) => Chip(label: Text(s), onDeleted: () => onDeleted(s)))
          .toList(),
    );
  }
}
