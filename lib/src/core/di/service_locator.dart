import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/dio_client.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/services/sessions/session_service_impl.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage_mobile.dart';
import 'package:doormer/src/core/utils/token_storage/token_storage_web.dart';
import 'package:doormer/src/features/auth/di/auth_module.dart';
import 'package:doormer/src/features/chat/di/chat_module.dart';
import 'package:doormer/src/features/registration/di/registration_module.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

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

  // Register Session Service (with token and dio)
  serviceLocator.registerLazySingleton<SessionService>(
    () => SessionServiceImpl(
      tokenStorage: serviceLocator<TokenStorage>(),
      dio: Dio(), // Temporary basic Dio instance
    ),
  );

  // Register GlobalSessionBloc
  serviceLocator.registerSingleton<GlobalSessionBloc>(
    GlobalSessionBloc(
      sessionService: serviceLocator<SessionService>(),
    ),
  );

  // Register Dio
  serviceLocator.registerLazySingleton<Dio>(
    () => DioClient.createDio(
      sessionService: serviceLocator<SessionService>(),
      sessionBloc: serviceLocator<GlobalSessionBloc>(),
    ),
  );

  // Inject the fully configured Dio into SessionService
  final sessionService = serviceLocator<SessionService>() as SessionServiceImpl;
  sessionService.setDio(serviceLocator<Dio>());

  // Initialize feature-specific modules
  initAuthModule(); // Initializes dependencies for the auth feature

  initRegisterModule();

  initChatModule(); // Initialize Chat feature dependencies
}
