import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';

void main() {
  final mockChat = Contact(
    id: '1',
    userName: 'Username',
    avatarUrl: '',
    lastMessage: 'This is a test mock message',
    createdTime: DateTime(2024, 3, 15, 14, 30),
    isArchived: true,
    isRead: true,
  );

  testWidgets('ChatCard displays correct user information',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatCard(chat: mockChat),
        ),
      ),
    );

    // Verify username is displayed
    expect(find.text('Username'), findsOneWidget);
    // Verify the last message is displayed - matches mockChat
    expect(find.text('This is a test mock message'), findsOneWidget);
    // Verify time is displayed - matches format
    expect(find.text('14:30'), findsOneWidget);
    // Verify CircleAvatar exists
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('ChatCard tap callback works correctly',
      (WidgetTester tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatCard(
            chat: mockChat,
            onTap: () => wasTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ListTile));
    expect(wasTapped, true);
  });

  testWidgets('ChatCard style verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatCard(chat: mockChat),
        ),
      ),
    );

    // Verify Card widget exists
    final cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);

    // Verify ListTile exists
    expect(find.byType(ListTile), findsOneWidget);

    // Verify text styles
    final titleFinder = find.text('Username');
    final Text titleWidget = tester.widget(titleFinder);
    expect(titleWidget.style?.fontWeight, FontWeight.bold);
    expect(titleWidget.style?.fontSize, 16);

    final subtitleFinder = find.text('This is a test mock message');
    final Text subtitleWidget = tester.widget(subtitleFinder);
    expect(subtitleWidget.style?.color, Colors.grey);
    expect(subtitleWidget.style?.fontSize, 14);
  });
}
