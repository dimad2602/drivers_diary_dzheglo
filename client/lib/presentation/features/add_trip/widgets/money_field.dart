import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/ui/app_text_field.dart';
import 'package:driver_diary/shared/utils/digits_input_formatter.dart';
import 'package:flutter/material.dart';

/// Поле суммы: только цифры (целые числа), знак валюты справа. Недопустимый ввод
/// отклоняется целиком, а не «исправляется» (см. [DigitsInputFormatter]).
class MoneyField extends StatelessWidget {
  const MoneyField({
    required this.controller,
    required this.label,
    required this.onChanged,
    this.errorText,
    this.helperText,
    this.hint,
    this.textInputAction,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextInputAction? textInputAction;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      errorText: errorText,
      helperText: helperText,
      suffixText: Constants.currencySymbol,
      keyboardType: TextInputType.number,
      inputFormatters: const [DigitsInputFormatter()],
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
