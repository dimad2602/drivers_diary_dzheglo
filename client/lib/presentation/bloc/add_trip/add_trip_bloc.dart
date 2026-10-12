import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/domain/models/trip_draft.dart';
import 'package:driver_diary/domain/repositories/i_trips_repo.dart';
import 'package:driver_diary/shared/models/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'add_trip_event.dart';
part 'add_trip_state.dart';
part 'add_trip_bloc.freezed.dart';

class AddTripBloc extends Bloc<AddTripEvent, AddTripState> {
  final ITripsRepo _repo;
  final String Function() _newId;

  /// Последняя отправленная поездка. Если отправка не удалась (например, пропала связь,
  /// хотя сервер мог успеть сохранить поездку), повтор с теми же данными уходит с тем же
  /// `id` — сервер вернёт сохранённую поездку, а не создаст дубль.
  Trip? _lastAttempt;

  AddTripBloc(ITripsRepo repo, {String Function()? idGenerator})
    : _repo = repo,
      _newId = idGenerator ?? const Uuid().v4,
      super(const AddTripState.initial()) {
    on<AddTripEvent>(
      (event, emit) async {
        await event.map(submitted: (e) => _onSubmitted(e, emit));
      },
      // Пока предыдущая отправка не завершилась, повторные нажатия игнорируются.
      transformer: droppable(),
    );
  }

  Future<void> _onSubmitted(
    _AddTripSubmitted event,
    Emitter<AddTripState> emit,
  ) async {
    final trip = _tripFor(event.draft);
    emit(const AddTripState.submitting());
    final result = await _repo.addTrip(trip);
    switch (result) {
      case Success(:final data):
        _lastAttempt = null;
        emit(AddTripState.success(data));
      case Failure(:final error):
        emit(AddTripState.failure(error));
    }
  }

  /// Те же данные, что в прошлой попытке, — тот же `id`; изменились — новый `id`.
  Trip _tripFor(TripDraft draft) {
    final last = _lastAttempt;
    if (last != null && draft.toTrip(last.id) == last) return last;
    return _lastAttempt = draft.toTrip(_newId());
  }
}
