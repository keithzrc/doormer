import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/presentation/widgets/message_bubble.dart';

void main() {
  Widget createWidgetUnderTest(Message message) {
    return MaterialApp(
      home: Scaffold(
        body: MessageBubble(message: message),
      ),
    );
  }

  group('MessageBubble', () {
    testWidgets('renders text message correctly', (tester) async {
      final message = Message(
        id: '1',
        content: 'Hello',
        timestamp: DateTime.now(),
        isFromMe: true,
        type: MessageType.text,
      );

      await tester.pumpWidget(createWidgetUnderTest(message));

      expect(find.text('Hello'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('renders emoji message with larger font', (tester) async {
      final message = Message(
        id: '1',
        content: '😊',
        timestamp: DateTime.now(),
        isFromMe: false,
        type: MessageType.emoji,
      );

      await tester.pumpWidget(createWidgetUnderTest(message));

      final textWidget = tester.widget<Text>(find.text('😊'));
      expect(textWidget.style?.fontSize, 24);
    });
  });
} 