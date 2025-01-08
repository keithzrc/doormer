import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('ContactModel', () {
    final validUuid = UuidValue('123e4567-e89b-12d3-a456-426614174000');
    final testDateTime = DateTime.parse('2024-01-01T12:00:00.000Z');
    final validJson = {
      'id': validUuid.toString(),
      'userName': 'Test User',
      'avatarUrl': 'https://example.com/avatar.jpg',
      'lastMessage': 'Hello World',
      'lastMessageCreatedTime': '2024-01-01T12:00:00.000Z',
      'isArchived': false,
      'isRead': true,
    };

    late ContactModel sut;

    setUp(() {
      sut = ContactModel(
        id: validUuid,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello World',
        lastMessageCreatedTime: testDateTime,
        isArchived: false,
        isRead: true,
      );
    });

    void verifyContactModel(ContactModel model) {
      expect(model.id, equals(validUuid));
      expect(model.userName, equals('Test User'));
      expect(model.avatarUrl, equals('https://example.com/avatar.jpg'));
      expect(model.lastMessage, equals('Hello World'));
      expect(model.lastMessageCreatedTime, equals(testDateTime));
      expect(model.isArchived, isFalse);
      expect(model.isRead, isTrue);
    }

    group('constructor validation', () {
      test('should create valid instance with correct parameters', () {
        verifyContactModel(sut);
      });

      test('should throw ArgumentError when userName is empty', () {
        expect(
          () => ContactModel(
            id: validUuid,
            userName: '  ',
            avatarUrl: 'https://example.com/avatar.jpg',
            lastMessage: 'Hello',
            lastMessageCreatedTime: testDateTime,
            isArchived: false,
            isRead: true,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError when avatarUrl is empty', () {
        expect(
          () => ContactModel(
            id: validUuid,
            userName: 'Test User',
            avatarUrl: '  ',
            lastMessage: 'Hello',
            lastMessageCreatedTime: testDateTime,
            isArchived: false,
            isRead: true,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('JSON serialization', () {
      test('fromJson should create valid instance', () {
        final result = ContactModel.fromJson(validJson);
        verifyContactModel(result);
      });

      test('fromJson should handle different UUID formats', () {
        final result = ContactModel.fromJson(validJson);
        expect(result.id, isA<UuidValue>());
        expect(result.id.toString(), equals(validUuid.toString()));
      });

      test('fromJson should throw FormatException for invalid date format', () {
        final invalidJson = Map<String, dynamic>.from(validJson)
          ..['lastMessageCreatedTime'] = 'invalid-date';

        expect(
          () => ContactModel.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });

      test('fromJson should throw TypeError for missing required fields', () {
        final invalidJson = Map<String, dynamic>.from(validJson)..remove('avatarUrl');

        expect(
          () => ContactModel.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      });

      test('toJson should handle all fields correctly', () {
        final json = sut.toJson();
        expect(json, equals(validJson));
      });
    });

    group('Entity conversion', () {
      test('toEntity should convert to Contact correctly', () {
        final entity = sut.toEntity();

        expect(entity, isA<Contact>());
        expect(entity.id, equals(validUuid));
        expect(entity.userName, equals('Test User'));
        expect(entity.avatarUrl, equals('https://example.com/avatar.jpg'));
        expect(entity.lastMessage, equals('Hello World'));
        expect(entity.lastMessageCreatedTime, equals(testDateTime));
        expect(entity.isArchived, isFalse);
        expect(entity.isRead, isTrue);
      });

      test('fromEntity should create valid ContactModel', () {
        final entity = Contact(
          id: validUuid,
          userName: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          lastMessage: 'Hello World',
          lastMessageCreatedTime: testDateTime,
          isArchived: false,
          isRead: true,
        );

        final result = ContactModel.fromEntity(entity);
        verifyContactModel(result);
      });
    });
  });
} 