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

  setUp(() {
    mockTokenStorage = MockTokenStorage();
    mockDio = MockDio();
    sessionService = SessionServiceImpl(
      tokenStorage: mockTokenStorage,
      dio: mockDio,
    );
  });

  group('SessionService - getAccessToken', () {
    test('should return token on success', () async {
      // Arrange
      const testAccessToken = 'test_access_token';
      when(mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => testAccessToken);

      // Act
      final token = await sessionService.getAccessToken();

      // Assert
      expect(token, equals(testAccessToken));
      verify(mockTokenStorage.getAccessToken()).called(1);
    });

    test('should catch error and return null on exception', () async {
      // Arrange
      when(mockTokenStorage.getAccessToken())
          .thenThrow(Exception('Failed to retrieve token'));

      // Act
      final token = await sessionService.getAccessToken();

      // Assert
      expect(token, isNull);
      verify(mockTokenStorage.getAccessToken()).called(1);
    });
  });

  group('SessionService - saveTokens', () {
    test(
        'should call saveAccessToken and saveRefreshToken with correct parameters',
        () async {
      // Arrange
      const testAccessToken = 'access_token';
      const testRefreshToken = 'refresh_token';

      when(mockTokenStorage.saveAccessToken(testAccessToken))
          .thenAnswer((_) async {});
      when(mockTokenStorage.saveRefreshToken(testRefreshToken))
          .thenAnswer((_) async {});

      // Act
      await sessionService.saveTokens(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
      );

      // Assert
      verify(mockTokenStorage.saveAccessToken(testAccessToken)).called(1);
      verify(mockTokenStorage.saveRefreshToken(testRefreshToken)).called(1);
    });
  });

  group('SessionService - setDio', () {
    test('should update the internal Dio instance used for refreshToken',
        () async {
      // Arrange: Create a new mock Dio instance
      final newMockDio = MockDio();
      sessionService.setDio(newMockDio);

      // Set up token storage and newMockDio responses
      const testRefreshToken = 'test_refresh_token';
      const testNewAccessToken = 'new_access_token';
      const testNewRefreshToken = 'new_refresh_token';

      when(mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => testRefreshToken);

      when(newMockDio.post(
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

      // Act: Call refreshToken which should use newMockDio
      final result = await sessionService.refreshToken();

      // Assert
      expect(result, equals(testNewAccessToken));
      verify(newMockDio.post(
        '/auth/refresh-token',
        data: {'refresh_token': testRefreshToken},
      )).called(1);
      // Ensure the old mockDio is not used
      verifyNever(mockDio.post(
        any,
        data: anyNamed('data'),
      ));
    });
  });

  group('SessionService - logout', () {
    test('should clear tokens when logging out', () async {
      // Arrange
      when(mockTokenStorage.clearTokens()).thenAnswer((_) async {});

      // Act
      await sessionService.logout();

      // Assert
      verify(mockTokenStorage.clearTokens()).called(1);
    });

    test('should handle errors during logout', () async {
      // Arrange
      when(mockTokenStorage.clearTokens())
          .thenThrow(Exception('Failed to clear tokens'));

      // Act & Assert
      expect(() => sessionService.logout(), throwsException);
    });
  });

  group('SessionService - refreshToken', () {
    const testRefreshToken = 'test_refresh_token';
    const testNewAccessToken = 'new_access_token';
    const testNewRefreshToken = 'new_refresh_token';

    test('should successfully refresh tokens', () async {
      // Arrange
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

      // Act
      final result = await sessionService.refreshToken();

      // Assert
      expect(result, equals(testNewAccessToken));
      verify(mockTokenStorage.getRefreshToken()).called(1);
      verify(mockTokenStorage.saveAccessToken(testNewAccessToken)).called(1);
      verify(mockTokenStorage.saveRefreshToken(testNewRefreshToken)).called(1);
    });

    test('should throw exception when no refresh token is available', () async {
      // Arrange
      when(mockTokenStorage.getRefreshToken()).thenAnswer((_) async => null);

      // Act & Assert
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
      // Arrange
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

      // Act & Assert
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
      // Arrange
      when(mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => testRefreshToken);

      when(mockDio.post(
        '/auth/refresh-token',
        data: {'refresh_token': testRefreshToken},
      )).thenThrow(Exception('Unexpected error'));

      // Act & Assert
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
      // Arrange
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

      // Act & Assert
      expect(
        () => sessionService.refreshToken(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
