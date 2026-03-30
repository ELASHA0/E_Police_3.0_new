
import '../../Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';

class LeadModel {
  final String id;
  final String leadTitle;
  final String clientName;
  final String clientEmail;
  final int clientPhone;
  final String clientAdd;
  final String shopName;
  final String notes;
  final String status;
  final Company? companyId;
  final Branch? branchId;
  final Salesman? salesmanId;
  final Supervisor? supervisorId;
  final String createdByRole;
  final String createdById;
  final DateTime createdAt;

  LeadModel({
    required this.id,
    required this.leadTitle,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAdd,
    required this.shopName,
    required this.notes,
    required this.status,
    this.companyId,
    this.branchId,
    this.salesmanId,
    this.supervisorId,
    required this.createdByRole,
    required this.createdById,
    required this.createdAt,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['_id'] ?? '',
      leadTitle: json['leadTitle'] ?? '',
      clientName: json['clientName'] ?? '',
      clientEmail: json['clientEmail'] ?? '',
      clientPhone: json['clientPhone'] ?? 0,
      clientAdd: json['clientAdd'] ?? '',
      shopName: json['shopName'] ?? '',
      notes: json['Notes'] ?? '',
      status: json['status'] ?? '',
      companyId: json['companyId'] != null ? Company.fromJson(json['companyId']) : null,
      branchId: json['branchId'] != null ? Branch.fromJson(json['branchId']) : null,
      salesmanId: json['salesmanId'] != null ? Salesman.fromJson(json['salesmanId']) : null,
      supervisorId: json['supervisorId'] != null ? Supervisor.fromJson(json['supervisorId']) : null,
      createdByRole: json['createdByRole'] ?? '',
      createdById: json['createdById'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'leadTitle': leadTitle,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'clientAdd': clientAdd,
      'shopName': shopName,
      'Notes': notes,
      'status': status,
      'companyId': companyId?.toJson(),
      'branchId': branchId?.toJson(),
      'salesmanId': salesmanId?.toJson(),
      'supervisorId': supervisorId?.toJson(),
      'createdByRole': createdByRole,
      'createdById': createdById,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}