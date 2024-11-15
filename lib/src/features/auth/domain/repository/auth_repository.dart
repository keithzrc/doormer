// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:doormer/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Signs up a new user with email and password
  Future<User> signup(String email, String password);

  /// Logs in the user with email and password
  Future<User> login(String email, String password);

  /// Signs in a user via Google
  //Future<User> signInWithGoogle();

  /// Verify email with confirmation code
  Future<void> confirmEmail(String email, String code);
}
