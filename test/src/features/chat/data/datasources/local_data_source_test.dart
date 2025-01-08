import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LocalDataSource localDataSource;

  setUp(() {
    localDataSource = LocalDataSource();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('LocalDataSource', () {
    const mockJsonData = '''[
      {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "userName": "Test User",
        "avatarUrl": "https://example.com/avatar.jpg",
        "lastMessage": "Hello World",
        "lastMessageCreatedTime": "2024-01-01T00:00:00.000Z",
        "isArchived": false,
        "isRead": true
      }
    ]''';

    test('loadDummyData should load and parse data correctly', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        if (message != null && 
            String.fromCharCodes(message.buffer.asUint8List()).contains(fileDBPath)) {
          return ByteData.view(Uint8List.fromList(mockJsonData.codeUnits).buffer);
        }
        return null;
      });

      final result = await localDataSource.loadDummyData();
      expect(result.length, 1);
      expect(result.first.userName, 'Test User');
      expect(result.first.lastMessage, 'Hello World');
    });

    test('loadDummyData should handle empty data', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        if (message != null && 
            String.fromCharCodes(message.buffer.asUint8List()).contains(fileDBPath)) {
          return ByteData.view(Uint8List.fromList('[]'.codeUnits).buffer);
        }
        return null;
      });

      final result = await localDataSource.loadDummyData();
      expect(result, isEmpty);
    });
  });
}
