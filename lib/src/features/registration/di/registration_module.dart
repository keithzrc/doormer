import 'package:doormer/src/core/network/request_manager.dart';
import 'package:doormer/src/features/registration/data/datasource/registration_remote_datasource.dart';
import 'package:doormer/src/features/registration/data/repository/registration_repository_impl.dart';
import 'package:doormer/src/features/registration/domain/repository/registration_repository.dart';
import 'package:doormer/src/features/registration/domain/usecase/registration_usecase.dart';
import 'package:doormer/src/features/registration/presentation/bloc/document_registration/registration_document_bloc.dart';
import 'package:doormer/src/features/registration/presentation/bloc/general_registration/registration_bloc.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void initRegisterModule() {
  // Register RegistrationRemoteDatasource
  serviceLocator.registerLazySingleton(() => RegistrationRemoteDataSource(
        requestManager: serviceLocator<RequestManager>(),
      ));

  // Register RegistrationRepository
  serviceLocator.registerLazySingleton<RegistrationRepository>(
      () => RegistrationRepositoryImpl(
            dataSource: serviceLocator<RegistrationRemoteDataSource>(),
          ));

  // Register RegistrationUsecase
  serviceLocator.registerLazySingleton(() => RegistrationUsecase(
        repository: serviceLocator<RegistrationRepository>(),
      ));

  // Register RegistrationBloc
  serviceLocator.registerFactory(() => RegistrationBloc(
      registrationUsecase: serviceLocator<RegistrationUsecase>(),
      globalSessionBloc: serviceLocator<GlobalSessionBloc>()));

  serviceLocator.registerFactory(() => RegistrationDocumentBloc(
        registrationUsecase: serviceLocator<RegistrationUsecase>(),
      ));
}
