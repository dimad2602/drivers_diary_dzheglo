import 'package:driver_diary/domain/models/offset_date_time.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_draft.freezed.dart';

/// Поездка, которую водитель вводит в форме: всё, кроме `id`.
/// Идентификатор присваивается при отправке (см. `AddTripBloc`).
@freezed
abstract class TripDraft with _$TripDraft {
  const factory TripDraft({
    required OffsetDateTime start,
    required OffsetDateTime end,
    required int amount,
    required PaymentMethod payment,
    required int commission,
  }) = _TripDraft;

  const TripDraft._();

  Trip toTrip(String id) => Trip(
    id: id,
    start: start,
    end: end,
    amount: amount,
    payment: payment,
    commission: commission,
  );
}
