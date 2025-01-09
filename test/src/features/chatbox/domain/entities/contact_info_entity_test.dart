import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('ContactInfo', () {
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

    test('should create ContactInfo instance', () {
      // Act
      final contactInfo = ContactInfo(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Assert
      expect(contactInfo, isA<ContactInfo>());
    });

    test('should have correct property values', () {
      // Arrange & Act
      final contactInfo = ContactInfo(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Assert
      expect(contactInfo.id, equals(testId));
      expect(contactInfo.name, testName);
      expect(contactInfo.avatarUrl, testAvatarUrl);
      expect(contactInfo.position, testPosition);
      expect(contactInfo.expectedSalary, testExpectedSalary);
      expect(contactInfo.status, testStatus);
    });

    test('should implement value equality', () {
      // Arrange
      final contactInfo1 = ContactInfo(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final contactInfo2 = ContactInfo(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Assert
      expect(contactInfo1, equals(contactInfo2));
    });

    test('should implement value inequality', () {
      // Arrange
      final contactInfo1 = ContactInfo(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final contactInfo2 = ContactInfo(
        id: const UuidValueConverter()
            .fromJson('123e4567-e89b-12d3-a456-426614174001'),
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Assert
      expect(contactInfo1, isNot(equals(contactInfo2)));
    });

    test('copyWith should create new instance with updated values', () {
      // Arrange
      final original = ContactInfo(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      final newId = const UuidValueConverter()
          .fromJson('123e4567-e89b-12d3-a456-426614174001');

      // Act
      final updated = original.copyWith(
        id: newId,
        name: 'Jane Doe',
        position: 'Senior Developer',
      );

      // Assert
      expect(updated.id, newId);
      expect(updated.name, 'Jane Doe');
      expect(updated.position, 'Senior Developer');
      expect(updated.avatarUrl, original.avatarUrl);
      expect(updated.expectedSalary, original.expectedSalary);
      expect(updated.status, original.status);
    });

    test('toString should contain all properties', () {
      // Arrange
      final contactInfo = ContactInfo(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Act & Assert
      expect(
        contactInfo.toString(),
        'ContactInfo(id: $testId, name: $testName, avatarUrl: $testAvatarUrl, '
        'position: $testPosition, expectedSalary: $testExpectedSalary, '
        'status: $testStatus)',
      );
    });
  });
} 