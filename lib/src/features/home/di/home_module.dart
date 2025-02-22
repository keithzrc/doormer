import 'package:doormer/src/features/home/candidate/data/datasource/candidate_home_local_datasource.dart';
import 'package:doormer/src/features/home/candidate/data/repository/candidate_home_repository_impl.dart';
import 'package:doormer/src/features/home/candidate/domain/repository/candidate_home_repository.dart';
import 'package:doormer/src/features/home/candidate/domain/usecase/candidate_home_usecase.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/home/candidate/presentation/bloc/candidate_home_bloc.dart';

final sl = GetIt.instance;

void initHomeModule() {
  // 1. Register the local datasource.
  sl.registerLazySingleton<CandidateHomeLocalDatasource>(
    () => CandidateHomeLocalDatasource(),
  );

  // 2. Register the CandidateHomeRepository with its dependency.
  sl.registerLazySingleton<CandidateHomeRepository>(
    () => CandidateHomeRepositoryImpl(
      localDataSource: sl<CandidateHomeLocalDatasource>(),
    ),
  );

  // 3. Register the GetHomeData use case.
  // (GlobalSessionBloc should be registered in a core or session module.)
  sl.registerLazySingleton<GetHomeData>(
    () => GetHomeData(
      sl<GlobalSessionBloc>(),
      repository: sl<CandidateHomeRepository>(),
    ),
  );

  // 4. Register the CandidateHomeBloc.
  sl.registerFactory(
    () => CandidateHomeBloc(
      getHomeDataUseCase: sl<GetHomeData>(),
    ),
  );
}
