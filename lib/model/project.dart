class Project {
  final String? docId; // optional for fetching
  final String title;
  final String description;
  final String imageUrl;
  final List<String> imageUrls;
  final List<String> altTexts;
  final String appLink;
  final List<String> tools;

  Project({
    this.docId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageUrls,
    required this.altTexts,
    required this.appLink,
    required this.tools,
  });

  factory Project.fromMap(Map<String, dynamic> map, String docId) {
    return Project(
      docId: docId,
      title: map['title'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls']),
      altTexts: List<String>.from(map['altTexts']),
      appLink: map['appLink'],
      tools: List<String>.from(map['tools']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'imageUrls': imageUrls,
      'altTexts': altTexts,
      'appLink': appLink,
      'tools': tools,
    };
  }
}
