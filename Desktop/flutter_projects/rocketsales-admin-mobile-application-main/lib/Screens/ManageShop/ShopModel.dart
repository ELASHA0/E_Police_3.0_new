import '../Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';

class Shop {
  final String id;
  final double latitude;
  final double longitude;
  final double radius;
  final String shopName;

  Shop({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.shopName,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
      shopName: json['shopName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'shopName': shopName,
    };
  }
}