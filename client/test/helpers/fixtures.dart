import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/domain/models/day_summary.dart';
import 'package:driver_diary/domain/models/offset_date_time.dart';
import 'package:driver_diary/domain/models/payment_breakdown.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/domain/models/trip_draft.dart';

const almaty = Duration(hours: 5);

OffsetDateTime at(int day, int hour, int minute, {Duration offset = almaty}) {
  final wall = DateTime.utc(2026, 10, day, hour, minute);
  return OffsetDateTime(instant: wall.subtract(offset), offset: offset);
}

Trip makeTrip({
  String id = 't1',
  OffsetDateTime? start,
  OffsetDateTime? end,
  int amount = 2400,
  PaymentMethod payment = PaymentMethod.card,
  int commission = 360,
}) {
  return Trip(
    id: id,
    start: start ?? at(1, 8, 10),
    end: end ?? at(1, 8, 32),
    amount: amount,
    payment: payment,
    commission: commission,
  );
}

TripDraft makeDraft({
  OffsetDateTime? start,
  OffsetDateTime? end,
  int amount = 2400,
  PaymentMethod payment = PaymentMethod.card,
  int commission = 360,
}) {
  return TripDraft(
    start: start ?? at(1, 8, 10),
    end: end ?? at(1, 8, 32),
    amount: amount,
    payment: payment,
    commission: commission,
  );
}

const emptyBreakdown = PaymentBreakdown(
  tripsCount: 0,
  revenue: 0,
  commission: 0,
  net: 0,
);

const exampleSummary = DaySummary(
  tripsCount: 2,
  revenue: 3900,
  commission: 585,
  net: 3315,
  cash: PaymentBreakdown(
    tripsCount: 1,
    revenue: 1500,
    commission: 225,
    net: 1275,
  ),
  card: PaymentBreakdown(
    tripsCount: 1,
    revenue: 2400,
    commission: 360,
    net: 2040,
  ),
);

const emptySummary = DaySummary(
  tripsCount: 0,
  revenue: 0,
  commission: 0,
  net: 0,
  cash: emptyBreakdown,
  card: emptyBreakdown,
);

DayDiary makeDiary() => DayDiary(
  summary: exampleSummary,
  trips: [
    makeTrip(),
    makeTrip(
      id: 't2',
      start: at(1, 9, 5),
      end: at(1, 9, 20),
      amount: 1500,
      payment: PaymentMethod.cash,
      commission: 225,
    ),
  ],
);
