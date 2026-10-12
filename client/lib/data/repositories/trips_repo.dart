import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart' as chopper;
import 'package:driver_diary/data/mappers/api_date.dart';
import 'package:driver_diary/data/mappers/summary_mapper.dart';
import 'package:driver_diary/data/mappers/trip_mapper.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/domain/repositories/i_trips_repo.dart';
import 'package:driver_diary/shared/models/result.dart';
import 'package:driver_diary/swagger_generated_code/driver_diary.swagger.dart'
    as sw;
import 'package:http/http.dart' as http;

class TripsRepo implements ITripsRepo {
  TripsRepo(this._api, {this.timeout = const Duration(seconds: 10)});

  final sw.DriverDiary _api;
  final Duration timeout;

  @override
  Future<Result<DayDiary, TripsError>> getDay(DateTime date) async {
    final day = formatApiDate(date);
    // Оба запроса идут параллельно; _call не бросает, поэтому wait безопасен.
    final (tripsResult, summaryResult) = await (
      _call(() => _api.listTrips(date: day)),
      _call(() => _api.getDaySummary(date: day)),
    ).wait;

    return switch ((tripsResult, summaryResult)) {
      (Success(data: final trips), Success(data: final summary)) => _map(
        () => DayDiary(
          summary: summary.toDomain(),
          trips: trips.map((t) => t.toDomain()).toList(),
        ),
      ),
      (Failure(:final error), _) => Failure(error),
      (_, Failure(:final error)) => Failure(error),
    };
  }

  @override
  Future<Result<Trip, TripsError>> addTrip(Trip trip) async {
    final result = await _call(() => _api.createTrip(body: trip.toCreateDto()));
    return switch (result) {
      Success(:final data) => _map(data.toDomain),
      Failure(:final error) => Failure(error),
    };
  }

  /// Выполняет запрос и превращает любой исход в [Result], не бросая исключений.
  Future<Result<T, TripsError>> _call<T extends Object>(
    Future<chopper.Response<T>> Function() request,
  ) async {
    try {
      final response = await request().timeout(timeout);
      final body = response.body;
      if (response.isSuccessful && body != null) return Success(body);
      return Failure(_errorForStatus(response.statusCode));
    } on TimeoutException {
      return const Failure(TripsError.noConnection);
    } on SocketException {
      return const Failure(TripsError.noConnection);
    } on http.ClientException {
      return const Failure(TripsError.noConnection);
    } catch (_) {
      return const Failure(TripsError.unknown);
    }
  }

  /// Ответ, который не удалось разобрать (например, неожиданный формат), — это `unknown`.
  Result<T, TripsError> _map<T extends Object>(T Function() convert) {
    try {
      return Success(convert());
    } on FormatException {
      return const Failure(TripsError.unknown);
    }
  }

  TripsError _errorForStatus(int status) => switch (status) {
    409 => TripsError.conflict,
    422 => TripsError.validation,
    >= 500 => TripsError.server,
    _ => TripsError.unknown,
  };
}
