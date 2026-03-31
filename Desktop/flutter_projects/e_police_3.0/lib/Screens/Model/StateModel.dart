import 'pagination_model.dart';class StateResponse {
  final int? status;
  final String? message;
  final Pagination? pagination;
  final List<StateModel>? data;

  StateResponse({
    this.status,
    this.message,
    this.pagination,
    this.data,
  });

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      status: json['status'],
      message: json['message'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => StateModel.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'pagination': pagination?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}


class StateModel {
  final int? id;
  final String? state_name_en;

  StateModel({
    this.id,
    this.state_name_en,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      state_name_en: json['state_name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_name_en': state_name_en,
    };
  }
}