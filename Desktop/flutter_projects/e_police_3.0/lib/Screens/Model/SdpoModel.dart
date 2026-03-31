import 'pagination_model.dart';
class SdpoResponse {
  final int? status;
  final String? message;
  final Pagination? pagination;
  final List<SdpoModel>? data;

  SdpoResponse({
    this.status,
    this.message,
    this.pagination,
    this.data,
  });

  factory SdpoResponse.fromJson(Map<String, dynamic> json) {
    return SdpoResponse(
      status: json['status'],
      message: json['message'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => SdpoModel.fromJson(e))
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



class SdpoModel {
  final int? id;
  final String? name;

  SdpoModel({
    this.id,
    this.name,
  });

  factory SdpoModel.fromJson(Map<String, dynamic> json) {
    return SdpoModel(
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
