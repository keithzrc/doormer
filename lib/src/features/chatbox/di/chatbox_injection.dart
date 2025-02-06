import 'package:doormer/src/core/signalr_service.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import '../data/repositories/chatbox_repository_impl.dart';
import '../domain/repositories/chatbox_repository.dart';
import '../domain/usecase/chatbox_usecase.dart';

final sl = GetIt.instance;

void initChatboxDependencies() {
  // LocalDataSource (如果还没注册)
  if (!sl.isRegistered<LocalDataSource>()) {
    sl.registerSingleton<LocalDataSource>(LocalDataSource());
  }

  // Repository
  if (!sl.isRegistered<ChatboxRepository>()) {
    sl.registerLazySingleton<ChatboxRepository>(
      () => ChatboxRepositoryImpl(
        //localDataSource: sl<LocalDataSource>(),
        signalRService: sl<SignalRService>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetMessages(sl()));
    sl.registerLazySingleton(() => SendMessage(sl()));
    sl.registerLazySingleton(() => SendFile(sl()));
    //sl.registerLazySingleton(() => GetContactInfo(sl()));
  }
}