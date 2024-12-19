import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';

void main() {
  final mockChat = Contact(
    id: '1',
    userName: 'Username',
    avatarUrl: '',
    lastMessage: 'This is a test mock message',
    lastMessageCreatedTime: DateTime(2024, 3, 15, 14, 30),
    isArchived: true,
    isRead: false,
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

    // Verify leading CircleAvatar exists
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Verify red dot exists for unread messages
    final redDotFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == Colors.red &&
          (widget.decoration as BoxDecoration).shape == BoxShape.circle,
    );
    expect(redDotFinder, findsOneWidget);

    // Verify title text styles
    final titleFinder = find.text('Username');
    final Text titleWidget = tester.widget(titleFinder);
    expect(titleWidget.style?.fontWeight, AppTextStyles.bodyLarge.fontWeight);
    expect(titleWidget.style?.fontSize, AppTextStyles.bodyLarge.fontSize);

    // Verify subtitle text styles
    final subtitleFinder = find.text('This is a test mock message');
    final Text subtitleWidget = tester.widget(subtitleFinder);
    expect(subtitleWidget.style?.color, AppTextStyles.bodyMedium.color);
    expect(subtitleWidget.style?.fontSize, AppTextStyles.bodyMedium.fontSize);

    // Verify trailing time format
    final trailingFinder = find.text('14:30');
    expect(trailingFinder, findsOneWidget);
    final Text trailingWidget = tester.widget(trailingFinder);
    expect(trailingWidget.style?.fontSize, AppTextStyles.bodySmall.fontSize);
  });
}
