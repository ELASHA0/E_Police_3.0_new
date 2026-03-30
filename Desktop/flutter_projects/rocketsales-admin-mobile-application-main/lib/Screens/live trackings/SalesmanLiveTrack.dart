class SalesmanLiveTrack {
  final String? salesmanId;
  final String? salesmanName;
  final String? salesmanEmail;
  final String? salesmanPhone;
  final String? username;
  final String? batteryLevel;
  final String? speed;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? timestamp;

  SalesmanLiveTrack({
    this.salesmanId,
    this.salesmanName,
    this.salesmanEmail,
    this.salesmanPhone,
    this.username,
    this.batteryLevel,
    this.speed,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.timestamp,
  });

  factory SalesmanLiveTrack.fromJson(Map<String, dynamic> json) {
    return SalesmanLiveTrack(
      salesmanId: json['salesmanId'] ?? '',
      salesmanName: json['salesmanName'] ?? '',
      salesmanEmail: json['salesmanEmail'] ?? '',
      salesmanPhone: json['salesmanPhone']?.toString() ?? 'N/A',
      username: json['username'] ?? '',
      batteryLevel: json['batteryLevel'] ?? '',
      speed: json['speed'] ?? '',
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '')?.toLocal(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '')?.toLocal(),
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '')?.toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesmanId': salesmanId,
      'salesmanName': salesmanName,
      'salesmanEmail': salesmanEmail,
      'salesmanPhone': salesmanPhone,
      'username': username,
      'batteryLevel': batteryLevel,
      'speed': speed,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'timestamp': timestamp,
    };
  }
}