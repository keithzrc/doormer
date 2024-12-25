import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';

void main() {
  group('ContactModel', () {
    const validUuid = '123e4567-e89b-12d3-a456-426614174000';
    final testDateTime = DateTime.parse('2023-04-25T12:34:56.789Z');

    group('Basic Serialization', () {
      test('fromJson should return a valid ContactModel', () {
        final json = {
          'id': validUuid,
          'userName': 'John Doe',
          'avatarUrl': 'https://example.com/avatar.jpg',
          'lastMessage': 'Hello, how are you?',
          'createdTime': '2023-04-25T12:34:56.789Z',
          'isArchived': false,
          'isRead': true,
        };

        final model = ContactModel.fromJson(json);

        expect(model.id, validUuid);
        expect(model.userName, 'John Doe');
        expect(model.avatarUrl, 'https://example.com/avatar.jpg');
        expect(model.lastMessage, 'Hello, how are you?');
        expect(model.createdTime, testDateTime);
        expect(model.isArchived, false);
        expect(model.isRead, true);
      });

      test('toJson should return a valid JSON map', () {
        final model = ContactModel(
          id: validUuid,
          userName: 'John Doe',
          avatarUrl: 'https://example.com/avatar.jpg',
          lastMessage: 'Hello, how are you?',
          createdTime: testDateTime,
          isArchived: false,
          isRead: true,
        );

        final json = model.toJson();

        expect(json['id'], validUuid);
        expect(json['userName'], 'John Doe');
        expect(json['avatarUrl'], 'https://example.com/avatar.jpg');
        expect(json['lastMessage'], 'Hello, how are you?');
        expect(json['createdTime'], testDateTime.toIso8601String());
        expect(json['isArchived'], false);
        expect(json['isRead'], true);
      });
    });

    group('Error Handling', () {
      test('fromJson should throw FormatException for invalid UUID', () {
        final json = {
          'id': 'invalid-uuid',
          'userName': 'John Doe',
          'avatarUrl': 'https://example.com/avatar.jpg',
          'lastMessage': 'Hello',
          'createdTime': '2023-04-25T12:34:56.789Z',
          'isArchived': false,
          'isRead': true,
        };

        expect(
          () => ContactModel.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });

      test(
          'fromJson should throw FormatException for invalid createdTime format',
          () {
        final json = {
          'id': validUuid,
          'userName': 'John Doe',
          'avatarUrl': 'https://example.com/avatar.jpg',
          'lastMessage': 'Hello',
          'createdTime': 'invalid-date-format',
          'isArchived': false,
          'isRead': true,
        };

        expect(
          () => ContactModel.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });

      test('fromJson should throw when required fields are missing', () {
        final json = {
          'userName': 'John Doe',
          // missing other required fields
        };

        expect(
          () => ContactModel.fromJson(json),
          throwsA(isA<TypeError>()), // or whatever exception type you expect
        );
      });

      test('fromJson should not accept null createdTime', () {
        final json = {
          'id': validUuid,
          'userName': 'John Doe',
          'avatarUrl': 'https://example.com/avatar.jpg',
          'lastMessage': 'Hello',
          'createdTime': null,
          'isArchived': false,
          'isRead': true,
        };

        expect(
          () => ContactModel.fromJson(json),
          throwsA(isA<TypeError>()), // or whatever exception type you expect
        );
      });
    });

    group('Entity Conversion', () {
      test('toEntity should convert ContactModel to Contact entity', () {
        final model = ContactModel(
          id: validUuid,
          userName: 'John Doe',
          avatarUrl: 'https://example.com/avatar.jpg',
          lastMessage: 'Hello',
          createdTime: testDateTime,
          isArchived: false,
          isRead: true,
        );

        final entity = model.toEntity();

        expect(entity.id, validUuid);
        expect(entity.userName, 'John Doe');
        expect(entity.avatarUrl, 'https://example.com/avatar.jpg');
        expect(entity.lastMessage, 'Hello');
        expect(entity.lastMessageCreatedTime, testDateTime);
        expect(entity.isArchived, false);
        expect(entity.isRead, true);
      });
    });
  });
}
