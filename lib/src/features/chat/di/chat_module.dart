import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';

import 'package:dio/dio.dart';
import 'package:doormer/src/features/chat/data/datasources/remote_data_source.dart';
import 'package:doormer/src/features/chatbox/domain/repositories/chatbox_repository.dart';
import 'package:doormer/src/features/chatbox/data/repositories/chatbox_repository_impl.dart';
import 'package:doormer/src/features/chatbox/domain/usecase/chatbox_usecase.dart';
import 'package:doormer/src/core/signalr_service.dart';

void initChatModule() {
  // Register RemoteDataSource
  serviceLocator.registerSingleton<ChatRemoteDataSource>(
    ChatRemoteDataSource(dio: serviceLocator<Dio>()),
  );

  // Register LocalDataSource
  serviceLocator.registerSingleton<LocalDataSource>(
    LocalDataSource(),
  );




void initChatModule() {

  // Register ChatRepository
  serviceLocator.registerSingleton<ContactRepository>(
    ChatRepositoryImpl(
      remoteDataSource: serviceLocator<ChatRemoteDataSource>(),
    ),
  );
  // Register ChatboxRepository
  serviceLocator.registerLazySingleton<ChatboxRepository>(
    () => ChatboxRepositoryImpl(
      //localDataSource: serviceLocator<LocalDataSource>(),
      signalRService: serviceLocator<SignalRService>(),
    ),
  );

  // Register Chatbox Use Cases
  serviceLocator.registerLazySingleton<GetMessages>(
    () => GetMessages(serviceLocator<ChatboxRepository>()),
  );

  serviceLocator.registerLazySingleton<SendMessage>(
    () => SendMessage(serviceLocator<ChatboxRepository>()),
  );

  serviceLocator.registerLazySingleton<SendFile>(
    () => SendFile(serviceLocator<ChatboxRepository>()),
  );

  // 添加 HandleReceivedMessage 的注册
  serviceLocator.registerLazySingleton<HandleReceivedMessage>(
    () => HandleReceivedMessage(serviceLocator<ChatboxRepository>()),
  );

  // serviceLocator.registerLazySingleton<GetContactInfo>(
  //   () => GetContactInfo(serviceLocator<ChatboxRepository>()),
  // );

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

  // Register ChatBloc
  serviceLocator.registerFactory<ChatBloc>(() => ChatBloc(
        getChatListUseCase: serviceLocator<GetSortedActiveChatList>(),
        getArchivedChatListUseCase: serviceLocator<GetSortedArchivedChatList>(),
        toggleChatUseCase: serviceLocator<ToggleChatArchivedStatus>(),
      ));

  // Register ChatboxBloc
  
}
}