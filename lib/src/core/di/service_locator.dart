import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/dio_client.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/signalr_service.dart';
import 'package:doormer/src/core/utils/token_storage.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/auth/di/auth_module.dart';
import 'package:doormer/src/features/chat/di/chat_module.dart';
import 'package:signalr_netcore/signalr_client.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Register Dio Client with base URL and interceptors
  serviceLocator.registerLazySingleton<Dio>(() => DioClient.createDio());

  serviceLocator.registerSingletonAsync<SignalRService>(
      () async => await SignalRService.create());

  // final SignalRService signalRService = serviceLocator<SignalRService>();
  // await signalRService.initSignalR();

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
    ),
  );

  // Initialize feature-specific modules
  initAuthModule(); // Initializes dependencies for the auth feature

  initChatModule(); // Initialize Chat feature dependencies
}
