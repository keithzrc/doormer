import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';

abstract class AuthRepository {
  /// Signs up a new user with email and password
  Future<User> signup(
      {required String email,
      required String password,
      required UserType userType});

  /// Logs in the user with email and password
  Future<User> login({
    required String email,
    required String password,
  });

  /// Signs in a user via Google
  Future<User> signInWithGoogle(String idToken);

  /// Signs in a user via Apple
  Future<User> signInWithApple();

  /// Verify email with confirmation code
  Future<void> verifyEmail({required String email, required String code});

  /// Logout user
  Future<void> logout();
}
