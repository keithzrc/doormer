import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/data/models/chat_model.dart';

void main() {
  group('ContactModel', () {
    // 基础序列化测试组
    group('Basic Serialization', () {
      test('fromJson should return a valid ContactModel', () {
        // 测试标准JSON数据转换为模型对象
        final json = {
          'id': 'abc123',
          'userName': 'John Doe',
          'avatarUrl': 'https://example.com/avatar.jpg',
          'lastMessage': 'Hello, how are you?',
          'createdTime': '2023-04-25T12:34:56.789Z',
          'isArchived': false,
        };

        final model = ContactModel.fromJson(json);

        // 验证所有字段是否正确转换
        expect(model.id, 'abc123');
        expect(model.userName, 'John Doe');
        expect(model.avatarUrl, 'https://example.com/avatar.jpg');
        expect(model.lastMessage, 'Hello, how are you?');
        expect(model.createdTime, DateTime.parse('2023-04-25T12:34:56.789Z'));
        expect(model.isArchived, false);
      });

      test('toJson should return a valid JSON map', () {
        // 测试模型对象转换为JSON数据
        final utcDateTime = DateTime.parse('2023-04-25T12:34:56.789Z');
        final model = ContactModel(
          id: 'abc123',
          userName: 'John Doe',
          avatarUrl: 'https://example.com/avatar.jpg',
          lastMessage: 'Hello, how are you?',
          createdTime: utcDateTime,
          isArchived: false,
        );

        final json = model.toJson();
        final expectedLocalTime = utcDateTime.toLocal().toIso8601String();

        // 验证JSON数据的正确性
        expect(json['id'], 'abc123');
        expect(json['userName'], 'John Doe');
        expect(json['avatarUrl'], 'https://example.com/avatar.jpg');
        expect(json['lastMessage'], 'Hello, how are you?');
        expect(json['createdTime'], expectedLocalTime);
        expect(json['isArchived'], false);
      });
    });

    // 边缘情况测试组
    group('Edge Cases', () {
      test('fromJson should handle missing fields with default values', () {
        // 测试处理缺失字段时的默认值
        final json = {
          'id': 'abc123',
        };

        final model = ContactModel.fromJson(json);

        // 验证默认值是否正确设置
        expect(model.id, 'abc123');
        expect(model.userName, 'Unknown User');
        expect(model.avatarUrl, '');
        expect(model.lastMessage, '');
        expect(model.createdTime, null);
        expect(model.isArchived, false);
      });

      test('fromJson should generate new UUID when id is missing', () {
        // 测试缺失ID时是否自动生成UUID
        final json = {
          'userName': 'John Doe',
        };

        final model = ContactModel.fromJson(json);

        // 验证生成的UUID是否有效
        expect(model.id, isNotEmpty);
        expect(model.id.length, 36);
      });
    });

    // 日期时间处理测试组
    group('DateTime Handling', () {
      test('fromJson should handle invalid createdTime format', () {
        // 测试处理无效的日期格式
        final json = {
          'id': 'abc123',
          'createdTime': 'invalid-date-format',
        };

        final model = ContactModel.fromJson(json);

        // 验证无效日期是否被正确处理为null
        expect(model.createdTime, null);
      });

      test('toJson should handle null createdTime', () {
        // 测试处理null日期时间
        final model = ContactModel(
          id: 'abc123',
          userName: 'John Doe',
          avatarUrl: '',
          lastMessage: '',
          createdTime: null,
          isArchived: false,
        );

        final json = model.toJson();

        // 验证null日期时间是否被转换为空字符串
        expect(json['createdTime'], '');
      });
    });
  });
}