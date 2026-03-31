
class CountryResponse {
  final int? status;
  final List<CountryModel>? data;

  CountryResponse({
    this.status,
    this.data,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      status: json['status'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => CountryModel.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class CountryModel {
  final int? id;
  final String? countryName;

  CountryModel({
    this.id,
    this.countryName,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      countryName: json['country_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_name': countryName,
    };
  }
}