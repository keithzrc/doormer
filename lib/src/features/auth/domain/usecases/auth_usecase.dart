import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import '../../../../shared/user/Entity/user_entity.dart';

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase(this.authRepository);

  // Signup method
  Future<User> signup({
    required String email,
    required String password,
  }) async {
    return await authRepository.signup(email: email, password: password);
  }

  // Login method
  Future<User> login({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(email: email, password: password);
  }

  // Sign Up/ Login with Google
  Future<User> googleSignIn() async {
    return await authRepository.signInWithGoogle();
  }

  Future<void> verifyEmail(
      {required String email, required String code}) async {
    return await authRepository.verifyEmail(email: email, code: code);
  }
}
