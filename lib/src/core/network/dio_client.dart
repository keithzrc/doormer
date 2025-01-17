// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:doormer/src/core/config/app_config.dart';
import 'package:doormer/src/core/network/interceptors/session_interceptor.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';

class DioClient {
  // Config constants
  static const String _apiUrl = AppConfig.apiBaseUrl;
  static const Duration _connectTimeout =
      Duration(milliseconds: AppConfig.connectTimeout);
  static const Duration _receiveTimeout =
      Duration(milliseconds: AppConfig.receiveTimeout);

  /// Creates and returns a Dio instance
  static Dio createDio({
    required SessionService sessionService,
    required GlobalSessionBloc sessionBloc,
  }) {
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

    // Add SessionInterceptor for token management
    dio.interceptors.add(SessionInterceptor(
      sessionService: sessionService,
      globalSessionBloc: sessionBloc,
    ));

    return dio;
  }
}
