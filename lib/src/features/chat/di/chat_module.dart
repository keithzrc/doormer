import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/data/datasources/remote_data_source.dart';
import 'package:doormer/src/features/chat/data/repositories/api/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:doormer/src/core/config/app_config.dart';

void initChatModule() {
  // API Client
  serviceLocator.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Data Sources
  serviceLocator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(
      client: serviceLocator<http.Client>(),
      baseUrl: AppConfig.apiBaseUrl,
    ),
  );

  // Repositories
  serviceLocator.registerLazySingleton<ContactRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: serviceLocator<RemoteDataSource>(),
      currentUserId: 'test-user-id', // TODO: 从认证服务获取
    ),
  );

  // Use Cases
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

  // BLoC
  serviceLocator.registerFactory<ChatBloc>(() => ChatBloc(
        getChatListUseCase: serviceLocator<GetSortedActiveChatList>(),
        getArchivedChatListUseCase: serviceLocator<GetSortedArchivedChatList>(),
        toggleChatUseCase: serviceLocator<ToggleChatArchivedStatus>(),
        deleteChatUseCase: serviceLocator<DeleteChat>(),
      ));
}
