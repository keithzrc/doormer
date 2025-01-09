import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/data/models/contact_info_model.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('ContactInfoModel', () {
    // Test data
    late UuidValue testId;
    const testName = 'John Doe';
    const testAvatarUrl = 'https://example.com/avatar.jpg';
    const testPosition = 'Developer';
    const testExpectedSalary = '100k';
    const testStatus = 'Active';

    setUp(() {
      testId = const UuidValueConverter()
          .fromJson('123e4567-e89b-12d3-a456-426614174000');
    });

    test('should create ContactInfoModel instance with valid data', () {
      final model = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      expect(model.id, equals(testId));
      expect(model.name, equals(testName));
      expect(model.avatarUrl, equals(testAvatarUrl));
      expect(model.position, equals(testPosition));
      expect(model.expectedSalary, equals(testExpectedSalary));
      expect(model.status, equals(testStatus));
    });

    test('should convert to entity correctly', () {
      final model = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final entity = model.toEntity();

      expect(entity, isA<ContactInfo>());
      expect(entity.id, equals(testId));
      expect(entity.name, testName);
      expect(entity.avatarUrl, testAvatarUrl);
      expect(entity.position, testPosition);
      expect(entity.expectedSalary, testExpectedSalary);
      expect(entity.status, testStatus);
    });

    test('should convert to JSON correctly', () {
      final model = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final json = model.toJson();

      expect(json, {
        'id': testId.toString(),
        'name': testName,
        'avatarUrl': testAvatarUrl,
        'position': testPosition,
        'expectedSalary': testExpectedSalary,
        'status': testStatus,
      });
    });

    test('should create instance from JSON correctly', () {
      final json = {
        'id': testId.toString(),
        'name': testName,
        'avatarUrl': testAvatarUrl,
        'position': testPosition,
        'expectedSalary': testExpectedSalary,
        'status': testStatus,
      };

      final model = ContactInfoModel.fromJson(json);

      expect(model.id, equals(testId));
      expect(model.name, testName);
      expect(model.avatarUrl, testAvatarUrl);
      expect(model.position, testPosition);
      expect(model.expectedSalary, testExpectedSalary);
      expect(model.status, testStatus);
    });

    test('should throw when JSON contains invalid UUID', () {
      final json = {
        'id': 'invalid-uuid',
        'name': testName,
        'avatarUrl': testAvatarUrl,
        'position': testPosition,
        'expectedSalary': testExpectedSalary,
        'status': testStatus,
      };

      expect(
        () => ContactInfoModel.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw when required fields are missing in JSON', () {
      final json = <String, dynamic>{};

      expect(
        () => ContactInfoModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('toString should return a string containing all properties', () {
      final model = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final string = model.toString();

      expect(string, contains(testId.toString()));
      expect(string, contains(testName));
      expect(string, contains(testAvatarUrl));
      expect(string, contains(testPosition));
      expect(string, contains(testExpectedSalary));
      expect(string, contains(testStatus));
    });

    test('should have value equality', () {
      final model1 = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final model2 = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final differentModel = ContactInfoModel(
        id: const UuidValueConverter()
            .fromJson('123e4567-e89b-12d3-a456-426614174001'),
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      expect(model1, equals(model2));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1, isNot(equals(differentModel)));
    });
  });
}