import 'package:rocketsales_admin/Screens/Expense/ExpenseModel.dart';

class SalesmanModel {
  final String? id;
  final String? salesmanName;
  final String? profileImage;
  final String? salesmanEmail;
  final String? salesmanPhone;
  final String? username;
  final String? password;
  final int? role;
  final String? companyId;
  final String? branchId;
  final String? supervisorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? companyName;
  final String? branchName;
  final String? supervisorName;


  SalesmanModel({
    required this.id,
    required this.salesmanName,
    this.profileImage,
    required this.salesmanEmail,
    required this.salesmanPhone,
    required this.username,
    required this.password,
    required this.role,
    required this.companyId,
    required this.branchId,
    required this.supervisorId,
    required this.createdAt,
    required this.updatedAt,
    required this.companyName,
    required this.branchName,
    required this.supervisorName,
  });

  factory SalesmanModel.fromJson(Map<String, dynamic> json) {
    return SalesmanModel(
      id: json['_id'] ?? "",
      salesmanName: json['salesmanName'] ?? "",
      profileImage: json['profileImage'], // stays nullable
      salesmanEmail: json['salesmanEmail'] ?? "",
      salesmanPhone: json['salesmanPhone'] ?? "",
      username: json['username'] ?? "",
      password: json['password'] ?? "",
      role: json['role'] ?? 0,
      companyId: json['companyId'] ?? "",
      branchId: json['branchId'] ?? "",
      supervisorId: json['supervisorId'] ?? "",
      createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? "") ?? DateTime.now(),
      companyName: json['companyName'] ?? "",
      branchName: json['branchName'] ?? "",
      supervisorName: json['supervisorName'] ?? "",
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'salesmanName': salesmanName,
      'profileImage': profileImage,
      'salesmanEmail': salesmanEmail,
      'salesmanPhone': salesmanPhone,
      'username': username,
      'password': password,
      'role': role,
      'companyId': companyId,
      'branchId': branchId,
      'supervisorId': supervisorId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'companyName': companyName,
      'branchName': branchName,
      'supervisorName': supervisorName,
    };
  }
}