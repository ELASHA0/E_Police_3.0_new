// pagination_model.dart
class Pagination {
  final int? totalRecords;
  final int? totalPages;
  final int? currentPage;
  final int? perPage;

  Pagination({
    this.totalRecords,
    this.totalPages,
    this.currentPage,
    this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords: json['total_records'],
      totalPages: json['total_pages'],
      currentPage: json['current_page'],
      perPage: json['per_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_records': totalRecords,
      'total_pages': totalPages,
      'current_page': currentPage,
      'per_page': perPage,
    };
  }
}