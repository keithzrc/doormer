import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/dio_client.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/signalr_service.dart';
import 'package:doormer/src/core/utils/token_storage.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chatbox/di/chatbox_injection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/auth/di/auth_module.dart';
import 'package:doormer/src/features/chat/di/chat_module.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // 确保 LocalDataSource 只被注册一次
  serviceLocator
      .registerLazySingleton<LocalDataSource>(() => LocalDataSource());

  // 注册 Dio Client
  serviceLocator.registerLazySingleton<Dio>(() => DioClient.createDio());

  var signalRService = await SignalRService.create();
  // 注册 SignalR 服务为工厂模式，允许动态传递 userId
  serviceLocator.registerFactory<SignalRService>(() => signalRService);

  // 注册其他服务
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  serviceLocator.registerLazySingleton(() =>
      TokenStorage(secureStorage: serviceLocator<FlutterSecureStorage>()));

  serviceLocator.registerLazySingleton<SessionService>(
    () => SessionServiceImpl(
      tokenStorage: serviceLocator<TokenStorage>(),
    ),
  );

  // 初始化特性模块
  initAuthModule();
  initChatModule();
  initChatboxDependencies();
}
