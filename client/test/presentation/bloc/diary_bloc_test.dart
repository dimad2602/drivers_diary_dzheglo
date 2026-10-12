import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/domain/repositories/i_trips_repo.dart';
import 'package:driver_diary/presentation/bloc/diary/diary_bloc.dart';
import 'package:driver_diary/shared/models/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';

class _MockTripsRepo extends Mock implements ITripsRepo {}

void main() {
  final today = DateTime(2026, 10, 12);
  final yesterday = DateTime(2026, 10, 11);
  final diary = makeDiary();
  const emptyDiary = DayDiary(summary: emptySummary, trips: []);

  late _MockTripsRepo repo;

  DiaryBloc createBloc() =>
      DiaryBloc(repo, clock: () => DateTime(2026, 10, 12, 15, 30));

  void stubDay(DateTime date, Result<DayDiary, TripsError> result) {
    when(() => repo.getDay(date)).thenAnswer((_) async => result);
  }

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    repo = _MockTripsRepo();
    stubDay(today, Success(diary));
  });

  test('начальное состояние — загрузка сегодняшнего дня', () {
    final bloc = createBloc();

    expect(bloc.state, DiaryState.loading(date: today));
    expect(bloc.today, today);
    expect(bloc.canGoNext, isFalse);
  });

  group('started / reloadRequested', () {
    blocTest<DiaryBloc, DiaryState>(
      'успех: загрузка → данные дня',
      build: createBloc,
      act: (bloc) => bloc.add(const DiaryEvent.started()),
      expect: () => [
        DiaryState.loading(date: today),
        DiaryState.success(date: today, diary: diary),
      ],
    );

    blocTest<DiaryBloc, DiaryState>(
      'ошибка: загрузка → тип ошибки без данных',
      setUp: () => stubDay(today, const Failure(TripsError.noConnection)),
      build: createBloc,
      act: (bloc) => bloc.add(const DiaryEvent.started()),
      expect: () => [
        DiaryState.loading(date: today),
        DiaryState.failure(date: today, error: TripsError.noConnection),
      ],
    );

    blocTest<DiaryBloc, DiaryState>(
      'reloadRequested после ошибки снова показывает загрузку и данные',
      build: createBloc,
      seed: () => DiaryState.failure(date: today, error: TripsError.server),
      act: (bloc) => bloc.add(const DiaryEvent.reloadRequested()),
      expect: () => [
        DiaryState.loading(date: today),
        DiaryState.success(date: today, diary: diary),
      ],
    );
  });

  group('смена дня', () {
    blocTest<DiaryBloc, DiaryState>(
      'dateSelected: загрузка и данные выбранного дня',
      setUp: () => stubDay(yesterday, const Success(emptyDiary)),
      build: createBloc,
      act: (bloc) => bloc.add(DiaryEvent.dateSelected(yesterday)),
      expect: () => [
        DiaryState.loading(date: yesterday),
        DiaryState.success(date: yesterday, diary: emptyDiary),
      ],
    );

    blocTest<DiaryBloc, DiaryState>(
      'dateSelected отбрасывает время суток',
      setUp: () => stubDay(yesterday, const Success(emptyDiary)),
      build: createBloc,
      act: (bloc) =>
          bloc.add(DiaryEvent.dateSelected(DateTime(2026, 10, 11, 23, 59))),
      verify: (_) => verify(() => repo.getDay(yesterday)).called(1),
    );

    blocTest<DiaryBloc, DiaryState>(
      'previousDayRequested переходит на вчера',
      setUp: () => stubDay(yesterday, const Success(emptyDiary)),
      build: createBloc,
      act: (bloc) => bloc.add(const DiaryEvent.previousDayRequested()),
      verify: (bloc) => expect(bloc.state.date, yesterday),
    );

    blocTest<DiaryBloc, DiaryState>(
      'previousDayRequested на границе месяца уходит в прошлый месяц',
      setUp: () => stubDay(DateTime(2026, 9, 30), const Success(emptyDiary)),
      build: createBloc,
      seed: () => DiaryState.loading(date: DateTime(2026, 10, 1)),
      act: (bloc) => bloc.add(const DiaryEvent.previousDayRequested()),
      verify: (bloc) => expect(bloc.state.date, DateTime(2026, 9, 30)),
    );

    blocTest<DiaryBloc, DiaryState>(
      'nextDayRequested со вчера переходит на сегодня',
      build: createBloc,
      seed: () => DiaryState.loading(date: yesterday),
      act: (bloc) => bloc.add(const DiaryEvent.nextDayRequested()),
      verify: (bloc) => expect(bloc.state.date, today),
    );

    blocTest<DiaryBloc, DiaryState>(
      'nextDayRequested на сегодняшнем дне ничего не делает',
      build: createBloc,
      act: (bloc) => bloc.add(const DiaryEvent.nextDayRequested()),
      expect: () => <DiaryState>[],
      verify: (_) => verifyNever(() => repo.getDay(any())),
    );

    test('canGoNext: можно со вчера, нельзя с сегодня', () {
      final bloc = createBloc();

      expect(bloc.canGoNext, isFalse);
      // ignore: invalid_use_of_protected_member
      bloc.emit(DiaryState.loading(date: yesterday));
      expect(bloc.canGoNext, isTrue);
    });

    blocTest<DiaryBloc, DiaryState>(
      'todayRequested возвращает на сегодня',
      build: createBloc,
      seed: () => DiaryState.loading(date: DateTime(2026, 9, 1)),
      act: (bloc) => bloc.add(const DiaryEvent.todayRequested()),
      verify: (bloc) => expect(bloc.state.date, today),
    );
  });

  group('конкурентность (restartable)', () {
    test('ответ на устаревший запрос не затирает выбранный день', () async {
      final slow = Completer<Result<DayDiary, TripsError>>();
      when(() => repo.getDay(today)).thenAnswer((_) => slow.future);
      stubDay(yesterday, const Success(emptyDiary));
      final bloc = createBloc();
      final states = <DiaryState>[];
      bloc.stream.listen(states.add);

      bloc.add(const DiaryEvent.started()); // медленный запрос за сегодня
      await pumpEventQueue();
      bloc.add(
        DiaryEvent.dateSelected(yesterday),
      ); // пользователь ушёл на вчера
      await pumpEventQueue();
      slow.complete(Success(diary)); // сегодняшний ответ приходит позже
      await pumpEventQueue();

      expect(states, [
        DiaryState.loading(date: today),
        DiaryState.loading(date: yesterday),
        DiaryState.success(date: yesterday, diary: emptyDiary),
      ]);
      await bloc.close();
    });

    test(
      'быстрые нажатия «назад» дают итоговый день, а не промежуточные',
      () async {
        final slow = Completer<Result<DayDiary, TripsError>>();
        when(() => repo.getDay(yesterday)).thenAnswer((_) => slow.future);
        stubDay(DateTime(2026, 10, 10), const Success(emptyDiary));
        final bloc = createBloc();

        bloc.add(const DiaryEvent.previousDayRequested());
        await pumpEventQueue();
        bloc.add(const DiaryEvent.previousDayRequested());
        await pumpEventQueue();
        slow.complete(Success(diary));
        await pumpEventQueue();

        expect(
          bloc.state,
          DiaryState.success(date: DateTime(2026, 10, 10), diary: emptyDiary),
        );
        await bloc.close();
      },
    );

    test('ответ после закрытия Bloc игнорируется', () async {
      final slow = Completer<Result<DayDiary, TripsError>>();
      when(() => repo.getDay(today)).thenAnswer((_) => slow.future);
      final bloc = createBloc();

      bloc.add(const DiaryEvent.started());
      await pumpEventQueue();
      await bloc.close();
      slow.complete(Success(diary));

      await expectLater(pumpEventQueue(), completes);
    });
  });

  group('refreshRequested', () {
    final loaded = DiaryState.success(date: today, diary: emptyDiary);

    blocTest<DiaryBloc, DiaryState>(
      'не сбрасывает экран: данные заменяются без состояния загрузки',
      build: createBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const DiaryEvent.refreshRequested()),
      expect: () => [
        DiaryState.success(date: today, diary: emptyDiary, isRefreshing: true),
        DiaryState.success(date: today, diary: diary),
      ],
    );

    blocTest<DiaryBloc, DiaryState>(
      'при ошибке оставляет прежние данные и кладёт ошибку в lastError',
      setUp: () => stubDay(today, const Failure(TripsError.server)),
      build: createBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const DiaryEvent.refreshRequested()),
      expect: () => [
        DiaryState.success(date: today, diary: emptyDiary, isRefreshing: true),
        DiaryState.success(
          date: today,
          diary: emptyDiary,
          lastError: TripsError.server,
        ),
      ],
    );

    blocTest<DiaryBloc, DiaryState>(
      'повторная ошибка снова порождает состояние с lastError',
      setUp: () => stubDay(today, const Failure(TripsError.noConnection)),
      build: createBloc,
      seed: () => loaded,
      act: (bloc) async {
        bloc.add(const DiaryEvent.refreshRequested());
        await pumpEventQueue();
        bloc.add(const DiaryEvent.refreshRequested());
      },
      expect: () => [
        DiaryState.success(date: today, diary: emptyDiary, isRefreshing: true),
        DiaryState.success(
          date: today,
          diary: emptyDiary,
          lastError: TripsError.noConnection,
        ),
        // Между ошибками lastError сбрасывается — слушатель увидит новую ошибку.
        DiaryState.success(date: today, diary: emptyDiary, isRefreshing: true),
        DiaryState.success(
          date: today,
          diary: emptyDiary,
          lastError: TripsError.noConnection,
        ),
      ],
    );

    blocTest<DiaryBloc, DiaryState>(
      'без данных на экране работает как обычная загрузка',
      build: createBloc,
      seed: () => DiaryState.failure(date: today, error: TripsError.server),
      act: (bloc) => bloc.add(const DiaryEvent.refreshRequested()),
      expect: () => [
        DiaryState.loading(date: today),
        DiaryState.success(date: today, diary: diary),
      ],
    );

    test('completer завершается после успеха и после ошибки', () async {
      final bloc = createBloc();
      // ignore: invalid_use_of_protected_member
      bloc.emit(DiaryState.success(date: today, diary: emptyDiary));

      final ok = Completer<void>();
      bloc.add(DiaryEvent.refreshRequested(completer: ok));
      await ok.future.timeout(const Duration(seconds: 1));

      stubDay(today, const Failure(TripsError.server));
      final failed = Completer<void>();
      bloc.add(DiaryEvent.refreshRequested(completer: failed));
      await failed.future.timeout(const Duration(seconds: 1));

      await bloc.close();
    });

    test(
      'completer завершается, даже если обновление отменено сменой дня',
      () async {
        final slow = Completer<Result<DayDiary, TripsError>>();
        when(() => repo.getDay(today)).thenAnswer((_) => slow.future);
        stubDay(yesterday, const Success(emptyDiary));
        final bloc = createBloc();
        // ignore: invalid_use_of_protected_member
        bloc.emit(DiaryState.success(date: today, diary: emptyDiary));

        final completer = Completer<void>();
        bloc.add(DiaryEvent.refreshRequested(completer: completer));
        await pumpEventQueue();
        bloc.add(DiaryEvent.dateSelected(yesterday));
        await pumpEventQueue();
        slow.complete(Success(diary)); // отменённый запрос всё же возвращается
        await completer.future.timeout(const Duration(seconds: 1));

        expect(
          bloc.state,
          DiaryState.success(date: yesterday, diary: emptyDiary),
        );
        await bloc.close();
      },
    );
  });
}
