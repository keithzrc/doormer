import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';

void initChatModule() {
  // Register ChatRepository
  serviceLocator.registerLazySingleton<ContactRepository>(
    () => ChatRepositoryImpl(),
  );

  // Register use cases
  serviceLocator.registerLazySingleton<GetSortedActiveChatList>(
    () => GetSortedActiveChatList(serviceLocator<ContactRepository>()),
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
