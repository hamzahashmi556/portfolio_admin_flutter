import 'package:portfolio_admin/features/basic_info/model/expreince.dart';

class BasicInfo {
  final String name;
  final String role;
  final String email;
  final int experience; // in years
  final String about;
  final List<String> skills;
  final List<Experience> experienceList;

  BasicInfo({
    required this.name,
    required this.role,
    required this.email,
    required this.experience,
    required this.about,
    required this.skills,
    required this.experienceList,
  });

  factory BasicInfo.fromMap(Map<String, dynamic> map) {
    return BasicInfo(
      name: map['name'],
      role: map['role'],
      email: map['email'],
      experience: map['experience'],
      about: map['about'],
      skills: List<String>.from(map['skills']),
      experienceList: List<Experience>.from(
        (map['experienceList'] as List).map((e) => Experience.fromMap(e)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'experience': experience,
      'about': about,
      'skills': skills,
      'experienceList': experienceList.map((e) => e.toMap()).toList(),
    };
  }
}
