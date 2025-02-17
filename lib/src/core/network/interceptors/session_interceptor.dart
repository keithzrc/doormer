import 'package:dio/dio.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';

/// An interceptor for handling session-related logic in network requests.
///
/// [SessionInterceptor] is responsible for attaching the access token to
/// request headers, handling token expiration by attempting a refresh,
/// and triggering logout actions when necessary.
class SessionInterceptor extends Interceptor {
  final SessionService _sessionService;
  final GlobalSessionBloc _globalSessionBloc;

  /// Creates a [SessionInterceptor] instance.
  ///
  /// Parameters:
  /// - [sessionService]: Provides methods to retrieve and refresh session tokens.
  /// - [globalSessionBloc]: Manages session state and handles session expiration.
  SessionInterceptor({
    required SessionService sessionService,
    required GlobalSessionBloc globalSessionBloc,
  })  : _sessionService = sessionService,
        _globalSessionBloc = globalSessionBloc;

  /// Attaches the access token to the request headers.
  ///
  /// If an access token is available, it is included in the `Authorization` header
  /// of the request in the format `Bearer <token>`.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Check if the current request should skip authentication.
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }
    try {
      final accessToken = await _sessionService.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    } catch (e) {
      AppLogger.error("Failed to attach access token: $e");
    }
    handler.next(options);
  }

  /// Handles errors and attempts to resolve 401 Unauthorized responses.
  ///
  /// For 401 errors:
  /// - Attempts to refresh the access token using [SessionService].
  /// - Retries the original request with the new token if refresh is successful.
  /// - Logs the user out and emits a [SessionExpired] event if the refresh fails.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // Attempt to refresh the token
        final newAccessToken = await _sessionService.refreshToken();
        if (newAccessToken != null) {
          // Prepare to retry the original request with the new token.
          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final cloneResponse = await Dio().request(
            retryOptions.path,
            options: Options(
              method: retryOptions.method,
              headers: retryOptions.headers,
            ),
          );

          return handler.resolve(cloneResponse); // Return the retried response.
        }
      } on DioException catch (e) {
        // Handle token refresh errors.
        if (e.response?.statusCode == 401) {
          // Both tokens are expired; log out.
          _globalSessionBloc.add(ExpireSession());
          await _sessionService.logout();
        } else {
          AppLogger.error("Refresh token failed with error: ${e.message}");
        }
      } catch (e) {
        AppLogger.error(
            "An unexpected error occurred during token refresh: $e");
      }
    }

    // Forward the original error if it can't be resolved.
    handler.next(err);
  }
}
