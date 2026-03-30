import '../../Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';
import '../Q&A Set/QuestionSetModel.dart';

class QRModel {
  final String id;
  final String boxNo;
  final Company company;
  final Branch branch;
  final Supervisor supervisor;
  final double? lat;
  final double? long;
  DateTime createdAt;
  DateTime updatedAt;
  final QuestionSet questionSet;
  final String qrImage;

  QRModel({
    required this.id,
    required this.boxNo,
    required this.company,
    required this.branch,
    required this.supervisor,
    required this.lat,
    required this.long,
    required this.createdAt,
    required this.updatedAt,
    required this.questionSet,
    required this.qrImage
  });

  factory QRModel.fromJson(Map<String, dynamic> json) {
    return QRModel(
      id: json['_id'] ?? '',
      boxNo: json['boxNo'] ?? '',
      company: Company.fromJson(json['company']),
      branch: Branch.fromJson(json['branch']),
      supervisor: Supervisor.fromJson(json['supervisor']),
      lat: (json['lat'] ?? 0).toDouble(),
      long: (json['long'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      questionSet: QuestionSet.fromJson(json['questionSet'] ?? {}),
      qrImage: json['qrImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'boxNo': boxNo,
      'company': company.toJson(),
      'branch': branch.toJson(),
      'supervisor': supervisor.toJson(),
      'lat': lat,
      'long': long,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'questionSet': questionSet.toJson(),
      'qrImage': qrImage,
    };
  }
}

class QuestionSet {
  final String id;
  final String title;
  final List<Question> questions;

  QuestionSet({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory QuestionSet.fromJson(Map<String, dynamic> json) {
    return QuestionSet(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}
