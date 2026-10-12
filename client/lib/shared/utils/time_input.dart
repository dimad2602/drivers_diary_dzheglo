import 'package:flutter/services.dart'
    show TextEditingValue, TextInputFormatter, TextSelection;
import 'package:flutter/material.dart' show TimeOfDay;

/// `09:05` — время для полей ввода и диалога выбора.
String formatTimeText(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

final _clockTime = RegExp(r'^([01]?\d|2[0-3]):([0-5]\d)$');

/// Разбирает `ЧЧ:ММ` строго: часы 0–23, минуты ровно из двух цифр 00–59.
/// Всё остальное (в том числе `25:00`, `9:5`, буквы) — `null`.
TimeOfDay? parseClockTime(String text) {
  final match = _clockTime.firstMatch(text.trim());
  if (match == null) return null;
  return TimeOfDay(
    hour: int.parse(match.group(1)!),
    minute: int.parse(match.group(2)!),
  );
}

/// Маска `ЧЧ:ММ`: принимает только цифры и двоеточие, сама ставит двоеточие,
/// не даёт набрать заведомо невозможное время (час больше 23, минуты больше 59).
/// Недопустимая правка отклоняется целиком.
class TimeInputFormatter extends TextInputFormatter {
  const TimeInputFormatter();

  static final _forbidden = RegExp(r'[^0-9:\s]');
  static final _whitespace = RegExp(r'\s');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text;
    if (_forbidden.hasMatch(raw)) return oldValue;

    final compact = raw.replaceAll(_whitespace, '');
    if (compact.isEmpty) return _result('');
    if (compact.startsWith(':') || ':'.allMatches(compact).length > 1) {
      return oldValue;
    }

    final String hour;
    final String minutes;
    final bool showColon;
    if (compact.contains(':')) {
      // «9:30» → «09:30»: двоеточие после одной цифры значит «час из одной цифры».
      final parts = compact.split(':');
      if (parts[0].length > 2 || parts[1].length > 2) return oldValue;
      hour = parts[0].length == 1 ? '0${parts[0]}' : parts[0];
      minutes = parts[1];
      showColon = true;
    } else {
      if (compact.length > 4) return oldValue;
      if (compact.codeUnitAt(0) > '2'.codeUnitAt(0)) {
        // Первая цифра 3–9 не может начинать двузначный час: «9» → «09:».
        hour = '0${compact[0]}';
        minutes = compact.substring(1);
        showColon = true;
      } else {
        hour = compact.length >= 2 ? compact.substring(0, 2) : compact;
        minutes = compact.length > 2 ? compact.substring(2) : '';
        showColon = minutes.isNotEmpty;
      }
      if (minutes.length > 2) return oldValue;
    }

    if (hour.length == 2 && int.parse(hour) > 23) return oldValue;
    if (minutes.isNotEmpty && minutes.codeUnitAt(0) > '5'.codeUnitAt(0)) {
      return oldValue;
    }
    return _result(showColon ? '$hour:$minutes' : hour);
  }

  TextEditingValue _result(String text) => TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );
}
