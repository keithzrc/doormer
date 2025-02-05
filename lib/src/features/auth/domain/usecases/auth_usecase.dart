import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase(this.authRepository);

  // Signup method
  Future<User> signup({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    return await authRepository.signup(
        email: email, password: password, userType: userType);
  }

  // Login method
  Future<User> login({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(email: email, password: password);
  }

  // Sign Up/ Login with Google
  Future<User> signInWithGoogle(String idToken) async {
    return await authRepository.signInWithGoogle(idToken);
  }

  Future<void> verifyEmail(
      {required String email, required String code}) async {
    return await authRepository.verifyEmail(email: email, code: code);
  }
}
