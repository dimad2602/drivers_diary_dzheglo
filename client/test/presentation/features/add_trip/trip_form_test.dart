import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/presentation/features/add_trip/trip_form.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final date = DateTime(2026, 10, 1);

  TripFormInput input({
    String start = '08:10',
    String end = '08:32',
    String amount = '2400',
    String commission = '360',
    PaymentMethod payment = PaymentMethod.card,
  }) => TripFormInput(
    date: date,
    start: start,
    end: end,
    amount: amount,
    commission: commission,
    payment: payment,
  );

  group('validateTripForm: корректный ввод', () {
    test('даёт готовый черновик без ошибок', () {
      final result = validateTripForm(input(payment: PaymentMethod.cash));

      expect(result.errors, isEmpty);
      final draft = result.draft!;
      expect(draft.amount, 2400);
      expect(draft.commission, 360);
      expect(draft.payment, PaymentMethod.cash);
      expect(draft.start.wallClock.hour, 8);
      expect(draft.start.wallClock.minute, 10);
      expect(draft.end.wallClock.minute, 32);
      expect(draft.start.wallDate, date);
    });

    test('пробелы вокруг чисел игнорируются', () {
      final result = validateTripForm(
        input(amount: ' 100 ', commission: ' 15 '),
      );

      expect(result.draft!.amount, 100);
      expect(result.draft!.commission, 15);
    });

    test('час из одной цифры допустим: 8:10', () {
      final result = validateTripForm(input(start: '8:10', end: '8:30'));

      expect(result.draft!.start.wallClock.hour, 8);
    });

    test('комиссия, равная сумме, допустима', () {
      final result = validateTripForm(input(amount: '500', commission: '500'));

      expect(result.draft, isNotNull);
    });
  });

  group('обязательные поля', () {
    test('пустая форма: четыре ошибки «обязательно», черновика нет', () {
      final result = validateTripForm(
        input(start: '', end: '', amount: '', commission: ''),
      );

      expect(result.draft, isNull);
      expect(result.errors, {
        TripFormField.start: TripFormError.required,
        TripFormField.end: TripFormError.required,
        TripFormField.amount: TripFormError.required,
        TripFormField.commission: TripFormError.required,
      });
    });

    test('строка из пробелов — тоже пусто', () {
      final result = validateTripForm(input(amount: '   ', start: '  '));

      expect(result.errors[TripFormField.amount], TripFormError.required);
      expect(result.errors[TripFormField.start], TripFormError.required);
    });

    test('не число — «некорректно»', () {
      final result = validateTripForm(input(amount: '12a'));

      expect(result.errors, {TripFormField.amount: TripFormError.invalid});
    });

    for (final bad in ['2400.50', '2400,50', '1e5', '٣٠٠']) {
      test('сумма «$bad» не принимается как число', () {
        final result = validateTripForm(input(amount: bad, commission: '10'));

        expect(result.draft, isNull);
        expect(result.errors[TripFormField.amount], TripFormError.invalid);
      });
    }
  });

  group('некорректное время', () {
    for (final bad in [
      '25:00',
      '12:60',
      '9:5',
      '0830',
      'ab:cd',
      '08.30',
      '08:3',
    ]) {
      test('«$bad» — не время', () {
        final result = validateTripForm(input(start: bad));

        expect(result.draft, isNull);
        expect(result.errors, {TripFormField.start: TripFormError.invalidTime});
      });
    }

    test('ошибки времени и сумм показываются вместе', () {
      final result = validateTripForm(
        input(start: '25:00', end: '', amount: 'x', commission: '1'),
      );

      expect(result.errors, {
        TripFormField.start: TripFormError.invalidTime,
        TripFormField.end: TripFormError.required,
        TripFormField.amount: TripFormError.invalid,
      });
    });
  });

  group('правила сервера', () {
    test('сумма ноль', () {
      final result = validateTripForm(input(amount: '0', commission: '0'));

      expect(result.errors, {
        TripFormField.amount: TripFormError.amountNotPositive,
      });
    });

    test('окончание совпадает с началом', () {
      final result = validateTripForm(input(start: '09:00', end: '09:00'));

      expect(result.errors, {
        TripFormField.end: TripFormError.endNotAfterStart,
      });
    });

    test('комиссия больше суммы', () {
      final result = validateTripForm(
        input(amount: '1000', commission: '1001'),
      );

      expect(result.errors, {
        TripFormField.commission: TripFormError.commissionExceedsAmount,
      });
    });

    test('отрицательная комиссия — «некорректно»', () {
      final result = validateTripForm(input(commission: '-5'));

      expect(result.errors, {TripFormField.commission: TripFormError.invalid});
    });

    test('несколько ошибок показываются сразу', () {
      final result = validateTripForm(
        input(start: '09:00', end: '09:00', amount: '0', commission: '10'),
      );

      expect(result.errors.keys, {
        TripFormField.amount,
        TripFormField.end,
        TripFormField.commission,
      });
    });
  });

  group('поездка через полночь', () {
    test('23:00 → 00:30 заканчивается на следующий день', () {
      final result = validateTripForm(input(start: '23:00', end: '00:30'));

      final draft = result.draft!;
      expect(result.errors, isEmpty);
      expect(draft.start.wallDate, date);
      expect(draft.end.wallDate, DateTime(2026, 10, 2));
      expect(draft.end.wallClock.hour, 0);
      expect(draft.end.wallClock.minute, 30);
      expect(
        draft.end.instant.difference(draft.start.instant),
        const Duration(minutes: 90),
      );
    });

    test('окончание раньше начала — это следующий день, а не ошибка', () {
      final result = validateTripForm(input(start: '09:00', end: '08:00'));

      expect(result.errors, isEmpty);
      expect(result.draft!.end.wallDate, DateTime(2026, 10, 2));
    });

    test('на границе месяца и года', () {
      TripFormInput nightTrip(DateTime day) => TripFormInput(
        date: day,
        start: '23:30',
        end: '00:10',
        amount: '1000',
        commission: '150',
      );

      expect(
        validateTripForm(nightTrip(DateTime(2026, 10, 31))).draft!.end.wallDate,
        DateTime(2026, 11, 1),
      );
      expect(
        validateTripForm(nightTrip(DateTime(2026, 12, 31))).draft!.end.wallDate,
        DateTime(2027, 1, 1),
      );
    });

    test('endsNextDay: сравнивает время на часах', () {
      const nine = TimeOfDay(hour: 9, minute: 0);

      expect(
        endsNextDay(
          const TimeOfDay(hour: 23, minute: 0),
          const TimeOfDay(hour: 0, minute: 30),
        ),
        isTrue,
      );
      expect(
        endsNextDay(
          const TimeOfDay(hour: 23, minute: 59),
          const TimeOfDay(hour: 0, minute: 0),
        ),
        isTrue,
      );
      expect(endsNextDay(nine, const TimeOfDay(hour: 9, minute: 30)), isFalse);
      expect(endsNextDay(nine, nine), isFalse);
    });
  });

  group('время ещё не заполнено', () {
    test('ошибки сумм видны, но «окончание позже начала» не выдумывается', () {
      final result = validateTripForm(
        input(start: '23:59', end: '', amount: '0', commission: '0'),
      );

      expect(result.errors, {
        TripFormField.end: TripFormError.required,
        TripFormField.amount: TripFormError.amountNotPositive,
      });
    });

    test('суммы корректны — остаются только «заполните время»', () {
      final result = validateTripForm(input(start: '', end: ''));

      expect(result.errors, {
        TripFormField.start: TripFormError.required,
        TripFormField.end: TripFormError.required,
      });
    });
  });

  group('suggestCommission', () {
    test('15% от суммы', () {
      expect(suggestCommission('2400'), 360);
      expect(suggestCommission('1500'), 225);
    });

    test('округляет до целого', () {
      expect(suggestCommission('10'), 2); // 1.5 → 2
      expect(suggestCommission('3'), 0); // 0.45 → 0
    });

    test('без суммы или с нулём подсказки нет', () {
      expect(suggestCommission(''), isNull);
      expect(suggestCommission('0'), isNull);
      expect(suggestCommission('abc'), isNull);
    });

    test('пробелы игнорируются', () {
      expect(suggestCommission(' 1000 '), 150);
    });
  });
}
