import 'package:dio/dio.dart';
import 'package:frontend/core/utils/api_response.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: "https://localhost:8000/api/v1",
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
          sendTimeout: Duration(seconds: 10),
        ),
      );

  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse<T>.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse<T>.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse<T>.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return ApiResponse<T>.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> downloadFile(
    String url,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw Exception('Failed to download file: ${e.message}');
    }
  }
}
