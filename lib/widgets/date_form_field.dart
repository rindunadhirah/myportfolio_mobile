import 'package:material_ui/material_ui.dart';

/// A read-only form field that opens a date picker when selected.
class DateFormField extends StatelessWidget {
  const DateFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.onTap,
    this.fieldKey,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final VoidCallback onTap;
  final Key? fieldKey;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      readOnly: true,
      enabled: enabled,
      onTap: enabled ? onTap : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
