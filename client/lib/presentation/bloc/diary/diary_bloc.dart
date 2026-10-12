import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/domain/repositories/i_trips_repo.dart';
import 'package:driver_diary/shared/models/result.dart';
import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_event.dart';
part 'diary_state.dart';
part 'diary_bloc.freezed.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final ITripsRepo _repo;

  /// Подменяется в тестах, чтобы «сегодня» было предсказуемым.
  final DateTime Function() _clock;

  DiaryBloc(ITripsRepo repo, {DateTime Function()? clock})
    : _repo = repo,
      _clock = clock ?? DateTime.now,
      super(DiaryState.loading(date: dateOnly((clock ?? DateTime.now)()))) {
    on<DiaryEvent>(
      (event, emit) async {
        await event.map(
          started: (_) => _load(state.date, emit),
          reloadRequested: (_) => _load(state.date, emit),
          dateSelected: (e) => _load(dateOnly(e.date), emit),
          previousDayRequested: (_) => _load(_shiftedDay(-1), emit),
          nextDayRequested: (_) => _onNextDay(emit),
          todayRequested: (_) => _load(today, emit),
          refreshRequested: (e) => _onRefresh(e, emit),
        );
      },
      // Действие пользователя отменяет предыдущее: ответ на устаревший запрос
      // (например, за день, с которого уже ушли) не попадёт в состояние.
      transformer: restartable(),
    );
  }

  DateTime get today => dateOnly(_clock());

  /// В будущее перелистывать нельзя: поездки ещё не случились.
  bool get canGoNext => state.date.isBefore(today);

  DateTime _shiftedDay(int days) =>
      DateTime(state.date.year, state.date.month, state.date.day + days);

  Future<void> _load(DateTime date, Emitter<DiaryState> emit) async {
    emit(DiaryState.loading(date: date));
    final result = await _repo.getDay(date);
    switch (result) {
      case Success(:final data):
        emit(DiaryState.success(date: date, diary: data));
      case Failure(:final error):
        emit(DiaryState.failure(date: date, error: error));
    }
  }

  Future<void> _onNextDay(Emitter<DiaryState> emit) async {
    if (!canGoNext) return;
    await _load(_shiftedDay(1), emit);
  }

  Future<void> _onRefresh(
    _DiaryRefreshRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      final current = state.mapOrNull(success: (s) => s);
      // Показывать сейчас нечего — это обычная загрузка со спиннером.
      if (current == null) {
        await _load(state.date, emit);
        return;
      }

      emit(current.copyWith(isRefreshing: true, lastError: null));
      final result = await _repo.getDay(current.date);
      switch (result) {
        case Success(:final data):
          emit(DiaryState.success(date: current.date, diary: data));
        case Failure(:final error):
          // Данные дня остаются на экране, об ошибке сообщаем отдельно.
          emit(current.copyWith(isRefreshing: false, lastError: error));
      }
    } finally {
      // Завершаем и при отмене новым событием, иначе RefreshIndicator зависнет.
      final completer = event.completer;
      if (completer != null && !completer.isCompleted) completer.complete();
    }
  }
}
