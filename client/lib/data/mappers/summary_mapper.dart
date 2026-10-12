import 'package:driver_diary/domain/models/day_summary.dart';
import 'package:driver_diary/domain/models/payment_breakdown.dart';
import 'package:driver_diary/swagger_generated_code/driver_diary.swagger.dart'
    as sw;

extension PaymentBreakdownDtoMapper on sw.PaymentBreakdown {
  PaymentBreakdown toDomain() => PaymentBreakdown(
    tripsCount: tripsCount,
    revenue: revenue,
    commission: commission,
    net: net,
  );
}

extension DaySummaryDtoMapper on sw.DaySummary {
  DaySummary toDomain() => DaySummary(
    tripsCount: tripsCount,
    revenue: revenue,
    commission: commission,
    net: net,
    cash: byPayment.cash.toDomain(),
    card: byPayment.card.toDomain(),
  );
}
