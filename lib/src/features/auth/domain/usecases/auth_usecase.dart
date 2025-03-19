import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';

class AuthUseCase {
  final Signup signup;
  final Login login;
  final SignInWithGoogle signInWithGoogle;
  final VerifyEmail verifyEmail;

  AuthUseCase({
    required this.signup,
    required this.login,
    required this.signInWithGoogle,
    required this.verifyEmail,
  });
}

class Signup {
  final AuthRepository authRepository;

  Signup(this.authRepository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    return await authRepository.signup(
      email: email,
      password: password,
      userType: userType,
    );
  }
}

class Login {
  final AuthRepository authRepository;

  Login(this.authRepository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(
      email: email,
      password: password,
    );
  }
}

class SignInWithGoogle {
  final AuthRepository authRepository;

  SignInWithGoogle(this.authRepository);

  Future<Either<Failure, User>> call(String idToken) async {
    return await authRepository.signInWithGoogle(idToken);
  }
}

class VerifyEmail {
  final AuthRepository authRepository;

  VerifyEmail(this.authRepository);

  Future<Either<Failure, void>> call({
    required String email,
    required String code,
  }) async {
    return await authRepository.verifyEmail(
      email: email,
      code: code,
    );
  }
}
