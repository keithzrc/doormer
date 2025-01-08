import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late Contact testContact;

  setUp(() {
    testContact = Contact(
      id: UuidValue(const Uuid().v4()),
      userName: 'Test User',
      avatarUrl: '',
      lastMessage: 'Hello World',
      lastMessageCreatedTime: DateTime(2024, 1, 1),
      isArchived: false,
      isRead: true,
    );
  });

  Widget createWidgetUnderTest({Contact? contact, VoidCallback? onTap}) {
    return MaterialApp(
      home: Material(
        child: Scaffold(
          body: ChatCard(
            chat: contact ?? testContact,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  group('ChatCard', () {
    testWidgets('should display user information correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('should show first letter when no avatar URL', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('T'), findsOneWidget);
    });

    testWidgets('should show question mark for empty username and no avatar', (tester) async {
      final emptyContact = testContact.copyWith(
        avatarUrl: '',
        userName: '',
      );
      await tester.pumpWidget(createWidgetUnderTest(contact: emptyContact));
      await tester.pump();

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('should show unread indicator when message is unread', (tester) async {
      final unreadContact = testContact.copyWith(isRead: false);
      await tester.pumpWidget(createWidgetUnderTest(contact: unreadContact));
      await tester.pump();

      final unreadIndicator = find.byWidgetPredicate(
        (widget) => widget is Container && 
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == Colors.red &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(unreadIndicator, findsOneWidget);
    });

    testWidgets('should not show unread indicator when message is read', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final unreadIndicator = find.byWidgetPredicate(
        (widget) => widget is Container && 
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == Colors.red,
      );
      expect(unreadIndicator, findsNothing);
    });

    testWidgets('should handle tap callback', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(createWidgetUnderTest(
        onTap: () => wasTapped = true,
      ));
      await tester.pump();

      await tester.tap(find.byType(ListTile));
      await tester.pump();
      
      expect(wasTapped, isTrue);
    });

    testWidgets('should have correct card styling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, equals(const EdgeInsets.symmetric(vertical: 8.0)));
      expect(card.elevation, equals(2));
      
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, equals(BorderRadius.circular(15.0)));
    });

    testWidgets('should handle text overflow correctly', (tester) async {
      final longTextContact = testContact.copyWith(
        userName: 'A' * 100,
        lastMessage: 'B' * 100,
      );
      await tester.pumpWidget(createWidgetUnderTest(contact: longTextContact));
      await tester.pump();

      final titleFinder = find.text('A' * 100);
      final subtitleFinder = find.text('B' * 100);
      
      expect(titleFinder, findsOneWidget);
      expect(subtitleFinder, findsOneWidget);
      
      final title = tester.widget<Text>(titleFinder);
      final subtitle = tester.widget<Text>(subtitleFinder);
      
      expect(title.overflow, equals(TextOverflow.ellipsis));
      expect(subtitle.overflow, equals(TextOverflow.ellipsis));
    });
  });
}
