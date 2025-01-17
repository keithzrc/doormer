import 'package:dio/dio.dart';
import 'package:doormer/src/core/services/sessions/session_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage.dart';

import 'session_service_test.mocks.dart';

// Generate mocks for the TokenStorage and Dio classes
@GenerateMocks([TokenStorage, Dio])
void main() {
  late SessionServiceImpl sessionService;
  late MockTokenStorage mockTokenStorage;
  late MockDio mockDio;

  // Set up the mocks and the service before each test
  setUp(() {
    mockTokenStorage = MockTokenStorage();
    mockDio = MockDio();
    sessionService = SessionServiceImpl(
      tokenStorage: mockTokenStorage,
      dio: mockDio,
    );
  });

  group('SessionService - logout', () {
    test('should clear tokens when logging out', () async {
      // Arrange: Stub clearTokens to simulate successful execution
      when(mockTokenStorage.clearTokens()).thenAnswer((_) async {});

      // Act: Call the logout method
      await sessionService.logout();

      // Assert: Verify that clearTokens was called exactly once
      verify(mockTokenStorage.clearTokens()).called(1);
    });

    test('should handle errors during logout', () async {
      // Arrange: Stub clearTokens to throw an exception
      when(mockTokenStorage.clearTokens())
          .thenThrow(Exception('Failed to clear tokens'));

      // Act & Assert: Ensure logout throws an exception
      expect(() => sessionService.logout(), throwsException);
    });
  });

  group('SessionService - refreshToken', () {
    const testRefreshToken = 'test_refresh_token';
    const testNewAccessToken = 'new_access_token';
    const testNewRefreshToken = 'new_refresh_token';

    test('should successfully refresh tokens', () async {
      // Arrange: Stub methods to simulate successful token refresh
      when(mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => testRefreshToken);

      when(mockDio.post(
        '/auth/refresh-token',
        data: {'refresh_token': testRefreshToken},
      )).thenAnswer((_) async => Response(
            data: {
              'access_token': testNewAccessToken,
              'refresh_token': testNewRefreshToken,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh-token'),
          ));

      when(mockTokenStorage.saveAccessToken(testNewAccessToken))
          .thenAnswer((_) async {});
      when(mockTokenStorage.saveRefreshToken(testNewRefreshToken))
          .thenAnswer((_) async {});

      // Act: Call the refreshToken method
      final result = await sessionService.refreshToken();

      // Assert: Verify behavior and result
      expect(result, equals(testNewAccessToken));
      verify(mockTokenStorage.getRefreshToken()).called(1);
      verify(mockTokenStorage.saveAccessToken(testNewAccessToken)).called(1);
      verify(mockTokenStorage.saveRefreshToken(testNewRefreshToken)).called(1);
    });

    test('should throw exception when no refresh token is available', () async {
      // Arrange: Stub getRefreshToken to return null
      when(mockTokenStorage.getRefreshToken()).thenAnswer((_) async => null);

      // Act & Assert: Ensure refreshToken throws an exception
      expect(
        () => sessionService.refreshToken(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('No refresh token available'),
        )),
      );
    });

    test('should handle DioException during token refresh', () async {
      // Arrange: Simulate a DioException during the token refresh process
      when(mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => testRefreshToken);

      when(mockDio.post(
        '/auth/refresh-token',
        data: {'refresh_token': testRefreshToken},
      )).thenThrow(DioException(
        response: Response(
          data: {'message': 'Invalid refresh token'},
          statusCode: 401,
          requestOptions: RequestOptions(path: '/auth/refresh-token'),
        ),
        requestOptions: RequestOptions(path: '/auth/refresh-token'),
      ));

      // Act & Assert: Ensure refreshToken throws an appropriate exception
      expect(
        () => sessionService.refreshToken(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to refresh token'),
        )),
      );
    });

    test('should handle unexpected errors during token refresh', () async {
      // Arrange: Simulate a generic exception during the token refresh process
      when(mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => testRefreshToken);

      when(mockDio.post(
        '/auth/refresh-token',
        data: {'refresh_token': testRefreshToken},
      )).thenThrow(Exception('Unexpected error'));

      // Act & Assert: Ensure refreshToken throws an appropriate exception
      expect(
        () => sessionService.refreshToken(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('An unexpected error occurred'),
        )),
      );
    });

    test('should handle token storage errors during save', () async {
      // Arrange: Simulate a failure when saving the access token
      when(mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => testRefreshToken);

      when(mockDio.post(
        '/auth/refresh-token',
        data: {'refresh_token': testRefreshToken},
      )).thenAnswer((_) async => Response(
            data: {
              'access_token': testNewAccessToken,
              'refresh_token': testNewRefreshToken,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh-token'),
          ));

      when(mockTokenStorage.saveAccessToken(testNewAccessToken))
          .thenThrow(Exception('Failed to save access token'));

      // Act & Assert: Ensure refreshToken throws an exception
      expect(
        () => sessionService.refreshToken(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
