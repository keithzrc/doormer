import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage_web.dart';
import 'package:universal_html/html.dart' as html;

void main() {
  late TokenStorageWeb tokenStorage;

  setUp(() {
    tokenStorage = TokenStorageWeb();
    html.document.cookie = ''; // Clear cookies before each test
  });

  group('TokenStorageWeb', () {
    const accessToken = 'sample_access_token';
    const refreshToken = 'sample_refresh_token';

    test('should save access token as a cookie', () async {
      // Act
      await tokenStorage.saveAccessToken(accessToken);

      // Assert
      expect(html.document.cookie, contains('access_token=$accessToken'));
    });

    test('should retrieve access token from cookies', () async {
      // Arrange
      html.document.cookie = 'access_token=$accessToken';

      // Act
      final result = await tokenStorage.getAccessToken();

      // Assert
      expect(result, accessToken);
    });

    test('should save refresh token as a secure cookie', () async {
      // Act
      await tokenStorage.saveRefreshToken(refreshToken);

      // Assert
      expect(html.document.cookie, contains('refresh_token=$refreshToken'));
    });

    test('should retrieve refresh token from cookies', () async {
      // Arrange
      html.document.cookie = 'refresh_token=$refreshToken';

      // Act
      final result = await tokenStorage.getRefreshToken();

      // Assert
      expect(result, refreshToken);
    });

    test('should save access token as a cookie with secure attributes',
        () async {
      await tokenStorage.saveAccessToken(accessToken);

      final cookie = html.document.cookie!;
      expect(cookie, contains('access_token=$accessToken'));
      expect(cookie, contains('Secure'));
      expect(cookie, contains('SameSite=Strict'));
      expect(cookie, contains('HttpOnly'));
      expect(cookie, contains('path=/'));
    });

    test('should mark access token cookie as expired when deleting', () async {
      // Arrange
      await tokenStorage.saveAccessToken(accessToken);

      // Act
      await tokenStorage.deleteAccessToken();

      // Assert
      final cookie = html.document.cookie!;
      expect(cookie, contains('access_token=')); // Should contain empty value
      expect(cookie,
          contains('expires=Thu, 01 Jan 1970')); // Should have past date
      expect(cookie, contains('path=/'));
      expect(cookie, contains('Secure'));
      expect(cookie, contains('SameSite=Strict'));
      expect(cookie, contains('HttpOnly'));
    });

    test('should delete refresh token cookie with correct attributes',
        () async {
      // Arrange
      await tokenStorage.saveRefreshToken(refreshToken);

      // Act
      await tokenStorage.deleteRefreshToken();

      // Assert
      final cookie = html.document.cookie!;
      expect(cookie, contains('refresh_token='));
      expect(cookie, contains('expires=Thu, 01 Jan 1970'));
      expect(cookie, contains('path=/'));
      expect(cookie, contains('Secure'));
      expect(cookie, contains('SameSite=Strict'));
      expect(cookie, contains('HttpOnly'));
    });
  });
}
