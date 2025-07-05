class Experience {
  final String title;
  final String company;
  final String period;

  Experience({
    required this.title,
    required this.company,
    required this.period,
  });

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      title: map['title'],
      company: map['company'],
      period: map['period'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'company': company, 'period': period};
  }
}
