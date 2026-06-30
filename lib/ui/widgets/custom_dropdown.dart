import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String labelText;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color brown = Color(0xFF5D4037);
    const Color lightBrown = Color(0xFFD7B98E);
    const Color orange = Color(0xFFE59A45);

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      style: const TextStyle(color: brown, fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: brown, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightBrown),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: orange, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    );
  }
}
