class AttendanceOverviewModel {
  bool? success;
  int? count;
  List<AttendanceData>? data;

  AttendanceOverviewModel({
    this.success,
    this.count,
    this.data,
  });

  AttendanceOverviewModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <AttendanceData>[];
      json['data'].forEach((v) {
        data!.add(AttendanceData.fromJson(v));
      });
    }
  }
}

class AttendanceData {
  String? id;
  BranchId? branchId;
  CompanyId? companyId;
  int? month;
  SalesmanId? salesmanId;
  int? year;

  int? totalPresentDays;
  int? totalLeavesTaken;
  int? totalLateIns;
  int? totalHalfDays;

  int? casualLeave;
  int? earnedLeave;
  int? sickLeave;
  int? leaveWithoutPay;

  AttendanceData({
    this.id,
    this.branchId,
    this.companyId,
    this.month,
    this.salesmanId,
    this.year,
    this.totalPresentDays,
    this.totalLeavesTaken,
    this.totalLateIns,
    this.totalHalfDays,
    this.casualLeave,
    this.earnedLeave,
    this.sickLeave,
    this.leaveWithoutPay,
  });

  AttendanceData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    branchId = json['branchId'] != null ? BranchId.fromJson(json['branchId']) : null;
    companyId = json['companyId'] != null ? CompanyId.fromJson(json['companyId']) : null;
    month = json['month'];
    salesmanId = json['salesmanId'] != null ? SalesmanId.fromJson(json['salesmanId']) : null;
    year = json['year'];

    totalPresentDays = json['totalPresentDays'] ?? 0;
    totalLeavesTaken = json['totalLeavesTaken'] ?? 0;
    totalLateIns = json['totalLateIns'] ?? 0;
    totalHalfDays = json['totalHalfDays'] ?? 0;

    casualLeave = json['casualLeave'] ?? 0;
    earnedLeave = json['earnedLeave'] ?? 0;
    sickLeave = json['sickLeave'] ?? 0;
    leaveWithoutPay = json['leaveWithoutPay'] ?? 0;
  }
}

class BranchId {
  String? branchName;
  String? id;

  BranchId({this.branchName, this.id});

  BranchId.fromJson(Map<String, dynamic> json) {
    branchName = json['branchName'];
    id = json['_id'];
  }
}

class CompanyId {
  String? companyName;
  String? id;

  CompanyId({this.companyName, this.id});

  CompanyId.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    id = json['_id'];
  }
}

class SalesmanId {
  String? salesmanName;
  String? username;

  SalesmanId({this.salesmanName, this.username});

  SalesmanId.fromJson(Map<String, dynamic> json) {
    salesmanName = json['salesmanName'];
    username = json['username'];
  }
}
