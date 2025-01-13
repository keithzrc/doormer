import 'package:doormer/src/features/chat/presentation/pages/chatlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatlistPage', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatlistPage(),
        ),
      );

      expect(find.text('Chatlist Page'), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should maintain center alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatlistPage(),
          ),
        ),
      );

      final centerFinder = find.byType(Center);
      expect(centerFinder, findsOneWidget);
      
      final Center center = tester.widget(centerFinder);
      expect(center.child, isA<Text>());
    });
  });
} 