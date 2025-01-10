import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/di/chat_module.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatModule', () {
    setUp(() {
      serviceLocator.reset();
      initChatModule();
    });

    tearDown(() {
      serviceLocator.reset();
    });

    test('should register LocalDataSource', () {
      final dataSource = serviceLocator<LocalDataSource>();
      expect(dataSource, isA<LocalDataSource>());
      expect(serviceLocator.isRegistered<LocalDataSource>(), isTrue);
    });

    test('should register ChatRepository', () {
      final repository = serviceLocator<ContactRepository>();
      expect(repository, isA<ChatRepositoryImpl>());
      expect(serviceLocator.isRegistered<ContactRepository>(), isTrue);
    });

    group('should register use cases', () {
      test('GetSortedActiveChatList', () {
        final useCase = serviceLocator<GetSortedActiveChatList>();
        expect(useCase, isA<GetSortedActiveChatList>());
        expect(serviceLocator.isRegistered<GetSortedActiveChatList>(), isTrue);
      });

      test('GetSortedArchivedChatList', () {
        final useCase = serviceLocator<GetSortedArchivedChatList>();
        expect(useCase, isA<GetSortedArchivedChatList>());
        expect(serviceLocator.isRegistered<GetSortedArchivedChatList>(), isTrue);
      });

      test('ToggleChatArchivedStatus', () {
        final useCase = serviceLocator<ToggleChatArchivedStatus>();
        expect(useCase, isA<ToggleChatArchivedStatus>());
        expect(serviceLocator.isRegistered<ToggleChatArchivedStatus>(), isTrue);
      });

      test('DeleteChat', () {
        final useCase = serviceLocator<DeleteChat>();
        expect(useCase, isA<DeleteChat>());
        expect(serviceLocator.isRegistered<DeleteChat>(), isTrue);
      });
    });

    test('should register ChatBloc', () {
      final bloc = serviceLocator<ChatBloc>();
      expect(bloc, isA<ChatBloc>());
      expect(serviceLocator.isRegistered<ChatBloc>(), isTrue);
    });

    test('should create new instance of ChatBloc each time', () {
      final bloc1 = serviceLocator<ChatBloc>();
      final bloc2 = serviceLocator<ChatBloc>();
      expect(bloc1, isNot(same(bloc2)));
    });

    test('should reuse singleton instances', () {
      final repo1 = serviceLocator<ContactRepository>();
      final repo2 = serviceLocator<ContactRepository>();
      expect(repo1, same(repo2));

      final useCase1 = serviceLocator<GetSortedActiveChatList>();
      final useCase2 = serviceLocator<GetSortedActiveChatList>();
      expect(useCase1, same(useCase2));
    });
  });
} 