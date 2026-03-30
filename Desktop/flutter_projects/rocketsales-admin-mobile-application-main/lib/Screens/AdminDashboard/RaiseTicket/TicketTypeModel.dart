class TicketTypeModel {
  final String id;
  final String type;
  final DateTime createdAt;

  TicketTypeModel({
    required this.id,
    required this.type,
    required this.createdAt,
  });

  factory TicketTypeModel.fromJson(Map<String, dynamic> json) {
    return TicketTypeModel(
      id: json['_id'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
