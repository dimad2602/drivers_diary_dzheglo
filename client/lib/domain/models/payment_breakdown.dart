import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_breakdown.freezed.dart';

/// Итоги по одному способу оплаты.
@freezed
abstract class PaymentBreakdown with _$PaymentBreakdown {
  const factory PaymentBreakdown({
    required int tripsCount,
    required int revenue,
    required int commission,
    required int net,
  }) = _PaymentBreakdown;
}
