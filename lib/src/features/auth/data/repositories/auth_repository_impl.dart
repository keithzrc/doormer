// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doormer/src/features/auth/data/datasources/local_data_source.dart';
import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/shared/user/Models/user_model_factory.dart';

class AuthRepositoryImpl implements AuthRepository {
  //final AuthRemoteDataSource dataSource;
  final AuthLocalDataSource dataSource;
  final SessionService sessionService;

  AuthRepositoryImpl({
    required this.dataSource,
    required this.sessionService,
  });

  @override
  Future<User> signup({required String email, required String password}) async {
    // Call remote data source to get LoginResponseModel
    final loginResponse = await dataSource.signup(email, password);

    // Save tokens using SessionService
    await sessionService.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );
    // Return User entity
    final userEntity = loginResponse.user.toEntity();
    return userEntity;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    // Call remote data source to get LoginResponseModel
    final loginResponse = await dataSource.login(email, password);
    AppLogger.info('$loginResponse');

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
    await dataSource.verifyEmail(email, code);
  }

  @override
  Future<void> logout() async {
    await sessionService.logout(); // Clear tokens and reset session
  }

  @override
  Future<User> signInWithApple() {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithGoogle() async {
    // Step 1: Get Google ID token
    final googleIdToken = await dataSource.getGoogleIdToken();

    final user = await exchangeGoogleIdTokenForTokens(googleIdToken);

    return user;
  }

  Future<User> exchangeGoogleIdTokenForTokens(String googleIdToken) async {
    final loginResponse =
        await dataSource.exchangeGoogleIdTokenForTokens(googleIdToken);

    // Save tokens using SessionService
    await sessionService.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );
    // Return User entity
    final user = loginResponse.user.toEntity();
    return user;
  }
}
