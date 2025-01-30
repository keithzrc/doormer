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

  /// Register company information usecase
  Future<User> registerCompanyInfo({
    required String companyName,
    required String nzbn,
    required String companyType,
    required String companySize,
    required String industry,
    required String oriented,
  }) async {
    return await authRepository.registerCompanyInfo(
        companyName: companyName,
        nzbn: nzbn,
        companyType: companyType,
        companySize: companySize,
        industry: industry,
        oriented: oriented);
  }

  /// Register candidate information usecase
  Future<User> registerCandidateInfo({
    required String firstName,
    required String lastName,
  }) async {
    return await authRepository.registerCandidateInfo(
        firstName: firstName, lastName: lastName);
  }
}
