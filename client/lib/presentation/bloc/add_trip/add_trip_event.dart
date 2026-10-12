part of 'add_trip_bloc.dart';

@freezed
sealed class AddTripEvent with _$AddTripEvent {
  const factory AddTripEvent.submitted(TripDraft draft) = _AddTripSubmitted;
}
