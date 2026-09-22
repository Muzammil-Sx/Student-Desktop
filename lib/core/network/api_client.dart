import 'package:dio/dio.dart';

import '../errors/app_exception.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Single HTTP client for the app.
/// No feature should create its own Dio.
class ApiClient {
  ApiClient({
    required String baseUrl,
    required Future<String?> Function() tokenProvider,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    Map<String, dynamic>? defaultHeaders,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            sendTimeout: sendTimeout,
            responseType: ResponseType.json,
            contentType: Headers.jsonContentType,
            headers: defaultHeaders,
          ),
        ) {
    _dio.interceptors.addAll([
      AuthInterceptor(tokenProvider: tokenProvider),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(dynamic data) parser,
  }) =>
      _run(() => _dio.get(path, queryParameters: query), parser);

  Future<T> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    required T Function(dynamic data) parser,
  }) =>
      _run(() => _dio.post(path, data: body, queryParameters: query), parser);

  Future<T> put<T>(
    String path, {
    Object? body,
    required T Function(dynamic data) parser,
  }) =>
      _run(() => _dio.put(path, data: body), parser);

  Future<T> delete<T>(
    String path, {
    Object? body,
    required T Function(dynamic data) parser,
  }) =>
      _run(() => _dio.delete(path, data: body), parser);

  Future<T> _run<T>(
    Future<Response<dynamic>> Function() call,
    T Function(dynamic data) parser,
  ) async {
    try {
      final response = await call();
      return parser(response.data);
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) throw err;
      throw NetworkException(e.message ?? 'Network error', cause: e.error);
    }
  }
}