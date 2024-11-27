// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/token_storage.dart';
import 'package:doormer/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doormer/src/shared/domain/entities/user.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;
  final SessionService sessionService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
    required this.sessionService,
  });

  @override
  Future<User> signup(String email, String password) async {
    // Call the data source and return a User
    final userModel = await remoteDataSource.signup(email, password);

    // Return User entity
    return userModel.userInfo.toEntity();
  }

  @override
  Future<User> login(String email, String password) async {
    // Call the data source and return a User
    final userModel = await remoteDataSource.login(email, password);

    // Save tokens for session management
    await tokenStorage.saveAccessToken(userModel.accessToken);
    await tokenStorage.saveRefreshToken(userModel.refreshToken);

    // Return User entity
    return userModel.userInfo.toEntity();
  }

  @override
  Future<void> confirmEmail(String email, String code) async {
    await remoteDataSource.confirmEmail(email, code);
  }

  @override
  Future<void> logout() async {
    await sessionService.logout(); // Clear tokens and reset session
  }
}
