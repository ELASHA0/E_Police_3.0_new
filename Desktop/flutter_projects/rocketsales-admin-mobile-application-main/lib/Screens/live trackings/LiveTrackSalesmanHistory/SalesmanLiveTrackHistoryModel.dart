class SalesmanLiveTrackHistoryModel {
  final String id;
  final String username;
  final String salesmanId;
  final String batteryLevel;
  final String distance;
  final String speed;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  SalesmanLiveTrackHistoryModel({
    required this.id,
    required this.username,
    required this.salesmanId,
    required this.batteryLevel,
    required this.distance,
    required this.speed,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory SalesmanLiveTrackHistoryModel.fromJson(Map<String, dynamic> json) {
    final parsedTime = DateTime.tryParse(json['timestamp'] ?? '');
    return SalesmanLiveTrackHistoryModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      salesmanId: json['salesmanId'] ?? '',
      batteryLevel: json['batteryLevel'] ?? '',
      distance: json['distance'] ?? '',
      speed: json['speed'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: parsedTime != null ? parsedTime.toLocal() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'salesmanId': salesmanId,
      'batteryLevel': batteryLevel,
      'distance': distance,
      'speed': speed,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toLocal(),
    };
  }
}
