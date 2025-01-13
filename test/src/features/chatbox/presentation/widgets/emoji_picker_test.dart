import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/presentation/widgets/emoji_picker.dart';

void main() {
  testWidgets('renders emoji grid', (tester) async {
    bool emojiSelected = false;
    String selectedEmoji = '';

    await tester.pumpWidget(
      MaterialApp(
        home: EmojiPicker(
          onEmojiSelected: (emoji) {
            emojiSelected = true;
            selectedEmoji = emoji;
          },
        ),
      ),
    );

    // 验证渲染了 GridView
    expect(find.byType(GridView), findsOneWidget);

    // 验证至少渲染了一个表情
    expect(find.byType(GestureDetector), findsWidgets);
    
    // 点击第一个表情
    await tester.tap(find.byType(GestureDetector).first);
    
    // 验证回调被调用
    expect(emojiSelected, true);
    expect(selectedEmoji.isNotEmpty, true);
  });
} 