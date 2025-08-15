import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {
  final String id;
  final String title;
  final String company;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final List<String> highlights;
  final List<String> tech;

  Experience({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.highlights,
    required this.tech,
  });

  factory Experience.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Experience(
      id: doc.id,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      location: data['location'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] == null
          ? null
          : (data['endDate'] as Timestamp).toDate(),
      isCurrent: data['isCurrent'] ?? false,
      highlights: List<String>.from(data['highlights'] ?? const []),
      tech: List<String>.from(data['tech'] ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate!),
      'isCurrent': isCurrent,
      'highlights': highlights,
      'tech': tech,
    };
  }

  Experience copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrent,
    List<String>? highlights,
    List<String>? tech,
  }) {
    return Experience(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      highlights: highlights ?? this.highlights,
      tech: tech ?? this.tech,
    );
  }
}
