import 'package:doormer/src/features/auth/candidate/domain/repository/auth_repository.dart';
import '../../../../../shared/user/candidate/user.dart';

class CandidateAuthUseCase {
  final CandidateAuthRepository authRepository;

  CandidateAuthUseCase(this.authRepository);

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

  Future<void> verifyEmail(
      {required String email, required String code}) async {
    return await authRepository.verifyEmail(email: email, code: code);
  }
}
