import 'package:driver_diary/shared/storage/constants.dart';
import 'package:intl/intl.dart';

/// `3315` → `3 315 ₸` (разделитель разрядов зависит от языка). Отрицательные значения
/// выводятся с настоящим минусом `−`, а не дефисом.
String formatMoney(int amount, String locale) {
  final digits = NumberFormat.decimalPattern(locale).format(amount.abs());
  final sign = amount < 0 ? '−' : '';
  // Неразрывный пробел: сумма и знак валюты не переносятся на разные строки.
  return '$sign$digits\u00A0${Constants.currencySymbol}';
}
