import 'pagination_model.dart';
class CityResponse {
  final int? status;
  final String? message;
  final Pagination? pagination;
  final List<CityModel>? data;

  CityResponse({
    this.status,
    this.message,
    this.pagination,
    this.data,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      status: json['status'],
      message: json['message'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => CityModel.fromJson(e))
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


class CityModel {
  final int? id;
  final String? cityName;

  CityModel({
    this.id,
    this.cityName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      cityName: json['city_name'], // ✅ matches API key exactly
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_name': cityName,
    };
  }
}