// lib/src/features/auth/di/auth_module.dart

import 'package:dio/dio.dart';
import 'package:doormer/src/core/config/app_config.dart';
import 'package:doormer/src/core/network/request_manager.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doormer/src/features/auth/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/features/auth/domain/usecases/auth_usecase.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final serviceLocator = GetIt.instance;

void initAuthModule() {
  serviceLocator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
      clientId: AppConfig.googleClientId,
      scopes: ['openid', 'email', 'profile']));

  // Register AuthRemoteDataSource
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      requestManager: serviceLocator<RequestManager>(),
      sessionService: serviceLocator<SessionService>(),
      googleSignIn: serviceLocator<GoogleSignIn>(),
      dio: serviceLocator<Dio>(),
    ),
  );

  serviceLocator
      .registerFactory<AuthLocalDataSource>(() => AuthLocalDataSource());

  // Register AuthRepository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
        dataSource: serviceLocator<AuthLocalDataSource>(),
        sessionService: serviceLocator<SessionService>(),
      ));

  // Register AuthUseCase
  serviceLocator.registerLazySingleton(() => AuthUseCase(serviceLocator()));

  // Register AuthBloc
  serviceLocator.registerFactory(() => AuthBloc(
      authUseCase: serviceLocator<AuthUseCase>(),
      globalSessionBloc: serviceLocator<GlobalSessionBloc>()));
}
