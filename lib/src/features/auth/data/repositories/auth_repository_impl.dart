// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:doormer/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doormer/src/features/auth/domain/entities/user.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signup(String email, String password) async {
    // Call the data source and return a User
    final userModel = await remoteDataSource.signup(email, password);
    return userModel; // UserModel is a subclass of User
  }

  @override
  Future<User> login(String email, String password) async {
    // Call the data source and return a User
    final userModel = await remoteDataSource.login(email, password);
    return userModel;
  }

  @override
  Future<void> confirmEmail(String email, String code) async {
    await remoteDataSource.confirmEmail(email, code);
  }
}
