class ManualAttendance {
  final String id;
  final String salesmanName;
  final String salesmanPhone;

  ManualAttendance({
    required this.id,
    required this.salesmanName,
    required this.salesmanPhone,
  });

  factory ManualAttendance.fromJson(Map<String, dynamic> json) {
    return ManualAttendance(
      id: json['_id'] ?? "",
      salesmanName: json['salesmanName'] ?? "",
      salesmanPhone: json['salesmanPhone'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'salesmanName': salesmanName,
      'salesmanPhone': salesmanPhone,
    };
  }
}