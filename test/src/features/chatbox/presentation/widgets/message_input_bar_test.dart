import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/presentation/widgets/message_input_bar.dart';

void main() {
  group('MessageInputBar', () {
    testWidgets('renders input field and buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageInputBar(
              onSendMessage: (_, __) {},
              onSendFile: (_, __) {},
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.attach_file), findsOneWidget);
      expect(find.byIcon(Icons.image), findsOneWidget);
      expect(find.byIcon(Icons.emoji_emotions), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('can type and send message', (tester) async {
      String? sentMessage;
      MessageType? messageType;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageInputBar(
              onSendMessage: (message, type) {
                sentMessage = message;
                messageType = type;
              },
              onSendFile: (_, __) {},
            ),
          ),
        ),
      );

      // 输入文本
      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      // 触发发送按钮
      final sendButton = find.byIcon(Icons.send);
      expect(sendButton, findsOneWidget);
      await tester.tap(sendButton);
      await tester.pump();

      // 验证回调被调用
      expect(sentMessage, 'Hello');
      expect(messageType, MessageType.text);
      
      // 验证发送后输入框被清空
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
  });
} 