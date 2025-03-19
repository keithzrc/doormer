import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';

abstract class AuthRepository {
  /// Signs up a new user with email and password.
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required UserType userType,
  });

  /// Logs in the user with email and password.
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Signs in a user via Google.
  Future<Either<Failure, User>> signInWithGoogle(String idToken);

  /// Signs in a user via Apple.
  Future<Either<Failure, User>> signInWithApple();

  /// Verify email with confirmation code.
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  });

  /// Logout user.
  Future<Either<Failure, void>> logout();
}
