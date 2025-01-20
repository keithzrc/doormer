import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:dio/dio.dart';
import 'package:doormer/src/features/chat/data/datasources/remote_data_source.dart';

void initChatModule() {
  // Register LocalDataSource
  serviceLocator.registerSingleton<LocalDataSource>(LocalDataSource());

  // Register RemoteDataSource
  serviceLocator.registerSingleton<ChatRemoteDataSource>(
    ChatRemoteDataSource(dio: serviceLocator<Dio>()),
  );

  // Register ChatRepository
  serviceLocator.registerSingleton<ContactRepository>(
    ChatRepositoryImpl(
      localDataSource: serviceLocator<LocalDataSource>(),
      remoteDataSource: serviceLocator<ChatRemoteDataSource>(),
    ),
  );

  // Register use cases
  serviceLocator.registerSingleton<GetSortedActiveChatList>(
    GetSortedActiveChatList(serviceLocator<ContactRepository>()),
  );

  serviceLocator.registerLazySingleton<GetSortedArchivedChatList>(
    () => GetSortedArchivedChatList(serviceLocator<ContactRepository>()),
  );

  serviceLocator.registerLazySingleton<ToggleChatArchivedStatus>(
    () => ToggleChatArchivedStatus(serviceLocator<ContactRepository>()),
  );

  serviceLocator.registerLazySingleton<DeleteChat>(
    () => DeleteChat(serviceLocator<ContactRepository>()),
  );

  // Register ChatBloc
  serviceLocator.registerFactory<ChatBloc>(() => ChatBloc(
        getChatListUseCase: serviceLocator<GetSortedActiveChatList>(),
        getArchivedChatListUseCase: serviceLocator<GetSortedArchivedChatList>(),
        toggleChatUseCase: serviceLocator<ToggleChatArchivedStatus>(),
        deleteChatUseCase: serviceLocator<DeleteChat>(),
      ));
}
