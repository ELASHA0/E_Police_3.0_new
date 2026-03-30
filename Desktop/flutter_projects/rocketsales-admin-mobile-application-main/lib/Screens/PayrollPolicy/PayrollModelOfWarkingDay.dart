class PayrollWorkingDayModel {
  bool? success;
  String? message;
  PayrollData? payroll;

  PayrollWorkingDayModel({this.success, this.message, this.payroll});

  PayrollWorkingDayModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    payroll = json['payroll'] != null
        ? PayrollData.fromJson(json['payroll'])
        : null;
  }
}

class PayrollData {
  String? id;
  CompanyId? companyId;
  BranchId? branchId;
  BankDetails1? bankDetails;

  String? employeeName;
  String? employeeType;

  num? grossSalary;
  num? allowance;
  num? incentive;
  num? bonusAmount;

  num? perDaySalary;

  num? lateArrivalDeductionAmount;
  num? halfDayDeductionAmount;
  num? absentDeduction;
  num? leaveWithoutPayDeduction;

  num? totalEarnings;
  num? totalDeductions;
  num? netPay;
  num? salaryYouWillReceive;
  num? salaryTillNow;

  PayrollData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];

    companyId = json['companyId'] != null
        ? CompanyId.fromJson(json['companyId'])
        : null;

    branchId = json['branchId'] != null
        ? BranchId.fromJson(json['branchId'])
        : null;

    employeeName = json['employeeName'];
    employeeType = json['employeeType'];

    grossSalary = json['grossSalary'];
    allowance = json['allowance'];
    incentive = json['incentive'];
    bonusAmount = json['bonusAmount'];

    perDaySalary = json['perDaySalary'];

    lateArrivalDeductionAmount = json['lateArrivalDeductionAmount'];
    halfDayDeductionAmount = json['halfDayDeductionAmount'];
    absentDeduction = json['absentDeduction'];
    leaveWithoutPayDeduction = json['leaveWithoutPayDeduction'];

    totalEarnings = json['totalEarnings'];
    totalDeductions = json['totalDeductions'];
    netPay = json['netPay'];
    salaryYouWillReceive = json['salaryYouWillRecive'];

    salaryTillNow = json['salaryTillNow'];

    bankDetails = json['bankDetails'] != null
        ? BankDetails1.fromJson(json['bankDetails'])
        : null;
  }
}

class CompanyId {
  String? companyName;

  CompanyId({this.companyName});

  CompanyId.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
  }
}

class BranchId {
  String? branchName;

  BranchId({this.branchName});

  BranchId.fromJson(Map<String, dynamic> json) {
    branchName = json['branchName'];
  }
}

class BankDetails1 {
  String? accountHolderName;
  String? accountNumber;
  String? ifscCode;
  String? bankName;

  BankDetails1({
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
  });

  BankDetails1.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['accountHolderName'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    bankName = json['bankName'];
  }
}

