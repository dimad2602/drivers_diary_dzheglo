part of 'add_trip_bloc.dart';

@freezed
sealed class AddTripState with _$AddTripState {
  const factory AddTripState.initial() = _AddTripInitial;
  const factory AddTripState.submitting() = _AddTripSubmitting;
  const factory AddTripState.success(Trip trip) = _AddTripSuccess;
  const factory AddTripState.failure(TripsError error) = _AddTripFailure;
}
