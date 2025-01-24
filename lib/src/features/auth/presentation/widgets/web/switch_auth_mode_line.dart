import 'package:flutter/material.dart';

class SwitchAuthModeLine extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onPressed;

  const SwitchAuthModeLine({
    Key? key,
    required this.text,
    required this.actionText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: onPressed,
          child: Text(actionText),
        ),
      ],
    );
  }
}
