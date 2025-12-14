class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Meta? meta;
  final dynamic error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    T? data;
    if (json['data'] != null && fromJson != null) {
      if (json['data'] is List) {
        data = (json['data'] as List)
            .map((e) => fromJson(e as Map<String, dynamic>))
            .toList() as T;
      } else {
        data = fromJson(json['data'] as Map<String, dynamic>);
      }
    } else if (json['data'] != null) {
      data = json['data'] as T?;
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: data,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      error: json['error'],
    );
  }

  /// Factory for parsing response with List data
  /// Element type E is used for fromJson, return type is List<E>
  static ApiResponse<List<E>> fromJsonList<E>(
    Map<String, dynamic> json,
    E Function(Map<String, dynamic>)? fromJson,
  ) {
    List<E>? data;
    if (json['data'] != null && fromJson != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ApiResponse<List<E>>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: data,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      error: json['error'],
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;
}

class Meta {
  final int currentPage;
  final int perPage;
  final int totalItems;
  final int totalPages;

  Meta({
    required this.currentPage,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      totalItems: json['total_items'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}
