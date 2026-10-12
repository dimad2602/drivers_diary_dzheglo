import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:driver_diary/shared/utils/duration_formatter.dart';
import 'package:driver_diary/shared/utils/money_formatter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
    await initializeDateFormatting('en');
  });

  group('formatMoney', () {
    test('ru: разряды разделены неразрывным пробелом, после суммы ₸', () {
      expect(formatMoney(3315, 'ru'), '3 315 ₸');
      expect(formatMoney(0, 'ru'), '0 ₸');
      expect(formatMoney(1250000, 'ru'), '1 250 000 ₸');
    });

    test('en: разряды через запятую', () {
      expect(formatMoney(3315, 'en'), '3,315 ₸');
    });

    test('отрицательная сумма — с настоящим минусом', () {
      expect(formatMoney(-585, 'ru'), '−585 ₸');
    });
  });

  group('даты', () {
    test('dateOnly отбрасывает время', () {
      expect(
        dateOnly(DateTime(2026, 10, 1, 23, 59, 30)),
        DateTime(2026, 10, 1),
      );
    });

    test('isSameDay сравнивает только дату', () {
      expect(
        isSameDay(DateTime(2026, 10, 1, 0, 1), DateTime(2026, 10, 1, 23, 59)),
        isTrue,
      );
      expect(isSameDay(DateTime(2026, 10, 1), DateTime(2026, 10, 2)), isFalse);
      expect(isSameDay(DateTime(2026, 10, 1), DateTime(2025, 10, 1)), isFalse);
    });

    test('formatTime — 24-часовой формат', () {
      final wall = DateTime.utc(2026, 10, 1, 8, 5);

      expect(formatTime(wall, 'ru'), '08:05');
      expect(formatTime(wall, 'en'), '08:05');
      expect(formatTime(DateTime.utc(2026, 10, 1, 18, 40), 'en'), '18:40');
    });

    test('formatWeekday — с заглавной буквы', () {
      final thursday = DateTime(2026, 10, 1);

      expect(formatWeekday(thursday, 'ru'), 'Четверг');
      expect(formatWeekday(thursday, 'en'), 'Thursday');
    });

    test('formatFullDate учитывает язык', () {
      final date = DateTime(2026, 10, 1);

      expect(formatFullDate(date, 'ru'), contains('октября'));
      expect(formatFullDate(date, 'en'), 'October 1, 2026');
    });
  });

  group('formatDuration', () {
    // S берёт язык из Intl.defaultLocale в момент вызова, поэтому язык задаём в каждом тесте.
    Future<S> l10n(String code) => S.load(Locale(code));

    test('минуты', () async {
      expect(
        formatDuration(await l10n('ru'), const Duration(minutes: 22)),
        '22 мин',
      );
      expect(
        formatDuration(await l10n('en'), const Duration(minutes: 22)),
        '22 min',
      );
    });

    test('ровно часы', () async {
      expect(formatDuration(await l10n('ru'), const Duration(hours: 2)), '2 ч');
    });

    test('часы и минуты с ведущим нулём', () async {
      const duration = Duration(hours: 1, minutes: 5);

      expect(formatDuration(await l10n('ru'), duration), '1 ч 05 мин');
      expect(formatDuration(await l10n('en'), duration), '1 h 05 min');
    });

    test('короче минуты показывается как одна минута', () async {
      expect(
        formatDuration(await l10n('ru'), const Duration(seconds: 20)),
        '1 мин',
      );
    });
  });
}
