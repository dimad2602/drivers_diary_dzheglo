import 'package:freezed_annotation/freezed_annotation.dart';

part 'offset_date_time.freezed.dart';

/// Момент времени вместе со смещением часового пояса, в котором он записан.
///
/// Dart-овский [DateTime] хранит либо UTC, либо зону устройства, поэтому смещение
/// `+05:00` из API терялось бы, а по нему сервер определяет день поездки.
@freezed
abstract class OffsetDateTime with _$OffsetDateTime {
  /// [instant] должен быть в UTC.
  const factory OffsetDateTime({
    required DateTime instant,
    required Duration offset,
  }) = _OffsetDateTime;

  const OffsetDateTime._();

  /// Локальное время устройства вместе с его текущим смещением.
  factory OffsetDateTime.fromLocal(DateTime local) =>
      OffsetDateTime(instant: local.toUtc(), offset: local.timeZoneOffset);

  /// Разбирает ISO 8601 со смещением (`2026-10-01T08:10:00+05:00` или `...Z`).
  factory OffsetDateTime.parse(String iso) {
    final match = _offsetSuffix.firstMatch(iso);
    if (match == null) {
      throw FormatException('В значении нет смещения часового пояса', iso);
    }
    final Duration offset;
    if (match.group(1) == 'Z') {
      offset = Duration.zero;
    } else {
      final magnitude = Duration(
        hours: int.parse(match.group(3)!),
        minutes: int.parse(match.group(4)!),
      );
      offset = match.group(2) == '-' ? -magnitude : magnitude;
    }
    return OffsetDateTime(instant: DateTime.parse(iso).toUtc(), offset: offset);
  }

  static final _offsetSuffix = RegExp(r'(Z|([+-])(\d{2}):?(\d{2}))$');

  /// «Настенное» время в поясе значения. Флаг UTC у результата условный:
  /// нужны только поля год/месяц/день/час/минута.
  DateTime get wallClock => instant.add(offset);

  /// Дата без времени в поясе значения.
  DateTime get wallDate =>
      DateTime(wallClock.year, wallClock.month, wallClock.day);

  /// ISO 8601 с исходным смещением, как его ждёт API.
  String toIso8601() {
    String two(int v) => v.toString().padLeft(2, '0');
    final w = wallClock;
    final absolute = offset.abs();
    final sign = offset.isNegative ? '-' : '+';
    return '${w.year.toString().padLeft(4, '0')}-${two(w.month)}-${two(w.day)}'
        'T${two(w.hour)}:${two(w.minute)}:${two(w.second)}'
        '$sign${two(absolute.inHours)}:${two(absolute.inMinutes.remainder(60))}';
  }
}
