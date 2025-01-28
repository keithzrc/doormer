import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/interceptors/session_interceptor.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';

/// Manages network requests with integrated session and token handling.
///
/// The [RequestManager] class wraps the Dio library to provide a centralized way
/// of handling HTTP requests. It also integrates the [SessionInterceptor] to
/// manage session tokens and other session-related concerns.
class RequestManager {
  final Dio _dio;

  /// Creates a new [RequestManager] instance.
  ///
  /// This constructor initializes the [Dio] client and attaches a
  /// [SessionInterceptor] for handling authentication and session logic.
  ///
  /// Parameters:
  /// - [dio]: An instance of the Dio client to perform network requests.
  /// - [sessionService]: Handles session-related operations like retrieving tokens.
  /// - [sessionBloc]: Manages the global session state within the application.
  RequestManager({
    required Dio dio,
    required SessionService sessionService,
    required GlobalSessionBloc sessionBloc,
  }) : _dio = dio {
    // Add SessionInterceptor to handle token and session management
    _dio.interceptors.add(SessionInterceptor(
      sessionService: sessionService,
      globalSessionBloc: sessionBloc,
    ));
  }

  /// Sends a GET request to the specified [path].
  ///
  /// Parameters:
  /// - [path]: The endpoint to send the GET request to.
  /// - [queryParams]: Optional query parameters to include in the request.
  /// - [requiresAuth]: Whether to include the `Authorization` header.
  ///
  /// Returns a [Response] containing the server's response.
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: _getRequestOptions(requiresAuth),
      );
      return response;
    } on DioException catch (e) {
      AppLogger.error('GET request failed: ${e.message}');
      rethrow;
    }
  }

  /// Sends a POST request to the specified [path].
  ///
  /// Parameters:
  /// - [path]: The endpoint to send the POST request to.
  /// - [data]: Optional data payload to include in the request body.
  /// - [requiresAuth]: Whether to include the `Authorization` header.
  ///
  /// Returns a [Response] containing the server's response.
  Future<Response> post(
    String path, {
    dynamic data,
    bool requiresAuth = true,
  }) async {
    try {
      // Log the request payload
      AppLogger.error('POST Request Path: $path');
      AppLogger.error('POST Request Data: $data');
      AppLogger.error(
          'POST Request Headers: ${_getRequestOptions(requiresAuth).headers}');

      final response = await _dio.post(
        path,
        data: data,
        options: _getRequestOptions(requiresAuth),
      );
      return response;
    } on DioException catch (e) {
      AppLogger.error('POST request failed: ${e.message}');
      rethrow;
    }
  }

  /// Sends a DELETE request to the specified [path].
  ///
  /// Parameters:
  /// - [path]: The endpoint to send the DELETE request to.
  /// - [requiresAuth]: Whether to include the `Authorization` header.
  ///
  /// Returns a [Response] containing the server's response.
  Future<Response> delete(String path, {bool requiresAuth = true}) async {
    try {
      final response = await _dio.delete(
        path,
        options: _getRequestOptions(requiresAuth),
      );
      return response;
    } on DioException catch (e) {
      AppLogger.error('DELETE request failed: ${e.message}');
      rethrow;
    }
  }

  /// Sends a PUT request to the specified [path].
  ///
  /// Parameters:
  /// - [path]: The endpoint to send the PUT request to.
  /// - [data]: Optional data payload to include in the request body.
  /// - [requiresAuth]: Whether to include the `Authorization` header.
  ///
  /// Returns a [Response] containing the server's response.
  Future<Response> put(
    String path, {
    dynamic data,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        options: _getRequestOptions(requiresAuth),
      );
      return response;
    } on DioException catch (e) {
      AppLogger.error('PUT request failed: ${e.message}');
      rethrow;
    }
  }

  /// Returns request options with or without the `Authorization` header.
  /// If [requiresAuth] is true, the interceptor will inherit the default `Authorization` headers.
  /// If [requiresAuth] is false, the interceptor will not add the `Authorization` header.
  Options _getRequestOptions(bool requiresAuth) {
    return Options(
      headers:
          requiresAuth ? null : {}, // `null` allows interceptors to add headers
    );
  }
}
