import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chatbox/di/chatbox_injection.dart';
import 'package:doormer/src/features/chatbox/domain/repositories/chatbox_repository.dart';

void main() {
  final sl = GetIt.instance;

  setUp(() {
    sl.reset();
  });

  group('ChatboxInjection', () {
    test('should register LocalDataSource as singleton', () {
      // Act
      initChatboxDependencies();

      // Assert
      expect(sl.isRegistered<LocalDataSource>(), true);
      expect(sl<LocalDataSource>(), isA<LocalDataSource>());
      
      // Verify singleton behavior
      final firstInstance = sl<LocalDataSource>();
      final secondInstance = sl<LocalDataSource>();
      expect(firstInstance, same(secondInstance));
    });

    test('should register ChatboxRepository as lazy singleton', () {
      // Act
      initChatboxDependencies();

      // Assert
      expect(sl.isRegistered<ChatboxRepository>(), true);
    });

    test('should not register dependencies twice', () {
      // Act
      initChatboxDependencies();
      initChatboxDependencies();

      // Assert
      expect(sl.isRegistered<LocalDataSource>(), true);
      expect(sl.isRegistered<ChatboxRepository>(), true);
      
      // Verify singleton behavior is maintained
      final firstInstance = sl<LocalDataSource>();
      final secondInstance = sl<LocalDataSource>();
      expect(firstInstance, same(secondInstance));
    });
  });
} 