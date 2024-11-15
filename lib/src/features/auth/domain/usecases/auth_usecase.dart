import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import '../entities/user.dart';

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase(this.authRepository);

  // Signup method
  Future<User> signup(String email, String password) async {
    return await authRepository.signup(email, password);
  }

  // Login method
  Future<User> login(String email, String password) async {
    return await authRepository.login(email, password);
  }

  Future<void> confirmEmail(String email, String code) async {
    return await authRepository.confirmEmail(email, code);
  }
}
