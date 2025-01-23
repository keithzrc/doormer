import 'package:doormer/src/shared/user/company/company.dart';

class EmployerAuthUseCase {
  final EmployerAuthUseCase authRepository;

  EmployerAuthUseCase(this.authRepository);

  // Signup method
  Future<EmployerUser> signup({
    required String email,
    required String password,
  }) async {
    return await authRepository.signup(email: email, password: password);
  }

  // Login method
  Future<EmployerUser> login({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(email: email, password: password);
  }

  Future<void> verifyEmail(
      {required String email, required String code}) async {
    return await authRepository.verifyEmail(email: email, code: code);
  }
}
