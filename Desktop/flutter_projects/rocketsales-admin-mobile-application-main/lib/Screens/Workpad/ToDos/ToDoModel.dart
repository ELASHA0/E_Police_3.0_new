class ToDoModel {
  final String id;
  final String title;
  final String description;
  String status;
  DateTime createdAt;

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt
  });

  // Convert a ToDoModel object to a map (for saving to JSON, database, etc.)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt,
    };
  }

  // Create a ToDoModel object from a map
  factory ToDoModel.fromJson(Map<String, dynamic> json) {
    return ToDoModel(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
