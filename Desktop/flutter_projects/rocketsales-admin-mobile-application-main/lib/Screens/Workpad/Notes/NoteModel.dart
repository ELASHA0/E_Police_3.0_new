class NoteModel {
  final String id;
  final String title;
  final String description;
  DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt
  });

  // Convert a NoteModel object to a map (for saving to JSON, database, etc.)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }

  // Create a NoteModel object from a map
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
