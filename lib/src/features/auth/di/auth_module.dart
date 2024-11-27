// lib/src/features/auth/di/auth_module.dart

import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/token_storage.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/features/auth/domain/usecases/auth_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

void initAuthModule() {
  // Register AuthRemoteDataSource
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(dio: serviceLocator<Dio>()),
  );

  // Register AuthRepository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
        tokenStorage: serviceLocator<TokenStorage>(),
        sessionService: serviceLocator<SessionService>(),
      ));

  // Register AuthUseCase
  serviceLocator.registerLazySingleton(() => AuthUseCase(serviceLocator()));

  // Register AuthBloc
  serviceLocator.registerFactory(
      () => AuthBloc(authUseCase: serviceLocator<AuthUseCase>()));
}
