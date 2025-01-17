import 'package:doormer/src/core/utils/token_storage/token_storage.dart';
import 'package:universal_html/html.dart' as html;

class TokenStorageWeb implements TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  String _createCookie(String name, String value) {
    return '$name=${Uri.encodeFull(value)}; path=/; Secure; SameSite=Strict; HttpOnly';
  }

  String _createDeleteCookie(String name) {
    return '$name=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT; Secure; SameSite=Strict; HttpOnly';
  }

  String? _getCookieValue(String name) {
    final cookies = html.document.cookie?.split('; ') ?? [];
    final cookiePrefix = '$name=';
    final cookie = cookies.firstWhere(
      (cookie) => cookie.startsWith(cookiePrefix),
      orElse: () => '',
    );
    return cookie.isEmpty
        ? null
        : Uri.decodeFull(cookie.substring(cookiePrefix.length));
  }

  @override
  Future<void> saveAccessToken(String token) async {
    html.document.cookie = _createCookie(_accessTokenKey, token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _getCookieValue(_accessTokenKey);
  }

  @override
  Future<void> deleteAccessToken() async {
    html.document.cookie = _createDeleteCookie(_accessTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    html.document.cookie = _createCookie(_refreshTokenKey, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _getCookieValue(_refreshTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    html.document.cookie = _createDeleteCookie(_refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }
}
