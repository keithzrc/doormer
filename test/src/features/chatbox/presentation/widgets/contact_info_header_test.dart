import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/features/chatbox/presentation/widgets/contact_info_header.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';

void main() {
  late ContactInfo contactInfo;

  setUp(() {
    contactInfo = ContactInfo(
      id: const UuidValueConverter().fromJson('123e4567-e89b-12d3-a456-426614174000'),
      name: 'John Doe',
      avatarUrl: 'https://example.com/avatar.jpg',
      position: 'Software Engineer',
      expectedSalary: '100k',
      status: 'online',
    );
  });

  Widget createWidgetUnderTest({
    required ContactInfo contactInfo,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        body: ContactInfoHeader(
          contactInfo: contactInfo,
          onTap: onTap,
        ),
      ),
    );
  }

  group('ContactInfoHeader', () {
    testWidgets('displays basic contact information correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(contactInfo: contactInfo));

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Software Engineer'), findsOneWidget);
      expect(find.text('100k'), findsOneWidget);
    });

    testWidgets('handles avatar display correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(contactInfo: contactInfo));

      final avatar = find.byType(CircleAvatar);
      expect(avatar, findsOneWidget);

      final CircleAvatar avatarWidget = tester.widget(avatar);
      expect(
        avatarWidget.backgroundImage,
        isA<NetworkImage>().having(
          (image) => image.url,
          'url',
          'https://example.com/avatar.jpg',
        ),
      );
    });

    testWidgets('shows default avatar when URL is empty', (tester) async {
      final contactInfoNoAvatar = contactInfo.copyWith(avatarUrl: '');
      await tester.pumpWidget(createWidgetUnderTest(contactInfo: contactInfoNoAvatar));

      final avatar = find.byType(CircleAvatar);
      final CircleAvatar avatarWidget = tester.widget(avatar);
      expect(avatarWidget.backgroundImage, isA<AssetImage>());
    });

    testWidgets('shows correct status indicator color', (tester) async {
      final statuses = {
        'online': Colors.green,
        'away': Colors.orange,
        'busy': Colors.red,
        'offline': Colors.grey,
      };

      for (final status in statuses.entries) {
        final contactWithStatus = contactInfo.copyWith(status: status.key);
        await tester.pumpWidget(createWidgetUnderTest(contactInfo: contactWithStatus));

        final statusIndicator = find.byType(Container).last;
        final Container container = tester.widget(statusIndicator);
        final BoxDecoration decoration = container.decoration as BoxDecoration;
        
        expect(decoration.color, status.value);
      }
    });

    testWidgets('handles onTap callback', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        createWidgetUnderTest(
          contactInfo: contactInfo,
          onTap: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(wasTapped, isTrue);
    });

    testWidgets('handles long text with ellipsis', (tester) async {
      final contactWithLongText = contactInfo.copyWith(
        name: 'Very Long Name That Should Be Truncated',
        position: 'Very Long Position Title That Should Also Be Truncated',
      );

      await tester.pumpWidget(createWidgetUnderTest(contactInfo: contactWithLongText));

      final nameFinder = find.text('Very Long Name That Should Be Truncated');
      final nameText = tester.widget<Text>(nameFinder);
      expect(nameText.maxLines, 1);
      expect(nameText.overflow, TextOverflow.ellipsis);

      final positionFinder = find.text('Very Long Position Title That Should Also Be Truncated');
      final positionText = tester.widget<Text>(positionFinder);
      expect(positionText.maxLines, 1);
      expect(positionText.overflow, TextOverflow.ellipsis);
    });
  });
} 