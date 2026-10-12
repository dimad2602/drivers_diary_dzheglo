import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/domain/repositories/i_trips_repo.dart';
import 'package:driver_diary/presentation/bloc/add_trip/add_trip_bloc.dart';
import 'package:driver_diary/shared/models/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';

class _MockTripsRepo extends Mock implements ITripsRepo {}

void main() {
  final draft = makeDraft();
  late _MockTripsRepo repo;
  late int idCounter;

  AddTripBloc createBloc() =>
      AddTripBloc(repo, idGenerator: () => 'id-${++idCounter}');

  /// Репозиторий «сохраняет» поездку и возвращает её же.
  void stubSuccess() {
    when(() => repo.addTrip(any())).thenAnswer(
      (invocation) async =>
          Success(invocation.positionalArguments.first as Trip),
    );
  }

  setUpAll(() => registerFallbackValue(makeTrip()));

  setUp(() {
    repo = _MockTripsRepo();
    idCounter = 0;
    stubSuccess();
  });

  test('начальное состояние — initial', () {
    expect(createBloc().state, const AddTripState.initial());
  });

  blocTest<AddTripBloc, AddTripState>(
    'успех: отправка → поездка с присвоенным id',
    build: createBloc,
    act: (bloc) => bloc.add(AddTripEvent.submitted(draft)),
    expect: () => [
      const AddTripState.submitting(),
      AddTripState.success(draft.toTrip('id-1')),
    ],
    verify: (_) => verify(() => repo.addTrip(draft.toTrip('id-1'))).called(1),
  );

  blocTest<AddTripBloc, AddTripState>(
    'ошибка: отправка → тип ошибки',
    setUp: () =>
        when(() => repo.addTrip(any()))
            .thenAnswer((_) async => const Failure(TripsError.noConnection)),
    build: createBloc,
    act: (bloc) => bloc.add(AddTripEvent.submitted(draft)),
    expect: () => [
      const AddTripState.submitting(),
      const AddTripState.failure(TripsError.noConnection),
    ],
  );

  group('защита от дублей', () {
    test('повтор тех же данных после сбоя уходит с тем же id', () async {
      when(() => repo.addTrip(any()))
          .thenAnswer((_) async => const Failure(TripsError.noConnection));
      final bloc = createBloc();

      bloc.add(AddTripEvent.submitted(draft));
      await bloc.stream.firstWhere(
        (s) => s.mapOrNull(failure: (_) => true) == true,
      );
      stubSuccess();
      bloc.add(AddTripEvent.submitted(draft));
      await bloc.stream.firstWhere(
        (s) => s.mapOrNull(success: (_) => true) == true,
      );

      final sent = verify(() => repo.addTrip(captureAny())).captured
          .cast<Trip>();
      expect(sent.map((t) => t.id), ['id-1', 'id-1']);
      expect(idCounter, 1);
      await bloc.close();
    });

    test('изменённые данные после сбоя получают новый id', () async {
      when(() => repo.addTrip(any()))
          .thenAnswer((_) async => const Failure(TripsError.server));
      final bloc = createBloc();

      bloc.add(AddTripEvent.submitted(draft));
      await bloc.stream.firstWhere(
        (s) => s.mapOrNull(failure: (_) => true) == true,
      );
      stubSuccess();
      bloc.add(AddTripEvent.submitted(makeDraft(amount: 2500)));
      await bloc.stream.firstWhere(
        (s) => s.mapOrNull(success: (_) => true) == true,
      );

      final sent = verify(() => repo.addTrip(captureAny())).captured
          .cast<Trip>();
      expect(sent.map((t) => t.id), ['id-1', 'id-2']);
      await bloc.close();
    });

    test('после успеха та же форма — это уже новая поездка', () async {
      final bloc = createBloc();

      bloc.add(AddTripEvent.submitted(draft));
      await bloc.stream.firstWhere(
        (s) => s.mapOrNull(success: (_) => true) == true,
      );
      bloc.add(AddTripEvent.submitted(draft));
      await bloc.stream.firstWhere(
        (s) => s.mapOrNull(submitting: (_) => true) == true,
      );
      await pumpEventQueue();

      final sent = verify(() => repo.addTrip(captureAny())).captured
          .cast<Trip>();
      expect(sent.map((t) => t.id), ['id-1', 'id-2']);
      await bloc.close();
    });

    test(
      'двойное нажатие во время отправки игнорируется (droppable)',
      () async {
        final pending = Completer<Result<Trip, TripsError>>();
        when(() => repo.addTrip(any())).thenAnswer((_) => pending.future);
        final bloc = createBloc();

        bloc.add(AddTripEvent.submitted(draft));
        await pumpEventQueue();
        bloc.add(AddTripEvent.submitted(draft));
        bloc.add(AddTripEvent.submitted(draft));
        await pumpEventQueue();
        pending.complete(Success(draft.toTrip('id-1')));
        await pumpEventQueue();

        verify(() => repo.addTrip(any())).called(1);
        expect(idCounter, 1);
        expect(bloc.state, AddTripState.success(draft.toTrip('id-1')));
        await bloc.close();
      },
    );
  });
}
