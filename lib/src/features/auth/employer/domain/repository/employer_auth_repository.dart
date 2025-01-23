import 'package:doormer/src/shared/user/company/company.dart';

abstract class EmployerAuthRepository {
  /// Signs up a new user with email and password
  Future<EmployerUser> signup({
    required String email,
    required String password,
  });

  /// Logs in the user with email and password
  Future<EmployerUser> login({
    required String email,
    required String password,
  });

  /// Verify email with confirmation code
  Future<void> verifyEmail({required String email, required String code});

  /// Logout user
  Future<void> logout();
}
