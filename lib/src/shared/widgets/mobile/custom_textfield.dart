import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
