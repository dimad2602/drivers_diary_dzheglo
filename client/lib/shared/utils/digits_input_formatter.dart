import 'dart:math';

import 'package:flutter/services.dart';

/// Ввод целого числа для денежных полей. Допустимы только цифры (пробелы-разделители
/// разрядов убираются), ведущие нули срезаются.
///
/// Недопустимую правку формат **отклоняет целиком**, а не вырезает лишнее: иначе вставка
/// «2400,50» молча стала бы 240050 (в 100 раз больше), а длинное число — обрезанным.
class DigitsInputFormatter extends TextInputFormatter {
  const DigitsInputFormatter({this.maxLength = 9});

  /// Максимум цифр; длиннее — правка отклоняется.
  final int maxLength;

  static final _forbidden = RegExp(r'[^0-9\s]');
  static final _whitespace = RegExp(r'\s');
  static final _leadingZeros = RegExp(r'^0+(?=\d)');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (_forbidden.hasMatch(text)) return oldValue;

    final digits = text.replaceAll(_whitespace, '');
    if (digits.length > maxLength) return oldValue;

    final cleaned = digits.replaceFirst(_leadingZeros, '');
    // Курсор остаётся после тех же цифр, что и до очистки.
    final caret = newValue.selection.extentOffset;
    final digitsBeforeCaret = caret < 0
        ? cleaned.length
        : text
                  .substring(0, min(caret, text.length))
                  .replaceAll(_whitespace, '')
                  .length -
              (digits.length - cleaned.length);
    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(
        offset: digitsBeforeCaret.clamp(0, cleaned.length),
      ),
    );
  }
}
