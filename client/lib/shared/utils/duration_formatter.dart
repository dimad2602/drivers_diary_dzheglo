import 'dart:math';

import 'package:driver_diary/generated/l10n.dart';

/// `22 мин`, `1 ч`, `1 ч 05 мин`. Поездка короче минуты показывается как «1 мин».
String formatDuration(S l10n, Duration duration) {
  final totalMinutes = max(1, duration.inMinutes);
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours == 0) return l10n.durationMinutes(minutes);
  if (minutes == 0) return l10n.durationHours(hours);
  return l10n.durationHoursMinutes(hours, minutes.toString().padLeft(2, '0'));
}
