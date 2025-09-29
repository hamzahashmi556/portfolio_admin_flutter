class BasicInfo {
  final String name;
  final String headline;
  final String phoneNumber;
  final String email;
  final String imageURL;
  final String companyLink;
  final int experience; // in years
  final String about;
  final List<String> skills;

  BasicInfo({
    required this.name,
    required this.headline,
    required this.imageURL,
    required this.phoneNumber,
    required this.email,
    required this.companyLink,
    required this.experience,
    required this.about,
    required this.skills,
  });

  factory BasicInfo.fromMap(Map<String, dynamic> map) {
    return BasicInfo(
      name: map['name'],
      headline: map['headline'] ?? '',
      imageURL: map['imageURL'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      companyLink: map['companyLink'] ?? '',
      experience: map['experience'] ?? 0,
      about: map['about'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
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
      'skills': skills,
    };
  }
}
