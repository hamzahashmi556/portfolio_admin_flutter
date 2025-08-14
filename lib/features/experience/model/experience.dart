class Experience {
  final String? docId;
  final String title;
  final String company;
  final String? companyLink;
  final String about;
  final DateTime startDate;
  final DateTime? endDate;

  Experience({
    this.docId,
    this.companyLink,
    required this.startDate,
    this.endDate,
    required this.about,
    required this.title,
    required this.company,
  });

  factory Experience.fromMap(Map<String, dynamic> map, String docId) {
    return Experience(
      docId: docId,
      title: map['title'],
      company: map['company'],
      companyLink: map['companyLink'],
      startDate: map['startDate'] as DateTime,
      endDate: map['endDate'] as DateTime,
      about: map['about'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'companyLink': companyLink,
      'startDate': startDate,
      'endDate': endDate,
      'about': about,
    };
  }
}
