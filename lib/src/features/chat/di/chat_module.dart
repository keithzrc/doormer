import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';

void initChatModule() {
  // Register ChatRepository
  serviceLocator.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(),
  );

  // Register use cases
  serviceLocator.registerLazySingleton<GetActiveChatList>(
    () => GetActiveChatList(serviceLocator<ChatRepository>()),
  );

  serviceLocator.registerLazySingleton<GetArchivedChatList>(
    () => GetArchivedChatList(serviceLocator<ChatRepository>()),
  );

  serviceLocator.registerLazySingleton<ToggleChatArchivedStatus>(
    () => ToggleChatArchivedStatus(serviceLocator<ChatRepository>()),
  );

  serviceLocator.registerLazySingleton<DeleteChat>(
    () => DeleteChat(serviceLocator<ChatRepository>()),
  );

  // Register ChatBloc
  serviceLocator.registerFactory<ChatBloc>(() => ChatBloc(
        getChatListUseCase: serviceLocator<GetActiveChatList>(),
        getArchivedChatListUseCase: serviceLocator<GetArchivedChatList>(),
        toggleChatUseCase: serviceLocator<ToggleChatArchivedStatus>(),
        deleteChatUseCase: serviceLocator<DeleteChat>(),
      ));
}
