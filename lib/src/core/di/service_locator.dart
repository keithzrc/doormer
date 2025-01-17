import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/dio_client.dart';
import 'package:doormer/src/core/network/request_manager.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/services/sessions/session_service_impl.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage_mobile.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage_web.dart';
import 'package:doormer/src/features/chat/di/chat_module.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/auth/di/auth_module.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Register TokenStorage based on platform
  if (kIsWeb) {
    // Use Web Implementation
    serviceLocator.registerSingleton<TokenStorage>(TokenStorageWeb());
  } else {
    // Use Mobile Implementation
    serviceLocator
        .registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
    serviceLocator.registerSingleton<TokenStorage>(
      TokenStorageMobile(serviceLocator<FlutterSecureStorage>()),
    );
  }

  // Register SessionService
  serviceLocator.registerSingleton<SessionService>(
    SessionServiceImpl(
      tokenStorage: serviceLocator<TokenStorage>(),
      dio: serviceLocator<Dio>(),
    ),
  );

  // Register GlobalSessionBloc
  serviceLocator.registerSingleton<GlobalSessionBloc>(
    GlobalSessionBloc(
      sessionService: serviceLocator<SessionService>(),
    ),
  );

  // Register Dio Client with interceptors
  serviceLocator.registerSingleton<Dio>(
    DioClient.createDio(
      sessionService: serviceLocator<SessionService>(),
      sessionBloc: serviceLocator<GlobalSessionBloc>(),
    ),
  );

  // Register RequestManager with Dio, SessionService, and GlobalSessionBloc
  serviceLocator.registerSingleton<RequestManager>(
    RequestManager(
      dio: serviceLocator<Dio>(),
      sessionService: serviceLocator<SessionService>(),
      sessionBloc: serviceLocator<GlobalSessionBloc>(),
    ),
  );

  // Initialize feature-specific modules
  initAuthModule(); // Initializes dependencies for the auth feature

  initChatModule(); // Initialize Chat feature dependencies
}
