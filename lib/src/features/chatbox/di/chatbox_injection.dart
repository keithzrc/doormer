import 'package:get_it/get_it.dart';
import '../data/repositories/chatbox_repository_impl.dart';
import '../domain/repositories/chatbox_repository.dart';
import '../domain/usecase/chatbox_usecase.dart';

final sl = GetIt.instance;

void initChatboxDependencies() {
  // Repository
  if (!GetIt.I.isRegistered<ChatboxRepository>()) {
    GetIt.I.registerLazySingleton<ChatboxRepository>(
      () => ChatboxRepositoryImpl(),
    );

    // Use cases
    GetIt.I.registerLazySingleton(() => GetMessages(GetIt.I()));
    GetIt.I.registerLazySingleton(() => SendMessage(GetIt.I()));
    GetIt.I.registerLazySingleton(() => SendFile(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetContactInfo(GetIt.I()));
  }
}