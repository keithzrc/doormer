// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:doormer/src/core/config/app_config.dart';

class DioClient {
  // Config constants
  static const String _apiUrl = AppConfig.apiBaseUrl;
  static const Duration _connectTimeout =
      Duration(milliseconds: AppConfig.connectTimeout);
  static const Duration _receiveTimeout =
      Duration(milliseconds: AppConfig.receiveTimeout);

  /// Creates and returns a Dio instance
  static Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: _apiUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
    ));

    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));

    return dio;
  }
}
