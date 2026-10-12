import 'package:driver_diary/data/mappers/api_date.dart';
import 'package:driver_diary/data/mappers/summary_mapper.dart';
import 'package:driver_diary/data/mappers/trip_mapper.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/swagger_generated_code/driver_diary.swagger.dart'
    as sw;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

sw.Trip _dto({
  String start = '2026-10-01T08:10:00+05:00',
  String end = '2026-10-01T08:32:00+05:00',
  sw.PaymentMethod payment = sw.PaymentMethod.card,
}) => sw.Trip(
  id: 't1',
  start: start,
  end: end,
  amount: 2400,
  payment: payment,
  commission: 360,
);

void main() {
  group('Trip', () {
    test('DTO → доменная модель сохраняет смещение и поля', () {
      final trip = _dto().toDomain();

      expect(trip.id, 't1');
      expect(trip.start.offset, const Duration(hours: 5));
      expect(trip.start.wallClock.hour, 8);
      expect(trip.end.wallClock.minute, 32);
      expect(trip.amount, 2400);
      expect(trip.commission, 360);
      expect(trip.payment, PaymentMethod.card);
    });

    test('время без смещения — ошибка формата', () {
      expect(
        () => _dto(start: '2026-10-01T08:10:00').toDomain(),
        throwsFormatException,
      );
    });

    test('неизвестный способ оплаты — ошибка формата', () {
      expect(
        () =>
            _dto(payment: sw.PaymentMethod.swaggerGeneratedUnknown).toDomain(),
        throwsFormatException,
      );
    });

    test('доменная модель → DTO отправляет время со смещением', () {
      final dto = makeTrip(payment: PaymentMethod.cash).toCreateDto();

      expect(dto.start, '2026-10-01T08:10:00+05:00');
      expect(dto.end, '2026-10-01T08:32:00+05:00');
      expect(dto.payment, sw.PaymentMethod.cash);
      expect(dto.toJson()['payment'], 'cash');
    });

    test('туда и обратно получается та же поездка', () {
      final trip = makeTrip(payment: PaymentMethod.cash);

      final dto = trip.toCreateDto();
      final back = sw.Trip.fromJson(dto.toJson()).toDomain();

      expect(back, trip);
    });
  });

  test('сводка из DTO раскладывается по способам оплаты', () {
    final dto = sw.DaySummary(
      date: DateTime(2026, 10, 1),
      tripsCount: 2,
      revenue: 3900,
      commission: 585,
      net: 3315,
      byPayment: const sw.ByPayment(
        cash: sw.PaymentBreakdown(
          tripsCount: 1,
          revenue: 1500,
          commission: 225,
          net: 1275,
        ),
        card: sw.PaymentBreakdown(
          tripsCount: 1,
          revenue: 2400,
          commission: 360,
          net: 2040,
        ),
      ),
    );

    expect(dto.toDomain(), exampleSummary);
  });

  group('formatApiDate', () {
    test('форматирует YYYY-MM-DD с ведущими нулями', () {
      expect(formatApiDate(DateTime(2026, 3, 7)), '2026-03-07');
      expect(formatApiDate(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('время суток игнорируется', () {
      expect(formatApiDate(DateTime(2026, 10, 1, 23, 59)), '2026-10-01');
    });
  });
}
