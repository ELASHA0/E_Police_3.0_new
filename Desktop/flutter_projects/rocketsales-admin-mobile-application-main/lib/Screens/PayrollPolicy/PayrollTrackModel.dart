class PayrollTrackModel {
  bool? success;
  String? message;
  int? count;
  int? total;
  int? currentPage;
  int? totalPages;
  List<SalesmanData>? data;

  PayrollTrackModel({
    this.success,
    this.message,
    this.count,
    this.total,
    this.currentPage,
    this.totalPages,
    this.data,
  });

  PayrollTrackModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    total = json['total'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(SalesmanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['count'] = count;
    data['total'] = total;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['data'] = this.data?.map((v) => v.toJson()).toList();
    return data;
  }
}

class SalesmanData {
  String? salesmanId;
  String? salesmanName;
  String? salesmanEmail;
  String? salesmanPhone;
  String? companyId;
  String? companyName;
  String? branchId;
  String? branchName;
  int? grossSalary;
  BankDetails? bankDetails;

  SalesmanData({
    this.salesmanId,
    this.salesmanName,
    this.salesmanEmail,
    this.salesmanPhone,
    this.companyId,
    this.companyName,
    this.branchId,
    this.branchName,
    this.grossSalary,
    this.bankDetails,
  });

  SalesmanData.fromJson(Map<String, dynamic> json) {
    salesmanId = json['salesmanId'];
    salesmanName = json['salesmanName'];
    salesmanEmail = json['salesmanEmail'];
    salesmanPhone = json['salesmanPhone'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    branchId = json['branchId'];
    branchName = json['branchName'];
    grossSalary = json['grossSalary'];
    bankDetails =
    json['bankDetails'] != null ? BankDetails.fromJson(json['bankDetails']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['salesmanId'] = salesmanId;
    data['salesmanName'] = salesmanName;
    data['salesmanEmail'] = salesmanEmail;
    data['salesmanPhone'] = salesmanPhone;
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    data['grossSalary'] = grossSalary;
    data['bankDetails'] = bankDetails?.toJson();
    return data;
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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['accountHolderName'] = accountHolderName;
    data['accountNumber'] = accountNumber;
    data['ifscCode'] = ifscCode;
    data['bankName'] = bankName;
    return data;
  }
}
