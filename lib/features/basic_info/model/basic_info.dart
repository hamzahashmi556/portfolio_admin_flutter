class BasicInfo {
  final String name;
  final String headline;
  final String phoneNumber;
  final String email;
  final String imageURL;
  final String companyLink;
  final int experience; // in years
  final String about;
  // final List<String> skills;
  final Map<String, List<String>> newSkills;

  BasicInfo({
    required this.name,
    required this.headline,
    required this.imageURL,
    required this.phoneNumber,
    required this.email,
    required this.companyLink,
    required this.experience,
    required this.about,
    required this.newSkills,
  });

  factory BasicInfo.fromMap(Map<String, dynamic> map) {
    // final skills = List<String>.from(map['skills'] ?? const []);
    // Safe parse for new_skills which is stored as a Map<String, List>
    final rawNewSkills = map['newSkills'];
    final Map<String, List<String>> parsedNewSkills = {};
    if (rawNewSkills != null && rawNewSkills is Map) {
      rawNewSkills.forEach((key, value) {
        if (value is List) {
          // convert each item to string to be safe
          parsedNewSkills[key.toString()] = value
              .map((e) => e?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList();
        } else if (value != null) {
          // single value -> convert to single-item list
          parsedNewSkills[key.toString()] = [value.toString()];
        }
      });
    }
    return BasicInfo(
      name: map['name'],
      headline: map['headline'] ?? '',
      imageURL: map['imageURL'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      companyLink: map['companyLink'] ?? '',
      experience: map['experience'] ?? 0,
      about: map['about'] ?? '',
      newSkills: parsedNewSkills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'headline': headline,
      'imageURL': imageURL,
      'phoneNumber': phoneNumber,
      'email': email,
      'companyLink': companyLink,
      'experience': experience,
      'about': about,
      'newSkills': newSkills,
    };
  }
}
