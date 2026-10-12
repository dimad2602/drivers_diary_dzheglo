import 'package:driver_diary/domain/models/trip.dart';

enum TripValidationError {
  amountNotPositive,
  endNotAfterStart,
  commissionNegative,
  commissionExceedsAmount,
}

/// Те же правила, что на сервере: ошибки видны до отправки запроса.
abstract final class TripValidator {
  static Set<TripValidationError> validate(Trip trip) {
    return {
      if (trip.amount <= 0) TripValidationError.amountNotPositive,
      if (!trip.end.instant.isAfter(trip.start.instant))
        TripValidationError.endNotAfterStart,
      if (trip.commission < 0) TripValidationError.commissionNegative,
      if (trip.commission > trip.amount)
        TripValidationError.commissionExceedsAmount,
    };
  }
}
