import 'package:driver_diary/domain/models/offset_date_time.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/swagger_generated_code/driver_diary.swagger.dart'
    as sw;

extension TripDtoMapper on sw.Trip {
  /// Бросает [FormatException], если сервер прислал время без пояса или неизвестный способ оплаты.
  Trip toDomain() => Trip(
    id: id,
    start: OffsetDateTime.parse(start),
    end: OffsetDateTime.parse(end),
    amount: amount,
    payment: _paymentFromDto(payment),
    commission: commission,
  );
}

extension TripToDtoMapper on Trip {
  sw.TripCreate toCreateDto() => sw.TripCreate(
    id: id,
    start: start.toIso8601(),
    end: end.toIso8601(),
    amount: amount,
    payment: _paymentToDto(payment),
    commission: commission,
  );
}

PaymentMethod _paymentFromDto(sw.PaymentMethod dto) => switch (dto) {
  sw.PaymentMethod.cash => PaymentMethod.cash,
  sw.PaymentMethod.card => PaymentMethod.card,
  sw.PaymentMethod.swaggerGeneratedUnknown => throw const FormatException(
    'Неизвестный способ оплаты',
  ),
};

sw.PaymentMethod _paymentToDto(PaymentMethod method) => switch (method) {
  PaymentMethod.cash => sw.PaymentMethod.cash,
  PaymentMethod.card => sw.PaymentMethod.card,
};
