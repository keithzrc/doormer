import 'package:doormer/src/shared/user/account_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/features/auth/domain/usecases/auth_usecase.dart';
import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:uuid/uuid.dart';

/// Create a mock for the repository.
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthUseCase authUseCase;
  late User testUser;

  setUpAll(() {
    // Register fallback values for any() matchers.
    registerFallbackValue(UserType.candidate);
    registerFallbackValue(AccountStatus.partial);
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authUseCase = AuthUseCase(mockAuthRepository);
    testUser = User(
        id: UuidValue(const Uuid().v4()),
        email: 'test@example.com',
        userType: UserType.candidate,
        accountStatus: AccountStatus.partial);
  });

  group('Signup UseCase', () {
    test('should call signup on the repository and return a user', () async {
      // Arrange
      when(() => mockAuthRepository.signup(
            email: any(named: 'email'),
            password: any(named: 'password'),
            userType: any(named: 'userType'),
          )).thenAnswer((_) async => testUser);

      // Act
      final result = await authUseCase.signup.call(
        email: 'test@example.com',
        password: 'password123',
        userType: UserType.candidate,
      );

      // Assert
      expect(result, equals(testUser));
      verify(() => mockAuthRepository.signup(
            email: 'test@example.com',
            password: 'password123',
            userType: UserType.candidate,
          )).called(1);
    });
  });

  group('Login UseCase', () {
    test('should call login on the repository and return a user', () async {
      // Arrange
      when(() => mockAuthRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => testUser);

      // Act
      final result = await authUseCase.login.call(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, equals(testUser));
      verify(() => mockAuthRepository.login(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });
  });

  group('SignInWithGoogle UseCase', () {
    test('should call signInWithGoogle on the repository and return a user',
        () async {
      // Arrange
      const idToken = 'test_token';
      when(() => mockAuthRepository.signInWithGoogle(idToken))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await authUseCase.signInWithGoogle.call(idToken);

      // Assert
      expect(result, equals(testUser));
      verify(() => mockAuthRepository.signInWithGoogle(idToken)).called(1);
    });
  });

  group('VerifyEmail UseCase', () {
    test('should call verifyEmail on the repository and complete successfully',
        () async {
      // Arrange
      when(() => mockAuthRepository.verifyEmail(
            email: any(named: 'email'),
            code: any(named: 'code'),
          )).thenAnswer((_) async => Future.value());

      // Act
      final future = authUseCase.verifyEmail.call(
        email: 'test@example.com',
        code: '123456',
      );

      // Assert
      expect(future, completes);
      verify(() => mockAuthRepository.verifyEmail(
            email: 'test@example.com',
            code: '123456',
          )).called(1);
    });
  });
}
