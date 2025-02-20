import 'package:flutter/material.dart';

class ProfileDropdownMenu extends StatelessWidget {
  /// The label for the dropdown field.
  final String label;

  /// The list of options to be displayed in the dropdown.
  final List<String> options;

  /// The current value of the dropdown (can be null if nothing is selected).
  final String? currentValue;

  /// Callback triggered when a new value is selected.
  final ValueChanged<String?> onChanged;

  /// validator for form usage.
  final FormFieldValidator<String>? validator;

  /// hint text shown when no value is selected.
  final String? hintText;

  /// flag to control whether the dropdown is expanded.
  final bool isExpanded;

  const ProfileDropdownMenu({
    super.key,
    required this.label,
    required this.options,
    required this.currentValue,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
      ),
      value: currentValue,
      isExpanded: isExpanded,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
