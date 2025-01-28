import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' if (dart.library.io) 'dart:io';

//TODO: store in local storage not cache
class TokenStorage {
  // Keys for storing tokens
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // Secure storage instance
  final FlutterSecureStorage storage;

  TokenStorage({FlutterSecureStorage? storage})
      : storage = storage ?? const FlutterSecureStorage();

  /// Save the access token
  Future<void> saveAccessToken(String token) async {
    try {
      if (kIsWeb) {
        window.localStorage[_accessTokenKey] = token;
      } else {
        await storage.write(key: _accessTokenKey, value: token);
      }
      AppLogger.info('Access token saved');
    } catch (e) {
      AppLogger.error('Error saving access token: $e');
    }
  }

  /// Retrieve the access token
    Future<String?> getAccessToken() async {
    try {
      if (kIsWeb) {
        final token = window.localStorage[_accessTokenKey];
        AppLogger.info('Web: Retrieved access token: ${token != null ? 'exists' : 'null'}');
        return token;
      } else {
        final token = await storage.read(key: _accessTokenKey);
        AppLogger.info('Native: Retrieved access token: ${token != null ? 'exists' : 'null'}');
        return token;
      }
    } catch (e) {
      AppLogger.error('Error reading access token: $e');
      return null;
    }
  }

  /// Delete the access token
  Future<void> deleteAccessToken() async {
    try {
      if (kIsWeb) {
        window.localStorage.remove(_accessTokenKey);
      } else {
        await storage.delete(key: _accessTokenKey);
      }
    } catch (e) {
      AppLogger.error('Error deleting access token: $e');
    }
  }

  /// Save the refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      if (kIsWeb) {
        window.localStorage[_refreshTokenKey] = token;
      } else {
        await storage.write(key: _refreshTokenKey, value: token);
      }
    } catch (e) {
      AppLogger.error('Error saving refresh token: $e');
    }
  }

  /// Retrieve the refresh token
  Future<String?> getRefreshToken() async {
    return await storage.read(key: _refreshTokenKey);
  }

  /// Delete the refresh token
  Future<void> deleteRefreshToken() async {
    await storage.delete(key: _refreshTokenKey);
  }

  /// Clear all stored tokens (used for logout)
  Future<void> clearTokens() async {
    await storage.deleteAll();
  }
}
