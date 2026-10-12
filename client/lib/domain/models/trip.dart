import 'package:driver_diary/domain/models/offset_date_time.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';

/// Поездка. Та же модель используется и для создания: `id` задаёт клиент
/// и он же защищает от дублей при повторной отправке.
@freezed
abstract class Trip with _$Trip {
  const factory Trip({
    required String id,
    required OffsetDateTime start,
    required OffsetDateTime end,
    required int amount,
    required PaymentMethod payment,
    required int commission,
  }) = _Trip;

  const Trip._();

  Duration get duration => end.instant.difference(start.instant);

  /// На руки: сумма минус комиссия.
  int get net => amount - commission;
}
