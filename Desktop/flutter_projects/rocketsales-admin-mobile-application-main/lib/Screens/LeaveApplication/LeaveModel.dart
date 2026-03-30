import 'package:rocketsales_admin/Screens/Orders/OrdersAndProductsClass.dart';

class Leave {
  final String id;
  final SalesmanId? salesman;
  final String leaveStartdate;
  final String leaveEnddate;
  final String reason;
  final String status;

  Leave(
      {
        required this.id,
        this.salesman,
        required this.leaveStartdate,
        required this.leaveEnddate,
        required this.reason,
        required this.status,
      });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['_id']?.toString() ?? '',
      salesman: json['salesmanId'] != null
          ? SalesmanId.fromJson(json['salesmanId'])
          : null,
      leaveStartdate: json['leaveStartdate']?.toString() ?? '',
      leaveEnddate: json['leaveEnddate']?.toString() ?? '',
      reason: json['reason'] ?? '',
      status: json['leaveRequestStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "salesmanId": salesman,
      "leaveStartdate": leaveStartdate,
      "leaveEnddate": leaveEnddate,
      "reason": reason,
      "leaveRequestStatus": status,
    };
  }
}