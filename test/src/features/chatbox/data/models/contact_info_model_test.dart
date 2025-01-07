import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/data/models/contact_info_model.dart';

void main() {
  group('ContactInfoModel', () {
    // Test data
    const testId = '123';
    const testName = 'John Doe';
    const testAvatarUrl = 'https://example.com/avatar.jpg';
    const testPosition = 'Developer';
    const testExpectedSalary = '100k';
    const testStatus = 'Active';

    test('should create ContactInfoModel instance with valid data', () {
      // Arrange & Act
      final model = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Assert
      expect(model.id, testId);
      expect(model.name, testName);
      expect(model.avatarUrl, testAvatarUrl);
      expect(model.position, testPosition);
      expect(model.expectedSalary, testExpectedSalary);
      expect(model.status, testStatus);
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final model = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json, {
        'id': testId,
        'name': testName,
        'avatarUrl': testAvatarUrl,
        'position': testPosition,
        'expectedSalary': testExpectedSalary,
        'status': testStatus,
      });
    });

    test('should create instance from JSON correctly', () {
      // Arrange
      final json = {
        'id': testId,
        'name': testName,
        'avatarUrl': testAvatarUrl,
        'position': testPosition,
        'expectedSalary': testExpectedSalary,
        'status': testStatus,
      };

      // Act
      final model = ContactInfoModel.fromJson(json);

      // Assert
      expect(model.id, testId);
      expect(model.name, testName);
      expect(model.avatarUrl, testAvatarUrl);
      expect(model.position, testPosition);
      expect(model.expectedSalary, testExpectedSalary);
      expect(model.status, testStatus);
    });

    test('should throw when required fields are missing in JSON', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act & Assert
      expect(
        () => ContactInfoModel.fromJson(json),
        throwsA(isA<TypeError>()), // 或者可能是其他类型的异常，取决于json_serializable的实现
      );
    });

    test('toString should return a string containing all properties', () {
      // Arrange
      final model = ContactInfoModel(
        id: testId,
        name: testName,
        avatarUrl: testAvatarUrl,
        position: testPosition,
        expectedSalary: testExpectedSalary,
        status: testStatus,
      );

      // Act
      final string = model.toString();

      // Assert
      expect(string.contains(testId), true);
      expect(string.contains(testName), true);
      expect(string.contains(testAvatarUrl), true);
      expect(string.contains(testPosition), true);
      expect(string.contains(testExpectedSalary), true);
      expect(string.contains(testStatus), true);
    });
  });
}