class TodayAttendance {
  final String? id;
  final String? profileImgUrl;
  final String? attendenceStatus;
  final Salesman? salesmanId;
  final Company? companyId;
  final Branch? branchId;
  final Supervisor? supervisorId;
  final double? startLat;
  final double? startLong;
  final DateTime? createdAt;
  final DateTime? checkOutTime;
  final double? endLat;
  final double? endLong;

  TodayAttendance({
    required this.id,
    this.profileImgUrl,
    required this.attendenceStatus,
    required this.salesmanId,
    required this.companyId,
    required this.branchId,
    required this.supervisorId,
    this.startLat,
    this.startLong,
    required this.createdAt,
    this.checkOutTime,
    this.endLat,
    this.endLong,
  });

  factory TodayAttendance.fromJson(Map<String, dynamic> json) {
    return TodayAttendance(
      id: json['_id'],
      profileImgUrl: json['profileImgUrl'] ?? "",
      attendenceStatus: json['attendenceStatus'],
      salesmanId: Salesman.fromJson(json['salesmanId']),
      companyId: Company.fromJson(json['companyId']),
      branchId: Branch.fromJson(json['branchId']),
      supervisorId: Supervisor.fromJson(json['supervisorId']),
      startLat: (json['startLat'] as num?)?.toDouble(),
      startLong: (json['startLong'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      endLat: (json['endLat'] as num?)?.toDouble(),
      endLong: (json['endLong'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profileImgUrl': profileImgUrl,
      'attendenceStatus': attendenceStatus,
      'salesmanId': salesmanId?.toJson(),
      'companyId': companyId?.toJson(),
      'branchId': branchId?.toJson(),
      'supervisorId': supervisorId?.toJson(),
      'startLat': startLat,
      'startLong': startLong,
      'createdAt': createdAt,
      'checkOutTime': checkOutTime,
      'endLat': endLat,
      'endLong': endLong,
    };
  }
}

class Salesman {
  final String? id;
  final String? salesmanName;

  Salesman({required this.id, required this.salesmanName});

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json['_id'],
      salesmanName: json['salesmanName'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'salesmanName': salesmanName,
  };
}

class Company {
  final String? id;
  final String? companyName;

  Company({required this.id, required this.companyName});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'companyName': companyName
  };
}

class Branch {
  final String? id;
  final String? branchName;

  Branch({required this.id, required this.branchName});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'] ?? '',
      branchName: json['branchName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'branchName': branchName
  };
}

class Supervisor {
  final String? id;
  final String? supervisorName;

  Supervisor({this.id, this.supervisorName});

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      id: json['_id'] ?? '',
      supervisorName: json['supervisorName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'supervisorName': supervisorName,
  };
}
