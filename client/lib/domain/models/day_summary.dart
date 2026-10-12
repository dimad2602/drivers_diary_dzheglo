import 'package:driver_diary/domain/models/payment_breakdown.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_summary.freezed.dart';

/// Сводка за день, посчитанная сервером.
@freezed
abstract class DaySummary with _$DaySummary {
  const factory DaySummary({
    required int tripsCount,
    required int revenue,
    required int commission,
    required int net,
    required PaymentBreakdown cash,
    required PaymentBreakdown card,
  }) = _DaySummary;

  const DaySummary._();

  bool get isEmpty => tripsCount == 0;
}
