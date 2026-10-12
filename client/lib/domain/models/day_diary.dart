import 'package:driver_diary/domain/models/day_summary.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_diary.freezed.dart';

/// Всё, что показывает экран дня: сводка и список поездок.
@freezed
abstract class DayDiary with _$DayDiary {
  const factory DayDiary({
    required DaySummary summary,
    required List<Trip> trips,
  }) = _DayDiary;
}
