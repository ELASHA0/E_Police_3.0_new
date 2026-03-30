import '../../Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';

class QRBySalesmanModel {
  final String id;
  final String? boxNo;
  final String? address;
  final String? qrcodeId;
  final List<QuestionAnswer> questionAnswers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Company? company;
  final Branch? branch;
  final Supervisor? supervisor;
  final Salesman? salesman;
  final QrCode? qrcode;

  QRBySalesmanModel({
    required this.id,
    this.boxNo,
    this.address,
    this.qrcodeId,
    required this.questionAnswers,
    required this.createdAt,
    required this.updatedAt,
    this.company,
    this.branch,
    this.supervisor,
    this.salesman,
    this.qrcode,
  });

  factory QRBySalesmanModel.fromJson(Map<String, dynamic> json) {
    return QRBySalesmanModel(
      id: json["_id"] ?? "",
      boxNo: json["boxNo"],
      address: json["address"],
      qrcodeId: json["qrcodeId"],
      questionAnswers: (json["questionAnswers"] as List<dynamic>? ?? [])
          .map((e) => QuestionAnswer.fromJson(e))
          .toList(),
      createdAt: DateTime.tryParse(json["createdAt"] ?? "")?.toLocal() ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "")?.toLocal() ?? DateTime.now(),
      company: json["company"] != null ? Company.fromJson(json["company"]) : null,
      branch: json["branch"] != null ? Branch.fromJson(json["branch"]) : null,
      supervisor: json["supervisor"] != null ? Supervisor.fromJson(json["supervisor"]) : null,
      salesman: json["salesman"] != null ? Salesman.fromJson(json["salesman"]) : null,
      qrcode: json["qrcode"] != null ? QrCode.fromJson(json["qrcode"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "boxNo": boxNo,
      "address": address,
      "qrcodeId": qrcodeId,
      "questionAnswers": questionAnswers.map((e) => e.toJson()).toList(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "company": company?.toJson(),
      "branch": branch?.toJson(),
      "supervisor": supervisor?.toJson(),
      "salesman": salesman?.toJson(),
      "qrcode": qrcode?.toJson(),
    };
  }
}

class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({required this.question, required this.answer});

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question: json["question"] ?? "",
      answer: json["answer"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answer": answer,
    };
  }
}

class QrCode {
  final String id;
  final String boxNo;
  final double lat;
  final double long;

  QrCode({
    required this.id,
    required this.boxNo,
    required this.lat,
    required this.long,
  });

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      id: json["_id"],
      boxNo: json["boxNo"],
      lat: (json["lat"] as num).toDouble(),
      long: (json["long"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "boxNo": boxNo,
      "lat": lat,
      "long": long,
    };
  }
}
