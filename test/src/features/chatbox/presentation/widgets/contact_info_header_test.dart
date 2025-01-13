import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/features/chatbox/presentation/widgets/contact_info_header.dart';
import 'package:uuid/uuid.dart';

void main() {
  late ContactInfo contactInfo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // 处理网络图片错误
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return const SizedBox.shrink();
    };

    contactInfo = ContactInfo(
      id: UuidValue(const Uuid().v4()),
      name: 'John Doe',
      position: 'Software Engineer',
      expectedSalary: '100k',
      status: 'Active',
      avatarUrl: '',
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: ContactInfoHeader(
          contact: contactInfo,
        ),
      ),
    );
  }

  group('ContactInfoHeader', () {
    testWidgets('displays contact information', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Software Engineer'), findsOneWidget);
      expect(find.text('Expected: 100k'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows correct text for missing fields', (tester) async {
      contactInfo = ContactInfo(
        id: UuidValue(const Uuid().v4()),
        name: 'John Doe',
        status: 'Active',
        avatarUrl: '',
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // 检查职位显示
      expect(find.text('Not Available'), findsOneWidget);
      // 检查期望薪资显示
      expect(find.text('Expected: Not Available'), findsOneWidget);
    });

    testWidgets('shows orange color for non-active status', (tester) async {
      contactInfo = ContactInfo(
        id: UuidValue(const Uuid().v4()),
        name: 'John Doe',
        status: 'Away',
        avatarUrl: '',
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final statusContainer = find.byType(Container).last;
      final Container container = tester.widget(statusContainer);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      
      // 只测试是否使用了橙色（不测试透明度）
      expect(
        (decoration.color as Color).withAlpha(255), 
        Colors.orange.withAlpha(26)
      );
    });
  });
} 