import 'dart:convert';

import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';

import '../../AttendanceTrakingOfSalesman/AttendanceOverviewModel.dart';

class LeadManagement {
  final String? leadTitle;
  final String? agenda;

  final String? clientName; //is a string
  final String? clientEmail; //is a string
  final String? clientPhone; // ph no are string
  final String? clientAdd; // string
  final String? shopName;
  final String? branchName;
  final String? createdAt;
  final String? notes;
  final String? id;
  final String? status;
  final bool? self;
  final String? createdByRole;
  final CompanyId? company;
  final BranchId? branch;
  final Salesman? salesman;
  final Supervisor? supervisor;
  

  LeadManagement({
    required this.leadTitle,
    required this.agenda,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAdd,
    required this.shopName,
    required this.branchName,
    required this.createdAt,
    this.notes,
    required this.id,
    required this.status,
    required this.self,
    required this.createdByRole,
    required this.company,
    required this.branch,
    required this.salesman,
    required this.supervisor,
  });

  factory LeadManagement.fromJson(Map<String, dynamic> json) => LeadManagement(
    // when we want to change an object from  json
    leadTitle: json['leadTitle']?.toString() ?? '',
    agenda: json['agenda']?.toString() ?? '',

    clientName: json['clientName']?.toString() ?? '',
    clientEmail: json['clientEmail']?.toString() ?? '',
    clientPhone: json['clientPhone']?.toString() ?? '',
    clientAdd: json['clientAdd']?.toString() ?? '',
    shopName: json['shopName']?.toString() ?? '',
    branchName: json['branchName']?.toString() ?? '',
    createdAt: json['createdAt']?.toString() ?? '',
    notes: json['Notes']?.toString() ?? '',
    id: json['_id']?.toString() ?? '',

    status: json['status'] ?? '',
    self: json['self'] ?? false,
    createdByRole: json['createdByRole'] ?? '',

    company: json['companyId'] != null
        ? CompanyId.fromJson(json['companyId'])
        : null,

    branch: json['branchId'] != null
        ? BranchId.fromJson(json['branchId'])
        : null,

    salesman: json['salesmanId'] != null
        ? Salesman.fromJson(json['salesmanId'])
        : null,

    supervisor: json['supervisorId'] != null
        ? Supervisor.fromJson(json['supervisorId'])
        : null,
  );

  Map<String, dynamic> toJson() {
    return {
      'leadTitle': leadTitle,
      'agenda': agenda,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientAdd': clientAdd,
      'shopName': shopName,
      'branchName': branchName,
      'clientPhone': clientPhone,
      'createdAt': createdAt,
      'Notes': notes,
      'id': id,
    };
  }
}

// class Company {
//   final String? id;
//   final String? companyName;
//
//   Company({
//     required this.id,
//     required this.companyName,
//   });
//
//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       id: json['_id'] ?? '',
//       companyName: json['companyName'] ?? '',
//     );
//   }
// }
//
// class Branch {
//   final String? id;
//   final String? branchName;
//
//   Branch({
//     required this.id,
//     required this.branchName,
//   });
//
//   factory Branch.fromJson(Map<String, dynamic> json) {
//     return Branch(
//       id: json['_id'] ?? '',
//       branchName: json['branchName'] ?? '',
//     );
//   }
// }
//
class Salesman {
  final String? id;
  final String? salesmanName;

  Salesman({this.id, this.salesmanName});

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json['_id']?.toString() ?? '',
      salesmanName: json['salesmanName']?.toString() ?? '',
    );
  }
}
//
// class Supervisor {
//   final String? id;
//   final String? supervisorName;
//
//   Supervisor({
//     required this.id,
//     required this.supervisorName,
//   });
//
//   factory Supervisor.fromJson(Map<String, dynamic> json) {
//     return Supervisor(
//       id: json['_id'] ?? '',
//       supervisorName: json['supervisorName'] ?? '',
//     );
//   }
// }
