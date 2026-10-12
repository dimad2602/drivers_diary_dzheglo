part of 'diary_bloc.dart';

@freezed
sealed class DiaryState with _$DiaryState {
  /// Выбранный день (только дата) есть у каждого состояния.
  const factory DiaryState.loading({required DateTime date}) = _DiaryLoading;

  const factory DiaryState.success({
    required DateTime date,
    required DayDiary diary,
    // Тихое обновление уже идёт, данные дня на экране прежние.
    @Default(false) bool isRefreshing,
    // Transient; surfaced as snackbar, данные дня сохраняются.
    TripsError? lastError,
  }) = _DiarySuccess;

  const factory DiaryState.failure({
    required DateTime date,
    required TripsError error,
  }) = _DiaryFailure;
}
