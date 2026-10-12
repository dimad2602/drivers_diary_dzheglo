part of 'diary_bloc.dart';

@freezed
sealed class DiaryEvent with _$DiaryEvent {
  /// Первая загрузка выбранного дня (сегодня).
  const factory DiaryEvent.started() = _DiaryStarted;

  /// Загрузка текущего дня со спиннером: повтор после ошибки, кнопка «Обновить».
  const factory DiaryEvent.reloadRequested() = _DiaryReloadRequested;

  const factory DiaryEvent.dateSelected(DateTime date) = _DiaryDateSelected;

  const factory DiaryEvent.previousDayRequested() = _DiaryPreviousDayRequested;

  const factory DiaryEvent.nextDayRequested() = _DiaryNextDayRequested;

  const factory DiaryEvent.todayRequested() = _DiaryTodayRequested;

  /// Тихое обновление без сброса экрана (pull-to-refresh). [completer]
  /// завершается, когда обновление закончено, — по нему гаснет индикатор.
  const factory DiaryEvent.refreshRequested({Completer<void>? completer}) =
      _DiaryRefreshRequested;
}
