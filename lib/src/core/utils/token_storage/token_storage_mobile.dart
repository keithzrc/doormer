import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageMobile implements TokenStorage {
  // Keys for storing tokens
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // Secure storage instance
  final FlutterSecureStorage _secureStorage;

  TokenStorageMobile(FlutterSecureStorage flutterSecureStorage,
      {FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    AppLogger.info('Access Token Saved.');
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.deleteAll();
  }
}
