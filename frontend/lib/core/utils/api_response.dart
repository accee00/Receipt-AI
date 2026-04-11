class ApiResponse<T> {
  final String? message;
  final T? data;
  final bool isSuccess;

  ApiResponse({
    this.message,
    this.data,
    required this.isSuccess,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    bool success = true;
    if (json['statusCode'] != null) {
      success = json['statusCode'] < 400;
    } else {
      success = json['isSuccess'] ?? true;
    }
    return ApiResponse<T>(
      message: json['message'] as String?,
      data: json['data'] as T?,
      isSuccess: success,
    );
  }
}

