class MonthPayrollDetailModel {
  bool? success;
  String? message;
  num? count;
  List<PayrollDetail>? data;

  MonthPayrollDetailModel({this.success, this.message, this.count, this.data});

  MonthPayrollDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <PayrollDetail>[];
      json['data'].forEach((v) {
        data!.add(PayrollDetail.fromJson(v));
      });
    }
  }
}

class PayrollDetail {
  String? payrollId;
  String? companyName;
  String? branchName;
  String? month;
  num? year;
  String? employeeName;
  num? grossSalary;
  num? totalEarnings;
  num? totalDeductions;
  num? netPay;
  BankDetails? bankDetails;
  String? createdAt;

  PayrollDetail({
    this.payrollId,
    this.companyName,
    this.branchName,
    this.month,
    this.year,
    this.employeeName,
    this.grossSalary,
    this.totalEarnings,
    this.totalDeductions,
    this.netPay,
    this.bankDetails,
    this.createdAt,
  });

  PayrollDetail.fromJson(Map<String, dynamic> json) {
    payrollId = json['payrollId'];
    companyName = json['companyName'];
    branchName = json['branchName'];
    month = json['month'];
    year = json['year'];
    employeeName = json['employeeName'];
    grossSalary = json['grossSalary'];
    totalEarnings = json['totalEarnings'];
    totalDeductions = json['totalDeductions'];
    netPay = json['netPay'];
    bankDetails = json['bankDetails'] != null
        ? BankDetails.fromJson(json['bankDetails'])
        : null;
    createdAt = json['createdAt'];
  }
}

class BankDetails {
  String? accountHolderName;
  String? accountNumber;
  String? ifscCode;
  String? bankName;

  BankDetails({
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
  });

  BankDetails.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['accountHolderName'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    bankName = json['bankName'];
  }
}


// class MonthPayrollDetailModel {
//   bool? success;
//   String? message;
//   int? count;
//   List<PayrollDetail>? data;
//
//   MonthPayrollDetailModel({this.success, this.message, this.count, this.data});
//
//   MonthPayrollDetailModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     count = json['count'];
//     if (json['data'] != null) {
//       data = <PayrollDetail>[];
//       json['data'].forEach((v) {
//         data!.add(PayrollDetail.fromJson(v));
//       });
//     }
//   }
// }
//
// class PayrollDetail {
//   String? payrollId;
//   String? companyName;
//   String? branchName;
//   String? month;
//   int? year;
//   String? employeeName;
//   int? grossSalary;
//   int? totalEarnings;
//   int? totalDeductions;
//   int? netPay;
//   BankDetails? bankDetails;
//   String? createdAt;
//
//   PayrollDetail({
//     this.payrollId,
//     this.companyName,
//     this.branchName,
//     this.month,
//     this.year,
//     this.employeeName,
//     this.grossSalary,
//     this.totalEarnings,
//     this.totalDeductions,
//     this.netPay,
//     this.bankDetails,
//     this.createdAt,
//   });
//
//   PayrollDetail.fromJson(Map<String, dynamic> json) {
//     payrollId = json['payrollId'];
//     companyName = json['companyName'];
//     branchName = json['branchName'];
//     month = json['month'];
//     year = json['year'];
//     employeeName = json['employeeName'];
//     grossSalary = json['grossSalary'];
//     totalEarnings = json['totalEarnings'];
//     totalDeductions = json['totalDeductions'];
//     netPay = json['netPay'];
//     bankDetails = json['bankDetails'] != null
//         ? BankDetails.fromJson(json['bankDetails'])
//         : null;
//     createdAt = json['createdAt'];
//   }
// }
//
// class BankDetails {
//   String? accountHolderName;
//   String? accountNumber;
//   String? ifscCode;
//   String? bankName;
//
//   BankDetails({
//     this.accountHolderName,
//     this.accountNumber,
//     this.ifscCode,
//     this.bankName,
//   });
//
//   BankDetails.fromJson(Map<String, dynamic> json) {
//     accountHolderName = json['accountHolderName'];
//     accountNumber = json['accountNumber'];
//     ifscCode = json['ifscCode'];
//     bankName = json['bankName'];
//   }
// }
