import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore path: users/{uid}/projects/{projectId}
class Project {
  final String? id; // nullable to support "create" flow
  final String title;
  final String? subtitle;
  final String description;
  final List<String> tags; // keywords/categories
  final List<String> tech; // Flutter, Swift, Node, etc.
  final bool featured; // pin to top
  final bool inProgress; // still building?
  final int order; // manual sorting
  final DateTime? startDate;
  final DateTime? endDate;
  final String? coverImageUrl; // hero image
  final List<String> galleryUrls; // extra screenshots
  final String? repoUrl;
  final String? liveUrl;
  final String? videoUrl;

  const Project({
    this.id,
    required this.title,
    this.subtitle,
    required this.description,
    this.tags = const [],
    this.tech = const [],
    this.featured = false,
    this.inProgress = false,
    this.order = 0,
    this.startDate,
    this.endDate,
    this.coverImageUrl,
    this.galleryUrls = const [],
    this.repoUrl,
    this.liveUrl,
    this.videoUrl,
  });

  Project copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    List<String>? tags,
    List<String>? tech,
    bool? featured,
    bool? inProgress,
    int? order,
    DateTime? startDate,
    DateTime? endDate,
    String? coverImageUrl,
    List<String>? galleryUrls,
    String? repoUrl,
    String? liveUrl,
    String? videoUrl,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      tech: tech ?? this.tech,
      featured: featured ?? this.featured,
      inProgress: inProgress ?? this.inProgress,
      order: order ?? this.order,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      repoUrl: repoUrl ?? this.repoUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  Map<String, dynamic> toMapForWrite({required bool isCreate}) {
    final map = {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'tags': tags,
      'tech': tech,
      'featured': featured,
      'inProgress': inProgress,
      'order': order,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'coverImageUrl': coverImageUrl,
      'galleryUrls': galleryUrls,
      'repoUrl': repoUrl,
      'liveUrl': liveUrl,
      'videoUrl': videoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (isCreate) map['createdAt'] = FieldValue.serverTimestamp();
    return map;
  }

  factory Project.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Project(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      subtitle: data['subtitle'] as String?,
      description: (data['description'] ?? '') as String,
      tags:
          (data['tags'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      tech:
          (data['tech'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      featured: (data['featured'] ?? false) as bool,
      inProgress: (data['inProgress'] ?? false) as bool,
      order: (data['order'] ?? 0) as int,
      startDate: (data['startDate'] is Timestamp)
          ? (data['startDate'] as Timestamp).toDate()
          : null,
      endDate: (data['endDate'] is Timestamp)
          ? (data['endDate'] as Timestamp).toDate()
          : null,
      coverImageUrl: data['coverImageUrl'] as String?,
      galleryUrls:
          (data['galleryUrls'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      repoUrl: data['repoUrl'] as String?,
      liveUrl: data['liveUrl'] as String?,
      videoUrl: data['videoUrl'] as String?,
    );
  }

  Map<String, dynamic> toExportJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'tags': tags,
    'tech': tech,
    'featured': featured,
    'inProgress': inProgress,
    'order': order,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'coverImageUrl': coverImageUrl,
    'galleryUrls': galleryUrls,
    'repoUrl': repoUrl,
    'liveUrl': liveUrl,
    'videoUrl': videoUrl,
  };
}
