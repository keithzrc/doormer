import 'package:bloc_test/bloc_test.dart';
import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/domain/usecases/auth_usecase.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:doormer/src/shared/user/account_status.dart';
import 'package:uuid/uuid.dart';

/// Mocks for our dependencies.
class MockAuthUseCase extends Mock implements AuthUseCase {}

class MockGlobalSessionBloc extends Mock implements GlobalSessionBloc {}

class FakeGlobalSessionEvent extends Fake implements GlobalSessionEvent {}

/// Mocks for each callable usecase.
class MockSignup extends Mock implements Signup {}

class MockLogin extends Mock implements Login {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockVerifyEmail extends Mock implements VerifyEmail {}

void main() {
  // Disable logging during tests for clarity.
  AppLogger.disable();

  late AuthBloc authBloc;
  late MockAuthUseCase mockAuthUseCase;
  late MockGlobalSessionBloc mockGlobalSessionBloc;
  late User testUser;

  setUpAll(() {
    registerFallbackValue(FakeGlobalSessionEvent());
    registerFallbackValue(UserType.candidate);
    registerFallbackValue(AccountStatus.partial);
    registerFallbackValue(
      User(
        id: UuidValue(const Uuid().v4()),
        email: 'fallback@example.com',
        userType: UserType.candidate,
        accountStatus: AccountStatus.partial,
      ),
    );
  });

  // Create new instances for each test.
  setUp(() {
    mockAuthUseCase = MockAuthUseCase();
    mockGlobalSessionBloc = MockGlobalSessionBloc();
    authBloc = AuthBloc(
      authUseCase: mockAuthUseCase,
      globalSessionBloc: mockGlobalSessionBloc,
    );
    testUser = User(
      id: UuidValue(const Uuid().v4()),
      email: 'test@example.com',
      userType: UserType.candidate,
      accountStatus: AccountStatus.partial,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    group('SignupRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when signup succeeds',
        build: () {
          // Create a mock for the Signup usecase.
          final mockSignup = MockSignup();
          // Stub the getter so that authUseCase.signup returns our mock.
          when(() => mockAuthUseCase.signup).thenReturn(mockSignup);
          // Stub the call() method on the mockSignup.
          when(() => mockSignup.call(
                email: any(named: 'email'),
                password: any(named: 'password'),
                userType: any(named: 'userType'),
              )).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(SignupRequested(
          email: 'test@example.com',
          password: 'password123',
          userType: UserType.candidate,
        )),
        expect: () => [
          AuthLoading(),
          AuthSuccess(),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.signup.call(
                email: 'test@example.com',
                password: 'password123',
                userType: UserType.candidate,
              )).called(1);
          verify(() => mockGlobalSessionBloc.add(SessionStarted(testUser)))
              .called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when signup fails',
        build: () {
          final mockSignup = MockSignup();
          when(() => mockAuthUseCase.signup).thenReturn(mockSignup);
          when(() => mockSignup.call(
                email: any(named: 'email'),
                password: any(named: 'password'),
                userType: any(named: 'userType'),
              )).thenThrow(Exception('Signup failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignupRequested(
          email: 'test@example.com',
          password: 'password123',
          userType: UserType.candidate,
        )),
        expect: () => [
          AuthLoading(),
          AuthFailure('Exception: Signup failed'),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.signup.call(
                email: 'test@example.com',
                password: 'password123',
                userType: UserType.candidate,
              )).called(1);
          // Ensure no session event is added in failure scenario.
          verifyNever(() => mockGlobalSessionBloc.add(any()));
        },
      );
    });

    group('LoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when login succeeds',
        build: () {
          final mockLogin = MockLogin();
          when(() => mockAuthUseCase.login).thenReturn(mockLogin);
          when(() => mockLogin.call(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        )),
        expect: () => [
          AuthLoading(),
          AuthSuccess(),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.login.call(
                email: 'test@example.com',
                password: 'password123',
              )).called(1);
          verify(() => mockGlobalSessionBloc.add(SessionStarted(testUser)))
              .called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when login fails',
        build: () {
          final mockLogin = MockLogin();
          when(() => mockAuthUseCase.login).thenReturn(mockLogin);
          when(() => mockLogin.call(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenThrow(Exception('Login failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        )),
        expect: () => [
          AuthLoading(),
          AuthFailure('Exception: Login failed'),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.login.call(
                email: 'test@example.com',
                password: 'password123',
              )).called(1);
          verifyNever(() => mockGlobalSessionBloc.add(any()));
        },
      );
    });

    group('VerifyEmailRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when verify email succeeds',
        build: () {
          final mockVerifyEmail = MockVerifyEmail();
          when(() => mockAuthUseCase.verifyEmail).thenReturn(mockVerifyEmail);
          when(() => mockVerifyEmail.call(
                email: any(named: 'email'),
                code: any(named: 'code'),
              )).thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(VerifyEmailRequested(
          email: 'test@example.com',
          code: '123456',
        )),
        expect: () => [
          AuthLoading(),
          AuthSuccess(),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.verifyEmail.call(
                email: 'test@example.com',
                code: '123456',
              )).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when verify email fails',
        build: () {
          final mockVerifyEmail = MockVerifyEmail();
          when(() => mockAuthUseCase.verifyEmail).thenReturn(mockVerifyEmail);
          when(() => mockVerifyEmail.call(
                email: any(named: 'email'),
                code: any(named: 'code'),
              )).thenThrow(Exception('Verification failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(VerifyEmailRequested(
          email: 'test@example.com',
          code: '123456',
        )),
        expect: () => [
          AuthLoading(),
          AuthFailure('Exception: Verification failed'),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.verifyEmail.call(
                email: 'test@example.com',
                code: '123456',
              )).called(1);
        },
      );
    });

    group('GoogleSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when Google sign-in succeeds',
        build: () {
          final mockSignInWithGoogle = MockSignInWithGoogle();
          when(() => mockAuthUseCase.signInWithGoogle)
              .thenReturn(mockSignInWithGoogle);
          when(() => mockSignInWithGoogle.call(any()))
              .thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(GoogleSignInRequested('valid_token')),
        expect: () => [
          AuthLoading(),
          AuthSuccess(),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.signInWithGoogle.call('valid_token'))
              .called(1);
          verify(() => mockGlobalSessionBloc.add(SessionStarted(testUser)))
              .called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when Google sign-in fails',
        build: () {
          final mockSignInWithGoogle = MockSignInWithGoogle();
          when(() => mockAuthUseCase.signInWithGoogle)
              .thenReturn(mockSignInWithGoogle);
          when(() => mockSignInWithGoogle.call(any()))
              .thenThrow(Exception('Google sign-in failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(GoogleSignInRequested('invalid_token')),
        expect: () => [
          AuthLoading(),
          AuthFailure('Exception: Google sign-in failed'),
        ],
        verify: (_) {
          verify(() => mockAuthUseCase.signInWithGoogle.call('invalid_token'))
              .called(1);
          verifyNever(() => mockGlobalSessionBloc.add(any()));
        },
      );
    });
  });
}
