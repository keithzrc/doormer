import 'package:dio/dio.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage.dart';
import 'package:doormer/src/core/utils/app_logger.dart';

class SessionServiceImpl implements SessionService {
  final TokenStorage _tokenStorage;
  final Dio _dio;

  SessionServiceImpl({
    required TokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  @override
  Future<String?> getAccessToken() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      AppLogger.info('Access token retrieved from storage.');
      return token;
    } catch (e) {
      AppLogger.error('Failed to retrieve access token: $e');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    // Clear tokens from secure storage
    await _tokenStorage.clearTokens();
    AppLogger.info('User logged out and tokens cleared.');

    //TODO: Notify the app about the logout
  }

  @override
  Future<String?> refreshToken() async {
    // Retrieve the refresh token from storage
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      AppLogger.error(
          'No refresh token available. User needs to log in again.');
      throw Exception('No refresh token available');
    }

    try {
      // Make a POST request to refresh the tokens
      final response = await _dio.post(
        '/auth/refresh-token', //TODO: change to actual API route
        data: {
          'refresh_token': refreshToken,
        },
      );

      // Extract the new tokens from the response
      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      // Save the new tokens in secure storage
      await _tokenStorage.saveAccessToken(newAccessToken);
      await _tokenStorage.saveRefreshToken(newRefreshToken);

      AppLogger.info('Tokens refreshed successfully.');

      // Return the new access token
      return newAccessToken;
    } on DioException catch (e) {
      AppLogger.error(
          'Failed to refresh token: ${e.response?.data['message'] ?? e.message}');
      throw Exception('Failed to refresh token');
    } catch (e) {
      AppLogger.error(
          'An unexpected error occurred while refreshing token: $e');
      throw Exception('An unexpected error occurred');
    }
  }
}
