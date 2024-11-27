// lib/src/core/di/service_locator.dart

import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/dio_client.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/token_storage.dart';
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

  // Initialize feature-specific modules
  initAuthModule(); // Initializes dependencies for the auth feature

  // Initialize other feature dependencies here as needed
}
