import 'pagination_model.dart';
class DistrictResponse {
  final int? status;
  final String? message;
  final Pagination? pagination;
  final List<DistrictModel>? data;

  DistrictResponse({
    this.status,
    this.message,
    this.pagination,
    this.data,
  });

  factory DistrictResponse.fromJson(Map<String, dynamic> json) {
    return DistrictResponse(
      status: json['status'],
      message: json['message'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => DistrictModel.fromJson(e))
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


class DistrictModel {
  final int? id;
  final String? districtName;

  DistrictModel({
    this.id,
    this.districtName,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      districtName: json['district_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district_name': districtName,
    };
  }
}