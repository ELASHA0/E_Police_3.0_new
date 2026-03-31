
import 'pagination_model.dart';
class PoliceStationResponse {
  final int? status;
  final String? message;
  final Pagination? pagination;
  final List<PoliceStationModel>? data;

  PoliceStationResponse({
    this.status,
    this.message,
    this.pagination,
    this.data,
  });

  factory PoliceStationResponse.fromJson(Map<String, dynamic> json) {
    return PoliceStationResponse(
      status: json['status'],
      message: json['message'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => PoliceStationModel.fromJson(e))
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


class PoliceStationModel {
  final int? id;
  final String? name;

  PoliceStationModel({
    this.id,
    this.name,
  });

  factory PoliceStationModel.fromJson(Map<String, dynamic> json) {
    return PoliceStationModel(
      id: json['id'],
      name: json['name'], // ✅ matches API key exactly
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
