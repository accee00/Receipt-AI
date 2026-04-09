class ApiError {
  final String error;
  final int statusCode;
  final bool isSuccess;

  ApiError({
    required this.error,
    required this.statusCode,
    required this.isSuccess,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      error: json['error'],
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
    );
  }
}

