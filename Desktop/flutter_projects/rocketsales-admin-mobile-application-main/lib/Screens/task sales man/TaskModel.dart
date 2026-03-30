import '../ManageShop/ShopModel.dart';

class Task {
  String? id;
  String? taskDescription;
  String? status;
  DateTime? deadline;
  String? assignedTo;
  String? companyName;
  String? branchName;
  String? supervisorName;
  String? address;
  Shop? shopGeofence;
  DateTime? createdAt;
  DateTime? updatedAt;
  CompletionFields? completionFields;

  Task({
    required this.id,
    required this.taskDescription,
    required this.status,
    required this.deadline,
    required this.assignedTo,
    required this.companyName,
    required this.branchName,
    required this.supervisorName,
    required this.address,
    required this.shopGeofence,
    required this.createdAt,
    required this.updatedAt,
    this.completionFields,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? '',
      taskDescription: json['taskDescription'] ?? '',
      status: json['status'] ?? 'Pending',
      deadline: DateTime.parse(json['deadline']).toLocal(),
      assignedTo: json['assignedTo']['salesmanName'] ?? '',
      companyName: json['companyId']['companyName'] ?? '',
      branchName: json['branchId']['branchName'] ?? '',
      supervisorName: json['supervisorId']['supervisorName'] ?? '',
      address: json['address'] ?? '',
      shopGeofence: json['shopGeofenceId'] != null
          ? Shop.fromJson(json['shopGeofenceId'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      completionFields: json['completionFields'] != null
          ? CompletionFields.fromJson(json['completionFields'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'taskDescription': taskDescription,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'assignedTo': assignedTo,
      'companyId': {'companyName': companyName},
      'branchId': {'branchName': branchName},
      'supervisorId': {'supervisorName': supervisorName},
      'address': address,
      'shopGeofenceId': shopGeofence?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completionFields': completionFields?.toJson(),
    };
  }

  // CopyWith method
  Task copyWith({
    String? id,
    String? taskTitle,
    String? taskDescription,
    String? status,
    DateTime? deadline,
    String? assignedTo,
    String? companyName,
    String? branchName,
    String? supervisorName,
    String? address,
    Shop? shopGeofence,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      taskDescription: taskDescription ?? this.taskDescription,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      assignedTo: assignedTo ?? this.assignedTo,
      companyName: companyName ?? this.companyName,
      branchName: branchName ?? this.branchName,
      supervisorName: supervisorName ?? this.supervisorName,
      address: address ?? this.address,
      shopGeofence: shopGeofence ?? this.shopGeofence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CompletionFields {
  final String? imageUrl;
  final String? audioUrl;
  final DateTime? uploadedAt;

  CompletionFields({
    this.imageUrl,
    this.audioUrl,
    this.uploadedAt,
  });

  factory CompletionFields.fromJson(Map<String, dynamic> json) {
    return CompletionFields(
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      uploadedAt:
      json['uploadedAt'] != null ? DateTime.parse(json['uploadedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'uploadedAt': uploadedAt?.toIso8601String(),
    };
  }
}
