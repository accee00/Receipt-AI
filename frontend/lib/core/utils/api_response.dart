class ApiResponse<T> {
  final String? message;
  final T? data;
  final String? token;
  final bool isSuccess;

  ApiResponse({
    this.message,
    this.data,
    this.token,
    required this.isSuccess,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      message: json['message'],
      data: json['data'] as T?,
      token: json['token'],
      isSuccess: json['isSuccess'] ?? true,
    );
  }
}

