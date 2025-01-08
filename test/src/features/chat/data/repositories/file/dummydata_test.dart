import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dummy Data JSON', () {
    late List<dynamic> jsonData;

    setUp(() {
      final file = File('lib/src/features/chat/data/repositories/file/dummydata.json');
      jsonData = json.decode(file.readAsStringSync()) as List<dynamic>;
    });

    test('should have correct number of contacts', () {
      expect(jsonData.length, equals(10));
    });

    test('each contact should have required fields', () {
      for (final contact in jsonData) {
        expect(contact, isA<Map<String, dynamic>>());
        expect(contact['id'], isA<String>());
        expect(contact['userName'], isA<String>());
        expect(contact['avatarUrl'], isA<String>());
        expect(contact['lastMessage'], isA<String>());
        expect(contact['lastMessageCreatedTime'], isA<String>());
        expect(contact['isArchived'], isA<bool>());
        expect(contact['isRead'], isA<bool>());
      }
    });

    test('should have valid UUIDs', () {
      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      );
      
      for (final contact in jsonData) {
        expect(contact['id'], matches(uuidPattern));
      }
    });

    test('should have valid dates', () {
      for (final contact in jsonData) {
        expect(
          () => DateTime.parse(contact['lastMessageCreatedTime'] as String),
          returnsNormally,
        );
      }
    });

    test('should have valid avatar URLs', () {
      final urlPattern = RegExp(r'^https://example\.com/avatar\d+\.png$');
      
      for (final contact in jsonData) {
        expect(contact['avatarUrl'], matches(urlPattern));
      }
    });
  });
} 