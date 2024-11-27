import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//TODO: store in local storage not cache
class TokenStorage {
  // Keys for storing tokens
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // Secure storage instance
  final FlutterSecureStorage _secureStorage;

  TokenStorage({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Save the access token
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    AppLogger.info('Access Token Saved.');
  }

  /// Retrieve the access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  /// Delete the access token
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  /// Save the refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieve the refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Delete the refresh token
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  /// Clear all stored tokens (used for logout)
  Future<void> clearTokens() async {
    await _secureStorage.deleteAll();
  }
}
