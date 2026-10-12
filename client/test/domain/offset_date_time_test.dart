import 'package:driver_diary/domain/models/offset_date_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parse', () {
    test('сохраняет смещение +05:00 и момент времени', () {
      final value = OffsetDateTime.parse('2026-10-01T08:10:00+05:00');

      expect(value.offset, const Duration(hours: 5));
      expect(value.instant, DateTime.utc(2026, 10, 1, 3, 10));
      expect(value.wallClock.hour, 8);
    });

    test('понимает Z как нулевое смещение', () {
      final value = OffsetDateTime.parse('2026-10-01T08:10:00Z');

      expect(value.offset, Duration.zero);
      expect(value.instant, DateTime.utc(2026, 10, 1, 8, 10));
    });

    test('понимает отрицательные и неполночасовые смещения', () {
      final value = OffsetDateTime.parse('2026-10-01T08:10:00-03:30');

      expect(value.offset, -const Duration(hours: 3, minutes: 30));
      expect(value.instant, DateTime.utc(2026, 10, 1, 11, 40));
    });

    test('понимает смещение без двоеточия и дробные секунды', () {
      final value = OffsetDateTime.parse('2026-10-01T08:10:00.123456+0500');

      expect(value.offset, const Duration(hours: 5));
    });

    test('значение без смещения — ошибка формата', () {
      expect(
        () => OffsetDateTime.parse('2026-10-01T08:10:00'),
        throwsFormatException,
      );
    });
  });

  group('toIso8601', () {
    test('возвращает исходную запись со смещением', () {
      for (final iso in [
        '2026-10-01T08:10:00+05:00',
        '2026-10-01T23:59:00-03:30',
        '2026-10-01T00:00:00+00:00',
      ]) {
        expect(OffsetDateTime.parse(iso).toIso8601(), iso);
      }
    });

    test('Z превращается в +00:00', () {
      expect(
        OffsetDateTime.parse('2026-10-01T08:10:00Z').toIso8601(),
        '2026-10-01T08:10:00+00:00',
      );
    });

    test('день берётся по смещению, а не по UTC', () {
      // 00:30 по +05:00 — это 19:30 UTC предыдущего дня.
      final value = OffsetDateTime.parse('2026-10-02T00:30:00+05:00');

      expect(value.instant.day, 1);
      expect(value.toIso8601(), startsWith('2026-10-02T00:30'));
      expect(value.wallDate, DateTime(2026, 10, 2));
    });
  });

  test('fromLocal берёт смещение устройства', () {
    final local = DateTime(2026, 10, 1, 8, 10);

    final value = OffsetDateTime.fromLocal(local);

    expect(value.offset, local.timeZoneOffset);
    expect(value.instant, local.toUtc());
    expect(value.wallClock.hour, 8);
  });

  test('значения с одним моментом и смещением равны', () {
    expect(
      OffsetDateTime.parse('2026-10-01T08:10:00+05:00'),
      OffsetDateTime.parse('2026-10-01T08:10:00+05:00'),
    );
  });
}
