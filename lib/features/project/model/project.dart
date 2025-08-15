import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String name;
  final String summary;
  final String role;
  final List<String> tech;
  final String? github;
  final String? liveUrl;
  final String? coverUrl; // optional image
  final bool featured;
  final int sortOrder;
  final DateTime? startDate;
  final DateTime? endDate;

  Project({
    required this.id,
    required this.name,
    required this.summary,
    required this.role,
    required this.tech,
    this.github,
    this.liveUrl,
    this.coverUrl,
    this.featured = false,
    this.sortOrder = 0,
    this.startDate,
    this.endDate,
  });

  factory Project.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Project(
      id: doc.id,
      name: d['name'] ?? '',
      summary: d['summary'] ?? '',
      role: d['role'] ?? '',
      tech: List<String>.from(d['tech'] ?? const []),
      github: d['github'],
      liveUrl: d['liveUrl'],
      coverUrl: d['coverUrl'],
      featured: d['featured'] ?? false,
      sortOrder: (d['sortOrder'] ?? 0) as int,
      startDate: d['startDate'] == null
          ? null
          : (d['startDate'] as Timestamp).toDate(),
      endDate: d['endDate'] == null
          ? null
          : (d['endDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'summary': summary,
      'role': role,
      'tech': tech,
      'github': github,
      'liveUrl': liveUrl,
      'coverUrl': coverUrl,
      'featured': featured,
      'sortOrder': sortOrder,
      'startDate': startDate == null ? null : Timestamp.fromDate(startDate!),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate!),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    String? summary,
    String? role,
    List<String>? tech,
    String? github,
    String? liveUrl,
    String? coverUrl,
    bool? featured,
    int? sortOrder,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      role: role ?? this.role,
      tech: tech ?? this.tech,
      github: github ?? this.github,
      liveUrl: liveUrl ?? this.liveUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      featured: featured ?? this.featured,
      sortOrder: sortOrder ?? this.sortOrder,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
