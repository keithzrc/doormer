// lib/src/core/di/service_locator.dart

import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/dio_client.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/token_storage.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/di/auth_module.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Register Dio Client with base URL and interceptors
  serviceLocator.registerLazySingleton<Dio>(() => DioClient.createDio());

  // Register FlutterSecureStorage
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Register TokenStorage
  serviceLocator.registerLazySingleton(() =>
      TokenStorage(secureStorage: serviceLocator<FlutterSecureStorage>()));

  // Register SessionService
  serviceLocator.registerLazySingleton<SessionService>(
    () => SessionServiceImpl(
      tokenStorage: serviceLocator<TokenStorage>(),
      // dio: serviceLocator<Dio>(),
    ),
  );

  // Register ChatRepository
  serviceLocator.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
        // Pass required dependencies to the repository if needed
        ),
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

  // Initialize feature-specific modules
  initAuthModule(); // Initializes dependencies for the auth feature

  // Initialize other feature dependencies here as needed
}
