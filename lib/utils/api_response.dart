class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, dynamic>? meta;
  final List<String>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.meta,
    this.errors,
  });

  factory ApiResponse.success(
    T data, {
    String? message,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse(success: true, data: data, message: message, meta: meta);
  }

  factory ApiResponse.error(String message, {List<String>? errors}) {
    return ApiResponse(success: false, message: message, errors: errors);
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    try {
      return ApiResponse(
        success: true,
        data: json['data'] != null ? fromJsonT(json['data']) : null,
        meta: json['meta'],
      );
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }
}
