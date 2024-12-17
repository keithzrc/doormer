import 'package:flutter/material.dart';

class EmojiPicker extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const EmojiPicker({
    Key? key,
    required this.onEmojiSelected,
  }) : super(key: key);

  static const List<String> _emojis = [
    '😀',
    '😂',
    '😊',
    '😍',
    '🤔',
    '😎',
    '👍',
    '❤️'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: _emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onEmojiSelected(_emojis[index]),
            child: Center(
              child: Text(
                _emojis[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }
}
