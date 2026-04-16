import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/utils/api_response.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/core/utils/secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  late final Dio _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kIsWeb || !Platform.isAndroid
            ? "http://localhost:8000/api/v1/"
            : "http://10.0.2.2:8000/api/v1/",
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage().getToken("token");
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
      ),
    );
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      return Failure('Request cancelled');
    }
    String errorMessage = e.message ?? 'An unknown error occurred';
    if (e.response?.data['message'] != null) {
      errorMessage = e.response!.data['message'];
    }
    return Failure(errorMessage, statusCode: e.response?.statusCode);
  }

  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse<T>.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
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
      final response = await _dio.post<dynamic>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse<T>.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
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
      final response = await _dio.put<dynamic>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse<T>.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
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
      final response = await _dio.delete<dynamic>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return ApiResponse<T>.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
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
      throw _handleDioError(e);
    }
  }
}
