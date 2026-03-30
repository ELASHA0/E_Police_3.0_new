import '../../Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';

class QuestionSetModel {
  final String id;
  final String title;
  final Company company;
  final Branch branch;
  final Supervisor supervisor;
  final List<Question> questions;

  QuestionSetModel({
    required this.id,
    required this.title,
    required this.company,
    required this.branch,
    required this.supervisor,
    required this.questions,
  });

  factory QuestionSetModel.fromJson(Map<String, dynamic> json) {
    return QuestionSetModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      company: Company.fromJson(json['company']),
      branch: Branch.fromJson(json['branch']),
      supervisor: Supervisor.fromJson(json['supervisor']),
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'company': company.toJson(),
      'branch': branch.toJson(),
      'supervisor': supervisor.toJson(),
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

class Question {
  final int questionNo;
  final String text;
  final String id;

  Question({
    required this.questionNo,
    required this.text,
    required this.id,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionNo: json['questionNo'] ?? 0,
      text: json['text'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionNo': questionNo,
      'text': text,
      '_id': id,
    };
  }
}