import 'package:doormer/src/core/theme/app_colors.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.validator,
    super.key,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;

  void _validate() {
    setState(() {
      _errorText = widget.validator?.call(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            errorText: _errorText, // Display custom error message
          ),
          onChanged: (value) => _validate(), // Revalidate on input change
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _errorText!,
              style: TextStyle(
                  color: AppColors.error,
                  fontSize: AppTextStyles.bodySmall.fontSize),
            ),
          ),
      ],
    );
  }
}
