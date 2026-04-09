class ApiResponse<T> implements Exception {
  final String? message;
  final T? data;
  final String? token;
  final bool isSuccess;
  final String? error;
  final int? statusCode;

  ApiResponse({
    this.message,
    this.data,
    this.token,
    required this.isSuccess,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      message: json['message'],
      data: json['data'] as T?,
      token: json['token'],
      isSuccess: json['isSuccess'] ?? true,
      error: json['error'],
      statusCode: json['statusCode'],
    );
  }

  factory ApiResponse.error({required String message, int? statusCode}) {
    return ApiResponse<T>(
      isSuccess: false,
      error: message,
      message: message,
      statusCode: statusCode,
    );
  }

  @override
  String toString() {
    if (!isSuccess) return error ?? message ?? 'Unknown Error';
    return 'ApiResponse(isSuccess: $isSuccess, data: $data)';
  }
}
