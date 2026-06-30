import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color brown = Color(0xFF5D4037);
    const Color lightBrown = Color(0xFFD7B98E);
    const Color orange = Color(0xFFE59A45);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: brown, fontSize: 14),
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightBrown),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: orange, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      style: const TextStyle(color: brown, fontSize: 14),
      validator: validator,
    );
  }
}
