// lib/src/features/auth/di/auth_module.dart

import 'package:doormer/src/core/network/request_manager.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/features/auth/candidate/domain/repository/auth_repository.dart';
import 'package:doormer/src/features/auth/candidate/domain/usecases/auth_usecase.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:get_it/get_it.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

void initAuthModule() {
  // Register AuthRemoteDataSource
  serviceLocator.registerFactory<CandidateAuthRemoteDataSource>(
    () => CandidateAuthRemoteDataSource(
        requestManager: serviceLocator<RequestManager>(),
        sessionService: serviceLocator<SessionService>()),
  );

  // Register AuthRepository
  serviceLocator.registerLazySingleton<CandidateAuthRepository>(
      () => CandidateAuthRepositoryImpl(
            remoteDataSource: serviceLocator<CandidateAuthRemoteDataSource>(),
            sessionService: serviceLocator<SessionService>(),
          ));

  // Register AuthUseCase
  serviceLocator
      .registerLazySingleton(() => CandidateAuthUseCase(serviceLocator()));

  // Register AuthBloc
  serviceLocator.registerFactory(() => AuthBloc(
      authUseCase: serviceLocator<CandidateAuthUseCase>(),
      globalSessionBloc: serviceLocator<GlobalSessionBloc>()));
}
