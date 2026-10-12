import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/shared/models/result.dart';

abstract class ITripsRepo {
  /// Сводка и поездки за день [date] (учитывается только дата).
  Future<Result<DayDiary, TripsError>> getDay(DateTime date);

  /// Идемпотентно добавляет поездку: повтор того же [trip] вернёт сохранённую поездку.
  Future<Result<Trip, TripsError>> addTrip(Trip trip);
}
