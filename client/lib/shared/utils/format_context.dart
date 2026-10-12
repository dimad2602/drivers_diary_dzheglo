import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:driver_diary/shared/utils/money_formatter.dart';
import 'package:flutter/widgets.dart';

/// Форматтеры с языком текущего контекста.
extension FormatContext on BuildContext {
  String get localeTag => Localizations.localeOf(this).toLanguageTag();

  String money(int amount) => formatMoney(amount, localeTag);

  String time(DateTime wallClock) => formatTime(wallClock, localeTag);

  String fullDate(DateTime date) => formatFullDate(date, localeTag);

  String weekday(DateTime date) => formatWeekday(date, localeTag);
}
