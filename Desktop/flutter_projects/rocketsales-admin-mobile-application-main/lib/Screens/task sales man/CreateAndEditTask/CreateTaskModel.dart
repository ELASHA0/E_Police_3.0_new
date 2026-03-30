class CreateTask {
  final String id;
  final String taskDescription;
  final String status;
  final DateTime deadline;
  final String assignedTo;
  final String companyId;
  final String branchId;
  final String supervisorId;
  final String address;
  final String shopGeofenceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CreateTask({
    required this.id,
    required this.taskDescription,
    required this.status,
    required this.deadline,
    required this.assignedTo,
    required this.companyId,
    required this.branchId,
    required this.supervisorId,
    required this.address,
    required this.shopGeofenceId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CreateTask.fromJson(Map<String, dynamic> json) {
    return CreateTask(
      id: json['_id'] as String,
      taskDescription: json['taskDescription'] as String,
      status: json['status'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      assignedTo: json['assignedTo'] as String,
      companyId: json['companyId'] as String,
      branchId: json['branchId'] as String,
      supervisorId: json['supervisorId'] as String,
      address: json['address'] as String,
      shopGeofenceId: json['shopGeofenceId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'taskDescription': taskDescription,
      'status': status,
      'deadline': deadline.toIso8601String(),
      'assignedTo': assignedTo,
      'companyId': companyId,
      'branchId': branchId,
      'supervisorId': supervisorId,
      'address': address,
      'shopGeofenceId': shopGeofenceId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
