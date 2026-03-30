class ReminderModelDate {
  final String id;
  final String title;
  final DateTime reminderAt;
  final String description;
  final String createdByRole;
  final String createdById;
  final bool isActive;
  final DateTime createdAt;

  ReminderModelDate({
    required this.id,
    required this.title,
    required this.reminderAt,
    required this.description,
    required this.createdByRole,
    required this.createdById,
    required this.isActive,
    required this.createdAt,
  });

  factory ReminderModelDate.fromJson(Map<String, dynamic> json) {
    return ReminderModelDate(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      reminderAt: DateTime.parse(json['reminderAt']).toLocal(),
      description: json['description'] ?? '',
      createdByRole: json['createdByRole'] ?? '',
      createdById: json['createdById'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'reminderAt': reminderAt.toLocal(),
      'description': description,
      'createdByRole': createdByRole,
      'createdById': createdById,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}

class RenderOfMonth {
  final DateTime date;
  final int remindersCount;

  RenderOfMonth({required this.date, required this.remindersCount});

  factory RenderOfMonth.fromJson(Map<String, dynamic> json) {
    return RenderOfMonth(
      date: DateTime.parse(json['date']),
      remindersCount: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'count': remindersCount
  };
}