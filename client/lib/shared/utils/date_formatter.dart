import 'package:intl/intl.dart';

/// Только дата, без времени суток.
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// `08:10` — 24-часовой формат, как в ru, так и в en.
String formatTime(DateTime wallClock, String locale) =>
    DateFormat.Hm(locale).format(wallClock);

/// `1 октября 2026 г.` / `October 1, 2026`.
String formatFullDate(DateTime date, String locale) =>
    DateFormat.yMMMMd(locale).format(date);

/// Название дня недели с заглавной буквы: `Четверг` / `Thursday`.
String formatWeekday(DateTime date, String locale) {
  final name = DateFormat.EEEE(locale).format(date);
  return name.isEmpty ? name : name[0].toUpperCase() + name.substring(1);
}
