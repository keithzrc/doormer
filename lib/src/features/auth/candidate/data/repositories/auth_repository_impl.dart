// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/features/auth/candidate/data/datasources/auth_remote_datasource.dart';
import 'package:doormer/src/shared/user/candidate/user.dart';
import 'package:doormer/src/features/auth/candidate/domain/repository/auth_repository.dart';

class CandidateAuthRepositoryImpl implements CandidateAuthRepository {
  final CandidateAuthRemoteDataSource remoteDataSource;
  final SessionService sessionService;

  CandidateAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sessionService,
  });

  @override
  Future<User> signup({required String email, required String password}) async {
    // Call remote data source to get LoginResponseModel
    final loginResponse = await remoteDataSource.signup(email, password);

    // Save tokens using SessionService
    await sessionService.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );
    // Return User entity
    final user = loginResponse.user.toEntity();
    return user;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    // Call remote data source to get LoginResponseModel
    final loginResponse = await remoteDataSource.login(email, password);

    // Save tokens using SessionService
    await sessionService.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );

    // Return User entity
    final user = loginResponse.user.toEntity();
    return user;
  }

  @override
  Future<void> verifyEmail(
      {required String email, required String code}) async {
    await remoteDataSource.verifyEmail(email, code);
  }

  @override
  Future<void> logout() async {
    await sessionService.logout(); // Clear tokens and reset session
  }

  // @override
  // Future<User> setupPassword(String password) async {
  //   final loginResponse = await remoteDataSource.setupPassword(password);

  //   return loginResponse.user.toEntity();
  // }
}
