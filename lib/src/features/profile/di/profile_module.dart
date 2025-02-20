import 'package:dio/dio.dart';
import 'package:doormer/src/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:doormer/src/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:doormer/src/features/profile/data/repository/profile_repository_impl.dart';
import 'package:doormer/src/features/profile/domain/repository/profile_repository.dart';
import 'package:doormer/src/features/profile/domain/usecase/profile_usecase.dart';
import 'package:doormer/src/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initProfileModule() {
  sl.registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(dio: sl<Dio>()));

  sl.registerFactory<ProfileLocalDataSource>(() => ProfileLocalDataSource());

  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
      localDataSource: sl<ProfileLocalDataSource>(),
      remoteDataSource: sl<ProfileRemoteDataSource>()));

  sl.registerLazySingleton<ProfileUseCases>(
    () => ProfileUseCases(repository: sl<ProfileRepository>()),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
        profileUseCase: sl<ProfileUseCases>(),
        globalSessionBloc: sl<GlobalSessionBloc>()),
  );
}
