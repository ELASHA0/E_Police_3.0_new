class TicketModel {
  final String id;
  final String description;
  final String status;
  final DateTime createdAt;
  final int ticketNumber;

  TicketModel({
    required this.id,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.ticketNumber,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['_id'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      ticketNumber: json['ticketNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'ticketNumber': ticketNumber,
    };
  }
}