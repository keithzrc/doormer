import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';


void main() {
  final mockChat = Chat(
    id: '1',
    userName: '用户名',
    avatarUrl: '',
    lastMessage: '这是测试的mock数据',
    createdTime: DateTime(2024, 3, 15, 14, 30), 
    isArchived: true,
  );

  testWidgets('ChatCard 显示正确的用户信息', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatCard(chat: mockChat),
        ),
      ),
    );

    // 验证用户名显示
    expect(find.text('用户名'), findsOneWidget);
    // 验证最后消息显示 - 修改为匹配 mockChat 中的实际消息
    expect(find.text('这是测试的mock数据'), findsOneWidget);
    // 验证时间显示 - 确保时间格式与实际显示匹配
    expect(find.text('14:30'), findsOneWidget);
    // 验证头像组件存在
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('ChatCard 点击回调正常工作', (WidgetTester tester) async {
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

  testWidgets('ChatCard 样式验证', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatCard(chat: mockChat),
        ),
      ),
    );

    // 验证Card组件存在
    final cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);

    // 验证ListTile存在
    expect(find.byType(ListTile), findsOneWidget);

    // 验证文本样式
    final titleFinder = find.text('用户名');
    final Text titleWidget = tester.widget(titleFinder);
    expect(titleWidget.style?.fontWeight, FontWeight.bold);
    expect(titleWidget.style?.fontSize, 16);

    final subtitleFinder = find.text('这是测试的mock数据');
    final Text subtitleWidget = tester.widget(subtitleFinder);
    expect(subtitleWidget.style?.color, Colors.grey);
    expect(subtitleWidget.style?.fontSize, 14);
  });
}