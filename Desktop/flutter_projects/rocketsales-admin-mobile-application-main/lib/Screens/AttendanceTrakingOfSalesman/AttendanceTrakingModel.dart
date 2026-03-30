class SalesmanResponse {
  List<SalesmanData>? data;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  SalesmanResponse({this.data, this.total, this.page, this.limit, this.totalPages});

  SalesmanResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SalesmanData>[];
      json['data'].forEach((v) {
        data!.add(SalesmanData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }
}

class SalesmanData {
  String? id;
  String? salesmanName;
  String? salesmanEmail;
  String? salesmanPhone;
  bool? isPayrollTrackCreated;

  SalesmanData({
    this.id,
    this.salesmanName,
    this.salesmanEmail,
    this.salesmanPhone,
    this.isPayrollTrackCreated,
  });

  SalesmanData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    salesmanName = json['salesmanName'];
    salesmanEmail = json['salesmanEmail'];
    salesmanPhone = json['salesmanPhone'];
    isPayrollTrackCreated = json['isPayrollTrackCreated'];
  }
}
