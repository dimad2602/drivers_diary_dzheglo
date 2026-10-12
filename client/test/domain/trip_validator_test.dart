import 'package:driver_diary/domain/validators/trip_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  test('корректная поездка не даёт ошибок', () {
    expect(TripValidator.validate(makeDraft()), isEmpty);
  });

  group('сумма', () {
    for (final amount in [0, -1, -2400]) {
      test('$amount — не больше нуля', () {
        final errors = TripValidator.validate(
          makeDraft(amount: amount, commission: 0),
        );

        expect(errors, contains(TripValidationError.amountNotPositive));
      });
    }

    test('1 — допустима', () {
      expect(
        TripValidator.validate(makeDraft(amount: 1, commission: 0)),
        isEmpty,
      );
    });
  });

  group('время', () {
    test('окончание раньше начала', () {
      final errors = TripValidator.validate(
        makeDraft(start: at(1, 9, 0), end: at(1, 8, 0)),
      );

      expect(errors, {TripValidationError.endNotAfterStart});
    });

    test('окончание совпадает с началом', () {
      final errors = TripValidator.validate(
        makeDraft(start: at(1, 9, 0), end: at(1, 9, 0)),
      );

      expect(errors, {TripValidationError.endNotAfterStart});
    });

    test('сравниваются моменты, а не часы на стене', () {
      // 09:00 по +05:00 — 04:00 UTC; 08:00 по +00:00 — на четыре часа позже.
      final errors = TripValidator.validate(
        makeDraft(
          start: at(1, 9, 0),
          end: at(1, 8, 0, offset: Duration.zero),
        ),
      );

      expect(errors, isEmpty);
    });
  });

  group('комиссия', () {
    test('отрицательная', () {
      final errors = TripValidator.validate(makeDraft(commission: -1));

      expect(errors, {TripValidationError.commissionNegative});
    });

    test('больше суммы', () {
      final errors = TripValidator.validate(
        makeDraft(amount: 1000, commission: 1001),
      );

      expect(errors, {TripValidationError.commissionExceedsAmount});
    });

    test('равна сумме — допустима', () {
      expect(
        TripValidator.validate(makeDraft(amount: 1000, commission: 1000)),
        isEmpty,
      );
    });
  });

  test('несколько нарушений возвращаются вместе', () {
    final errors = TripValidator.validate(
      makeDraft(
        amount: 0,
        commission: 10,
        start: at(1, 9, 0),
        end: at(1, 9, 0),
      ),
    );

    expect(errors, {
      TripValidationError.amountNotPositive,
      TripValidationError.endNotAfterStart,
      TripValidationError.commissionExceedsAmount,
    });
  });
}
